Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591F428BEF3
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404059AbgJLRUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403928AbgJLRUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 13:20:06 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C775DC0613D0;
        Mon, 12 Oct 2020 10:20:05 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j13so12795373ilc.4;
        Mon, 12 Oct 2020 10:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FdCADMFduhnPF4cnc87RqKUCIAd2GLd0BSWpCX8Qcuo=;
        b=Vo/erKt3fbTzBLdsTvLRhSFyKb9Svq6gWNJN/9ddHA4kgkd33G2ZguuZN0h082K5VY
         I4NbwvtaxGQRVz60+PyW4PurHoSKVImNnL4Rjh+Ar/QtocficpTqCcADG1HiN06U+ILC
         qsonpCin2Dq0JpaiLYyTfiOiDR3fE0rukdDVYQWlo+KlZ3fDHlGjORVAvMCRIt9ytYuA
         ZcbbSq9ElJTQ8MPUIBVi/8JtheNzc15ZAK39DKdZWwazez76E+U8N7jPJIvPNoiLfyut
         91eLupft6FmQKYUv33gvOff+ifHOqo8h0lWIgzfD0NCYMoO5lFuj+lN540qOrz7Vs95n
         9MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FdCADMFduhnPF4cnc87RqKUCIAd2GLd0BSWpCX8Qcuo=;
        b=M4ByyEKtioThNxMvNaXity6JlYnQ8FRqTO9l122taVSGIX73bice54t7T9FjlJ4uBm
         oIIOmf2PTI3qAdsaDi70aMlYQfF6oXdDChK0+ApXjGLKVzcQ76SgoJMa9inrZm6BvRIm
         VdjCFOVtdqvQuRuo/tcIpiFdY1TmXmHBMVtjlvFPTIsAONiXIb+mqoTHLmGvfxzjaezM
         mC5iEbBu7a58ROaWYwoV6Z2dvXcVJoUT0wq0ORd5F/04HOwZt5EBzzFI4jfrcigwzzVz
         qFtJKxxoNW1ezDXZ4lQBDktxzLleqaqsNcPgegEWXCLNjOLm49plxx1GSGThuifkIQ10
         V+cw==
X-Gm-Message-State: AOAM533vXtz6UfomjsNLw+PPxLS+nACGeUv9kLm0RXcd51qhEjQQNkz3
        Mgqn3Kek4yxnBjzF47sR6+8pn8xZS6s=
X-Google-Smtp-Source: ABdhPJyY1HhZyNMyiWyEvYCGKhNFhFQ9Tx09dlgtHjh9rdY8WIY/QyD/rTpc8OpJHUW/5dx5i4TVSw==
X-Received: by 2002:a92:6711:: with SMTP id b17mr20702705ilc.100.1602523205130;
        Mon, 12 Oct 2020 10:20:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r4sm9744013ilc.32.2020.10.12.10.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 10:20:04 -0700 (PDT)
Date:   Mon, 12 Oct 2020 10:19:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, lmb@cloudflare.com
Message-ID: <5f84903d914d1_370c208c3@john-XPS-13-9370.notmuch>
In-Reply-To: <87ft6jr6po.fsf@cloudflare.com>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
 <160226863689.5692.13861422742592309285.stgit@john-Precision-5820-Tower>
 <87ft6jr6po.fsf@cloudflare.com>
Subject: Re: [bpf-next PATCH v3 4/6] bpf, sockmap: remove dropped data on
 errors in redirect case
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Fri, Oct 09, 2020 at 08:37 PM CEST, John Fastabend wrote:
> > In the sk_skb redirect case we didn't handle the case where we overru=
n
> > the sk_rmem_alloc entry on ingress redirect or sk_wmem_alloc on egres=
s.
> > Because we didn't have anything implemented we simply dropped the skb=
.
> > This meant data could be dropped if socket memory accounting was in
> > place.
> >
> > This fixes the above dropped data case by moving the memory checks
> > later in the code where we actually do the send or recv. This pushes
> > those checks into the workqueue and allows us to return an EAGAIN err=
or
> > which in turn allows us to try again later from the workqueue.
> >
> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF pa=
th")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/skmsg.c |   28 ++++++++++++++--------------
> >  1 file changed, 14 insertions(+), 14 deletions(-)
> >
> =

> [...]
> =

> > @@ -709,30 +711,28 @@ static void sk_psock_skb_redirect(struct sk_buf=
f *skb)
> >  {
> >  	struct sk_psock *psock_other;
> >  	struct sock *sk_other;
> > -	bool ingress;
> >
> >  	sk_other =3D tcp_skb_bpf_redirect_fetch(skb);
> > +	/* This error is a buggy BPF program, it returned a redirect
> > +	 * return code, but then didn't set a redirect interface.
> > +	 */
> >  	if (unlikely(!sk_other)) {
> >  		kfree_skb(skb);
> >  		return;
> >  	}
> >  	psock_other =3D sk_psock(sk_other);
> > +	/* This error indicates the socket is being torn down or had anothe=
r
> > +	 * error that caused the pipe to break. We can't send a packet on
> > +	 * a socket that is in this state so we drop the skb.
> > +	 */
> >  	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
> >  	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
> >  		kfree_skb(skb);
> >  		return;
> >  	}
> >
> > -	ingress =3D tcp_skb_bpf_ingress(skb);
> > -	if ((!ingress && sock_writeable(sk_other)) ||
> > -	    (ingress &&
> > -	     atomic_read(&sk_other->sk_rmem_alloc) <=3D
> > -	     sk_other->sk_rcvbuf)) {
> =

> I'm wondering why the check for going over socket's rcvbuf was removed?=


Couple reasons, I never checked it from skmsg side so after this patch
accounting for both skmsg and sk_skb types are the same. I think this
should be the case going forward with anything we do around memory
accounting. The other, and more immediate, reason is we don't want the
error case here with the kfree_skb().

> =

> I see that we now rely exclusively on
> sk_psock_skb_ingress=E2=86=92sk_rmem_schedule for sk_rmem_alloc checks,=
 which I
> don't think applies the rcvbuf limit.

Right. Also notice even though we checked it here we never charged the
skm_rmem_alloc for skmsg on the ingress queue. So we were effectively
getting that memory for free. Still doing some review and drafting a
patch to see if this works, but my proposal is:

  For ingress sk_skb case we check sk_rmem_alloc before enqueuing
  the new sk_msg into ingress queue and then also charge the memory
  the same as skb_set_owner_r except do it with a new helper
  skmsg_set_owner_r(skmsg, sk) and only do the atomic add against
  sk_rmem_alloc and the sk_mem_charge() part.

  Then for skmsg programs convert the sk_mem_charge() calls to
  use the new skmsg_set_owner_r() to get the same memory accounting.
  Finally, on copy to user buffer we unwind this. Then we will have
  the memory in the queue accounted for against the socket.

I'll give it a try. Thanks for asking. wdyt? Any other ideas.

> =

> > -		skb_queue_tail(&psock_other->ingress_skb, skb);
> > -		schedule_work(&psock_other->work);
> > -	} else {
> > -		kfree_skb(skb);
> > -	}
> > +	skb_queue_tail(&psock_other->ingress_skb, skb);
> > +	schedule_work(&psock_other->work);
> >  }
> >
> >  static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verd=
ict)=
