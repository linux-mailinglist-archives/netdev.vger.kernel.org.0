Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C02ABE21
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgKIOBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729871AbgKIOBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:01:40 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36225C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 06:01:40 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id t13so8359174ilp.2
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 06:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R/y3h2V8KUh2HjjXpKhtsmK1j3JU5Ik5x1QmKjAc+dw=;
        b=sCHfxt1Tg+i5nd302fB2fuH/skV5z9YHP9zYsSGc+aivet4eZV9LHp1n4S5VD2JxlQ
         vlxHzm2jS2InJ+TtETBPTBs1m/UII6vtfBDqJB3/vIzvBiK5JouLCXz85fRCfIkVE3AP
         TmugfLHQze9u3h5/dP46mop+7w+c8kW01+ra0FgUSXDlvZZUKm6OA+COJ9N/z20roiCm
         dkvM1tsT/0jbVgsYqUzvQEtMsoyjgcStAwZGd/ekeDI7v63A2IO5x0xXKsaI7Y/Qzq5F
         vqQmcg7CRlZgrQu0M4KqGWEduol6rT0cjgG8W+/wAIwrczKmwNMqkuuBmNNloI0buZ7Y
         uKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R/y3h2V8KUh2HjjXpKhtsmK1j3JU5Ik5x1QmKjAc+dw=;
        b=OUDNDid/lvN13rn3ClQP9hp4DHwl6DBowmRNxuWGqSgWQz/P9GSmyy7wSrBnnna9pW
         4SUa0+V/yLriwWoJL/sammfpZyNaeJvjufprL5BlUUxMg78+nEIagyl0sHXghzMdLjQ6
         3CpDBrgr+178+hgspYY47Tu6nLV2TYF7hostmYxqH/6Tc4zxAYXUITEk81eEyZ5LcREJ
         05m+F6pZBohmTfnXYXEGhczXNlPEeME+yeHzK6qFeq/Rcb6egBZ9TdqWv1ELmkJJR1N3
         KIapZONMpccDwYqRTtOa4P0+SqyTQdk/PPLUxsCd+Ny1/KXK/hB1lP/Bp5qgsiZVkZfz
         FV5Q==
X-Gm-Message-State: AOAM533jTtOSKsrgaOY24236Zl/QBtYOcNRvm40ktrCc85DbNZAjUorJ
        wEuVvPcTEeTgKXO6CZreoFAT4n8lHfCUnzJaD8TYEw==
X-Google-Smtp-Source: ABdhPJxaKVOuDzlxhdWUNS2F1aDUsYr9TZS1F1EZaAf/eBNGDDQ34ZzmFykw1qVrgV1xaz+EFOmyT71gy0MuHe/FhxA=
X-Received: by 2002:a92:6f11:: with SMTP id k17mr10207429ilc.69.1604930499398;
 Mon, 09 Nov 2020 06:01:39 -0800 (PST)
MIME-Version: 1.0
References: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
 <1604914417-24578-1-git-send-email-wenan.mao@linux.alibaba.com>
 <CANn89iKiNdtxaL_yMF6=_8=m001vXVaxvECMGbAiXTYZjfj3oQ@mail.gmail.com>
 <3b92167c-201c-e85d-822d-06f0c9ac508c@linux.alibaba.com> <CANn89i+oS75TVKBDOBrr7Ff55Uctq4_HUcM_05Ed8kUL1HkHLw@mail.gmail.com>
 <CANn89iJ5kuEfKAJoWxM9MWV5X6nHXzbtcBkh1OBTak-Y6SzbPQ@mail.gmail.com>
In-Reply-To: <CANn89iJ5kuEfKAJoWxM9MWV5X6nHXzbtcBkh1OBTak-Y6SzbPQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 15:01:27 +0100
Message-ID: <CANn89iLhCjh7ZQRanVEj6Sytzn6LhFOb9Xo7O=teLHPouoeopw@mail.gmail.com>
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

On Mon, Nov 9, 2020 at 12:41 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Packetdrill test would be :
>
> // Force syncookies
> `sysctl -q net.ipv4.tcp_syncookies=3D2`
>
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) =3D 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) =3D 0
>    +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [2048], 4) =3D 0
>    +0 bind(3, ..., ...) =3D 0
>    +0 listen(3, 1) =3D 0
>
> +0 < S 0:0(0) win 32792 <mss 1000,sackOK,TS val 100 ecr 0,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <mss 1460,sackOK,TS val 4000 ecr 100,nop,wscale 0=
>
>   +.1 < . 1:1(0) ack 1 win 1024 <nop,nop,TS val 200 ecr 4000>
>    +0 accept(3, ..., ...) =3D 4
> +0 %{ assert tcpi_snd_wscale =3D=3D 0, tcpi_snd_wscale }%
>

Also, please add to your next submission an appropriate Fixes: tag :

Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's
rcv-buffer via setsockopt")

> On Mon, Nov 9, 2020 at 12:02 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Nov 9, 2020 at 11:12 AM Mao Wenan <wenan.mao@linux.alibaba.com>=
 wrote:
> > >
> > >
> > >
> > > =E5=9C=A8 2020/11/9 =E4=B8=8B=E5=8D=885:56, Eric Dumazet =E5=86=99=E9=
=81=93:
> > > > On Mon, Nov 9, 2020 at 10:33 AM Mao Wenan <wenan.mao@linux.alibaba.=
com> wrote:
> > > >>
> > > >> When net.ipv4.tcp_syncookies=3D1 and syn flood is happened,
> > > >> cookie_v4_check or cookie_v6_check tries to redo what
> > > >> tcp_v4_send_synack or tcp_v6_send_synack did,
> > > >> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
> > > >> which will make rcv_wscale is different, the client
> > > >> still operates with initial window scale and can overshot
> > > >> granted window, the client use the initial scale but local
> > > >> server use new scale to advertise window value, and session
> > > >> work abnormally.
> > > >
> > > > What is not working exactly ?
> > > >
> > > > Sending a 'big wscale' should not really matter, unless perhaps the=
re
> > > > is a buggy stack at the remote end ?
> > > 1)in tcp_v4_send_synack, if SO_RCVBUF is set and
> > > tcp_full_space(sk)=3D65535, pass req->rsk_window_clamp=3D65535 to
> > > tcp_select_initial_window, rcv_wscale will be zero, and send to clien=
t,
> > > the client consider wscale is 0;
> > > 2)when ack is back from client, if there is no this patch,
> > > req->rsk_window_clamp is 0, and pass to tcp_select_initial_window,
> > > wscale will be 7, this new rcv_wscale is no way to advertise to clien=
t.
> > > 3)if server send rcv_wind to client with window=3D63, it consider the=
 real
> > > window is 63*2^7=3D8064, but client consider the server window is onl=
y
> > > 63*2^0=3D63, it can't send big packet to server, and the send-q of cl=
ient
> > > is full.
> > >
> >
> > I see, please change your patches so that tcp_full_space() is used _onc=
e_
> >
> > listener sk_rcvbuf can change under us.
> >
> > I really have no idea how window can be set to 63, so please send us
> > the packetdrill test once you have it.
