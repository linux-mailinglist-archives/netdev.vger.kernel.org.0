Return-Path: <netdev+bounces-4066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8CF70A695
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 11:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 190CB2819C8
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 09:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2B720E4;
	Sat, 20 May 2023 09:08:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27952632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 09:08:11 +0000 (UTC)
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244041A1;
	Sat, 20 May 2023 02:08:08 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-561a33b6d63so56317157b3.1;
        Sat, 20 May 2023 02:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684573687; x=1687165687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XfLDx7gZ7ffDR8UWXBnKEy5S/l+ELbSVQlFX2fs43Kw=;
        b=DVd7utPaKv/OyCTklhWeNOSb5ePOy4FxZRi/ZfhDt6aXQ60fmOIKXxyNa0BsGTD9kf
         j9elsz9UXV6tc22s+GilVme8XXCwuXFdRWadgpGqwHUoFBrQuYOXaLYtS6CljYH8TRFb
         1Aoxx/JyBqnftWtPHmC02xRJBD8HCIXGEo7dyiYA8bouchhVwv51/roKPlKtchS1TBQe
         rjlyD2AhJ8n0Y+a9TnTKTXXCh36rGLHtxDSLhtOcW4rG0ey14f4Lb+jJmcgZzLDTapBH
         HeuC8ksaw9St3SVTBIUycpOIIYoRAAZkThgiCExZtCNZWyE7rS3YvRgBKInxn+nxVXbC
         hWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684573687; x=1687165687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XfLDx7gZ7ffDR8UWXBnKEy5S/l+ELbSVQlFX2fs43Kw=;
        b=MZ0hya8T4vXW/qqUyOCwcenUsmeB71RA5lCcGRIiCF8d4DPfNsc9/2yTaLnFugVw4+
         Ga0dyrdWG4ft99F++TjlwBQ1wiqg/C8FGzZTT1rvwJ0cNoPoiHBuZWkXTtusufze85wT
         pVRIaK6aTaA7SeZ/xdvOmstofHLL39mkcjn6ZzJ4CpE1uGNhRn7Hh0HsLtf0AenW65sk
         Q5IHMnhh7jD44fTZvc72Sh0mERF8jRQrV0kSqsb1oBT71j1vnXuwFQikgHbs1e87Xi3N
         ZTwuNrPIM25vZdESM0xFGJWEm6xMq7dxybKmBsOF6AA2+5StN+qEklQxD/nCfjEPFloJ
         e3mg==
X-Gm-Message-State: AC+VfDzSsc+5bLAIxRRgARIJ0Jl/lEHBVZvXGtdFwleII5HsYg4y/HBW
	QI27tkUViHhqhPginJ+my+/GCe5sdxdxOGASqMk=
X-Google-Smtp-Source: ACHHUZ6DQEjBSNmrFjyQzSAX+SWaQyke8+7vKtQbOmlt3wMrA9WtiE4uLqekZViBXPc6BVV1QuymM82cTawmx3OSCi0=
X-Received: by 2002:a81:48d3:0:b0:55d:626c:b62f with SMTP id
 v202-20020a8148d3000000b0055d626cb62fmr4946232ywa.51.1684573687222; Sat, 20
 May 2023 02:08:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-4-imagedong@tencent.com> <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
 <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com>
 <CADVnQynZ67511+cKF=hyiaLx5-fqPGGmpyJ-5Lk6ge-ivmAf-w@mail.gmail.com>
 <CADxym3ZiyYK7Vyz05qLv8jOPmNZXXepCsTbZxdkhSQxRx0cdSA@mail.gmail.com> <CADVnQy=JQkVGRsbL0u=-oZSpdaFBpz907yX24p3uUu2pMhUjGg@mail.gmail.com>
In-Reply-To: <CADVnQy=JQkVGRsbL0u=-oZSpdaFBpz907yX24p3uUu2pMhUjGg@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Sat, 20 May 2023 17:07:55 +0800
Message-ID: <CADxym3awe-c29C-e1Y+efepLdpFWrG520ezJO1EjJ5C3arq6Eg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>, kuba@kernel.org
Cc: davem@davemloft.net, pabeni@redhat.com, dsahern@kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Menglong Dong <imagedong@tencent.com>, Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 12:03=E2=80=AFAM Neal Cardwell <ncardwell@google.co=
m> wrote:
>
> On Thu, May 18, 2023 at 10:12=E2=80=AFAM Menglong Dong <menglong8.dong@gm=
ail.com> wrote:
> >
> > On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardwell@google=
.com> wrote:
> > >
> > > On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <menglong8.don=
g@gmail.com> wrote:
> > > >
> > > > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet@goo=
gle.com> wrote:
> > > > >
> > > > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com=
> wrote:
> > > > > >
> > > > > > From: Menglong Dong <imagedong@tencent.com>
> > > > > >
> > > > > > Window shrink is not allowed and also not handled for now, but =
it's
> > > > > > needed in some case.
> > > > > >
> > > > > > In the origin logic, 0 probe is triggered only when there is no=
 any
> > > > > > data in the retrans queue and the receive window can't hold the=
 data
> > > > > > of the 1th packet in the send queue.
> > > > > >
> > > > > > Now, let's change it and trigger the 0 probe in such cases:
> > > > > >
> > > > > > - if the retrans queue has data and the 1th packet in it is not=
 within
> > > > > > the receive window
> > > > > > - no data in the retrans queue and the 1th packet in the send q=
ueue is
> > > > > > out of the end of the receive window
> > > > >
> > > > > Sorry, I do not understand.
> > > > >
> > > > > Please provide packetdrill tests for new behavior like that.
> > > > >
> > > >
> > > > Yes. The problem can be reproduced easily.
> > > >
> > > > 1. choose a server machine, decrease it's tcp_mem with:
> > > >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > > > 2. call listen() and accept() on a port, such as 8888. We call
> > > >     accept() looply and without call recv() to make the data stay
> > > >     in the receive queue.
> > > > 3. choose a client machine, and create 100 TCP connection
> > > >     to the 8888 port of the server. Then, every connection sends
> > > >     data about 1M.
> > > > 4. we can see that some of the connection enter the 0-probe
> > > >     state, but some of them keep retrans again and again. As
> > > >     the server is up to the tcp_mem[2] and skb is dropped before
> > > >     the recv_buf full and the connection enter 0-probe state.
> > > >     Finially, some of these connection will timeout and break.
> > > >
> > > > With this series, all the 100 connections will enter 0-probe
> > > > status and connection break won't happen. And the data
> > > > trans will recover if we increase tcp_mem or call 'recv()'
> > > > on the sockets in the server.
> > > >
> > > > > Also, such fundamental change would need IETF discussion first.
> > > > > We do not want linux to cause network collapses just because bill=
ions
> > > > > of devices send more zero probes.
> > > >
> > > > I think it maybe a good idea to make the connection enter
> > > > 0-probe, rather than drop the skb silently. What 0-probe
> > > > meaning is to wait for space available when the buffer of the
> > > > receive queue is full. And maybe we can also use 0-probe
> > > > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > > > is full?
> > > >
> > > > Am I right?
> > > >
> > > > Thanks!
> > > > Menglong Dong
> > >
> > > Thanks for describing the scenario in more detail. (Some kind of
> > > packetdrill script or other program to reproduce this issue would be
> > > nice, too, as Eric noted.)
> > >
> > > You mention in step (4.) above that some of the connections keep
> > > retransmitting again and again. Are those connections receiving any
> > > ACKs in response to their retransmissions? Perhaps they are receiving
> > > dupacks?
> >
> > Actually, these packets are dropped without any reply, even dupacks.
> > skb will be dropped directly when tcp_try_rmem_schedule()
> > fails in tcp_data_queue(). That's reasonable, as it's
> > useless to reply a ack to the sender, which will cause the sender
> > fast retrans the packet, because we are out of memory now, and
> > retrans can't solve the problem.
>
> I'm not sure I see the problem. If retransmits can't solve the
> problem, then why are you proposing that data senders keep
> retransmitting forever (via 0-window-probes) in this kind of scenario?
>

Because the connection will break if the count of
retransmits up to tcp_retires2, but probe-0 can keep
for a long time.

> A single dupack without SACK blocks will not cause the sender to fast
> retransmit. (Only 3 dupacks would trigger fast retransmit.)
>
> Three or more dupacks without SACK blocks will cause the sender to
> fast retransmit the segment above SND.UNA once if the sender doesn't
> have SACK support. But in this case AFAICT fast-retransmitting once is
> a fine strategy, since the sender should keep retrying transmits (with
> backoff) until the receiver potentially has memory available to
> receive the packet.
>
> >
> > > If so, then perhaps we could solve this problem without
> > > depending on a violation of the TCP spec (which says the receive
> > > window should not be retracted) in the following way: when a data
> > > sender suffers a retransmission timeout, and retransmits the first
> > > unacknowledged segment, and receives a dupack for SND.UNA instead of
> > > an ACK covering the RTO-retransmitted segment, then the data sender
> > > should estimate that the receiver doesn't have enough memory to buffe=
r
> > > the retransmitted packet. In that case, the data sender should enter
> > > the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 timer to
> > > call tcp_probe_timer().
> > >
> > > Basically we could try to enhance the sender-side logic to try to
> > > distinguish between two kinds of problems:
> > >
> > > (a) Repeated data packet loss caused by congestion, routing problems,
> > > or connectivity problems. In this case, the data sender uses
> > > ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off and only
> > > retries sysctl_tcp_retries2 times before timing out the connection
> > >
> > > (b) A receiver that is repeatedly sending dupacks but not ACKing
> > > retransmitted data because it doesn't have any memory. In this case,
> > > the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), and back=
s
> > > off but keeps retrying as long as the data sender receives ACKs.
> > >
> >
> > I'm not sure if this is an ideal method, as it may be not rigorous
> > to conclude that the receiver is oom with dupacks. A packet can
> > loss can also cause multi dupacks.
>
> When a data sender suffers an RTO and retransmits a single data
> packet, it would be very rare for the data sender to receive multiple
> pure dupacks without SACKs. This would only happen in the rare case
> where (a) the connection did not have SACK enabled, and (b) there was
> a hole in the received sequence space and there were still packets in
> flight when the (spurioius) RTO fired.
>
> But if we want to be paranoid, then this new response could be written
> to only trigger if SACK is enabled (the vast, vast majority of cases).
> If SACK is enabled, and an RTO of a data packet starting at sequence
> S1 results in the receiver sending only a dupack for S1 without SACK
> blocks, then this clearly shows the issue is not packet loss but
> suggests a receiver unable to buffer the given data packet, AFAICT.
>

Yeah, you are right on this point, multi pure dupacks can
mean out of memory of the receiver. But we still need to
know if the receiver recovers from OOM. Without window
shrink, the window in the ack of zero-window probe packet
is not zero on OOM.

Hi, Eric and kuba, do you have any comments on this
case?

Thanks!
Menglong Dong

> thanks,
> neal
>
> >
> > Thanks!
> > Menglong Dong
> >
> > > AFAICT that would be another way to reach the happy state you mention=
:
> > > "all the 100 connections will enter 0-probe status and connection
> > > break won't happen", and we could reach that state without violating
> > > the TCP protocol spec and without requiring changes on the receiver
> > > side (so that this fix could help in scenarios where the
> > > memory-constrained receiver is an older stack without special new
> > > behavior).
> > >
> > > Eric, Yuchung, Menglong: do you think something like that would work?
> > >
> > > neal

