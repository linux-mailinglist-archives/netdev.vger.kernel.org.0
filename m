Return-Path: <netdev+bounces-4679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74AC270DD6E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB546281305
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F001E506;
	Tue, 23 May 2023 13:27:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7D6FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:27:38 +0000 (UTC)
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F49FF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:27:35 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id ada2fe7eead31-437e2e0a5c7so1765424137.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684848455; x=1687440455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrPstjuDfJ4ubdtEpuiqFdwZENDF6KFV0h9OdIBWvhc=;
        b=xvRYZeMlaP1qcD7HVQiuJ2JPL+3rV+ax0DM1kEabcaDpXoMY4PM6TRNEWVI+IDrn1B
         ZnvXgHgalW063DhJ875iJG1Y+dIcMdLOYClXn+IqxexmNclkHmqkM8CSm1sTpdkmnuok
         vplHJdxT/mTsqzxaHqHjtqsPJNVN9KyrnbTgGJuAJXTx4ZiT8bCShuN24oHhwBuXUMc4
         ZvkRvm+mf1D5S5sLzrMGlo9bQNrqjzmaGgLhIE6YYySwIxeT5B/FMDJFdSL/wlk/a7ev
         hUAtiACQYXUe81BJmflamqU6MuXg95CcugjXVo+Mn0J7HCWVpz+eGmvGiBRVva3cl+5/
         N9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684848455; x=1687440455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qrPstjuDfJ4ubdtEpuiqFdwZENDF6KFV0h9OdIBWvhc=;
        b=hZFJCiyGPHARQIhzX5umVdFIueRkVMXOZsLsFR59Z3cV3hsBGIDdiU9G9h7c6fXO9s
         uvB30KVyWSWowKQ54UqGJEr9Py0s+wmIIBSZrYnGu9zP6XR+Yz4QY/66iqZDwPaLyKLp
         yfVfhgj7DxMrPRUvK4hlkhtcQ5GX3vzTfvBais6Pq/r7IA/4ZTLNsFQj6R65Pu/XR6ec
         T/R5HmYI7kDzyCHHqDKpDRcHVz6tdwbh/lqvIZ3zv9sIRXc5Vk5cL3ngpiost51YDn6p
         xWa0b/lkKxW0ztb0Ek96It1qfiimfBXOx7IgR7Rlj8lznLj9IAJeHHo/d2UIRtUymubV
         2uKQ==
X-Gm-Message-State: AC+VfDz0MWMtyfMF7hCNS0HYE+6akhEdNSSlzPYaZyffnkkjQy3saDE/
	hMx5yyhie4d7x45r+aKoES/SSvp1xbtoEs5SHnigAw==
X-Google-Smtp-Source: ACHHUZ6rPrrLYFMXLNhjqHodOVut9QLJZ5x2D5U7lj/dJBlnaA35Qna89oytZZrP6Roo3RmSPz57rPx8BRCyKaXDtpg=
X-Received: by 2002:a67:fb0c:0:b0:430:e0:ac2e with SMTP id d12-20020a67fb0c000000b0043000e0ac2emr3004102vsr.15.1684848454674;
 Tue, 23 May 2023 06:27:34 -0700 (PDT)
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
 <CADxym3awe-c29C-e1Y+efepLdpFWrG520ezJO1EjJ5C3arq6Eg@mail.gmail.com>
 <CADVnQyk2y68HKScad4W2jOy9uqe7TTCyY-StwdLWFPJhXU+CUA@mail.gmail.com>
 <CADxym3bbGkOv4dwATp6wT0KA4ZPiPGfxvqvYtEzF45GJDe=RXQ@mail.gmail.com>
 <CADVnQymzzZ9m30-1ZA+muvmt-bjaebtMT0Bh8Wp5vXZuYifONQ@mail.gmail.com> <CADxym3bLnLS=V5L6hZ9-PhrE3ZPpW2YD_cAG=XntEH9ky1Z0aw@mail.gmail.com>
In-Reply-To: <CADxym3bLnLS=V5L6hZ9-PhrE3ZPpW2YD_cAG=XntEH9ky1Z0aw@mail.gmail.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Tue, 23 May 2023 09:27:17 -0400
Message-ID: <CADVnQyk4Wew4iv9WRGAOiJE6fKD+OuvnwF8UQcDf+G5Ou25yUA@mail.gmail.com>
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

On Tue, May 23, 2023 at 4:59=E2=80=AFAM Menglong Dong <menglong8.dong@gmail=
.com> wrote:
>
> On Mon, May 22, 2023 at 11:04=E2=80=AFPM Neal Cardwell <ncardwell@google.=
com> wrote:
> >
> > On Sun, May 21, 2023 at 10:55=E2=80=AFPM Menglong Dong <menglong8.dong@=
gmail.com> wrote:
> > >
> > > On Sat, May 20, 2023 at 10:28=E2=80=AFPM Neal Cardwell <ncardwell@goo=
gle.com> wrote:
> > > >
> > > > On Sat, May 20, 2023 at 5:08=E2=80=AFAM Menglong Dong <menglong8.do=
ng@gmail.com> wrote:
> > > > >
> > > > > On Fri, May 19, 2023 at 12:03=E2=80=AFAM Neal Cardwell <ncardwell=
@google.com> wrote:
> > > > > >
> > > > > > On Thu, May 18, 2023 at 10:12=E2=80=AFAM Menglong Dong <menglon=
g8.dong@gmail.com> wrote:
> > > > > > >
> > > > > > > On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardw=
ell@google.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <men=
glong8.dong@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <ed=
umazet@google.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong=
@gmail.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > From: Menglong Dong <imagedong@tencent.com>
> > > > > > > > > > >
> > > > > > > > > > > Window shrink is not allowed and also not handled for=
 now, but it's
> > > > > > > > > > > needed in some case.
> > > > > > > > > > >
> > > > > > > > > > > In the origin logic, 0 probe is triggered only when t=
here is no any
> > > > > > > > > > > data in the retrans queue and the receive window can'=
t hold the data
> > > > > > > > > > > of the 1th packet in the send queue.
> > > > > > > > > > >
> > > > > > > > > > > Now, let's change it and trigger the 0 probe in such =
cases:
> > > > > > > > > > >
> > > > > > > > > > > - if the retrans queue has data and the 1th packet in=
 it is not within
> > > > > > > > > > > the receive window
> > > > > > > > > > > - no data in the retrans queue and the 1th packet in =
the send queue is
> > > > > > > > > > > out of the end of the receive window
> > > > > > > > > >
> > > > > > > > > > Sorry, I do not understand.
> > > > > > > > > >
> > > > > > > > > > Please provide packetdrill tests for new behavior like =
that.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Yes. The problem can be reproduced easily.
> > > > > > > > >
> > > > > > > > > 1. choose a server machine, decrease it's tcp_mem with:
> > > > > > > > >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > > > > > > > > 2. call listen() and accept() on a port, such as 8888. We=
 call
> > > > > > > > >     accept() looply and without call recv() to make the d=
ata stay
> > > > > > > > >     in the receive queue.
> > > > > > > > > 3. choose a client machine, and create 100 TCP connection
> > > > > > > > >     to the 8888 port of the server. Then, every connectio=
n sends
> > > > > > > > >     data about 1M.
> > > > > > > > > 4. we can see that some of the connection enter the 0-pro=
be
> > > > > > > > >     state, but some of them keep retrans again and again.=
 As
> > > > > > > > >     the server is up to the tcp_mem[2] and skb is dropped=
 before
> > > > > > > > >     the recv_buf full and the connection enter 0-probe st=
ate.
> > > > > > > > >     Finially, some of these connection will timeout and b=
reak.
> > > > > > > > >
> > > > > > > > > With this series, all the 100 connections will enter 0-pr=
obe
> > > > > > > > > status and connection break won't happen. And the data
> > > > > > > > > trans will recover if we increase tcp_mem or call 'recv()=
'
> > > > > > > > > on the sockets in the server.
> > > > > > > > >
> > > > > > > > > > Also, such fundamental change would need IETF discussio=
n first.
> > > > > > > > > > We do not want linux to cause network collapses just be=
cause billions
> > > > > > > > > > of devices send more zero probes.
> > > > > > > > >
> > > > > > > > > I think it maybe a good idea to make the connection enter
> > > > > > > > > 0-probe, rather than drop the skb silently. What 0-probe
> > > > > > > > > meaning is to wait for space available when the buffer of=
 the
> > > > > > > > > receive queue is full. And maybe we can also use 0-probe
> > > > > > > > > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > > > > > > > > is full?
> > > > > > > > >
> > > > > > > > > Am I right?
> > > > > > > > >
> > > > > > > > > Thanks!
> > > > > > > > > Menglong Dong
> > > > > > > >
> > > > > > > > Thanks for describing the scenario in more detail. (Some ki=
nd of
> > > > > > > > packetdrill script or other program to reproduce this issue=
 would be
> > > > > > > > nice, too, as Eric noted.)
> > > > > > > >
> > > > > > > > You mention in step (4.) above that some of the connections=
 keep
> > > > > > > > retransmitting again and again. Are those connections recei=
ving any
> > > > > > > > ACKs in response to their retransmissions? Perhaps they are=
 receiving
> > > > > > > > dupacks?
> > > > > > >
> > > > > > > Actually, these packets are dropped without any reply, even d=
upacks.
> > > > > > > skb will be dropped directly when tcp_try_rmem_schedule()
> > > > > > > fails in tcp_data_queue(). That's reasonable, as it's
> > > > > > > useless to reply a ack to the sender, which will cause the se=
nder
> > > > > > > fast retrans the packet, because we are out of memory now, an=
d
> > > > > > > retrans can't solve the problem.
> > > > > >
> > > > > > I'm not sure I see the problem. If retransmits can't solve the
> > > > > > problem, then why are you proposing that data senders keep
> > > > > > retransmitting forever (via 0-window-probes) in this kind of sc=
enario?
> > > > > >
> > > > >
> > > > > Because the connection will break if the count of
> > > > > retransmits up to tcp_retires2, but probe-0 can keep
> > > > > for a long time.
> > > >
> > > > I see. So it sounds like you agree that retransmits can solve the
> > > > problem, as long as the retransmits are using the zero-window probe
> > > > state machine (ICSK_TIME_PROBE0, tcp_probe_timer()), which continue=
s
> > > > as long as the receiver is sending ACKs. And it sounds like when yo=
u
> > > > said "retrans can't solve the problem" you didn't literally mean th=
at
> > > > retransmits can't solve the problem, but rather you meant that the =
RTO
> > > > state machine, specifically (ICSK_TIME_RETRANS,
> > > > tcp_retransmit_timer(), etc) can't solve the problem. I agree with
> > > > that assessment that in this scenario tcp_probe_timer() seems like =
a
> > > > solution but tcp_retransmit_timer() does not.
> > > >
> > >
> > > Yes, that is indeed what I want to express.
> > >
> > > > > > A single dupack without SACK blocks will not cause the sender t=
o fast
> > > > > > retransmit. (Only 3 dupacks would trigger fast retransmit.)
> > > > > >
> > > > > > Three or more dupacks without SACK blocks will cause the sender=
 to
> > > > > > fast retransmit the segment above SND.UNA once if the sender do=
esn't
> > > > > > have SACK support. But in this case AFAICT fast-retransmitting =
once is
> > > > > > a fine strategy, since the sender should keep retrying transmit=
s (with
> > > > > > backoff) until the receiver potentially has memory available to
> > > > > > receive the packet.
> > > > > >
> > > > > > >
> > > > > > > > If so, then perhaps we could solve this problem without
> > > > > > > > depending on a violation of the TCP spec (which says the re=
ceive
> > > > > > > > window should not be retracted) in the following way: when =
a data
> > > > > > > > sender suffers a retransmission timeout, and retransmits th=
e first
> > > > > > > > unacknowledged segment, and receives a dupack for SND.UNA i=
nstead of
> > > > > > > > an ACK covering the RTO-retransmitted segment, then the dat=
a sender
> > > > > > > > should estimate that the receiver doesn't have enough memor=
y to buffer
> > > > > > > > the retransmitted packet. In that case, the data sender sho=
uld enter
> > > > > > > > the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 t=
imer to
> > > > > > > > call tcp_probe_timer().
> > > > > > > >
> > > > > > > > Basically we could try to enhance the sender-side logic to =
try to
> > > > > > > > distinguish between two kinds of problems:
> > > > > > > >
> > > > > > > > (a) Repeated data packet loss caused by congestion, routing=
 problems,
> > > > > > > > or connectivity problems. In this case, the data sender use=
s
> > > > > > > > ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off=
 and only
> > > > > > > > retries sysctl_tcp_retries2 times before timing out the con=
nection
> > > > > > > >
> > > > > > > > (b) A receiver that is repeatedly sending dupacks but not A=
CKing
> > > > > > > > retransmitted data because it doesn't have any memory. In t=
his case,
> > > > > > > > the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer()=
, and backs
> > > > > > > > off but keeps retrying as long as the data sender receives =
ACKs.
> > > > > > > >
> > > > > > >
> > > > > > > I'm not sure if this is an ideal method, as it may be not rig=
orous
> > > > > > > to conclude that the receiver is oom with dupacks. A packet c=
an
> > > > > > > loss can also cause multi dupacks.
> > > > > >
> > > > > > When a data sender suffers an RTO and retransmits a single data
> > > > > > packet, it would be very rare for the data sender to receive mu=
ltiple
> > > > > > pure dupacks without SACKs. This would only happen in the rare =
case
> > > > > > where (a) the connection did not have SACK enabled, and (b) the=
re was
> > > > > > a hole in the received sequence space and there were still pack=
ets in
> > > > > > flight when the (spurioius) RTO fired.
> > > > > >
> > > > > > But if we want to be paranoid, then this new response could be =
written
> > > > > > to only trigger if SACK is enabled (the vast, vast majority of =
cases).
> > > > > > If SACK is enabled, and an RTO of a data packet starting at seq=
uence
> > > > > > S1 results in the receiver sending only a dupack for S1 without=
 SACK
> > > > > > blocks, then this clearly shows the issue is not packet loss bu=
t
> > > > > > suggests a receiver unable to buffer the given data packet, AFA=
ICT.
> > > > > >
> > > > >
> > > > > Yeah, you are right on this point, multi pure dupacks can
> > > > > mean out of memory of the receiver. But we still need to
> > > > > know if the receiver recovers from OOM. Without window
> > > > > shrink, the window in the ack of zero-window probe packet
> > > > > is not zero on OOM.
> > > >
> > > > But do we need a protocol-violating zero-window in this case? Why n=
ot
> > > > use my approach suggested above: conveying the OOM condition by
> > > > sending an ACK but not ACKing the retransmitted packet?
> > > >
> > >
> > > I agree with you about the approach you mentioned
> > > about conveying the OOM condition. But that approach
> > > can't convey the recovery from OOM, can it?
> >
> > Yes, my suggested approach can convey the recovery from OOM. The data
> > receiver conveys the recovery from OOM by buffering and ACKing the
> > retransmitted data packet.
>
> Oh, I understand what you mean now. You are saying that
> retransmit that first packet in the retransmit queue instead
> of zero-window probe packet when OOM of the receiver,
> isn't it? In other word, retransmit the unacked data and ignore
> the tcp_retries2 when we find the receiver is in OOM state.

Yes. The idea would be to use a heuristic to estimate the receiver is
currently OOM and use ICSK_TIME_PROBE0 / tcp_probe_timer() /
tcp_write_wakeup() in this case instead of ICSK_TIME_RETRANS /
tcp_retransmit_timer().

> That's an option, and we can make the length of the data we
> send to 1 byte, which means we keep retransmitting the first
> byte that has not be acked in the retransmit queue.

I don't think it would be worth adding special-case code to only send
1 byte.  If the data receiver is not OOM then for CPU and memory
efficiency reasons (as well as simplicity) the data sender should send
it a full MSS. So for those reasons I would suggest that in this
potential approach tcp_write_wakeup() should stay the same.

neal

