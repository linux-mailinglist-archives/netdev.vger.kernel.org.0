Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F922AB75D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgKILlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729551AbgKILlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:41:31 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5910FC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 03:41:31 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id g7so7958091ilr.12
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rvy9/WkLCxYxtHuDnEwzo7NVYvNBUGnMi/E3lzNTZiU=;
        b=VeNw+S3Fb2nmjMIz7GerJ9k7CYcEDXKZqMHEblY+L/1ubVSAfK5ZmtOeuQWyYpqL9C
         ivnLJt/qAnNlHbPQQI+uut27ATNnIDTrW7XjmrnafVZo8YmGh6b5+EFF3DzhuMxFd/um
         kTvKAc68vHorDClk80q2S2+wMU3DYKxUBPDun3p3J4vPYZecAn2YUs+hAVDhhhg/n2yY
         bXwn4gcKz8IFGpm+T4t+HlHYtSXj8JwleBAyEWlQdXQbTT7JQKHmH0usI3KqMUI90Gu3
         b9yUCAw0IakLsMoi+h8bGyMw9YwGW1vTHxQwgGtIpv9iGqDmkzaphSAhaIRcni9sGBek
         j2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rvy9/WkLCxYxtHuDnEwzo7NVYvNBUGnMi/E3lzNTZiU=;
        b=Mfiw+q4RC9t13FJWMPDqF8bY6jKC0s0TlFmfts2lB/QLTWHmFjGhP5wDqBcOUp/4bd
         8QeAFQhTFv9F4F8g+3bLfdO4rddQjg6ZZ2eXpPPAQC7ACDOCjVqHUwoYeRlPcSiip92z
         j8V2vAixhEV5ekbz7dKISvhyMFyP+VaJ6GJy8kvDh6qCVo/XkN0JNPW4uLFKo4IGdxUm
         JpD1gqPP4ICRrBSmlXT7B7k1CuFM9WCG77SQcNQVi081Hvrk9MfbUirJMG3ScvpQ0MVK
         r901TDDR8vS4t4xmP4tcYabEkfDWZfs82pfSVHzwudRfC5hCQjKJ4rCwpAQxNICmy0Ce
         ds2Q==
X-Gm-Message-State: AOAM532zuma1JChzdo1TG8BFiRG706pYo+8JCSd6dETBbv6mQtMmPAy6
        C+SwoHKV1G/d3//HWsWezvnAEQ88O5j7VC0rNBEJIQ==
X-Google-Smtp-Source: ABdhPJz3qLOUE/G75fCctA62RI4+6Fx4vrvuNy0j+jzQhoNBnx7H5kZbMbH0YPhIb+t3GtjiNwt6TV6dGxYa1LAkSJo=
X-Received: by 2002:a92:7f08:: with SMTP id a8mr9095512ild.216.1604922090454;
 Mon, 09 Nov 2020 03:41:30 -0800 (PST)
MIME-Version: 1.0
References: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
 <1604914417-24578-1-git-send-email-wenan.mao@linux.alibaba.com>
 <CANn89iKiNdtxaL_yMF6=_8=m001vXVaxvECMGbAiXTYZjfj3oQ@mail.gmail.com>
 <3b92167c-201c-e85d-822d-06f0c9ac508c@linux.alibaba.com> <CANn89i+oS75TVKBDOBrr7Ff55Uctq4_HUcM_05Ed8kUL1HkHLw@mail.gmail.com>
In-Reply-To: <CANn89i+oS75TVKBDOBrr7Ff55Uctq4_HUcM_05Ed8kUL1HkHLw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 12:41:19 +0100
Message-ID: <CANn89iJ5kuEfKAJoWxM9MWV5X6nHXzbtcBkh1OBTak-Y6SzbPQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Update window_clamp if SOCK_RCVBUF is set
To:     Mao Wenan <wenan.mao@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packetdrill test would be :

// Force syncookies
`sysctl -q net.ipv4.tcp_syncookies=3D2`

    0 socket(..., SOCK_STREAM, IPPROTO_TCP) =3D 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) =3D 0
   +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [2048], 4) =3D 0
   +0 bind(3, ..., ...) =3D 0
   +0 listen(3, 1) =3D 0

+0 < S 0:0(0) win 32792 <mss 1000,sackOK,TS val 100 ecr 0,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,sackOK,TS val 4000 ecr 100,nop,wscale 0>
  +.1 < . 1:1(0) ack 1 win 1024 <nop,nop,TS val 200 ecr 4000>
   +0 accept(3, ..., ...) =3D 4
+0 %{ assert tcpi_snd_wscale =3D=3D 0, tcpi_snd_wscale }%

On Mon, Nov 9, 2020 at 12:02 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Nov 9, 2020 at 11:12 AM Mao Wenan <wenan.mao@linux.alibaba.com> w=
rote:
> >
> >
> >
> > =E5=9C=A8 2020/11/9 =E4=B8=8B=E5=8D=885:56, Eric Dumazet =E5=86=99=E9=
=81=93:
> > > On Mon, Nov 9, 2020 at 10:33 AM Mao Wenan <wenan.mao@linux.alibaba.co=
m> wrote:
> > >>
> > >> When net.ipv4.tcp_syncookies=3D1 and syn flood is happened,
> > >> cookie_v4_check or cookie_v6_check tries to redo what
> > >> tcp_v4_send_synack or tcp_v6_send_synack did,
> > >> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
> > >> which will make rcv_wscale is different, the client
> > >> still operates with initial window scale and can overshot
> > >> granted window, the client use the initial scale but local
> > >> server use new scale to advertise window value, and session
> > >> work abnormally.
> > >
> > > What is not working exactly ?
> > >
> > > Sending a 'big wscale' should not really matter, unless perhaps there
> > > is a buggy stack at the remote end ?
> > 1)in tcp_v4_send_synack, if SO_RCVBUF is set and
> > tcp_full_space(sk)=3D65535, pass req->rsk_window_clamp=3D65535 to
> > tcp_select_initial_window, rcv_wscale will be zero, and send to client,
> > the client consider wscale is 0;
> > 2)when ack is back from client, if there is no this patch,
> > req->rsk_window_clamp is 0, and pass to tcp_select_initial_window,
> > wscale will be 7, this new rcv_wscale is no way to advertise to client.
> > 3)if server send rcv_wind to client with window=3D63, it consider the r=
eal
> > window is 63*2^7=3D8064, but client consider the server window is only
> > 63*2^0=3D63, it can't send big packet to server, and the send-q of clie=
nt
> > is full.
> >
>
> I see, please change your patches so that tcp_full_space() is used _once_
>
> listener sk_rcvbuf can change under us.
>
> I really have no idea how window can be set to 63, so please send us
> the packetdrill test once you have it.
