Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1BC4B63AF
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiBOGkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiBOGkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:40:14 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E258FAE186;
        Mon, 14 Feb 2022 22:40:04 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21F3FHWv026837;
        Mon, 14 Feb 2022 22:39:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=FJSIgIOGVJkruk6Hukw4B1vJMJjNzZVJ/Dk/j1e1ghM=;
 b=ZIO6J6NGhYNI7CJHqIwkyzGmRs77DWoak6ECHyzCmDBnkTyXtgd2NDOIuU0PPlano6tw
 R1oXES1X3qBPkyr5tN1MVXqDzvZ9chnBGiFnOnAJOKm869sgrLM1YimhrSlH5zNor2y2
 WfnVi06T5r8RMOIVS0PfX8p6LTyCC6Ug17g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e843mgqgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Feb 2022 22:39:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 22:39:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAs2MqIj/ApjKZHf5YFIVQ9EErLNTTmu0IquUA1v622PRyQS7becsUtN0WsafTGGpBlfQoaO35eFcnFpiItM4k9ZoyUilj7aTRSC0vSrF2BX0t4/rFvt3Wboe30Mo/pnJrGMYioIAW50T5ssfTBGddjvJroix7Ve14d1nxn2wpkK/uQZSYoskIOLqwY2bHFypjhrWL/dj3CF+u8ZwQyYZXOoW7loaSnMHTTNSSMHC7PWTgnvOxU0U+JsN+DRJp09GdhTyBlzG7IpRusi7hii3/m3CLZT6XGTvtQqW+UPk5n6xeBcLuA2UBMCOfbKe2qpPzhGuGhSMpZrQU7a5wZ0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJSIgIOGVJkruk6Hukw4B1vJMJjNzZVJ/Dk/j1e1ghM=;
 b=PG8qcegGjp4Hl/eU3zuXUW/wR+Ep+N0MwaK1Hc988WUVT7HdXKdjpG9pbn8ubHfoBV9yOKji5AcrMnZbQKvXI/F4c4s1EetcV/QRJMdCjkecbfkVoEZD7uDl2GeCWfU5032tJG9bQc144OCHw8xz3MJxlXZ6tQ5TIiSvU33fflyKCBQ5xSIM+3bH0oFGg0S7CSXGwlCmDA/g/1rF0jmu+SZqyibeMd6DiLMIqw0B0gOWEx5JZnkPPjzgazxIAktVA+nCZAlSqozBN23LMQ5gWhT0NXJ0xS0X9xrW8EGDsLT29TReybwLHZmocD9ps/1yK4prHEpr0ZwDgsD8PX6Rsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB2971.namprd15.prod.outlook.com (2603:10b6:5:137::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 15 Feb
 2022 06:39:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.4975.015; Tue, 15 Feb 2022
 06:39:34 +0000
Message-ID: <345fbe59-4f81-6a80-1a54-51829aea10ac@fb.com>
Date:   Mon, 14 Feb 2022 22:39:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH bpf-next v3] bpf: reject kfunc calls that overflow
 insn->imm
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220209091153.54116-1-houtao1@huawei.com>
 <54064f1c-5ff0-e6c1-dae5-19bec4b7641b@fb.com>
 <2339465e-1f87-595a-2954-eb92b6bfa9cc@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <2339465e-1f87-595a-2954-eb92b6bfa9cc@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:300:103::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b27897e-0c2c-4c49-0ec0-08d9f04dedb7
X-MS-TrafficTypeDiagnostic: DM6PR15MB2971:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB2971607581FF6667E8D86FB7D3349@DM6PR15MB2971.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQ/r506Fb//yAdiuvC+hh9n//aia4gjNbrguA68xhGsvoWez+KfrErabOy+fPGydkIZ3QGpcx0j05F56Yng0GPJ7RRxE8t2II0BtQRdiIJ+qVtwsSNgu+EQMv/sLBmJBtYxhq66e63cCk6s/tusE8aHOaZG7tYh1EdSI45OCjASFGm0upSHBzTDze5pHlkkU+bwOrf0feww1SzCsjCCeDp+EwwMnT5WpvDmMXzbj5VYKKhJa/opEzO5V0ndXMyjahknVwyYJJV/XzBfUoboOxIAKv0k11dYWs9sBSnr+qLPEPhk6KbSESR5pV2+aijMpfeKj4owqBa3zgQFeemMA8PfH0xT1d8k8a7iYYJp3bOhAQOqtYOAScHmso3LbKptIplEbtQhmrye2KyFO4DdqMwVTTgDfuSA2p4dQPyMQ6LTtqipWCM86JigXVGGk230grkfhZlJ39qM9qHimghdOFaR6jG9cv65l13YUFX3bu2SYVmruLV3TgWs+kEnqULLTYUei2TWUwEebIZ5ILi2lNj0KSTx4bWXDvbjoDGApMKW+iykFkgT/9Wwate/lZHXd5xchYWEEN2/31R26dBsBcVqCXx+cyK6qpO/C5usxyCNhsbMOktFlvqVtoaEWQa2XXlcKrL6rm1Z6rKhlPZJdEGJg9M6+l9mZSItbcDKtlEBeWA4nKtP4cGnTSqirHS3k5HaGgsBrUjWwOyEc17MjFM8GrqEiYK6599DKDCtFPOEIDySkDSUv5jgilSWze4CNGpU4DyDCjDChbOQpMeyGCqC2pKE+IMoaSdpfUQluVxfkODncX5Wg2CwEcD6j01Z7t2QCEtUCnUnDVmMjJdzO85XWjn/Dg/xZgdqrWcBSN6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(6512007)(8936002)(66946007)(66556008)(110136005)(4326008)(86362001)(31696002)(53546011)(66476007)(38100700002)(508600001)(6486002)(54906003)(6666004)(966005)(6506007)(316002)(2616005)(31686004)(83380400001)(36756003)(52116002)(186003)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enVuQ2ZzNTZEeGVxYlg5MEJrZlpER2FQeVBZMTcyeWl4bkthVG5UMTlwZDhj?=
 =?utf-8?B?Y2hqSExWblgzWlRaTFB1WHA5N3kyOHB5NzAzT3p4aGlFdjNDTjJXU2IwZnBt?=
 =?utf-8?B?cHE5YzNBVHNSUElJVjB1R2RaL2JxRzQrVHAxcDZHNzVDVmd1b3l5RU5oNmdh?=
 =?utf-8?B?QmIxd2hEeE1wVlhEWHhWc1BDWG9XVlN5T1N4M1U4eGdOTzBHNXgwNjdGU1BR?=
 =?utf-8?B?V1RySlpVLzNDZllXbEMwQUErYVpzWm1hR2o5bVloYTYvYnFuZ2E3VkFseVVB?=
 =?utf-8?B?MFIxZmhiSnZpRHJZSlJZQUV5UmM4ejloVmF5aGtKalRMNitDK2pSNkdvN1lL?=
 =?utf-8?B?R05jWks5RjNFZlRnckZQY01iQy9QcGEvNzNISlhJZlY4eStkS2RQWXlrUkFa?=
 =?utf-8?B?N1EzOHl3R0dmcG4rajJXY0JFa29RYUhJdllvY0lmazFHQU00bUt6aEpvUklM?=
 =?utf-8?B?Q0ROMTg4Rzlzd3d3QmNqM3k0MjllL0dtamcvUkEzZW90NmErc2Y5bEt4bmRX?=
 =?utf-8?B?dm8wYlo1UHdoajB4SW52MGM1d2g4OVdEZWtMaTM3MTNhY1FRU3ZQL24yeWd2?=
 =?utf-8?B?N2pqc1dtdlBLUzl6dHF2aHpDMUkreWhHV25WNlVXV3NaZ041Y0tPSnNseU1B?=
 =?utf-8?B?OEh3WElPTisyRjRKdnNDWmloR0tNclRqME0xLzAvUGhadXQxSkJPVFVaOEVp?=
 =?utf-8?B?ZStZN3NENXArZVVJLzdJYWNuS0JrYy9VdzNOaXRpS0VLR2d1cXlxSFdtd0pX?=
 =?utf-8?B?UUFsTlZTK2NTUFVkY0dqRngvdkpkMjk4cnFZTFl5SERnbU0vZWpCSlczRWNG?=
 =?utf-8?B?ckJrKzE3U2RYL3hLK1RCU1FoUnJDL0lkNkt6WVBpZmUwQTUwWGYwcitpOXBB?=
 =?utf-8?B?L01VU0hJWWxNUjc3L0RSU1VUVWxFM3J3TEREOWt5RWZuek9sUDR4TytaZG5u?=
 =?utf-8?B?Y3E3R2ZPU2hWemRnWjhWYlEwYTV1aURsSnVMRXFWOGd4Tkc0ZzE2Zjl2YTZZ?=
 =?utf-8?B?d3AwK3FmT1huRzBwYW9TR3pTK1NPa25SNGUwWVlvSDkzVXpSN0Q2bG9VSVZr?=
 =?utf-8?B?ZjBidVBKMFVFWXZ2dmtQSEMyUXlhVlJSb0NhNTBneDBFQ0VnUlhqbFNCZXhY?=
 =?utf-8?B?cHpqR2VDWHlMMWMzVnhKaHRWeE9VUDZIaUlFRUNWNllMREZ0UVFqRjNYY3JZ?=
 =?utf-8?B?MzE0c2lwSlpuaUU4MWltZ3NIVlNVUm50NXdZdHd2WjdoQ0M1amNFaHRPRC9n?=
 =?utf-8?B?MzE2ODhEREpEdlord09CbUNnWkpHL0NUKzJGaWJnSnJtdGl3VmFBdG10TWlU?=
 =?utf-8?B?NGJrOU9oenpuVG9uU05GQ05DOVRwTi9XNTFvcHQvdEoyMURHdnVJRUtoaUZv?=
 =?utf-8?B?djJoOGhCU1JxRVp3R3B4b2F2cjBNTXVYdUJUMEE1RFl2WEdTbGVNSWt5VGsy?=
 =?utf-8?B?blB4aTErUzJwTmJYd3BscFkxZjQwUERtRlQrRjliRDRkdjVBZzV2STdhaG9u?=
 =?utf-8?B?UVZnZzFEL0tUeEh0ZVhIc2V4dzhBMENGSXNuN01oSGhZT0pzdFJ0TzZ5SkJS?=
 =?utf-8?B?T1lkeWNjOGZpTU81NUkzN25vUTNkdG5LS05MY3hvVXQzOXB0SXNYM0crQnVI?=
 =?utf-8?B?R1VmV0h1N3FTYTRraU5XQXl4aVFLRUZkRUtCK1VCRlp2T1RRZWlaZjlURWl1?=
 =?utf-8?B?Wk9ZZzZDa0RudjUzb0NFLzhXbCtCMXdZL0IzUG1XZStQbjZYUnRtbEtyTUlr?=
 =?utf-8?B?VUlObS9zVlExNzB2Q1UzOVRkVzNFSkxxaUN2bnIxNkROS2phTk81MkMyeHVp?=
 =?utf-8?B?aGxLQlFjMVhOcytGWnczSUsyMnRKZkNyY2VETThEOEJwNzE3d3ZVbklnUW1X?=
 =?utf-8?B?L1lLVzB0Q1ZyOWJxWUtkSXZLdmZWb3RmbmEvUnVCbXlTajl5VHE1MHNhUk1T?=
 =?utf-8?B?SjZUMEd1VHB4ZHl6L1ZRVklLMS9hTlJSS2lnMDNGcXlWMTNJMHYxdDB6NXpN?=
 =?utf-8?B?eWw3bUdxVzh2WnlHYjVJVWVpWVNFSTZCekszdUF6MmpadTNKMEMwczgwOVE5?=
 =?utf-8?B?MkIwRlFobEVhODZoOHQzR1VpYXlPWWh6NWNBamY3R09sTUpSNTh3ZGdoVFZC?=
 =?utf-8?Q?qizWyMqB81N6yeKSvF675U7SJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b27897e-0c2c-4c49-0ec0-08d9f04dedb7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 06:39:34.3324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HM7SCUxINUYw/RQJ6jRZSYXV43MrwX0ce/9OZn12flbQXEU28vx0PGZXKWeddaYf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2971
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: UiQ6vju4fADGL8YLAEYlWjwavMKiKDp_
X-Proofpoint-GUID: UiQ6vju4fADGL8YLAEYlWjwavMKiKDp_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_02,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150038
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/22 8:29 PM, Hou Tao wrote:
> Hi,
> 
> On 2/9/2022 11:42 PM, Yonghong Song wrote:
>>
>>
>> On 2/9/22 1:11 AM, Hou Tao wrote:
>>> Now kfunc call uses s32 to represent the offset between the address
>>> of kfunc and __bpf_call_base, but it doesn't check whether or not
>>> s32 will be overflowed, so add an extra checking to reject these
>>> invalid kfunc calls.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>
>> The patch itself looks good. But the commit message
>> itself doesn't specify whether this is a theoretical case or
>> could really happen in practice. I look at the patch history,
>> and find the become commit message in v1 of the patch ([1]):
>>
>>> Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
>>> randomization range to 2 GB"), for arm64 whether KASLR is enabled
>>> or not, the module is placed within 2GB of the kernel region, so
>>> s32 in bpf_kfunc_desc is sufficient to represente the offset of
>>> module function relative to __bpf_call_base. The only thing needed
>>> is to override bpf_jit_supports_kfunc_call().
>>
>> So it does look like the overflow is possible.
>>
>> So I suggest you add more description on *when* the overflow
>> may happen in this patch.
> Will do in v5.
>>
>> And you can also retain your previous selftest patch to test
>> this verifier change.
> Is it necessary ?  IMO it is just duplication of the newly-added logic.

Okay, I just realized that the previous selftest doesn't really
verify the kernel change. That is, it will succeed regardless
of whether the kernel change applied or not. So it is ok not to
have your previous selftest.

> 
> Regards,
> Tao
> 
>>
>>    [1] https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com/
>>
>>> ---
>>> v3:
>>>    * call BPF_CALL_IMM() once (suggested by Yonghong)
>>>
>>> v2: https://lore.kernel.org/bpf/20220208123348.40360-1-houtao1@huawei.com
>>>    * instead of checking the overflow in selftests, just reject
>>>      these kfunc calls directly in verifier
>>>
>>> v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
>>> ---
>>>    kernel/bpf/verifier.c | 11 ++++++++++-
>>>    1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 1ae41d0cf96c..eb72e6139e2b 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -1842,6 +1842,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env,
>>> u32 func_id, s16 offset)
>>>        struct bpf_kfunc_desc *desc;
>>>        const char *func_name;
>>>        struct btf *desc_btf;
>>> +    unsigned long call_imm;
>>>        unsigned long addr;
>>>        int err;
>>>    @@ -1926,9 +1927,17 @@ static int add_kfunc_call(struct bpf_verifier_env
>>> *env, u32 func_id, s16 offset)
>>>            return -EINVAL;
>>>        }
>>>    +    call_imm = BPF_CALL_IMM(addr);
>>> +    /* Check whether or not the relative offset overflows desc->imm */
>>> +    if ((unsigned long)(s32)call_imm != call_imm) {
>>> +        verbose(env, "address of kernel function %s is out of range\n",
>>> +            func_name);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>>        desc = &tab->descs[tab->nr_descs++];
>>>        desc->func_id = func_id;
>>> -    desc->imm = BPF_CALL_IMM(addr);
>>> +    desc->imm = call_imm;
>>>        desc->offset = offset;
>>>        err = btf_distill_func_proto(&env->log, desc_btf,
>>>                         func_proto, func_name,
>> .
> 
