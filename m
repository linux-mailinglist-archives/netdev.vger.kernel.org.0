Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD8225B0C2
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgIBQKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIBQKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:10:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9DBC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 09:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BTY0fGThLXhrGlP2jVGEPThGuHaN5geflfeqbYkaafU=; b=Ny7KORvBPox6bLkYydHU0U8n9
        +Nol7HY/61yH3BoyWDp2WL4fZTEUo+nsTalWm/aCtPKAJD/4cKkNMAY5MMqjBx/rg7kfyj7quFcEv
        EgS66n91B3lodRg6N9MXwkzK5WnHmH2zv9K1czyLWVpWlqQdf8FUvmZf/ym0fkpwu169iZZrh/kbY
        f2hTpjt/u7akaKqQzFHOVsP7olKjjxFpkfp/77NyBoZxhWYgtG4bYFX2b5q6v47BzUkeCMXmf1+kV
        qOEh8oeL1fh81wjYCO+Lz0czTxbxyCwirMDOh+WKnMyqiXTKFcZ6GgpktQ+UUdOYZgYP0to/O8k2g
        VvfUiHk0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60266)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kDVKu-0004w4-GM; Wed, 02 Sep 2020 17:10:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kDVKp-0008MK-9Z; Wed, 02 Sep 2020 17:10:07 +0100
Date:   Wed, 2 Sep 2020 17:10:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next 0/7] Marvell PP2.2 PTP support
Message-ID: <20200902161007.GN1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds PTP support for PP2.2 hardware to the mvpp2 driver.
Tested on the Macchiatobin eth1 port.

Note that on the Macchiatobin, eth0 uses a separate TAI block from
eth1, and there is no hardware synchronisation between the two.

 drivers/net/ethernet/marvell/Kconfig            |   6 +
 drivers/net/ethernet/marvell/mvpp2/Makefile     |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 202 +++++++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 410 ++++++++++++++++++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c  | 467 ++++++++++++++++++++++++
 5 files changed, 1038 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
