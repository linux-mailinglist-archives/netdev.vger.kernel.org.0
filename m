Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0663D9918
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhG1Wx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:53:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4958 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232143AbhG1Wx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:53:26 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SMrAGe017453;
        Wed, 28 Jul 2021 15:53:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=y2IwvHa524+hI7HxCgOhnKe0Hxzk6FCLqlEpPVWisfA=;
 b=VS7bOXR9dfdZdPHaACmTgvBNTRfqpf5BZoCdFNKd6nqOS0tJcZo72m+sQE7qBrP8QR+x
 cZ22J3HGr5ChZR9dTuDKUOpc0aSJS8U1yQLQI5ESKrWmQrTlpjMnvI99cxCBh+sCxFgg
 UcyAQXISy3nJTCJMLdRMNWsnM87g3mG4rPc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3bu99qgq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 15:53:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 15:53:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfZFs7YbxjMhgEqkNVF+OS+R16cmVl3C8+Ro/M1ArnB6eshoBxmYbWsxf/DvubeUyrVBnYQcjJkw8snbHgnIS23nQ9OwFmUVE/mNpQHh5FI9C6RamMdidJhihqMyeWMfkiAJErBJS5SA9Tio7hz+kf8H0RM98TMN4v7pa3uc9Qs93eL/2dJrxr5+XpDWxgjH2pOTxltgeEm+jnU9/Lk45m2b6s6ePdcsBc+9M+aMaH6MWcEULCvSoe3rjQ2EDlH5CWGD9ZDeOpf1O2Z6i2z+MOE9euRHyinlHWkNZhKXgh4Ez0dYvsx+5fxoqZe+R/wiSOjkQts0Oyc+Ar7XcfSkzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2IwvHa524+hI7HxCgOhnKe0Hxzk6FCLqlEpPVWisfA=;
 b=Ii1C1bvdkZbkgI7uc2mAFWOBzfd1luS2w0Z2h9/UThw45R3CrlJTznuxB9Ag4MgZoXiVktxSX1A5loB+hzsNHE5sU+aELv4Bnkbu6TctsTsEUNlb8EeK3pJyQc7z08Vggk8E+S97i7hg/VWKUToGCegC6lxqaMI8UKwI/68ZB7lPBRvUVbKubiRyr6t9ZwAZTYpuNFjsoQAZBdo9J3R8FoMpc6U6/IwLA+9yT5b2iXpPtfsY6V2UEgy6kFWnbIDu3iEgUZQOF0SzI+yKvhJMrTrq0MXwssMpEHU7KkqLdO+EQjsV3xJ/qSjusTXWpt7ygXfbKvwfThMSiTnABgc3JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM6PR15MB3322.namprd15.prod.outlook.com (2603:10b6:5:16f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 22:53:09 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f%7]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 22:53:09 +0000
Subject: Re: [PATCH 04/14] bpf/tests: Add more tests of ALU32 and ALU64
 bitwise operations
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-5-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <989326f9-5758-9669-56c0-76b6b23ec92b@fb.com>
Date:   Wed, 28 Jul 2021 15:53:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-5-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0030.namprd14.prod.outlook.com
 (2603:10b6:300:12b::16) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by MWHPR14CA0030.namprd14.prod.outlook.com (2603:10b6:300:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 22:53:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d904869-6e64-41c8-0017-08d9521a78ab
X-MS-TrafficTypeDiagnostic: DM6PR15MB3322:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3322A894689A4C495B0C03D6D3EA9@DM6PR15MB3322.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:309;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7pWmhoKTNRLliSaG+s8u+tdNUKQ+uerSB4TpBQb19U2nA4cFs0dmK7GkUPtDGuOY/OVNhoFevZBPMcz1k4KT+ou2juGfVpQ/bWiOFJ10QK3i9jZUCUUDZcikox64jFKusuiziO/jbpp5/jsYNxmecEQBqRaKoGe8f+cNtxkcIgi2U32q/tmQh1RRTXjJkDLqZsYlMqOVveLtn/SWOgyXwxL0TOdno2KOXL2QK4XbElSCPo4o7jnNu1BCfJX0Z6p/RlEtqxKaE/7xRW2u2tqkYmE/N6c17w2SkSgFWzeswGSbxfzCBxCVJJjgyHK6Rw+ABqY/5ZtOUmVQ453miIwQ1xRJNVpHNlH9JTF0T2Cq/gWoU2r7/oWwnjSlfSlyDcT8zgtGkYVFXDJbDZgdor1y27mATgd4rftnzvetDT9sv88Eb7Pdn1kRiWi/Gc8BoUHHKF7PJB24LTGLjUhQJr0P/zth5i4xmLzNsy2Tn72IT1WCiYjTyIAGDa4a5zvqTEk2NxW2lqc6DawFR14BZ+Jsz/SA+7i+LOME406oZc0IsEgIhMHMQyE79AXGJQkMaKnKDDgnDZi55evIyKKydQglp0SYmks24uFEJfKMoXXWNxd6+k4zQsuyQ8QFlvZsPD50zo9FKpcraPXLMKQpKxeylbU/qsseNNcAuuZZbv2Wbv6wJNDYhU72r3JaE7z4aaEd3XH0N9itInRlxZJmHGlJo8RUNRsqo2ONezoFxTNLRY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(6486002)(66556008)(31686004)(5660300002)(8676002)(4326008)(36756003)(186003)(53546011)(38100700002)(4744005)(316002)(2616005)(2906002)(52116002)(86362001)(8936002)(508600001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2xXSlRHTXorNnJBcXJJWnNESXpIY29nM1g1WVRtL3dVbVE1Zm56azhXU2g3?=
 =?utf-8?B?YjkxTUpFQXl5OUxEWFg4VENyRjh1K0s3RDhMV3lZZnBVVFBEdExwWDljNng3?=
 =?utf-8?B?RG9XelcrVzR6VVFqYXN3WHJldG0rZm5wMTBxMUIvWDZvWmdyeEEwY3QwZkNY?=
 =?utf-8?B?dFFIQWpOYkoyNmg2MFJnS1pZMzkvRjg1R05TcDV6ZzBCeitKaGdXUEdlZXZr?=
 =?utf-8?B?Y29VWG5weXpUaEYyS2llbnlxTDZybk5IUTF3VnhsM1VMUVdKZTFmL05FY1da?=
 =?utf-8?B?RWp4clJrM2pYK2dueE9aS0FjL3BFc29SK25FZmN0dG5ndFJQOEUyK2w2cjhX?=
 =?utf-8?B?dnNnenpNTDArT2REMnVhVElwN2w3Q3hJbG1FNmh2aFRvM2x6SkxldzZwWU9m?=
 =?utf-8?B?Q2t4aEQwVmJ5R1ZvQktDMEVVMTJQdmJIQTkzTDFmcjhiWndxMEtVRWlZWkl1?=
 =?utf-8?B?ZnpsckdRWm5PQW9zL2trTUdkMTVEenpaSEVwQmdUNUlDTjc3SFZWYXpNRFhL?=
 =?utf-8?B?dUtwbU1relUxZXlQYVl4QTlXRmplUWVCWUFSbE1WTzdHRjNlKzY5RGhZRm15?=
 =?utf-8?B?Q0QvRlk1NUoxZlBMRGp3S05IWkJXaTZjUkVaa1MxWGk4ZTVnaERkbE4wWGdC?=
 =?utf-8?B?bStMQnlXTXM5WlJYKzhMeDhKaERVbVcxRk9DdDhlVXZqb1k2NTAwMDNDMXkr?=
 =?utf-8?B?N1c4THM1QW43c2xUS0Y3dkVHREV5ZUpZVEhudm4xTnBRak9hZ1ZoNGNqcFpX?=
 =?utf-8?B?UGZqSk9kaTZkd0U4VlltR01yb3UzeTYxcm9PbEp3aUphRWlaMXU1WkZFVEJh?=
 =?utf-8?B?cDFDMDJzVFNnYXVjejM4ZjVzTU55ZTNDYWpEWFFCUnZQOVNhVU5DalkrWE51?=
 =?utf-8?B?bkhqNktHQmRlU29GUVhvcTg5NEJQNkRjdUUxY2lTaG1GWS93Q1B0OWRqV2RR?=
 =?utf-8?B?Zjk4L2M1dU5yRHJKV2FTbHdBZHNUZDM3SUVvbUVFVDQyU1FvNXlFSThtbUtq?=
 =?utf-8?B?SUx6WllyUFFpbyt3WnZHOVcxZHJHZ25DK092NHo5dHBPS2VZUmxOT2w5cG4w?=
 =?utf-8?B?L3VmV2xFTi9CT0kvRXBQT2xidDNVT2NEenVnbGJGYnFZTVNndmRZcHFwRGEw?=
 =?utf-8?B?TjRySXJYWDlXWGZFM0kxMG43a1U4aFppdytNMlNHWGVvUlNnYisvak9BYUxO?=
 =?utf-8?B?KzZ4bnZlam1PYUs1QXJ0Q0Y3eTVRRjk1Y0lIM2ttSGRZNnpSekoydzljRlJD?=
 =?utf-8?B?UER2Ry9aT1I3aUxvU3hUSk45ci9lZTQvVzQrMWJMdVVrSkdMKzZQbll1SmNI?=
 =?utf-8?B?Y2RTRDB2UDVRS2ljVlV4ZUh4Uzk4TEgxYk5CY2ZhbjRVY0huc1l0WFVCdWFX?=
 =?utf-8?B?TWlvR0pvZEM5ZnNHMlkycTRaS3pZY3dJanlxRHJ6d09qeitGTjB4UWFKT2Qx?=
 =?utf-8?B?OXgyOEdBK3Nvam80SmxsT29qNTBnKzlQaHJtbWIyM0dmS3drYmE5UkkxUXFv?=
 =?utf-8?B?d3A4aVY1ZDJJSGsyclpmNzhnM21WSDFyci9QVWVxRUFzT0owODNJZk9NWUpt?=
 =?utf-8?B?ckNOSWlzWWc5N040YUkyenhSaDlDR3Z2SmplempDOC9DZTRuKzA5MlRMWThZ?=
 =?utf-8?B?WTVGNzUzYm9GMit2REpXREh5aHRlWGVMNWxCN3ZLbXI1VklXQUMxdS9udlVh?=
 =?utf-8?B?M3g0NjJ3L2kvWUQxRVM5N2V0aHFJdlFlWWxDaUtreWRBZGhrNVR0SDRYZFlV?=
 =?utf-8?B?MFl3L3ZSNkp5ZjR3cXhMTFpoVXczR1ZOLzducWZUdUlHRWZrd3N3a3VCaitZ?=
 =?utf-8?B?aFdSdWZGRFRXczBIR0tUZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d904869-6e64-41c8-0017-08d9521a78ab
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 22:53:09.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5szlhvSjzGYjQ4OKpZkBVeSqYSlHE8qKs2yvNZJzG5Vtm7E5Y5XknVe55ruDx8vX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3322
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Ed_VGVJ9ScVK5DUMv6JToe3GYwYIKT0x
X-Proofpoint-GUID: Ed_VGVJ9ScVK5DUMv6JToe3GYwYIKT0x
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=678
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> This patch adds tests of BPF_AND, BPF_OR and BPF_XOR with different
> magnitude of the immediate value. Mainly checking 32-bit JIT sub-word
> handling and zero/sign extension.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
