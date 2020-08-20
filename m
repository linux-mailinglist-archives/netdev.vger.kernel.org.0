Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB8D24C343
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgHTQTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:19:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729944AbgHTQTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:19:24 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KGAbFN010187;
        Thu, 20 Aug 2020 09:19:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=n88BMqN7VBIH/kJoxqi6FPMKxdintb/pzM7ZVXrtC2k=;
 b=D7AUyCF24hDz3cXh2cjPG0huAYgPTA9KsIsdwcm/l/g6aSVnDDrBK5GpE+Cvv57/yjP+
 goMr+gQpznETh5tFZbHbaShh/lYxvrzyWIdwzJiljelT4CCFKSwRVeWMtfvjWp+PDO37
 oDXIZcj/OcKtSmW6DxDbhpnBuLMDmPrizkM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 331d50m0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 09:19:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 09:19:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUHdwGEuELiwr3WM5qrE+PZussXS8Fj7aCtiSYUIwUlMBd3F7buXJtM+Y/cTDZrqrfZyWBBUcjYOUcURQCAHD7RObfdZy19pzJUIgCSQK9e0PeoloGVMoXsmtAQcNhbPgcqP0HRwWg1helCgOteMt1EkgNFmjlwgs2mghANt+xpENW7XmODuLWWPz4zuzJl2jVkW7aditOT/w6/SMXap+YVBEfhsrrPbes9kxmshqHcnuzCJvr1hhxFBI6BgLgbspl9yhhf2mMJCSz4nfjVwhIpEXdMcOl2gY6sTM/73yZg8OdS8H4n7TwB0CzdIXlKeU+FDAGxGv1156e1XukkfTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n88BMqN7VBIH/kJoxqi6FPMKxdintb/pzM7ZVXrtC2k=;
 b=VOzw9pEmJACgIPwrUDYcj0/FuGXNPFh2D57AgfNCZUItSvKw8GMNuYjV3Ow2tFuq76Vl7b3ssnJyLg7qcGg2p8n2nZovrbJ50qeErpjKAggU0Jf40JRk9zMcXPzt53hPwQpvV1TBIROu2nw9/Jl8wITa5/CAiL6zo4r53gMwL3tI1NY7a7s3+/TWERPlMNc5fYf8PF6JUtcTW+6ahSOxG/52Dl/Pfk6NX1MjEKgNUUhJKmcL2+qlqh7WX3Ldjfqkhrk5UNNgaUXZ3djwSg7UtthxMvIZFiSzBVUcpPpwQQ2ycxF6hducRAGfeeFI5U1ZV7Ob5XpxFrCMlg4P/RdKiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n88BMqN7VBIH/kJoxqi6FPMKxdintb/pzM7ZVXrtC2k=;
 b=lYdzPevzFM+AM7CJ4Oi3UJ1kZDj8qjEBTPsVGEwCB68WyXVW5toWn5d2eDinV6czD30mRubYkBTGrG9zLgs31ZO8TjD+A3bv6Y7kWMDnKxhTsvrUT4BBnQJ2Kg0euBlSq5NU2YffaTlwvIiNmvkSPa80FxUOWsml+EL0ykROlbs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 20 Aug
 2020 16:19:02 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 16:19:02 +0000
Subject: Re: [PATCH bpf-next v2 4/6] bpf: override the meaning of
 ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200820135729.135783-1-lmb@cloudflare.com>
 <20200820135729.135783-5-lmb@cloudflare.com>
 <34027dbc-d5c6-e886-21f8-f3e73e2fde4a@fb.com>
 <CACAyw98gaWmpJT-LPhqKbKgaPG9s=aNU=K2Db1144dihFHzXJA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2d167605-df64-29c8-f817-d2602cb9d57f@fb.com>
Date:   Thu, 20 Aug 2020 09:18:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CACAyw98gaWmpJT-LPhqKbKgaPG9s=aNU=K2Db1144dihFHzXJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0056.namprd13.prod.outlook.com
 (2603:10b6:208:257::31) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL1PR13CA0056.namprd13.prod.outlook.com (2603:10b6:208:257::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Thu, 20 Aug 2020 16:19:00 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8897372-e04f-459f-dce0-08d84524c0a2
X-MS-TrafficTypeDiagnostic: BYAPR15MB4088:
X-Microsoft-Antispam-PRVS: <BYAPR15MB408882415B0AE4C27A25F912D35A0@BYAPR15MB4088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lO7QPyvWnMamYDwBonbwPgV1xN46L/Uvfm1a36ZmcTDJtjRP2QbpUnQsuYUv3Fi4aKFhnBLtyFFUe0s5z5hrBMzOUEMCOt7tJJFgq4GMZruMWTixHdMdq8oWIRsWgd3cxtWbpOwUGLl/+n1Xd8GhH9m7WeG/7iBbcdkhI8P4ZIeH+jqa2B8j58IahKPxbW2pinUrYCGohIw6gdKqV6qS0nvQjIYjNa+u1q9mVC+Y9AqeXjCuM0wiyCjTFgbdR6IO3L4ws23t0DXp+/7u6ZQq76CyxoI21KT3i2x6br1z3cp7tyUPXlyfXvJDr3RGOYunU54UNQL93vT+ImYg/nrtsCDXcEf+Km7NtNWG0vdG/7TuRYrCMp9CAHAzPhMw7CbFE1nBX0st9fpQejBR7BrDfDO6d9mCyARkiN9TvCMQ4/Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(54906003)(52116002)(66556008)(66476007)(316002)(66946007)(8936002)(31696002)(5660300002)(83380400001)(6666004)(186003)(53546011)(86362001)(2906002)(2616005)(16576012)(36756003)(478600001)(110011004)(8676002)(956004)(4326008)(6486002)(6916009)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: O5m73O5sxRYDxSaO7qcI0m+shFTwPgSlVIlAMzRlculHn3OmuFXl3GNkyXeq5USgKnnQonv0P48tZEysMzMrkoWA5qU6fj9UiMI+ulNw4wOtIiX4dSXIhb4q8PSCLSF5bNBGHl2zmiNuTREyDuCS/Km/ZcIT38dKHxb0iaS0e7jRaXT4BSJ1V6gquFAHYGtz7m5524hABAv9ZSbDc55d9fvp4URxhdodNFvaPeqtWR3Lsn0BxsQ9ANd32eBicM7aB0H8mtPOxiYEYLzPXdgHlop6Nt/sHk7DcQRIKDDoKIgesaSAy4wHhwgbR7S09GVFKNIPTZRlcMdTOZI+SQirL7r31IGzqoyoLCtVRX9yTIt8tSFsRo2OWApVWVTudh9qZhU44eTAYp51pfKE8PoCkgKo3w0RRvwRz4CYElDtQTZ/y7eoQPawsvkZoY6kbNjQ0B2DhDPKxNvuPjPoBetF5ZYHuQXku5xnWkytSxNgAaHV3kiSKVXHpg+fXa6wrZeAhf+C5s2p7PI+4RfO704LZA491Oi6Cbb8ZusfDkQT/7VfmKoIo8PF6sw/pPekWvoGzp/l2DC2Jwzl2ZPcVh/2BH9fNYx/kgcx9XkuzuFs9jDYcTjw1BlQ5RmiAVsV/w0tfEjDpFtu9CRZSJZlRljFxDqI5Ndc4iGrd9YiDKgyoXk=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8897372-e04f-459f-dce0-08d84524c0a2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 16:19:02.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZUWeQio4uxZFdaE0DAqs0r/DPi2yZ52rvgo5ItIzRs0KWg0mV/Dhhfn5EHKq5ip
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4088
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008200132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 9:15 AM, Lorenz Bauer wrote:
> On Thu, 20 Aug 2020 at 17:10, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/20/20 6:57 AM, Lorenz Bauer wrote:
>>> The verifier assumes that map values are simple blobs of memory, and
>>> therefore treats ARG_PTR_TO_MAP_VALUE, etc. as such. However, there are
>>> map types where this isn't true. For example, sockmap and sockhash store
>>> sockets. In general this isn't a big problem: we can just
>>> write helpers that explicitly requests PTR_TO_SOCKET instead of
>>> ARG_PTR_TO_MAP_VALUE.
>>>
>>> The one exception are the standard map helpers like map_update_elem,
>>> map_lookup_elem, etc. Here it would be nice we could overload the
>>> function prototype for different kinds of maps. Unfortunately, this
>>> isn't entirely straight forward:
>>> We only know the type of the map once we have resolved meta->map_ptr
>>> in check_func_arg. This means we can't swap out the prototype
>>> in check_helper_call until we're half way through the function.
>>>
>>> Instead, modify check_func_arg to treat ARG_PTR_TO_MAP_VALUE* to
>>> mean "the native type for the map" instead of "pointer to memory"
>>> for sockmap and sockhash. This means we don't have to modify the
>>> function prototype at all
>>>
>>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>>> ---
>>>    kernel/bpf/verifier.c | 37 +++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 37 insertions(+)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index b6ccfce3bf4c..24feec515d3e 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -3872,6 +3872,35 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
>>>        return -EINVAL;
>>>    }
>>>
>>> +static int resolve_map_arg_type(struct bpf_verifier_env *env,
>>> +                              const struct bpf_call_arg_meta *meta,
>>> +                              enum bpf_arg_type *arg_type)
>>> +{
>>> +     if (!meta->map_ptr) {
>>> +             /* kernel subsystem misconfigured verifier */
>>> +             verbose(env, "invalid map_ptr to access map->type\n");
>>> +             return -EACCES;
>>> +     }
>>> +
>>> +     switch (meta->map_ptr->map_type) {
>>> +     case BPF_MAP_TYPE_SOCKMAP:
>>> +     case BPF_MAP_TYPE_SOCKHASH:
>>> +             if (*arg_type == ARG_PTR_TO_MAP_VALUE) {
>>> +                     *arg_type = ARG_PTR_TO_SOCKET;
>>> +             } else if (*arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
>>> +                     *arg_type = ARG_PTR_TO_SOCKET_OR_NULL;
>>
>> Is this *arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL possible with
>> current implementation?
> 
> No, the only user is bpf_sk_storage_get and friends which requires
> BPF_MAP_TYPE_SK_STORAGE.
> I seemed to make sense to map ARG_PTR_TO_MAP_VALUE_OR_NULL, but I can
> remove it as
> well if you prefer. Do you think this is dangerous?

It is not dangerous, but is misleading. People looking at code may
think it is possible but actually it is not. So I prefer you remove it.

> 
>>
>> If not, we can remove this "else if" and return -EINVAL, right?
>>
>>> +             } else {
>>> +                     verbose(env, "invalid arg_type for sockmap/sockhash\n");
>>> +                     return -EINVAL;
>>> +             }
>>> +             break;
>>> +
>>> +     default:
>>> +             break;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>>    static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>>>                          struct bpf_call_arg_meta *meta,
>>>                          const struct bpf_func_proto *fn)
>>> @@ -3904,6 +3933,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>>>                return -EACCES;
>>>        }
>>>
>>> +     if (arg_type == ARG_PTR_TO_MAP_VALUE ||
>>> +         arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
>>> +         arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
>>> +             err = resolve_map_arg_type(env, meta, &arg_type);
>>
>> I am okay with this to cover all MAP_VALUE types with func
>> name resolve_map_arg_type as a generic helper.
>>
>>> +             if (err)
>>> +                     return err;
>>> +     }
>>> +
>>>        if (arg_type == ARG_PTR_TO_MAP_KEY ||
>>>            arg_type == ARG_PTR_TO_MAP_VALUE ||
>>>            arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
>>>
> 
> 
> 
