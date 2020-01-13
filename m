Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F839138F05
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgAMK2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:28:22 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44443 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgAMK2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:28:21 -0500
Received: by mail-ed1-f68.google.com with SMTP id bx28so7960373edb.11;
        Mon, 13 Jan 2020 02:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iMaJqGe+/87KiNUvJjKYz57OCMd9euJzaVWaUN0lP1s=;
        b=DObAAOFbSbrVsGeQHDd10Vzw+tqaEuBubMD9TEHteChXl3Os6q57ah95lTayO9eabr
         4H8lfic+3PgOkOYTAmV9yTJ5Rd17E7OyzZZmH6MvfpcrduFUp2wPJuFxohfeg9RHwr1l
         XtNYo0ro+an7eUtSAAvkNbMR6TasOwacC/o0rhmpmTaMO4K9IvJ4kbQAAwny4MY9z6q/
         +KLC9BGC9NsZS1hjdc//LeCh68StWNhrw5FHOZ15I/LsTIIfvhhzIFJ0v1RT/3CpXbgY
         QT19mQoAGaH9rq7xwv2sjdTE/NsDMw/GXBgONCEvOUpG56varewMdFKAHBZ6Pg23b5MK
         S/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iMaJqGe+/87KiNUvJjKYz57OCMd9euJzaVWaUN0lP1s=;
        b=pYUlpSu0bVx3ikESa6a1g+6wV7OWUujW346vRTiPdavQ/OyV7f4EDSDwNoxCCX3K18
         ygulSdfz+KGthmu26MK78Xg0VzUJRpfl6WapH84lh/lw8kXfS5eaxPs4AxNrxT5Bm2R/
         02n6DYnWKFNNVY9xKB7/31mhdgCdXDi/HlA7soyRx8+AO8ggYjEv4Bq/4DepUbpvOotM
         7Gg9hwfU9VUws6AZXUJyisFTZwntwsYLgn1Bu6TnUZiifz+EnxtR1wmMawLY++cA6U9E
         9rAuUhsFkL9DeHOY7YkYJ7sO9ECTBjLv0qKypX4FDMuriFpZxYVJ4fT0ln6w0I4sLmua
         r8kg==
X-Gm-Message-State: APjAAAUxm7lJO5DLmbAhuKl8N0DbW4ad175S9kvY4HYkZD4qxPMLRF3+
        MSU3JMU2kPicDNJEWkG6cehqD6OAQHUmwCaMZCw=
X-Google-Smtp-Source: APXvYqyePqN9rysuFPmxEhUlGyUdY4qvbz40qryhjRRm5hpgejdUM23whTYnPjgS7seBJrNUneoHgAgsHduYxvuLJZQ=
X-Received: by 2002:a17:906:504d:: with SMTP id e13mr16068802ejk.103.1578911300006;
 Mon, 13 Jan 2020 02:28:20 -0800 (PST)
MIME-Version: 1.0
References: <20191230143028.27313-1-alobakin@dlink.ru> <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com> <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
 <CA+h21hoSoZT+ieaOu8N=MCSqkzey0L6HeoXSyLtHjZztT0S9ug@mail.gmail.com> <0002a7388dfd5fb70db4b43a6c521c52@dlink.ru>
In-Reply-To: <0002a7388dfd5fb70db4b43a6c521c52@dlink.ru>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 13 Jan 2020 12:28:09 +0200
Message-ID: <CA+h21hqZoLrU7nL3Vo0KcmFnOxNxQPwoOVSEd6styyjK7XO+5w@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO callbacks
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 at 11:46, Alexander Lobakin <alobakin@dlink.ru> wrote:
>
> Vladimir Oltean wrote 13.01.2020 12:42:
> > Hi Alexander,
> >
> > On Mon, 13 Jan 2020 at 11:22, Alexander Lobakin <alobakin@dlink.ru>
> > wrote:
> >>
> >> CPU ports can't be bridged anyway
> >>
> >> Regards,
> >> =E1=9A=B7 =E1=9B=96 =E1=9A=A2 =E1=9A=A6 =E1=9A=A0 =E1=9A=B1
> >
> > The fact that CPU ports can't be bridged is already not ideal.
> > One can have a DSA switch with cascaded switches on each port, so it
> > acts like N DSA masters (not as DSA links, since the taggers are
> > incompatible), with each switch forming its own tree. It is desirable
> > that the ports of the DSA switch on top are bridged, so that
> > forwarding between cascaded switches does not pass through the CPU.
>
> Oh, I see. But currently DSA infra forbids the adding DSA masters to
> bridges IIRC. Can't name it good or bad decision, but was introduced
> to prevent accidental packet flow breaking on DSA setups.
>

I just wanted to point out that some people are going to be looking at
ways by which the ETH_P_XDSA handler can be made to play nice with the
master's rx_handler, and that it would be nice to at least not make
the limitation worse than it is by converting everything to
rx_handlers (which "currently" can't be stacked, from the comments in
netdevice.h).

> > -Vladimir
>
> Regards,
> =E1=9A=B7 =E1=9B=96 =E1=9A=A2 =E1=9A=A6 =E1=9A=A0 =E1=9A=B1
