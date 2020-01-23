Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495781470EF
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWSkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:40:32 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35082 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAWSkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:40:32 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so1718511plt.2
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8oIccJIlTUC1Dw8HRnjTRBBSu6QGk0ZS+OG3ES7yvzM=;
        b=egL0/5SHTVAQdpE5LVDaEklnRWCn3BfgW8CtGiXnZWyQ1vHVKDxEQ32safKLKvWjb8
         NZ/uPHGXteStFJ0Gr11yL3vFdeTWUsKpVnlP/jErH1vI85LaP9g0WcVMmAhfeRxUVDmb
         KTUuEorx71cVFyBRxRbjNMFOMCIsLW8verMbaszf32WdyAvdsBiww8EJRICNqDSeRxLX
         +xHu6qqulz1y8lhJvGrFQj4wQVYbQSZYEJ5A8ceCg3KQ0S186lSwUYd1gkar1yo7rrk2
         eN+hZ2tV1mHp5acqOMxn4YaFrQREEmZPczuAp3fmFDoKNnTiE0lMGIv1NAqNQML5k/9I
         1wkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8oIccJIlTUC1Dw8HRnjTRBBSu6QGk0ZS+OG3ES7yvzM=;
        b=jaBs0sJ8zYljT9xdYJqbosfjefvSfqDFPOpvP6YWCXrPe8BX2kvuJHganI/fqpCFUC
         qfntTcqzhn3XBNfcKHiM7WNe9+0J6VKqqeL8dSoNOIwUe+av9u063LAdG2AcmjzAgHht
         jX2rj0gjQhLj+YEnKPgK+lzrgEloGnJ2U6y9BwQL2/n2sdJYpj9alt9ArmfzUgHg7j9Q
         LrlLRfaNHHmtBIGx1bMpJkEB8dRZiBKprR2jXL+QS1vZFJsxvNA/MUeaKlhd5Ubb51yW
         BYKhg+wUYk91WaujF+QFd6Wg2tPgKgJFfxNE6+bp1AbzCUcVMf3JRyN3BSQImwxtSrKK
         L9FA==
X-Gm-Message-State: APjAAAV/sfr6BAdL7rP2Q2DbAUC00JNnA0p1NAvg8eTItEyycJct9v60
        z3w1350SRp1t+MabjWdGdn0=
X-Google-Smtp-Source: APXvYqxxdBSOClT/cmFiST/Ewom/ihbWthLHMzUrDpl2Yiy9XZfV+LD1R1dWGiRFB+OBcxRjzza1HA==
X-Received: by 2002:a17:902:407:: with SMTP id 7mr17065329ple.226.1579804831351;
        Thu, 23 Jan 2020 10:40:31 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 71sm3675782pfb.123.2020.01.23.10.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 10:40:30 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH] net: stmmac: platform: fix probe for ACPI devices
Date:   Wed, 22 Jan 2020 17:16:35 -0800
Message-Id: <20200123011635.15137-1-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Use generic device API to get phy mode to fix probe failure
with ACPI based devices.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 4775f49d7f3b..d10ac54bf385 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -412,9 +412,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		*mac = NULL;
 	}
 
-	rc = of_get_phy_mode(np, &plat->phy_interface);
-	if (rc)
-		return ERR_PTR(rc);
+	plat->phy_interface = device_get_phy_mode(&pdev->dev);
+	if (plat->phy_interface < 0)
+		return ERR_PTR(plat->phy_interface);
 
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
-- 
2.17.1

