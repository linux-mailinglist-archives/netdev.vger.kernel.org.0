Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3FD19829B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgC3Rni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:43:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55970 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbgC3Rni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DbNDLZv69oD2h74kxnSO6sXdtYVe+PVoOCCLOJyKOJk=; b=xP+KO8g4DGEb8ZUAjdqBbic16
        vW28HLuaCzjk84AHmhOd5NHGAQH40Gn22+8RHvjIMp3FWRJVVKgtvaS7n1T6hChu+g3PZoBILdwbF
        PgjxMrS1CvxsuXXMwO3K9cr8Rp9xUXq89a6LnN1qHzZL/Z0I+CsbEkX+7XklsG7IAZ1ELPcbujWyq
        H4yVR2+k7r8yqXuHb4pULXADfFdc8RkH/TD9HyshN5NzUOHtbVGzDN2E5HXeXHVF7mdZn597lNO4W
        oNIlUCAe7vgbh7i2WZ3pszonsxEdEyjcSP2Hkg4G1s1mwGRqaR+4ymPQb8y2VI6AFSF4dmSh8qhgg
        LH2F/yUpw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:39288)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIyRg-0003VX-1b; Mon, 30 Mar 2020 18:43:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIyRe-0007JY-9G; Mon, 30 Mar 2020 18:43:30 +0100
Date:   Mon, 30 Mar 2020 18:43:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] split phylink PCS operations
Message-ID: <20200330174330.GH25745@shell.armlinux.org.uk>
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

v3: change phylink_create() prototype

 drivers/net/phy/phylink.c | 115 ++++++++++++++++++++++++++++++----------------
 include/linux/phylink.h   |  93 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 166 insertions(+), 42 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
