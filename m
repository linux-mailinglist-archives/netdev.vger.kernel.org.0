Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB3C14A2CE
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgA0LQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:16:39 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:44518 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730218AbgA0LPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:15:52 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 36A30407CF;
        Mon, 27 Jan 2020 11:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580123375; bh=WDHga405QA2kRfIL5nzi84ZTD/uxWi96ihnmJZFBiA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YUrxf9eNQACZD7KbzDtLfihxIi56TQmyd0NMNnynlFpfaSDri1drYwli4nT6U1t9T
         RyAvJ3XnPifHW0TROUXhsjOOkKT6I3p1NJ3a+eH2uUCIN/LFJqCIj5RmKfnKLfnG0O
         a82XdOEdkJJqT8K1wLEUR8V5LogU+VdrbgrW+BzoZM3ATGVn91pnKswamzx5EjH0DY
         xcXGgG/M9YKHOiNAnZx4MzPb/zRubtPuAOdqL0ykXg1wljOR1u4DakphjdSU1KBSfD
         nhrc5e/uU980M2/bLb4L52FTRZ+g5okYl3O0aLt+q+CDO0nms4sIg6Ak/4y4NO6erI
         DbzzAH8Yt/Tag==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 913E1A008A;
        Mon, 27 Jan 2020 11:09:28 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 2/8] net: phylink: Add phylink_and and phylink_andnot Helpers
Date:   Mon, 27 Jan 2020 12:09:07 +0100
Message-Id: <9509e5d75810da4ef49c674f0fd5cacb81d1a536.1580122909.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new helpers for bitmap handling.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/phylink.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 523209e70947..70a2f7a4450b 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -272,6 +272,10 @@ int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
 
 #define phylink_zero(bm) \
 	bitmap_zero(bm, __ETHTOOL_LINK_MODE_MASK_NBITS)
+#define phylink_and(bm, obm) \
+	bitmap_and(bm, bm, obm, __ETHTOOL_LINK_MODE_MASK_NBITS)
+#define phylink_andnot(bm, obm) \
+	bitmap_andnot(bm, bm, obm, __ETHTOOL_LINK_MODE_MASK_NBITS)
 #define __phylink_do_bit(op, bm, mode) \
 	op(ETHTOOL_LINK_MODE_ ## mode ## _BIT, bm)
 
-- 
2.7.4

