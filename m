Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29636B4005
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCJNPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCJNPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:15:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FDFE8249;
        Fri, 10 Mar 2023 05:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678454139; x=1709990139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=MXlYr8rjYEegZkGLvQYaWqWds8Z6SCbvAthRB+OeA2s=;
  b=PsCCb2g8WNqrd2yJercjAkDwfs9PDS032WWeQMFZNuEEdWc49Yv9N/yh
   Li+NvKxemI+XL4uwsefxXq+v909QdtwQ2zMjOJCjkRX94TauGrcmvtC9R
   ToFuJ9l5AX4qEKI9UiLvBrMtpY3kBZHP4PaZJa0AnHXzGpHnHgQFjAfAP
   gBwCKtpWE4AjW5xHTf34tBz+bl3k30D3VZAVBmJCHxQsZHwd6C//SMv+q
   CDQnLcfO+B+eyXN4hRftmLNVAO1+YyhdOznc3q3PJdWK6rW0Y+hKo5hE/
   9l85qwABLwXk/m2IFWKSZPRKxJDev7CIVqp7GdhrCuzeP8wJqRXepjMHU
   w==;
X-IronPort-AV: E=Sophos;i="5.98,249,1673938800"; 
   d="scan'208";a="141383947"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2023 06:15:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Mar 2023 06:15:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 10 Mar 2023 06:15:29 -0700
Date:   Fri, 10 Mar 2023 14:15:29 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <thomas.petazzoni@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Jay Vosburgh" <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        "Jie Wang" <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "Sean Anderson" <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/10/2023 13:15, Michael Walle wrote:
> 
> [+ Horatiu]
> 
> Am 2023-03-10 12:35, schrieb Vladimir Oltean:
> > On Fri, Mar 10, 2023 at 11:48:52AM +0100, Köry Maincent wrote:
> > > > From previous discussions, I believe that a device tree property was
> > > > added in order to prevent perceived performance regressions when
> > > > timestamping support is added to a PHY driver, correct?
> > > 
> > > Yes, i.e. to select the default and better timestamp on a board.
> > 
> > Is there a way to unambiguously determine the "better" timestamping on
> > a board?
> > 
> > Is it plausible that over time, when PTP timestamping matures and,
> > for example, MDIO devices get support for PTP_SYS_OFFSET_EXTENDED
> > (an attempt was here: https://lkml.org/lkml/2019/8/16/638), the
> > relationship between PTP clock qualities changes, and so does the
> > preference change?
> > 
> > > > I have a dumb question: if updating the device trees is needed in order
> > > > to prevent these behavior changes, then how is the regression problem
> > > > addressed for those device trees which don't contain this new property
> > > > (all device trees)?
> > > 
> > > On that case there is not really solution,
> > 
> > If it's not really a solution, then doesn't this fail at its primary
> > purpose of preventing regressions?
> > 
> > > but be aware that CONFIG_PHY_TIMESTAMPING need to be activated to
> > > allow timestamping on the PHY. Currently in mainline only few (3)
> > > defconfig have it enabled so it is really not spread,
> > 
> > Do distribution kernels use the defconfigs from the kernel, or do they
> > just enable as many options that sound good as possible?
> > 
> > > maybe I could add more documentation to prevent further regression
> > > issue when adding support of timestamp to a PHY driver.
> > 
> > My opinion is that either the problem was not correctly identified,
> > or the proposed solution does not address that problem.
> > 
> > What I believe is the problem is that adding support for PHY
> > timestamping
> > to a PHY driver will cause a behavior change for existing systems which
> > are deployed with that PHY.
> > 
> > If I had a multi-port NIC where all ports share the same PHC, I would
> > want to create a boundary clock with it. I can do that just fine when
> > using MAC timestamping. But assume someone adds support for PHY
> > timestamping and the kernel switches to using PHY timestamps by
> > default.
> > Now I need to keep in sync the PHCs of the PHYs, something which was
> > implicit before (all ports shared the same PHC). I have done nothing
> > incorrectly, yet my deployment doesn't work anymore. This is just an
> > example. It doesn't sound like a good idea in general for new features
> > to cause a behavior change by default.
> > 
> > Having identified that as the problem, I guess the solution should be
> > to stop doing that (and even though a PHY driver supports timestamping,
> > keep using the MAC timestamping by default).
> > 
> > There is a slight inconvenience caused by the fact that there are
> > already PHY drivers using PHY timestamping, and those may have been
> > introduced into deployments with PHY timestamping. We cannot change the
> > default behavior for those either. There are 5 such PHY drivers today
> > (I've grepped for mii_timestamper in drivers/net/phy).
> > 
> > I would suggest that the kernel implements a short whitelist of 5
> > entries containing PHY driver names, which are compared against
> > netdev->phydev->drv->name (with the appropriate NULL pointer checks).
> > Matches will default to PHY timestamping. Otherwise, the new default
> > will be to keep the behavior as if PHY timestamping doesn't exist
> > (MAC still provides the timestamps), and the user needs to select the
> > PHY as the timestamping source explicitly.
> > 
> > Thoughts?
> 
> While I agree in principle (I have suggested to make MAC timestamping
> the default before), I see a problem with the recent LAN8814 PHY
> timestamping support, which will likely be released with 6.3. That
> would now switch the timestamping to PHY timestamping for our board
> (arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt-8g.dts). I could
> argue that is a regression for our board iff NETWORK_PHY_TIMESTAMPING
> is enabled. Honestly, I don't know how to proceed here and haven't
> tried to replicate the regression due to limited time. Assuming,
> that I can show it is a regression, what would be the solution then,
> reverting the commit? Horatiu, any ideas?

I don't think reverting the commit is the best approach. Because this
will block adding any timestamp support to any of the existing PHYs.
Maybe a better solution is to enable or disable NETWORK_PHY_TIMESTAMPING
depending where you want to do the timestamp.

> 
> I digress from the original problem a bit. But if there would be such
> a whitelist, I'd propose that it won't contain the lan8814 driver.

I don't have anything against having a whitelist the PHY driver names.

> 
> Other than that, I guess I have to put some time into testing
> before it's too late.

I was thinking about another scenario (I am sorry if this was already
discussed).
Currently when setting up to do the timestamp, the MAC will check if the
PHY has timestamping support if that is the case the PHY will do the
timestamping. So in case the switch was supposed to be a TC then we had
to make sure that the HW was setting up some rules not to forward PTP
frames by HW but to copy these frames to CPU.
With this new implementation, this would not be possible anymore as the
MAC will not be notified when doing the timestamping in the PHY.
Does it mean that now the switch should allocate these rules at start
time?

> 
> -michael

-- 
/Horatiu
