Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670792F82A0
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbhAORhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbhAORhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:37:34 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035D7C061757;
        Fri, 15 Jan 2021 09:36:53 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id w5so10074077wrm.11;
        Fri, 15 Jan 2021 09:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9/oL1RPdRUYNlfnCCkWKJ/0OLcrfNwJFWYby4oAY4/o=;
        b=nKjLbMKpq9DL/ayDeE6sFcxF9HKVvYQCkq4C1vrh85qVD/uM8u6LmNfREHTSIELw5B
         TLuw4RVjBEexIhTvcnNuM5kweIt9gJk2CipAchKhbxALk5jVCRQVA2Z4+u657t0Tk+0d
         1mTilisMV9fhlJUtqmlf8TlWIItyksFowB374PZCVGP4IO6BZOKqw2xDAue6DRTWL4dq
         N/Uqq51xwbRHoA1lmpq+tXszByv3SjYoUHsZmKbNbROelRaU0xdvm5c4SVXkywef4va1
         eebzPXsDOGO8ZP68IeDOXXEzVyL5q4FB3UViTJGol5dQTtrCuYGzAxjjVN5bkNu3iJQ1
         A1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9/oL1RPdRUYNlfnCCkWKJ/0OLcrfNwJFWYby4oAY4/o=;
        b=bncBYfeMxwnt0a+oDHAS2UsIs/k1bAiVG3vkHdT5q0lXBJ6ns22Q/sM/VeRjKaWQ9I
         rDNdpkfqScfd33KLqu+72ENQSGdnx2BSgghRj05ZGbuad5JSRIPwNBrEChVbj0sJpXlL
         LWVcjZG91/676N3CRdRrENDUq56+PdBV5gaZR0IMbpsnFF1WThlXqktp541LuZj6tCrH
         R4a048fMDilxWCDlhwGGNR5ud/8iLyeOxB8RvX0Fh1Y6ILN998yy8jFZzNeQ0JB9IEN8
         HB6E9WZypr23+A+gM5mQhyFsztgxWmmP6t/O5PXL42hR5bNnKK5okK3yFMAuCraqEqpG
         mp2g==
X-Gm-Message-State: AOAM531QX8eZ5MGk8B9odOUL79TshLlcmkRfKzV4GH2oluzqL6KbkNVx
        yn6J3/AEeU0C1cFiXTKtnbo=
X-Google-Smtp-Source: ABdhPJwO6Rk21uGS+uz0VFIcv29xRQjxnLskFlB7ZDiGsjABd89neQAIj/yXhg+sKWXjwwQAIfdbSw==
X-Received: by 2002:adf:c5d3:: with SMTP id v19mr14198441wrg.365.1610732212648;
        Fri, 15 Jan 2021 09:36:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:fca3:feb5:3aa8:7dc5? (p200300ea8f065500fca3feb53aa87dc5.dip0.t-ipconnect.de. [2003:ea:8f06:5500:fca3:feb5:3aa8:7dc5])
        by smtp.googlemail.com with ESMTPSA id d2sm15218088wre.39.2021.01.15.09.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 09:36:52 -0800 (PST)
To:     "Badel, Laurent" <LaurentBadel@eaton.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
References: <MW4PR17MB4243A17EE8C434AE3DCAEAF4DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Subject: [PATCH v3 net-next 0/4] net:phy: Fix LAN87xx external
 reset
Message-ID: <a54ae202-fed9-1fff-5e71-b7a93f09c411@gmail.com>
Date:   Fri, 15 Jan 2021 18:36:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <MW4PR17MB4243A17EE8C434AE3DCAEAF4DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.01.2021 18:19, Badel, Laurent wrote:
> ﻿Description: 
> External PHY reset from the FEC driver was introduced in commit [1] to 
> mitigate an issue with iMX SoCs and LAN87xx PHYs. The issue occurs 
> because the FEC driver turns off the reference clock for power saving 
> reasons [2], which doesn't work out well with LAN87xx PHYs which require 
> a running REF_CLK during the power-up sequence. As a result, the PHYs 
> occasionnally (and unpredictably) fail to establish a stable link and
> require a hardware reset to work reliably.
> 
> As previously noted [3] the solution in [1] integrates poorly with the
> PHY abstraction layer, and it also performs many unnecessary resets. This
> patch series suggests a simpler solution to this problem, namely to hold
> the PHY in reset during the time between the PHY driver probe and the first
> opening of the FEC driver.
> 
> To illustrate why this is sufficient, below is a representation of the PHY
> RST and REF_CLK status at relevant time points (note that RST signal is
> active-low for LAN8710/20):
> 
>  1. During system boot when the PHY is probed:
>  RST    111111111111111111111000001111111111111
>  CLK    000011111111111111111111111111111000000
>  REF_CLK is enabled during fec_probe(), and there is a short reset pulse
>  due to mdiobus_register_gpiod() which calls gpiod_get_optional() with
>  the GPIOD_OUT_LOW which sets the initial value to 0. The reset is
>  de-asserted by phy_device_register() shortly after.  After that, the PHY
>  runs without clock until the FEC is opened, which causes issues.
> 
>  2. At first opening of the FEC:
>  RST    111111111111111111111111111100000111111
>  CLK    000000000011111111111111111111111111111
>  After REF_CLK is enabled, phy_reset_after_clk_enable() causes a
>  short reset pulse. Reset is needed here because the PHY was running 
>  without clock before. 
>    
>  3. At closing of the FEC driver:
>  RST    111110000000000000000000000000000000000                 
>  CLK    111111111111000000000000000000000000000
>  FEC first disconnects the PHY, which asserts the reset, and then 
>  disables the clock.
>    
>  4. At subsequent openings of the FEC:
>  RST    000000000000000011111111111110000011111                  
>  CLK    000000000011111111111111111111111111111
>  FEC first enables the clock, then connects to the PHY which releases 
>  the reset. Here the second reset pulse (phy_reset_after_clk_enable()) 
>  is unnecessary, because REF_CLK is already running when the reset is 
>  first deasserted. 
>   
> This illustrates that the only place where the extra reset pulse is 
> actually needed, is at the first opening of the FEC driver, and the reason
> it is needed in the first place, is because the PHY has been running 
> without clock after it was probed. 
> 
> Extensive testing with LAN8720 confirmed that the REF_CLK can be disabled
> without problems as long as the PHY is either in reset or in power-down 
> mode (which is relevant for suspend-to-ram as well). Therefore, instead 
> of relying on extra calls to phy_reset_after_clk_enable(), the issue 
> addressed by commit [1] can be simply fixed by keeping the PHY in reset 
> when exiting from phy_probe(). In this way the PHY will always be in reset
> or power-down whenever the REF_CLK is turned off.
> 
> This should not cause issues, since as per the PAL documentation any 
> driver that has business with the PHY should at least call phy_attach(), 
> which will deassert the reset in due time. Therefore this fix probably 
> works equally well for any PHY, but out of caution the patch uses the 
> existing PHY_RST_AFTER_CLK_EN driver flag (which it renames), to implement
> the fix only for LAN8710/20/40 PHYs.
> 
> Previous versions:
> This is the 3rd version of the series;  below is a short description of
> the previous versions.
> 
> v1: 
> The solution in [1] has the unfortunate side-effect of breaking the PHY 
> interrupt system due to the hardware reset erasing the interrupt mask of
> the PHY. Patch series v1 suggested performing the extra reset before the 
> PHY is configured, by moving the call to phy_reset_after_clk_enable() from
> the FEC into phy_init_hw() instead. The patch was re-examinated after 
> finding an issue during resume from suspend, where the PHY also seemed to
> require a hardware reset to work properly. 
> Further investigation showed that this is in fact due to another
> peculiarity of the LAN87xx, which also erase their interrupt mask upon 
> software reset (which is done by phy_init_hw() on resuming from 
> suspend-to-ram), and is thus a separate issue that will be addressed in 
> a separate patch. 
> 
> v2:
> During this time the kernel had moved on and 2 new commits rendered the v1
> fix unnecessary: 
>   [3] allows the extra PHY reset to still be performed from the FEC, but 
>   before the interrupt mask is configured, thereby fixing the above 
>   interrupt mask issue.
>   [4] allows LAN87xx to take control of the REF_CLK directly, preventing
>   the FEC from disabling it and thus circumventing the entire REF_CLK 
>   issue.
> Patch v2 proposed to fix 2 potential issues with the solution from [4], 
> namely that (i) failing to set the PHY "clocks" DT property would silently 
> break the system (because FEC succeeds in disabling the REF_CLK, yet the 
> extra reset has been removed), and (ii) keeping the REF_CLK enabled
> defeated the power-saving purpose of commit [2].
> 
> The present patch fixes (i), and leaves it up to the user to use the 
> power-friendly clock management of [2] (leave the DT clocks property 
> unset), or keep the REF_CLK always enabled (set the clocks property). 
> It also simplifies the code by removing all calls to 
> phy_reset_after_clk_enable() and related code, and the function
> phy_reset_after_clk_enable() altogether.  
> 
> Tests: against net-next (5.11-rc3) with LAN8720 and LAN8742 and iMX283 
> SoC. Unfortunately unable to test LAN8740 which has a different form 
> factor.
> 
> References:
> [1] commit 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable()
>     support")
> [2] commit e8fcfcd5684a ("net: fec: optimize the clock management to save
>     power")
> [3] commit 64a632da538a ("net: fec: Fix phy_device lookup for 
>     phy_reset_after_clk_enable()")
> [4] commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
>     support")
> 
> Laurent Badel (4):
>   Remove PHY reset in fec_main.c
>   Remove phy_reset_after_clk_enable()
>   Rename PHY_RST_AFTER_CLK_EN to PHY_RST_AFTER_PROBE
>   Add PHY reset after probe for PHYs with PHY_RST_AFTER_PROBE flag 
> 
>  drivers/net/ethernet/freescale/fec_main.c | 40 -----------------------
>  drivers/net/phy/phy_device.c              | 26 +--------------
>  drivers/net/phy/smsc.c                    |  4 +--
>  include/linux/phy.h                       |  3 +-
>  4 files changed, 4 insertions(+), 69 deletions(-)
> 

W/o knowing the exact issue in detail: For the sake of bisectability,
shouldn't patches 4 and a modified patch 3 be first? After patches 1 and 2
we may be in trouble, right?

And it seems you composed the mails manually:
- subject is prefixed with "Subject:"
- patch subjects in the cover letter don't match the ones of the
  respective patches

For the patch prefixes: Please add a space between net: and phy:
