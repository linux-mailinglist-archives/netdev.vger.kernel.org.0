Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2051781ED
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbgCCSH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:07:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39376 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbgCCSH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CM/FydandSdqRRSQ2f2rUi2w5meDDl9F8tbAdx8tbwU=; b=PX8Fkbc1iQWkcU+0EhHC3Pbse
        tzo4BGqHjx+sQVZ1o8+ZXM1jmOesZknsqH6QDmNaprHJYDVDAi7h70OcfX5rLFlpN162/aRG315Lz
        GF0Suuf6i6jGfZ1nnc94tUIAH0Ivi6RQrq/jKPtSmu/SbyNjEgmwx1AxG46Fok9+YAkHDK6xpE73p
        vkMApws4X+uJ3zipOhRqp4cGwZh1HCKpapaZuTU1hjvGjV6xAVqkubYQ2Tu8r5Es0noifFsqe16Fs
        2xUsw2Mce9BVpNn75/QKDR4B0E0NGBve6Y3cVDwwYsjmohbxHUtgrLU8r477uFjSFX5tQLUeEVAxQ
        lUJpxz//Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:55786)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j9BxO-00015k-6Z; Tue, 03 Mar 2020 18:07:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j9BxL-00066Z-UJ; Tue, 03 Mar 2020 18:07:47 +0000
Date:   Tue, 3 Mar 2020 18:07:47 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] marvell10g tunable and power saving support
Message-ID: <20200303180747.GT25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds support for:
- mdix configuration (auto, mdi, mdix)
- energy detect power down (edpd)
- placing in edpd mode at probe

for both the 88x3310 and 88x2110 PHYs.

Antione, could you test this for the 88x2110 PHY please?

v3: fix return code in get_tunable/set_tunable
v2: fix comments from Antione.

 drivers/net/phy/marvell10g.c | 177 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 7 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
