Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CDC588EA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfF0Rmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:42:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42636 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfF0Rmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:42:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id k13so1336730pgq.9;
        Thu, 27 Jun 2019 10:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OWPaAEBhAjk5F4JzNGhatrCNgFqb/Wo92Dms8qeFtZ4=;
        b=IYMzHCw1NFLgUDiufLBKvDxAuMKCWjFzY1PPyF7YXGfL2wIVK/YF+33yUcpG1u9OSB
         pXu/MXRjbjlDb2AssyGN37ZUK0PB7+d1SHJxOdiKxDZaAxI/AgYwi565mGSFf2rzZckD
         nLlQvVwCObFBoX/YaIMBMoXPNAktGrBn4TpXeQQNbQuNCiFM+mD34zhYm6Sm5y2euP9w
         rZzKkFzDmdX7SR0RC2UeIhu1Zk9iHqcSYAtZX4Cjzlnd9FqrSnJClil8ANWtDv9Pqpxj
         X9xjbtoAn+uu4T73GZPss/Ko2OELLvI28xtBWUAqi2p9shM2Dn15n6sp3d3mm7LRaqT3
         UB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OWPaAEBhAjk5F4JzNGhatrCNgFqb/Wo92Dms8qeFtZ4=;
        b=EBhgqyw+9qp9+gEEsSL7kBt6mYjMIBZA5laNy5bVuXftxmUiIBqSE4Cg3zJRXLJyvs
         VLa9lPm+4cBB6nsMPO5iKsCPFn45rFq1Z+0iVz9Rz2vB7/p+j6VCMnyG58vtNfMbMart
         LQnd+5xZv8FLntAsBOnVto0m3WQc/7R21qsbn8eHVhUbVfcD3o29zPSvZ0ITZE0f4aEj
         3gVtcRmnXLZOZT/Z6gVKxGx7UA02F8m/W7f5R/KXtL9Tw6xC/BoZ/2egd9I+N9Fjdyjs
         8ieFrDG6acuLEcIaPnf18hFID0zzikDGH8UplHZ4gxaisGPlRM7xuSTOetkBQ4l/BUIl
         8ENQ==
X-Gm-Message-State: APjAAAU3wGK11hgiGNoT5fY/JB84AaY7lvjzIU6kRgWJD5j5Bn/0d2nj
        tasN1l1Hc79MsWQsJn9nmdA=
X-Google-Smtp-Source: APXvYqzkEKqRPmNBh7vPqKbxvVFrkNE2c+K+ZaH3WGBd9kBOVasa2XMnJuRw+iBmWP74EoLEOYaNsA==
X-Received: by 2002:a65:5202:: with SMTP id o2mr4524485pgp.199.1561657373085;
        Thu, 27 Jun 2019 10:42:53 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id d4sm5121859pju.19.2019.06.27.10.42.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:42:52 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 86/87] ethernet: mellanox:mlx4: replace kmalloc and memset with kzalloc
Date:   Fri, 28 Jun 2019 01:42:45 +0800
Message-Id: <20190627174245.4877-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmalloc + memset(0) -> kzalloc

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 6c01314e87b0..f1dff5c47676 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1062,7 +1062,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	struct mlx4_qp_context *context;
 	int err = 0;
 
-	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -1073,7 +1073,6 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	}
 	qp->event = mlx4_en_sqp_event;
 
-	memset(context, 0, sizeof(*context));
 	mlx4_en_fill_qp_context(priv, ring->actual_size, ring->stride, 0, 0,
 				qpn, ring->cqn, -1, context);
 	context->db_rec_addr = cpu_to_be64(ring->wqres.db.dma);
-- 
2.11.0

