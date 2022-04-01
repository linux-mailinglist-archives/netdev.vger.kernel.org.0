Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DEC4EEE26
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346356AbiDANdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345975AbiDANdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:33:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D25027DEA6;
        Fri,  1 Apr 2022 06:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648819909; x=1680355909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lOHpdOenq/fYFzyDMijV5NodHbSZD635rAmVNUrJjAs=;
  b=LXlqkFAVQeMRZgo02TR8wYLY51ymTpt0kg1Dmct8GLHAl8f526xEgYct
   l+y0TgWtft2/Z9COa87xaKRfsVViyXwhzeuu5dSpU1igAeYKAtAZuX+zd
   bfSflxkoy5uPrEPrqOxX38yIYfSrsn8Xtdv4yoSZceU0M9ijvaxa2YvaL
   7M07rkkLfuiLXKuAn2sD4oRH4W8avbjaZvu5qCnTUgS+0mdho8XMvLgI2
   5zmT0ahkuyGev1KQ8bYIWfoDu1/0kV5KDAZGLq3R6ynbDyiWm7vbsXlHB
   1eCKddLGzsHDhGj2t3xmn+fhIr0NPXuwiUupbf7E6+nSgfMZqI/PHCdMU
   A==;
X-IronPort-AV: E=Sophos;i="5.90,227,1643698800"; 
   d="scan'208";a="158536030"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 06:31:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 06:31:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Apr 2022 06:31:46 -0700
Date:   Fri, 1 Apr 2022 15:34:54 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <Divya.Koppera@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net 2/3] net: phy: micrel: Remove latency from driver
Message-ID: <20220401133454.ic6jxnripuxjhp5g@soft-dev3-1.localhost>
References: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
 <20220401094805.3343464-3-horatiu.vultur@microchip.com>
 <Ykb0RgM+fnzOUTNx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Ykb0RgM+fnzOUTNx@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/01/2022 14:47, Andrew Lunn wrote:
> 
> On Fri, Apr 01, 2022 at 11:48:04AM +0200, Horatiu Vultur wrote:
> > Based on the discussions here[1], the PHY driver is the wrong place
> > to set the latencies, therefore remove them.
> >
> > [1] https://lkml.org/lkml/2022/3/4/325
> >
> > Fixes: ece19502834d84 ("net: phy: micrel: 1588 support for LAN8814 phy")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> Thanks for the revert.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> > -static struct kszphy_latencies lan8814_latencies = {
> > -     .rx_10          = 0x22AA,
> > -     .tx_10          = 0x2E4A,
> > -     .rx_100         = 0x092A,
> > -     .tx_100         = 0x02C1,
> > -     .rx_1000        = 0x01AD,
> > -     .tx_1000        = 0x00C9,
> > -};
> 
> What are the reset defaults of these? 

Those are actually the reset values.

> I'm just wondering if we should
> explicitly set them to 0, so we don't get into a mess where some
> vendor bootloader sets values but mainline bootloader does not,
> breaking a configuration where the userspace daemon does the correct?

It would be fine for me to set them to 0. But then definitely we need a
way to set these latencies from userspace.

> 
>          Andrew

-- 
/Horatiu
