Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB45712ADE1
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLZSRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 13:17:19 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36770 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfLZSRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 13:17:19 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so23341889edp.3;
        Thu, 26 Dec 2019 10:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/kVUvUUlIv+S4KgB8PAilg5eRolltdkQ40GkTlROLJs=;
        b=bdk9f8SUF43t/ZpP5zxB4uQXnDLufOuMHu/wIWWmDxL7aVjosImu7uDnGwroYAo9hR
         eJCnfI7jptFKeuPCfVOoo7DiYO5i6BKr4kO6hw5GyLhjfhklx2fPmTYgv6vRDCEfICc6
         N3X3vUhbgwMXiacZqdUHI4AqL0uF0koIJCoO4qJCciRnbmP6Jx5g3AXukI/Fw4JQ/wAv
         o4aL+uNzuC/mo44CJ2xatye3EAhKVbrD6a4UjOkCtB4+olUufm7vbM6mvjvPR9c991vv
         jaTnyHZiCSrclPaFEMixAatFZ8y0GsfV++VqW1GaPDsCrplp7O/+sv4lIfufoL5CcUB6
         HCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/kVUvUUlIv+S4KgB8PAilg5eRolltdkQ40GkTlROLJs=;
        b=bwfyVlAoOrRWq+cDkp9kZYWlhz9mL4OaCP9j7HNzb9K+hi6LLJ58fnVGDvzt6cpwGF
         fScYdWLLSSrpYYQpek9WYSfdcANZKwysH9h8HVQLaGgvnR0oH6fwPNaTr8Lhnxs1nh/d
         ZSGv/edPASV53Yx+uVVJxdbDNKF/8Adnhpu+KcMdNNkBwppL/D2WNkQwCbvfJBSklNmn
         HqVrgJBSsvgstEsYfcl03lhpmxLiH1R1WzIhAgPahCwL5HzYDABMTBn7OdGERvQs2qCY
         WHy0lAl/dBebWqzF45etgzePi1ZywNVHyeY0cJo3Qlw1qVh4/3lPmsnY7ZsZp1VwxUfU
         4jjg==
X-Gm-Message-State: APjAAAVudn+0q2f2JmMub2zjXdPAEAaHlco3PIiLKBtZlRMCouLAP7xb
        DJ1NjU759/AsRGvWxAyktHybTf4XS8hVL0i3rE4=
X-Google-Smtp-Source: APXvYqyIG6a7r9M4dZcMeoqoNvL9c1xsxC7MdJXKs8s6dyYvgPlDylAr5Jg+h9P+QsIDTu+cgoDJlTOe781mQBrq0i0=
X-Received: by 2002:a17:906:260b:: with SMTP id h11mr49327361ejc.327.1577384236409;
 Thu, 26 Dec 2019 10:17:16 -0800 (PST)
MIME-Version: 1.0
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
 <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
 <20191225150845.GA16671@lunn.ch> <CAFBinCA4X1e5_5nBiHmNiB40uJyr9Nm1b2VkF9NqM+wb7-1xmw@mail.gmail.com>
 <20191226105044.GC1480@lunn.ch> <CAFBinCB8YQ-tuGBixO_85NFXDdrH5keDURFgri5tFLdrAwUJKg@mail.gmail.com>
 <20191226120133.GI1480@lunn.ch>
In-Reply-To: <20191226120133.GI1480@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 26 Dec 2019 19:17:05 +0100
Message-ID: <CAFBinCC9KioCC8HzPOFm3x3ZjTiQm_gr-aemnziLnTN8Ets_+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on
 Meson8b/8m2 SoCs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com,
        linus.luessing@c0d3.blue, balbes-150@yandex.ru,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ingrassia@epigenesys.com, jbrunet@baylibre.com,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Dec 26, 2019 at 1:01 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > the MAC is not capable of generating an RX delay (at least as far as I know).
>
> So that immediately means rgmii is invalid as a phy-mode, since the
> documentation implies the MAC needs to add RX delay.
things turned out even more confusing thanks to your persistence (keep
reading, it will get better though) :-)

I have tested the following on my Odroid-C1 which has an RTL8211F PHY.
With patch #1 from this series I knew that the following was working:
- phy-mode = "rgmii" and 2ns TX delay on the MAC (RX delay is
seemingly not configured anywhere)
- phy-mode = "rgmii-txid" (again, the RX delay is seemingly not
configured anywhere)

with the patch to change the RX delay on the RTL8211F PHY I decided to
try out phy-mode = "rgmii-id": this broke Ethernet.
then I looked at the MAC registers and spotted that bits 13
(adj_enable) and 14 (adj_setup) are set (first time I'm noticing
this). unsetting them makes phy-mode = "rgmii-id" work!
I also confirmed the opposite case: unsetting bit 13 and 14 breaks
Ethernet with phy-mode = "rgmii-txid".

so it seems that there *is* a way to configure the RX delay on Meson8b
and Meson8m2 SoCs (at least).
I will spin up a RfC patch to discuss this with the Amlogic team and
because I don't know what these bits do exactly

> > it's mostly "broken" (high TX packet loss, slow TX speeds) for the two
> > supported boards with an RGMII PHY (meson8b-odroidc1.dts and
> > meson8m2-mxiii-plus.dts)
> > examples on the many ways it was broken will follow - feel free to
> > skip this part
>
> That is actually good. If it never worked, we don't need to worry
> about breaking it! We can spend our time getting this correct, and not
> have to worry about backwards compatibility, etc.
ACK

> > > What we normally say is make the MAC add no delays, and pass the
> > > correct configuration to the PHY so it adds the delay. But due to the
> > > strapping pin on the rtl8211f, we are in a bit of a grey area. I would
> > > suggest the MAC adds no delay, phy-mode is set to rmgii-id, the PHY
> > > driver adds TX delay in software, we assume the strapping pin is set
> > > to add RX delay, and we add a big fat comment in the DT.
> > >
> > > For the Micrel PHY, we do the same, plus add the vendor properties to
> > > configure the clock skew.
> > >
> > > But as i said, we are in a bit of a grey area. We can consider other
> > > options, but everything needs to be self consistent, between what the
> > > MAC is doing, what the PHY is doing, and what phy-mode is set to in
> > > DT.
>
> > do you think it's worth the effort to get clarification from Realtek
> > on the RX delay behavior (and whether there's a register to control
> > it)?
>
> You can ask. There are also datasheet here:
>
> http://files.pine64.org/doc/datasheet/rock64/RTL8211F-CG-Realtek.pdf
> https://datasheet.lcsc.com/szlcsc/1909021205_Realtek-Semicon-RTL8211F-CG_C187932.pdf
>
> It looks like both RX and TX delay can be controlled via
> strapping. But the register for controlling the TX delay is not
> documented.
I checked the mails I got from Realtek I while ago and they even
included the RX delay bits!
I even sent a patch two years ago but I must have dropped it at some
point (maybe I assumed that it wasn't relevant anymore - I don't
remember): [0]

> > you mentioned that there was breakage earlier this year, so I'm not sure anymore
> > (that leaves me thinking: asking them is still useful to get out of
> > this grey area)
>
> It was an Atheros PHY with breakage.
>
> If we can fully control the RX and TX delays, that would be great. It
> would also be useful if there was a way to determine how the PHY has
> been strapped. If we cannot fully control the delays but we can find
> out what delays it is using, we can check the requested configuration
> against the strapped configuration, and warn if they are different.
I am currently testing whether the pin strapping configuration can be
read back by the RX and TX delay registers
my Odroid-C1 has both strapped to GND which means off
but my Khadas VIM2 has TX delay strapped to ETH_VDDIO which means on
(RX delay is still strapped to GND)
once I am done testing I will send patches for the RTL8211F PHY driver


Martin


[0] https://patchwork.ozlabs.org/patch/843946/
