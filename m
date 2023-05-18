Return-Path: <netdev+bounces-3661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02FE77083A1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC4211C20FC5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6192C209AA;
	Thu, 18 May 2023 14:12:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD4123C69
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:12:07 +0000 (UTC)
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34A4DC;
	Thu, 18 May 2023 07:12:03 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 3f1490d57ef6-ba6d024a196so1780307276.2;
        Thu, 18 May 2023 07:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684419123; x=1687011123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZgWXPTe1ZG4Sw/b1mpfq3+D2E79rsdzVUg9Htd0C1I=;
        b=nQCx1Fb704okQyK869FxXTPFNzbbbeXJPFjY3YNtSJiJ34R7ANcOTfOCBTBxgUz1v/
         4lgpnWaSBMlfJ6UugEXUL590pNC3ehvBBnc33W9HiUAEw6LtA6ZMx73aQ/8lDU7eA4VK
         s92KHROyZwH6VM2K34So3/2NIhfg7RJcEeBvDEwrKw3MWognZMwmxWKhmeaWMb+sW1OM
         2WAyuyD3ma4nv0RENopUIE6qO1Yog3kehphCTKeEqJEtOzllT1ety04HqDyoRp0buMTw
         N/EVads6jSmThIQxvJHMMcG2a2IdHC1+rQNnuznQjGtY7qVuaHSUokkP0befQc0IAZuL
         1FRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684419123; x=1687011123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZgWXPTe1ZG4Sw/b1mpfq3+D2E79rsdzVUg9Htd0C1I=;
        b=M+AOeAjll1MPDSfijaz5CePIepiY+A0JxxwpjubhOoP0kZl/NzxKuGEIlz4WKaC4/Z
         284Bdk3NRgHLpUCsIM0ScQfilfGtMXwUydUE4CPVw7eVSU4XQfWYhzzmWnWRaDOCq6XU
         6H7QU9txLgNb0b5ME/LBzb8zMHCEUg2zqSNUDc6pPwOq3AT6f0zuPQg7xJvlXamju9Pb
         JStU0qSHZCpBMHfZ3vpGn5fYtm/GFeaolB+88H5OuyjKFgA0g3VcVEyJlljZfbYGBczA
         TfsG4/Q47Uw5uX2uVoJAtI9YdjEzTyqJ9klOsjy7tkSBEyNYH1/59ZqxV+fkXBhLNteu
         sSwQ==
X-Gm-Message-State: AC+VfDwiQgRi7OiWX6FXdhkBYz9bQGJmrE9tysK6ksxf5K54TnDOOwj2
	KmFq9jO6TE6njc5xp5vWsoO6DnfOCswPoMm8QKU=
X-Google-Smtp-Source: ACHHUZ7Wg8xb1JH8XfeIc9gUmaEmZ1QQYbmXEsgYarNjqa8kvVLA8Lmw4xYSh9xP4U0j3obrgMp+czHwKDBtVv/H2Us=
X-Received: by 2002:a25:460a:0:b0:b9a:6cb6:b942 with SMTP id
 t10-20020a25460a000000b00b9a6cb6b942mr1368503yba.54.1684419122859; Thu, 18
 May 2023 07:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-4-imagedong@tencent.com> <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
 <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com> <CADVnQynZ67511+cKF=hyiaLx5-fqPGGmpyJ-5Lk6ge-ivmAf-w@mail.gmail.com>
In-Reply-To: <CADVnQynZ67511+cKF=hyiaLx5-fqPGGmpyJ-5Lk6ge-ivmAf-w@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Thu, 18 May 2023 22:11:51 +0800
Message-ID: <CADxym3ZiyYK7Vyz05qLv8jOPmNZXXepCsTbZxdkhSQxRx0cdSA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>, kuba@kernel.org, davem@davemloft.net, 
	pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>, 
	Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardwell@google.com=
> wrote:
>
> On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <menglong8.dong@gm=
ail.com> wrote:
> >
> > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet@google.=
com> wrote:
> > >
> > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> wr=
ote:
> > > >
> > > > From: Menglong Dong <imagedong@tencent.com>
> > > >
> > > > Window shrink is not allowed and also not handled for now, but it's
> > > > needed in some case.
> > > >
> > > > In the origin logic, 0 probe is triggered only when there is no any
> > > > data in the retrans queue and the receive window can't hold the dat=
a
> > > > of the 1th packet in the send queue.
> > > >
> > > > Now, let's change it and trigger the 0 probe in such cases:
> > > >
> > > > - if the retrans queue has data and the 1th packet in it is not wit=
hin
> > > > the receive window
> > > > - no data in the retrans queue and the 1th packet in the send queue=
 is
> > > > out of the end of the receive window
> > >
> > > Sorry, I do not understand.
> > >
> > > Please provide packetdrill tests for new behavior like that.
> > >
> >
> > Yes. The problem can be reproduced easily.
> >
> > 1. choose a server machine, decrease it's tcp_mem with:
> >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > 2. call listen() and accept() on a port, such as 8888. We call
> >     accept() looply and without call recv() to make the data stay
> >     in the receive queue.
> > 3. choose a client machine, and create 100 TCP connection
> >     to the 8888 port of the server. Then, every connection sends
> >     data about 1M.
> > 4. we can see that some of the connection enter the 0-probe
> >     state, but some of them keep retrans again and again. As
> >     the server is up to the tcp_mem[2] and skb is dropped before
> >     the recv_buf full and the connection enter 0-probe state.
> >     Finially, some of these connection will timeout and break.
> >
> > With this series, all the 100 connections will enter 0-probe
> > status and connection break won't happen. And the data
> > trans will recover if we increase tcp_mem or call 'recv()'
> > on the sockets in the server.
> >
> > > Also, such fundamental change would need IETF discussion first.
> > > We do not want linux to cause network collapses just because billions
> > > of devices send more zero probes.
> >
> > I think it maybe a good idea to make the connection enter
> > 0-probe, rather than drop the skb silently. What 0-probe
> > meaning is to wait for space available when the buffer of the
> > receive queue is full. And maybe we can also use 0-probe
> > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > is full?
> >
> > Am I right?
> >
> > Thanks!
> > Menglong Dong
>
> Thanks for describing the scenario in more detail. (Some kind of
> packetdrill script or other program to reproduce this issue would be
> nice, too, as Eric noted.)
>
> You mention in step (4.) above that some of the connections keep
> retransmitting again and again. Are those connections receiving any
> ACKs in response to their retransmissions? Perhaps they are receiving
> dupacks?

Actually, these packets are dropped without any reply, even dupacks.
skb will be dropped directly when tcp_try_rmem_schedule()
fails in tcp_data_queue(). That's reasonable, as it's
useless to reply a ack to the sender, which will cause the sender
fast retrans the packet, because we are out of memory now, and
retrans can't solve the problem.

> If so, then perhaps we could solve this problem without
> depending on a violation of the TCP spec (which says the receive
> window should not be retracted) in the following way: when a data
> sender suffers a retransmission timeout, and retransmits the first
> unacknowledged segment, and receives a dupack for SND.UNA instead of
> an ACK covering the RTO-retransmitted segment, then the data sender
> should estimate that the receiver doesn't have enough memory to buffer
> the retransmitted packet. In that case, the data sender should enter
> the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 timer to
> call tcp_probe_timer().
>
> Basically we could try to enhance the sender-side logic to try to
> distinguish between two kinds of problems:
>
> (a) Repeated data packet loss caused by congestion, routing problems,
> or connectivity problems. In this case, the data sender uses
> ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off and only
> retries sysctl_tcp_retries2 times before timing out the connection
>
> (b) A receiver that is repeatedly sending dupacks but not ACKing
> retransmitted data because it doesn't have any memory. In this case,
> the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), and backs
> off but keeps retrying as long as the data sender receives ACKs.
>

I'm not sure if this is an ideal method, as it may be not rigorous
to conclude that the receiver is oom with dupacks. A packet can
loss can also cause multi dupacks.

Thanks!
Menglong Dong

> AFAICT that would be another way to reach the happy state you mention:
> "all the 100 connections will enter 0-probe status and connection
> break won't happen", and we could reach that state without violating
> the TCP protocol spec and without requiring changes on the receiver
> side (so that this fix could help in scenarios where the
> memory-constrained receiver is an older stack without special new
> behavior).
>
> Eric, Yuchung, Menglong: do you think something like that would work?
>
> neal

