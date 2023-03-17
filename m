Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3729A6BF5FA
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 00:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCQXHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 19:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCQXHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 19:07:31 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AFA298C5;
        Fri, 17 Mar 2023 16:07:26 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id ix20so6881169plb.3;
        Fri, 17 Mar 2023 16:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679094446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C64UcAB/whbGGHIdvNFyF6L32ISLaky5hb0iGmC3r3U=;
        b=KaiJwKod5fmmNHCdHqy+e7t8aHOhfe7xHBK0NFgc8zuEckpp5TweA9T7/k86ugkWN1
         rtiXQn9Jp1OvEiCAMpRjcsXJ7WN81eiOtvAZBEAScvBI92ZS+egHirTL8HrYJ9C0kHG6
         e2bzHeEh0KVFrhsaMmyz3pMQ2XAMbyVh+QOQkFPSIxB8H8fb8MEjjgWZk9XFdYyrPO3l
         ojGUkezp/SRlZmFWTymCH3q1dXDqh6uWukQHWRH8/doFJr1nPLfGfUw1nMLzWHThPDQP
         aekACNWwCLPJu05chZsBDn6eoSMtwms2c0PdOdaQmdu3oUhgkQV+XKd2aoDgYjK6cyPF
         xwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679094446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C64UcAB/whbGGHIdvNFyF6L32ISLaky5hb0iGmC3r3U=;
        b=YjC8gOhcmAUXrDm3z7OenaixNR1nNCxJ4PBRhXl1g9ILRfRyduh1mPbZ9vMFXS7EWA
         HtvEWeynUaL7LDZpRMqbaJs9s+fiLpnmfYMRx5tM88Tm1uvf/mycdkRFDB3tuT4Scoi8
         8qdqsSB3ZivbZwaKG4Hgap/0OawHPAgoQh0ZKV8XoKPf0v0tcIhSsNrCWvfJ/06x1aXD
         zSZs/lub0DilSVX9sLI38t39I8txnq5G2XO9iuHmaEum2RWw3PtMyrPPzwM1EiFg342j
         ux/kkhsXIXDoqfELvt9GArQrsPQ6BkbuCK8SdKU7GLGDcboJaW3jSxWHeofcUr945Ll2
         t/9w==
X-Gm-Message-State: AO0yUKUOZXLgTa9QdxETUMuk/X7Udd2MIb/pBGqvNmAvpNEPKSBHp34t
        vnVW6vOiX0/ZJieYT/Z7EkQ=
X-Google-Smtp-Source: AK7set9uyfZbQiCkA81v6mvakXZgwhG7+yQNnGlOUi/HvF3QwPdrDW5b7ibPXf/oEHC0AE1BL9UTbw==
X-Received: by 2002:a17:903:22d2:b0:19e:ba2c:27ec with SMTP id y18-20020a17090322d200b0019eba2c27ecmr10073886plg.11.1679094445774;
        Fri, 17 Mar 2023 16:07:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e8::1380? ([2620:10d:c090:400::5:87c3])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902b7c300b0019fcece6847sm2022912plz.227.2023.03.17.16.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 16:07:25 -0700 (PDT)
Message-ID: <4271f277-ec08-ea15-4c7b-8c5147db6308@gmail.com>
Date:   Fri, 17 Mar 2023 16:07:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v7 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US, en-ZW
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kui-Feng Lee <kuifeng@meta.com>, bpf@vger.kernel.org,
        ast@kernel.org, martin.lau@linux.dev, song@kernel.org,
        kernel-team@meta.com, andrii@kernel.org, sdf@google.com
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
References: <20230316023641.2092778-1-kuifeng@meta.com>
 <20230316023641.2092778-3-kuifeng@meta.com>
 <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
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



On 3/17/23 08:23, Daniel Borkmann wrote:
> On 3/16/23 3:36 AM, Kui-Feng Lee wrote:
>> This feature lets you immediately transition to another congestion
>> control algorithm or implementation with the same name.  Once a name
>> is updated, new connections will apply this new algorithm.
>>
>> The purpose is to update a customized algorithm implemented in BPF
>> struct_ops with a new version on the flight.  The following is an
>> example of using the userspace API implemented in later BPF patches.
>>
>>     link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
>>     .......
>>     err = bpf_link__update_map(link, skel->maps.ca_update_2);
>>
>> We first load and register an algorithm implemented in BPF struct_ops,
>> then swap it out with a new one using the same name. After that, newly
>> created connections will apply the updated algorithm, while older ones
>> retain the previous version already applied.
>>
>> This patch also takes this chance to refactor the ca validation into
>> the new tcp_validate_congestion_control() function.
>>
>> Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
>> ---
>>   include/net/tcp.h   |  3 +++
>>   net/ipv4/tcp_cong.c | 60 +++++++++++++++++++++++++++++++++++++++------
>>   2 files changed, 56 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index db9f828e9d1e..2abb755e6a3a 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -1117,6 +1117,9 @@ struct tcp_congestion_ops {
>>   int tcp_register_congestion_control(struct tcp_congestion_ops *type);
>>   void tcp_unregister_congestion_control(struct tcp_congestion_ops 
>> *type);
>> +int tcp_update_congestion_control(struct tcp_congestion_ops *type,
>> +                  struct tcp_congestion_ops *old_type);
>> +int tcp_validate_congestion_control(struct tcp_congestion_ops *ca);
>>   void tcp_assign_congestion_control(struct sock *sk);
>>   void tcp_init_congestion_control(struct sock *sk);
>> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
>> index db8b4b488c31..c90791ae8389 100644
>> --- a/net/ipv4/tcp_cong.c
>> +++ b/net/ipv4/tcp_cong.c
>> @@ -75,14 +75,8 @@ struct tcp_congestion_ops *tcp_ca_find_key(u32 key)
>>       return NULL;
>>   }
>> -/*
>> - * Attach new congestion control algorithm to the list
>> - * of available options.
>> - */
>> -int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
>> +int tcp_validate_congestion_control(struct tcp_congestion_ops *ca)
>>   {
>> -    int ret = 0;
>> -
>>       /* all algorithms must implement these */
>>       if (!ca->ssthresh || !ca->undo_cwnd ||
>>           !(ca->cong_avoid || ca->cong_control)) {
>> @@ -90,6 +84,20 @@ int tcp_register_congestion_control(struct 
>> tcp_congestion_ops *ca)
>>           return -EINVAL;
>>       }
>> +    return 0;
>> +}
>> +
>> +/* Attach new congestion control algorithm to the list
>> + * of available options.
>> + */
>> +int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
>> +{
>> +    int ret;
>> +
>> +    ret = tcp_validate_congestion_control(ca);
>> +    if (ret)
>> +        return ret;
>> +
>>       ca->key = jhash(ca->name, sizeof(ca->name), strlen(ca->name));
>>       spin_lock(&tcp_cong_list_lock);
>> @@ -130,6 +138,44 @@ void tcp_unregister_congestion_control(struct 
>> tcp_congestion_ops *ca)
>>   }
>>   EXPORT_SYMBOL_GPL(tcp_unregister_congestion_control);
>> +/* Replace a registered old ca with a new one.
>> + *
>> + * The new ca must have the same name as the old one, that has been
>> + * registered.
>> + */
>> +int tcp_update_congestion_control(struct tcp_congestion_ops *ca, 
>> struct tcp_congestion_ops *old_ca)
>> +{
>> +    struct tcp_congestion_ops *existing;
>> +    int ret;
>> +
>> +    ret = tcp_validate_congestion_control(ca);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ca->key = jhash(ca->name, sizeof(ca->name), strlen(ca->name));
>> +
>> +    spin_lock(&tcp_cong_list_lock);
>> +    existing = tcp_ca_find_key(old_ca->key);
>> +    if (ca->key == TCP_CA_UNSPEC || !existing || 
>> strcmp(existing->name, ca->name)) {
>> +        pr_notice("%s not registered or non-unique key\n",
>> +              ca->name);
>> +        ret = -EINVAL;
>> +    } else if (existing != old_ca) {
>> +        pr_notice("invalid old congestion control algorithm to 
>> replace\n");
>> +        ret = -EINVAL;
>> +    } else {
>> +        /* Add the new one before removing the old one to keep
>> +         * one implementation available all the time.
>> +         */
>> +        list_add_tail_rcu(&ca->list, &tcp_cong_list);
>> +        list_del_rcu(&existing->list);
>> +        pr_debug("%s updated\n", ca->name);
>> +    }
>> +    spin_unlock(&tcp_cong_list_lock);
>> +
>> +    return ret;
>> +}
> 
> Was wondering if we could have tcp_register_congestion_control and 
> tcp_update_congestion_control
> could be refactored for reuse. Maybe like below. From the function 
> itself what is not clear whether
> callers that replace an existing one should do the synchronize_rcu() 
> themselves or if this should
> be part of tcp_update_congestion_control?
> 
> int tcp_check_congestion_control(struct tcp_congestion_ops *ca)
> {
>      /* All algorithms must implement these. */
>      if (!ca->ssthresh || !ca->undo_cwnd ||
>          !(ca->cong_avoid || ca->cong_control)) {
>          pr_err("%s does not implement required ops\n", ca->name);
>          return -EINVAL;
>      }
>      if (ca->key == TCP_CA_UNSPEC)
>          ca->key = jhash(ca->name, sizeof(ca->name), strlen(ca->name));
>      if (ca->key == TCP_CA_UNSPEC) {
>          pr_notice("%s results in zero key\n", ca->name);
>          return -EEXIST;
>      }
>      return 0;
> }
> 
> /* Attach new congestion control algorithm to the list of available
>   * options or replace an existing one if old is non-NULL.
>   */
> int tcp_update_congestion_control(struct tcp_congestion_ops *new,
>                    struct tcp_congestion_ops *old)
> {
>      struct tcp_congestion_ops *found;
>      int ret;
> 
>      ret = tcp_check_congestion_control(new);
>      if (ret)
>          return ret;
>      if (old &&
>          (old->key != new->key ||
>           strcmp(old->name, new->name))) {
>          pr_notice("%s & %s have non-matching congestion control names\n",
>                old->name, new->name);
>          return -EINVAL;
>      }
>      spin_lock(&tcp_cong_list_lock);
>      found = tcp_ca_find_key(new->key); >      if (old) {
>          if (found == old) {
>              list_add_tail_rcu(&new->list, &tcp_cong_list);
>              list_del_rcu(&old->list);
>          } else {
>              pr_notice("%s not registered\n", old->name);
>              ret = -EINVAL;
>          }
>      } else {
>          if (found) {
>              pr_notice("%s already registered\n", new->name);
>              ret = -EEXIST;
>          } else {
>              list_add_tail_rcu(&new->list, &tcp_cong_list);
>          }
>      }
>      spin_unlock(&tcp_cong_list_lock);
>      return ret;
> }

After trying to do this refactoring, I found it just shares a few lines
of code, but make thing complicated by adding more checks.  So, I prefer
to keep it as it is.  How do you think?


> 
> int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
> {
>      return tcp_update_congestion_control(ca, NULL);
> }
> EXPORT_SYMBOL_GPL(tcp_register_congestion_control);
