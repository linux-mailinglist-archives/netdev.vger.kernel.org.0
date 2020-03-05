Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565D717A56E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgCEMl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:41:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39916 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgCEMl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YnYsjuIYSSEnkC+fTrjqyxoFCDXvJlC27BpNge5Iv0s=; b=hilxUGbLMHCtyN0YCuFXGnCoX
        apMav/j6NOyJigSqjKMc5ahlSwyqocMM0wQGNV2Y4AGwNw+JdXTEw29QTyFcp4NTripImChzeQbB1
        jcsC9bRDg7UmJChCfV4zfE/F/4jRT8wTTUMjwuyM7Zw8aBxd02V7oyEtKrLeBBSlOwL6sgH8/ayNV
        4uOnKBvXp8kIhtFVeiMPW7vb+CXVjl3voX0nqFDFwsCAB0j7PfOAbWwKcPymw87vzwZqSANHuHETz
        i4gZDnwdwHg1S1qfYeTwRR0/tiWlxz5t/TlbILVkuwQ+HcCg7mQiLTiqP14uc6QN7SzDc79kNaIYz
        tQ9yzrKlQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48980)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j9pos-0006QT-K3; Thu, 05 Mar 2020 12:41:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j9pop-0007vO-HH; Thu, 05 Mar 2020 12:41:39 +0000
Date:   Thu, 5 Mar 2020 12:41:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200305124139.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
does not automatically update the switch MACs with the link parameters.
Currently, the DSA code implements a work-around for this.

This series improves the Serdes integration, making use of the recent
phylink changes to support split MAC/PCS setups.  One noticable
improvement for userspace is that ethtool can now report the link
partner's advertisement.

 drivers/net/dsa/mv88e6xxx/chip.c   | 437 +++++++++++++++++++++----------------
 drivers/net/dsa/mv88e6xxx/chip.h   |  35 +--
 drivers/net/dsa/mv88e6xxx/port.c   | 285 +++++-------------------
 drivers/net/dsa/mv88e6xxx/port.h   |  29 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c | 375 +++++++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  34 ++-
 include/linux/mii.h                |  57 +++--
 net/dsa/port.c                     |   7 +-
 8 files changed, 706 insertions(+), 553 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
