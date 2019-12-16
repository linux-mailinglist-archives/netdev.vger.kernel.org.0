Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE020120EF7
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfLPQNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:41 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36226 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfLPQNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:36 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so3192639pjc.3;
        Mon, 16 Dec 2019 08:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LmXS6uIWfMnXSZXtQtWkCqjkZwd/k/U9KsfhUQk5CGY=;
        b=Oxv5/HnsdBDvtAaPP7gUfZsYhaCcmLLW2e+eOvnsnxS3uxoVYPIbIvKMgAuTo6hC6b
         3/tbojC/zZq2CNoP9tDRwUUFr4RN9axRLuwNlxOkFLi5v3omGtoKl/sATFg/bf0BME0X
         wGVZ3xmqydN6XcAM9P1yQ/8DRPc4yv03+LUiYZWPVCX9+IWlPaTX910rjS4tIJ8Odu3g
         4LJUFaZUolAfWDkDpit+Pg6ZBIcBu6COWS6a9uck8ldAOJ84nuA15xuxLSmMxhuPIGSM
         kHxdICXdDlBBjpBGslmSsj5e+wLtqVHmWv7SCEqNiJfKdqiCturx9M2CJhJruJIjOcsC
         dqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LmXS6uIWfMnXSZXtQtWkCqjkZwd/k/U9KsfhUQk5CGY=;
        b=h3TrSrxigDjm9LPmZZ0zqLhHsXFm8pI9964HrLB0qz9uCejnUDM8i1EuAQmeYXqhH6
         UFEXd74uNcGlvLggqOMdsF3DcdbuDdecwJKQhPEsnbU4oCJ3Vz4UKamctxzxgjQgawGG
         I7jlwr+nRZnlZdZfTUwUrqY1ba70DrLfQFaJZtwZ0lG0nl6zYp1kwusKPYG0ne8L3lNO
         SKnqWRC+bexpo4R3OcgP5DntaU0ZsIgOsdGWWkVQ/lquPlOwcMwoISA13xAieU4WLvjF
         MQSbuNtlO4y87qRHgU+AhyKFTUQbDOgEz4CgCRHp7T2aIOLzjA+yXennCDnUGlaWGQcY
         M5gg==
X-Gm-Message-State: APjAAAXkM9a6Eokcm14GsmEUaGoAu8RWW/1dc8xpo5nJPvATqG1KZcXp
        JFChy6HO9+S26UQ35Mhd2uqKMC/w
X-Google-Smtp-Source: APXvYqz/UCHZT0/948BnhH4ryWuFQfMaEU2JUR/+28pQ2nNU4X4wbTxJguBDY+2byLbGbAVt23pmgA==
X-Received: by 2002:a17:90a:e64b:: with SMTP id ep11mr19144877pjb.58.1576512815981;
        Mon, 16 Dec 2019 08:13:35 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:35 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 05/11] net: netcp_ethss: Use the PHY time stamping interface.
Date:   Mon, 16 Dec 2019 08:13:20 -0800
Message-Id: <26366cff657f6182d581d7cdf425bbd1aaf97718.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thie netcp_ethss driver tests fields of the phy_device in order to
determine whether to defer to the PHY's time stamping functionality.
This patch replaces the open coded logic with an invocation of the
proper methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 86a3f42a3dcc..1280ccd581d4 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2533,8 +2533,6 @@ static int gbe_del_vid(void *intf_priv, int vid)
 }
 
 #if IS_ENABLED(CONFIG_TI_CPTS)
-#define HAS_PHY_TXTSTAMP(p) ((p)->drv && (p)->drv->txtstamp)
-#define HAS_PHY_RXTSTAMP(p) ((p)->drv && (p)->drv->rxtstamp)
 
 static void gbe_txtstamp(void *context, struct sk_buff *skb)
 {
@@ -2566,7 +2564,7 @@ static int gbe_txtstamp_mark_pkt(struct gbe_intf *gbe_intf,
 	 * We mark it here because skb_tx_timestamp() is called
 	 * after all the txhooks are called.
 	 */
-	if (phydev && HAS_PHY_TXTSTAMP(phydev)) {
+	if (phy_has_txtstamp(phydev)) {
 		skb_shinfo(p_info->skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		return 0;
 	}
@@ -2588,7 +2586,7 @@ static int gbe_rxtstamp(struct gbe_intf *gbe_intf, struct netcp_packet *p_info)
 	if (p_info->rxtstamp_complete)
 		return 0;
 
-	if (phydev && HAS_PHY_RXTSTAMP(phydev)) {
+	if (phy_has_rxtstamp(phydev)) {
 		p_info->rxtstamp_complete = true;
 		return 0;
 	}
@@ -2830,7 +2828,7 @@ static int gbe_ioctl(void *intf_priv, struct ifreq *req, int cmd)
 	struct gbe_intf *gbe_intf = intf_priv;
 	struct phy_device *phy = gbe_intf->slave->phy;
 
-	if (!phy || !phy->drv->hwtstamp) {
+	if (!phy_has_hwtstamp(phy)) {
 		switch (cmd) {
 		case SIOCGHWTSTAMP:
 			return gbe_hwtstamp_get(gbe_intf, req);
-- 
2.20.1

