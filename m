Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65813BC1A1
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhGEQ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhGEQ1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:27:32 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9839C061574;
        Mon,  5 Jul 2021 09:24:54 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id l5so21518258iok.7;
        Mon, 05 Jul 2021 09:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jE7HJODEJC7aP7ymfDAho2zFMkKGchYcLm7s7apgoF8=;
        b=rJQBtQmHei0xD27PsnQhcQZpQu5nCnmATnmzFyTLdXUiT9ewrDAupYNryLLndjFqY+
         NxLGyYTaxOUhAaRssSyczHuS1M0EoFt4CGbrKCb4XT1dDyVqY0KX4sGcL1/dGM6Bz9Wx
         W/yHkcYYW96mejslZXMc+0KfaBt9XAPylGX1O7jwx1B8ef5Ql/dgVeH7e3F4BnsWAfIr
         RHJl1OFaguWYj4/oWEsER5/Mof01ww2hdFcKyypQUM/CLmHJD0EDmC6Tgou8xTE+m+SN
         kHBKAqcve8uJho+MU8Odm0NTvgUuhL+zYpYUngR+Nv476JG1lTGY1i5m1C7Q6hX1FggJ
         57qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jE7HJODEJC7aP7ymfDAho2zFMkKGchYcLm7s7apgoF8=;
        b=qPZUbxVXOr+HR+dzk6uPUZFhculqR+x4wgHSUdmEUWVFhy8I4dTQMKy/dlNYHo7pXr
         0rU7AUAHKPhFz6vqEGui95VxAZhzKrkDpKXr6qPuEzuSBYhTNcALzoRMWWB885ZvHq4m
         2EUGAZxFUTvTCX9lHf5fbH+SkPehCM6PJ7zhwB05nA2lZndXmRIPQTriY9Zi9yIjwwnH
         X/DLds6cZrHDboEqb7zZXntI5FJUQbxovt9Kvex7p907mPW/WwI+Rl7DA0kqKMDf8PjI
         OFnM1+RwoPRqT5iDwx/Mkhv6FjY/St01z0G79oj86/8RUwBkJixPqBzTLvagwqZy5VHD
         Mr5g==
X-Gm-Message-State: AOAM530JIN7OloSeNKApUzf6GUi/GnZX+RCXozcc/jrfJtQnHaKO14jp
        4KT7W9H9g9/ZVRB7TLoUNwE=
X-Google-Smtp-Source: ABdhPJyFd+hNW3cxwVRuDKHLISvjv5aAoy3iY5/RRw2pEhT16HlV0hksHEvAcB3xPTy98FQJN60JMA==
X-Received: by 2002:a05:6638:21b:: with SMTP id e27mr13327378jaq.80.1625502294270;
        Mon, 05 Jul 2021 09:24:54 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n5sm7254179ilo.78.2021.07.05.09.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:24:53 -0700 (PDT)
Date:   Mon, 05 Jul 2021 09:24:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60e3324bbc766_20ea208ce@john-XPS-13-9370.notmuch>
In-Reply-To: <8735strwwg.fsf@cloudflare.com>
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
 <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
 <875yxrs2sc.fsf@cloudflare.com>
 <CAM_iQpW69PGfp_Y8mZoqznwCk2axask5qJLB7ntZjFgGO+Eizg@mail.gmail.com>
 <8735strwwg.fsf@cloudflare.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sun, Jul 04, 2021 at 09:53 PM CEST, Cong Wang wrote:
> > On Sat, Jul 3, 2021 at 10:52 AM Jakub Sitnicki <jakub@cloudflare.com>=
 wrote:
> >> When running with just the verdict prog attached, the -EIO error fro=
m
> >> sk_psock_verdict_apply is propagated up to tcp_read_sock. That is, i=
t
> >> maps to 0 bytes used by recv_actor. sk_psock_verdict_recv in this ca=
se.
> >>
> >> tcp_read_sock, if 0 bytes were used =3D copied, won't sk_eat_skb. It=
 stays
> >> on sk_receive_queue.
> >
> > Are you sure?
> >
> > When recv_actor() returns 0, the while loop breaks:
> >
> > 1661                         used =3D recv_actor(desc, skb, offset, l=
en);
> > 1662                         if (used <=3D 0) {
> > 1663                                 if (!copied)
> > 1664                                         copied =3D used;
> > 1665                                 break;
> >
> > then it calls sk_eat_skb() a few lines after the loop:
> > ...
> > 1690                 sk_eat_skb(sk, skb);
> =

> This sk_eat_skb is still within the loop:
> =

> 1636:int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> 1637-		  sk_read_actor_t recv_actor)
> 1638-{
> 	=E2=80=A6
> 1643-	int copied =3D 0;
>         =E2=80=A6
> 1647-	while ((skb =3D tcp_recv_skb(sk, seq, &offset)) !=3D NULL) {
> 1648-		if (offset < skb->len) {
> 			=E2=80=A6
> 1661-			used =3D recv_actor(desc, skb, offset, len);
> 1662-			if (used <=3D 0) {
> 1663-				if (!copied)
> 1664-					copied =3D used;
> 1665-				break;
> 1666-			} else if (used <=3D len) {
> 1667-				seq +=3D used;
> 1668-				copied +=3D used;
> 1669-				offset +=3D used;
> 1670-			}
> 			=E2=80=A6
> 1684-		}
> 		=E2=80=A6
> 1690-		sk_eat_skb(sk, skb);
> 		=E2=80=A6
> 1694-	}
> 	=E2=80=A6
> 1699-	/* Clean up data we have read: This will do ACK frames. */
> 1700-	if (copied > 0) {
> 1701-		tcp_recv_skb(sk, seq, &offset);
> 1702-		tcp_cleanup_rbuf(sk, copied);
> 1703-	}
> 1704-	return copied;
> 1705-}
> =

> sk_eat_skb could get called by tcp_recv_skb =E2=86=92 sk_eat_skb if rec=
v_actor
> returned > 0 (the case when we have parser attached).
> =

> >
> >>
> >>   sk->sk_data_ready
> >>     sk_psock_verdict_data_ready
> >>       ->read_sock(..., sk_psock_verdict_recv)
> >>         tcp_read_sock (used =3D copied =3D 0)
> >>           sk_psock_verdict_recv -> ret =3D 0
> >>             sk_psock_verdict_apply -> -EIO
> >>               sk_psock_skb_redirect -> -EIO
> >>
> >> However, I think this gets us stuck. What if no more data gets queue=
d,
> >> and sk_data_ready doesn't get called again?

Agree looks like it will be stuck. I found a similar stuck queue
in the skmsg backlog case for this I'm testing changing our workqueue
over to a delayed workqueue and then calling it again after some
delay.

We could do the same here I think. Return 0 to stop the tcp_read_sock
as you show. Then the data is still on the sk_receive_queue and
memory should still be accounted for. Solving the memory overrun
on the dest socket. Then we kick a workqueue item that will call
data_ready at some point in the future. And we do a backoff so
we don't keep hitting it repeatedly. I think this should work and
I have the patches testing now for doing it on the backlog paths.

> >
> > I think it is dropped by sk_eat_skb() in TCP case and of course the
> > sender will retransmit it after detecting this loss. So from this poi=
nt of
> > view, there is no difference between drops due to overlimit and drops=

> > due to eBPF program policy.
> =

> I'm not sure the retransmit will happen.
> =

> We update tp->rcv_nxt (tcp_rcv_nxt_update) when skb gets pushed onto
> sk_receive_queue in either:
> =

>  - tcp_rcv_established -> tcp_queue_rcv, or
>  - tcp_rcv_established -> tcp_data_queue -> tcp_queue_rcv
> =

> ... and schedule ACK (tcp_event_data_recv) to be sent.

Right, this is what we've observed before when we did have a few drops
on error cases. And then some applications will break and user will
send bugs and we have to fix them. We can't unintentionally drop TCP
packets. A policy drop though is different in this case we want to
break the session. FWIW I'm considering adding a reset socket helper
so we can do this cleanly and tear the socket down.

> =

> Say we are in quickack mode, then
> tcp_ack_snd_check()/__tcp_ack_snd_check() would cause ACK to be sent
> out.

Yep.

For the stream parser case. I propose we stop the stream parser so it
wont pull in more data. Then requeue the skb we don't have memory for.
Finally use same delayed workqueue to start up the stream parser again.

It requires some patches to get working, but this should get us the
correct handling for TCP. And avoids drops in UDP stack which may
or may not be useful.

I'll try to flush my queue of patches tomorrow its a holiday today
here. With those I think above becomes not so difficult.

.John=
