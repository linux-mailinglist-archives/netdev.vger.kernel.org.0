Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECAF34EDF1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhC3QdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:33:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232236AbhC3Qcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:32:55 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12UGUal9009641;
        Tue, 30 Mar 2021 09:32:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BwR+yue0cpHIhl7tVhKwHpwzycNpOYjcn24t9sYh8HU=;
 b=d8Gh4mib+m1FOIZHzsrN7CdYbhVGoOzQBUFGvBLB2/LYuVh2l356tpMDhE+PrAb5MaDR
 5XXTQFHXVYepEVBZ5ynGOIs8+7Wnp5SDMRHzeSu/nexUwj8EnQVYHJ4hx4A5kEwU52k0
 /BQXQxQCaeZsNNxK2ecP++fTTlxO5RzvS/U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37kuvm3qw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Mar 2021 09:32:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 09:32:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8ZtzVrzj38Wyjex2DOt7zJxGkSd03XodqVOdWKdp0J98CShV3aI6DWbjUEOO0pIvogxEnmoMb+hMkya/AzCVssYzQ7CiowJLc74AHq+LGjC/f9U2lBgmfYQexDiZLFogQQnISRQwitmNfHTkdGqxEsulhah3BQ6ML81nntg6Q91YOFnKbf4ueKoT2s1jO85+x/PIVCd9ANxb+BjzhIMtILuiIrcbbe578NmZngyR1HCZWtInEl7BtFLgXPg0MLbPuDeriCouQmNi6HFuIWEfigObTUK4MjZ2dcv/4VNhsBT/fIoim7JQI+UiSBDd2hJNgY6SiWS5oLX0VTGBIxD4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwR+yue0cpHIhl7tVhKwHpwzycNpOYjcn24t9sYh8HU=;
 b=F+n34qGNoktf8Nw//eTsjosF2+fXP0AyAy12iqLwxGqbOraJ4qNMv0hlCv+sTQOFWrF61mxVQOcZZfBoqaXERZ2GPK26arnMZn68NxfaGu1kZ1M5J1OfSZDmsgmyNnAtOdxuabzyU2PUMOPGMpyJXCWQaFq+2hfAvJ/TrDbxnHuxEtKnAXs6Whjoc6S7OZYlCxtIKVa0DARbCZOQ/yVc+q6GKWx0EMm2RJXUo3GTzJD27fO20uD6DzrV53tL3Y2B/CoQ+3/KE0Q16llFrR6akhbxzZWGOrLlc9yDnhk7KUpLLEi+EQ+3czXYeTSMwldRptZa/pVY95n9xgAOi1rgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN6PR15MB1779.namprd15.prod.outlook.com (2603:10b6:405:4d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Tue, 30 Mar
 2021 16:32:37 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 16:32:37 +0000
Subject: Re: [PATCH bpf-next] libbpf: fix memory leak when emitting final
 btf_ext
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210327042502.969745-1-andrii@kernel.org>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <b0032ec1-973f-d7e4-74cc-bae24126808a@fb.com>
Date:   Tue, 30 Mar 2021 09:32:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210327042502.969745-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:2845]
X-ClientProxiedBy: MWHPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:300:ee::17) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103::3b8] (2620:10d:c090:400::5:2845) by MWHPR04CA0031.namprd04.prod.outlook.com (2603:10b6:300:ee::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 16:32:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 774faa56-6971-4740-fe49-08d8f3996db2
X-MS-TrafficTypeDiagnostic: BN6PR15MB1779:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR15MB1779D23952A930F4297D6D67D77D9@BN6PR15MB1779.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:561;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f2zGhieawvRXqpVbss8KEjZzXZTdAZygFFkQMTSmsE0Keta6qHqRV7/v5SNU4XK7PWdfOgPjlA9nnTNhEOfSXNOxlRXC75X/HSHSmtrvHbycHfyfyBePg4p0CIQImLUo47Yw2/lE7kFcOWbgTYyxAoONJkylmN0CrSpOEOBCTA1L9T367mjQl+GkHRyTxvE+ao067xZRK/kxqeDojhBwLzpdtq2mQKV15DMgF338EdC/Knid2yBQiaUAAgXSxZw0agyjfyEUydoxjyctrJwkIqiHjutVMcEg1Hm5pyPyEhJZDTazpDUJUqr3+2XW5qq6trz/Q8OShBjPbe5y56qKaZddpn/wKXzVucpDiNfFlRuw+k+MvxxMLe83EpasbNrY0hZeUE9fjnGOefwIlYbrfT1KFAMGE0QisGVArI6aQrQpGzj6QOMig45bEXehZqY8v2q7UPrFMto28D3819XUW0DWOTlkWpSYNyPzGtr6rzSwqRXDqGxKWVSbxMvvoiUO5NkTGiGV3PqDkf+ZvB2e5Lmd7v0o/4s8n+HweeVAZRf1hcq/R5f6TBJQM9CbiLHcMZ5MmB5IYYQNvklcKk0huydra1Ddo+Y9tvb+4HP7TI4oWc6ck0i7OKylKdzSUJkp7p/UtlhzdGcxBt3KtR4tBEhTlZgyJNwzjeOBFeZefiIZ5ar/CVxGSYN8siiHCdfLLVCxez4RAomEjB/bp/TUi8GpZSP8/S7X6XMrRopzh14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(8936002)(2906002)(31686004)(66476007)(66946007)(86362001)(16526019)(316002)(66556008)(31696002)(6486002)(38100700001)(4326008)(6666004)(52116002)(2616005)(5660300002)(478600001)(8676002)(4744005)(186003)(53546011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cmt0WXluVVVwa0Ixc0RCcnhKQnVNenArUGxhWXlwL01zZmx3N21JbE10SjBv?=
 =?utf-8?B?aVIxbE1OL0xQM2F5VHZTaStaVUo0cVF5RGFVNlhzZWZFODl2NEZOd094WkRC?=
 =?utf-8?B?RVNBdG1LTHJkaWtIQTZ1L1g1OTJOL0pzZmZWTFp0cFUyYThNQjhJSmhKZmpa?=
 =?utf-8?B?b21Kd05XSWVTYWlRTm13ZHEzS0oyRGhPckZyZ2tQVEJVSWhYbDVDcFJZZjNE?=
 =?utf-8?B?SEd4aS9WdkZZcjVDRUF5S2xRRHI5cElQL200cHpBcGVoYklkbmE1OVhEOW5x?=
 =?utf-8?B?R1BDK3piYVhWZlZCWE82bGlHS21qbnl3NUNZdDRSSzZuU2ZjZ3dLbkQvZUFR?=
 =?utf-8?B?bFhGQXdNSUhLbzByWmlwWkRGQmhVaFNDK09ZRVlPY1Uya2ZFZDZrMjBYSkFF?=
 =?utf-8?B?eHU3ZEdhcDlNVmU0Szg0Wmt1SC8rYkxZelVJSkdaaEIzTlNhZllYZm8zcXcr?=
 =?utf-8?B?QzRBOVpzYzBONzhJUW1xNVlOSDRTTnh4THp5eFExanVSN0RCcWtoSDR3Rito?=
 =?utf-8?B?M3MzOFBIdEp2VkZuN0pyTWtKUFRwN3FzWkNiUkVucVFJcWdpUldkMW10U3pS?=
 =?utf-8?B?d1pzVmpWQ0R6c3dnT1NBZHpmOGNHMDV0UEE1ek5tQ294OGk2aHV4WkIvRXF0?=
 =?utf-8?B?WnNxZzBwQWNJdXZydGlRS2NROXFNQ3NGK2dYd1lOeElSYzhVd1VEdlQ1R1BC?=
 =?utf-8?B?V0ExaU5sZ3hkNFVCVHRpNng1cU5QYysrUGpoQlc1eHAwdWRpUW1FeTAwMzFB?=
 =?utf-8?B?L05lSTd4NW84bUV1cnJjQjdQQ3VRVmhScVd5OGZGeFE0eFU5d0ZJMW5KaVNF?=
 =?utf-8?B?VzByK3U4OWVGanloVDRVbHkrUk1pMy9FUzVYK1lZTUFEMXh2am1JN3dqM0c0?=
 =?utf-8?B?R2EzZmxMSlV1R0JWN0FKbEtmT2lxaGxoU1RYM05mYmFFeUJTeEFWOXRFbHZ5?=
 =?utf-8?B?L3hCRHowV0JkUDkyaldKM1k3Q0k1SnhYZmovb0g5Y2plQlVDWFJpT3ZKWnV0?=
 =?utf-8?B?TGpndU1vcmxvS3QramlVNGI5Y05NMWdNR3hLV2o3U3hOVit0akk5dHZCRzUx?=
 =?utf-8?B?VEhzQnJYYUtoS2pvSTVaaVBwVVU4dCt4RXNXcUxwZkErMnhTZXZIWWk2Rkc2?=
 =?utf-8?B?VXM1L2VrQWRkVk9mTmhHNjVOM253N2tuKzBMUmFTWTR5eWMxUlJWelhXZ3NL?=
 =?utf-8?B?VGh6bVZ6STNNb01sWGtTWWluQVhtdGJYK2FQOGJXNkZXVFdCcGVsU2hsZ0Fn?=
 =?utf-8?B?eWVIck80NUFVT1Jzd2svMXNlYk1sczUxZlM0ZFNEVW1iYW5XMlFSemNHUkxO?=
 =?utf-8?B?OTFUTUllSVQ1UTV2YUcvMCt0VmU2R08wc2l2d29xYVBNUXB1SnA2Z2RhejhU?=
 =?utf-8?B?WWZFdUZjVEtuaWV0YitvMERPT3A1aTRxYS9xSXZkMXFWY3pCNWU0MFZJbTBV?=
 =?utf-8?B?cENiM3luUXVSL1Z3ZzI5aldaOUVnMER5RU50MzBiemVLMEFlRkp0bk1lM3VT?=
 =?utf-8?B?ZFYrVHR5QmpjNzc3QUs3ZE9YR0MvQVhPQ3MvMVNPd21mSXFaU2kwdkgyMU5B?=
 =?utf-8?B?dTl1VGMzeDkvYURzU1FzSkVGcTZtU2x6M1dtRjJHeFh0SDhWWmJKNFlVbHNp?=
 =?utf-8?B?K0lHNXl1OHpSMkh0SnVWOHZxdHEySEo1SFB3d0VrVlpFSkZhMkFGaitMV3F3?=
 =?utf-8?B?ZGpUaG9uUEwvRm52T3F4cWlHc3daN1VheFFPTDR3TGhqMlRmN2h0YVNKcm1w?=
 =?utf-8?B?aWdUYWNQN1FkMCthV1Y1WEJEb1pKMkFOU0RVOFE2eExBdXVUbEtqWkRUK1Jt?=
 =?utf-8?B?ZXNTOGVDRzRTaUtXenk2Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 774faa56-6971-4740-fe49-08d8f3996db2
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 16:32:37.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qfc5xYWXUVTcDcPnkGQFveHpdY+absnsDUx97Ea5pQ68HTRorNuoXnP9ldjOATM6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1779
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wON7dPyHmwLb2AnC6CyXM-SY5yEEahmo
X-Proofpoint-ORIG-GUID: wON7dPyHmwLb2AnC6CyXM-SY5yEEahmo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_06:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=920
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/21 9:25 PM, Andrii Nakryiko wrote:
> Free temporary allocated memory used to construct finalized .BTF.ext data.
> Found by Coverity static analysis on libbpf's Github repo.
> 
> Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
> Signed-off-by: Andrii Nakryiko<andrii@kernel.org>

Applied.
