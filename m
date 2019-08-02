Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46C27FF83
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404843AbfHBRX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:23:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39833 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404689AbfHBRX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:23:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so32371807pfn.6;
        Fri, 02 Aug 2019 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IiFdESaUeR8/Ptk86fBVa0zD7SnyT3cTX82bjeo6Ol0=;
        b=brRD9VUfVprfoKVw39JcxhHxnZ5uiaFGhGBtMEOjj1lGgrPCGCOW0xLlY8eUmDfrOl
         2cRjRMHZnIZcqBkkZdIAyEmzuNsdtztnXoaUCSyUgPCMG76pr9J6lnm0Iydmv7wkYvNL
         gxwLOye8AZYOOPKM5T2Voo0yrtueys71pDC8jIPg10pWxMqyQ6uTl5Qx4EUVodSeDxAY
         IyFX6lhbCNzpbnedabLXRHUiXi0RsKx1gveq8GztkFiO5L3o1kS5Q4qVfQb69sqiSYii
         NWikHh3OtcTrRzqZaFbSVsi+IljHi+qhAvFLJzC7v0h8QaYNTRHNfhnmjzJ02TQUj+e2
         swbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IiFdESaUeR8/Ptk86fBVa0zD7SnyT3cTX82bjeo6Ol0=;
        b=mfv5InOKEgY4ejFL6bhzwbTmY3tD7pp6I+GLg/i0saLiQ93KgRTx8TQzfS92sIgJkb
         uQjnEIUOnPWiBl8REz3L+0jv20rzd0nHgCp+0l8MDs4GjAEiJXlovhkabDgdEz8Tp2tH
         U7O6hhIbkPUvrYWx1hHeP+Kvu04vMfWGtztecjWsJBmdQ7fSHJJnwfplitz6gNVVnOIA
         Nz730wrN/DmoyIklgGJymV01fk/NDOghiJFhynUYlPBKqgr9+Vh/zdmIEUmdDEzdSwLi
         Wbf2bdHuLAf3ni5pGGvEMMShjdLWK2tvN2VHafcfnL9TrwcSbZtgpz6nQJWUhlvRsuUd
         Op5A==
X-Gm-Message-State: APjAAAVFuB5J24XD47xgZwyAS0g/g5d1u6lsXmAwop3RWsKWK0oVjply
        D7uIbPavA2mCI+BYIuUMeG0=
X-Google-Smtp-Source: APXvYqzxLk+xg1WGHKPow+LANtxdkTGTCr18/+AWrS0GAUBNFtj19jioym6IDb6uBS05TY6VLbL/yg==
X-Received: by 2002:aa7:86cc:: with SMTP id h12mr53717965pfo.2.1564766636527;
        Fri, 02 Aug 2019 10:23:56 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id w197sm96665552pfd.41.2019.08.02.10.23.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:23:55 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 2/3] net/mlx5: Use refcount_() APIs
Date:   Sat,  3 Aug 2019 01:23:51 +0800
Message-Id: <20190802172351.8413-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch depends on PATCH 1/3.

After converting refcount to refcount_t, use
refcount_() APIs to operate it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index b8ba74de9555..7b44d1e49604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -53,7 +53,7 @@ mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 
 	common = radix_tree_lookup(&table->tree, rsn);
 	if (common)
-		atomic_inc(&common->refcount);
+		refcount_inc(&common->refcount);
 
 	spin_unlock_irqrestore(&table->lock, flags);
 
@@ -62,7 +62,7 @@ mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common)
 {
-	if (atomic_dec_and_test(&common->refcount))
+	if (refcount_dec_and_test(&common->refcount))
 		complete(&common->free);
 }
 
@@ -209,7 +209,7 @@ static int create_resource_common(struct mlx5_core_dev *dev,
 	if (err)
 		return err;
 
-	atomic_set(&qp->common.refcount, 1);
+	refcount_set(&qp->common.refcount, 1);
 	init_completion(&qp->common.free);
 	qp->pid = current->pid;
 
-- 
2.20.1

