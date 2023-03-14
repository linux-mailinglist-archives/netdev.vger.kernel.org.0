Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4816B89A5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 05:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCNEb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 00:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNEbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 00:31:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C20564854;
        Mon, 13 Mar 2023 21:31:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kb15so14195584pjb.1;
        Mon, 13 Mar 2023 21:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678768283;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z0fiSNKtWLGW2f4s7r8bTWgjxs5ym4KSK8uJbM4/y18=;
        b=ArYuvTamlHhvmlx7mJZ67IGyQxjMXmc2ITNXsd6iESDWffGVZjtKjFMJRnuPnCuOB/
         5f7avLCqKrWC2sSzqsnDwf1NDYl+OX0dfOh1bRhaT3jimkRoHCFETsH/LBfcDeAoXpb7
         asNQKr1eTbTyq56/Y/whCLo/U/md/Hrw0/aDv14UZkvqCKbBDaRtAUveKET4HBVLFXV+
         gHCwcNUKViKeNoUgYJkKVKRVCHzb3v8mDfYS/ie/0bBimPihx77ARP8sCgBl1pm4TRMJ
         bVKATB9beeobmpoxEooYj37m6aIYMvUN/BsOWBn2MSh3qVDvlEJWYbtw3zCKb/yrFvRQ
         wFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678768283;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z0fiSNKtWLGW2f4s7r8bTWgjxs5ym4KSK8uJbM4/y18=;
        b=Zkic+zG1QZ/PJhHyCcAup7ygBEzj6LxOruPx0GemOuww3EVXrH+7GjjmheuZrkQesC
         tSjxH8nwricTbE9RaVoRCiETwZ6pVp+j19iHcNwKxA71MDoRQcS3bgLgTcfiYG6bZIDl
         /wGV0++wmyZplcBo6Fhhquaj8cZnoXifxEKKiM52R3CEgggHzdGYMgen5UKNM/WZDBCx
         GXKG+goAXJCEAtvAqeByYZRc879Hz8K85BedxnVNPswSZBPzUEkdae+1ME1NlCOfRT4P
         P36TY1/RsoM2O7NKh9thvqnTIrhAJEgQw5/Yt28o2T7Jz/wxcz6yYz2hVmmEuVwmE58p
         CYLg==
X-Gm-Message-State: AO0yUKVRBArQE+Bqx0xh4i1aBRgLB7NwsWxzgsg9MG1IuzDRDF5mk34N
        zVJuZ8lsMM2qmaGxC/B25TU=
X-Google-Smtp-Source: AK7set+7e/Zyroph6dN91TMPP3+J5jC3Y7hrDAwrYPbX9PH1R7AOtd+OYjyTWltcbTnlKfKeilyOmw==
X-Received: by 2002:a17:902:714b:b0:19c:d97f:5d20 with SMTP id u11-20020a170902714b00b0019cd97f5d20mr28898377plm.38.1678768282725;
        Mon, 13 Mar 2023 21:31:22 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e8::12e7? ([2620:10d:c090:400::5:541e])
        by smtp.gmail.com with ESMTPSA id v8-20020a170902b7c800b001994fc55998sm618727plz.217.2023.03.13.21.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 21:31:22 -0700 (PDT)
Message-ID: <31abe375-d844-8776-6fd5-7b9ab5348a4c@gmail.com>
Date:   Mon, 13 Mar 2023 21:31:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v6 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US, en-ZW
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Kui-Feng Lee <kuifeng@meta.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        song@kernel.org, kernel-team@meta.com, andrii@kernel.org,
        sdf@google.com
References: <20230310043812.3087672-1-kuifeng@meta.com>
 <20230310043812.3087672-3-kuifeng@meta.com>
 <d6af02bb-f1e6-79a9-33b6-292c486f5684@linux.dev>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <d6af02bb-f1e6-79a9-33b6-292c486f5684@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/23 17:28, Martin KaFai Lau wrote:
> On 3/9/23 8:38 PM, Kui-Feng Lee wrote:
>> This feature lets you immediately transition to another congestion
>> control algorithm or implementation with the same name.  Once a name
>> is updated, new connections will apply this new algorithm.
> 
> The commit message needs to explain why the change is needed and some 
> major details on how the patch is doing it. In this case, why a later 
> bpf patch needs it and what major changes are made to tcp_cong.c.
> 
> For example,
> 
> A later bpf patch will allow attaching a bpf_struct_ops (TCP Congestion 
> Control implemented in bpf) to bpf_link. The later bpf patch will also 
> use the existing bpf_link API to replace a bpf_struct_ops (ie. to 
> replace an old tcp-cc with a new tcp-cc under the same name). This 
> requires a helper function to replace a tcp-cc under a 
> tcp_cong_list_lock. Thus, this patch adds a 
> tcp_update_congestion_control() to replace the "old_ca" with a new "ca".
> 
> This patch also takes this chance to refactor the ca validation into the 
> new tcp_validate_congestion_control() function.


Sure!

> 
>>
>> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
>> ---
>>   include/linux/bpf.h            |  1 +
>>   include/net/tcp.h              |  2 ++
>>   net/bpf/bpf_dummy_struct_ops.c |  6 ++++
>>   net/ipv4/bpf_tcp_ca.c          |  6 ++++
>>   net/ipv4/tcp_cong.c            | 60 ++++++++++++++++++++++++++++++----
>>   5 files changed, 68 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 00ca92ea6f2e..0f84925d66db 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1511,6 +1511,7 @@ struct bpf_struct_ops {
>>                  void *kdata, const void *udata);
>>       int (*reg)(void *kdata);
>>       void (*unreg)(void *kdata);
>> +    int (*update)(void *kdata, void *old_kdata);
>>       const struct btf_type *type;
>>       const struct btf_type *value_type;
>>       const char *name;
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index db9f828e9d1e..239cc0e2639c 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -1117,6 +1117,8 @@ struct tcp_congestion_ops {
>>   int tcp_register_congestion_control(struct tcp_congestion_ops *type);
>>   void tcp_unregister_congestion_control(struct tcp_congestion_ops 
>> *type);
>> +int tcp_update_congestion_control(struct tcp_congestion_ops *type,
>> +                  struct tcp_congestion_ops *old_type);
>>   void tcp_assign_congestion_control(struct sock *sk);
>>   void tcp_init_congestion_control(struct sock *sk);
>> diff --git a/net/bpf/bpf_dummy_struct_ops.c 
>> b/net/bpf/bpf_dummy_struct_ops.c
>> index ff4f89a2b02a..158f14e240d0 100644
>> --- a/net/bpf/bpf_dummy_struct_ops.c
>> +++ b/net/bpf/bpf_dummy_struct_ops.c
>> @@ -222,12 +222,18 @@ static void bpf_dummy_unreg(void *kdata)
>>   {
>>   }
>> +static int bpf_dummy_update(void *kdata, void *old_kdata)
>> +{
>> +    return -EOPNOTSUPP;
>> +}
>> +
>>   struct bpf_struct_ops bpf_bpf_dummy_ops = {
>>       .verifier_ops = &bpf_dummy_verifier_ops,
>>       .init = bpf_dummy_init,
>>       .check_member = bpf_dummy_ops_check_member,
>>       .init_member = bpf_dummy_init_member,
>>       .reg = bpf_dummy_reg,
>> +    .update = bpf_dummy_update,
>>       .unreg = bpf_dummy_unreg,
>>       .name = "bpf_dummy_ops",
>>   };
>> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
>> index 13fc0c185cd9..66ce5fadfe42 100644
>> --- a/net/ipv4/bpf_tcp_ca.c
>> +++ b/net/ipv4/bpf_tcp_ca.c
>> @@ -266,10 +266,16 @@ static void bpf_tcp_ca_unreg(void *kdata)
>>       tcp_unregister_congestion_control(kdata);
>>   }
>> +static int bpf_tcp_ca_update(void *kdata, void *old_kdata)
>> +{
>> +    return tcp_update_congestion_control(kdata, old_kdata);
>> +}
>> +
>>   struct bpf_struct_ops bpf_tcp_congestion_ops = {
>>       .verifier_ops = &bpf_tcp_ca_verifier_ops,
>>       .reg = bpf_tcp_ca_reg,
>>       .unreg = bpf_tcp_ca_unreg,
>> +    .update = bpf_tcp_ca_update,
> 
> In v5, a comment was given to move the ".update" related changes to 
> patch 5 such that patch 2 will only have netdev change in tcp_cong.c for 
> review purpose.
> 
> Please ensure the earlier review comment is addressed in the next 
> revision or reply if the earlier review comment does not make sense. 
> This will save time for the reviewer not to have to repeat the same 
> comment again.

Sorry about this.  I only addressed .validate and missed .update.
Will fix this.

> 
>>       .check_member = bpf_tcp_ca_check_member,
>>       .init_member = bpf_tcp_ca_init_member,
>>       .init = bpf_tcp_ca_init,
> 
> 
