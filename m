Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4792B0E83
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgKLTwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgKLTwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:52:47 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C87C0613D1;
        Thu, 12 Nov 2020 11:52:46 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id z16so6775668otq.6;
        Thu, 12 Nov 2020 11:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xCZ+ScKBnKSg0Y3a6GGJaUS8JUdOG0wXjV3AbR5rAIY=;
        b=hbraEew9mPZ7eAa2ghJXPfqvGIEoOvIevHLfv09KCWBE8r/HVkQR7aHdylTJLQL4r/
         sToS37Fv1ssFODs49MBCJ61SqVQGCO6dVErh/WJYK+ibzWWnYqiS7cEKTrpOcsZrxz+M
         C1HUxxRIRy5U93HOaccUApCdS3TTRiApnFCP1U1ppd5yT378uNjb+pQvXw23a68RRwg5
         IYMkJIymZ6yAOnQyC/DyJb8YD9eADZLaPEnbt3UxfcqQ+3SKJzzPOt6DKY1UDIgCUCRb
         h2CQxm8dF5kSh+oAr8n1pJhVUkaO9zeyVXLo0oT99ZtBPxSfMQUJ3WMCr3Bq+1cYQpWZ
         knMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xCZ+ScKBnKSg0Y3a6GGJaUS8JUdOG0wXjV3AbR5rAIY=;
        b=iRlgYkkdu8YGHkFebbE/vuF0qUnxX9B5FRHYHTtvl5x4hbv325TnmtqcCV6Kl8OSFF
         essvZHG9nDrAEWsQbHIq+SehEPPdhlkfjJbXHtpoHGzVhePajJzlJcLGliuIUXLYpJsL
         NiJQUO+0af4zJ3zMmg1VPQaheB4KTvDW2U7kSRfYw9WZQ6cdx60ULFcO0YFTkxYABQ7Y
         6P7h3arpl4ELicoipZyg+EXjTYpeBnmH/+5n/tQGlDyEdzvhsizUDyg8yAXzx81i6rJc
         izBeozwN5mUr1gU3Nx2N6Q/DG/ebma+rGJU0ZktYZEmfYQI7XP7FIrcu/hcVEC9h5xj4
         wWow==
X-Gm-Message-State: AOAM532n0NVLwoO++bepuEv0Vn/wE4bnK8RudskItXtVBMmHvLCPUXkd
        I8zBixAL9Wx9WKmW6QE2KWM=
X-Google-Smtp-Source: ABdhPJzI+uf+xxyDwZejtDwU2oymycIKhIItgvZuHfGVsOH4+nSJ5x4GOV+Kog62rmn4RH7kvV/7bA==
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr646632otj.9.1605210766415;
        Thu, 12 Nov 2020 11:52:46 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m29sm1439814otj.42.2020.11.12.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:52:45 -0800 (PST)
Date:   Thu, 12 Nov 2020 11:52:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <5fad928748443_2a6120855@john-XPS-13-9370.notmuch>
In-Reply-To: <a49096e0-6cc7-7741-a283-27c8629da80f@iogearbox.net>
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
 <160477791482.608263.14389359214124051944.stgit@john-XPS-13-9370>
 <a49096e0-6cc7-7741-a283-27c8629da80f@iogearbox.net>
Subject: Re: [bpf PATCH 3/5] bpf, sockmap: Avoid returning unneeded EAGAIN
 when redirecting to self
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 11/7/20 8:38 PM, John Fastabend wrote:
> > If a socket redirects to itself and it is under memory pressure it is
> > possible to get a socket stuck so that recv() returns EAGAIN and the
> > socket can not advance for some time. This happens because when
> > redirecting a skb to the same socket we received the skb on we first
> > check if it is OK to enqueue the skb on the receiving socket by checking
> > memory limits. But, if the skb is itself the object holding the memory
> > needed to enqueue the skb we will keep retrying from kernel side
> > and always fail with EAGAIN. Then userspace will get a recv() EAGAIN
> > error if there are no skbs in the psock ingress queue. This will continue
> > until either some skbs get kfree'd causing the memory pressure to
> > reduce far enough that we can enqueue the pending packet or the
> > socket is destroyed. In some cases its possible to get a socket
> > stuck for a noticable amount of time if the socket is only receiving
> > skbs from sk_skb verdict programs. To reproduce I make the socket
> > memory limits ridiculously low so sockets are always under memory
> > pressure. More often though if under memory pressure it looks like
> > a spurious EAGAIN error on user space side causing userspace to retry
> > and typically enough has moved on the memory side that it works.
> > 
> > To fix skip memory checks and skb_orphan if receiving on the same
> > sock as already assigned.
> > 
> > For SK_PASS cases this is easy, its always the same socket so we
> > can just omit the orphan/set_owner pair.
> > 
> > For backlog cases we need to check skb->sk and decide if the orphan
> > and set_owner pair are needed.
> > 
> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   net/core/skmsg.c |   72 ++++++++++++++++++++++++++++++++++++++++--------------
> >   1 file changed, 53 insertions(+), 19 deletions(-)
> > 
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index fe44280c033e..580252e532da 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -399,38 +399,38 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
> >   }
> >   EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
> >   
> > -static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
> > +static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
> > +						  struct sk_buff *skb)
> >   {
> > -	struct sock *sk = psock->sk;
> > -	int copied = 0, num_sge;
> >   	struct sk_msg *msg;
> >   
> >   	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
> > -		return -EAGAIN;
> > +		return NULL;
> > +
> > +	if (!sk_rmem_schedule(sk, skb, skb->len))
> 
> Isn't accounting always truesize based, thus we should fix & convert all skb->len
> to skb->truesize ?

Right good catch, will fix in v2.
