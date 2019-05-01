Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9110FB0
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 01:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfEAXDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 19:03:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35312 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfEAXDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 19:03:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id f7so581318wrs.2;
        Wed, 01 May 2019 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9dwIam3UIpcq7Xll5Xc0hLS4by0pOvzP1sRyP0/58rI=;
        b=pkLdASeUDAmknYB3Kxj2XChtbSOk7YvC+ym+Adfae/F1s4GyQzjLAcCBRbc8ENHwPe
         xQr/hvTsUrssIY2EozTWEOQCjZEz+BamJvgs0V3VfV+rP76+E5HYm7i4ZAH7JaVEAPA+
         ZeK1MjzNhIB1zVIN0WJ9AJdUXbwMkY6SU5f/UMjn6zaSuntjVELPgzofGg34gKlRx7D7
         eSwWirk9ShUgt8pUyhtxigNHlw9Soo0C4VcJXAPSbesg0UTbtG18o4knOmTX8o6k5YT1
         2FgNBmbVstfyO2vXy2j1VEn4Xi7AD6n2aoLQZnV5K4T1VHJelDx56KBsx+wN4Md6Ek+a
         QOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9dwIam3UIpcq7Xll5Xc0hLS4by0pOvzP1sRyP0/58rI=;
        b=BJJFdGgleFZX/Fscm54JAXK4bQ+XKE7dAcGj15GFuFSg/jrir0DulK8D+T0ws1vAZ4
         1aFUU8nOxz6sv9PuH605MDWe8q0+PEEeU48LwJpbbC9R7SfhXGgSa0qFBDxBGPFzeiWu
         kcvigvHtQeNVZGbG0TYD5LEnT7NluM6fr6OUpP2Z5rupABdxcz5mr+nGXaStOGCb0Qg0
         l7dHyLFcAJ7GEgN4lR7kJ0XR+GNIvJ5YwzqN7DTHfzofFhukiBTYmX/byQKEucG3+OwG
         eHIJOmDDkUo9tG/qsrmhH6F+zrgg+J00aIvxbXlipKpgUnQ9YSJ/TLmXWcwkcyKeX3lv
         PH/g==
X-Gm-Message-State: APjAAAX6qur2YJtOodoieblt7hOPMjxYglQVEDm9I3tmL4cOVfEZ7uIE
        nZ1LwmWtPI70QBT0Jvx7jDTobcCNxLZZWsEBtcg=
X-Google-Smtp-Source: APXvYqxtUeux1nJc2m6hnvZUzCnT9ES2c+qfw6SZO0tQjD1yhuvvaE3dtWzGF9ppq5YnpzPycuOPtCv3nL18iWRl0eM=
X-Received: by 2002:adf:e811:: with SMTP id o17mr368176wrm.30.1556751823159;
 Wed, 01 May 2019 16:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation> <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
In-Reply-To: <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 2 May 2019 02:03:31 +0300
Message-ID: <CA+h21hq_4rMXaOgr4ZQjiwwvpKSZmRoTg__PZisWZCz3pzCPOA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 May 2019 at 00:16, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
>  Hello Serge,
>
> On Mon, Apr 29, 2019 at 11:12 PM Serge Semin <fancer.lancer@gmail.com> wrote:
> [...]
> > > > > Apparently the current config_init method doesn't support RXID setting.
> > > > > The patch introduced current function code was submitted by
> > > > > Martin Blumenstingl in 2016:
> > > > > https://patchwork.kernel.org/patch/9447581/
> > > > > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > > > > the RGMII_ID as supported while only TX-delay could be set.
> > > > > I also failed to find anything regarding programmatic rtl8211f delays setting
> > > > > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> let me give you a bit of context on that patch:
> most boards (SBCs and TV boxes) with an Amlogic SoC and a Gigabit
> Ethernet PHY use a Realtek RTL8211F PHY. we were seeing high packet
> loss when transmitting from the board to another device.
> it took us very long to understand that a combination of different
> hardware and driver pieces lead to this issue:
> - in the MAC driver we enabled a 2ns TX delay by default, like Amlogic
> does it in their vendor (BSP) kernel
> - we used the upstream Realtek RTL8211F PHY driver which only enabled
> the TX delay if requested (it never disabled the TX delay)
> - hardware defaults or pin strapping of the Realtek RTL8211F PHY
> enabled the TX delay in the PHY
>
> This means that the TX delay was applied twice: once at the MAC and
> once at the PHY.
> That lead to high packet loss when transmitting data.
> To solve that I wrote the patch you mentioned, which has since been
> ported over to u-boot (for a non-Amlogic related board)
>
> > > > > Anyway lets clarify the situation before to proceed further. You are suggesting
> > > > > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > > > > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > > > > support either of them.
> I don't have any datasheet for the Realtek RTL8211F PHY and I'm not in
> the position to get one (company contracts seem to be required for
> this).
> Linux is not my main job, I do driver development in my spare time.
>
> there may or may not be a register or pin strapping to configure the RX delay.
> due to this I decided to leave the RX delay behavior "not defined"
> instead of rejecting RGMII_RXID and RGMII_ID.
>
> > > > That is how I read Andrew's suggestion and it is reasonable. WRT to the
> > > > original changes from Martin, he is probably the one you would want to
> > > > add to this conversation in case there are any RX delay control knobs
> > > > available, I certainly don't have the datasheet, and Martin's change
> > > > looks and looked reasonable, seemingly independent of the direction of
> > > > this very conversation we are having.
> the changes in patch 1 are looking good to me (except that I would use
> phy_modify_paged instead of open-coding it, functionally it's
> identical with what you have already)
>
> I'm not sure about patch 2:
> personally I would wait for someone to come up with the requirement to
> use RGMII_RXID with a RTL8211F PHY.
> that person will then a board to test the changes and (hopefully) a
> datasheet to explain the RX delay situation with that PHY.
> that way we only change the RGMII_RXID behavior once (when someone
> requests support for it) instead of twice (now with your change, later
> on when someone needs RGMII_RXID support in the RTL8211F driver)
>
> that said, the change in patch 2 itself looks fine on Amlogic boards
> (because all upstream .dts let the MAC generate the TX delay). I
> haven't runtime-tested your patch there yet.
> but there seem to be other boards (than the Amlogic ones, the RTL8211F
> PHY driver discussion in u-boot was not related to an Amlogic board)
> out there with a RTL8211F PHY (these may or may not be supported in
> mainline Linux or u-boot and may or may not use RGMII_RXID where you
> are now changing the behavior). that's not a problem by itself, but
> you should be aware of this.
>
> [...]
> > rtl8211(e|f) TX/RX delays can be configured either by external pins
> > strapping or via software registers. This is one of the clue to provide
> > a proper config_init method code. But not all rtl8211f phys provide
> > that software register, and if they do it only concerns TX-delay (as we
> > aware of). So we need to take this into account when creating the updated
> > versions of these functions.
> >
> > (Martin, I also Cc'ed you in this discussion, so if you have anything to
> > say in this matter, please don't hesitate to comment.)
> Amlogic boards, such as the Hardkernel Odroid-C1 and Odroid-C2 as well
> as the Khadas VIM2 use a "RTL8211F" RGMII PHY. I don't know whether
> there are multiple versions of this PHY. all RTL8211F I have seen so
> far did behave exactly the same.
>
> I also don't know whether the RX delay is configurable (by pin
> strapping or some register) on RTL8211F PHYs because I don't have
> access to the datasheet.
>
>
> Martin

Hi Martin, Sergey,

I had another look and it seems that Realtek has designated the same
PHY ID for the RTL8211F and RTL8211FS. However the F is a 40-pin
package and the FS is a 48-pin package. The datasheet for the F
doesn't mention about the MDIO bit for TXDLY being implemented,
whereas for FS it does. That can mean anything, really, but as I only
have access to a board with the FS chip, I can't easily check. Maybe
Martin can confirm that his chip's designation is really not FS.
But my point still remains, though. The F and FS share the same PHY
ID, and one supports only RGMII while the other can be configured for
SGMII as well. Good luck being ultra-correct in the phy-mode checking
when you can't distinguish the chip. But in general DT description is
chief and should not be contradicted. Perhaps an argument could be
made for the RGMII delays as they constitute an exception to the "HW
description" rule.

Thanks,
-Vladimir
