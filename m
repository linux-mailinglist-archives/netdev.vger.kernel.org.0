Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5795EE924
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 00:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiI1WIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 18:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiI1WH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 18:07:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D63FAF0EB;
        Wed, 28 Sep 2022 15:07:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so1731677wmq.1;
        Wed, 28 Sep 2022 15:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=iuT26ScGvRggN3peNOuf2lq9UIzLkSCceSdt7cOIh94=;
        b=qzAajm8ofrzy4fUaHbU1aSX8zXd06RoBr4GNIboWOY/5hVss3kW8bErysP6SeMzsCb
         AM3fbzLpcs0j0xBHTGfPVZc2kQEIDkIKD/vCmq9khibI3fyiRs29FUO8Xn+rhZhB/GC1
         ALrg65acn5y+fk6QzpKFTCwkTtlLLrH23Ddl9F5d89HncQLcxcTCHDyxfGhb2SpNwubR
         9mmHrIVPGCJ1tcZRpdrf5r4kVH2ys4wdOGI6Wu2006Y5Xppp6F4pbVp7vTi1ojSARwgY
         HQvGvzz6v/uLaixVw5Jvaz7qzyGJzsd/QTz5jwECVS7Hzp5oxNUbQtWBmqtCx6t1z68b
         dwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=iuT26ScGvRggN3peNOuf2lq9UIzLkSCceSdt7cOIh94=;
        b=VV265+yr41tZcqwC2ouDtqTBc81h7oOcCrFA5cGZWmfGkbSbHS5cShl/FKTFIVH7zX
         yJvVZkiSHgAekyRn5GCUa+if7iVPupQL3++ByBgFosiNyErnQRuSiCBWgilxQahrIdtb
         nPJBK08xURHeDbaqpL/YhU99WIjbtXI3e9/E30Wt04wGNpSJavHKrq2i4K5DYraE5Vin
         UXDTElro+L6Ub2TomN/J+BnqiQ1R2LYRvgTJ1fWgiyO5ZUy+DHEA6hUOU1UnltTqNwiq
         Asv5k7p7zHuvPz9KyAfSwC2sb72VlUCsHiO8yFnaJ6SpnlySi+lwc1+ZP2KVQdo5NVHM
         qamg==
X-Gm-Message-State: ACrzQf0BaiIveWYHfL9dML06tUHjJlwvtZ1RBJM2sN4Q5JCAxNGKfKN6
        kpXL2IEGcBKE0GFR8LuGAb2amGEewxyP+A==
X-Google-Smtp-Source: AMsMyM58agWNgDZUGNIkFEif92ZBKQAeoDyl3w1bfZ6cJIvaOmRe89aYUpInFdhwTG2uU5ccbBnjkg==
X-Received: by 2002:a05:600c:27d1:b0:3b4:5e9c:23ed with SMTP id l17-20020a05600c27d100b003b45e9c23edmr85780wmb.180.1664402876830;
        Wed, 28 Sep 2022 15:07:56 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l17-20020a05600c4f1100b003b4ff30e566sm558010wmq.3.2022.09.28.15.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:07:56 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: Fix spelling mistake "syndrom" -> "syndrome"
Date:   Wed, 28 Sep 2022 23:07:55 +0100
Message-Id: <20220928220755.67137-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

There is a spelling mistake in a devlink_health_report message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index b7ef891836f0..59205ba2ef7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -601,7 +601,7 @@ static void mlx5_fw_reporter_err_work(struct work_struct *work)
 	fw_reporter_ctx.miss_counter = health->miss_counter;
 	if (fw_reporter_ctx.err_synd) {
 		devlink_health_report(health->fw_reporter,
-				      "FW syndrom reported", &fw_reporter_ctx);
+				      "FW syndrome reported", &fw_reporter_ctx);
 		return;
 	}
 	if (fw_reporter_ctx.miss_counter)
-- 
2.37.1

