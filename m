Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5D188808
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCQOtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:49:50 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40854 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCQOtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k7+i231jDjsm8522fP/urW3aKe5ogcB0Dz0oNPfSKxQ=; b=ZVzUyxowFODWWzKTQ5fC+Znod
        DC9aABxe+fPaIgUpvKGlQOwZ9agaUaHUY+JBDAjKhtOjo949TcV0WmgTBsJM4n05xrupew4eHiqYM
        ahxLfU2aNDa170u1QZ+uyGVfp+wQcGWxNxWaVwReoFvZzT9qM57oU065G4DnX0mUrB6xHE8FoTvlB
        wVRIGes/pyWS6kJvrIzB48Awlft4Pr2LcIaFhxP6mZ3g/eJ0NO6ZuzfMp89jVbfOAlQNfU1op3X9K
        3lGwoW+ZwbU/0DHJnrB3Ej00L4tO/0l3bpABSRskS2czE83PxB9aW0JlWGP3CVQoym/8ByeI5z7CA
        2jHV9hOwQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54266)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEDXM-0007go-Ne; Tue, 17 Mar 2020 14:49:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEDXM-0002tF-7X; Tue, 17 Mar 2020 14:49:44 +0000
Date:   Tue, 17 Mar 2020 14:49:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC net-next 0/2] split phylink PCS operations and add PCS support
 for dpaa2
Message-ID: <20200317144944.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series splits the phylink_mac_ops structure so that PCS can be
supported separately with their own PCS operations, and illustrates
the use of the helpers in the previous patch series (net: add phylink
support for PCS) in the DPAA2 driver.

This is prototype code, not intended to be merged yet, and is merely
being sent for illustrative purposes only.

 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi   | 144 +++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 226 ++++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h |   1 +
 drivers/net/phy/phylink.c                        | 102 ++++++----
 include/linux/phylink.h                          |  11 ++
 5 files changed, 446 insertions(+), 38 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
