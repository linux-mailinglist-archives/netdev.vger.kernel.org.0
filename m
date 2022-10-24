Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A95060B31A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJXQ4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbiJXQzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:55:14 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8561AFAA1
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:36:04 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id bs14so13289273ljb.9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=tn+PruS5YkjgRdlQM1NrKYabae3GPv6yAwzdf/vH2qw=;
        b=qvLC/Gs3f8bKWsi127OF67B4xQzw9e+5EtSujWYcaQRlA1hUaAHHTtc+vKkP9gQZzF
         +uXXfY5TYrJH0kLHuX8q0yXTlMLpkqYZasLsHe/iQbxFrb+GQ3EeIY1pbDwyIv9iFM0w
         TvTcLpYjo7ts08ZNCEIBlapAtP2bAkF/bjrzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tn+PruS5YkjgRdlQM1NrKYabae3GPv6yAwzdf/vH2qw=;
        b=5hW2RABNOQwELqpKdt8zN/FnqqZFqJUGKUBOn1YaEkpIK029Ztx2onvYm8HDq/sxlh
         5aX/wBAg2Vw5qffEasd+tx6Qr5K2Ih79fi2OxM7RmZ+GWBpljDr4y4hJpPdvutZzwK/1
         GOr32fYqp780yfAG/d7WSPUlcYd5ds4zVTVgxV/Bp4kl2g/mWlZxoBOCtgBREFT0ouDr
         GzF6DGjgtE2EVKCtnLJt0kmHdRt0TAbWf7V25J4GqOI+VXsohnlnqntwOR4vcCAbKsul
         RHV+HMz/ym5+LcEM9PibmO48xCFWYptCEoCFY9q383kUhUVL99wxgRj6ViogdQkFXk+R
         8FPQ==
X-Gm-Message-State: ACrzQf3wffKcXS/psBpR0gI7R1boP4RIiUIEzDkkvC8JYxtp3Fyuaxks
        8bfHm3cMA91Gbmio/g0rvMkZILMtorevdQ==
X-Google-Smtp-Source: AMsMyM7vLKEGSyFAd6KE8ZpZLgiNjBMV/2/VSiRsKbmflkxQR+L+0Apgb9GGnxEacK5xJO519Ov8DA==
X-Received: by 2002:a17:906:cc5b:b0:7a9:e58d:bad9 with SMTP id mm27-20020a170906cc5b00b007a9e58dbad9mr2534869ejb.237.1666618756811;
        Mon, 24 Oct 2022 06:39:16 -0700 (PDT)
Received: from cloudflare.com (79.191.56.44.ipv4.supernova.orange.pl. [79.191.56.44])
        by smtp.gmail.com with ESMTPSA id la5-20020a170907780500b0077f20a722dfsm15657874ejc.165.2022.10.24.06.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 06:39:16 -0700 (PDT)
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <cong.wang@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Date:   Mon, 24 Oct 2022 15:33:13 +0200
In-reply-to: <Y07sxzoS/s6ZBhEx@google.com>
Message-ID: <87eduxfiik.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
> On 10/17, Cong Wang wrote:
>> From: Cong Wang <cong.wang@bytedance.com>
>
>> Technically we don't need lock the sock in the psock work, but we
>> need to prevent this work running in parallel with sock_map_close().
>
>> With this, we no longer need to wait for the psock->work synchronously,
>> because when we reach here, either this work is still pending, or
>> blocking on the lock_sock(), or it is completed. We only need to cancel
>> the first case asynchronously, and we need to bail out the second case
>> quickly by checking SK_PSOCK_TX_ENABLED bit.
>
>> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
>> Reported-by: Stanislav Fomichev <sdf@google.com>
>> Cc: John Fastabend <john.fastabend@gmail.com>
>> Cc: Jakub Sitnicki <jakub@cloudflare.com>
>> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>
> This seems to remove the splat for me:
>
> Tested-by: Stanislav Fomichev <sdf@google.com>
>
> The patch looks good, but I'll leave the review to Jakub/John.

I can't poke any holes in it either.

However, it is harder for me to follow than the initial idea [1].
So I'm wondering if there was anything wrong with it?

This seems like a step back when comes to simplifying locking in
sk_psock_backlog() that was done in 799aa7f98d53.

[1] https://lore.kernel.org/bpf/87ilk9ftls.fsf@cloudflare.com/T/#md486941e228a1b29729dba842ccd396c2c07d9fd

>
>> ---
>>   include/linux/skmsg.h |  2 +-
>>   net/core/skmsg.c      | 19 +++++++++++++------
>>   net/core/sock_map.c   |  4 ++--
>>   3 files changed, 16 insertions(+), 9 deletions(-)
>
>> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
>> index 48f4b645193b..70d6cb94e580 100644
>> --- a/include/linux/skmsg.h
>> +++ b/include/linux/skmsg.h
>> @@ -376,7 +376,7 @@ static inline void sk_psock_report_error(struct  sk_psock
>> *psock, int err)
>>   }
>
>>   struct sk_psock *sk_psock_init(struct sock *sk, int node);
>> -void sk_psock_stop(struct sk_psock *psock, bool wait);
>> +void sk_psock_stop(struct sk_psock *psock);
>
>>   #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
>>   int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
>> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
>> index ca70525621c7..c329e71ea924 100644
>> --- a/net/core/skmsg.c
>> +++ b/net/core/skmsg.c
>> @@ -647,6 +647,11 @@ static void sk_psock_backlog(struct work_struct  *work)
>>   	int ret;
>
>>   	mutex_lock(&psock->work_mutex);
>> +	lock_sock(psock->sk);
>> +
>> +	if (!sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
>> +		goto end;
>> +
>>   	if (unlikely(state->skb)) {
>>   		spin_lock_bh(&psock->ingress_lock);
>>   		skb = state->skb;
>> @@ -672,9 +677,12 @@ static void sk_psock_backlog(struct work_struct  *work)
>>   		skb_bpf_redirect_clear(skb);
>>   		do {
>>   			ret = -EIO;
>> -			if (!sock_flag(psock->sk, SOCK_DEAD))
>> +			if (!sock_flag(psock->sk, SOCK_DEAD)) {
>> +				release_sock(psock->sk);
>>   				ret = sk_psock_handle_skb(psock, skb, off,
>>   							  len, ingress);
>> +				lock_sock(psock->sk);
>> +			}
>>   			if (ret <= 0) {
>>   				if (ret == -EAGAIN) {
>>   					sk_psock_skb_state(psock, state, skb,
>> @@ -695,6 +703,7 @@ static void sk_psock_backlog(struct work_struct *work)
>>   			kfree_skb(skb);
>>   	}
>>   end:
>> +	release_sock(psock->sk);
>>   	mutex_unlock(&psock->work_mutex);
>>   }
>
>> @@ -803,16 +812,14 @@ static void sk_psock_link_destroy(struct sk_psock
>> *psock)
>>   	}
>>   }
>
>> -void sk_psock_stop(struct sk_psock *psock, bool wait)
>> +void sk_psock_stop(struct sk_psock *psock)
>>   {
>>   	spin_lock_bh(&psock->ingress_lock);
>>   	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
>>   	sk_psock_cork_free(psock);
>>   	__sk_psock_zap_ingress(psock);
>>   	spin_unlock_bh(&psock->ingress_lock);
>> -
>> -	if (wait)
>> -		cancel_work_sync(&psock->work);
>> +	cancel_work(&psock->work);
>>   }
>
>>   static void sk_psock_done_strp(struct sk_psock *psock);
>> @@ -850,7 +857,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock
>> *psock)
>>   		sk_psock_stop_verdict(sk, psock);
>>   	write_unlock_bh(&sk->sk_callback_lock);
>
>> -	sk_psock_stop(psock, false);
>> +	sk_psock_stop(psock);
>
>>   	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
>>   	queue_rcu_work(system_wq, &psock->rwork);
>> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
>> index a660baedd9e7..d4e11d7f459c 100644
>> --- a/net/core/sock_map.c
>> +++ b/net/core/sock_map.c
>> @@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
>>   	saved_destroy = psock->saved_destroy;
>>   	sock_map_remove_links(sk, psock);
>>   	rcu_read_unlock();
>> -	sk_psock_stop(psock, false);
>> +	sk_psock_stop(psock);
>>   	sk_psock_put(sk, psock);
>>   	saved_destroy(sk);
>>   }
>> @@ -1619,7 +1619,7 @@ void sock_map_close(struct sock *sk, long timeout)
>>   	saved_close = psock->saved_close;
>>   	sock_map_remove_links(sk, psock);
>>   	rcu_read_unlock();
>> -	sk_psock_stop(psock, true);
>> +	sk_psock_stop(psock);
>>   	sk_psock_put(sk, psock);
>>   	release_sock(sk);
>>   	saved_close(sk, timeout);
>> --
>> 2.34.1

