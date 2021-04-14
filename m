Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EA335FD82
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhDNWBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:01:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhDNWBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:01:08 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13ELtt3x030973;
        Wed, 14 Apr 2021 15:00:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kFx9ONaOe80zKte+PrqrUPSlgacNVmEACgzjj0WgAgM=;
 b=pX3O1rTMbDj0OIfFRR/fVmI49rqGq7SQ9axXPfiv+CQaIl3V1R1UAIF7Uyv6wLqXgOVE
 NUPckRdn2vCa/lGGfeEOQjiHa5+Mgv4VaroHz5cglt7E798hQM0TVl4BZrVjrCT4A/9z
 +Y6bfffJh3JU0ABhFKmpEMLWFWZkyxaUDp0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37wv9qc5wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Apr 2021 15:00:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 15:00:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8h8YQ+gYNHZ6NHonhmkMhhrTlFUfZizlan95oYPKIolgiPD2rt3W5yzMHHb3cEXXPdaW3HnYaLKHTnelzsAZDRGCo//fMMEyvyzxwdrrEMszuJ60eBBRqK6hhVl7D6CsDVXOdyfgbZOzOp/r60AJueWGp99bMENKmRRhdAv5JE/ouiybvgbNC0H5odkM0xzXM/HqGGGKCdbpetoU7zJDMuLx2DhDezL6c9c6cMC0uFEhRiRCIZA530Xp5xwnNnioBgXolNvXm2iu3BLoYuRjGQdxM6k0jO0l6U8+ucVUXh+qRcN1wR7VFgG+2rEAQpDksH86i4U61R0RkzgGXwUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFx9ONaOe80zKte+PrqrUPSlgacNVmEACgzjj0WgAgM=;
 b=QPkOeCu/uRnF2tb4cYlL0Vzhg3/Yx8BdHVSvIAhnuhJdRbFhUEkjk6HtXBGpJ5JPN7CmfqscKH/cDxgG3VSiMLJCZTUikMXoYqnOo+l2l9mkx7irrXySh6MvxV4sSu1OmsbmcPxLVBrMaZLk5XWwpTaBv4HDyI5E9FMbOvOOr3290XnSQ5Uy6bOAZptHZ7mqtj2aYQNF3ewrsRfxLbf+7BtFIkwk6o8pBH969lZNoOspcAtY1Vzo+iouqSu6kcxFbP+zwPeohNfuc0mEZWiYhdCuAbvIDbbMLqOPc+E8SoYakLoliV/zWxdk6y80b9TKKBLCxO6Yk4g+wI3vCAj8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN6PR15MB1235.namprd15.prod.outlook.com (2603:10b6:404:ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 22:00:31 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.040; Wed, 14 Apr 2021
 22:00:31 +0000
Subject: Re: [PATCH bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210414200146.2663044-1-andrii@kernel.org>
 <20210414200146.2663044-13-andrii@kernel.org>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <f3f3bcc5-be1a-6d11-0c6e-081fc30367c4@fb.com>
Date:   Wed, 14 Apr 2021 15:00:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210414200146.2663044-13-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:62bb]
X-ClientProxiedBy: MWHPR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:301:2::33) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:62bb) by MWHPR12CA0047.namprd12.prod.outlook.com (2603:10b6:301:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21 via Frontend Transport; Wed, 14 Apr 2021 22:00:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dcc9dbf-e231-40ff-9962-08d8ff90b8bf
X-MS-TrafficTypeDiagnostic: BN6PR15MB1235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR15MB123525A46A4FAD05F0C596BAD74E9@BN6PR15MB1235.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSvcHWFKrhhfgsHihlIbb9dd80DrQaPKIVgS12r3Cs7ZBWrwGRobF55WyEe9i4s14+L0S1T91EDESQ9+/VKTT3gOi468cPw1QZkasC6jx3dMHtZy7f1XoWJT6r4R8+5y+nCUFWEc/Bl5UO9Bimk5aY8tOC40WqGsSJHyNO0YCFrxAXNlDq9z7s6TtySqYj2bDUY/e0C+IT4KzHglYH1FLOGwltMWp8yn3alF+FMyGYe2zXd6YEIKxD5WhB2CD98rHCjjr6yQcQQeRsdRu4dtJ9MezIAta3qAJs7VCBXAa+33igz6TiTQP0obIkjMErpJDCQHwpnJKZfMMfczsOrWcIwqL6/0DstZFoknaGCxl6T3T0a2rRN/1tlMLgB0kJAs2NKu3aZkaG8VMcF2mFECe/KRTjuqmv31wJkQp+l0kQsS4Lxxkr6/wam9JOxc8QkjEHuVsVh/uV9eDvzdcVl64CEXRLWt8lj6w5TRYrGtbxWuO/1ZeXOUhSagWSRGBFFABNfggwdhW/G9vVpJietqa8A37yuytRYVFmg4GRK9ebzC/JZd1Occ0+jFdIK/M+rlqTWmmuxp8230+5m+j13CrCsdZwX/lwh9G2zPQ1hyym9vqRLUjLsFkROv4Ayxz7prOcXx5kCQeqhOGC92R8aQsUzt9Z0TJxMn7xnrXA3LUK6QbgM5mynAU6/k6fjngpA1U+LOYBmbw61BbvZyfDeeUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(2616005)(66476007)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(53546011)(478600001)(31686004)(66946007)(2906002)(4326008)(16526019)(52116002)(31696002)(186003)(6486002)(5660300002)(86362001)(316002)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d0ZpenpKbytjMWhHMnpJa2ZsSGNGbjVhM0w1TDRtTEl4S2R1b0RKWnpHNlU5?=
 =?utf-8?B?Z2x0ai9ONzhNbmdDUHNPV205WEg1YWFvMzdmZDNDaDloK1FEc3l6allacFlz?=
 =?utf-8?B?a2FvSHA3dS9yaytvaXdjeWp5VVJFdnVSVFNnV0UyY0tkaDlaV2NMSU9YUUlP?=
 =?utf-8?B?TVlMSTYvQzRvbFJyWEdnby81TnJmcDZ3TFIrdmhCUEV5eWRGM1NRdldIaDdY?=
 =?utf-8?B?YmMxTVo1S3dQUnBKR0w3aHRXdXExM2J6MmN5bTJ6SVlQZkYrdml5eEE2eklT?=
 =?utf-8?B?WDgxMDM0UklPbEVscG1mSWdKNktmb3dMRGlCQ3NRV0RWbml3ZUhZOW9IbUlT?=
 =?utf-8?B?NlRwRnZua3Fyc1c0K3gwczNxTEZzb2JycktxMjk0VjJSdExaSWFNNjF1Wmg0?=
 =?utf-8?B?UXFLVGhaRkVvTENtMXF2N1NGZEI5S25yb2FPeG12TmZQRmQyUEduejUzOW1M?=
 =?utf-8?B?dDE2eVF0WW1QUDVXUzVoSU5IWFpTQkFXVlRtS1BWTU0yT2JIMkp3eGFkc3Yz?=
 =?utf-8?B?RGdIdXUxaVVSei85eEFaZkRteTNsSzBNWDJ4NDFjQVM3aDNva3pLUGFwUzhv?=
 =?utf-8?B?dHFSL0RLZXNvNVAwdk1maVo3VS9aSVlyaVRkNkhhWnlZMUgwRDdwSm1CREtY?=
 =?utf-8?B?dkJsTDFUQzhzeFZhdHFJa2dJdzFrSksrSWlPVmJiQjBudEZVR24zZnRML3hi?=
 =?utf-8?B?NlIyQVNsOXB6UkxWZVQ2Z1VVZWk0aXNmbFVERXRIWjZwY0FMZUIrNUxjM3FM?=
 =?utf-8?B?eWJ0T1J3b3lYVk94TWdMaDdVOXdRd1Z5M2hROHMramV6bkIrbERIZDFrdlQv?=
 =?utf-8?B?VWpUTmlidUNNeWtFbUlEZ0g2Z09XWUxuMTZWanh3blR2U2FtUDFTRHA4ZURu?=
 =?utf-8?B?cHdiZ2ZRMUhqbjJDWUV5MW9qdWRmOFNDVTZGUmdYRE1UcVU5UVg5dkdZZlBj?=
 =?utf-8?B?cEpXRUZqazRlTFMySER4ZEF0cHArSXBlMnFKUUZ3NUZFT0R0ZHFnZ2VLVFAw?=
 =?utf-8?B?ZlhrOTJnS0V0NDhhb2wwL1FLaEZURGRXR2kzTDRldGVYRmZTNS9wWnpRRllW?=
 =?utf-8?B?eWV3eVJiQTFTUTZUSnFubWZsNnNPV2lOd1pZS1NwK3FneU5TZlU4K3VpTGhU?=
 =?utf-8?B?OHc5ZUsvaU1UNW9rTGVET2Z6Um9vU3B2TWZFWGk3MmlSY2NUNm5kcitmL3NR?=
 =?utf-8?B?ZHFuYWZGRHNxdklsN0c0V2pVTTc5bUlUQ09pVVFrWFZSV1p3WTM1Nk1DbVdT?=
 =?utf-8?B?QWNGcUtWSnduQjJYU09FY3ZTa1VEUVRJckRyZjBtaHF3RWlmZTEyU05zQTNR?=
 =?utf-8?B?ejZMWWhtSnU2Y0tzSExrOWxsZXd6QnlCY1hTYk1adGFDN2tVdkJoV05Vdk1r?=
 =?utf-8?B?czNCVk5HTUJOTEI0V2xSVnJhLzFjdzJQbnliaUhzeU9TQ1RRVmFBSzZrbncy?=
 =?utf-8?B?NnNZNmJjVFpXUWJOUjc3ZERjYldVemFrakJLNnR3MUloMERKVnN6UGpQWUFT?=
 =?utf-8?B?L28yNE43NkxyV0tBWjJvQTM2bzFUZDNQZ2tCUSs0OTlQay94cDROYjNKZXYw?=
 =?utf-8?B?T2JCWjJNaHNPNXVoRGE1OURWazA1cmZnaitaWkJLckM4bmNQd1AxMk9UdklI?=
 =?utf-8?B?R0lFOVdMNWM5aWo4eWpNNGk0L3V4M1FwWnVtamVRSlR5VVdpUHQ1ZlhVTnlP?=
 =?utf-8?B?OXR3SEpXcGU4cnhrNlRCTkZVYVhMMUdHOHcyZEhhdXJDbmhrSS92bDBXSjFl?=
 =?utf-8?B?azVaQnpXRkg0KzRlcVJ0ZDdDMXI4Y3BTdGMxTnJiQ2JFSzU1clRYRnFTdkVh?=
 =?utf-8?B?aUhEY1pNVVpMNXpNNElkZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcc9dbf-e231-40ff-9962-08d8ff90b8bf
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 22:00:31.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydzDo+qyt8uPtEPWFV5XOa6NpJ+aSHRtvlYMCq+kThRXP/jzccecHaFVRaDwWx3D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1235
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: tWmH-ddYiWklzDIjzB-vtse3EvneIDFg
X-Proofpoint-ORIG-GUID: tWmH-ddYiWklzDIjzB-vtse3EvneIDFg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_15:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 clxscore=1015 adultscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104140139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/21 1:01 PM, Andrii Nakryiko wrote:
> Add extra logic to handle map externs (only BTF-defined maps are supported for
> linking). Re-use the map parsing logic used during bpf_object__open(). Map
> externs are currently restricted to always and only specify map type, key
> type and/or size, and value type and/or size. Nothing extra is allowed. If any
> of those attributes are mismatched between extern and actual map definition,
> linker will report an error.

I don't get the motivation for this.
It seems cumbersome to force users to do:
+extern struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, key_type);
+	__type(value, value_type);
+	/* no max_entries on extern map definitions */
+} map1 SEC(".maps");

> The original intent was to allow for extern to specify attributes that matters
> (to user) to enforce. E.g., if you specify just key information and omit
> value, then any value fits. Similarly, it should have been possible to enforce
> map_flags, pinning, and any other possible map attribute. Unfortunately, that
> means that multiple externs can be only partially overlapping with each other,
> which means linker would need to combine their type definitions to end up with
> the most restrictive and fullest map definition.

but there is only one such full map definition.
Can all externs to be:
extern struct {} map1 SEC(".maps");

They can be in multiple .o files, but one true global map def
should have all the fields and will take the precedence during
the linking.

The map type, key size, value size, max entries are all irrelevant
during compilation. They're relevant during loading, but libbpf is
not going to load every .o individually. So "extern map" can
have any fields it wouldn't change the end result after linking.
May be enforce that 'extern struct {} map' doesn't have
any fields defined instead?
It seems asking users to copy-paste map defs in one file and in all
of extern is just extra hassle.
The users wouldn't want to copy-paste them for production code,
but will put map def into .h and include in multiple .c,
but adding "extern " in many .c-s and not
adding that "extern " is the main .c is another macro hassle.
Actually forcing "no max_entries in extern" is killing this idea.
So it's mandatory copy-paste or even more macro magic with partial
defs of maps?
What am I missing?
