Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6690252839
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 09:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHZHN2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Aug 2020 03:13:28 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36715 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgHZHN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 03:13:27 -0400
Received: by mail-oi1-f195.google.com with SMTP id b9so695859oiy.3;
        Wed, 26 Aug 2020 00:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FGHPb84Jx11W3vIf+ODKn/oBh3C6uj3q4u2snyewUTw=;
        b=TPRbD82xxEC79PMccp+ZMzJ5MVIGmAwTuXCY1UUHzFpOD1E3s2Wch/5XWinv0bYWXF
         s8yCbd9DMBQW+xOr6/wXdUeDPttAPu8gSqKvXc78Oz6/8//8H1qazrRolufojI3siDPy
         6n5NP+43t1fV20nj4OpaPbJkf8NX938MnMM925QrVXiVbGJnfIU80GpixayLF7x6uk/R
         mk9gGftC5RpehgtfUc5OaqmDEB2YGEr6vecq9qEyWnKj5CkQWETVnjO3fBLqOpqIoZPe
         rYFmUOKbUReXyM7O30WTfBJdkj5tGqYCqRkdEsDusL1xBpl3ViG9ZgYwrLppk4fi3A2m
         J7nA==
X-Gm-Message-State: AOAM531/WUMwliqa8O3BASt/i04yccXlsgCfKQFhG7SpxuKaZ7fhd/sq
        AN4sXy0OBecMWlfTZN4hW7vLb09xl0qOdKdZfys88k8F89I=
X-Google-Smtp-Source: ABdhPJzJ6a5NBDzJtEvfkg5F2sVcb5PuRWQN4ld2RSTCZ8WlCraVfILM0VjbwiytxZr10m9hx+KCyWNT6QSx2+Z7PCM=
X-Received: by 2002:aca:3402:: with SMTP id b2mr648406oia.153.1598426006201;
 Wed, 26 Aug 2020 00:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200825170322eucas1p2c6619aa3e02d2762e07da99640a2451c@eucas1p2.samsung.com>
 <20200825170311.24886-1-l.stelmach@samsung.com> <20200825180134.GN2403519@lunn.ch>
In-Reply-To: <20200825180134.GN2403519@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 Aug 2020 09:13:14 +0200
Message-ID: <CAMuHMdWNdMEnSnLRkUkRmLop4E-tnBirjfMw06e_40Ss-V-JyQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 8:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Tue, Aug 25, 2020 at 07:03:09PM +0200, Łukasz Stelmach wrote:
> > +     if (netif_msg_pktdata(ax_local)) {
> > +             int loop;
> > +             netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
> > +                             pkt_len, tx_skb->len, seq_num);
> > +
> > +             netdev_info(ndev, "  Dump SPI Header:\n    ");
> > +             for (loop = 0; loop < 4; loop++)
> > +                     netdev_info(ndev, "%02x ", *(tx_skb->data + loop));
> > +
> > +             netdev_info(ndev, "\n");
>
> This no longer works as far as i remember. Lines are terminate by
> default even if they don't have a \n.
>
> Please you should not be using netdev_info(). netdev_dbg() please.

We have a nice helper for this: print_hex_dump_debug().

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
