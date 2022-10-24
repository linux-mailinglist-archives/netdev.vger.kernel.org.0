Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9207C609E28
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJXJjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiJXJjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:39:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8E0167ED
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:39:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y69so9980510ede.5
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=vSob/wpwRuqflqb3iLshpo2hBXzsESt/go/728dGgK8=;
        b=qC6F21rcHdEqikV+5dB0ENzstAf8RWJcg3DkPHk4jDZhsZREqaTHs7j7vJ3cTetnPF
         9vpPY74n99On3nfNnlfFloFrH7BgXmJ/Y2kIwQT9ejEgn1Kxh7UgUEYymiYctvufPua1
         zrpvaIpqgYSXEug4sqlEuqmos0hyuzQjZAE5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSob/wpwRuqflqb3iLshpo2hBXzsESt/go/728dGgK8=;
        b=r8Ktk2QX+Gpdg3qq0WyeByA6VOOQHb7/0R3SpkQdOKAalU03+X0Pl23Z5nGHF939sI
         jc7gs7rv+QGJZZfwuDPh0JKN3SIO1xVkqoyHaU2c1jQhGm2jlA/aUp47thhESlk+Wfgq
         3EeXZZIjJJKKFYWZ7M3Vbs+GOAzFDc58fZo8gqmf6bVbEzcVbRL6JKCOr3Tu1UUAoy0C
         IyeAmum3lBV2+IARwmlNseEKsSBe7lde/PUM3bQ1YIJCOAxAm+1i8QqSGDmrRik23vaK
         33nzFm3VMVtBHd2/WOVJ4hKodyJMIE7UNrp85YA1Y4Z7e2yg7GkoGwXz90DHz4Qcg30p
         KYKg==
X-Gm-Message-State: ACrzQf2tJ9ZqMbH4C3QIwlGlPleyuVAEUAziCae+Ez/y9Do7bAGbgrID
        BI6z8HHOrYg0nqB0Z2elDLuPXg==
X-Google-Smtp-Source: AMsMyM48KNepC0k/zdSk/Byr9J2IG1zVWhcrFtRJGG4n8Hl6UNJ+pHXmaCW1BFVoJHekkA1++onVyQ==
X-Received: by 2002:a05:6402:5296:b0:461:b6e5:ea63 with SMTP id en22-20020a056402529600b00461b6e5ea63mr5291974edb.248.1666604385626;
        Mon, 24 Oct 2022 02:39:45 -0700 (PDT)
Received: from cloudflare.com (79.191.56.44.ipv4.supernova.orange.pl. [79.191.56.44])
        by smtp.gmail.com with ESMTPSA id kv2-20020a17090778c200b0077e6be40e4asm15516502ejc.175.2022.10.24.02.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:39:44 -0700 (PDT)
References: <Y0csu2SwegJ8Tab+@google.com> <87bkqfigzv.fsf@cloudflare.com>
 <Y0xJUc/LRu8K/Af8@pop-os.localdomain>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     sdf@google.com, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: Lockdep warning after c0feea594e058223973db94c1c32a830c9807c86
Date:   Mon, 24 Oct 2022 11:36:47 +0200
In-reply-to: <Y0xJUc/LRu8K/Af8@pop-os.localdomain>
Message-ID: <87ilk9ftls.fsf@cloudflare.com>
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

On Sun, Oct 16, 2022 at 11:11 AM -07, Cong Wang wrote:
> On Thu, Oct 13, 2022 at 10:39:08PM +0200, Jakub Sitnicki wrote:
>> Hi Stan,
>> 
>> On Wed, Oct 12, 2022 at 02:08 PM -07, sdf@google.com wrote:
>> > Hi John & Jakub,
>> >
>> > Upstream commit c0feea594e05 ("workqueue: don't skip lockdep work
>> > dependency in cancel_work_sync()") seems to trigger the following
>> > lockdep warning during test_prog's sockmap_listen:
>> >
>> > [  +0.003631] WARNING: possible circular locking dependency detected
>> 
>> [...]
>> 
>> > Are you ware? Any idea what's wrong?
>> > Is there some stable fix I'm missing in bpf-next?
>> 
>> Thanks for bringing it up. I didn't know.
>> 
>> The mentioned commit doesn't look that fresh
>> 
>> commit c0feea594e058223973db94c1c32a830c9807c86
>> Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Date:   Fri Jul 29 13:30:23 2022 +0900
>> 
>>     workqueue: don't skip lockdep work dependency in cancel_work_sync()
>> 
>> ... but then it just landed not so long ago, which explains things:
>> 
>> $ git describe --contains c0feea594e058223973db94c1c32a830c9807c86 --match 'v*'
>> v6.0-rc7~10^2
>> 
>> I've untangled the call chains leading to the potential dead-lock a
>> bit. There does seem to be a window of opportunity there.
>> 
>> psock->work.func = sk_psock_backlog()
>>   ACQUIRE psock->work_mutex
>>     sk_psock_handle_skb()
>>       skb_send_sock()
>>         __skb_send_sock()
>>           sendpage_unlocked()
>>             kernel_sendpage()
>>               sock->ops->sendpage = inet_sendpage()
>>                 sk->sk_prot->sendpage = tcp_sendpage()
>>                   ACQUIRE sk->sk_lock
>>                     tcp_sendpage_locked()
>>                   RELEASE sk->sk_lock
>>   RELEASE psock->work_mutex
>> 
>> sock_map_close()
>>   ACQUIRE sk->sk_lock
>>   sk_psock_stop()
>>     sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED)
>>     cancel_work_sync()
>>       __cancel_work_timer()
>>         __flush_work()
>>           // wait for psock->work to finish
>>   RELEASE sk->sk_lock
>> 
>> There is no fix I know of. Need to think. Ideas welcome.
>> 
>
> Thanks for the analysis.
>
> I wonder if we can simply move this cancel_work_sync() out of sock
> lock... Something like this:

[...]

> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index a660baedd9e7..81beb16ab1eb 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
>  	saved_destroy = psock->saved_destroy;
>  	sock_map_remove_links(sk, psock);
>  	rcu_read_unlock();
> -	sk_psock_stop(psock, false);
> +	sk_psock_stop(psock);
>  	sk_psock_put(sk, psock);
>  	saved_destroy(sk);
>  }
> @@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
>  	saved_close = psock->saved_close;
>  	sock_map_remove_links(sk, psock);
>  	rcu_read_unlock();
> -	sk_psock_stop(psock, true);
> -	sk_psock_put(sk, psock);
> +	sk_psock_stop(psock);
>  	release_sock(sk);
> +	cancel_work_sync(&psock->work);
> +	sk_psock_put(sk, psock);
>  	saved_close(sk, timeout);
>  }
>  EXPORT_SYMBOL_GPL(sock_map_close);

Sorry for the delay. I've been out.

Great idea. I don't see why not.
