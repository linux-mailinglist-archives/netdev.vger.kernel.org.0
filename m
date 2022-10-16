Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086896002BE
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 20:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJPSLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 14:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJPSLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 14:11:33 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF30205CB;
        Sun, 16 Oct 2022 11:11:32 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id m6so5492822qkm.4;
        Sun, 16 Oct 2022 11:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jYlc4BrVr3X8Czl+pyEy2ynMLRU37xdYjW55O3SGRyE=;
        b=Y1H+XYkzVKONT22Twebfp6F6fGBRmL/f9fU4en8bzHb3Z838Gdc+jl7qbYuFgkW4DD
         YzJDw6p4bNPPKqcBo/R630DOLJTU0rOcICu2W59yOaH8Cs7AJsMyJKGOPsAW4WBpE7OW
         XEi1yz6Y7sf2gBjanyn9SDhLY4s83sdj0PN7Tl54so8V66Stql0VbqJCJSe3CWN9SxQA
         Vb5hEUqF33drAObv0giu8GgscpsAaz22FVQI4SNLQySpdn/TMg6igYGTB/Vl+e+D8I88
         lQl8uJDAie8ilSlkw3omJeqccb2aEsk1f44D0SlT4pAWlhxJlh2bP4S2vkj5618fb777
         JjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYlc4BrVr3X8Czl+pyEy2ynMLRU37xdYjW55O3SGRyE=;
        b=Lpc/G4vBziMfUCD3pSwmS7cC6+nJ2Rjx1ubO5DLSWbx13GMhhsh2A8Em6DO59Nadq+
         Df5PEFNI2WeMKp0wwhmU81GJHJYeHhg+110Z6I4jZHMoZ1XDxr4H2qu2OK9BJnmXBulM
         +JlRVgHwGr4YDt+IQx17nuWuXWX5/rK72fDrCLmH+dITJm9kJYl/UfsupyZ1ywB44xm4
         6/B9irzbrZF3M8CrA1ygI4GjNjAa0eXUh70AluQuVY2CE2mr2ogrqdF0S6sVp8IUzHNr
         s6thfgiLYpukj0ZTOheAc9yAKO+wdblPPs0mYqGaDziGsb/OEQ+Rhsj0UWBbuHiFewKI
         kh8A==
X-Gm-Message-State: ACrzQf0GpxAbIqol5YMu/qD6jIjO8h7w5KVGhotHFjKSLuvshI/Y25KD
        QVEA6zKS9065l6b6nMmsmc8=
X-Google-Smtp-Source: AMsMyM49ghY60aHcTJdE7MSu9aNrw+eghvYy86ri0eSe4fIALxraEBcVGIwLgi7pd8uRVzFQo3ndNg==
X-Received: by 2002:a37:ae87:0:b0:6d1:debe:4cf4 with SMTP id x129-20020a37ae87000000b006d1debe4cf4mr5437692qke.655.1665943891523;
        Sun, 16 Oct 2022 11:11:31 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:12b6:f18f:f885:c4ee])
        by smtp.gmail.com with ESMTPSA id i5-20020a05622a08c500b0039bfe8acff6sm6283295qte.58.2022.10.16.11.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 11:11:30 -0700 (PDT)
Date:   Sun, 16 Oct 2022 11:11:29 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     sdf@google.com, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: Lockdep warning after c0feea594e058223973db94c1c32a830c9807c86
Message-ID: <Y0xJUc/LRu8K/Af8@pop-os.localdomain>
References: <Y0csu2SwegJ8Tab+@google.com>
 <87bkqfigzv.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkqfigzv.fsf@cloudflare.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 10:39:08PM +0200, Jakub Sitnicki wrote:
> Hi Stan,
> 
> On Wed, Oct 12, 2022 at 02:08 PM -07, sdf@google.com wrote:
> > Hi John & Jakub,
> >
> > Upstream commit c0feea594e05 ("workqueue: don't skip lockdep work
> > dependency in cancel_work_sync()") seems to trigger the following
> > lockdep warning during test_prog's sockmap_listen:
> >
> > [  +0.003631] WARNING: possible circular locking dependency detected
> 
> [...]
> 
> > Are you ware? Any idea what's wrong?
> > Is there some stable fix I'm missing in bpf-next?
> 
> Thanks for bringing it up. I didn't know.
> 
> The mentioned commit doesn't look that fresh
> 
> commit c0feea594e058223973db94c1c32a830c9807c86
> Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date:   Fri Jul 29 13:30:23 2022 +0900
> 
>     workqueue: don't skip lockdep work dependency in cancel_work_sync()
> 
> ... but then it just landed not so long ago, which explains things:
> 
> $ git describe --contains c0feea594e058223973db94c1c32a830c9807c86 --match 'v*'
> v6.0-rc7~10^2
> 
> I've untangled the call chains leading to the potential dead-lock a
> bit. There does seem to be a window of opportunity there.
> 
> psock->work.func = sk_psock_backlog()
>   ACQUIRE psock->work_mutex
>     sk_psock_handle_skb()
>       skb_send_sock()
>         __skb_send_sock()
>           sendpage_unlocked()
>             kernel_sendpage()
>               sock->ops->sendpage = inet_sendpage()
>                 sk->sk_prot->sendpage = tcp_sendpage()
>                   ACQUIRE sk->sk_lock
>                     tcp_sendpage_locked()
>                   RELEASE sk->sk_lock
>   RELEASE psock->work_mutex
> 
> sock_map_close()
>   ACQUIRE sk->sk_lock
>   sk_psock_stop()
>     sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED)
>     cancel_work_sync()
>       __cancel_work_timer()
>         __flush_work()
>           // wait for psock->work to finish
>   RELEASE sk->sk_lock
> 
> There is no fix I know of. Need to think. Ideas welcome.
> 

Thanks for the analysis.

I wonder if we can simply move this cancel_work_sync() out of sock
lock... Something like this:

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 48f4b645193b..70d6cb94e580 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -376,7 +376,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
-void sk_psock_stop(struct sk_psock *psock, bool wait);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ca70525621c7..ddc56660ce97 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -803,16 +803,13 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
-void sk_psock_stop(struct sk_psock *psock, bool wait)
+void sk_psock_stop(struct sk_psock *psock)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
 	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
-
-	if (wait)
-		cancel_work_sync(&psock->work);
 }
 
 static void sk_psock_done_strp(struct sk_psock *psock);
@@ -850,7 +847,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a660baedd9e7..81beb16ab1eb 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
@@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
-	sk_psock_put(sk, psock);
+	sk_psock_stop(psock);
 	release_sock(sk);
+	cancel_work_sync(&psock->work);
+	sk_psock_put(sk, psock);
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
