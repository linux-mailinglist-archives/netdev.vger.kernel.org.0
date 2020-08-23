Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBFA24EF55
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgHWSvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgHWSvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 14:51:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5BCC061573;
        Sun, 23 Aug 2020 11:51:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so3158592plp.4;
        Sun, 23 Aug 2020 11:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wyU9tpC675HB0ixAAkXh4+zgCwIcMMcXIhj+1AOnOR8=;
        b=T+y2mGrEVr3tz7PLuTgcYkJwIC5IeEx/hSpwak1i56n6onfu7wNEQacYGOUsksCnSK
         gIlJQAsHS+JwZ5GaMMJbKk6TLlk90nA61uboFEsGFaUNEKNjyQc0eOiusrgcuSz27dmD
         Em8M9lUKz4Mjqcgp2V2oHAW7Lkz5wxsAb0fc4d/uCFZ+1R5XQdYFLHwEjNvXp39WmEC8
         owsUxAW2xm4CkegIi0/KuYVAYGKdq8u9XcrwR0p/rX3w1l6AObuM2w2tEnos07ulT974
         x2AlLnStHMVE5GPytevXmWOJsnguZsjstl5C4mRWPW1sSEXuqAu11MK7r7OiN5km2n72
         2KwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wyU9tpC675HB0ixAAkXh4+zgCwIcMMcXIhj+1AOnOR8=;
        b=ECP/VQcBXv51qGvf1gOU5a8vgzybtULBAmJZnoYay+gQYfNIrLuP0R3vtQsV8hWt9i
         KLrxBJDYHl2WXYScEnWh66nxcWBD4vsJQhlZM2p6EEozKLsEmjyRoya50wvCG6eymyZc
         mvRBTELmxcTQoQvzKwSOxuJ9IX3cWOPEdpKxems+zCUeWDMLvQp1a7Cn6EPbQAenda9p
         Z8nqrV54q5tVbUnIMPc8LaGEjjQUwRphJsNVLA8wQ/Qe3iaPKQHnvI8l+oYDOJ6kC2k/
         Gkjjta4cx2/OvRsgyOuhGQxljgo2y3Na30PfYjbWshRXwc+3o/4CLoIUWqg1Gg2ZSO5U
         zCiA==
X-Gm-Message-State: AOAM533Mnkl2Dg2uz3CszpxSrhhv/N3j1hQCXGnOk21mnq6/Y2yUDAQ+
        KjqTgNuj/PbnZ2ozPf2p7Yw=
X-Google-Smtp-Source: ABdhPJyaXB8AyrP/r8i55ExjjRdmeAd9G4Y9G2Cu8hHrxOKgTyf3tRAZ4Qd1pUWDrt9kNSOh62DXCA==
X-Received: by 2002:a17:902:16a:: with SMTP id 97mr1516013plb.207.1598208665945;
        Sun, 23 Aug 2020 11:51:05 -0700 (PDT)
Received: from localhost.localdomain ([49.207.217.77])
        by smtp.gmail.com with ESMTPSA id s8sm861116pfm.180.2020.08.23.11.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 11:51:05 -0700 (PDT)
From:   Sumera Priyadarsini <sylphrenadin@gmail.com>
To:     davem@davemloft.net
Cc:     Julia.Lawall@lip6.fr, andrew@lunn.ch, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>
Subject: [PATCH V2] net: dsa: Add of_node_put() before break statement
Date:   Mon, 24 Aug 2020 00:20:56 +0530
Message-Id: <20200823185056.16641-1-sylphrenadin@gmail.com>
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
before the break statement.

Issue found with Coccinelle.

---
Changes in v2:
	Add another of_node_put() in for_each_child_of_node() as pointed
out by Andrew.

---

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
---
 drivers/net/dsa/mt7530.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8dcb8a49ab67..e81198a65c26 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1327,6 +1327,7 @@ mt7530_setup(struct dsa_switch *ds)
 			if (phy_node->parent == priv->dev->of_node->parent) {
 				ret = of_get_phy_mode(mac_np, &interface);
 				if (ret && ret != -ENODEV)
+					of_node_put(mac_np)
 					return ret;
 				id = of_mdio_parse_addr(ds->dev, phy_node);
 				if (id == 0)
@@ -1334,6 +1335,7 @@ mt7530_setup(struct dsa_switch *ds)
 				if (id == 4)
 					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
 			}
+			of_node_put(mac_np);
 			of_node_put(phy_node);
 			break;
 		}
-- 
2.17.1

