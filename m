Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7497C3958C1
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhEaKKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhEaKJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:09:12 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37E2C06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 03:07:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l1so15886458ejb.6
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 03:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a0/8Vpq95M8QprcQw7KYDWNo1Yxj99yeThQkIKer1ag=;
        b=qb2L4ScSA4rVDGUkdJZQNfB/i+W20GjSsyHJTQCCZZK9r66QakKq4I17mG+rP2b+aj
         xyhtpKTXD352BetYnWu/1AMdS6ADwSevgYe2jmU4P1P85FX/Ofad+myYq9zGEaePDuXW
         yACDIpad6K35q+8dlXnvDx0ekRI+A3KHR42VJLulWef3w2RsQtGpx/tzBHXR5dy8vHD0
         BPPIs/UojtfYLDab+1TiBXUvYaAvHVAHnJPlXfyWg/KlHmt8To2bacBq1uWPT+27Xjdf
         QQNUIQ6PLC3Lv6MpWWkAyN3WOga+YxQb+5LE0yZoTV4PGHuKUJjZ6UYSlfrtDyZkkliW
         zyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0/8Vpq95M8QprcQw7KYDWNo1Yxj99yeThQkIKer1ag=;
        b=PB6ramofg143h2kUJMQrCV6/3NFxMCN1mAUQoYIvlQO1+MP4zMMwzvZge1hWSZ8BlS
         sywbluu0EBgk5EdsdAumevUNhSJvZDHtRTIyNTO1LQng/RfByHYZIkKlBWPjYb9OBaVq
         JGG3vMq1YPVAPjVbzp1u9T2Gf6wAw/QIkM2dKYT0+/pMtho+0CgIwo+bTD4A5eB9Drlv
         sSidnkonb4cAOGu31SZxhN/SSBwn8X1R9NACE4iRJPth8jMaCGLpPnkdJ+Ei9Hijt/nu
         UP8koh4aJMBsV3GwdGQvDOVs+EsoL/b/Ton0fJdFS2K2u9QGh+G+50Z6tB/GFWYrang9
         A1jQ==
X-Gm-Message-State: AOAM532Wf6vnSZdv6lEPuBSwW0p3Xmlj3roCvagv8pdiYmY8jo2was9p
        s2ogi4eZUj/qv9ASxdT80Uk=
X-Google-Smtp-Source: ABdhPJxgdzYjyI9/FE4Af6VlNeEkPnkdKXYezqdtMNEyRBys/IemZSU+FXK/eypAz/2ft9O6a9KR+w==
X-Received: by 2002:a17:906:174e:: with SMTP id d14mr22162790eje.397.1622455637593;
        Mon, 31 May 2021 03:07:17 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id fn3sm832893ejc.96.2021.05.31.03.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:07:17 -0700 (PDT)
Date:   Mon, 31 May 2021 13:07:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 0/8] Convert xpcs to phylink_pcs_ops
Message-ID: <20210531100715.mjjs4flzen67a5kr@skbuf>
References: <20210527204528.3490126-1-olteanv@gmail.com>
 <20210528021521.GA20022@linux.intel.com>
 <20210528091230.hzuzhotuna34amhj@skbuf>
 <20210531023019.GA5494@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531023019.GA5494@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi VK,

On Mon, May 31, 2021 at 10:30:19AM +0800, Wong Vee Khee wrote:
> On Fri, May 28, 2021 at 12:12:30PM +0300, Vladimir Oltean wrote:
> > Hi VK,
> > 
> > On Fri, May 28, 2021 at 10:15:21AM +0800, Wong Vee Khee wrote:
> > > I got the following kernel panic after applying [1], and followed by
> > > this patch series.
> > > 
> > > [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210527155959.3270478-1-olteanv@gmail.com/
> > > 
> > > [   10.742057] libphy: stmmac: probed
> > > [   10.750396] mdio_bus stmmac-1:01: attached PHY driver [unbound] (mii_bus:phy_addr=stmmac-1:01, irq=POLL)
> > > [   10.818222] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
> > > [   10.830348] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to setup phy (-22)
> > 
> > Thanks a lot for testing. Sadly I can't figure out what is the mistake.
> > Could you please add this debugging patch on top and let me know what it
> > prints?
> > 
> 
> Sorry for the late response. Here the debug log:
> 
> [   11.474302] mdio_bus stmmac-1:01: attached PHY driver [unbound] (mii_bus:phy_addr=stmmac-1:01, irq=POLL)
> [   11.495564] mdio_bus stmmac-1:16: xpcs_create: xpcs_id 7996ced0 matched on entry 0
> [   11.503154] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 13
> [   11.510377] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 14
> [   11.517590] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 6
> [   11.524725] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 17
> [   11.531946] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 18
> [   11.539278] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 19
> [   11.541316] ish-hid {33AECD58-B679-4E54-9BD9-A04D34F0C226}: [hid-ish]: enum_devices_done OK, num_hid_devices=6
> [   11.546487] mdio_bus stmmac-1:16: xpcs_create: setting entry->supported bit 15
> [   11.546489] mdio_bus stmmac-1:16: xpcs_create: xpcs->supported 0000000,00000000,000ee040
> [   11.584687] hid-generic 001F:8087:0AC2.0001: device has no listeners, quitting
> [   11.599461] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match supported interface 0 (usxgmii)
> [   11.606538] hid-generic 001F:8087:0AC2.0002: device has no listeners, quitting
> [   11.610306] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match any supported interface
> [   11.610309] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match supported interface 0 (usxgmii)
> [   11.626259] hid-generic 001F:8087:0AC2.0003: device has no listeners, quitting
> [   11.627675] mdio_bus stmmac-1:16: xpcs_validate: provided interface sgmii does not match any supported interface
> [   11.627677] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
> [   11.641996] hid-generic 001F:8087:0AC2.0004: device has no listeners, quitting
> [   11.645729] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to setup phy (-22)

Ha ha, this works as expected, but I was led into error due to the code
structure.

See, everything in pcs-xpcs.c is laid out as if there are different PHY
IDs for SGMII, USXGMII etc. But if you pay close attention, they are all
equal to 0x7996ced0:

#define SYNOPSYS_XPCS_USXGMII_ID	0x7996ced0
#define SYNOPSYS_XPCS_10GKR_ID		0x7996ced0
#define SYNOPSYS_XPCS_XLGMII_ID		0x7996ced0
#define SYNOPSYS_XPCS_SGMII_ID		0x7996ced0
#define SYNOPSYS_XPCS_MASK		0xffffffff

With the old code, it works because the probing code gets a nudge from
the caller of xpcs_probe by being told what is the expected phy_interface_t.
The xpcs then uses the phy_interface_t _as_part_of_ the PHY ID matching
sequence.

So.. yeah. I got the information I needed. I will come back with a way
for the same PCS PHY ID to support multiple PHY interface types.

Thanks again for testing.
