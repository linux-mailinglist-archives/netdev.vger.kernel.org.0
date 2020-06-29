Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98C20D375
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgF2S7E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 14:59:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:65099 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgF2S6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:58:54 -0400
IronPort-SDR: eKoD8V2wqTWUE0QfvlcDWBj2fUJGp1JQFAZEWCcOdd9RB6Iz2k79WYN3SDqzCHfZ5x5HJtYUrS
 TCxYV5wPo5rQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="147558727"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="147558727"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:18:48 -0700
IronPort-SDR: PfovTJ7ctRVVTVNzrBgATY6YChrZ/17qHIHtYJnPMMZEpZLRlO/kZ9uRGO0xFF6kZv7z2obVoF
 C6l1q1l38H6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="424885466"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 10:18:47 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.104]) with mapi id 14.03.0439.000;
 Mon, 29 Jun 2020 10:18:47 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Rob Herring" <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: RE: [PATCH v2 02/10] net: ethernet: ixgbe: don't call
 devm_mdiobus_free()
Thread-Topic: [PATCH v2 02/10] net: ethernet: ixgbe: don't call
 devm_mdiobus_free()
Thread-Index: AQHWTg2KqoUStuk1GEW2zcU3EcxbWKjv1lQw
Date:   Mon, 29 Jun 2020 17:18:46 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449874064D@ORSMSX112.amr.corp.intel.com>
References: <20200629120346.4382-1-brgl@bgdev.pl>
 <20200629120346.4382-3-brgl@bgdev.pl>
In-Reply-To: <20200629120346.4382-3-brgl@bgdev.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Bartosz Golaszewski <brgl@bgdev.pl>
> Sent: Monday, June 29, 2020 05:04
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; John Crispin
> <john@phrozen.org>; Sean Wang <sean.wang@mediatek.com>; Mark Lee
> <Mark-MC.Lee@mediatek.com>; Matthias Brugger
> <matthias.bgg@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>; Andrew
> Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>; Russell King
> <linux@armlinux.org.uk>; Rob Herring <robh+dt@kernel.org>; Frank Rowand
> <frowand.list@gmail.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-mediatek@lists.infradead.org;
> devicetree@vger.kernel.org; Bartosz Golaszewski
> <bgolaszewski@baylibre.com>
> Subject: [PATCH v2 02/10] net: ethernet: ixgbe: don't call
> devm_mdiobus_free()
> 
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The idea behind devres is that the release callbacks are called if probe fails. As
> we now check the return value of ixgbe_mii_bus_init(), we can drop the call
> devm_mdiobus_free() in error path as the release callback will be called
> automatically.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
 
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
