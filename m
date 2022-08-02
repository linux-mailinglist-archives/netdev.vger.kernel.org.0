Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757D458782D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 09:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiHBHrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 03:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiHBHro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 03:47:44 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C311707F;
        Tue,  2 Aug 2022 00:47:42 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b4so2679902pji.4;
        Tue, 02 Aug 2022 00:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=6asRODmKw6yxS4ioTuMFP/4VNFqB0bV8/bgYU9lk6AA=;
        b=IgvVa6aZOCwu+xsnzkqGLYwWryfk8JepZYVKz7P7apzXy4OqmUkaYlGCGHgY/q9ye/
         72Pp8JiXLfWU0tgRpL3YOrgeB0WZ2qe6QfTUIWtG9ItsjuQsD3qRj8vxxUztJBu93Kin
         1B1yCoYGr7dlTQ9e2/TKKDOF8jwPRfJ5w+W1RFDSbnk1+CSIWOACsUbQt6tfjdh93DI0
         mCNl7YVa9Ky0Gz0YAK7kg2Lgf/LtyUjRGj/9rDH485hIguHI8g4y0LrGBrtAtFJmM36A
         TzKLxQKtY6PO0PcR2teQ+oYeTg+1LglU0JWa5mnBoIFgrxdUszwczJLjDjsvZ8VEDxwY
         H+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=6asRODmKw6yxS4ioTuMFP/4VNFqB0bV8/bgYU9lk6AA=;
        b=Yjh/odyuWut3qG57aNiJA/McWwrCDSR7L7a4kc5FEScP2cQOn40SlVvCksZ850UqUt
         Uo67iVhcz1ZQr0IPritXOw5/SCwBiCx8oaR9XDSPNPp4SRZ1BGrWd6S7zam2POYC/ELW
         jouo7fvihVEcfpigkDgdWUZ5ZEzGvl4Mj8PNTvMLAHrpZxqJHYuAPTIgXd3JPRjl24xx
         O42NVd/iHTlG09SBuQu5QT/X1nFqNd7jtdVHDiJcbf9JAtcgsg3WnigChpH3gV1KsFAC
         OHakbml9QL0x78NltXiORuNb2N9rcw/qGUNYIm2q7EzGyO+AQ5j++8ZnRyMvPp5NBXk1
         /vuw==
X-Gm-Message-State: ACgBeo01kaNdDr5f8u0hUDW3OalYOPx6g/SKqyqJ8kScOqsywISuXQVi
        c1UoNZ8GvLEwOH+C81xKrXW2F6aRmCQ=
X-Google-Smtp-Source: AA6agR5TSJ++0nQD3vWSqQ1mPdnuwR+HvgJk4ZNTeEjLxb7wus3tfz5ZoHlpfLjEqcWTUl2be2KgFw==
X-Received: by 2002:a17:902:ea07:b0:16e:daf6:6087 with SMTP id s7-20020a170902ea0700b0016edaf66087mr12024306plg.68.1659426461966;
        Tue, 02 Aug 2022 00:47:41 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p1-20020a170902e74100b0016bcc35000asm10866845plf.302.2022.08.02.00.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 00:47:41 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net: ethernet: ti:using the pm_runtime_resume_and_get  to simplify the code Using pm_runtime_resume_and_get() to instade of  pm_runtime_get_sync and pm_runtime_put_noidle.
Date:   Tue,  2 Aug 2022 07:47:37 +0000
Message-Id: <20220802074737.1648723-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/ethernet/ti/cpsw_priv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 758295c898ac..abe5b65de415 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1539,9 +1539,8 @@ static int cpsw_qos_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	if (!tc_cls_can_offload_and_chain0(priv->ndev, type_data))
 		return -EOPNOTSUPP;
 
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(priv->dev);
 		return ret;
 	}
 
-- 
2.25.1
