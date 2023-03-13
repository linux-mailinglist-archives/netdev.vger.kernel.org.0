Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED446B70EC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 09:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCMIRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 04:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCMIRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 04:17:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A6D2CC53;
        Mon, 13 Mar 2023 01:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678695423; x=1710231423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5JrPFVlcWQFwap3ILpm16k6q7pBO4Fn/SgtyEDcEoGU=;
  b=up3gFiw+XeKOPFI2M7wG7DDT2ygITHsj2NbhiW66u1sVMjrSWL3pDQj1
   DNRybkQxOwvQHJE9wF4Y2u20xfVpRqmV4VKeQAuaxhWPIeu3SEopunivF
   z3neOodlZGo79tlq71x8lSGpcR4SYseAFPXCvShWuzHOvzk9ki0oETt4t
   ReHi1DhfiLjw/LNTzp7G3XiOdLQSpk1QITO5S9K+13mojBBVTZFp+SSLs
   3Fn+9a5XS8MrioBgVITfRxENWwQF8HHGq1yi9wBmtU6xzDDkXaK5R20aH
   lmO0JRzVF3mhZqcCgoTVqRgB/FxcNCEzCUDw34edZ67HX9BUrDo6dk6YY
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,256,1673938800"; 
   d="scan'208";a="201308119"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Mar 2023 01:17:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 01:17:01 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 13 Mar 2023 01:17:00 -0700
Date:   Mon, 13 Mar 2023 09:17:00 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Michael Walle <michael@walle.cc>,
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
Message-ID: <20230313081700.ie7cwjvrlky4e27b@soft-dev3-1>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/10/2023 18:44, Vladimir Oltean wrote:
> 
> On Fri, Mar 10, 2023 at 02:15:29PM +0100, Horatiu Vultur wrote:
> > I was thinking about another scenario (I am sorry if this was already
> > discussed).
> > Currently when setting up to do the timestamp, the MAC will check if the
> > PHY has timestamping support if that is the case the PHY will do the
> > timestamping. So in case the switch was supposed to be a TC then we had
> > to make sure that the HW was setting up some rules not to forward PTP
> > frames by HW but to copy these frames to CPU.
> > With this new implementation, this would not be possible anymore as the
> > MAC will not be notified when doing the timestamping in the PHY.
> > Does it mean that now the switch should allocate these rules at start
> > time?
> 
> I would say no (to the allocation of trapping rules at startup time).
> It was argued before by people present in this thread that it should be
> possible (and default behavior) for switches to forward PTP frames as if
> they were PTP-unaware:
> https://patchwork.ozlabs.org/project/netdev/patch/20190813025214.18601-5-yangbo.lu@nxp.com/

Thanks for the explanation!

> 
> But it raises a really good point about how much care a switch driver
> needs to take, such that with PTP timestamping, it must trap but not
> timestamp the PTP frames.
> 
> There is a huge amount of variability here today.
> 
> The ocelot driver would be broken with PHY timestamping, since it would
> flood the PTP messages (it installs the traps only if it is responsible
> for taking the timestamps too).
> 
> The lan966x driver is very fine-tuned to call lan966x_ptp_setup_traps()
> regardless of what phy_has_hwtstamp() says.
> 
> The sparx5 driver doesn't even seem to install traps at all (unclear if
> they are predefined in hardware or not).

They are not predefined in HW, I have on my TODO list to add those
traps I just need to get the time to do this.

> 
> I guess that we want something like lan966x to keep working, since it
> sounds like it's making the sanest decision about what to do.
> 
> But, as you point out, with Köry's/Richard's proposal, the MAC driver
> will be bypassed when the selected timestamping layer is the PHY, and
> that's a problem currently.
> 
> May I suggest the following? There was another RFC which proposed the
> introduction of a netdev notifier when timestamping is turned on/off:
> https://lore.kernel.org/netdev/20220317225035.3475538-1-vladimir.oltean@nxp.com/
> 
> It didn't go beyond RFC status, because I started doing what Jakub
> suggested (converting the raw ioctls handlers to NDOs) but quickly got
> absolutely swamped into the whole mess.
> 
> If we have a notifier, then we can make switch drivers do things
> differently. They can activate timestamping per se in the timestamping
> NDO (which is only called when the MAC is the active timestamping layer),
> and they can activate PTP traps in the netdev notifier (which is called
> any time a timestamping status change takes place - the notifier info
> should contain details about which net_device and timestamping layer
> this is, for example).
> 
> It's just a proposal of how to create an alternative notification path
> that doesn't disturb the goals of this patch set.

-- 
/Horatiu
