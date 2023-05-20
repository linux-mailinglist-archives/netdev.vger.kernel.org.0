Return-Path: <netdev+bounces-4073-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3FFB70A882
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 16:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19FCE2811C4
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 14:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8506AB5;
	Sat, 20 May 2023 14:28:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF32A63C7
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 14:28:32 +0000 (UTC)
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAE6116
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 07:28:30 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-436161f2cf2so1441432137.2
        for <netdev@vger.kernel.org>; Sat, 20 May 2023 07:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684592910; x=1687184910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnahHUDaOzUYBYnHGcO8vg1OxYRFdXQA4RSYztwTqns=;
        b=6jmRYHUSy+3V1Pm1Me1w0q39JXv8J9u99nlq4qhDFFVcHxQXiDnWEVj9/X1gRLSpaA
         Ovc0SnNq52kDPkkFIHhTw7qT91jQj0bqPIzXdOeveKMAGouS2yZqTPO9cShDU+6FvYPt
         2u7fc/aBq2QTfW4EdIw9i3D55P9hwdRUw0UXInYD7D2iJSTghJPiZ4p6uQB/RRtuj9Jq
         F/Lnn7woUCzP+dzpvSd8+gDIMqoVJvmtOi2jHLuQrRfyS6PvdRgA5Uj+Xxpuoppkpa+o
         7ZXqUkrAA2vEDqiN0MycK0pomf3OrA1I1Sr9bcTm2N6i2+8pjxmy+ZXY+CICMUuxlTBD
         jb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684592910; x=1687184910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnahHUDaOzUYBYnHGcO8vg1OxYRFdXQA4RSYztwTqns=;
        b=S2Npw1SAKO81d99+XN4KumBaribaKf4p+E58Ztt98MeTGgFwB1Xndm6YjKbpO0bXE3
         v31D1sUuZQswS4JAJf4Hppv2AABXKmBYCNIX3KKwgaQPuKVH1zi8q4i5+GyVMrk1w5yN
         clge8i21gY3Jjxav5PJwxniDojJX/TyJoiHJYm3ouaf1MAtFxo/8udrliKb0PUBrLTQy
         N6BPZtqwLzVBvv+Myi7k9CViJ76JfcEhhip75YmAKclIzkG/AURy1hle67/Y/qhDVQRn
         kb+btZ8jvALhP7nvqak9MBP33aKAGu8u9Scm+7QCYuheQ/dyhy4EO/34JMeIh73d0KjT
         3HJQ==
X-Gm-Message-State: AC+VfDwlik+yZBx7Dp62fTJnxhI7FGCbZd2BL/y02aRwNNG1qb7w4hCN
	ez11owXiDwKAnsnyCOl8YhFhjIV8S05GRTw726PoMw==
X-Google-Smtp-Source: ACHHUZ7VsWAWuvH8EJv6/vbMtYMacrJCln2WeQNa1k9rtsXydkvUh9DBsranpuSJAwvjfY8Bz44npMDWqiZ0zG1amQo=
X-Received: by 2002:a05:6102:7a8:b0:438:d4bd:f1f2 with SMTP id
 x8-20020a05610207a800b00438d4bdf1f2mr931731vsg.22.1684592909593; Sat, 20 May
 2023 07:28:29 -0700 (PDT)
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
 <CADxym3ZiyYK7Vyz05qLv8jOPmNZXXepCsTbZxdkhSQxRx0cdSA@mail.gmail.com>
 <CADVnQy=JQkVGRsbL0u=-oZSpdaFBpz907yX24p3uUu2pMhUjGg@mail.gmail.com> <CADxym3awe-c29C-e1Y+efepLdpFWrG520ezJO1EjJ5C3arq6Eg@mail.gmail.com>
In-Reply-To: <CADxym3awe-c29C-e1Y+efepLdpFWrG520ezJO1EjJ5C3arq6Eg@mail.gmail.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Sat, 20 May 2023 10:28:12 -0400
Message-ID: <CADVnQyk2y68HKScad4W2jOy9uqe7TTCyY-StwdLWFPJhXU+CUA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, kuba@kernel.org, davem@davemloft.net, 
	pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>, 
	Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 5:08=E2=80=AFAM Menglong Dong <menglong8.dong@gmail=
.com> wrote:
>
> On Fri, May 19, 2023 at 12:03=E2=80=AFAM Neal Cardwell <ncardwell@google.=
com> wrote:
> >
> > On Thu, May 18, 2023 at 10:12=E2=80=AFAM Menglong Dong <menglong8.dong@=
gmail.com> wrote:
> > >
> > > On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardwell@goog=
le.com> wrote:
> > > >
> > > > On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <menglong8.d=
ong@gmail.com> wrote:
> > > > >
> > > > > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet@g=
oogle.com> wrote:
> > > > > >
> > > > > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.c=
om> wrote:
> > > > > > >
> > > > > > > From: Menglong Dong <imagedong@tencent.com>
> > > > > > >
> > > > > > > Window shrink is not allowed and also not handled for now, bu=
t it's
> > > > > > > needed in some case.
> > > > > > >
> > > > > > > In the origin logic, 0 probe is triggered only when there is =
no any
> > > > > > > data in the retrans queue and the receive window can't hold t=
he data
> > > > > > > of the 1th packet in the send queue.
> > > > > > >
> > > > > > > Now, let's change it and trigger the 0 probe in such cases:
> > > > > > >
> > > > > > > - if the retrans queue has data and the 1th packet in it is n=
ot within
> > > > > > > the receive window
> > > > > > > - no data in the retrans queue and the 1th packet in the send=
 queue is
> > > > > > > out of the end of the receive window
> > > > > >
> > > > > > Sorry, I do not understand.
> > > > > >
> > > > > > Please provide packetdrill tests for new behavior like that.
> > > > > >
> > > > >
> > > > > Yes. The problem can be reproduced easily.
> > > > >
> > > > > 1. choose a server machine, decrease it's tcp_mem with:
> > > > >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > > > > 2. call listen() and accept() on a port, such as 8888. We call
> > > > >     accept() looply and without call recv() to make the data stay
> > > > >     in the receive queue.
> > > > > 3. choose a client machine, and create 100 TCP connection
> > > > >     to the 8888 port of the server. Then, every connection sends
> > > > >     data about 1M.
> > > > > 4. we can see that some of the connection enter the 0-probe
> > > > >     state, but some of them keep retrans again and again. As
> > > > >     the server is up to the tcp_mem[2] and skb is dropped before
> > > > >     the recv_buf full and the connection enter 0-probe state.
> > > > >     Finially, some of these connection will timeout and break.
> > > > >
> > > > > With this series, all the 100 connections will enter 0-probe
> > > > > status and connection break won't happen. And the data
> > > > > trans will recover if we increase tcp_mem or call 'recv()'
> > > > > on the sockets in the server.
> > > > >
> > > > > > Also, such fundamental change would need IETF discussion first.
> > > > > > We do not want linux to cause network collapses just because bi=
llions
> > > > > > of devices send more zero probes.
> > > > >
> > > > > I think it maybe a good idea to make the connection enter
> > > > > 0-probe, rather than drop the skb silently. What 0-probe
> > > > > meaning is to wait for space available when the buffer of the
> > > > > receive queue is full. And maybe we can also use 0-probe
> > > > > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > > > > is full?
> > > > >
> > > > > Am I right?
> > > > >
> > > > > Thanks!
> > > > > Menglong Dong
> > > >
> > > > Thanks for describing the scenario in more detail. (Some kind of
> > > > packetdrill script or other program to reproduce this issue would b=
e
> > > > nice, too, as Eric noted.)
> > > >
> > > > You mention in step (4.) above that some of the connections keep
> > > > retransmitting again and again. Are those connections receiving any
> > > > ACKs in response to their retransmissions? Perhaps they are receivi=
ng
> > > > dupacks?
> > >
> > > Actually, these packets are dropped without any reply, even dupacks.
> > > skb will be dropped directly when tcp_try_rmem_schedule()
> > > fails in tcp_data_queue(). That's reasonable, as it's
> > > useless to reply a ack to the sender, which will cause the sender
> > > fast retrans the packet, because we are out of memory now, and
> > > retrans can't solve the problem.
> >
> > I'm not sure I see the problem. If retransmits can't solve the
> > problem, then why are you proposing that data senders keep
> > retransmitting forever (via 0-window-probes) in this kind of scenario?
> >
>
> Because the connection will break if the count of
> retransmits up to tcp_retires2, but probe-0 can keep
> for a long time.

I see. So it sounds like you agree that retransmits can solve the
problem, as long as the retransmits are using the zero-window probe
state machine (ICSK_TIME_PROBE0, tcp_probe_timer()), which continues
as long as the receiver is sending ACKs. And it sounds like when you
said "retrans can't solve the problem" you didn't literally mean that
retransmits can't solve the problem, but rather you meant that the RTO
state machine, specifically (ICSK_TIME_RETRANS,
tcp_retransmit_timer(), etc) can't solve the problem. I agree with
that assessment that in this scenario tcp_probe_timer() seems like a
solution but tcp_retransmit_timer() does not.

> > A single dupack without SACK blocks will not cause the sender to fast
> > retransmit. (Only 3 dupacks would trigger fast retransmit.)
> >
> > Three or more dupacks without SACK blocks will cause the sender to
> > fast retransmit the segment above SND.UNA once if the sender doesn't
> > have SACK support. But in this case AFAICT fast-retransmitting once is
> > a fine strategy, since the sender should keep retrying transmits (with
> > backoff) until the receiver potentially has memory available to
> > receive the packet.
> >
> > >
> > > > If so, then perhaps we could solve this problem without
> > > > depending on a violation of the TCP spec (which says the receive
> > > > window should not be retracted) in the following way: when a data
> > > > sender suffers a retransmission timeout, and retransmits the first
> > > > unacknowledged segment, and receives a dupack for SND.UNA instead o=
f
> > > > an ACK covering the RTO-retransmitted segment, then the data sender
> > > > should estimate that the receiver doesn't have enough memory to buf=
fer
> > > > the retransmitted packet. In that case, the data sender should ente=
r
> > > > the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 timer to
> > > > call tcp_probe_timer().
> > > >
> > > > Basically we could try to enhance the sender-side logic to try to
> > > > distinguish between two kinds of problems:
> > > >
> > > > (a) Repeated data packet loss caused by congestion, routing problem=
s,
> > > > or connectivity problems. In this case, the data sender uses
> > > > ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off and onl=
y
> > > > retries sysctl_tcp_retries2 times before timing out the connection
> > > >
> > > > (b) A receiver that is repeatedly sending dupacks but not ACKing
> > > > retransmitted data because it doesn't have any memory. In this case=
,
> > > > the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), and ba=
cks
> > > > off but keeps retrying as long as the data sender receives ACKs.
> > > >
> > >
> > > I'm not sure if this is an ideal method, as it may be not rigorous
> > > to conclude that the receiver is oom with dupacks. A packet can
> > > loss can also cause multi dupacks.
> >
> > When a data sender suffers an RTO and retransmits a single data
> > packet, it would be very rare for the data sender to receive multiple
> > pure dupacks without SACKs. This would only happen in the rare case
> > where (a) the connection did not have SACK enabled, and (b) there was
> > a hole in the received sequence space and there were still packets in
> > flight when the (spurioius) RTO fired.
> >
> > But if we want to be paranoid, then this new response could be written
> > to only trigger if SACK is enabled (the vast, vast majority of cases).
> > If SACK is enabled, and an RTO of a data packet starting at sequence
> > S1 results in the receiver sending only a dupack for S1 without SACK
> > blocks, then this clearly shows the issue is not packet loss but
> > suggests a receiver unable to buffer the given data packet, AFAICT.
> >
>
> Yeah, you are right on this point, multi pure dupacks can
> mean out of memory of the receiver. But we still need to
> know if the receiver recovers from OOM. Without window
> shrink, the window in the ack of zero-window probe packet
> is not zero on OOM.

But do we need a protocol-violating zero-window in this case? Why not
use my approach suggested above: conveying the OOM condition by
sending an ACK but not ACKing the retransmitted packet?

Thanks,
neal

> Hi, Eric and kuba, do you have any comments on this
> case?
>
> Thanks!
> Menglong Dong
>
> > thanks,
> > neal
> >
> > >
> > > Thanks!
> > > Menglong Dong
> > >
> > > > AFAICT that would be another way to reach the happy state you menti=
on:
> > > > "all the 100 connections will enter 0-probe status and connection
> > > > break won't happen", and we could reach that state without violatin=
g
> > > > the TCP protocol spec and without requiring changes on the receiver
> > > > side (so that this fix could help in scenarios where the
> > > > memory-constrained receiver is an older stack without special new
> > > > behavior).
> > > >
> > > > Eric, Yuchung, Menglong: do you think something like that would wor=
k?
> > > >
> > > > neal

