Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002401A378D
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgDIPyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:54:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35895 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgDIPyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:54:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id n10so4309858pff.3
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ucKtYbQuGc8onF8oHIcb23sKgcmLNws/OhvldCL7DQ=;
        b=OTW/o+vIzsEvCy8skVyQFDfgbDvhBTyWR6577OqDMYH+e+Db7CKhfPElhd+VktoNQI
         cRoANjRDTbAZ6Ti8y8V11I9t2dTBwcLbSoRUDbuFFJlooCjcMWTWOk5Wft0rT3dGEbn6
         TUk4wFg1/QyMomEpgGHWAPHX5DG1JgnOBqUE8a8UH6oTWZ3HKvTE84zNtOcQsMAgMdLh
         np5GV/GdzkF5iu0RlAL4g0jNAz9OWlIwZ4IcZ0+UUBnIHSWC5RCwFlOcCTWkp2PEPtbI
         oAi2+fqYhWJMh6nkaFvyxKhlvk9rd9Ky6GqZHbqNCfWFLf39KgyiUJybFIXHZqzIiAoh
         dy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ucKtYbQuGc8onF8oHIcb23sKgcmLNws/OhvldCL7DQ=;
        b=KUqbH0clwfzaF6WQrhANTxemYFYL8hBpGfyXi3+qYaNbg/eybiLxquCKannCeFbTiR
         SidMP95luHk290+95mQqrNX8MHwMkm/jWtdeOvahJ+fco61t5zib0rzZp5mwqRC/s1fV
         l2XkBK9RMAki7Gk9a24aRixBSJoyZOL/ixBH/Q/ZeQdAm1tYfajc4YkUQfgpDBMz1Mir
         IIF8RqFIesfTYJNrtpO6IZm5fZ57Bxr4euNriGcuu9oo/wVVkLYk83tr30NXn+DXmEQB
         m/NwxXf0znX8HxTSR4AL6h32eE+QI2ZSAygMVGEPokst6+XJmXIyPiZVt9RCO652bJm/
         VMpA==
X-Gm-Message-State: AGi0PubDWN/hgYKmJvG/TSw4ERcX4ZmF6ktzhcyYDPBaSt7TOce5cgae
        AMYsKnL0vZcSJ4aQMQKcv3l1+qvMwEcJYA==
X-Google-Smtp-Source: APiQypJHiedBu++E1LBL7z2k5OexmoYH7tz4WT3EVNUCjR34GEaYqXrpdiKMbgQnjCYMnNGchnhrCA==
X-Received: by 2002:a63:460a:: with SMTP id t10mr82648pga.105.1586447655664;
        Thu, 09 Apr 2020 08:54:15 -0700 (PDT)
Received: from example.com ([2402:f000:1:1501::7416:4bb0])
        by smtp.gmail.com with ESMTPSA id q200sm18567691pgq.68.2020.04.09.08.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 08:54:15 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Wang <sean.wang@mediatek.com>,
        Weijie Gao <weijie.gao@mediatek.com>
Subject: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
Date:   Thu,  9 Apr 2020 23:54:09 +0800
Message-Id: <20200409155409.12043-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable jumbo frame for MT7530
It allows frames up to 15 KB (including FCS)

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 16 ++++++++++++++++
 drivers/net/dsa/mt7530.h |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2d0d91db0ddb..ed080ded34a7 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1284,6 +1284,19 @@ mtk_get_tag_protocol(struct dsa_switch *ds, int port,
 	}
 }
 
+static void
+mt7530_set_jumbo(struct mt7530_priv *priv, u8 kilobytes)
+{
+	if (kilobytes > 15)
+		kilobytes = 15;
+
+	if (kilobytes > 1)
+		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_JUMBO_MASK | MAX_RX_PKT_LEN_MASK,
+			   MAX_RX_JUMBO_KB(kilobytes) | MAX_RX_PKT_LEN_JMB);
+	else
+		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1536);
+}
+
 static int
 mt7530_setup(struct dsa_switch *ds)
 {
@@ -1428,6 +1441,9 @@ mt7530_setup(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
+	/* Enable jumbo frame up to 15 KB */
+	mt7530_set_jumbo(priv, 15);
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ef9b52f3152b..62f5ea64670d 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -223,6 +223,13 @@ enum mt7530_vlan_port_attr {
 #define  PMSR_DPX			BIT(1)
 #define  PMSR_LINK			BIT(0)
 
+#define MT7530_GMACCR			0x30e0
+#define  MAX_RX_JUMBO_KB(x)		((x) << 2)
+#define  MAX_RX_JUMBO_MASK		MAX_RX_JUMBO_KB(0xf)
+#define  MAX_RX_PKT_LEN_MASK		0x3
+#define  MAX_RX_PKT_LEN_1536		0x1
+#define  MAX_RX_PKT_LEN_JMB		MAX_RX_PKT_LEN_MASK
+
 /* Register for MIB */
 #define MT7530_PORT_MIB_COUNTER(x)	(0x4000 + (x) * 0x100)
 #define MT7530_MIB_CCR			0x4fe0
-- 
2.26.0

