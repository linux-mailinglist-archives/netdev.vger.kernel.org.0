Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E56D24C0CE
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgHTOpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:45:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8396 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727011AbgHTOpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:45:30 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KEeOOu004539;
        Thu, 20 Aug 2020 07:45:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sv2Zh4RmHbuRh4lL4RUIqIwFUwVOEf9kSSlgIv8Z1ek=;
 b=gSUqBeit0NTYkZ28u1tnLBPd+nUMuTcwQAQuOZiq/lUEA+Czlt9grcWmsa+vz+gR6fuT
 YoAVr8QYX/qQsVDsbpcqzsfF5aV+IMzrICbDscc9KRUYNGaHzTeBBOVwJx5eenXinIGP
 R5FwbUAnEN6RfnhkwncDMhW/Cz2PFmW9RAg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxxfwe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 07:45:11 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 07:45:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGaZoPNtxhGg8La7Qnt9Z2gSl5GzUI6f+lLman1xSVcPrwqmYBMU5DQZ79b/3j+iGzmEIx3LA05uAuDeQ7tuAinQusGqmxA1I50qQVLbBcz3GQmh+HNpPybJZLV+gnTXqqL3fnXjRGBVonhUccQr1BccU2ayXMGiH2PBrKuxtsEp0E551TeL+ecT3fBiUCRumhkaq7b0LLNU0hJoqDnbjo1ysjOVUqI8I//37ay5+kS9Zrtc79Atuc/1C8xLYhG59ws9i5RT85uGDgH65BQWzbSocD8QyYFry94YeMnB0muWST9HAt+51xDkTzu4gKw2GYC9Fp3pbZ9xCKvAs0ZJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sv2Zh4RmHbuRh4lL4RUIqIwFUwVOEf9kSSlgIv8Z1ek=;
 b=iFLxnI7yjB76Vxz8sBoufvqlHombdHxPinFWIq45P1RkBazXBDLvjSkq1BNY1jbhYwImK+kPmmZjcW7J/txJM/Vm+gy0ktdDn6D1rttqpsSD2B8oZ6n3p6CKVjQsQ5m1I2WEEijIXfLEAC65WnAjdlV92YPHL7ZAQNcWZOr+icUDUo6Eqk5qwWSQ5DSky0euhPG1RvmcjloqpfZ/CGetMEqAABktUox49hd81+JGDscl1ghgLua23DvLdVYtqDsPmpDhJghvwU8A9TlVGvgj3GqMqd9z+HOHJUopBzcJ4O9s+g9p9PIMn2bbargGBEquovE/VqmG1lVC9js5zVLp5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sv2Zh4RmHbuRh4lL4RUIqIwFUwVOEf9kSSlgIv8Z1ek=;
 b=aAt134CKoB6yZV0VHRdqPbcMwRuj/1mYpNMP01t0N6G8b350Yk+IIGk4SibbYH7t6/mYs2o6Z5w++6p50cnBz9PPF8Eg+U4cxrII+RuBSETKxE6zIWnCeW5YHWfeg3aE0awX0S02FsxLZaRhyWMdunFfqLZuPz8qnyYSNyHvUAU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 14:45:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 14:45:09 +0000
Subject: Re: [PATCH bpf-next 5/6] bpf: sockmap: allow update from BPF
To:     Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-6-lmb@cloudflare.com>
 <5f3d982f51f22_2c9b2adeefb585bccb@john-XPS-13-9370.notmuch>
 <5f3daa91265a7_1b0e2ab87245e5c05@john-XPS-13-9370.notmuch>
 <CACAyw9_oa5BKq+0gLS6pAuGu6pj9MsRHhEAxFvts167DwpdhLw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <80223f16-efe3-7a43-cd88-4ec323d2c477@fb.com>
Date:   Thu, 20 Aug 2020 07:45:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CACAyw9_oa5BKq+0gLS6pAuGu6pj9MsRHhEAxFvts167DwpdhLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0011.namprd16.prod.outlook.com
 (2603:10b6:208:134::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR16CA0011.namprd16.prod.outlook.com (2603:10b6:208:134::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 14:45:06 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7303114-593f-4ae6-ac46-08d84517a287
X-MS-TrafficTypeDiagnostic: BYAPR15MB2886:
X-Microsoft-Antispam-PRVS: <BYAPR15MB28860A56EE6C99C64EE76EFED35A0@BYAPR15MB2886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g54hRtn1HA0D+/wGD5qOXhSsZLmpIYlTCQyux3ZhozcdaPLxtpersK0LwsAIU2cr8ky42aQKpv15ZC1/L47SStdoufBm7gFbxBk+nOwWg6OkH9QerXvmOE/b5zKG1Xkh8MnepH9lnQz112ZEzEWcWJ80HsApmn/B6UOxdRWzsja/Sr2vOKXd4wwYOFL5fWLo+zRg1j2Y9XPDBBlk3W4fHxX+a+bPpdBD6/cFFZApDS6hBQuTG4cTCRPuVzfYtXns/aJ4eDETTxhMwSSvh+PFQzkTJ+TOjjukbGy+O2vdWNRAb+OhZ+LcGBAkTY2xr8fv8w+FyAHNf9T8LKYNQWQn/YU17N3uFIWpXro/QJ5ypvF6di+InN8r/krDs2JxQdkhoR8R0fr7olN7QJpUKbRTnxmngXTmlo8rYIap0gVRrkLORC6mQrdigPBI/lCkNOpAPis2/rvp7ZfRLV/qouiVMLDcoSw1Q0XVjWh32+c45m4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39860400002)(346002)(54906003)(16576012)(110136005)(15650500001)(2616005)(52116002)(956004)(66946007)(8676002)(110011004)(5660300002)(2906002)(66556008)(66476007)(6486002)(53546011)(83380400001)(36756003)(966005)(86362001)(31686004)(31696002)(4326008)(186003)(7416002)(6666004)(8936002)(316002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KYj78yjKAIvg5BowH82iVqJmCZM0ltvr+TweI9Tco0s4Annxk8tNmWQhDJS48IDk/SQYSJV8Lz1Mjs4mcPRinjG801hUmuuLZeABIqXf90DLhTS9+HhoeRtwmmh5npisGSpumcg7ccMqi9R2cBjsgrZWu9sPIbwXwUHYlOFrfdp41uW5hSCPulImFvRv6eB/gBz4oW+/rRPvaNGVv90AE0poHlk5q+VDEfnfbqwHWyuNmwu38ooKXZQzjxnO7h5sAb3tFf7wOlBqdEXhLP4R9bg9dYg1OXMKRhTEyvYRwHC5vwRiXWiH1/xuReYJ2HVb+BIvZIoRNBIp54kP/Spe/RVV5jYcjpenQHGCGNctFTnk35TO9tUg6YQHfFII4Wb9zNHi43krEXmBzCgvqZZvAiIyW83Yd7ryBKztut0Xx5juFuwUssvpTrD05CUx+RiqbY2MLN4hG/kXUxxRwegj75p6FoOQTYVbPuNVtfumkkN+29dwNsH6zacAOBOVwpAVsKiixMH0fRVoo9eKyuPDD9VUw2dkKLL0DZjUTeUfTftK76orgJVEUmarV3DTc5mLqJ5UPD/e7KpDZ4LZ23a6wRIWWIy/7DcgWfqL02IBkGeIdQmNjYyfd+WcZXpx682zOUtJklTfhz2mmu32H8QtMW9x7Gy1eubUhhcWgTYP8rMObl60RK/ZiuCCsIHiJCcI
X-MS-Exchange-CrossTenant-Network-Message-Id: d7303114-593f-4ae6-ac46-08d84517a287
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 14:45:08.8668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgQbRTt6aSp8dhMAXvjGLTaI+Xn6meQf0wCglWXssLL21+ClOCR+GyD++rAaaRHO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 4:33 AM, Lorenz Bauer wrote:
> On Wed, 19 Aug 2020 at 23:41, John Fastabend <john.fastabend@gmail.com> wrote:
>>
>> John Fastabend wrote:
>>> Lorenz Bauer wrote:
>>>> Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
>>>> context. The synchronization required for this is a bit fiddly: we
>>>> need to prevent the socket from changing it's state while we add it
>>>> to the sockmap, since we rely on getting a callback via
>>>> sk_prot->unhash. However, we can't just lock_sock like in
>>>> sock_map_sk_acquire because that might sleep. So instead we disable
>>>> softirq processing and use bh_lock_sock to prevent further
>>>> modification.
>>>>
>>>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>>>> ---
>>>>   kernel/bpf/verifier.c |  6 ++++--
>>>>   net/core/sock_map.c   | 24 ++++++++++++++++++++++++
>>>>   2 files changed, 28 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index 47f9b94bb9d4..421fccf18dea 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -4254,7 +4254,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>>>                  func_id != BPF_FUNC_map_delete_elem &&
>>>>                  func_id != BPF_FUNC_msg_redirect_map &&
>>>>                  func_id != BPF_FUNC_sk_select_reuseport &&
>>>> -               func_id != BPF_FUNC_map_lookup_elem)
>>>> +               func_id != BPF_FUNC_map_lookup_elem &&
>>>> +               func_id != BPF_FUNC_map_update_elem)
>>>>                      goto error;
>>>>              break;
>>>>      case BPF_MAP_TYPE_SOCKHASH:
>>>> @@ -4263,7 +4264,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>>>                  func_id != BPF_FUNC_map_delete_elem &&
>>>>                  func_id != BPF_FUNC_msg_redirect_hash &&
>>>>                  func_id != BPF_FUNC_sk_select_reuseport &&
>>>> -               func_id != BPF_FUNC_map_lookup_elem)
>>>> +               func_id != BPF_FUNC_map_lookup_elem &&
>>>> +               func_id != BPF_FUNC_map_update_elem)
>>>
>>> I lost track of a detail here, map_lookup_elem should return
>>> PTR_TO_MAP_VALUE_OR_NULL but if we want to feed that back into
>>> the map_update_elem() we need to return PTR_TO_SOCKET_OR_NULL
>>> and then presumably have a null check to get a PTR_TO_SOCKET
>>> type as expect.
>>>
>>> Can we use the same logic for expected arg (previous patch) on the
>>> ret_type. Or did I miss it:/ Need some coffee I guess.
>>
>> OK, I tracked this down. It looks like we rely on mark_ptr_or_null_reg()
>> to update the reg->tyype to PTR_TO_SOCKET. I do wonder if it would be
>> a bit more straight forward to do something similar to the previous
>> patch and refine it earlier to PTR_TO_SOCKET_OR_NULL, but should be
>> safe as-is for now.
> 
> Yes, it took me a while to figure this out as well. I think we can use
> the same approach, but I wanted to keep this series simple.
> 
>> I still have the below question though.
>>
>>>
>>>>                      goto error;
>>>>              break;
>>>>      case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
>>>> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
>>>> index 018367fb889f..b2c886c34566 100644
>>>> --- a/net/core/sock_map.c
>>>> +++ b/net/core/sock_map.c
>>>> @@ -603,6 +603,28 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key,
>>>>      return ret;
>>>>   }
>>>>
>>>> +static int sock_map_update_elem(struct bpf_map *map, void *key,
>>>> +                           void *value, u64 flags)
>>>> +{
>>>> +   struct sock *sk = (struct sock *)value;
>>>> +   int ret;
>>>> +
>>>> +   if (!sock_map_sk_is_suitable(sk))
>>>> +           return -EOPNOTSUPP;
>>>> +
>>>> +   local_bh_disable();
>>>> +   bh_lock_sock(sk);
>>>
>>> How do ensure we are not being called from some context which
>>> already has the bh_lock_sock() held? It seems we can call map_update_elem()
>>> from any context, kprobes, tc, xdp, etc.?
> 
> Yeah, to be honest I'm not entirely sure.
> 
> XDP, TC, sk_lookup are fine I think. We have bpf_sk_lookup_tcp and
> friends, but these aren't locked, and the BPF doesn't run in a context
> where there is a locked socket.
> 
> As you point out, kprobes / tracing is problematic because the probe
> _can_ run at a point where an sk is locked. If the tracing program
> somehow gets a hold of this socket via sk_lookup_* or
> a sockmap the program could deadlock.

Thanks for John to bring this up. I looked at codes a few times
but somehow missed the potential deadlock issues.

kprobes/non-iter tracing/perf_event, freplace of these kprobes etc. 
programs, may have issues. tracepoint probably not since people
probably won't add tracepoint inside a spinlock.

> 
> bpf_sock_ops is also problematic since ctx->sk is in various states of
> locking. For example, BPF_SOCK_OPS_TCP_LISTEN_CB is called with
> lock_sock held, so unproblematic. BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
> on the other hand is called with the spinlock held.
> 
> It seems to me like the only option is to instead only allow updates
> from "safe" contexts, such as XDP, tc, bpf_iter etc.

This should be okay, I think. You can start from small and then
grows as more use cases emerge.

> 
> Am I missing something?
> 
> 
>>>
>>>> +   if (!sock_map_sk_state_allowed(sk))
>>>> +           ret = -EOPNOTSUPP;
>>>> +   else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
>>>> +           ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
>>>> +   else
>>>> +           ret = sock_hash_update_common(map, key, sk, flags);
>>>> +   bh_unlock_sock(sk);
>>>> +   local_bh_enable();
>>>> +   return ret;
>>>> +}
>>>> +
>>>>   BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
>>>>         struct bpf_map *, map, void *, key, u64, flags)
>>>>   {
>>>> @@ -687,6 +709,7 @@ const struct bpf_map_ops sock_map_ops = {
>>>>      .map_free               = sock_map_free,
>>>>      .map_get_next_key       = sock_map_get_next_key,
>>>>      .map_lookup_elem_sys_only = sock_map_lookup_sys,
>>>> +   .map_update_elem        = sock_map_update_elem,
>>>>      .map_delete_elem        = sock_map_delete_elem,
>>>>      .map_lookup_elem        = sock_map_lookup,
>>>>      .map_release_uref       = sock_map_release_progs,
>>>> @@ -1180,6 +1203,7 @@ const struct bpf_map_ops sock_hash_ops = {
>>>>      .map_alloc              = sock_hash_alloc,
>>>>      .map_free               = sock_hash_free,
>>>>      .map_get_next_key       = sock_hash_get_next_key,
>>>> +   .map_update_elem        = sock_map_update_elem,
>>>>      .map_delete_elem        = sock_hash_delete_elem,
>>>>      .map_lookup_elem        = sock_hash_lookup,
>>>>      .map_lookup_elem_sys_only = sock_hash_lookup_sys,
>>>> --
>>>> 2.25.1
>>>>
>>>
>>>
>>
>>
> 
> 
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__www.cloudflare.com&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=1Gk85bZFwViEPzlsGBklXLgdbxI4Q9F505taA25KfBI&s=pcsCdyC4ZCnSqXgJJc4rjmFx1C8Hiz49KCOxDf6gagg&e=
> 
