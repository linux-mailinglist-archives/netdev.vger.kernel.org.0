Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9F11BB4D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfLKSPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:43 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38624 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731306AbfLKSPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:41 -0500
Received: by mail-yw1-f67.google.com with SMTP id 10so9308158ywv.5;
        Wed, 11 Dec 2019 10:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nwGdO4R8lji1D/r7NSUfswqgTgfKAYEWc+q0aQAaY34=;
        b=aUxLEcZUouXI6SiOx6pzGdSVCiQx8vK4DJHmtxf40D8r2b8eE/Z7eFcVMho5BCcp5X
         TWAopBJt6oZEaDrtyeLOmvzBUHni/LGxL7s3zooI5vp3hz+tf/sIY36AZ4ujyxRHdSM1
         JW/i27mPlMCELPmiKLsbGaquGB0q4X7u10AVk6/TmUCwWN03CUXliusqyzdUQzTaTKm8
         EmnzAmMs5HpqAoAL5Uh8/pasMHdghdduGWBgA4X5VWID+DVGHsYkcLwljb9EYVaya0T3
         HlMFB3Nr7xLUmO3wfvrHAAHOSmPCjq6O5tjrX4lfjqHKVrh+78yKijz5Zl8ajfsy/tBN
         RoIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwGdO4R8lji1D/r7NSUfswqgTgfKAYEWc+q0aQAaY34=;
        b=cjS3o+fYnaMo/0HZ6gcHzbwFAhuEKfvhjfVZ3grJkFdDOn+7k3TPw97mnzjwGJJyKv
         7HNMCctHwGlTdnYWIaPCNUXdZSRaMe+IjhySH1C+luA7fXydRgDxgjvQL2eAiAG6aEI9
         Q4cbBkvjMFICCArd7hes4aBrFvLtbYU1KA7Xk8HXU1P7I4+GNRhj41XbglhZUpNxhRgf
         wgHSV4KEa7l6P2+rpC1//I1BtsdxAZBU2b1lFD9caDf1Sstu+xv05USFCeb3azxSB4Vd
         L7KZj6L/s+jsGakYpGjqqpVvP0t9T8/zfXvEIyWa+2Var18hSa50oRZg5ibkIOyBEDdL
         LFBg==
X-Gm-Message-State: APjAAAVrb4ZFSPs+N+1bnFbfNmRfTXWoEn2frzLmaRF9+bokvVfiotDC
        PNyqDCQyoKTzdvl1lnY0N+07JDdv2/BVww==
X-Google-Smtp-Source: APXvYqyozxGB2X1nuGDB7dAEJrbGUelIJWseYKoI5+DIGHJRwfsZF4g4z3Za9/kKACyVGBgBVB3tMw==
X-Received: by 2002:a0d:d2c2:: with SMTP id u185mr875765ywd.211.1576088139917;
        Wed, 11 Dec 2019 10:15:39 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id f134sm1304186ywb.68.2019.12.11.10.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:39 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 23/23] staging: qlge: Fix WARNING: Avoid multiple line dereference
Date:   Wed, 11 Dec 2019 12:12:52 -0600
Message-Id: <f2e9384f0940fb7e57649a8ea8493abae2c220ee.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: Avoid multiple line dereference in qlge_main.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 102da1fe9899..725db7262a9a 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -399,9 +399,8 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			 * the route field to NIC core.
 			 */
 			cam_output = (CAM_OUT_ROUTE_NIC |
-				      (qdev->
-				       func << CAM_OUT_FUNC_SHIFT) |
-					(0 << CAM_OUT_CQ_ID_SHIFT));
+				      (qdev->func << CAM_OUT_FUNC_SHIFT) |
+				      (0 << CAM_OUT_CQ_ID_SHIFT));
 			if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
 				cam_output |= CAM_OUT_RV;
 			/* route to NIC core */
@@ -3428,10 +3427,9 @@ static int ql_request_irq(struct ql_adapter *qdev)
 				     &qdev->rx_ring[0]);
 			status =
 			    request_irq(pdev->irq, qlge_isr,
-					test_bit(QL_MSI_ENABLED,
-						 &qdev->
-						 flags) ? 0 : IRQF_SHARED,
-					intr_context->name, &qdev->rx_ring[0]);
+					test_bit(QL_MSI_ENABLED, &qdev->flags)
+					? 0 : IRQF_SHARED, intr_context->name,
+					&qdev->rx_ring[0]);
 			if (status)
 				goto err_irq;
 
-- 
2.20.1

