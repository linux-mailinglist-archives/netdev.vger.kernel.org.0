Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FFC3E9F2B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhHLHEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:04:53 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:14362 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHLHEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 03:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628751868; x=1660287868;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yXS7WGCykLk3FUewGcpr1XuvvQftDJHoYif2PcgFrW0=;
  b=2Xhzp6hbGo0qRsi1LiB6yYNO8cguJSkV09AvymbESwizoNwWDnREB9H2
   NYWPJT73ffYZ/LA+bPUh+CjnXvo79xvRgvOS62afy98DiHGBtp6K0D+2H
   5Sv6BGDHkBmxVYY5ptbvjSuFHzbK7+sDmR/WS4DetI40apyYuPiI6rxgW
   87tjh9JrSLy+R12mwv9zU59Hv8xU7sAvU7AkSve+m8bREBQ4BrDacNG+s
   0MyFihvdr1q7pGmkDmZqlExNMOUviJ7fEqvtxJD5yzwzp+l5405SOE13G
   I2+xR1dI0p+jn2qO+EKloxw58HBper4UPA6xuDE1wyqOrOXc8AMfittgr
   A==;
IronPort-SDR: zMr99bGI7x3dohffRlPCC9uRYu3WtdDefoqGDNUUPxEflEN3i4q4fkNfFHbAUm7Qym977OgCQS
 PBf4xhchfu+rimc5jHSj+s82mHDNSW8Ovw2frBNgQb0OUTOJ/xOzffCIsqQ5kyz6dsjWBAzhNB
 dUagUz5lT7won7EoSN490NrK3LTCiL9m4K2LXLvxrGkSAvoPvs5+GHjRTErzvlMcC+qUUT6ZJZ
 gLR8njfWChzECutMfrtXh6NYDAROuWpCnefEkLoan0TXqoYr8oRYNyZQ+170x7eghLHl2JgyoN
 oCi68IBwHPC5YScF56Xhb7N5
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="139783698"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2021 00:04:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 00:04:26 -0700
Received: from [10.205.21.35] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 12 Aug 2021 00:04:25 -0700
Message-ID: <e37f35e5ec73a7b7a3d6f692e0764411e74c7486.camel@microchip.com>
Subject: Re: [PATCH net-next 1/2] net: sparx5: switchdev: adding frame DMA
 functionality
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Date:   Thu, 12 Aug 2021 09:04:24 +0200
In-Reply-To: <20210811153132.63480934@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210811075909.543633-1-steen.hegelund@microchip.com>
         <20210811075909.543633-2-steen.hegelund@microchip.com>
         <20210811153132.63480934@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hej Jacub,

On Wed, 2021-08-11 at 15:31 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, 11 Aug 2021 09:59:08 +0200 Steen Hegelund wrote:
> > This add frame DMA functionality to the Sparx5 platform.
> > 
> > Ethernet frames can be extracted or injected autonomously to or from the
> > device’s DDR3/DDR3L memory and/or PCIe memory space. Linked list data
> > structures in memory are used for injecting or extracting Ethernet frames.
> > The FDMA generates interrupts when frame extraction or injection is done
> > and when the linked lists need updating.
> 
> Something to fix:
> 
> drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c: In function ‘sparx5_fdma_start’:
> drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c:544:6: warning: variable ‘proc_ctrl’ set but
> not used [-Wunused-but-set-variable]
>   544 |  u32 proc_ctrl;
>       |      ^~~~~~~~~

Will do.

Thanks for the review.

BR
Steen

