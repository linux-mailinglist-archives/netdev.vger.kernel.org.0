Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE58D196E42
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgC2QAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:00:46 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39166 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgC2QAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DOwh3z2MwJDb1Uvok3pqf/GkIt0I6pPUBCxRMLqBGXc=; b=ZjqcU8vhO9Q2UDJwR4Imbjt6y
        BjKbjxh6B0sM+ni/PCT8/dLeE3IsJpKkWERelwauBdVbiB+iYNckVvrPATKG41Lwcd/RmkcXUd3qa
        Nf0mIt74o6UwyzeZ1/WfP3XlvV3l89l/RwVpZagMBNCHvsM3eLdBLLmcIQJIam0bfJPAHAtqojahu
        gNvZ6zcFMIPAYFp55bj1t2StE9+jIqyu6ds7CA6kLd+TGvKNNyB+/bhsE6YokPZoM9N15p9UFcANG
        UpLENJDkmt7ldFkqEJEokozJmAgVkp8SWJ5wRP9q5Xz7KIi4kuveLxGaLvKOVmQ+328Dy4vEgcSqy
        XRA92ksHg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38834)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIaMY-0005nt-GO; Sun, 29 Mar 2020 17:00:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIaMW-0006Ke-9C; Sun, 29 Mar 2020 17:00:36 +0100
Date:   Sun, 29 Mar 2020 17:00:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200329160036.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series splits the phylink_mac_ops structure so that PCS can be
supported separately with their own PCS operations, separating them
from the MAC layer.  This may need adaption later as more users come
along.

v2: change pcs_config() and associated called function prototypes to
only pass the information that is required, and add some documention.

 drivers/net/phy/phylink.c | 115 ++++++++++++++++++++++++++++++----------------
 include/linux/phylink.h   |  91 +++++++++++++++++++++++++++++++++++-
 2 files changed, 165 insertions(+), 41 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
