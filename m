Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8E4181AD
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244574AbhIYLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhIYLk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 07:40:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202C1C061570;
        Sat, 25 Sep 2021 04:38:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i24so19496065wrc.9;
        Sat, 25 Sep 2021 04:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kxpv1Vy6pYbyF1BOQEj3cs5wBqi8pHepFHdqGdQ/R9M=;
        b=DPrpEgC0X7aTJh/sIZdIt5MciRnryOGZs90IJdyIGD9COAPJ5XjGHe9Yf0nPXONpGH
         z9AahC6xjKwrllYvKDocn2ryrkmg8D0YoA3AQqWhoXhlNbEcTK7zfVZ1lDMchUiU40QI
         eSafJvX3tthIsSieEmno0w1BOplCIF2GrOr4FZzyaXIl1dVI2dttLhANLE3QK8nZX8m2
         FEn26ERfAnvpS4OdNd82IGJYl+1OJvKq50s8EQbDsiNi/0dWlLU1JUsNp29xDeGgW/ng
         t/TVu4qurByoIWZjZ/6cb88uCLFTOEDUi5WXfBuQ88h4H1aYOlQFTXRFuN12d4vSK/82
         hcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kxpv1Vy6pYbyF1BOQEj3cs5wBqi8pHepFHdqGdQ/R9M=;
        b=Ne6OTim7OacZyxe+Z6XaCb9HGcd0uQ9zi427UlcbV5FDVt8TLY6ZDPifZGDFuRoXPI
         m/1a9K/6KIOkq8LP+/ou4mDGVXPN7MvWkX0p6wfskJAu13WDdmSvQFgW4K2advHv1bCy
         JMrj0wJA4ROd7EsKL1E0Gz9LJS/PQCAnmiXyQ5dRqth4nb+k5sTUmzq5xJZbf6QY3isY
         FWMoi4bsQqZFdeXX4GQQ/ENaNIPIt1yVzoRiDyd9+w6FmJAUJ7ANKloRwDLiFcuCHcem
         v3IwiUEj0/cIpHKQ0R13woC/Yi/CCoMTSY/NRg6VUqDPCz6Ls3ziRQtBGtnxO/HhSm+C
         0k5g==
X-Gm-Message-State: AOAM532ysLtirinBgc9ZetA/IcHImRg3v51OaN20zSN+t8TNp8PfQOU+
        pJHsAjNizLpMxbwBnEBYUnViWu3F/EW9cA==
X-Google-Smtp-Source: ABdhPJx5jxuJqVl7h+NXrefCqjyk/PMZB73LL/GOidROgSIeMPukjqukX7oDQO/z+a3T9T97hl1oxA==
X-Received: by 2002:a5d:5903:: with SMTP id v3mr16644354wrd.232.1632569932758;
        Sat, 25 Sep 2021 04:38:52 -0700 (PDT)
Received: from oci-gb-a1.vcn08061408.oraclevcn.com ([2603:c020:c001:7eff:7c7:9b76:193f:d476])
        by smtp.googlemail.com with ESMTPSA id c4sm11033157wrt.23.2021.09.25.04.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 04:38:52 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] net: bgmac-platform: handle mac-address deferral
Date:   Sat, 25 Sep 2021 11:36:27 +0000
Message-Id: <20210925113628.1044111-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a replication of Christian Lamparter's "net: bgmac-bcma:
handle deferred probe error due to mac-address" patch for the
bgmac-platform driver [1].

As is the case with the bgmac-bcma driver, this change is to cover the
scenario where the MAC address cannot yet be discovered due to reliance
on an nvmem provider which is yet to be instantiated, resulting in a
random address being assigned that has to be manually overridden.

[1] https://lore.kernel.org/netdev/20210919115725.29064-1-chunkeey@gmail.com

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/ethernet/broadcom/bgmac-platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index 4ab5bf64d353..df8ff839cc62 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -192,6 +192,9 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->dma_dev = &pdev->dev;
 
 	ret = of_get_mac_address(np, bgmac->net_dev->dev_addr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+
 	if (ret)
 		dev_warn(&pdev->dev,
 			 "MAC address not present in device tree\n");
-- 
2.27.0

