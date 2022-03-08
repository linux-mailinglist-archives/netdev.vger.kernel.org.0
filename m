Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3A84D0E1D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 03:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiCHCsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 21:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiCHCsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 21:48:52 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582F61D333;
        Mon,  7 Mar 2022 18:47:57 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 9so15800345pll.6;
        Mon, 07 Mar 2022 18:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=9+rs02y8/agiJlSLF4WllYH2sVrI0f+W4mxvW+9rYxo=;
        b=kOsYCvCHrcNK69cLsdd1syJuU5VrntMM29u88/Zofjp5wZ0p+JUKmRoTVMQuCXa5EP
         x1EAnf6nugh/jSQbzGEpRJSiSnJ8p5qzUNZGg0qMKgKo4evf+xy9phi/bG+nTb474El6
         me7DarfDNuPG88ioy57rONUHHnJ1DO9/oQYWGcR/nFSrW/SPhT98Hv7xM+CDvqhFgqZw
         r4THfZcgwMDAL5lXLSV3ZTVK3bdKNkr/p/XNktZfJ5m3tCfQwogJiyKzdCd3tnEX3bNX
         8qAeFmGjbb+94ETj4VE+pKUAt6AAZH+lBipxMNlk0Q+yP58CoYhhqoYwgukRW9SE288c
         2DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=9+rs02y8/agiJlSLF4WllYH2sVrI0f+W4mxvW+9rYxo=;
        b=MCC10rLY73dGPOr+UZ50gckzpI3N4kKHSjZG13Q2aQNB/V1aXUJQpSKRmLHfX15j9o
         ZYwJuBrhczNBrdrsODleLveR0LPMc3C60ZIKpo9AuE7spynJMa1xJdgiFGZFzryYvKSL
         sKJu3PNaknaIRd9P/Egrw0ZGwpu6rczdn+fUH2ag/TM+BuuUoHIr8a7auOeiILNy2Cq/
         tPng7FxUQe0OAlsPjnNuYeeomNc2/42Kb1X+YmgYndmFYasKw5UcbuU7NkeBMifKTiNW
         78iR6W7ZNNZYfm3dLLMGxzBjSbS+IWaEZvQGR9TnoZrdmRT6DBVvkXxo0AO2BsO+CZTX
         4kYQ==
X-Gm-Message-State: AOAM532OYVVfOWK1cc3dZswl+NASfygFI2idb/GRRCuQ1HDpJIgYw6oc
        nC3xh4BrNCbKay4zKzQP3Y4=
X-Google-Smtp-Source: ABdhPJx5sigmWo+hcAj/lrzhaaBiN7D4kgyoa0sNOMynzTneLnudVl/LjKzXJwdeyHer4Chiqm1Bdg==
X-Received: by 2002:a17:902:e2c3:b0:151:d68e:cd0c with SMTP id l3-20020a170902e2c300b00151d68ecd0cmr13249158plc.69.1646707676850;
        Mon, 07 Mar 2022 18:47:56 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id g18-20020a62e312000000b004f6fe0f4cf2sm5565404pfh.102.2022.03.07.18.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 18:47:56 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Miaoqian Lin <linmq006@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        YueHaibing <yuehaibing@huawei.com>,
        John Linn <john.linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sadanand Mutyala <Sadanand.Mutyala@xilinx.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: Fix error handling in xemaclite_of_probe
Date:   Tue,  8 Mar 2022 02:47:49 +0000
Message-Id: <20220308024751.2320-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This node pointer is returned by of_parse_phandle() with refcount
incremented in this function. Calling of_node_put() to avoid the
refcount leak. As the remove function do.

Fixes: 5cdaaa12866e ("net: emaclite: adding MDIO and phy lib support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 519599480b15..77fa2cb03aca 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1183,7 +1183,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	if (rc) {
 		dev_err(dev,
 			"Cannot register network device, aborting\n");
-		goto error;
+		goto put_node;
 	}
 
 	dev_info(dev,
@@ -1191,6 +1191,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 		 (unsigned long __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
+put_node:
+	of_node_put(lp->phy_node);
 error:
 	free_netdev(ndev);
 	return rc;
-- 
2.17.1

