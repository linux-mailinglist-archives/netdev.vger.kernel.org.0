Return-Path: <netdev+bounces-3666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 655C07083E5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4759A1C21094
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF83209B4;
	Thu, 18 May 2023 14:25:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEDE23C6A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:25:32 +0000 (UTC)
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB77BE69;
	Thu, 18 May 2023 07:25:30 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-5619032c026so25850897b3.1;
        Thu, 18 May 2023 07:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684419930; x=1687011930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTZb9xwEPvqrA/j50VjQvMgiTttO1+oVgLrqOulaWSQ=;
        b=Cie3DBeRtOyBQRKJgcR50NNynnzE/TEAWOfqObFUR8A2nC4Zw5QkCfWZG69biLFCrY
         ivdVpj0aOtb0aqPuxEufhKQOOaZ1sjMMXIiRTB1fpZYC0iH+RTBzRgs/Xoh/Ke8MhTyo
         Wv74c3ed9XnC9vHtxlywqfbIJVqTe4kIMNaB2WpOoZTSKg3pBorrnUGYRxCZ996iTgI4
         1krAISt0z4/vdsQENQIgJm/JuDp29UDs5rzALcm3fgoOVbU5iTqNhRx3TWfmXi7no2zR
         K2lBJ3S6xdED996DnHzOJ93yRxT0Wt0HiTfzcoRQd9OkuG6sVGlgJNeta7l4UWPebd8O
         pLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684419930; x=1687011930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTZb9xwEPvqrA/j50VjQvMgiTttO1+oVgLrqOulaWSQ=;
        b=Dir7bHwepibQxG5kqf6VkS0PGXuH4CuOBjzYNIuVVSmZakJcPv3PF5sXeMDMdlLohk
         ZMtqOavKSFSBCBQSrVay3ItIKFhZgqvNwV9rReEqgIVqHAVhWR7OBZ6EX33l0fkYTxNL
         2AeG4E2aKIHGUZ9Vj3G2zauH7zVVbuV4ub51cl2gbG4y84DooHRRO/19LkNI6UBwnkmQ
         iwfLm7r9QwfNUuEOYK1TI+o5urncniUyhAFBuGCvFMs6yOUwSr2WIP4svPid0vKaUVgn
         LzpouVUHsM7IX/cXL09dL3Nkz2SmfpoLxpLG9C3UBQ2TbfeYOCu29lbzFZLRIQ3vlMA2
         HZLA==
X-Gm-Message-State: AC+VfDyvb0FoUsQidOsVFg1FzQW7NATDFKOul1ytXkKiCeVpozJmwvss
	Z7MU7aXUy0TB/TWoNp8E0ZEii1+yWamq3O0JExcLGWHkQiZglJQl
X-Google-Smtp-Source: ACHHUZ6G8i9qItBqQExzJTxNIJVwXTycXCxHQpLTsllgiBz7A9qD4SLx6IAeUYGjhT9W1MqTe/ZqRevzmTwvfAiO1WQ=
X-Received: by 2002:a81:4854:0:b0:561:a41d:aabb with SMTP id
 v81-20020a814854000000b00561a41daabbmr1430263ywa.16.1684419929926; Thu, 18
 May 2023 07:25:29 -0700 (PDT)
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
Date: Thu, 18 May 2023 22:25:18 +0800
Message-ID: <CADxym3YTpzfsB9JB8qwrm4ffMrXs_+mfe3-oO5=UhivuFXq+4g@mail.gmail.com>
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
> What you want instead is simply to send EPOLLIN sooner (when the first
> packet is queued instead when the second packet is dropped)
> by changing sk_forced_mem_schedule() a bit.
>
> This might matter for applications using SO_RCVLOWAT, but not for
> other applications.

To be more clear, what I talk about here is not to send EPOLLIN
sooner, but try to make the TCP connection, which has a "hang"
receiver and in TCP protocol memory pressure, entry 0-probe
state. And this commit is the first step: make the receiver
shrink the window by sending a zero-window ack.

Thanks!
Menglong Dong

