Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F073153CAB1
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 15:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbiFCNcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 09:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiFCNct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 09:32:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1396324;
        Fri,  3 Jun 2022 06:32:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e11so7196339pfj.5;
        Fri, 03 Jun 2022 06:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ECC1+okgsMaiWvHxJAvUSB9hG1Q5Ly0yeqZYvfrES/8=;
        b=RIWLo7064YQ/76wZkg6f2CO99pIe7brrz3E4IN/MuMvlgFJRzEV6Uxfft3kWIf+kTa
         NmoNPC7cacJIoKHkaQHznvER7Fa54zd25kYDLax7rnsWjn1kQQOi+s604sJYiUDfaDRB
         NwrjJBl0Cq+l6+Rg5s2ZHs1F/0Xru3teb5zNC2VndgT7QCYylCux78ggf6xUBSRppr0A
         LUPPDTelEygHSSGWIv2RaVdytrgFcBnZgOUwLwQcI2Cl8lVxNXH3DuYHfpVkWDF7DI6C
         nc2WQvKUX3x7FAnlzAUgPc8Td4rG7O+wetkL9WgsVUqykRy2CaqlRuaiR86s8wlouGVz
         DT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ECC1+okgsMaiWvHxJAvUSB9hG1Q5Ly0yeqZYvfrES/8=;
        b=ga7ZEPWHkd9hb8YlV3w+CG/nM22HgXUABbG2mfq5gKVqL8gh19b/LexQpjMwzLaSPv
         rDKjHAcpP83Ho+0HotVS1cMfcC8rT2L4SNPEZ7djOlf2fNf/jZR2cPn1NX7LEzoM7YJ9
         oKKIitMM6vmaD6ny4liXCshHQP+Pr8OmAaC+c4TslomM4ewrFlcuTvNGX/ZiOd+cRbjI
         lXkZuiaCd7aZsKqUUQEYB+J4WVI4nlKzzYMMTHeXlL8zhcBua98QBmJshTsmFZ08/2zu
         ni4xKfzaWf8U2U/esx1ZZAX+veEn/RAuIZ+wG+yPvOwTODH6h2kjXbsZkhCUKIxurzEm
         MxSA==
X-Gm-Message-State: AOAM533iiujKztNVh9sulviyAICYcA8/T1FXmdfSf4K5OSgNIjL3wqHC
        Jjqk911ljnqy/jqhCkUNgHc=
X-Google-Smtp-Source: ABdhPJyXLt4vvfEg8t4R8Pv9RjRFHaE6pAdqXmSydDh4o7v1KuU5NSRdzN9aVudkXFRZO9x63zoZ4g==
X-Received: by 2002:a65:52cd:0:b0:3f5:f3fb:6780 with SMTP id z13-20020a6552cd000000b003f5f3fb6780mr9219011pgp.150.1654263168130;
        Fri, 03 Jun 2022 06:32:48 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id t15-20020a1709028c8f00b00163d4dc6e95sm5334767plo.307.2022.06.03.06.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 06:32:47 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH v2] net: ethernet: bgmac: Fix refcount leak in bcma_mdio_mii_register
Date:   Fri,  3 Jun 2022 17:32:38 +0400
Message-Id: <20220603133238.44114-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 55954f3bfdac ("net: ethernet: bgmac: move BCMA MDIO Phy code into a separate file")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
changes in v2:
- update Fixes tag.
v1 Link: https://lore.kernel.org/r/20220602133629.35528-1-linmq006@gmail.com
---
 drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
index 086739e4f40a..9b83d5361699 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
@@ -234,6 +234,7 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
 	np = of_get_child_by_name(core->dev.of_node, "mdio");
 
 	err = of_mdiobus_register(mii_bus, np);
+	of_node_put(np);
 	if (err) {
 		dev_err(&core->dev, "Registration of mii bus failed\n");
 		goto err_free_bus;
-- 
2.25.1

