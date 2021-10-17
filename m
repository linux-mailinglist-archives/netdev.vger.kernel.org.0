Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCC0430925
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343490AbhJQMw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhJQMwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:52:55 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88324C061765;
        Sun, 17 Oct 2021 05:50:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id kk10so10432071pjb.1;
        Sun, 17 Oct 2021 05:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4wqy4m7MNxsT45A9dbW0Hcm/ddfeiUuTQypZRmFJ+Vg=;
        b=Xr8G/LsVQ0pBXqDobWkzpHu0rdMgdKUkGJhF+vweJ4R7F5yPI8WQv4Ze0eEpmHR2kh
         1rHOjxqVOY+lmnxoN3BnH50MxruiHyt2aM1Bf13XVljf6+ncHlmasLENCksEtFFelkLz
         VpLllWKaS2Kzwlewc85RHGp2bGSIo2Fn4GJLQcd9PSNk+Zj2CzYZqWt+p5dU1Bs21lLJ
         nGMJHMze1YkipQZJvipUGZJ3vX9MbPbt3OLUGXkrqPT/wCVPuckQiDABr4IRBIxC80Cg
         pPZX8i88ZziY0zlx1j4xIARp/cN7XT2BdXmDkuAa5tmrmNcUFq6Ap7oPz71HOG1Eoydz
         Zi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4wqy4m7MNxsT45A9dbW0Hcm/ddfeiUuTQypZRmFJ+Vg=;
        b=o9Uv9OGAnu8XD8nTHtAJu+mzVVaLuQZpcHWzakBk0Ec036FFawjiI0XqiN0mFZ6lKd
         54ViGmltWupqjPQQP364g5PCxN8k8VwUQD7oJNcJ7bZJg93NDSGXQohWDk9gL0enY93z
         uGknUw4OvC87N0Dh2qg7Q8zjL3D4S98+lf8H0u8VYmI5h/qMVO6phb56QbbPvldauWCO
         q1l12a18yP526HulUSp+IZ5NB0yVXM93VWLteqZvCyGH0hJARRBj2ejdnLUtc+h4D/NH
         GVjEO9o34+HwOL11DbCpaM0R9X02p9y31odXk+JFMkEytaOxxc13Bpqwggs1pIsNu7+F
         9vGA==
X-Gm-Message-State: AOAM531wB6NJ/N8WuENIT42vJU95ZrTDiXIQ1TguKmKmDsldVV4qvcOO
        aEZ9QTv/4rpVAYtNi0xokp6a4LeXlAUuLkh6EiMPmw==
X-Google-Smtp-Source: ABdhPJwd6jVaVw6mIw9QPU49EMFxTyVxmCXP3tlrmMyblrpy2Jo8kKhctyZemNnq7uWAN42WHFfDyg==
X-Received: by 2002:a17:90a:73ce:: with SMTP id n14mr41998106pjk.215.1634475045872;
        Sun, 17 Oct 2021 05:50:45 -0700 (PDT)
Received: from localhost.localdomain ([94.177.118.10])
        by smtp.gmail.com with ESMTPSA id i5sm9597221pgo.36.2021.10.17.05.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 05:50:45 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: xilinx_can: remove redundent netif_napi_del from xcan_remove
Date:   Sun, 17 Oct 2021 20:50:21 +0800
Message-Id: <20211017125022.3100329-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since netif_napi_del is already done in the free_candev, so we remove
this redundent netif_napi_del invocation. In addition, this patch can
match the operations in the xcan_probe and xcan_remove functions.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/can/xilinx_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 3b883e607d8b..60a3fb369058 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1848,7 +1848,6 @@ static int xcan_remove(struct platform_device *pdev)
 
 	unregister_candev(ndev);
 	pm_runtime_disable(&pdev->dev);
-	netif_napi_del(&priv->napi);
 	free_candev(ndev);
 
 	return 0;
-- 
2.25.1

