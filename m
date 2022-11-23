Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD186635A77
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbiKWKqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiKWKqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:46:06 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF1110FEE4;
        Wed, 23 Nov 2022 02:33:34 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id x17so15253406wrn.6;
        Wed, 23 Nov 2022 02:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OqSAHENsP2Eu+k3T6lfgmaN20FBPw3RANOCBpU5sGY=;
        b=GhTJSHSNMn1LSkt5XAIirYA0GPUA9wmRL7L897xAkRyovmoeA5oKzMqtiCG8e9MKeN
         DwuH7xPWG2gTrNaEStYB107xVh+/tH8yIqg+60fHiyylngxIFxvavQuAAiQ/gXR8powy
         ja4PWp4wavYUPrKLM4VLb7NdO4I9YkUMevz4j7ACzMwJnN6TZ7HFfJC3u4mc28A1U/iS
         vxg6yd1m2+yqRnSFOGEwU5z+/6ZI+IPYT4awd7F1Box3TfVaJ3o0rphSFiOOSk/JWAVD
         6Lr+LFhjGziY4otzt+S2RCnk4SiTFAuha7bV5GXb5nHSSjfXVUmvF/QTza5W+q+VagCr
         BoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+OqSAHENsP2Eu+k3T6lfgmaN20FBPw3RANOCBpU5sGY=;
        b=68NC5Qhq9uZ8P8Y6yHdQhzeXSjJQI2OqFr6mJp22a2klMPN+SqOutuzAqZlDLoYfE/
         wN2OoKRe4z6jqDVA+azAN3RTXsNT9Czjh5sTYUH0eIzR1KYvI/Jz3UV6/tD8fbtZD5OL
         Oq2FmULyuCmmvsfLWTnv/cgmaxTPTg2FCz8iD3X/WdX9huOxrM/vJj6+Ve1r1lfBZJFw
         ZdNbXjHky+8ROF815rX43jUYOcH1RN5JfrhMf4N5OQnOHNa8Os2gJlHhyX50vcDTekRt
         bUrXfkDG32dTz0+tJMqpn7sU01EolQt0n9BTFAf+b4SPHb3zChs5/gwwCGeZNkRUBUN2
         tGrw==
X-Gm-Message-State: ANoB5plg8CKBZMvcVImEpmXQkWp2tGu5u1MIUP87mMprAa0ZXIfPi4WZ
        iv62mNGcZnsyqcWXNYC0wLw=
X-Google-Smtp-Source: AA0mqf67+7Gm4xBpd33mmNGuvLu7YiooVfeAVPs6SZjz+EPNiDTk4OC5/lxTyoCQ+JYbI2Q7RmUpDg==
X-Received: by 2002:a5d:4f85:0:b0:22e:35f4:9182 with SMTP id d5-20020a5d4f85000000b0022e35f49182mr4585712wru.121.1669199604715;
        Wed, 23 Nov 2022 02:33:24 -0800 (PST)
Received: from felia.fritz.box (200116b826997500d517ac74edd630a9.dip.versatel-1u1.de. [2001:16b8:2699:7500:d517:ac74:edd6:30a9])
        by smtp.gmail.com with ESMTPSA id p37-20020a05600c1da500b003cf4eac8e80sm2158191wms.23.2022.11.23.02.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 02:33:24 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] qed: avoid defines prefixed with CONFIG
Date:   Wed, 23 Nov 2022 11:33:05 +0100
Message-Id: <20221123103305.9083-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defines prefixed with "CONFIG" should be limited to proper Kconfig options,
that are introduced in a Kconfig file.

Here, constants for bitmap indices of some configs are defined and these
defines begin with the config's name, and are suffixed with BITMAP_IDX.

To avoid defines prefixed with "CONFIG", name these constants
BITMAP_IDX_FOR_CONFIG_XYZ instead of CONFIG_XYZ_BITMAP_IDX.

No functional change.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 9fb1fa479d4b..16e6bd466143 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -767,34 +767,34 @@ static int qed_mcp_cancel_load_req(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
-#define CONFIG_QEDE_BITMAP_IDX		BIT(0)
-#define CONFIG_QED_SRIOV_BITMAP_IDX	BIT(1)
-#define CONFIG_QEDR_BITMAP_IDX		BIT(2)
-#define CONFIG_QEDF_BITMAP_IDX		BIT(4)
-#define CONFIG_QEDI_BITMAP_IDX		BIT(5)
-#define CONFIG_QED_LL2_BITMAP_IDX	BIT(6)
+#define BITMAP_IDX_FOR_CONFIG_QEDE	BIT(0)
+#define BITMAP_IDX_FOR_CONFIG_QED_SRIOV	BIT(1)
+#define BITMAP_IDX_FOR_CONFIG_QEDR	BIT(2)
+#define BITMAP_IDX_FOR_CONFIG_QEDF	BIT(4)
+#define BITMAP_IDX_FOR_CONFIG_QEDI	BIT(5)
+#define BITMAP_IDX_FOR_CONFIG_QED_LL2	BIT(6)
 
 static u32 qed_get_config_bitmap(void)
 {
 	u32 config_bitmap = 0x0;
 
 	if (IS_ENABLED(CONFIG_QEDE))
-		config_bitmap |= CONFIG_QEDE_BITMAP_IDX;
+		config_bitmap |= BITMAP_IDX_FOR_CONFIG_QEDE;
 
 	if (IS_ENABLED(CONFIG_QED_SRIOV))
-		config_bitmap |= CONFIG_QED_SRIOV_BITMAP_IDX;
+		config_bitmap |= BITMAP_IDX_FOR_CONFIG_QED_SRIOV;
 
 	if (IS_ENABLED(CONFIG_QED_RDMA))
-		config_bitmap |= CONFIG_QEDR_BITMAP_IDX;
+		config_bitmap |= BITMAP_IDX_FOR_CONFIG_QEDR;
 
 	if (IS_ENABLED(CONFIG_QED_FCOE))
-		config_bitmap |= CONFIG_QEDF_BITMAP_IDX;
+		config_bitmap |= BITMAP_IDX_FOR_CONFIG_QEDF;
 
 	if (IS_ENABLED(CONFIG_QED_ISCSI))
-		config_bitmap |= CONFIG_QEDI_BITMAP_IDX;
+		config_bitmap |= BITMAP_IDX_FOR_CONFIG_QEDI;
 
 	if (IS_ENABLED(CONFIG_QED_LL2))
-		config_bitmap |= CONFIG_QED_LL2_BITMAP_IDX;
+		config_bitmap |= BITMAP_IDX_FOR_CONFIG_QED_LL2;
 
 	return config_bitmap;
 }
-- 
2.17.1

