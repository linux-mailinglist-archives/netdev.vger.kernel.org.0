Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0D6160137
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 00:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgBOX5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 18:57:42 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39422 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgBOX5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 18:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iYplRL1e0BdAzh9cQ4tz1FdbBmVjVIbiXIdm8jfOejE=; b=POMR2FnPewzH33ljrEqobxrjWy
        cD6iK3tHhTgwgfT/HeUVSDetjLHNiglDD8+J4J+9BcQLXI788mFbqRv2cWxXZTgRBraEUQRFcAx8i
        lccQWJ4b2C+q7XMKWkUkxn3/DYugoEF8MmKu2SivWi19BQIg1zwl0NhQr5NCOMEbIBr37VGTwQ1Rk
        CP61CSNWB+Io9y3ZgNwT2Vc0Rc3wVNs4scGbVCNtNBg88xBvFYhxcHiDGJ4eIkAeWrptGdxYmXEnx
        Nv9+8c3KqU0rtIiYlO2FVfGKDbr14Cy/vXQQW+kH3EbMunaFKI9uPmKkD/+JnxaQpOy8g8uL0CAwr
        RqODrnTQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:34534 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j37JY-0007te-Ru; Sat, 15 Feb 2020 23:57:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j37JY-0005a8-Al; Sat, 15 Feb 2020 23:57:36 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 01/10] net: linkmode: make linkmode_test_bit() take
 const pointer
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j37JY-0005a8-Al@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 23:57:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linkmode_test_bit() does not modify the address; test_bit() is also
declared const volatile for the same reason. There's no need for
linkmode_test_bit() to be any different, and allows implementation of
helpers that take a const linkmode pointer.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/linkmode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index fe740031339d..8e5b352e44f2 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -71,7 +71,7 @@ static inline void linkmode_change_bit(int nr, volatile unsigned long *addr)
 	__change_bit(nr, addr);
 }
 
-static inline int linkmode_test_bit(int nr, volatile unsigned long *addr)
+static inline int linkmode_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return test_bit(nr, addr);
 }
-- 
2.20.1

