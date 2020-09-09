Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F58263223
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbgIIQ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbgIIQZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:25:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4CFC061756
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Kk950UHkpffaei0stWLqtmhbh51NwZ0LS/ZR3Y8Oc/4=; b=i2Ke+6EYFg9bdW/f/ccjPTdGC
        X5tKzd2AUMJ1vAvtz+6ufg5sRsDi7TQERliUUnd+LAvJHDbbCL2BRTLynBqcqq9URxHZW+15hYGnJ
        hOgVxo0QWwrx3WYSDkIHg8dSTyIlWiBC7v7dMm+A0xSilY3MvdQoNUEVCwRClOm8cS9VLG/1ZuTRx
        0Kyi/nzt7h15sPuD8pV16lK4LPlqy1FyJo8w/1NsVSCuOf2s1HD8WqjwcyJ8p+GUG56BLjzhFrd/f
        6jLdy2eWXNA3ueFQ5VLIu+LjMdBmN2Tv9ASSKwuubKw73cKSi/Jz00O9h/h1CD47jDyGxkFTG0eXt
        tnjXqj4QA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32956)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kG2uF-00051Q-AY; Wed, 09 Sep 2020 17:25:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kG2u6-0006WG-9x; Wed, 09 Sep 2020 17:25:02 +0100
Date:   Wed, 9 Sep 2020 17:25:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next v4 0/6] Marvell PP2.2 PTP support
Message-ID: <20200909162501.GB1551@shell.armlinux.org.uk>
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 202 ++++++++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 410 ++++++++++++++++++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c  | 457 ++++++++++++++++++++++++
 5 files changed, 1028 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c

v2: add Andrew's r-bs, squash patch 6 and patch 7.
v3: Address Richard's comments on patch 4.
v4: replace fixes from v2.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
