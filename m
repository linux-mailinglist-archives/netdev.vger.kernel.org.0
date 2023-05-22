Return-Path: <netdev+bounces-4135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C86E170B366
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 04:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E9E7280E5C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 02:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A67A4C;
	Mon, 22 May 2023 02:55:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EE2A2C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 02:55:24 +0000 (UTC)
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A00A0;
	Sun, 21 May 2023 19:55:22 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 3f1490d57ef6-bab8f66d3a2so3613614276.3;
        Sun, 21 May 2023 19:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684724122; x=1687316122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EByqJK3fZFvbzEbYq4Gg3GsKIQs2/LZcmxocyBfm1M=;
        b=Hkhc3HRvoYOAWEVUYll8PBl5bCKP68JgnaMlGbsDE8kg++B7VjTKp6nuiTPHiw+NML
         0TKBqcnhkbF8Kt90Rb37BLPMQ6musDH0odrq3SkI4dcRUJrFDyVOfnHYJNessycRessL
         Ut7MFhSxqogMQavuYvtqs/SiHWxCDI0B/9HdPozIcjeBGgsAx/hvEAASg3HS971oiwEk
         1+Tgj1rNa6RfOh74ZPZLvRrEM1KExeV8KzkOnzYMpquwn6m1Lu2X4vhNhTlISPllvRYf
         Yn+IgI7WBddDUNsQsSxQdnMXY+2kZrz1rFXgMMYM2nKpf5pgXAlKQ72/lWpWtPyc3IE+
         5/EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684724122; x=1687316122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EByqJK3fZFvbzEbYq4Gg3GsKIQs2/LZcmxocyBfm1M=;
        b=IM48WEFGV8qelGj0vxdizM/E03ERc37SPJlqX+DxrIna2RJ50VAjkX685pLfQ5w7Na
         IBTROwuC2KMY7TIoUSSsjkIjWYDd2bd9wWxeYECxeG7AtMF1C9WAKLz8V42m6+Qia8TZ
         iAMAUpO8JpEbWIwc4yPgoDgerft+qvsAtwTvDwKOljxug1Bf/ZS6nXguruzyR+c0F2mB
         /x8IPexJWsjQe2d/XIMBF43jtxFUWW4fc1M0BdMiUPqXkvNdXLzENLyeP9IdGKVUqAMQ
         Pd79Kl7WdMn0e8eZeGkfc/KziaMFQ0eL8AtPf9VXvunKT9eJ0/o+O+Yk+j5alfn0CI7h
         hgKQ==
X-Gm-Message-State: AC+VfDyHcPyVPGYX7/bz+VAocBm0FLOGtdgVM2+HSr9xJFtems+m+PBl
	0pxq/PP8/WrT/nriXBJGd7GroUfIPBod9QdURQuresoaWtcm7mAQ
X-Google-Smtp-Source: ACHHUZ4UzbXkCAOOAkEwwHp2luGgipD7y+kJJYReGvIO6TXtEZKqEhNHXf4UUtxXzPGvEPDUwa9nmv/WIACjmP06reI=
X-Received: by 2002:a81:54d4:0:b0:55a:5b19:ca9 with SMTP id
 i203-20020a8154d4000000b0055a5b190ca9mr9994933ywb.36.1684724121787; Sun, 21
 May 2023 19:55:21 -0700 (PDT)
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
 <CADVnQy=JQkVGRsbL0u=-oZSpdaFBpz907yX24p3uUu2pMhUjGg@mail.gmail.com>
 <CADxym3awe-c29C-e1Y+efepLdpFWrG520ezJO1EjJ5C3arq6Eg@mail.gmail.com> <CADVnQyk2y68HKScad4W2jOy9uqe7TTCyY-StwdLWFPJhXU+CUA@mail.gmail.com>
In-Reply-To: <CADVnQyk2y68HKScad4W2jOy9uqe7TTCyY-StwdLWFPJhXU+CUA@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Mon, 22 May 2023 10:55:10 +0800
Message-ID: <CADxym3bbGkOv4dwATp6wT0KA4ZPiPGfxvqvYtEzF45GJDe=RXQ@mail.gmail.com>
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

On Sat, May 20, 2023 at 10:28=E2=80=AFPM Neal Cardwell <ncardwell@google.co=
m> wrote:
>
> On Sat, May 20, 2023 at 5:08=E2=80=AFAM Menglong Dong <menglong8.dong@gma=
il.com> wrote:
> >
> > On Fri, May 19, 2023 at 12:03=E2=80=AFAM Neal Cardwell <ncardwell@googl=
e.com> wrote:
> > >
> > > On Thu, May 18, 2023 at 10:12=E2=80=AFAM Menglong Dong <menglong8.don=
g@gmail.com> wrote:
> > > >
> > > > On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardwell@go=
ogle.com> wrote:
> > > > >
> > > > > On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <menglong8=
.dong@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet=
@google.com> wrote:
> > > > > > >
> > > > > > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail=
.com> wrote:
> > > > > > > >
> > > > > > > > From: Menglong Dong <imagedong@tencent.com>
> > > > > > > >
> > > > > > > > Window shrink is not allowed and also not handled for now, =
but it's
> > > > > > > > needed in some case.
> > > > > > > >
> > > > > > > > In the origin logic, 0 probe is triggered only when there i=
s no any
> > > > > > > > data in the retrans queue and the receive window can't hold=
 the data
> > > > > > > > of the 1th packet in the send queue.
> > > > > > > >
> > > > > > > > Now, let's change it and trigger the 0 probe in such cases:
> > > > > > > >
> > > > > > > > - if the retrans queue has data and the 1th packet in it is=
 not within
> > > > > > > > the receive window
> > > > > > > > - no data in the retrans queue and the 1th packet in the se=
nd queue is
> > > > > > > > out of the end of the receive window
> > > > > > >
> > > > > > > Sorry, I do not understand.
> > > > > > >
> > > > > > > Please provide packetdrill tests for new behavior like that.
> > > > > > >
> > > > > >
> > > > > > Yes. The problem can be reproduced easily.
> > > > > >
> > > > > > 1. choose a server machine, decrease it's tcp_mem with:
> > > > > >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > > > > > 2. call listen() and accept() on a port, such as 8888. We call
> > > > > >     accept() looply and without call recv() to make the data st=
ay
> > > > > >     in the receive queue.
> > > > > > 3. choose a client machine, and create 100 TCP connection
> > > > > >     to the 8888 port of the server. Then, every connection send=
s
> > > > > >     data about 1M.
> > > > > > 4. we can see that some of the connection enter the 0-probe
> > > > > >     state, but some of them keep retrans again and again. As
> > > > > >     the server is up to the tcp_mem[2] and skb is dropped befor=
e
> > > > > >     the recv_buf full and the connection enter 0-probe state.
> > > > > >     Finially, some of these connection will timeout and break.
> > > > > >
> > > > > > With this series, all the 100 connections will enter 0-probe
> > > > > > status and connection break won't happen. And the data
> > > > > > trans will recover if we increase tcp_mem or call 'recv()'
> > > > > > on the sockets in the server.
> > > > > >
> > > > > > > Also, such fundamental change would need IETF discussion firs=
t.
> > > > > > > We do not want linux to cause network collapses just because =
billions
> > > > > > > of devices send more zero probes.
> > > > > >
> > > > > > I think it maybe a good idea to make the connection enter
> > > > > > 0-probe, rather than drop the skb silently. What 0-probe
> > > > > > meaning is to wait for space available when the buffer of the
> > > > > > receive queue is full. And maybe we can also use 0-probe
> > > > > > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > > > > > is full?
> > > > > >
> > > > > > Am I right?
> > > > > >
> > > > > > Thanks!
> > > > > > Menglong Dong
> > > > >
> > > > > Thanks for describing the scenario in more detail. (Some kind of
> > > > > packetdrill script or other program to reproduce this issue would=
 be
> > > > > nice, too, as Eric noted.)
> > > > >
> > > > > You mention in step (4.) above that some of the connections keep
> > > > > retransmitting again and again. Are those connections receiving a=
ny
> > > > > ACKs in response to their retransmissions? Perhaps they are recei=
ving
> > > > > dupacks?
> > > >
> > > > Actually, these packets are dropped without any reply, even dupacks=
.
> > > > skb will be dropped directly when tcp_try_rmem_schedule()
> > > > fails in tcp_data_queue(). That's reasonable, as it's
> > > > useless to reply a ack to the sender, which will cause the sender
> > > > fast retrans the packet, because we are out of memory now, and
> > > > retrans can't solve the problem.
> > >
> > > I'm not sure I see the problem. If retransmits can't solve the
> > > problem, then why are you proposing that data senders keep
> > > retransmitting forever (via 0-window-probes) in this kind of scenario=
?
> > >
> >
> > Because the connection will break if the count of
> > retransmits up to tcp_retires2, but probe-0 can keep
> > for a long time.
>
> I see. So it sounds like you agree that retransmits can solve the
> problem, as long as the retransmits are using the zero-window probe
> state machine (ICSK_TIME_PROBE0, tcp_probe_timer()), which continues
> as long as the receiver is sending ACKs. And it sounds like when you
> said "retrans can't solve the problem" you didn't literally mean that
> retransmits can't solve the problem, but rather you meant that the RTO
> state machine, specifically (ICSK_TIME_RETRANS,
> tcp_retransmit_timer(), etc) can't solve the problem. I agree with
> that assessment that in this scenario tcp_probe_timer() seems like a
> solution but tcp_retransmit_timer() does not.
>

Yes, that is indeed what I want to express.

> > > A single dupack without SACK blocks will not cause the sender to fast
> > > retransmit. (Only 3 dupacks would trigger fast retransmit.)
> > >
> > > Three or more dupacks without SACK blocks will cause the sender to
> > > fast retransmit the segment above SND.UNA once if the sender doesn't
> > > have SACK support. But in this case AFAICT fast-retransmitting once i=
s
> > > a fine strategy, since the sender should keep retrying transmits (wit=
h
> > > backoff) until the receiver potentially has memory available to
> > > receive the packet.
> > >
> > > >
> > > > > If so, then perhaps we could solve this problem without
> > > > > depending on a violation of the TCP spec (which says the receive
> > > > > window should not be retracted) in the following way: when a data
> > > > > sender suffers a retransmission timeout, and retransmits the firs=
t
> > > > > unacknowledged segment, and receives a dupack for SND.UNA instead=
 of
> > > > > an ACK covering the RTO-retransmitted segment, then the data send=
er
> > > > > should estimate that the receiver doesn't have enough memory to b=
uffer
> > > > > the retransmitted packet. In that case, the data sender should en=
ter
> > > > > the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 timer t=
o
> > > > > call tcp_probe_timer().
> > > > >
> > > > > Basically we could try to enhance the sender-side logic to try to
> > > > > distinguish between two kinds of problems:
> > > > >
> > > > > (a) Repeated data packet loss caused by congestion, routing probl=
ems,
> > > > > or connectivity problems. In this case, the data sender uses
> > > > > ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off and o=
nly
> > > > > retries sysctl_tcp_retries2 times before timing out the connectio=
n
> > > > >
> > > > > (b) A receiver that is repeatedly sending dupacks but not ACKing
> > > > > retransmitted data because it doesn't have any memory. In this ca=
se,
> > > > > the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), and =
backs
> > > > > off but keeps retrying as long as the data sender receives ACKs.
> > > > >
> > > >
> > > > I'm not sure if this is an ideal method, as it may be not rigorous
> > > > to conclude that the receiver is oom with dupacks. A packet can
> > > > loss can also cause multi dupacks.
> > >
> > > When a data sender suffers an RTO and retransmits a single data
> > > packet, it would be very rare for the data sender to receive multiple
> > > pure dupacks without SACKs. This would only happen in the rare case
> > > where (a) the connection did not have SACK enabled, and (b) there was
> > > a hole in the received sequence space and there were still packets in
> > > flight when the (spurioius) RTO fired.
> > >
> > > But if we want to be paranoid, then this new response could be writte=
n
> > > to only trigger if SACK is enabled (the vast, vast majority of cases)=
.
> > > If SACK is enabled, and an RTO of a data packet starting at sequence
> > > S1 results in the receiver sending only a dupack for S1 without SACK
> > > blocks, then this clearly shows the issue is not packet loss but
> > > suggests a receiver unable to buffer the given data packet, AFAICT.
> > >
> >
> > Yeah, you are right on this point, multi pure dupacks can
> > mean out of memory of the receiver. But we still need to
> > know if the receiver recovers from OOM. Without window
> > shrink, the window in the ack of zero-window probe packet
> > is not zero on OOM.
>
> But do we need a protocol-violating zero-window in this case? Why not
> use my approach suggested above: conveying the OOM condition by
> sending an ACK but not ACKing the retransmitted packet?
>

I agree with you about the approach you mentioned
about conveying the OOM condition. But that approach
can't convey the recovery from OOM, can it?

Let's see the process. With 3 pure dupack for SND.UNA,
we deem the OOM of the receiver and make the sender
enter zero-window probe state.

The sender will keep sending probe0 packets, and the
receiver will reply an ack. However, as we don't
shrink the window actually, the window in the ack is
not zero on OOM, so we can't know if the receiver has
recovered from OOM and retransmit the data in retransmit
queue.

BTW, the probe0 will send the last byte that was already
acked, so the ack of the probe0 will be a pure dupack.

Did I miss something?

BTW, a previous patch has explained the need to
support window shrink, which should satisfy the RFC
of TCP protocol:

https://lore.kernel.org/netdev/20230308053353.675086-1-mfreemon@cloudflare.=
com/

Thanks!
Menglong Dong

> Thanks,
> neal
>
> > Hi, Eric and kuba, do you have any comments on this
> > case?
> >
> > Thanks!
> > Menglong Dong
> >
> > > thanks,
> > > neal
> > >
> > > >
> > > > Thanks!
> > > > Menglong Dong
> > > >
> > > > > AFAICT that would be another way to reach the happy state you men=
tion:
> > > > > "all the 100 connections will enter 0-probe status and connection
> > > > > break won't happen", and we could reach that state without violat=
ing
> > > > > the TCP protocol spec and without requiring changes on the receiv=
er
> > > > > side (so that this fix could help in scenarios where the
> > > > > memory-constrained receiver is an older stack without special new
> > > > > behavior).
> > > > >
> > > > > Eric, Yuchung, Menglong: do you think something like that would w=
ork?
> > > > >
> > > > > neal

