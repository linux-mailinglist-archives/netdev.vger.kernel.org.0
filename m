Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9084C16A4EF
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgBXLc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:32:26 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37463 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBXLc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 06:32:26 -0500
Received: by mail-ed1-f66.google.com with SMTP id t7so11502400edr.4;
        Mon, 24 Feb 2020 03:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AfrimxhNpVIP3+bGsNCdKoq84x3eL8XHOriR3+8j0Ms=;
        b=OZsng7PbGu7nmQgVf0EtJ4UWk9brlGfX7GQV6ScV8Un4zIbnEmMQo3K75kfZv2R4de
         xn5deO8iu6mqROEspIXv4C7rytvd5C0l81vNnQ68QvJE/3rUTisCUF13AeFSF/ItpxLl
         5+WzaVr95eOKF1VDrIwhwlQYOyo3rsiwqBRiwvZYpIQTtHGoBpL3vTWEe1ot1PvW8sVj
         gLGBY3nytSKGi+JjFUhai8H+diT/G7IqNMgelKUAYJC2dD1glW01knXX957H1t72VZlB
         Vg9twX8zXS+4S5y1bcD4RGzTFKaISbSHlUJ/SxtszwziKDtnEv3CZT1Uibr+BQkrcOIk
         awgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AfrimxhNpVIP3+bGsNCdKoq84x3eL8XHOriR3+8j0Ms=;
        b=Y2LGRI6hWRb8H89sCLBIv9vKYXo/jnO6CXe/fjB4qJ37CBtdpTmEYLn1DZXQGS0GOc
         5OcdLzBDLpOS4YY+/zCWrLMeMxWz9890+jKH51ZtAr1x+iO9cOwqMIVU1sWZJQqzVATw
         V4MbbTlXFhstH83I072WMLAHYOWr/FcGTvXOl0cJbQ9WE0+2b4pMKVtRP91beelDlEny
         EGQzd+hG3Rv6t0tvsVLbUHi+uduepKY9Mztcbt8fkAUn94HE4+6uuauc9OTtDVCC3NDi
         CHbGIkFxdR5YDHaQPxlhKuibfHifkSd7rjinQdbt0rM5BXRgI+M2/NihP8q9L/r+56aX
         XdIQ==
X-Gm-Message-State: APjAAAVk9LjqaJGDzwhHqTfrgkEljbhBzrToSFPO59otg2uehbkgQt4F
        V8vzeld83CKfX3Vg3deBmAkXytzQGyNr4v/XBFI=
X-Google-Smtp-Source: APXvYqx9zeCTXG6L2u/50zzr6HLZumNTp5QAGjJPhbCfCsxqyl+CRJ3+VOhlW4+ONQ2A4mxbmAR07pHS25KnPjt6JdU=
X-Received: by 2002:aa7:d3cb:: with SMTP id o11mr46447702edr.145.1582543944370;
 Mon, 24 Feb 2020 03:32:24 -0800 (PST)
MIME-Version: 1.0
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hoSA5DECsA+faJ91n0jBhAR5BZnkMm=Dx4JfNDp8J+xbw@mail.gmail.com> <20200224110350.7kdzf4kml4iaem4i@soft-dev3.microsemi.net>
In-Reply-To: <20200224110350.7kdzf4kml4iaem4i@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 24 Feb 2020 13:32:13 +0200
Message-ID: <CA+h21hrWqdvfApodpKbBXNH83cFT4uCgBmAtnzs+t63bhktO2g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Mon, 24 Feb 2020 at 13:03, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> Hi Vladimir,
>
> The 02/24/2020 12:38, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > Hi Horatiu,
> >
> > On Fri, 31 May 2019 at 10:18, Horatiu Vultur
> > <horatiu.vultur@microchip.com> wrote:
> > >
> > > Add ACL support using the TCAM. Using ACL it is possible to create rules
> > > in hardware to filter/redirect frames.
> > >
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > ---
> > >  arch/mips/boot/dts/mscc/ocelot.dtsi      |   5 +-
> > >  drivers/net/ethernet/mscc/Makefile       |   2 +-
> > >  drivers/net/ethernet/mscc/ocelot.c       |  13 +
> > >  drivers/net/ethernet/mscc/ocelot.h       |   8 +
> > >  drivers/net/ethernet/mscc/ocelot_ace.c   | 777 +++++++++++++++++++++++++++++++
> > >  drivers/net/ethernet/mscc/ocelot_ace.h   | 227 +++++++++
> > >  drivers/net/ethernet/mscc/ocelot_board.c |   1 +
> > >  drivers/net/ethernet/mscc/ocelot_regs.c  |  11 +
> > >  drivers/net/ethernet/mscc/ocelot_s2.h    |  64 +++
> > >  drivers/net/ethernet/mscc/ocelot_vcap.h  | 403 ++++++++++++++++
> > >  10 files changed, 1508 insertions(+), 3 deletions(-)
> > >  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.c
> > >  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.h
> > >  create mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
> > >  create mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
> > >
> >
> > I was testing this functionality and it looks like the MAC_ETYPE keys
> > (src_mac, dst_mac) only match non-IP frames.
> > Example, this rule doesn't drop ping traffic:
> >
> > tc qdisc add dev swp0 clsact
> > tc filter add dev swp0 ingress flower skip_sw dst_mac
> > 96:e1:ef:64:1b:44 action drop
> >
> > Would it be possible to do anything about that?
>
> What you could do is to configure each port in such a way, to treat IP
> frames as MAC_ETYPE frames. Have a look in ANA:PORT[0-11]:VCAP_S2_CFG.
>
> There might be a problem with this approach. If you configure the port
> in such a way, then all your rules with the keys IP6, IP4 will not be
> match on that port.
>

Thanks for the quick answer.
Doing that is indeed problematic and would not be my first choice. I
was expecting MAC_ETYPE rules to always match an Ethernet frame
regardless of higher-level protocols, and that the user would decide
the behavior via rule ordering.

> >
> > Thanks,
> > -Vladimir
>
> --
> /Horatiu

-Vladimir
