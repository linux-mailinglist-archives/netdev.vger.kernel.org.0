Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7FF477223
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhLPMrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236919AbhLPMrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:47:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE4EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jxCv6zM4/AJUYK3u/tkYLL5oHjuuejaIEOEtkVdPMVc=; b=NWjxRvbpMmB1VeGGH/qtCH49M7
        0KtG/h0eaUWA44nXkf5d5k4XUNyTzz7/uYRWi68HIg5kanX2nizCdRNceMiiGCAo7vVE0yDy/FBWA
        hoZUnsTDjQUCwJOy2qFFVvj4j8Byw4Y1rRfuEGsZiQIb9unsEFIOkC8HNhQ1bPUWJu2Q4pQbk6E+k
        AgPXuU14bXJj+hpOSGiZddpGkOV1Ob9ENk2zbql05gVynrr8tRbYYFwILib89WDF5TeMe5TUhICaZ
        L1WYS7X+PasVQlltFZ47A3hwPoIx3gzqaEvf3DrHF32p0zbd/GDu2teuobU+uuFT/AWXVimGl5xbm
        jUrvZChQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56316)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxqAm-0007oq-4G; Thu, 16 Dec 2021 12:47:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxqAj-0005QP-7I; Thu, 16 Dec 2021 12:47:45 +0000
Date:   Thu, 16 Dec 2021 12:47:45 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH CFT 0/2] net: axienet: modernise pcs implementation
Message-ID: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
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

Please test, thanks.

 drivers/net/ethernet/xilinx/xilinx_axienet.h      |   1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 111 +++++++++++-----------
 2 files changed, 56 insertions(+), 56 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
