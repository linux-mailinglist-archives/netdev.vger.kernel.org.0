Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F113D958E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhG1Sw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1Swy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:52:54 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2DCC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:52:52 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id j18so398949ile.8
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GxrRfsk5z4LAbr/d0J9jcCTA7Ah1vKHoCRtggyfCAtY=;
        b=LD50dWLdsaKlIKAPTsD2/cqz8VG5tjnAdCaizwobgW0mqZ38qxeRwOacitolZcZef7
         q/ChI6o4fDHVTrhrZ5yCf+zwSYJzA4kMeEmNz9Ffm6XAzX1KL25qmPsxFQfGw9LwwTDz
         /vtEwfT8vzQJ+BhpqWtbVrRNTX+QIdud44NtrkD430mZuqx8WdiUY4R3NPbGnATr610j
         Iwkiclk0QwXX/JrIIleAa5GA9hVou0X2XMqYjO8zaX1IG3sGulj/9gXaUCNpAfH2WCsL
         M6eZgzmKf/V5eAGFjSu33H0yIk3lIYmmzIQP/m4+GS+RMEuUXpHv+n8ceUbtQjvXNptU
         jMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GxrRfsk5z4LAbr/d0J9jcCTA7Ah1vKHoCRtggyfCAtY=;
        b=QPGBC8HfF96lnftaO6v9g/82pt8LcJkwN6Wt9gEwwCcubRWGfMT9+XYbeOHiJE0LjA
         oNNF5ptVuxZ9ve42IqfOZGetCd2aZuOSd+2BdZIf6Bsny9ilr3Ztf+JGQRWVSlqhie+0
         ijYxEbxA++oNxZEhVkWDrup4MGGH8MKyxYej33OtHxMDqZ3hWcbkBDKv3SuMMKLXUow8
         qJdmcBtVYC/bLkjX3fPCMXkeVE1uNg92YMEffRA5pXEynwR1Mlm68sx11DRCsBOVfCmC
         lxm3gGPkP/NHwFc+q+/ZULuX0Rji8b28rNMpHrUQ/Jcr17EcppX98i0nPKKcuAFiffXX
         ttwg==
X-Gm-Message-State: AOAM531dPNmTbRn+dxbzqss6O0OBuQufaqwc9H63+8t1DIFqSkJHqlRG
        gzwxklCjYGYRBCTD1EYRZdc=
X-Google-Smtp-Source: ABdhPJyuM6yykXQt0AKjTJ8JVSzsx83d72+hxRghYAgTk0mUWrZ2L9FYBg8xnQegVLD4PN7d+UzNJQ==
X-Received: by 2002:a92:3209:: with SMTP id z9mr835272ile.115.1627498372247;
        Wed, 28 Jul 2021 11:52:52 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j20sm552593ile.17.2021.07.28.11.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:52:51 -0700 (PDT)
Date:   Wed, 28 Jul 2021 11:52:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6101a77ca9c1_1e1ff620822@john-XPS-13-9370.notmuch>
In-Reply-To: <87h7ge3fya.fsf@cloudflare.com>
References: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
 <87h7ge3fya.fsf@cloudflare.com>
Subject: Re: [Patch bpf-next] unix_bpf: fix a potential deadlock in
 unix_dgram_bpf_recvmsg()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Fri, Jul 23, 2021 at 08:36 PM CEST, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > As Eric noticed, __unix_dgram_recvmsg() may acquire u->iolock
> > too, so we have to release it before calling this function.
> >
> > Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/unix/unix_bpf.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> > index db0cda29fb2f..b07cb30e87b1 100644
> > --- a/net/unix/unix_bpf.c
> > +++ b/net/unix/unix_bpf.c
> > @@ -53,8 +53,9 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> >  	mutex_lock(&u->iolock);
> >  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
> >  	    sk_psock_queue_empty(psock)) {
> > -		ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> > -		goto out;
> > +		mutex_unlock(&u->iolock);
> > +		sk_psock_put(sk, psock);
> > +		return __unix_dgram_recvmsg(sk, msg, len, flags);
> >  	}
> >  
> >  msg_bytes_ready:
> > @@ -68,13 +69,13 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> >  		if (data) {
> >  			if (!sk_psock_queue_empty(psock))
> >  				goto msg_bytes_ready;
> > -			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> > -			goto out;
> > +			mutex_unlock(&u->iolock);
> > +			sk_psock_put(sk, psock);
> > +			return __unix_dgram_recvmsg(sk, msg, len, flags);
> >  		}
> >  		copied = -EAGAIN;
> >  	}
> >  	ret = copied;
> > -out:
> >  	mutex_unlock(&u->iolock);
> >  	sk_psock_put(sk, psock);
> >  	return ret;
> 
> Nit: Can be just `return copied`. `ret` became useless.
> 
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

Worth doing the small cleanup pointed out by Jakub but feel free to add
my ack.

Acked-by: John Fastabend <john.fastabend@gmail.com>
