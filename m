Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B763C409F72
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 00:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhIMWHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 18:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbhIMWH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 18:07:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848F3C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 15:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=9UDCdn/+J/ZFSw+PkN+Giy/F9a5T3Gga4WD8XYCOhuk=; b=edooB8xc5o9xDQYtIuD4sZpFd3
        JQy8/WFXE8i5FY830/Y5NeOtmD3lrjc/XlOg6jcka2Vp9eC1+A0c9D+zGcg302+QJeYm8oGWsjD2+
        SM2tDYm66EulQ+EFWH4v3Nnjv+HCoyruWL/TW+h0JT4jCO8Rm3GeaDlc29XkIqX2dN6i8sThEwxHm
        8AUWR/BY4490kluCQtBQ4EQbPjZlt/w7uZ9TCAjEW7Z1Y1lIbdC4CIaS75ZypY85U2/UCj1DFegd3
        7XvUrtwxhrzFJz+7fvzk/vP1Ijy2Hwp0lgShNo/lff1gVhh2y1V+C9Xua9Hbx8yXQ4yrZrPM//+ra
        /w+ZP2dg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPu5W-003Oig-Rm; Mon, 13 Sep 2021 22:06:06 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH -net] ptp: dp83640: don't define PAGE0
Date:   Mon, 13 Sep 2021 15:06:05 -0700
Message-Id: <20210913220605.19682-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building dp83640.c on arch/parisc/ produces a build warning for
PAGE0 being redefined. Since the macro is not used in the dp83640
driver, just make it a comment for documentation purposes.

In file included from ../drivers/net/phy/dp83640.c:23:
../drivers/net/phy/dp83640_reg.h:8: warning: "PAGE0" redefined
    8 | #define PAGE0                     0x0000
                 from ../drivers/net/phy/dp83640.c:11:
../arch/parisc/include/asm/page.h:187: note: this is the location of the previous definition
  187 | #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)

Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
---
 drivers/net/phy/dp83640_reg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20210913.orig/drivers/net/phy/dp83640_reg.h
+++ linux-next-20210913/drivers/net/phy/dp83640_reg.h
@@ -5,7 +5,7 @@
 #ifndef HAVE_DP83640_REGISTERS
 #define HAVE_DP83640_REGISTERS
 
-#define PAGE0                     0x0000
+/* #define PAGE0                  0x0000 */
 #define PHYCR2                    0x001c /* PHY Control Register 2 */
 
 #define PAGE4                     0x0004
