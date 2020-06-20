Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C426A202331
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 12:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgFTKat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 06:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgFTKad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 06:30:33 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280B0C06174E;
        Sat, 20 Jun 2020 03:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DzAgpAOZLOM7f+2C2NYrc6NoYekk/Q+a1E7XT1PA1jE=; b=I32YmR/GknVIbL66bEJLdSOvv5
        EvI5imvkGhippXrgNAjM/K4bcX0OYR3RmPg8MLyFxGDa7BeEBQdxG4ole587G3C4DEVw8o1p6WO/g
        xhUSsAjNp7N+F/MIv4X/zZ24oJcYhKCVvp/o8p3S4kel9BDjyXF9s9eYxSdd17YW8BJt/mBaprSjD
        Agf0PCCMBnHeEgp8wmt55EiQxZnugTCM5W/W4oIvw728AgzK0OzFcO2T8v99zPPAFDsu0Ta0VHD1u
        cJcIQHfHjj0v7wotYIIr//v6mNYMeJO6n+kS2MJ7kF3E5nKderh5kGKl7jQdLd4oqsaKkWq08wydC
        OC1WW3oA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jmal9-00048D-Gp; Sat, 20 Jun 2020 11:30:03 +0100
Date:   Sat, 20 Jun 2020 11:30:03 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 0/3] net: dsa: qca8k: Improve SGMII interface
 handling
Message-ID: <cover.1592648711.git.noodles@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1591816172.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This 3 patch series migrates the qca8k switch driver over to PHYLINK,
and then adds the SGMII clean-ups (i.e. the missing initialisation) on
top of that as a second patch. The final patch is a simple spelling fix
in a comment.

As before, tested with a device where the CPU connection is RGMII (i.e.
the common current use case) + one where the CPU connection is SGMII. I
don't have any devices where the SGMII interface is brought out to
something other than the CPU.

v5:
- Move spelling fix to separate patch
- Use ds directly rather than ds->priv
v4:
- Enable pcs_poll so we keep phylink updated when doing in-band
  negotiation
- Explicitly check for PHY_INTERFACE_MODE_1000BASEX when setting SGMII
  port mode.
- Address Vladimir's review comments
v3:
- Move phylink changes to separate patch
- Address rmk review comments
v2:
- Switch to phylink
- Avoid need for device tree configuration options

Jonathan McDowell (3):
  net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
  net: dsa: qca8k: Improve SGMII interface handling
  net: dsa: qca8k: Minor comment spelling fix

 drivers/net/dsa/qca8k.c | 341 ++++++++++++++++++++++++++++------------
 drivers/net/dsa/qca8k.h |  13 ++
 2 files changed, 256 insertions(+), 98 deletions(-)

-- 
2.20.1

