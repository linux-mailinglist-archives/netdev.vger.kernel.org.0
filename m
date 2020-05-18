Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D698E1D7EB7
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgERQiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgERQiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:38:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321AE20758;
        Mon, 18 May 2020 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589819886;
        bh=UCRJ/MAv2zt+ot9B3dieTSRN+E/lAjTsZEl/KNf3w5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M4BVr/KM+iHK/37L5wTn+sv7YsXjCyZdOJjL9ubU1r2o0lcKH9aSS5bJoFw4DFnb4
         Osw+ZXX9Cr25ZzNNZ9TzPQlk0dqLQW8VFtlBmX9OcuxgqTMAeZLwQjP0RkOrIi0Fmb
         gYpvi0H8Ot079HK5Vd3MeRODTSlvUY0VxH3Y99W8=
Date:   Mon, 18 May 2020 09:38:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 0/7] Raw PHY TDR data
Message-ID: <20200518093804.34a69fff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200517195851.610435-1-andrew@lunn.ch>
References: <20200517195851.610435-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 21:58:44 +0200 Andrew Lunn wrote:
> Some ethernet PHYs allow access to raw TDR data in addition to summary
> diagnostics information. Add support for retrieving this data via
> netlink ethtool. The basic structure in the core is the same as for
> normal phy diagnostics, the PHY driver simply uses different helpers
> to fill the netlink message with different data.
> 
> There is a graphical tool under development, as well a ethtool(1)
> which can dump the data as text and JSON.
> 
> Thanks for Chris Healy for lots of testing.

Hm, my system can't build this with allmodconfig:

drivers/net/phy/nxp-tja11xx.c:195:37: error: not enough arguments for function ethnl_cable_test_alloc
drivers/net/phy/nxp-tja11xx.c: In function tja11xx_config_aneg_cable_test:
drivers/net/phy/nxp-tja11xx.c:195:8: error: too few arguments to function ethnl_cable_test_alloc
  195 |  ret = ethnl_cable_test_alloc(phydev);
      |        ^~~~~~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/phy/nxp-tja11xx.c:8:
include/linux/ethtool_netlink.h:30:19: note: declared here
   30 | static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
      |                   ^~~~~~~~~~~~~~~~~~~~~~
make[4]: *** [drivers/net/phy/nxp-tja11xx.o] Error 1
make[3]: *** [drivers/net/phy] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2
