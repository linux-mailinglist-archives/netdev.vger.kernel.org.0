Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF5B25D255
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgIDH2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgIDH2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:28:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7EEC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 00:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jjiolMKbI7adxgZW2Urc0quzTDy0RNGtt5zo/w52StQ=; b=OoOzVpVIDmAYmL6VQhjyzn6gT
        Pq1bl3ljYkQbFQJ0EeOO88pDyVUVnOxAlDu7kdNmejFy7u0CfnlaCQNjgsay2s8Kn46fQeNA4xVHw
        OqZIyOYfKpHgv9XlAn4tRnh6lfum0pOAOUf9uoYinU+zhHhw9C7X0wInf7MLRxEX1f5SsFxxbmT8j
        70GPXI8rZsV9ZjPN+5w8cQfMZ6syZCnkq3fXMZdYzIHAKf7zh6wtgz9puNtABzgrsDcpTyrt75HyP
        vlDOI+LfRhqoRzkwQelrPNABNVbvwisbtrJxgdFr8N0AwPdkS3ef9gFgpO0YGAcvCywFVsbb33eNk
        MzSxjPbNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60942)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kE697-0007OB-AO; Fri, 04 Sep 2020 08:28:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kE696-0001cA-Sa; Fri, 04 Sep 2020 08:28:28 +0100
Date:   Fri, 4 Sep 2020 08:28:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next v2 0/6] Marvell PP2.2 PTP support
Message-ID: <20200904072828.GQ1551@shell.armlinux.org.uk>
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

v2: add Andrew's r-bs, squash patch 6 and patch 7.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
