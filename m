Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A10433E50
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhJSSWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:22:20 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:35366
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231783AbhJSSWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 14:22:20 -0400
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 523933FFF6
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634667606;
        bh=64iuIQfOFaMwcVIQxd+Ygwi9Yi5880/D7tGs8YCTSAA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=CvJjXY8PWbJ0AosQ2mmvsLYlkqDAC4uVcctf2lKc1GzGAdfj4AUwn6OQQeFqP5g0h
         71rPBeFi6x4AxomQsO24RV4hMfL27P0K5heGQYJ2ayL8VhAhUTbO5qfh2wRkA7RcdN
         5njfc1evmPkH1yGYMlFYlclDRnqclBPKgTx33c6sF4LcZbjcS174jglY0hhw6MVa02
         DhKMMMV0t1rRgUbS6BL836NSffMYZqTgViDTMbqFRtx3k2/9fMLfzqWgy559F6aCD6
         afUS5DeUmgNbctl2Gz6F6pwm6NVriYUPmzXX7incfhoMhjlxg5KHdMYy6RXPavwbzU
         7aNjFnd7/oAHQ==
Received: by mail-pg1-f198.google.com with SMTP id p19-20020a634f53000000b002877a03b293so12010545pgl.10
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 11:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=64iuIQfOFaMwcVIQxd+Ygwi9Yi5880/D7tGs8YCTSAA=;
        b=hap6Ro02Z/aFq2H0//IFvCAD0MExJV94XIzbrNQAjSzlbh6BQNci8ZglgfZEz8Hil4
         htiurMp8dhePlLOK/JWgufwcAO9h+zbQfAbL7/XhCsYgDLsdKoLQjtoTSPkkEJpHKxsW
         AnEJd7BQS0rl0ysBZVtqcINiSfmIyI4hsvrQ5CO5E4SfXVYsCDx1csnMhm2KmjFfVL3H
         aYAWUyHt7soa5pZ6Ripd6BEdbfJE6WH76qfCc9nPxf8Wf3ljzKUXlxBt7jZL4B+I2LX5
         gtcPNZ15tq+RrIWLAX7GSNK7HTGnqBXOvt4gQFoCdnpRPowuaa3TaWndbmjVTogzZouU
         iTlg==
X-Gm-Message-State: AOAM530jQ4/aLgeY9Sqce97VMQlLSN84/nOPOp1OVXMU4B/Z5UrixslW
        FyPNNfd1SJC+g7AUk9JfRKEh2VCgiaf1VNqvVxDU20tL3K5OLoiXk9J4FtJdbedgt3NM22X6nCj
        JvB4W8NA2DIkSv6/6jACLbg+YMCPcpyamxw==
X-Received: by 2002:a17:902:b907:b0:13f:ccaf:9ed8 with SMTP id bf7-20020a170902b90700b0013fccaf9ed8mr8079816plb.46.1634667604620;
        Tue, 19 Oct 2021 11:20:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6xGnIRPJ4AIpW8LVmU03U3+vcTQNm8XPqCknyqs6SO6Ue5v5xOhqDIECBbvqVreszBB6RYA==
X-Received: by 2002:a17:902:b907:b0:13f:ccaf:9ed8 with SMTP id bf7-20020a170902b90700b0013fccaf9ed8mr8079785plb.46.1634667604269;
        Tue, 19 Oct 2021 11:20:04 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id q16sm9591688pfu.36.2021.10.19.11.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 11:20:03 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     netdev@vger.kernel.org
Cc:     tim.gardner@canonical.com, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH][linux-next] net: enetc: unmap DMA in enetc_send_cmd()
Date:   Tue, 19 Oct 2021 12:19:50 -0600
Message-Id: <20211019181950.14679-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains of a possible dereference of a null return value.

   	5. returned_null: kzalloc returns NULL. [show details]
   	6. var_assigned: Assigning: si_data = NULL return value from kzalloc.
488        si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
489        cbd.length = cpu_to_le16(data_size);
490
491        dma = dma_map_single(&priv->si->pdev->dev, si_data,
492                             data_size, DMA_FROM_DEVICE);

While this kzalloc() is unlikely to fail, I did notice that the function
returned without unmapping si_data.

Fix this by refactoring the error paths and checking for kzalloc()
failure.

Fixes: 888ae5a3952ba ("net: enetc: add tc flower psfp offload driver")
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

I am curious why you do not need to call dma_sync_single_for_device() before enetc_send_cmd()
in order to flush the contents of CPU cache to RAM. Is it because __GFP_DMA marks
that page as uncached ? Or is it because of the SOC this runs on ?

rtg
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 22 +++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 4577226d3c6a..a93c55b04287 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -486,14 +486,16 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	data_size = sizeof(struct streamid_data);
 	si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	cbd.length = cpu_to_le16(data_size);
+	if (!si_data)
+		return -ENOMEM;
+	cbd.length = cpu_to_le16(data_size);
 
 	dma = dma_map_single(&priv->si->pdev->dev, si_data,
 			     data_size, DMA_FROM_DEVICE);
 	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
 		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		kfree(si_data);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out;
 	}
 
 	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
@@ -512,12 +514,10 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		return -EINVAL;
+		goto out;
 
-	if (!enable) {
-		kfree(si_data);
-		return 0;
-	}
+	if (!enable)
+		goto out;
 
 	/* Enable the entry overwrite again incase space flushed by hardware */
 	memset(&cbd, 0, sizeof(cbd));
@@ -560,7 +560,11 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	}
 
 	err = enetc_send_cmd(priv->si, &cbd);
-	kfree(si_data);
+out:
+	if (!dma_mapping_error(&priv->si->pdev->dev, dma))
+		dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_FROM_DEVICE);
+
+	kfree(si_data);
 
 	return err;
 }
-- 
2.33.1

