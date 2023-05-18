Return-Path: <netdev+bounces-3652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5E97082F5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A41C1C20D8B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4084811CA8;
	Thu, 18 May 2023 13:40:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331F723C8A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:40:57 +0000 (UTC)
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFD4FE
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:40:55 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-456f7ea8694so105453e0c.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684417254; x=1687009254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tO9iooI56FzY/iP176V5ICBpaJB4SK5RAZzxGCjOh+c=;
        b=cYCTE3RMNKJ6s8LWLrIFcvauLAHxZobqQtGDDDFDml0X54Sfu80Ki/h3ticIzyML9Z
         090jNF/AUQnUT62lJNWlPd/EvMztT9bes/p7Cy5oEZAdwf/h5Se8rcoh0DPpRNFEmHcQ
         76z8sqbNHk7m3TEYsuISLJxd2qCSMA0SFhuAPwC6aqAPwo0BZhMtdkBCWZrNSzfrbrHJ
         VZIZJKeiB4cxF+o7H3qwhE1yt8waTMM5P5A/wfNVOYNnhMVoQE5KqGEHDj2Ov9y0coYo
         dO9peHxxCzHwZ072HD/xnBXljbjoefKhO88rd9Wo7sepndfMV/wUNzjCArxhF7Cvh+vj
         7yPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684417254; x=1687009254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tO9iooI56FzY/iP176V5ICBpaJB4SK5RAZzxGCjOh+c=;
        b=h97ZOudHBDR7lWrkJZTz5BJejRgzaOBF8qjwpx39fFyk2B6w4ioRvIsyWHtH4+ZG73
         60Ucbd6LYSRYdurZtkdi25MHOllY3keggdmIjbyaW+JcuJq7+O6q5oUBI1QMB32nWi5Z
         Eziq26I+l72LdzKgTR4t87LYlDVCDjS6iIc+O9yO29max/7CNuxo1+Ayi58ACNKUupMw
         PNb6o9l/G9AXPjxgpPDj7mEE8Y/8sw3YVPV1LojrCLHaFd2mi6rf71JcB9Yz31LD58z4
         muhCRKH1M4qBt+GT3s2+YM7JD0HDgLhnRgf4BHaZix/m0Wsxu4H8QhnISNKgwb6aCo+n
         hv2A==
X-Gm-Message-State: AC+VfDwgkDvT7FfYZjsW9xqLvw7P0jD1pSqhkIPbVa1L2qogD7oe3e7a
	F/R6HlV1qyW2c9laz2mEAPaLoSzCgTdUR2lgL2cExA==
X-Google-Smtp-Source: ACHHUZ6MYat4STXZJsVwuZR4PYNh7+BmxG/S1f4+FO72tkacwa0bCowdG+yEUis8XEPl+y1Grq2Wuw7SQ1wmtWBl/qY=
X-Received: by 2002:a1f:45c8:0:b0:456:fc81:1db3 with SMTP id
 s191-20020a1f45c8000000b00456fc811db3mr197246vka.5.1684417254221; Thu, 18 May
 2023 06:40:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-4-imagedong@tencent.com> <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
 <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com>
In-Reply-To: <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Thu, 18 May 2023 09:40:37 -0400
Message-ID: <CADVnQynZ67511+cKF=hyiaLx5-fqPGGmpyJ-5Lk6ge-ivmAf-w@mail.gmail.com>
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

On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <menglong8.dong@gmai=
l.com> wrote:
>
> On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet@google.co=
m> wrote:
> >
> > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> wrot=
e:
> > >
> > > From: Menglong Dong <imagedong@tencent.com>
> > >
> > > Window shrink is not allowed and also not handled for now, but it's
> > > needed in some case.
> > >
> > > In the origin logic, 0 probe is triggered only when there is no any
> > > data in the retrans queue and the receive window can't hold the data
> > > of the 1th packet in the send queue.
> > >
> > > Now, let's change it and trigger the 0 probe in such cases:
> > >
> > > - if the retrans queue has data and the 1th packet in it is not withi=
n
> > > the receive window
> > > - no data in the retrans queue and the 1th packet in the send queue i=
s
> > > out of the end of the receive window
> >
> > Sorry, I do not understand.
> >
> > Please provide packetdrill tests for new behavior like that.
> >
>
> Yes. The problem can be reproduced easily.
>
> 1. choose a server machine, decrease it's tcp_mem with:
>     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> 2. call listen() and accept() on a port, such as 8888. We call
>     accept() looply and without call recv() to make the data stay
>     in the receive queue.
> 3. choose a client machine, and create 100 TCP connection
>     to the 8888 port of the server. Then, every connection sends
>     data about 1M.
> 4. we can see that some of the connection enter the 0-probe
>     state, but some of them keep retrans again and again. As
>     the server is up to the tcp_mem[2] and skb is dropped before
>     the recv_buf full and the connection enter 0-probe state.
>     Finially, some of these connection will timeout and break.
>
> With this series, all the 100 connections will enter 0-probe
> status and connection break won't happen. And the data
> trans will recover if we increase tcp_mem or call 'recv()'
> on the sockets in the server.
>
> > Also, such fundamental change would need IETF discussion first.
> > We do not want linux to cause network collapses just because billions
> > of devices send more zero probes.
>
> I think it maybe a good idea to make the connection enter
> 0-probe, rather than drop the skb silently. What 0-probe
> meaning is to wait for space available when the buffer of the
> receive queue is full. And maybe we can also use 0-probe
> when the "buffer" of "TCP protocol" (which means tcp_mem)
> is full?
>
> Am I right?
>
> Thanks!
> Menglong Dong

Thanks for describing the scenario in more detail. (Some kind of
packetdrill script or other program to reproduce this issue would be
nice, too, as Eric noted.)

You mention in step (4.) above that some of the connections keep
retransmitting again and again. Are those connections receiving any
ACKs in response to their retransmissions? Perhaps they are receiving
dupacks? If so, then perhaps we could solve this problem without
depending on a violation of the TCP spec (which says the receive
window should not be retracted) in the following way: when a data
sender suffers a retransmission timeout, and retransmits the first
unacknowledged segment, and receives a dupack for SND.UNA instead of
an ACK covering the RTO-retransmitted segment, then the data sender
should estimate that the receiver doesn't have enough memory to buffer
the retransmitted packet. In that case, the data sender should enter
the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 timer to
call tcp_probe_timer().

Basically we could try to enhance the sender-side logic to try to
distinguish between two kinds of problems:

(a) Repeated data packet loss caused by congestion, routing problems,
or connectivity problems. In this case, the data sender uses
ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off and only
retries sysctl_tcp_retries2 times before timing out the connection

(b) A receiver that is repeatedly sending dupacks but not ACKing
retransmitted data because it doesn't have any memory. In this case,
the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), and backs
off but keeps retrying as long as the data sender receives ACKs.

AFAICT that would be another way to reach the happy state you mention:
"all the 100 connections will enter 0-probe status and connection
break won't happen", and we could reach that state without violating
the TCP protocol spec and without requiring changes on the receiver
side (so that this fix could help in scenarios where the
memory-constrained receiver is an older stack without special new
behavior).

Eric, Yuchung, Menglong: do you think something like that would work?

neal

