Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD6048400F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiADKo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiADKo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:44:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE9DC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 02:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ojDFPC4GdqkqjyhXy5hhfAKt1DL52COEmlH0eLMP6U4=; b=kQvUqSXSN5fvlxUbQnjVc33oz8
        7bhXcCXdjrtBo55f41Yvb8X3pqS2hIIjnM/4c0jmypWBqtf15lX3ggiqNX4SuZyIg556zgxkW6xzi
        RuIsXZAM5rxuXOvJU+WniFnyWv2ao8bmuSg45b1P+bIYkv0MXItCvhCromx2fg598T3HlkhcuA6o3
        VFQ30qX37O+Qmya/UAY8lOWxw9zXczUUMWBz2W0YB/1u6BeZOdIqTm5RqvQwOwvq6zlM5gss1fUQP
        sdw1/sJ/AZnCOWtHSX8hYTBIAFsmvIAPMr+E2i+yfVprhhwpfJ16qfLWnrL/Zd0Pje/l/6aRKCAhV
        BkmzVxiA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56550)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4hJE-0006sZ-E5; Tue, 04 Jan 2022 10:44:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4hJD-0007AV-K3; Tue, 04 Jan 2022 10:44:51 +0000
Date:   Tue, 4 Jan 2022 10:44:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH CFT v2 0/2] net: axienet: modernise pcs implementation
Message-ID: <YdQlI8gcVwg2sR+5@shell.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
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

v2: remove question over switch_x_sgmii

 drivers/net/ethernet/xilinx/xilinx_axienet.h      |   2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 108 +++++++++++-----------
 2 files changed, 55 insertions(+), 55 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
