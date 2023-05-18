Return-Path: <netdev+bounces-3481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD4B7077EA
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1EFF1C2102E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 02:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658F6384;
	Thu, 18 May 2023 02:15:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAF17E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:15:09 +0000 (UTC)
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF441FD4;
	Wed, 17 May 2023 19:15:07 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-561d611668eso15904037b3.0;
        Wed, 17 May 2023 19:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684376107; x=1686968107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HX08ufncLdeXuaNreGmLZ9S7+vVBhvFauDOAu0zDUiY=;
        b=AF9mhOh/h/gy4+ECVR/wZlPak+uqpVqcZiKJ1XqHvb8VbnPOx5/dv27EcoJ373JNky
         FBCvGoTcpSiBA7sy+0gFALF7jgEyjfj2DSNrN6CuM0oL4eS8/RPaxB+SjgEjWODGru5I
         HSibY0ovWpSIPM9fIHZ6dPgNxfhGhJjoSchmAHKEguFk637cMsClOLIJvvW9AE/atfy9
         JLv7NdyLfb5GKDfLL9TTOCDfsGn/aH6KFXbxE0NiHmHzIyPr4UbfKEe5NFu4j4D/PLhW
         kIeQttlNJXGLlJBWY6tRvp4V4BkmLdk31XahThJSY5HxuWGIAMZFJoxf4TBkKlrgZ9kF
         Yotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684376107; x=1686968107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HX08ufncLdeXuaNreGmLZ9S7+vVBhvFauDOAu0zDUiY=;
        b=IT/DRPqAw7hdW0csPO/+gI+k+C3cttlKwV2w94fKbEAh44WCBrgaEejks70GEh/xc/
         8tC/NT3Lu3N9/C/t30cAtL5S1BwpL+HtJXeQ+gDvzJKMuvLNpl9sz1/Jb6wFMbagupHg
         bTjlgsPUovP3AAVXaQEQTdGBDyAKvmqbBCSO68UVuZAG0AvEAK6OdfH4Lp367HkqWkrm
         2Q85Yk8gUoYuLTMdckWCf5j8xTkLD9kJEdGzwFnXBZJ38lrdmTw94TdEoGJX3N4Nlzn1
         fm1qrC17uDmXeIKa5xzTGVWIGAvwj9Fu4P7I2wc011m0hIRp5/kpxeHgJq5i/RTc+csm
         0igg==
X-Gm-Message-State: AC+VfDyMZ7Mvru6TV5k4DfIL11hdlShNPtkkzqa9q7r2LO53Yt81OZSP
	VvtbpRjItuxPQ8YNZpO+eTcuUKiwuxAp7bEdpC5h2j9VJjnwuM4e
X-Google-Smtp-Source: ACHHUZ7x9jOyk2+hgMMH38dyovX9OhGzxBD1zb1zBJzdhqz5OBMb/3evg0eclg+dmds+BMvF8AKVbPhkuXTzAHg4JBg=
X-Received: by 2002:a0d:e6cc:0:b0:55a:30f5:3d65 with SMTP id
 p195-20020a0de6cc000000b0055a30f53d65mr108816ywe.41.1684376106790; Wed, 17
 May 2023 19:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-3-imagedong@tencent.com> <CANn89iKGTPHK5wMyP4oRoAuv8f56VY-RrrMPBSb8jRMJSiL5Qg@mail.gmail.com>
In-Reply-To: <CANn89iKGTPHK5wMyP4oRoAuv8f56VY-RrrMPBSb8jRMJSiL5Qg@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Thu, 18 May 2023 10:14:55 +0800
Message-ID: <CADxym3bnn1uMA+7Wavz9ybgySjuUg_CvVs4AtWHDcntqd0VHVA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: tcp: send zero-window when no memory
To: Eric Dumazet <edumazet@google.com>
Cc: kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com, 
	dsahern@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 10:45=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, skb will be dropped when no memory, which makes client keep
> > retrans util timeout and it's not friendly to the users.
>
> Yes, networking needs memory. Trying to deny it is recipe for OOM.
>
> >
> > Therefore, now we force to receive one packet on current socket when
> > the protocol memory is out of the limitation. Then, this socket will
> > stay in 'no mem' status, util protocol memory is available.
> >
>
> I think you missed one old patch.
>
> commit ba3bb0e76ccd464bb66665a1941fabe55dadb3ba    tcp: fix
> SO_RCVLOWAT possible hangs under high mem pressure
>
>
>
> > When a socket is in 'no mem' status, it's receive window will become
> > 0, which means window shrink happens. And the sender need to handle
> > such window shrink properly, which is done in the next commit.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/net/sock.h    |  1 +
> >  net/ipv4/tcp_input.c  | 12 ++++++++++++
> >  net/ipv4/tcp_output.c |  7 +++++++
> >  3 files changed, 20 insertions(+)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 5edf0038867c..90db8a1d7f31 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -957,6 +957,7 @@ enum sock_flags {
> >         SOCK_XDP, /* XDP is attached */
> >         SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
> >         SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
> > +       SOCK_NO_MEM, /* protocol memory limitation happened */
> >  };
> >
> >  #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIM=
ESTAMPING_RX_SOFTWARE))
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index a057330d6f59..56e395cb4554 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5047,10 +5047,22 @@ static void tcp_data_queue(struct sock *sk, str=
uct sk_buff *skb)
> >                 if (skb_queue_len(&sk->sk_receive_queue) =3D=3D 0)
> >                         sk_forced_mem_schedule(sk, skb->truesize);
>
> I think you missed this part : We accept at least one packet,
> regardless of memory pressure,
> if the queue is empty.
>
> So your changelog is misleading.

Sorry that I didn't describe the problem clearly enough. The problem is
for two cases.

Case 1:

tcp_mem[2] limitation causes packet drop. In some cases, applications
may not read the data in the socket receiving queue quickly enough.
In my case, it will call recv() every 5 minutes. And there are a lot of suc=
h
sockets. tcp_mem[2] limitation can happen easily in such a case, and once
this happens, skb will be dropped (the receive queue is not empty) and
the send retrans the skb until timeout and the connection break.

Case 2:

The sender keeps sending small packets and makes the rec_buf full.
Meanwhile, the window is not zero, and the sender will keep retrans
until timeout, as the skb is dropped by the receiver.

>
> >                 else if (tcp_try_rmem_schedule(sk, skb, skb->truesize))=
 {
> > +                       if (sysctl_tcp_wnd_shrink)
>
> We no longer add global sysctls for TCP. All new sysctls must per net-ns.
>
> > +                               goto do_wnd_shrink;
> > +
> >                         reason =3D SKB_DROP_REASON_PROTO_MEM;
> >                         NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDR=
OP);
> >                         sk->sk_data_ready(sk);
> >                         goto drop;
> > +do_wnd_shrink:
> > +                       if (sock_flag(sk, SOCK_NO_MEM)) {
> > +                               NET_INC_STATS(sock_net(sk),
> > +                                             LINUX_MIB_TCPRCVQDROP);
> > +                               sk->sk_data_ready(sk);
> > +                               goto out_of_window;
> > +                       }
> > +                       sk_forced_mem_schedule(sk, skb->truesize);
>
> So now we would accept two packets per TCP socket, and yet EPOLLIN
> will not be sent in time ?
>
> packets can consume about 45*4K each, I do not think it is wise to
> double receive queue sizes.
>

What we want to do here is to send a ack with zero window. It
may be not necessary to force receive new data here, but to stay
the same with the logic of 'tcp_may_update_window()', only
newer 'ack' in a ack packet can shrink the window.

If we don't receive new data and send a zero-window ack directly
here, it will be weird, as the previous ack with the same 'seq' and 'ack'
has non-zero window.

Thanks!
Menglong Dong

> What you want instead is simply to send EPOLLIN sooner (when the first
> packet is queued instead when the second packet is dropped)
> by changing sk_forced_mem_schedule() a bit.
>
> This might matter for applications using SO_RCVLOWAT, but not for
> other applications.

