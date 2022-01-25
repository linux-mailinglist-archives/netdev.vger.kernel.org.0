Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1D249B84F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiAYQK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574653AbiAYQIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:08:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0168FC061755
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g2IfAkoycv2/LyNH25WFIWk1Duwwv1ZBY/ThaVcxiQw=; b=znmlhp9HHjCxmbTGDUHH4WtBe+
        byU5wqdSpRBTKieX7zbdQBpEcPlgd+Z1CWftPqJOTibOqtzla/Xpg2xOiafjllKVDUt7K92RddOLw
        WwNINRoWSZCeMhLDPBbSJ9BeUQv590G1f3oq0t0uCLOgVojzCrLlRrRURf8StweLDdpXiHbGc2NIy
        96905qJvtSTLJRIXfmL3hQ5FJ/4rcNCW3fjWLdcpJO+lmfOlriX/Ie6lekqmZpdhTfEHJ8wcSKB4F
        RyPO9gboJwcS2sZQHzRAp5BpgBHO0ZXtHQyZgy1/PeT72OF6rN4ak8WPv0HzkBxeZI7bzkjF/6VP/
        03QuSLxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56856)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCOMt-00027a-6a; Tue, 25 Jan 2022 16:08:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCOMq-0003PX-QE; Tue, 25 Jan 2022 16:08:24 +0000
Date:   Tue, 25 Jan 2022 16:08:24 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 0/2] net: axienet: modernise pcs implementation
Message-ID: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

These two patches modernise the Xilinx axienet PCS implementation to
use the phylink split PCS support.

The first patch adds split PCS support and makes use of the newly
introduced mac_select_pcs() function, which is the preferred way to
conditionally attach a PCS.

The second patch cleans up the use of mdiobus_write() since we now have
bus accessors for mdio devices.

There should be no functional change to the driver.

This series was previously sent CFT on the 16th December (message ID
Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk), and feedback addressed. CFT v2
sent 4th January (message ID YdQlI8gcVwg2sR+5@shell.armlinux.org.uk).

 drivers/net/ethernet/xilinx/xilinx_axienet.h      |   2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 108 +++++++++++-----------
 2 files changed, 55 insertions(+), 55 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
