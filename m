Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD04B618AAC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKCVgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKCVgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:36:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE4A21E2F;
        Thu,  3 Nov 2022 14:36:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b11so2892589pjp.2;
        Thu, 03 Nov 2022 14:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7GUBiiKpfQ3HTf3sZloKJzQ8N14tQccpRdkJfkzLDU=;
        b=KQPjEpy9VVQ5k3LusQUuzeH8Pe3JCwa9+JO7MjxikUXoDUgM67vZSsy5VMTzkOacJ2
         oDEH6tfiLSudAz7dOJ+DWZC1hmTl7wczwW/w3jZK2Nz383bhjm4ffaKRNJWufK3ri9fk
         0h+glOrKo4niDu8WtbDq6recIPxkptJjEqRJr9XUMPywnm97V97K8PXjcZDjh9wbANKO
         BuHDLNrFdQxnFf6uiWpugALqNxlqY4EQt72qkFixitKHzuQwoOeUkn0HBl3yO504yrJP
         T+h+gMCJhi0j8IUpxEIu6IGwTPPBo/Av1YDvxh8cnq/bdnzAFmKIc3/UJXtGifOe6/4f
         SMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z7GUBiiKpfQ3HTf3sZloKJzQ8N14tQccpRdkJfkzLDU=;
        b=3nliGTJwc+GKVX+LrSaKZUBvAUgqZ8sHTaK8pUptYErGzOUL+vP8czT+4j+5brB3xg
         4KgaRmB1mZmhkO7GsJbjoAO1kRwjmpPD8dMzv894GKp4RcUkjkr5IXaqDfBf/I/YTpvB
         dO2funm1iMpIP8ylUYnihVFv+88hstGzr4q/r6Fi/37NlZNkpPtWJzWCWnBShhmJiZXk
         SUCVgsYg6hxUDDFAH4kuYkrXao9y7Bg89mRC0lUmmzLRXlZzEjFyY4Tb0p0PTjVSj4Za
         PDG3jERRtNIUC6h1vpJ7h6RqOfKnfb+DZPa2Qdh5nmi0oeYlpcXPecFtEOl91SyZqE4v
         cdjg==
X-Gm-Message-State: ACrzQf3dhevY3DIqw8E3Nk4PfbQ4FqbYa0O74z4devvDH6FCKywMFSBC
        yP4ATj9X2JQJXS6mf1g/OyA=
X-Google-Smtp-Source: AMsMyM43FeFXpgD7qbJyeeq1J4FAwhA0rBJmE3UGB32w8iOXYg2fP+oQ6r2RkO4hf+PpAQPeSL9Bog==
X-Received: by 2002:a17:902:9891:b0:17f:e1d0:45e7 with SMTP id s17-20020a170902989100b0017fe1d045e7mr198778plp.16.1667511371800;
        Thu, 03 Nov 2022 14:36:11 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id k4-20020a17090a39c400b00211d5f93029sm452523pjf.24.2022.11.03.14.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:36:11 -0700 (PDT)
Date:   Thu, 03 Nov 2022 14:36:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <63643449b978a_204d620851@john.notmuch>
In-Reply-To: <87a6574yz0.fsf@cloudflare.com>
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com>
 <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
 <87bkprprxf.fsf@cloudflare.com>
 <63617b2434725_2eb7208e1@john.notmuch>
 <87a6574yz0.fsf@cloudflare.com>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, Nov 01, 2022 at 01:01 PM -07, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
> >> > On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
> >> >> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
> >> >> > On 10/17, Cong Wang wrote:
> >> >> >> From: Cong Wang <cong.wang@bytedance.com>
> >> >> >
> >> >> >> Technically we don't need lock the sock in the psock work, but we
> >> >> >> need to prevent this work running in parallel with sock_map_close().
> >> >> >
> >> >> >> With this, we no longer need to wait for the psock->work synchronously,
> >> >> >> because when we reach here, either this work is still pending, or
> >> >> >> blocking on the lock_sock(), or it is completed. We only need to cancel
> >> >> >> the first case asynchronously, and we need to bail out the second case
> >> >> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
> >> >> >
> >> >> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> >> >> >> Reported-by: Stanislav Fomichev <sdf@google.com>
> >> >> >> Cc: John Fastabend <john.fastabend@gmail.com>
> >> >> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> >> >> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> >> >> >
> >> >> > This seems to remove the splat for me:
> >> >> >
> >> >> > Tested-by: Stanislav Fomichev <sdf@google.com>
> >> >> >
> >> >> > The patch looks good, but I'll leave the review to Jakub/John.
> >> >> 
> >> >> I can't poke any holes in it either.
> >> >> 
> >> >> However, it is harder for me to follow than the initial idea [1].
> >> >> So I'm wondering if there was anything wrong with it?
> >> >
> >> > It caused a warning in sk_stream_kill_queues() when I actually tested
> >> > it (after posting).
> >> 
> >> We must have seen the same warnings. They seemed unrelated so I went
> >> digging. We have a fix for these [1]. They were present since 5.18-rc1.
> >> 
> >> >> This seems like a step back when comes to simplifying locking in
> >> >> sk_psock_backlog() that was done in 799aa7f98d53.
> >> >
> >> > Kinda, but it is still true that this sock lock is not for sk_socket
> >> > (merely for closing this race condition).
> >> 
> >> I really think the initial idea [2] is much nicer. I can turn it into a
> >> patch, if you are short on time.
> >> 
> >> With [1] and [2] applied, the dead lock and memory accounting warnings
> >> are gone, when running `test_sockmap`.
> >> 
> >> Thanks,
> >> Jakub
> >> 
> >> [1] https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
> >> [2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/
> >
> > Cong, what do you think? I tend to agree [2] looks nicer to me.
> >
> > @Jakub,
> >
> > Also I think we could simply drop the proposed cancel_work_sync in
> > sock_map_close()?
> >
> >  }
> > @@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
> >  	saved_close = psock->saved_close;
> >  	sock_map_remove_links(sk, psock);
> >  	rcu_read_unlock();
> > -	sk_psock_stop(psock, true);
> > -	sk_psock_put(sk, psock);
> > +	sk_psock_stop(psock);
> >  	release_sock(sk);
> > +	cancel_work_sync(&psock->work);
> > +	sk_psock_put(sk, psock);
> >  	saved_close(sk, timeout);
> >  }
> >
> > The sk_psock_put is going to cancel the work before destroying the psock,
> >
> >  sk_psock_put()
> >    sk_psock_drop()
> >      queue_rcu_work(system_wq, psock->rwork)
> >
> > and then in callback we
> >
> >   sk_psock_destroy()
> >     cancel_work_synbc(psock->work)
> >
> > although it might be nice to have the work cancelled earlier rather than
> > latter maybe.
> 
> Good point.
> 
> I kinda like the property that once close() returns we know there is no
> deferred work running for the socket.
> 
> I find the APIs where a deferred cleanup happens sometimes harder to
> write tests for.
> 
> But I don't really have a strong opinion here.

I don't either and Cong left it so I'm good with that.

Reviewing backlog logic though I think there is another bug there, but
I haven't been able to trigger it in any of our tests.

The sk_psock_backlog() logic is,

 sk_psock_backlog(struct work_struct *work)
   mutex_lock()
   while (skb = ...)
   ...
   do {
     ret = sk_psock_handle_skb()
     if (ret <= 0) {
       if (ret == -EAGAIN) {
           sk_psock_skb_state()
           goto  end;
       } 
      ...
   } while (len);
   ...
  end:
   mutex_unlock()

what I'm not seeing is if we get an EAGAIN through sk_psock_handle_skb
how do we schedule the backlog again. For egress we would set the
SOCK_NOSPACE bit and then get a write space available callback which
would do the schedule(). The ingress side could fail with EAGAIN
through the alloc_sk_msg(GFP_ATOMIC) call. This is just a kzalloc,

   sk_psock_handle_skb()
    sk_psock_skb_ingress()
     sk_psock_skb_ingress_self()
       msg = alloc_sk_msg()
               kzalloc()          <- this can return NULL
       if (!msg)
          return -EAGAIN          <- could we stall now


I think we could stall here if there was nothing else to kick it. I
was thinking about this maybe,

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1efdc47a999b..b96e95625027 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -624,13 +624,20 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 static void sk_psock_skb_state(struct sk_psock *psock,
                               struct sk_psock_work_state *state,
                               struct sk_buff *skb,
-                              int len, int off)
+                              int len, int off, bool ingress)
 {
        spin_lock_bh(&psock->ingress_lock);
        if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
                state->skb = skb;
                state->len = len;
                state->off = off;
+               /* For ingress we may not have a wakeup callback to trigger
+                * the reschedule on so need to reschedule retry. For egress
+                * we will get TCP stack callback when its a good time to
+                * retry.
+                */
+               if (ingress)
+                       schedule_work(&psock->work);
        } else {
                sock_drop(psock->sk, skb);
        }
@@ -678,7 +685,7 @@ static void sk_psock_backlog(struct work_struct *work)
                        if (ret <= 0) {
                                if (ret == -EAGAIN) {
                                        sk_psock_skb_state(psock, state, skb,
-                                                          len, off);
+                                                          len, off, ingress);
                                        goto end;
                                }
                                /* Hard errors break pipe and stop xmit. */


Its tempting to try and use the memory pressure callbacks but those are
built for the skb cache so I think overloading them is not so nice. The
drawback to above is its possible no memory is available even when we
get back to the backlog. We could use a delayed reschedule but its not
clear what delay makes sense here. Maybe some backoff...

Any thoughts?

Thanks,
John
