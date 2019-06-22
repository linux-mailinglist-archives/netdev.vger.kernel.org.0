Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092DC4F676
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFVPRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 11:17:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFVPRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 11:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JLAYnHSUEh6JrV56G8BcihpmZUMRNPD6w8HfodS1dL8=; b=D2YWk6uOxm6uYhneNLGX01gZ4H
        Z+zCbSojlrYws9oUxt5hBVqy4nBbF8p9a+69ZumzN9iIdDr7+YT9yo9MGLBYNrlQTXyXYaMUDtw0a
        WfilyveYd1aBJn6M0COMCu4L1nzwoWUtlMar07HWTno3GhynQcrcZ+Jex3ep1mX2jQzg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hehlB-0002dW-S5; Sat, 22 Jun 2019 17:16:57 +0200
Date:   Sat, 22 Jun 2019 17:16:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/7] net: aquantia: add documentation for the
 atlantic driver
Message-ID: <20190622151657.GC8497@lunn.ch>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
 <1e1b3a34f4ff27aad030e690058404b2140da914.1561210852.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e1b3a34f4ff27aad030e690058404b2140da914.1561210852.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  Jumbo Frames
> +  ------------
> +  The driver supports Jumbo Frames for all adapters. Jumbo Frames support is
> +  enabled by changing the MTU to a value larger than the default of 1500.
> +  The maximum value for the MTU is 16000.  Use the ifconfig command to
> +  increase the MTU size.  For example:
> +
> +        ifconfig <ethX> mtu 16000 up

ifconfig has been deprecated for many years. Please document the
iproute2 command.

> + Viewing adapter information
> + ---------------------
> + ethtool -i <ethX>
> +
> + Output example:
> + driver: atlantic
> + version: 1.6.9.0
> + firmware-version: 1.5.49
> + expansion-rom-version:
> + bus-info: 0000:01:00.0
> + supports-statistics: yes
> + supports-test: no
> + supports-eeprom-access: no
> + supports-register-dump: yes
> + supports-priv-flags: no

Shouldn't there be 5.2-rc5 in here somewhere, given the first patch in
this series?

> +
> + Disable GRO when routing/bridging
> + ---------------------------------
> + Due to a known kernel issue, GRO must be turned off when routing/bridging.
> + It can be done with command:

Is this a kernel issue, or a driver issue? 

> + Interrupt coalescing support
> + ---------------------------------
> + ITR mode, TX/RX coalescing timings could be viewed with:
> +
> + ethtool -c <ethX>
> +
> + and changed with:
> +
> + ethtool -C <ethX> tx-usecs <usecs> rx-usecs <usecs>
> +
> + To disable coalescing:
> +
> + ethtool -C <ethX> tx-usecs 0 rx-usecs 0 tx-max-frames 1 tx-max-frames 1

Please put these before the module parameters. We should discourage
the use of module parameters. Using ethtool is the correct way to do
this.

> +License
> +=======
> +
> +aQuantia Corporation Network Driver
> +Copyright(c) 2014 - 2019 aQuantia Corporation.
> +
> +This program is free software; you can redistribute it and/or modify it
> +under the terms and conditions of the GNU General Public License,
> +version 2, as published by the Free Software Foundation.

grep SPDX drivers/net/ethernet/aquantia/atlantic/*.c
drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c:// SPDX-License-Identifier: GPL-2.0-or-later
drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c:// SPDX-License-Identifier: GPL-2.0-only
drivers/net/ethernet/aquantia/atlantic/aq_filters.c:// SPDX-License-Identifier: GPL-2.0-or-later
drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c:// SPDX-License-Identifier: GPL-2.0-only
drivers/net/ethernet/aquantia/atlantic/aq_main.c:// SPDX-License-Identifier: GPL-2.0-only
drivers/net/ethernet/aquantia/atlantic/aq_nic.c:// SPDX-License-Identifier: GPL-2.0-only
drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c:// SPDX-License-Identifier: GPL-2.0-only
drivers/net/ethernet/aquantia/atlantic/aq_ring.c:// SPDX-License-Identifier: GPL-2.0-only
drivers/net/ethernet/aquantia/atlantic/aq_vec.c:// SPDX-License-Identifier: GPL-2.0-only

You have a mix of 2 and 2+.

    Andrew
