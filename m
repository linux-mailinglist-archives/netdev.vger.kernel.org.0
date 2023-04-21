Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E016EA1AB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjDUCci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjDUCcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:32:36 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33568469F
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:32:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b4dfead1bso1576723b3a.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682044325; x=1684636325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Os9mukvCSPKKdw4nMw1R9O8vMlREwTtiShtLG9IPKE=;
        b=HCUz5FFzKFUHDPDgsikCdeCMO1zCq/dlZrN9CoWrMcHhOk5eW5mGuvAW0p45w19CZ9
         6DhK5F2Gk1GWEBSlELCPFSghDIlDSe1DGcJsa3XDYcDtdAEhjPD95OxhadNqFqLjy31a
         AEwqXTmEZj/G96t5M0pUJFRsj3q4EZINhn5IxkcSe8fP6t4MfV3qgawZfZCEP/9uKbME
         XEmL0ckKkFWmjHQeQG7hPRTo7o4ucGkjtRfjE1LcDP8ADmrc3OOqwoNwl3GOCVz2MgqQ
         qWNVGhGaMk/y7AJaDYlyWUfw2DAWzlQCWRH/UzMHCoGdZelgd211UAMLzH4/cQqVS8G9
         RY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682044325; x=1684636325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+Os9mukvCSPKKdw4nMw1R9O8vMlREwTtiShtLG9IPKE=;
        b=f5KveXIhpjquV3VT+N3pXEwG2RVStzI+8Oa3jD/N90EMUTG8nzVZAMCoLLNAGXEG+s
         FkAmAJ5HEpEwIFos2inrzMKpt5QTsQSW3Ft7HtUmJVG/e3/KaYWSFkEi5yVzn5lLa3vY
         uuZigGX8WUMhofqZNyvKPjdUTA2237QS3eI0/zNadptJhOLWICyxmryranDd+1A0s8Cb
         u9QGnWG8COMBbdPLm9HYB7j6842n5z3tuPnONt+1LIjoXk0qHH6LlWhKYEryaHKaNM0p
         wv1wzRrq9mFJC5OzazexfLoLGStvw0NiydmPn7NAixN6BMpaASVyBrXJxKJIOh7a3r3l
         3OJw==
X-Gm-Message-State: AAQBX9cI/uOZcGZZpq1JgdZnrcjHmT9PNx/zpFB+jLfc2AdXsB3C23WQ
        o3eTnpWzKGjy7odmSw5urbO2lA==
X-Google-Smtp-Source: AKy350an2piqFQ6UOXrk8jJ6gIyDjZgCDQB+P/aZgG82pfL/0ZNRMdlbfqgcUvlglP49ovd9ARWPuw==
X-Received: by 2002:a05:6a00:1acd:b0:63d:2aac:7b88 with SMTP id f13-20020a056a001acd00b0063d2aac7b88mr4799316pfv.25.1682044325691;
        Thu, 20 Apr 2023 19:32:05 -0700 (PDT)
Received: from [10.71.57.173] ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id o8-20020a62f908000000b006260526cf0csm1847551pfh.116.2023.04.20.19.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 19:32:05 -0700 (PDT)
Message-ID: <184a2930-99ee-4cbe-9d9e-2f7d7fa8a2e2@bytedance.com>
Date:   Fri, 21 Apr 2023 10:31:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [External] Re: [PATCH bpf-next 1/2] bpf: Add
 bpf_task_under_cgroup helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, yangzhenze@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>
References: <20230420072657.80324-1-zhoufeng.zf@bytedance.com>
 <20230420072657.80324-2-zhoufeng.zf@bytedance.com>
 <CAADnVQ+ffmrJCMa2R48AtJL3nT93jtKEdRv3RFeJ3Vo2L6ukQA@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQ+ffmrJCMa2R48AtJL3nT93jtKEdRv3RFeJ3Vo2L6ukQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2023/4/21 02:22, Alexei Starovoitov 写道:
> On Thu, Apr 20, 2023 at 12:27 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> This adds a bpf helper that's similar to the
>> bpf_current_task_under_cgroup. The difference is that it is a
>> designated task.
>>
>> When hook sched related functions, sometimes it is necessary to
>> specify a task instead of the current task.
>>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
>>   include/uapi/linux/bpf.h       | 13 +++++++++++++
>>   kernel/bpf/verifier.c          |  4 +++-
>>   kernel/trace/bpf_trace.c       | 31 +++++++++++++++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h | 13 +++++++++++++
>>   4 files changed, 60 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 4b20a7269bee..3d31ddb39e10 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -5550,6 +5550,18 @@ union bpf_attr {
>>    *             0 on success.
>>    *
>>    *             **-ENOENT** if the bpf_local_storage cannot be found.
>> + *
>> + * long bpf_task_under_cgroup(struct bpf_map *map, struct task_struct *task, u32 index)
>> + *     Description
>> + *             Check whether the probe is being run is the context of a given
>> + *             subset of the cgroup2 hierarchy. The cgroup2 to test is held by
>> + *             *map* of type **BPF_MAP_TYPE_CGROUP_ARRAY**, at *index*.
>> + *     Return
>> + *             The return value depends on the result of the test, and can be:
>> + *
>> + *             * 1, if assigned task belongs to the cgroup2.
>> + *             * 0, if assigned task does not belong to the cgroup2.
>> + *             * A negative error code, if an error occurred.
>>    */
>>   #define ___BPF_FUNC_MAPPER(FN, ctx...)                 \
>>          FN(unspec, 0, ##ctx)                            \
>> @@ -5764,6 +5776,7 @@ union bpf_attr {
>>          FN(user_ringbuf_drain, 209, ##ctx)              \
>>          FN(cgrp_storage_get, 210, ##ctx)                \
>>          FN(cgrp_storage_delete, 211, ##ctx)             \
>> +       FN(task_under_cgroup, 212, ##ctx)               \
>>          /* */
>>
>>   /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 1e05355facdc..1e2c3c3e8d5f 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -7771,7 +7771,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>                  break;
>>          case BPF_MAP_TYPE_CGROUP_ARRAY:
>>                  if (func_id != BPF_FUNC_skb_under_cgroup &&
>> -                   func_id != BPF_FUNC_current_task_under_cgroup)
>> +                   func_id != BPF_FUNC_current_task_under_cgroup &&
>> +                   func_id != BPF_FUNC_task_under_cgroup)
>>                          goto error;
>>                  break;
>>          case BPF_MAP_TYPE_CGROUP_STORAGE:
>> @@ -7902,6 +7903,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>                          goto error;
>>                  break;
>>          case BPF_FUNC_current_task_under_cgroup:
>> +       case BPF_FUNC_task_under_cgroup:
>>          case BPF_FUNC_skb_under_cgroup:
>>                  if (map->map_type != BPF_MAP_TYPE_CGROUP_ARRAY)
>>                          goto error;
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index bcf91bc7bf71..b02a04768824 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -814,6 +814,35 @@ static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
>>          .arg2_type      = ARG_ANYTHING,
>>   };
>>
>> +BPF_CALL_3(bpf_task_under_cgroup, struct bpf_map *, map, struct task_struct *,
>> +          task, u32, idx)
>> +{
>> +       struct bpf_array *array = container_of(map, struct bpf_array, map);
>> +       struct cgroup *cgrp;
>> +
>> +       if (unlikely(!task))
>> +               return -ENOENT;
>> +
>> +       if (unlikely(idx >= array->map.max_entries))
>> +               return -E2BIG;
>> +
>> +       cgrp = READ_ONCE(array->ptrs[idx]);
>> +       if (unlikely(!cgrp))
>> +               return -EAGAIN;
>> +
>> +       return task_under_cgroup_hierarchy(task, cgrp);
> We don't add helpers anymore.
> Please wrap task_under_cgroup_hierarchy() as a kfunc
> that takes two TRUSTED pointers task and cgroup.
Will do, thanks.
