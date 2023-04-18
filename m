Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5496E6450
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDRMsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjDRMsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:48:11 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A02515A19
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:48:02 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id e13so11682802qvd.8
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681822081; x=1684414081;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6DRGGRKc2AoWMsuaAE9+G+jTBsGffDSmnKGfaP1mAis=;
        b=VMCKtudo4QuaWLSK5TW8re+wB0fykIzf8cX8bMgdRCmBNuRR5/3Y/YpjQzIcGrr3nP
         CCH+NLN1nirJ/catfihlT/OCIXXdu41KB4iVszmXUHKpM6PTDChHJKHRHPKUn8aLPUbE
         A9+ZnIHAbkN4Yq5aLXZBqA/zMai4ct5x4vQk8g1ofObCpMl1qxrSu219H8b1G1iAWOCQ
         g4IyfoPB7VOuUxBn1R8GVMsAPXmXbmuczVp+h80E17S65e19+JJotDSu6Lt97/tPm3ZA
         dOBESLjq2KFJkej8xE4SfheeiYOMYL/P/aaJ8eJaN9HVg+PXq/FYvAsCdbwA9bP87hOq
         VQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681822081; x=1684414081;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6DRGGRKc2AoWMsuaAE9+G+jTBsGffDSmnKGfaP1mAis=;
        b=THIfDSwWVjA/q83WnoS8kSNSg0voPHwqJPnQmW3gPPftt1xEUF1FONBWbZptGXj+5g
         84DmobByykTcuxTDxFJTcfD2prCzv0Odmm8xXbXiwkVbaY0SzcAYMlf0fN41URfW373c
         s2Ii+3pVo6fMwVyteLTTnXsvXav2kK4A+ZoqQg2eWXMfS22rGo5qh3uOAiMSbCRBt5Ur
         i2uZyUAYGhDLg2SFnDkvYrv+rg09yGMbLOeLUg5d4QLSrm3L6ggoiI1BKF4wxLxCWx1v
         LdORn6xMG0qKBMFVZaCQibuGK/03kCuBpvnA3IgKlvvNnm/vmBempGBtvFwZguu+JrN2
         3Tng==
X-Gm-Message-State: AAQBX9d2fqSSqW9EliKxmmi3JaVgK/IW8bCZ61E/37/iKG1AdeaaFW+S
        dUbTVTB0O7VqfO1lr38KeAU=
X-Google-Smtp-Source: AKy350YmydtOo/ZtLbDOcOjVsprJaExizwYkCJBg/LSqUKryvVFhOZ0pAEFNuVEJIu/ZeG5iA77rTQ==
X-Received: by 2002:a05:6214:27e4:b0:56e:92a8:e18e with SMTP id jt4-20020a05621427e400b0056e92a8e18emr20329769qvb.31.1681822081023;
        Tue, 18 Apr 2023 05:48:01 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id a3-20020a0cefc3000000b005ef53081921sm3374661qvt.42.2023.04.18.05.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 05:48:00 -0700 (PDT)
Date:   Tue, 18 Apr 2023 08:48:00 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller@googlegroups.com, willemb@google.com
Message-ID: <643e918069a34_327ccc294fd@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230418015442.89242-1-kuniyu@amazon.com>
References: <643df48f6ce39_30336a294a7@willemb.c.googlers.com.notmuch>
 <20230418015442.89242-1-kuniyu@amazon.com>
Subject: RE: [PATCH v1 net] udp: Fix memleaks of sk and zerocopy skbs with TX
 timestamp.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kuniyuki Iwashima wrote:
> From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date:   Mon, 17 Apr 2023 21:38:23 -0400
> > Kuniyuki Iwashima wrote:
> [...]
> > > > > So, we need to make sure TX tstamp is not queued if SOCK_DEAD is
> > > > > flagged and we purge the queue only after marking SOCK_DEAD ?
> > > > 
> > > > Exactly. Thanks for the sketch.
> > > > 
> > > > Ideally without having to take an extra lock in the common path.
> > > > sk_commmon_release calls sk_prot->destroy == udp_destroy_sock,
> > > > which already sets SOCK_DEAD.
> > > > 
> > > > Could we move the skb_queue_purge in there? That is also what
> > > > calls udp_flush_pending_frames.
> > > 
> > > Yes, that makes sense.
> > > 
> > > I was thinking if we need a memory barrier for SOCK_DEAD to sync
> > > with TX, which reads it locklessly.  Maybe we should check SOCK_DEAD
> > > with sk->sk_error_queue.lock held ?
> > 
> > the flag write needs the lock (which is held). The test_bit in
> > sock_flag is atomic.
> 
> I was concerning this race:
> 
> 					if (!sock_flag(sk, SOCK_DEAD)) {
> 	sock_flag(sk, SOCK_DEAD)
> 	skb_queue_purge()
> 						skb_queue_tail()
> 					}
> 
> and thought we can avoid it by checking SOCK_DEAD under sk_error_queue.lock.
> 
> 					spin_lock_irqsave(sk_error_queue.lock
> 					if (!sock_flag(SOCK_DEAD)) {
> 	sock_flag(SOCK_DEAD)			__skb_queue_tail()
> 					}
> 					spin_unlock_irqrestore()
> 	skb_queue_purge()
> 
> What do you think ?

Good point. Yes, that looks good to me.
 
> >  
> > > And I forgot to return error from sock_queue_err_skb() to free skb
> > > in __skb_complete_tx_timestamp().
> > >
> > > ---8<---
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 4c0879798eb8..287b834df9c8 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
> > >   */
> > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > >  {
> > > +	unsigned long flags;
> > > +
> > >  	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
> > >  	    (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > >  		return -ENOMEM;
> > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > >  	/* before exiting rcu section, make sure dst is refcounted */
> > >  	skb_dst_force(skb);
> > >  
> > > -	skb_queue_tail(&sk->sk_error_queue, skb);
> > > -	if (!sock_flag(sk, SOCK_DEAD))
> > > -		sk_error_report(sk);
> > > +	spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > +	if (sock_flag(sk, SOCK_DEAD)) {
> > > +		spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
> > > +		return -EINVAL;
> > > +	}
> > > +	__skb_queue_tail(&sk->sk_error_queue, skb);
> > > +	spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
> > > +
> > > +	sk_error_report(sk);
> > > +
> > >  	return 0;
> > >  }
> > >  EXPORT_SYMBOL(sock_queue_err_skb);
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index c605d171eb2d..7060a5cda711 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -2674,6 +2674,11 @@ void udp_destroy_sock(struct sock *sk)
> > >  		if (up->encap_enabled)
> > >  			static_branch_dec(&udp_encap_needed_key);
> > >  	}
> > > +
> > > +	/* A zerocopy skb has a refcnt of sk and may be
> > > +	 * put into sk_error_queue with TX timestamp
> > > +	 */
> > > +	skb_queue_purge(&sk->sk_error_queue);
> > >  }
> > >  
> > >  /*
> > > ---8<---


