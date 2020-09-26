Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FA12797FB
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 10:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgIZIad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 04:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIZIad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 04:30:33 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC8DC0613CE;
        Sat, 26 Sep 2020 01:30:32 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z23so1673424ejr.13;
        Sat, 26 Sep 2020 01:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=geRPT82jJQC5Dnh8QLGuxC3SCHWc2B1rPydy51X3y1Y=;
        b=vJgVOXcnyREOuagh28h8Q0hP3/36E2V95YTMGWyefkvTqTzDsU/nh6s/sw4djktg3j
         HbkKAVtMTuwM5NugaibhxmZgkmRRJWoRqqLTZ/5ntZQHR6uy3YUb4P/uysiZCAaSvbA/
         msjSbkjTd12PbiMT3mhH2UCLjfm7tQehqgwXLMpNLY2P+CvIspAi96cQ8qLYROGdyk3D
         N7KWsJRDacxkzT98nQyZ9cwRf+IDqnS/+I6iT26Knfn4TbMHXiVzVdEe6z5JI0v7ap5M
         bOdUV8ACbNvb3vg+pMNphJUzHaYRHQ5TLQC8JBDgGhRqav5Wb7RAhSqjkDGlmrodmtFe
         uPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=geRPT82jJQC5Dnh8QLGuxC3SCHWc2B1rPydy51X3y1Y=;
        b=UsVh840ElH0ZlI3IYzSsTodywaA9c+Bo3HaNyZ83093+eocvyuJ5c/lICh3ov9NyKz
         OA7SG89grBhC2fx8WpJhHZ3UDTftqr/illWmbOROPTFPZSSDIB9Ef5gaHfOOrVPp0Q8F
         2lcJXUNdR1fcsF3Kb4BMqh0IqqTcOmkr6fB1wGCJIJT8U2ZNw3hTCH+pFWuIRAm1onQB
         ZG/fiYLVLTSjoJimoe6y7sBKGhfqFsnokgpSmkQxdD1EzcK1z3rICs4XlUNWfUTSynXp
         dlYpKAH2bNGiBe79Qe/F15qy8glMXWa0pHkUOZ8WP4gt6tcNPm4+suJFiB0pXrBch1N8
         Qo4Q==
X-Gm-Message-State: AOAM5301FTkQpQBUzOgHY14JEJQHRik4DtyZzyfeBW9/NZaGAoUFWfUI
        1yR89mo+CJXmWWIJTfnpPGbMYE6viQ0Da4Yv+XM=
X-Google-Smtp-Source: ABdhPJx0csOOAv2vhhfuNQzBodoKVpINTDv/Y6G8FMXBH5RtOuMbitW1hL9frNPcQ2pHadXidMm67gt6b4kDUQ954Cg=
X-Received: by 2002:a17:906:3791:: with SMTP id n17mr6423102ejc.216.1601109031457;
 Sat, 26 Sep 2020 01:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
 <20200925221403.GE3856392@lunn.ch> <CAFBinCC4VuLJDLqQb+m+h+qnh6fAK2aBLVtQaE15Tc-zQq=KSg@mail.gmail.com>
 <20200926004129.GC3850848@lunn.ch>
In-Reply-To: <20200926004129.GC3850848@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Sep 2020 10:30:20 +0200
Message-ID: <CAFBinCAc2-QV3E8P4gk+7Lq0ushH08UoZ0tQ8ACEoda-D8oaWg@mail.gmail.com>
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        alexandre.torgue@st.com, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, joabreu@synopsys.com, kuba@kernel.org,
        peppe.cavallaro@st.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Sep 26, 2020 at 2:41 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > The reference code I linked tries to detect the RGMII interface mode.
> > However, for each board we know the phy-mode as well as the RX and TX
> > delay - so I'm not trying to port the RGMII interface detection part
> > to the mainline driver.
> >
> > on X96 Air (which I'm using for testing) Amlogic configures phy-mode
> > "rgmii" with a 2ns TX delay provided by the MAC and 0ns RX delay
> > anywhere (so I'm assuming that the board adds the 2ns RX delay)
>
> Hi Martin
>
> It would be unusual to have an asymmetric design in the PCB. So i
> would try to prove that assumption. It could be the PHY driver is
> broken, and although it is configured to use RGMII, it is actually
> inserting a delay on RX. Also check if the PHY has any strapping.
I checked this again for the vendor u-boot (where Ethernet is NOT
working) as well as the Android kernel which this board was shipped
with (where Ethernet is working)
- in u-boot the MAC side adds a 2ns TX delay and the PHY side adds a
2ns RX delay
- in Linux the MAC side adds a 2ns TX delay and the RX delay is turned
off (for both, MAC and PHY)

> > I am aware that the recommendation is to let the PHY generate the delay.
> > For now I'm trying to get the same configuration working which is used
> > by Amlogic's vendor kernel and u-boot.
> >
> > > Is there any documentation as to what the calibration values mean?  I
> > > would just hard code it to whatever means 0uS delay, and be done. The
> > > only time the MAC needs to add delays is when the PHY is not capable
> > > of doing it, and generally, they all are.
>
> > This calibration is not the RGMII RX or TX delay - we have other
> > registers for that and already know how to program these.
>
> O.K. so maybe this is just fine tuning. Some PHYs also allow this.
>
> > What I can say is that u-boot programs calibration value 0xf (the
> > maximum value) on my X96 Air board. With this I cannot get Ethernet
> > working - regardless of how I change the RX or TX delays.
> > If I leave everything as-is (2ns TX delay generated by the MAC, 0ns RX
> > delay, ...) and change the calibration value to 0x0 or 0x3 (the latter
> > is set by the vendor kernel) then Ethernet starts working.
>
> So there is just one calibration value? So it assumes the calibration
> is symmetric for both RX and TX.
yes, there's only one calibration value
the reference code is calculating the calibration setting for four
configuration variants:
- 2ns TX delay on the MAC side, no RX or TX delay on the PHY side,
RGMII RX_CLK not inverted
- 2ns TX delay on the MAC side, no RX or TX delay on the PHY side,
RGMII RX_CLK inverted
- 2ns TX delay on the MAC side, 2ns RX delay on the PHY side, RGMII
RX_CLK not inverted
- 2ns TX delay on the MAC side, 2ns RX delay on the PHY side, RGMII
RX_CLK inverted

now that I'm writing this, could it be a calibration of the RX_CLK
signal? The TX delay is fixed in all cases but the RX delay and RX_CLK
signal inversion are variable.

> What PHY is it using?
>
> https://dpaste.com/2WJF9EN suggests it is a RTL8211F.
indeed, it's a RTL8211F

> This device does have stripping to set the default delay. Can you
> check if there are pull ups on pins 24 and 25?
I checked it in software (see above)
to let you sanity-check this:
in vendor u-boot I read: reg 0x11=0x9 and reg 0x15=0x19
in the Android kernel shipped with the board I have: reg 0x11=0x9 and
reg 0x15=0x11

note: I haven't found a way to "fix" Ethernet in u-boot so far. I
cannot get the exact u-boot copy that's used on my board (since
there's no vendor to contact).
so I'm careful with interpreting what I'm seeing in u-boot

if you really want me to I can check the pull-ups but I prefer not to
since I managed to short and break tiny solder joints in the past -
and I only have one of these boards for testing

> What i find interesting is in the driver is:
>
>         ret = phy_modify_paged_changed(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY,
>                                        val_txdly);
>
>         ret = phy_modify_paged_changed(phydev, 0xd08, 0x15, RTL8211F_RX_DELAY,
>                                        val_rxdly);
>
> Different registers, 0x11 vs 0x15. In the datasheets i found with
> google, none describe any of these bits, but at least register 0x15 is
> mentioned, where as register 0x11 is not.
>
> Git blame shows you added this! Are you sure about this? It seems odd
> they are in different registers.
I asked Realtek about it back then and they were kind enough to reply
- so I got this information from Realtek
double-checking with my old mails (I have to type what's shown in the
screenshot as I'm allowed to share the info but not the screenshot
that I received):
Function Name: Manually Enable TXDLY
Function Description: Enable TXDLY by registers (default by hardware
pin configuration)
RTL8211F series: Page: 0xd08, Reg 17, bit[8] = 1

Function Name: Manually Enable RXDLY
Function Description: Enable RXDLY by registers (default by hardware
pin configuration)
RTL8211F series: Page: 0xd08, Reg 21, bit[3] = 1

In the meantime Amlogic's "hacked" PHY driver is also using these registers: [0]
So I assume that I'm doing the right thing in the Realtek PHY driver


Best regards,
Martin


[0] https://github.com/khadas/linux/blob/d140398907da5a3f4f7dba2acd336e2ef469bac2/drivers/net/phy/realtek.c#L174
