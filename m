Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00D18C226
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCSVRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:17:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39149 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgCSVRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:17:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id h6so5013359wrs.6
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 14:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PYJRuGm9L94awr6ToxB4CPKaiPGLK0GIcQ2dswIg5hA=;
        b=Ljtx1WQSs6EpHUCP+9xMk8q0ykZpS1+8x8PUpIg5W78wCTkxRLgk2YM+Ayh2n3ldbG
         /8/m9vB3vBvVL4zsnb7i/RSLxJNQLxE0ZQMR4MB4YrEjHUlD6BR8OPkUPtTIuJlsLHq0
         UwzLtEGex04xLhagdkyS3ThlFPmbQrkuiqhgEzCq9pU2hoXn1cMnZ4Ytms8XITOf3pH7
         bssDKfquQ7gRrO8MEkcHuLm0Z2jrhsJP8XI0VSlzv+jq7e1BZ68lbmGf2RYeixdEsCkD
         gIsKGRS2B1L6jPh4khY3x0Q+o+H2ZG4kPTimUT/rB6mO9nbC7vEGFEbbOHhBoR8WY+MI
         +x0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PYJRuGm9L94awr6ToxB4CPKaiPGLK0GIcQ2dswIg5hA=;
        b=Vg3iglMAaRGQSnIjWiCS39O2+UbgH9rBSRaQhZuVMWGjbxin6gFeA1bl66KtIM8yhJ
         +PsrLo1EvL79lKjPdWWxNkDQVoIhcDkzGQ5VTaXPwzPW434khiomQnaOVa2MemYwNRqQ
         FstraCt8bGj1/J7oj3GhAxIKctGwpVO/4TlAaiGLvsP2/KmZhNZyLx2etFyaXoe6jvrL
         GbWsoxk+GZ4RQ5vugQXqKf53Sn1GMunVdR7hTZqu3P7FGL4iVtPQPeRQ4FbvsZhSD7JH
         OTKha7ZqsG+4gJiQyPPx37doTMgGikH5iuhvhO499nJzHHnSqi8Vk9MsxCz7siZ3UWOd
         s2Rw==
X-Gm-Message-State: ANhLgQ11jjCtsQG7HhgnrjZqq45hS5CwP3b/HELUa1+H/8rvl5tG2gdd
        1t+k5/1jTNDSHVM4yfgH2oA=
X-Google-Smtp-Source: ADFU+vtwHAtzWrN/XjVxgIv3i611b5GY4+3nh2P786Pvu81Og6Cw0Gs9NB7bFzDComYfiN+tv5DMAQ==
X-Received: by 2002:a5d:480c:: with SMTP id l12mr6668656wrq.19.1584652624254;
        Thu, 19 Mar 2020 14:17:04 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id l13sm5117655wrm.57.2020.03.19.14.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 14:17:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net-next 2/4] net: phy: mscc: accept all RGMII species in vsc85xx_mac_if_set
Date:   Thu, 19 Mar 2020 23:16:47 +0200
Message-Id: <20200319211649.10136-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319211649.10136-1-olteanv@gmail.com>
References: <20200319211649.10136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The helper for configuring the pinout of the MII side of the PHY should
do so irrespective of whether RGMII delays are used or not. So accept
the ID, TXID and RXID variants as well, not just the no-delay RGMII
variant.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index d221583ed97a..67d96a3e0fad 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -491,6 +491,9 @@ static int vsc85xx_mac_if_set(struct phy_device *phydev,
 	reg_val = phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_1);
 	reg_val &= ~(MAC_IF_SELECTION_MASK);
 	switch (interface) {
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII:
 		reg_val |= (MAC_IF_SELECTION_RGMII << MAC_IF_SELECTION_POS);
 		break;
-- 
2.17.1

