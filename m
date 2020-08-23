Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4D624ED69
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 16:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHWOBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 10:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWOBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 10:01:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D743BC061573;
        Sun, 23 Aug 2020 07:01:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so2962950plp.4;
        Sun, 23 Aug 2020 07:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TlsZGie0Pmq1ULANAaf92cPvcSYg7hONtV2IZVBlGx0=;
        b=FBm7IpmR8lFsFOm/8ZYSpn4lHcHTTlLQtfZ7gnrV+9KiCN7Z+4XW9HBRFhYCAlcrFo
         IegKHLWFZd1UkHFojFjnNltDYMlTWXU2lXJpBlQipRET6ZAxveZCthpajxQjss5Zf0Fd
         ynmVJHpxWPvnLkNLJhz0gqlBBDG39Sl6OB2u5yQfDJ4e/OQ+XN24CklX+9L9hl6VHcmD
         S4x8op5uNEZJd+mTCTWeZKCP9nr8b7ltoXA4wYNk2EgxM+kr1Ffa8mn7/rH1hcR+7rop
         K8jAzyqiq/obyOFReOMaKDFMA650dGvGDq6ePyVaPgO3tVecb0DM94WUru27QsRozWQH
         RJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TlsZGie0Pmq1ULANAaf92cPvcSYg7hONtV2IZVBlGx0=;
        b=Jzh/T2rARQD98IJ2JskBW0i0ODBFVoyUxHTQc9EelOCXFk8edcHGR13HspWaq89uXa
         wAeI2ejq3jm4eE8WxXb5WcdCiIxxv1RjNX7tIUyyzrmnFfdbttPAH+UtTT2g8tiPGpCf
         jdMninKWxpP5hgsS3AXsfvc8v7PjBwJBJ0kD/s9EJOlMltFHYRYjivwf+GqfIAYffl96
         26X+0mOWzLBX53FvFF8YQuXJb441WW0CEkI2XcwB6tbcM89JtZzCRmX9TkR6wz6baVri
         PrMWecp0vRg99phePKqzlKDBYqJehRUn7ZEmXv/Ug4lq3+kDj3gNYevdBuDHHsjUalr6
         UooA==
X-Gm-Message-State: AOAM532bdgdfdwLlXxBLPg7yV+n3NhnCJps5xvdcOHRLASJbYnauR2m2
        JM7rXNsXtujbyZkHYHQ48Tc=
X-Google-Smtp-Source: ABdhPJwB7I7XTQmD24PNJDgOa3uoUFrwQGJ2tGiqYQj1CtzJOReQaeyjNpN2XqZHLin2FmSnxHgu7A==
X-Received: by 2002:a17:902:10f:: with SMTP id 15mr976200plb.121.1598191303470;
        Sun, 23 Aug 2020 07:01:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.210.11])
        by smtp.gmail.com with ESMTPSA id t19sm8291639pfc.5.2020.08.23.07.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 07:01:42 -0700 (PDT)
From:   Sumera Priyadarsini <sylphrenadin@gmail.com>
To:     davem@davemloft.net
Cc:     Julia.Lawall@lip6.fr, andrew@lunn.ch, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>
Subject: [PATCH] net: dsa: Add of_node_put() before break statement
Date:   Sun, 23 Aug 2020 19:31:16 +0530
Message-Id: <20200823140116.6606-1-sylphrenadin@gmail.com>
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

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
---
 drivers/net/dsa/mt7530.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8dcb8a49ab67..af83e5034842 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1334,6 +1334,7 @@ mt7530_setup(struct dsa_switch *ds)
 				if (id == 4)
 					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
 			}
+			of_node_put(mac_np);
 			of_node_put(phy_node);
 			break;
 		}
-- 
2.17.1

