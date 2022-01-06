Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EDE486127
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 08:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiAFHvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 02:51:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235701AbiAFHvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 02:51:09 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 205N5vvi026319;
        Wed, 5 Jan 2022 23:51:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nG2Qj34XXdDEh7UfXE7FH+gRgxy5frPb1J7qC8k172s=;
 b=nRvvnKSASatOjc523rxPmiR8PveD4VPzmFyqQnF0oF8zkkvZzjEab1r3Xkw2tCCg7qO9
 YWrOwTsmNMHAg6Muh21+R2zCYf00TSKzQVKGOwcUujV5tb/6FI80T+5MH1BpSnrdZxDw
 FOAPwkcqExtga4qpJBezXjt3V4CwY+mkJQo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ddmq3hym0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Jan 2022 23:51:06 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 23:51:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFN1Jvo8V9LC9BdB1gCUb9ivfARlGSbFU+tqFgng3SLVmYVPYmDr9OR1wsZZR8/Mqkzw/vklHnVQeiycBVkAQBhYeJJMqhzqpEucQKcK15iAP29WX6o7UTDm0sVFiM3DXrQ/F2aEreRmIW3RJ8CWva1LwhW4657jeJhHSIIT4aQuxJoZzYK2BdwbWe8PMH5VRs7XHoNpCWnfDl+gVT+87b3r0A7DI2zbyoSXfEeOJPLktTpW5oBwKGvEEHydjhphF0F9Z5SDMrBIVbBNn3JRD5vAe9NKjvyUK9t+AmlUKUGiDdO4pGoBTT76GmxGOLGoZcB9CBmv3A89rrqv6fTabg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nG2Qj34XXdDEh7UfXE7FH+gRgxy5frPb1J7qC8k172s=;
 b=J3zb3rtNq+qsLFpsT2ezfAKSUNyUA4++TmZSPolA3CF8VKzSLefhr1j6FwEbaxr8xruz4VIHCGd/CFwyL/mq262F/a2XXBh6t0mHaZR4jJ+/RisKadEml5i/vUFqZPY9E+xTA3SuKS8YFyZYg0x8HIhW0R4YNTApiEqCIrhfZXouPTPdvA4HdiLxFQUKCoT++Lnq50/hSXIKfZlJyf9ERmzWbyz9kjwlyS59iQ+sBS5aWa4cIvFMN1sE++rVsy1wMpL/HYfFyQbN5LDG8wBfO7INq9iXVXkASPTHiJ83OsQZwXAVFVK+EfxJ/M/CttoGWphKKVHPfBRTlbMnS7PU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2031.namprd15.prod.outlook.com (2603:10b6:805:8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 07:50:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29%4]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 07:50:58 +0000
Message-ID: <2e3a072c-2734-0d54-d0c3-833a75b509bf@fb.com>
Date:   Wed, 5 Jan 2022 23:50:55 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Content-Language: en-US
To:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211229210549.ocscvmftojxcqq3x@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388A3420C7FBC0B79894CFAA4B9@BYAPR02MB5238.namprd02.prod.outlook.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <BYAPR02MB52388A3420C7FBC0B79894CFAA4B9@BYAPR02MB5238.namprd02.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:301:4c::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 209ea888-7be8-4f61-f7a9-08d9d0e946d6
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2031:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2031D839D061026C700B0B2AD34C9@SN6PR1501MB2031.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjjhbcLoDlgvqu3mJRQgjBGlv7uzzR1FqpUlhDbKV1F5cThh6kcjQNSAtN5VOo2qKti9lzEEjhGmV0DgeCTWS2ddQzliqtGLnGLWEWLxqy/qepdnl7Qm9eRrY7tPi3md1GC3yLWgjZFOGt3yW4BGMNDgC1Cj6NQEovVqNfAFa0lOiaMrufUswnXyQEVuN9laCLofMlx59W1JDD56S6dTUFCJY3ExTgHLZkcR9ExUlEcCqsEw/wURJ6aBXYOWs12uxCrFpwLEePonHkO4jr+WSihTc4COwNI2u9muEoh81XRPm/vbE/qkB8b1Mz9nKzVwIlbnxa9LlCUWANoVSqKNK2DkCfDOdwcsRUa3SFRH1CoVIioOMSTBkoJHSIRb2EL7czSpzBDSsZhZwPrItM7noNXwytyiRNSZlYz/iKm8KRXQUNmsphOrLNHfDF1ToSTFY+iGB+wPEcBL60BcNaIqrkdr9kfLjIkmlZ1OY59E2DcEe/8RK79D/CAjee5h2YhpGK1e/M7xL07UZ0TtnONuk59VL1NGqfWpOKa3eqSDB17b5VioiprG76zAY910yEObOh2TpAW5hIyZc5dwKobwyInpUBIxIAuiRebyaqSu27Sfg26TugMfLw6gf0c4yYDwYjPsqN9g5KI7REB+qmzT98yn5i3JGDVdIRbJ2qeBc5fnzLFdj7TRXPFoW6EGmF7cKqG+z0IQp2pYVjeOSh1VHYeQPAhKqLrh2hehBlPjTH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(8676002)(31686004)(4326008)(8936002)(6486002)(508600001)(36756003)(186003)(86362001)(110136005)(6512007)(54906003)(5660300002)(52116002)(6666004)(2906002)(83380400001)(66476007)(6506007)(53546011)(66556008)(66946007)(316002)(38100700002)(2616005)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFMrZHg2VU1Lcld2dVBwQytGcXUyeUxLcURkMUozMEhiN0pVdTlITFB3WG1o?=
 =?utf-8?B?Z2YyVlU2UW9UZUhJRnJhb0tsZWZuc1FucWNzOGFPR1lCR1dNV3ZvTVUyUHFn?=
 =?utf-8?B?NjZMWVdSQW80eVFJSzNVdWpJWmJjOFZkUFhwQUdyZ09zeUdMYlBDUGk1MXdM?=
 =?utf-8?B?QnJVOS9jUFYwVkt0dzl3MXN0dE5IRDJVL3VyK3dOMHVPRVBNWVFoRWk4UEJI?=
 =?utf-8?B?bHdIK2xYdGtoZEMyaWJ5NTNSQlcxMXJNU1FCQVRqVVdocDhyUXNONk9nU0ZH?=
 =?utf-8?B?RW1zNHoyYWZnV2ppa1hzbmNKYXQyeW5sdW5hazNEWEVpRm1yU01GWHVxUzBx?=
 =?utf-8?B?a1hRSHVYSDlWNWR0UXMxODMyY2Qram93Y0s5NWJrQzVaanpUbmxPZExJSzRy?=
 =?utf-8?B?QW1DVDg5ZFhYUzh4cHdNaCtkVXZ5MUhBOUV6Qk1HcWVTOUR5WFBQSFBLVjFN?=
 =?utf-8?B?KzQvZHkxRS9xMHhnUjhsQUdCUHlNUGFZQ1pQM2VQSHJFT3hLc2l6Z2ZHQ1lh?=
 =?utf-8?B?TWhWRDRQemM3ZU44RnN4OXV3KzBPYlkzZExIbTdNeHY5MUJUbU1Jb2MrTnV6?=
 =?utf-8?B?UHNwRlNHdHd5bllpeGxlbGpoYkV2dzc2dmgvK3RtOWZkbHlPWHFnaG1POVhH?=
 =?utf-8?B?RVhCcjVyelhIRmttMGhmaEd5anpWV2NhQ054S01BcU5RWVl2UFFUUXdPYmFX?=
 =?utf-8?B?TkNFdDZLNDZxSTVmcm9hYVR5ZG5nVXB1emRBSVNTNC96UWdrcS9yZkRQakJr?=
 =?utf-8?B?cks0WFRhZmJKVVFQK2JrRmJzd0ZjM2xqQnZkNUJmSkNBaWlZeURad1dQYzBE?=
 =?utf-8?B?YURVa1JFQ2Qvb2hMenc1ckVlLy8wMmVnbFVjM2ZFK2hrNjhCMjNXMk5HbFdh?=
 =?utf-8?B?TmN0UENMd3IvMW9pNmcvam0rU0hoVGpxamphOHFFalZ2TGdhRHIzRnJRTHhK?=
 =?utf-8?B?Zm1VU0tDQmNORm5NcHRmQ1hRSXNLTVFZbkhGUUlVSUoreDhkYkcxd1FvZDZG?=
 =?utf-8?B?cUdtNUM0ZXRjby9qSW4wcjJDejlRYmFBRitwMTFXU1BSeGEwNG5ZODlVOG1E?=
 =?utf-8?B?N0hFMFBnOEVlYXA0VjdBYVlvWEZEN3EyV28xcTFxVlVieFpCTG5OdkFnRjBH?=
 =?utf-8?B?TnRicWlyVFF0eWVGL2xRNmlGUUpVM2M4ekI5NTkrbVhlclAvVzNQZk5Ua0hm?=
 =?utf-8?B?czdoeVlkSERNNHZSWVE1RUIwY2huMDBHdjQ1ei9HQ21Ja1pUL3VubWZCbjYx?=
 =?utf-8?B?R1hsUTIvMkJ3Z0FuMldrM0g4RTh5eHlyWTUxZGNiY0NZbkRYTHgyRHFpQXcv?=
 =?utf-8?B?ODdzSEZTZ1NkaDV2dE94SGJ3ZVYxb04vR200OGNuZGUyR2dBU3c0bXhXQisx?=
 =?utf-8?B?NytYNnFnQnNwaXJ0NkZjUXlwMEM2OFI4cnBqdFJuM2lDU1d4bmNTNHBXb2d3?=
 =?utf-8?B?SEVzQ3BPajhNZXNqWWZxbDBPRm1IU1Q3aE5uRStoSTJqS2lzek55ZmhBU2FQ?=
 =?utf-8?B?aHNORWlJWHo5UGFoN0NRdzVxdzVMZWlaek1vTFBJb01lVFV0Y09zQWlEQXZu?=
 =?utf-8?B?SzZOMjR5VFJISUFVdlVzWitUNFA2K0doMUl1QkpyWHRONnVnRlRCWng4Tmls?=
 =?utf-8?B?dVQ2MElva1p3cjREZ2x1ZTZ1cGdBc2ZCU1VpdXZJSkVrd3JEYUJZaVZPMUg2?=
 =?utf-8?B?cUxzWmtOajYwT1ArV3JOZ3Rmb25iTW0xQ2NuQnNBaDBPakF4QWhwTk95Vmw1?=
 =?utf-8?B?SG9QQ2V3YTZJd1pkaXVmelI4dW5TVEFiaGtma25vOGp6bVZxR2lZK1FYNFQ2?=
 =?utf-8?B?Q255RWRkdEppR1NwajJ1TTg2NWFuU21rMkJaNERIbnE1WFYzYUZlWXk5ODY5?=
 =?utf-8?B?L0oxMjZ2QmxieHZLYlFjSmpiV1VMdVZyYWdSZ2ZySXY5Q0c5bEFiVHBjRXhF?=
 =?utf-8?B?bHZqTEFZd2x1aWpBRERVenRrbitKamE1Y2dneHJJL3BETmtMV0NlenJFTS9B?=
 =?utf-8?B?ZnlkaytqNmN5YTJERWtQTyt3YUF6Z2l2SmYvMW1heVVJSHFLN3NtVFppZW16?=
 =?utf-8?B?dXl1WFVkeXV0aFkrUVFMWFRQdExMY2YyWGwzL1ZjVnMvTVMvd08vNGk4Mjlu?=
 =?utf-8?Q?LGRxx9Bj/HddWn2lXJTCTdJYU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 209ea888-7be8-4f61-f7a9-08d9d0e946d6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 07:50:58.5648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72boNIcs1qVN0nEHItmP09T9HTusbfo6oQ4Uz1N8/cxEAiyzyjQWZXL+69bWXE//
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2031
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: bOi482iqguunRAxSK_h_Cl-CC7TZQBV4
X-Proofpoint-ORIG-GUID: bOi482iqguunRAxSK_h_Cl-CC7TZQBV4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_02,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 malwarescore=0
 bulkscore=0 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060053
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/22 4:27 PM, Tyler Wear (QUIC) wrote:
> 
> 
>> -----Original Message-----
>> From: Martin KaFai Lau <kafai@fb.com>
>> Sent: Wednesday, December 29, 2021 1:06 PM
>> To: Tyler Wear <twear@quicinc.com>
>> Cc: Yonghong Song <yhs@fb.com>; Tyler Wear (QUIC) <quic_twear@quicinc.com>; netdev@vger.kernel.org; bpf@vger.kernel.org;
>> maze@google.com
>> Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
>>
>> WARNING: This email originated from outside of Qualcomm. Please be wary of any links or attachments, and do not enable macros.
>>
>> On Wed, Dec 29, 2021 at 06:29:05PM +0000, Tyler Wear wrote:
>>> Unable to run any bpf tests do to errors below. These occur with and without the new patch. Is this a known issue?
>>> Is the new test case required since bpf_skb_store_bytes() is already a tested function for other prog types?
>>>
>>> libbpf: failed to find BTF for extern 'bpf_testmod_invalid_mod_kfunc'
>>> [18] section: -2
>>> Error: failed to open BPF object file: No such file or directory
>>> libbpf: failed to find BTF info for global/extern symbol 'my_tid'
>>> Error: failed to link
>>> '/local/mnt/workspace/linux-stable/tools/testing/selftests/bpf/linked_
>>> funcs1.o': Unknown error -2 (-2)
>>> libbpf: failed to find BTF for extern 'bpf_kfunc_call_test1' [27]
>>> section: -2
>> tools/testing/selftests/bpf/README.rst has details on these.
>>
>> Ensure the llvm and pahole are up to date.
>> Also take a look at the "Testing patches" and "LLVM" section in Documentation/bpf/bpf_devel_QA.rst.
> 
> This will also require adding the l3/l4_ csum_replace() api's then. Adding the csum_replace() to a cgroup test case results in the below error during bpf program validation:
> "BPF_LD_[ABS|IND] instructions not allowed for this program type"

I saw you posted a new patch, so it seems you have resolved this 
BPF_LD_[ABS|IND] issue. Do you know what is the reason for this 
verification error? Here, the program type is cgroup_skb which should 
not mess up with BPF_LD_[ABS|IND] which is mostly for classic bpf to 
extended bpf conversion. Did I miss anything here?

> 
> Is there something else that needs to be added? Or would it be better to create the function just for ds_field?
