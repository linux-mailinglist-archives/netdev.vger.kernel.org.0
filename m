Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017CF277391
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgIXOHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 10:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgIXOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 10:07:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4EDC0613D3;
        Thu, 24 Sep 2020 07:07:03 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so3944539wrm.9;
        Thu, 24 Sep 2020 07:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NwiE/qAzUiZ6lU+Jo3RIVIuBWkBT0u68h0OW67hqGOw=;
        b=ke7h7xkZBjNa24ASDTNPMQnBcxFqrydn1XzvZ7PQXFu14U5B0Zh+iyze6O5QMBQ1Kj
         kbcytqhlXZg66t5bFbVVC5fLAZLsm13fOwisu/lz4oj1wsYAUocq3P+0TDHSLrNc3O81
         wcvfQfMkjCoyJH2E+jcRR4kP0WOJ1jcpdt0BKj+OG7ciN0TVb7oiGFeN5SF5T5K7GBw/
         hVtY5yspmMGnG5vmJYlWYdIi5JNwgpX/atB4UIjtgCXls7YMRCvUSjFnl0bIjX5YJ8W7
         45J1cVUaa8jVQMxgmsh5yP6XCJKsDgGvsU8ceJhI2jzvr+XW1eLDSZdGsIsuiS/Aezpc
         5w+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NwiE/qAzUiZ6lU+Jo3RIVIuBWkBT0u68h0OW67hqGOw=;
        b=Xjk8hxoHuelleO7b3g6odXiWmus39qg8B7f7MJLOQVvJFkmfZ+WuDl+GyGPdlh/DMd
         DU6LF09Ysq2IeqFDgF57RkT5mgMHWZ6VXpAIbl88wOBxa6o4EzB4rbrIJqZfOcs8s8w/
         dqPUUY1dQnLggnGim6OUewdM7fPc9B75DMYbb+JesW6cXUF0k4pjTShzczeETTbqLFgq
         m0YByKlockduViI0FOg69mW5crvc0cpboxM2YKQmRV/vqhfS41x2pugapHhL3zZ05YCb
         igRPunkJt4Xq4P5pF1oTT90X3ixbV8yLcr+jGCNF6Kd3ybtmnMMghACAxBQ4oez3y791
         NPDQ==
X-Gm-Message-State: AOAM531yrfxqR5UbEyBlki5rqSbBJyh7/3Hrz7zLNHolG63jiA938ap2
        16raXYi/2sXa5teKLzzJkmWYzQMKsf4n7yFU
X-Google-Smtp-Source: ABdhPJyQeaYSH0dtZQLkXzcaBkKZaxSqciD3iu7nfzOFVZf/o4sk8J8/sx1MP+QlS+c/W0EgbBs6ww==
X-Received: by 2002:a5d:4388:: with SMTP id i8mr5265503wrq.365.1600956421923;
        Thu, 24 Sep 2020 07:07:01 -0700 (PDT)
Received: from localhost.localdomain ([176.12.107.132])
        by smtp.gmail.com with ESMTPSA id k84sm3711217wmf.6.2020.09.24.07.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 07:07:00 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: dsa: mt7530: Add some return-value checks
Date:   Thu, 24 Sep 2020 15:05:35 +0100
Message-Id: <20200924140535.5940-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1600953934.19244.2.camel@mtksdccf07>
References: <1600953934.19244.2.camel@mtksdccf07>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mt7531_cpu_port_config(), if the variable port is neither 5 nor 6,
then variable interface will be used uninitialised. Change the function
to return -EINVAL in this case.

As the return value of mt7531_cpu_port_config() is never checked
(even though it returns an int) add a check in the correct place so that
the error can be passed up the call stack. Now that we correctly handle
errors thrown in this function, also check the return value of
mt7531_mac_config() in case an error occurs here. Also add misisng
checks to mt7530_setup() and mt7531_setup(), which are another level
further up the call stack.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Addresses-Coverity: 1496993 ("Uninitialized variables")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---

Hi Landen,

Here you go!

v3:
	- fix checkpatch warning about braces (Landen)
v2:
	- fix typo in commit message
	- split variable declarations onto multiple lines (Gustavo)
	- add additional checks for mt753*_setup (Landen)

 drivers/net/dsa/mt7530.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 61388945d316..23b2386318b2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -945,10 +945,14 @@ static int
 mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret;
 
 	/* Setup max capability of CPU port at first */
-	if (priv->info->cpu_port_config)
-		priv->info->cpu_port_config(ds, port);
+	if (priv->info->cpu_port_config) {
+		ret = priv->info->cpu_port_config(ds, port);
+		if (ret)
+			return ret;
+	}
 
 	/* Enable Mediatek header mode on the cpu port */
 	mt7530_write(priv, MT7530_PVC_P(port),
@@ -1631,10 +1635,13 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
-		if (dsa_is_cpu_port(ds, i))
-			mt753x_cpu_port_enable(ds, i);
-		else
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = mt753x_cpu_port_enable(ds, i);
+			if (ret)
+				return ret;
+		} else {
 			mt7530_port_disable(ds, i);
+		}
 
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
@@ -1785,10 +1792,13 @@ mt7531_setup(struct dsa_switch *ds)
 
 		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
 
-		if (dsa_is_cpu_port(ds, i))
-			mt753x_cpu_port_enable(ds, i);
-		else
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = mt753x_cpu_port_enable(ds, i);
+			if (ret)
+				return ret;
+		} else {
 			mt7530_port_disable(ds, i);
+		}
 
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
@@ -2276,6 +2286,7 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	struct mt7530_priv *priv = ds->priv;
 	phy_interface_t interface;
 	int speed;
+	int ret;
 
 	switch (port) {
 	case 5:
@@ -2293,6 +2304,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 
 		priv->p6_interface = interface;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
@@ -2300,7 +2313,9 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	else
 		speed = SPEED_1000;
 
-	mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+	ret = mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+	if (ret)
+		return ret;
 	mt7530_write(priv, MT7530_PMCR_P(port),
 		     PMCR_CPU_PORT_SETTING(priv->id));
 	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED, interface, NULL,
-- 
2.28.0

