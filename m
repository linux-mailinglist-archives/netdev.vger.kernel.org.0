Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3498824EF75
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgHWTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgHWTbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 15:31:04 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CBBC061573;
        Sun, 23 Aug 2020 12:31:03 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so3166524plb.12;
        Sun, 23 Aug 2020 12:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=weNWHTNBlFYVLfVtCUahgwUBiIrruSXZn6kHTI1JUaY=;
        b=V77Ac81FIKwovH3RsFHYw6KqcGVROAhAK7uQOVOywTRUgnyCtheBeTYlD1U+XRbKHB
         G/ioAl4eu40NyeaXo8Nl33FsxQSPIUvhrlHT2SLxOszsMe0ByUA9Szm5Jbg9ZuS4b0uy
         ZHJCNEJV1fLvjRhxlxSMq89sQ7MHRGM6yCJDrAa3t8rrnoQ8QIg5eezpRxC/UgdtYppA
         PoDfL/7KmBV3kKXseyYll1UVhOqEWjq8reufqJ6BX1Ou5u9bvkAQNSDgr0FJxnig6WZN
         q3am9o04NOYfbyLNjZlXhDpjGRu+YHnYJCuR1Y2E3KPVC9A4WB3DGhfailImR7zwA9Bg
         92Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=weNWHTNBlFYVLfVtCUahgwUBiIrruSXZn6kHTI1JUaY=;
        b=dL7Y99KWwtreoa0EbxegI5lw84Tz9qq0mTBBL9qZzs7KN5fh4AFKlon3yb4cCPXIRR
         qKwNs/skHySolqOICLvUpIe9ijEyLuRxKbSOgZOStwCV9E0Q3eArL2gx2J82ln00WuL7
         ZapovAL8aMUIVY4S/SIf9GngKvi7m+Gz9//4MRurisWMyPIXnci7xsm+wIAludVRRbMl
         Y/6W30N34hvKhtsaOIVJCcNUhy3Nb55GtLvaigZ1CyuDPJrWg381/IkTUq5KHE/FIV7F
         HBSgYnKmTDEC7o+sOYrQBNYvFxcIeQdpsa+1nqfCQX2JRhGZY5Rh65eROF7DehXIJsmU
         ZVpw==
X-Gm-Message-State: AOAM53146SF6QFu8L4gDJqFx4SMoHMwsegcqRIC/LlXXby7nJaNNPeSY
        zEJnATl+VI/WfxBf0J0KgxE=
X-Google-Smtp-Source: ABdhPJwwq1r/SRRcR3NwII2uDcDioNwrJebgxM9d75uHBbsTp1sJOileU4MFGNBOgcn4iKBR6eyIzA==
X-Received: by 2002:a17:902:8bcb:: with SMTP id r11mr1547106plo.65.1598211063471;
        Sun, 23 Aug 2020 12:31:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.93])
        by smtp.gmail.com with ESMTPSA id mp1sm7804624pjb.27.2020.08.23.12.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 12:31:02 -0700 (PDT)
From:   Sumera Priyadarsini <sylphrenadin@gmail.com>
To:     davem@davemloft.net
Cc:     Julia.Lawall@lip6.fr, andrew@lunn.ch, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>
Subject: [PATCH V3] net: dsa: Add of_node_put() before break and return statements
Date:   Mon, 24 Aug 2020 01:00:54 +0530
Message-Id: <20200823193054.29336-1-sylphrenadin@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every iteration of for_each_child_of_node() decrements
the reference count of the previous node, however when control
is transferred from the middle of the loop, as in the case of
a return or break or goto, there is no decrement thus ultimately
resulting in a memory leak.

Fix a potential memory leak in mt7530.c by inserting of_node_put()
before the break and return statements.

Issue found with Coccinelle.

---
Changes in v2:
	Add another of_node_put() in for_each_child_of_node() as pointed
out by Andrew.

Changes in v3:
	- Correct syntax errors
	- Modify commit message

---

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
---
 drivers/net/dsa/mt7530.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8dcb8a49ab67..4b4701c69fe1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1326,14 +1326,17 @@ mt7530_setup(struct dsa_switch *ds)
 
 			if (phy_node->parent == priv->dev->of_node->parent) {
 				ret = of_get_phy_mode(mac_np, &interface);
-				if (ret && ret != -ENODEV)
+				if (ret && ret != -ENODEV) {
+					of_node_put(mac_np);
 					return ret;
+				}
 				id = of_mdio_parse_addr(ds->dev, phy_node);
 				if (id == 0)
 					priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
 				if (id == 4)
 					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
 			}
+			of_node_put(mac_np);
 			of_node_put(phy_node);
 			break;
 		}
-- 
2.17.1

