Return-Path: <netdev+bounces-4600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E5670D81E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E06CB2812C4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FD01DDE5;
	Tue, 23 May 2023 08:59:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636FB1B91E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:59:28 +0000 (UTC)
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BC8102;
	Tue, 23 May 2023 01:59:24 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-561d249f045so59947407b3.2;
        Tue, 23 May 2023 01:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684832364; x=1687424364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ws+yAVHhBNJT7L/nBPCWWDV+WcW5Mj1me36wbWFYsCw=;
        b=n6ChZpeeR7Dg0o4pXDibfwQA05QQAtwJ7sklx/Xv4NZKeCLFW07gExL63Wi+Y74FQg
         UYOduRDGUci1J82DZ7/Yw9vpYzmPUiGMO+e5O5lfW9Emb5M04SanA4GaLNX+HByYMTpQ
         MouhNlUbVql4nUxvrWOad6J0rDQGlMw1HaF4YNhl1MRzEsuGlqVjK85OKf59H4Fo3ro9
         MW7uzdJ06QpKAp2jQ4hAm/9iEYTAr5dFyI2KJqkPtvnVvXzQcVI7bvvc1AFL1OJvOGYr
         PqD93ZPni/6g75hdjItdaFUVvgSy5GphZ5d5YqlkRnuUEn+GR6CVytQ+okTPprC4VwhD
         0Q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684832364; x=1687424364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ws+yAVHhBNJT7L/nBPCWWDV+WcW5Mj1me36wbWFYsCw=;
        b=CheefZbSo1oqWSnDznknNDAuXYQZ6L03Z6Koh09DiswYF09sTVmoiPArJpLg+ey10c
         3Jkcrz+yjJNi9PcXHXMQCizyUntGNs0salUQLQ9vNEDcd3HtqDG53qGN9h6qxZCOwO8I
         Bd79M9XcTP7w0hiBXYueZTuDTH0Mnghmt8LO6hsFqpHK1pxDJCEcU1+xW0bVB7V/9Bnx
         Npe+YkaBqODDOzJcRntyPvG7NScCmyktXrswFkLrWA5zNGr7uJ0CfKEpBfxyIIfMviFk
         aWUzCjOzXWSEGMVcfgbSlqkjbMSRcr9fbUbtneA0pwE6p6iMZ5FpqGSEwUlVOLXZ/Roq
         Nrew==
X-Gm-Message-State: AC+VfDzgxuuGZIxr3ABdxHNO1aIvOS6PBW+BkcX7lvXfHKnJti6Z3iuY
	iZTb3EYiLTJFRsX9D0IxQZ0xitdbDtq6NAerfXA=
X-Google-Smtp-Source: ACHHUZ7pXaV6KA5OtFh0fCDMRpMntjMhnx34lPKw7Q4oz7PJ3Eoe/fGbFrdRyVeBGgGzLRQy6rZhLgLZr1cOv6ifiZ8=
X-Received: by 2002:a0d:dd01:0:b0:561:9051:d2d3 with SMTP id
 g1-20020a0ddd01000000b005619051d2d3mr15242140ywe.11.1684832363862; Tue, 23
 May 2023 01:59:23 -0700 (PDT)
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
 <CADxym3bbGkOv4dwATp6wT0KA4ZPiPGfxvqvYtEzF45GJDe=RXQ@mail.gmail.com> <CADVnQymzzZ9m30-1ZA+muvmt-bjaebtMT0Bh8Wp5vXZuYifONQ@mail.gmail.com>
In-Reply-To: <CADVnQymzzZ9m30-1ZA+muvmt-bjaebtMT0Bh8Wp5vXZuYifONQ@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Tue, 23 May 2023 16:59:12 +0800
Message-ID: <CADxym3bLnLS=V5L6hZ9-PhrE3ZPpW2YD_cAG=XntEH9ky1Z0aw@mail.gmail.com>
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

On Mon, May 22, 2023 at 11:04=E2=80=AFPM Neal Cardwell <ncardwell@google.co=
m> wrote:
>
> On Sun, May 21, 2023 at 10:55=E2=80=AFPM Menglong Dong <menglong8.dong@gm=
ail.com> wrote:
> >
> > On Sat, May 20, 2023 at 10:28=E2=80=AFPM Neal Cardwell <ncardwell@googl=
e.com> wrote:
> > >
> > > On Sat, May 20, 2023 at 5:08=E2=80=AFAM Menglong Dong <menglong8.dong=
@gmail.com> wrote:
> > > >
> > > > On Fri, May 19, 2023 at 12:03=E2=80=AFAM Neal Cardwell <ncardwell@g=
oogle.com> wrote:
> > > > >
> > > > > On Thu, May 18, 2023 at 10:12=E2=80=AFAM Menglong Dong <menglong8=
.dong@gmail.com> wrote:
> > > > > >
> > > > > > On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardwel=
l@google.com> wrote:
> > > > > > >
> > > > > > > On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <mengl=
ong8.dong@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edum=
azet@google.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@g=
mail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > From: Menglong Dong <imagedong@tencent.com>
> > > > > > > > > >
> > > > > > > > > > Window shrink is not allowed and also not handled for n=
ow, but it's
> > > > > > > > > > needed in some case.
> > > > > > > > > >
> > > > > > > > > > In the origin logic, 0 probe is triggered only when the=
re is no any
> > > > > > > > > > data in the retrans queue and the receive window can't =
hold the data
> > > > > > > > > > of the 1th packet in the send queue.
> > > > > > > > > >
> > > > > > > > > > Now, let's change it and trigger the 0 probe in such ca=
ses:
> > > > > > > > > >
> > > > > > > > > > - if the retrans queue has data and the 1th packet in i=
t is not within
> > > > > > > > > > the receive window
> > > > > > > > > > - no data in the retrans queue and the 1th packet in th=
e send queue is
> > > > > > > > > > out of the end of the receive window
> > > > > > > > >
> > > > > > > > > Sorry, I do not understand.
> > > > > > > > >
> > > > > > > > > Please provide packetdrill tests for new behavior like th=
at.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Yes. The problem can be reproduced easily.
> > > > > > > >
> > > > > > > > 1. choose a server machine, decrease it's tcp_mem with:
> > > > > > > >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > > > > > > > 2. call listen() and accept() on a port, such as 8888. We c=
all
> > > > > > > >     accept() looply and without call recv() to make the dat=
a stay
> > > > > > > >     in the receive queue.
> > > > > > > > 3. choose a client machine, and create 100 TCP connection
> > > > > > > >     to the 8888 port of the server. Then, every connection =
sends
> > > > > > > >     data about 1M.
> > > > > > > > 4. we can see that some of the connection enter the 0-probe
> > > > > > > >     state, but some of them keep retrans again and again. A=
s
> > > > > > > >     the server is up to the tcp_mem[2] and skb is dropped b=
efore
> > > > > > > >     the recv_buf full and the connection enter 0-probe stat=
e.
> > > > > > > >     Finially, some of these connection will timeout and bre=
ak.
> > > > > > > >
> > > > > > > > With this series, all the 100 connections will enter 0-prob=
e
> > > > > > > > status and connection break won't happen. And the data
> > > > > > > > trans will recover if we increase tcp_mem or call 'recv()'
> > > > > > > > on the sockets in the server.
> > > > > > > >
> > > > > > > > > Also, such fundamental change would need IETF discussion =
first.
> > > > > > > > > We do not want linux to cause network collapses just beca=
use billions
> > > > > > > > > of devices send more zero probes.
> > > > > > > >
> > > > > > > > I think it maybe a good idea to make the connection enter
> > > > > > > > 0-probe, rather than drop the skb silently. What 0-probe
> > > > > > > > meaning is to wait for space available when the buffer of t=
he
> > > > > > > > receive queue is full. And maybe we can also use 0-probe
> > > > > > > > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > > > > > > > is full?
> > > > > > > >
> > > > > > > > Am I right?
> > > > > > > >
> > > > > > > > Thanks!
> > > > > > > > Menglong Dong
> > > > > > >
> > > > > > > Thanks for describing the scenario in more detail. (Some kind=
 of
> > > > > > > packetdrill script or other program to reproduce this issue w=
ould be
> > > > > > > nice, too, as Eric noted.)
> > > > > > >
> > > > > > > You mention in step (4.) above that some of the connections k=
eep
> > > > > > > retransmitting again and again. Are those connections receivi=
ng any
> > > > > > > ACKs in response to their retransmissions? Perhaps they are r=
eceiving
> > > > > > > dupacks?
> > > > > >
> > > > > > Actually, these packets are dropped without any reply, even dup=
acks.
> > > > > > skb will be dropped directly when tcp_try_rmem_schedule()
> > > > > > fails in tcp_data_queue(). That's reasonable, as it's
> > > > > > useless to reply a ack to the sender, which will cause the send=
er
> > > > > > fast retrans the packet, because we are out of memory now, and
> > > > > > retrans can't solve the problem.
> > > > >
> > > > > I'm not sure I see the problem. If retransmits can't solve the
> > > > > problem, then why are you proposing that data senders keep
> > > > > retransmitting forever (via 0-window-probes) in this kind of scen=
ario?
> > > > >
> > > >
> > > > Because the connection will break if the count of
> > > > retransmits up to tcp_retires2, but probe-0 can keep
> > > > for a long time.
> > >
> > > I see. So it sounds like you agree that retransmits can solve the
> > > problem, as long as the retransmits are using the zero-window probe
> > > state machine (ICSK_TIME_PROBE0, tcp_probe_timer()), which continues
> > > as long as the receiver is sending ACKs. And it sounds like when you
> > > said "retrans can't solve the problem" you didn't literally mean that
> > > retransmits can't solve the problem, but rather you meant that the RT=
O
> > > state machine, specifically (ICSK_TIME_RETRANS,
> > > tcp_retransmit_timer(), etc) can't solve the problem. I agree with
> > > that assessment that in this scenario tcp_probe_timer() seems like a
> > > solution but tcp_retransmit_timer() does not.
> > >
> >
> > Yes, that is indeed what I want to express.
> >
> > > > > A single dupack without SACK blocks will not cause the sender to =
fast
> > > > > retransmit. (Only 3 dupacks would trigger fast retransmit.)
> > > > >
> > > > > Three or more dupacks without SACK blocks will cause the sender t=
o
> > > > > fast retransmit the segment above SND.UNA once if the sender does=
n't
> > > > > have SACK support. But in this case AFAICT fast-retransmitting on=
ce is
> > > > > a fine strategy, since the sender should keep retrying transmits =
(with
> > > > > backoff) until the receiver potentially has memory available to
> > > > > receive the packet.
> > > > >
> > > > > >
> > > > > > > If so, then perhaps we could solve this problem without
> > > > > > > depending on a violation of the TCP spec (which says the rece=
ive
> > > > > > > window should not be retracted) in the following way: when a =
data
> > > > > > > sender suffers a retransmission timeout, and retransmits the =
first
> > > > > > > unacknowledged segment, and receives a dupack for SND.UNA ins=
tead of
> > > > > > > an ACK covering the RTO-retransmitted segment, then the data =
sender
> > > > > > > should estimate that the receiver doesn't have enough memory =
to buffer
> > > > > > > the retransmitted packet. In that case, the data sender shoul=
d enter
> > > > > > > the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 tim=
er to
> > > > > > > call tcp_probe_timer().
> > > > > > >
> > > > > > > Basically we could try to enhance the sender-side logic to tr=
y to
> > > > > > > distinguish between two kinds of problems:
> > > > > > >
> > > > > > > (a) Repeated data packet loss caused by congestion, routing p=
roblems,
> > > > > > > or connectivity problems. In this case, the data sender uses
> > > > > > > ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off a=
nd only
> > > > > > > retries sysctl_tcp_retries2 times before timing out the conne=
ction
> > > > > > >
> > > > > > > (b) A receiver that is repeatedly sending dupacks but not ACK=
ing
> > > > > > > retransmitted data because it doesn't have any memory. In thi=
s case,
> > > > > > > the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), =
and backs
> > > > > > > off but keeps retrying as long as the data sender receives AC=
Ks.
> > > > > > >
> > > > > >
> > > > > > I'm not sure if this is an ideal method, as it may be not rigor=
ous
> > > > > > to conclude that the receiver is oom with dupacks. A packet can
> > > > > > loss can also cause multi dupacks.
> > > > >
> > > > > When a data sender suffers an RTO and retransmits a single data
> > > > > packet, it would be very rare for the data sender to receive mult=
iple
> > > > > pure dupacks without SACKs. This would only happen in the rare ca=
se
> > > > > where (a) the connection did not have SACK enabled, and (b) there=
 was
> > > > > a hole in the received sequence space and there were still packet=
s in
> > > > > flight when the (spurioius) RTO fired.
> > > > >
> > > > > But if we want to be paranoid, then this new response could be wr=
itten
> > > > > to only trigger if SACK is enabled (the vast, vast majority of ca=
ses).
> > > > > If SACK is enabled, and an RTO of a data packet starting at seque=
nce
> > > > > S1 results in the receiver sending only a dupack for S1 without S=
ACK
> > > > > blocks, then this clearly shows the issue is not packet loss but
> > > > > suggests a receiver unable to buffer the given data packet, AFAIC=
T.
> > > > >
> > > >
> > > > Yeah, you are right on this point, multi pure dupacks can
> > > > mean out of memory of the receiver. But we still need to
> > > > know if the receiver recovers from OOM. Without window
> > > > shrink, the window in the ack of zero-window probe packet
> > > > is not zero on OOM.
> > >
> > > But do we need a protocol-violating zero-window in this case? Why not
> > > use my approach suggested above: conveying the OOM condition by
> > > sending an ACK but not ACKing the retransmitted packet?
> > >
> >
> > I agree with you about the approach you mentioned
> > about conveying the OOM condition. But that approach
> > can't convey the recovery from OOM, can it?
>
> Yes, my suggested approach can convey the recovery from OOM. The data
> receiver conveys the recovery from OOM by buffering and ACKing the
> retransmitted data packet.

Oh, I understand what you mean now. You are saying that
retransmit that first packet in the retransmit queue instead
of zero-window probe packet when OOM of the receiver,
isn't it? In other word, retransmit the unacked data and ignore
the tcp_retries2 when we find the receiver is in OOM state.

That's an option, and we can make the length of the data we
send to 1 byte, which means we keep retransmitting the first
byte that has not be acked in the retransmit queue.

>
> > Let's see the process. With 3 pure dupack for SND.UNA,
> > we deem the OOM of the receiver and make the sender
> > enter zero-window probe state.
>
> AFAICT the data sender does not need to wait for 3 pure dpacks for
> SND.UNA. AFAICT a data sender that suffers an RTO and finds that its
> RTO gets a response that is a single dupack for SND.UNA could estimate
> that the receiver is OOM, and enter the zero-window probe state.
>
> > The sender will keep sending probe0 packets, and the
> > receiver will reply an ack. However, as we don't
> > shrink the window actually, the window in the ack is
> > not zero on OOM, so we can't know if the receiver has
> > recovered from OOM and retransmit the data in retransmit
> > queue.
>
> As I noted above, in my proposal the data receiver conveys the
> recovery from OOM by buffering and ACKing the retransmitted data
> packet.
>
> > BTW, the probe0 will send the last byte that was already
> > acked, so the ack of the probe0 will be a pure dupack.
> >
> > Did I miss something?
>
> I don't think that's the case. My read of tcp_write_wakeup() is that
> it will send an skb that is whatever prefix of 1 MSS is allowed by the
> receiver window. In the scenario we are discussing, that would mean
> that it sends a full 1 MSS. So AFAICT tcp_write_wakeup() could be used
> for sending a data "probe" packet for this OOM case.
>
> > BTW, a previous patch has explained the need to
> > support window shrink, which should satisfy the RFC
> > of TCP protocol:
> >
> > https://lore.kernel.org/netdev/20230308053353.675086-1-mfreemon@cloudfl=
are.com/
>
> Let's see what Eric thinks about that patch.
>
> neal
>
>
> > Thanks!
> > Menglong Dong
> >
> > > Thanks,
> > > neal
> > >
> > > > Hi, Eric and kuba, do you have any comments on this
> > > > case?
> > > >
> > > > Thanks!
> > > > Menglong Dong
> > > >
> > > > > thanks,
> > > > > neal
> > > > >
> > > > > >
> > > > > > Thanks!
> > > > > > Menglong Dong
> > > > > >
> > > > > > > AFAICT that would be another way to reach the happy state you=
 mention:
> > > > > > > "all the 100 connections will enter 0-probe status and connec=
tion
> > > > > > > break won't happen", and we could reach that state without vi=
olating
> > > > > > > the TCP protocol spec and without requiring changes on the re=
ceiver
> > > > > > > side (so that this fix could help in scenarios where the
> > > > > > > memory-constrained receiver is an older stack without special=
 new
> > > > > > > behavior).
> > > > > > >
> > > > > > > Eric, Yuchung, Menglong: do you think something like that wou=
ld work?
> > > > > > >
> > > > > > > neal

