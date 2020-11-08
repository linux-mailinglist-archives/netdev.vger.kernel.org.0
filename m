Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5227E2AAACA
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 13:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgKHMNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 07:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgKHMNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 07:13:07 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9E4C0613CF;
        Sun,  8 Nov 2020 04:13:07 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f27so1121797pgl.1;
        Sun, 08 Nov 2020 04:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sZgtC17MKA2xhKNgWbgYsub6PZlsKHIRcytR5EljA/A=;
        b=q1FupwcIEATY7EtpNhAYG+Furzmr5KF54ZFCdrq/myzcR4zUFg09b/iieRHagWPoXt
         CjTmLpeCSRL7Av7IrGrepsllfHdPepC33LjJXGB0ne+xYxXyRgtM4W2cpMmnP3ZERnBB
         jbB5XZpA50967PraixaiArf8/WlUFCa7xslzZlYJplYs98l0qm53yMUH08xJ1VnKux1Q
         a6a2NTsswXSA6mnQjCkBnLjc5ERlpMehEq0yleNrVgdHYGGgyBxAZYZ5SMfd+DSgdgO4
         LJCLWFtczdGi7wuDuL8gXZoi3wXQFuyXSTFLgxv/umPWhLBwc0DID/e6wnfN3bLzjjNh
         kUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sZgtC17MKA2xhKNgWbgYsub6PZlsKHIRcytR5EljA/A=;
        b=DZYz6MbJOgHRUZgwxeeDxyA17P6CKXwkmjYAVb3f8XGwur73tzJQGmGD/gaSxM3RbD
         BDlkn9Tg8UMVweZPZjeQjL46yXHWbAE/pUrgW9UWEgpx6TPNafQx4Hm/mCkKEeTA7JjX
         GOLuOpkZeudcJHYTmWfgBCR+2Bim6T/L7qHcqYF8iLC/G1yG/MJV/2QNohUIbYvbjYgY
         zt5TuP1pg6fwjPjJiwahTuSqGWWSKUqKKQAMA4YDOJBGZV5svKPsDMF3EljYcUcNPMlT
         VWnUPd1bDG4x8tpXizUaUEQuvhVZG8Tt8+qV2fHSuTN0c5mcw3Qigi75uV96ipJqOXTK
         qpDw==
X-Gm-Message-State: AOAM531QqisvSiu9o6CXo54giR4SCckkFPdG8MdN/Y2A5LC0Wz0OP1D4
        vflgYJ8LnCc7lyHpTQPbMcEn7vQf3FAe
X-Google-Smtp-Source: ABdhPJxw3i1OOYT00hJ4cshzn+orNUN3ugzmQcSQK0GTs5qsgdDlmrDZbJhzSNpoAZXZk0bJ8PqZFg==
X-Received: by 2002:a63:3e05:: with SMTP id l5mr8920664pga.74.1604837586879;
        Sun, 08 Nov 2020 04:13:06 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v7sm8048096pfu.39.2020.11.08.04.13.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Nov 2020 04:13:05 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] net: pch_gbe: remove unneeded variable retval in __pch_gbe_suspend
Date:   Sun,  8 Nov 2020 20:13:00 +0800
Message-Id: <1604837580-12419-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the following coccicheck warning:

./drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:2415:5-11: Unneeded variable: "retval". Return "0" on line 2435

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ade8c44c01cd..b9e32e4478a8 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2412,7 +2412,6 @@ static int __pch_gbe_suspend(struct pci_dev *pdev)
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	struct pch_gbe_hw *hw = &adapter->hw;
 	u32 wufc = adapter->wake_up_evt;
-	int retval = 0;
 
 	netif_device_detach(netdev);
 	if (netif_running(netdev))
@@ -2432,7 +2431,7 @@ static int __pch_gbe_suspend(struct pci_dev *pdev)
 		pch_gbe_mac_set_wol_event(hw, wufc);
 		pci_disable_device(pdev);
 	}
-	return retval;
+	return 0;
 }
 
 #ifdef CONFIG_PM
-- 
2.20.0

