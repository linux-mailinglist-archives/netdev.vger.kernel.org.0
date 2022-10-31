Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F70F61316C
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJaIBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaIBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:01:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A324A1B0;
        Mon, 31 Oct 2022 01:01:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5so6666472wmo.1;
        Mon, 31 Oct 2022 01:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8CNX8jzayop+Kti5FIqpzMp88MzE0hO8BrJ9pvHH71g=;
        b=mNx4KRRz+pN2Gl8FenOlMLsScGrkz7en9/rFpi5F0anT38zwStUDuPbJioC6TlrMN4
         KzSG/mJ75f9mLuKfs2E6JrPgNjFGomQ8JbvUOPLPmn3BuDLrqRAPvBEGRbHew6GrHpez
         gZOlqD9cedonHgWzZr0W6ofwqfC6d7f61Lxc+OHwkSJnaV0PvZWAc21GYRNpTHX7eOnr
         6Vg6Kkj/+yAzURuF+M3L6bSa7uZkTSBRmFVeDV8scCe27Ai78Y52W/dnnC3izmeYmA7U
         GfchKLKFHv5j6m8z1ehEsRa89Lr0MIqp1sgeIErcGTnKoop1wOEfvWFWd2RnPYwrKZxz
         m8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8CNX8jzayop+Kti5FIqpzMp88MzE0hO8BrJ9pvHH71g=;
        b=wEBxynen7BGaSAM9EAfAFKoJa9qIkte3oP4IQlt44AJ54pzFSj1LkiqnJTCxp0c8+G
         TDN0qCiNuhCsEbf5F7QF7vCZ22Ruqjc2AGBOJjTGXgNHdTf46/1WKy58TYnavkZL9Hpj
         WrQ+f5rXYWdDIgMGZlsRvoQTAXGBn0LKpL5heWyw3EbVstw/b0ugR/MxCZKi/0k2pzSX
         +RwCQ06gpkq1I4B5j6E+6qL/49Ocf5rO73K7NNCdodSishpKLzv6pn6rTBOfV5mxv+BT
         j3MP9+Ru/pLo16C7Glf2MhJNGT8z05f5n+qc9v5eUc93xZMjQ/Ca/o9eH1SazVn9dp7c
         jDiw==
X-Gm-Message-State: ACrzQf3pw4iYbt2rKBLVY9SdgEZJm3LTZ8LvgIhSqv5lYLKTgiDn95HE
        dj99KYJbgcI2ykTL+ANLP/4=
X-Google-Smtp-Source: AMsMyM7uSqMgve5Vo1MLvjOo6LdpW7emDVMT75NeNcMPog4+Vpyq+k2SsTtW6loczZLAdnRXsSq3Ug==
X-Received: by 2002:a1c:3503:0:b0:3c6:fb2a:b115 with SMTP id c3-20020a1c3503000000b003c6fb2ab115mr7166768wma.10.1667203265908;
        Mon, 31 Oct 2022 01:01:05 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id 7-20020a056000154700b00236644228besm6552880wry.40.2022.10.31.01.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 01:01:05 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: Fix spelling mistake "destoy" -> "destroy"
Date:   Mon, 31 Oct 2022 08:01:04 +0000
Message-Id: <20221031080104.773325-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
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

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index eb81759244d5..9c3dfd68f8df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -292,7 +292,7 @@ int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
 	mlx5dr_dbg_tbl_del(tbl);
 	ret = dr_table_destroy_sw_owned_tbl(tbl);
 	if (ret)
-		mlx5dr_err(tbl->dmn, "Failed to destoy sw owned table\n");
+		mlx5dr_err(tbl->dmn, "Failed to destroy sw owned table\n");
 
 	dr_table_uninit(tbl);
 
-- 
2.37.3

