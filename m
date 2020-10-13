Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627A128CB9E
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgJMK1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbgJMK1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:27:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0106DC0613D2
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y12so17989220wrp.6
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=cAni1ifXqzsheh6lxHnRYNhry2fldD6pWJ51clSn3eo=;
        b=QV8rIxZVZ0HgEbxaKtarYS4BM6Y+nINmfn9RlW0186p5pnJmuAuSNH4IrOoXrU+P82
         EaRzGF+z1HalpE069jmHSfPnIPxk4W7TYujkIbA3OG4byq2bayXtIdWlGcAO8Vw/rRz7
         +9IZX4D+aNLnx57fgSoX1W4tZ9z5f4ET/mfS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=cAni1ifXqzsheh6lxHnRYNhry2fldD6pWJ51clSn3eo=;
        b=P4lhtY1vKH1bsU0JnO87K8hkUcHUJW1NEumTPI6UlV1ryywsTzSozVeBh8+asLuKv0
         s9lIpglv28yeB0YGAXtV1BMzl/DZFxfiTXsDgKZzDIwsnv7/3LXtqQ6srPgx8Qy/bfjv
         jZqwIeKIpSRfIWyYlvyLJJ6UknqIPxLfYo4Ep89rjcy3nKZYpr72r9wR7CRoSCH+wxCn
         kM8apnQZvtBBWfOPSoQAgkRoNtYdU665Oy2uYm4SMnKZ463anjxSwKoxM2acCxckg7GB
         0TTzl4+lYbklhrUCWGifFknsizeUcUXlVwpQDyHIvPIEoMov4vzPxNumoyvP141XM5oA
         Of/g==
X-Gm-Message-State: AOAM5306wzln69BxBZIo88xai1h8ZZJe+hjYj5kTisOVaWvNtnkUBzyf
        S2g6mZ5CQBzJRJwAi2SxkcvIFQ==
X-Google-Smtp-Source: ABdhPJwBiMMGUe3TA6Qt17hQOk4uJsDTP6tyiaMiA3MalHF6I0+La5Z+Me4iwheDHC9TAzTRTiOceA==
X-Received: by 2002:adf:f246:: with SMTP id b6mr28797397wrp.111.1602584852653;
        Tue, 13 Oct 2020 03:27:32 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id l11sm30119342wrt.54.2020.10.13.03.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 03:27:31 -0700 (PDT)
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower> <160226863689.5692.13861422742592309285.stgit@john-Precision-5820-Tower> <87ft6jr6po.fsf@cloudflare.com> <5f84903d914d1_370c208c3@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, lmb@cloudflare.com
Subject: Re: [bpf-next PATCH v3 4/6] bpf, sockmap: remove dropped data on errors in redirect case
In-reply-to: <5f84903d914d1_370c208c3@john-XPS-13-9370.notmuch>
Date:   Tue, 13 Oct 2020 12:27:31 +0200
Message-ID: <87d01mqv3g.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 07:19 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Fri, Oct 09, 2020 at 08:37 PM CEST, John Fastabend wrote:
>> > In the sk_skb redirect case we didn't handle the case where we overrun
>> > the sk_rmem_alloc entry on ingress redirect or sk_wmem_alloc on egress.
>> > Because we didn't have anything implemented we simply dropped the skb.
>> > This meant data could be dropped if socket memory accounting was in
>> > place.
>> >
>> > This fixes the above dropped data case by moving the memory checks
>> > later in the code where we actually do the send or recv. This pushes
>> > those checks into the workqueue and allows us to return an EAGAIN error
>> > which in turn allows us to try again later from the workqueue.
>> >
>> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF pat=
h")
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > ---
>> >  net/core/skmsg.c |   28 ++++++++++++++--------------
>> >  1 file changed, 14 insertions(+), 14 deletions(-)
>> >
>>
>> [...]
>>
>> > @@ -709,30 +711,28 @@ static void sk_psock_skb_redirect(struct sk_buff=
 *skb)
>> >  {
>> >  	struct sk_psock *psock_other;
>> >  	struct sock *sk_other;
>> > -	bool ingress;
>> >
>> >  	sk_other =3D tcp_skb_bpf_redirect_fetch(skb);
>> > +	/* This error is a buggy BPF program, it returned a redirect
>> > +	 * return code, but then didn't set a redirect interface.
>> > +	 */
>> >  	if (unlikely(!sk_other)) {
>> >  		kfree_skb(skb);
>> >  		return;
>> >  	}
>> >  	psock_other =3D sk_psock(sk_other);
>> > +	/* This error indicates the socket is being torn down or had another
>> > +	 * error that caused the pipe to break. We can't send a packet on
>> > +	 * a socket that is in this state so we drop the skb.
>> > +	 */
>> >  	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
>> >  	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
>> >  		kfree_skb(skb);
>> >  		return;
>> >  	}
>> >
>> > -	ingress =3D tcp_skb_bpf_ingress(skb);
>> > -	if ((!ingress && sock_writeable(sk_other)) ||
>> > -	    (ingress &&
>> > -	     atomic_read(&sk_other->sk_rmem_alloc) <=3D
>> > -	     sk_other->sk_rcvbuf)) {
>>
>> I'm wondering why the check for going over socket's rcvbuf was removed?
>
> Couple reasons, I never checked it from skmsg side so after this patch
> accounting for both skmsg and sk_skb types are the same. I think this
> should be the case going forward with anything we do around memory
> accounting. The other, and more immediate, reason is we don't want the
> error case here with the kfree_skb().

Right, we definitely don't want to drop the skb.

What crossed my mind is that sk_psock_handle_skb() could check for
sk_rmem_alloc <=3D sk_rcvbuf and error out with -EAGAIN. Similarly to how
we check for sock_writable() with this change.

This would let the process owning the destination socket, we are
redirecting to, to push back by tuning down SO_RCVBUF.

>
>>
>> I see that we now rely exclusively on
>> sk_psock_skb_ingress=E2=86=92sk_rmem_schedule for sk_rmem_alloc checks, =
which I
>> don't think applies the rcvbuf limit.
>
> Right. Also notice even though we checked it here we never charged the
> skm_rmem_alloc for skmsg on the ingress queue. So we were effectively
> getting that memory for free. Still doing some review and drafting a
> patch to see if this works, but my proposal is:
>
>   For ingress sk_skb case we check sk_rmem_alloc before enqueuing
>   the new sk_msg into ingress queue and then also charge the memory
>   the same as skb_set_owner_r except do it with a new helper
>   skmsg_set_owner_r(skmsg, sk) and only do the atomic add against
>   sk_rmem_alloc and the sk_mem_charge() part.
>
>   Then for skmsg programs convert the sk_mem_charge() calls to
>   use the new skmsg_set_owner_r() to get the same memory accounting.
>   Finally, on copy to user buffer we unwind this. Then we will have
>   the memory in the queue accounted for against the socket.
>
> I'll give it a try. Thanks for asking. wdyt? Any other ideas.

SGTM, nothing to add except for honoring SO_RCVBUF I mentioned above.

[...]
