Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172A61657E8
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBTGmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:42:13 -0500
Received: from mail-yw1-f46.google.com ([209.85.161.46]:34390 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgBTGmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 01:42:12 -0500
Received: by mail-yw1-f46.google.com with SMTP id b186so1432887ywc.1
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 22:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQ+IbXyI0716sGwzySCi/2PZSqAJF4IYLXvTF2SVZ7I=;
        b=hEBdVPIebv3TxJ/awBEPdpGkWOjd6q31BpKysgAJe0FR5iusXgNWbYkvGusoxC17Qj
         LAczq/DjfQ9cMqM7+Y/JJdyKcoOU0y44xO3HGfddXJGFf83BFyYOUXnh2H7Xbv1I88+L
         OP4nQok8MijddZgERhIyzp5f1ZeHQvU2l+/SuQQUOPr00ZjTvgovS226ttPWrqlitltt
         SxjpAow18sMx/x3DJ30RRx+Q6nJQB6K0Nuzro433kcKQA0bu96T0Oty5/V5a9RJ0rzdH
         gzp3+FlMlhqeFZ9IT1unlqtdfgzxzT3AgB2fgsr3oAUP1eLS485XqX0KXXEX2r6svmDD
         I/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQ+IbXyI0716sGwzySCi/2PZSqAJF4IYLXvTF2SVZ7I=;
        b=kUFysVlF7m0CYteXLCyp4gWOsFQiesJtHT9qC5My0hKnP67bUKMX1E6vRU3IjXeOGQ
         JzOZsquymG3YJf46B6tL7q/UlN8jK8+F5b0uEYIA6bXA2yyFS6urFMSoMJRICrIuKyIJ
         BANJn0Wmhrd3o2tbooAC4dg42tXqYrKoAxGsgouDsaR6ZD7YebDpvU/JO1G1uGfAS62N
         rFn2DWXDli/JI0neRb+eH7Zabkrk0kzbXOnYeMKLl0zO11C0KfJSAtRYTmkDPI8n5M5Q
         pSnSsavnFwOGHAUPpX2U5eoqIRYpB2oOlGgieYIGPyTA0x2pRyIVmGplFmRyywzghLr5
         sTLg==
X-Gm-Message-State: APjAAAUjAafOf1yHrfxIHjTt/mIujLssVmZm8stiBa5LHtosig5boF2E
        fCNq9zhCpvcN6j0Uat7Y7PgWx2AV
X-Google-Smtp-Source: APXvYqyTi5aaPNI6cnrlCu8XT1qSWBhAw9spygTt6dMIIXb8e7cYv4XW74PcGgmsx6Z29c6TulkAPQ==
X-Received: by 2002:a81:9304:: with SMTP id k4mr24546628ywg.323.1582180931086;
        Wed, 19 Feb 2020 22:42:11 -0800 (PST)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id s3sm989255ywf.22.2020.02.19.22.42.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 22:42:10 -0800 (PST)
Received: by mail-yb1-f175.google.com with SMTP id f130so1660240ybc.7
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 22:42:09 -0800 (PST)
X-Received: by 2002:a25:6906:: with SMTP id e6mr27371361ybc.441.1582180929443;
 Wed, 19 Feb 2020 22:42:09 -0800 (PST)
MIME-Version: 1.0
References: <da2b1a2f-b8f7-21de-05c2-9a30636ccf9f@ti.com> <9cfc1bcb-6d67-e966-28d9-a6f290648cb0@ti.com>
 <CA+FuTSeSouL4pFFo8kAcU4yZ7m6C2v_6OcGHXHWeEXXNFofzXA@mail.gmail.com> <20200219162546.312218a2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200219162546.312218a2@kicinski-fedora-PC1C0HJN>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 19 Feb 2020 22:41:32 -0800
X-Gmail-Original-Message-ID: <CA+FuTSf0vuRJgxmD=AWRrFRFCr5VeTNfpVWmZvCM2ufuK+tLfw@mail.gmail.com>
Message-ID: <CA+FuTSf0vuRJgxmD=AWRrFRFCr5VeTNfpVWmZvCM2ufuK+tLfw@mail.gmail.com>
Subject: Re: CHECKSUM_COMPLETE question
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 4:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 19 Feb 2020 14:59:16 -0800 Willem de Bruijn wrote:
> > On Wed, Feb 19, 2020 at 9:04 AM Grygorii Strashko
> > <grygorii.strashko@ti.com> wrote:
> > >
> > > Hi All,
> > >
> > > On 12/02/2020 11:52, Grygorii Strashko wrote:
> > > > Hi All,
> > > >
> > > > I'd like to ask expert opinion and clarify few points about HW RX checksum offload.
> > > >
> > > > 1) CHECKSUM_COMPLETE - from description in <linux/skbuff.h>
> > > >   * CHECKSUM_COMPLETE:
> > > >   *
> > > >   *   This is the most generic way. The device supplied checksum of the _whole_
> > > >   *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
> > > >   *   hardware doesn't need to parse L3/L4 headers to implement this.
> > > >
> > > > My understanding from above is that HW, to be fully compatible with Linux, should produce CSUM
> > > > starting from first byte after EtherType field:
> > > >   (6 DST_MAC) (6 SRC_MAC) (2 EtherType) (...                   ...)
> > > >                                          ^                       ^
> > > >                                          | start csum            | end csum
> > > > and ending at the last byte of Ethernet frame data.
> > > > - if packet is VLAN tagged then VLAN TCI and real EtherType included in CSUM,
> > > >    but first VLAN TPID doesn't
> > > > - pad bytes may/may not be included in csum
> >
> > Based on commit 88078d98d1bb ("net: pskb_trim_rcsum() and
> > CHECKSUM_COMPLETE are friends") these bytes are expected to be covered
> > by skb->csum.
> >
> > Not sure about that ipv4 header pull without csum adjust.
>
> Isn't it just because IPv4 has a header checksum and therefore what's
> pulled off adds up to 0 anyway? IPv6 does not have a header csum, hence
> the adjustment?

Ah yes, of course!
