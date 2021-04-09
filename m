Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDF235A745
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhDIToC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhDIToA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:44:00 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26E1C061762;
        Fri,  9 Apr 2021 12:43:46 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u21so10396318ejo.13;
        Fri, 09 Apr 2021 12:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UYa70dh30D9VBwtvT7OqpO7sw3vtfJKMvIiKRh6GeY=;
        b=fkkfoPoRz8d83AokzQ7L6GTbjaKU/DhNM7q7RVEpqTsF1klo1m6lCvAwTolJSXWAbM
         JIBjY40QgYqcJtcXxfejiZ9bkv+j/sEyxjpFch/MH6jDX2IGNJ4Yi35w8a1eyHKescx2
         0TFIOqIqdwr+uKCrBH/P28A8cnv8GgvR7hj96mBL8BXcpfGgPtkR5sBg81vdSBGcfaN1
         Xe/74i/JICYjlKWAAiBPCvpeYIZTtsnjjtBmLfcccUqAtIxFCtfTKi5i+mrIAEmxYrU4
         TZHcnRvCkKUKGwIHina+mheILLHyyGDmukDdeKKHmPpWDCoxkfvPGKaMRavdq5w8XQYE
         3pEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UYa70dh30D9VBwtvT7OqpO7sw3vtfJKMvIiKRh6GeY=;
        b=ID1e00AuAtK9DW71L3YxLtC9jhXawAUKOgNR1PWCyI/QzWr4o13dSrnxWMUlmjlHKv
         /xo8I8AR4d5JPZw4lRSB/8dNCEciwGRCADWY4LfSM+GuzKs/kEmjXijBdUgm313bqWn8
         tO0RNYZquPuDbcgle85Q7JA9aXcUrDiSqwvXsjG8GB64E5dYydXsGnzeLzBqlBtfygaX
         eR3NNt0G/DSxtMIzGmgVeq1hlhZp55VrrMZaFTBY08tzrUWN1rD387YAV1qR1agMcrYY
         SU37+LwWhzsW5ngjB+yc3Kz+nuDYShGVmOUXciJkrDBXNAhmDImV3UP3zo+9cVwWCkUw
         R21g==
X-Gm-Message-State: AOAM531ZvKvNCOvZTyknOelD04Z/OWcwTnMOCeL4Cqw/1uh5XtiJ6mw9
        PLmcc029jrrnXxgiRA3U5Go1fAv3tL7p+T7kbjs=
X-Google-Smtp-Source: ABdhPJwVOEIyaQjI4MXQ5Xe0/oNdshHtbZvqJV5v6rYd9A0WUvhzGw4rIa1yYreweKKm2yAIzl7WKxRs/bJRhOOzp1c=
X-Received: by 2002:a17:906:3ce9:: with SMTP id d9mr347758ejh.172.1617997425581;
 Fri, 09 Apr 2021 12:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
 <20210408183828.1907807-2-martin.blumenstingl@googlemail.com> <20210408224617.crnllsf7eedxr6cp@skbuf>
In-Reply-To: <20210408224617.crnllsf7eedxr6cp@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 9 Apr 2021 21:43:34 +0200
Message-ID: <CAFBinCAACrUO+89TnPs=5hhkV_73N5hxz=18u9o-NERUC_wpGg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] net: dsa: lantiq_gswip: Don't use PHY auto polling
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

On Fri, Apr 9, 2021 at 12:46 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Apr 08, 2021 at 08:38:27PM +0200, Martin Blumenstingl wrote:
> > PHY auto polling on the GSWIP hardware can be used so link changes
> > (speed, link up/down, etc.) can be detected automatically. Internally
> > GSWIP reads the PHY's registers for this functionality. Based on this
> > automatic detection GSWIP can also automatically re-configure it's port
> > settings. Unfortunately this auto polling (and configuration) mechanism
> > seems to cause various issues observed by different people on different
> > devices:
> > - FritzBox 7360v2: the two Gbit/s ports (connected to the two internal
> >   PHY11G instances) are working fine but the two Fast Ethernet ports
> >   (using an AR8030 RMII PHY) are completely dead (neither RX nor TX are
> >   received). It turns out that the AR8030 PHY sets the BMSR_ESTATEN bit
> >   as well as the ESTATUS_1000_TFULL and ESTATUS_1000_XFULL bits. This
> >   makes the PHY auto polling state machine (rightfully?) think that the
> >   established link speed (when the other side is Gbit/s capable) is
> >   1Gbit/s.
>
> Why do you say "rightfully"? The PHY is gigabit capable, and it reports
> that via the Extended Status register. This is one of the reasons why
> the "advertising" and "supported" link modes are separate concepts,
> because even though you support gigabit, you don't advertise it because
> you are in RMII mode.
according to the marketing materials of the AR8030 it is a "Ultra
low-power single RMII Fast Ethernet PHY"
based on that I am referring to this PHY as "not Gbit/s capable"
(other PHYs from the AR803x series are Gbit/s capable though)

> How does turning off the auto polling feature help circumvent the
> Atheros PHY reporting "issue"? Do we even know that is the problem, or
> is it simply a guess on your part based on something that looked strange?
I have a patch in my queue (which I'll send for the next -net-next
cycle) which adds "ethtool -d" (.get_regs) support to the GSWIP
driver.
There are multiple status registers, one of them indicates that the
link speed (as result of the auto polling mechanism) is 1Gbit/s

[...]
> > Switch to software based configuration instead of PHY auto polling (and
> > letting the GSWIP hardware configure the ports automatically) for the
> > following link parameters:
> > - link up/down
> > - link speed
> > - full/half duplex
> > - flow control (RX / TX pause)
>
> What does the auto polling feature consist of, exactly? Is there some
> sort of microcontroller accessing the MDIO bus simultaneously with
> Linux?
I believe the answer is yes, but there's no clear description in the
datasheet for a newer GSWIP revision [0]
"Figure 8" on page 41 (or page 39 if you go by the numbers at the
bottom of each page) has a description of the state machine logic.
If I understood Hauke correct the "not fiber" part is only checked for
newer GSWIP revisions

Please note that the datasheet from [0] refers to part number GSW140
which is a stand-alone IC.
The GSWIP driver (currently) supports an older revision (at least two
generations older) of GSWIP which is built into Lantiq xRX200 and
xRX300 SoCs.


Best regards,
Martin


[0] https://www.maxlinear.com/document/index?id=23266&languageid=1033&type=Datasheet&partnumber=GSW140&filename=617930_GSW140_DS_Rev1.7.pdf&part=GSW140
