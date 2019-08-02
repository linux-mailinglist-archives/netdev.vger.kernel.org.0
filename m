Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2DF7F694
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392556AbfHBMLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:11:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47035 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfHBMLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:11:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id k189so16938107pgk.13;
        Fri, 02 Aug 2019 05:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IiFdESaUeR8/Ptk86fBVa0zD7SnyT3cTX82bjeo6Ol0=;
        b=jKXCa4ur+CB/M7X8BamK5WVjN+s0l18BvPO7qhH7sXVsLDwKS0ckV0s2djfLM1aY3K
         1JbczSLl+Q/W138nZ7aPIGeN+YxrYMIMRSK5uVoQEqjQQ5Pu0UCatj2WpUTLNcJkrB2z
         vkFEKb/5AaHcDFXjf+5V58Zdl2Bz/YnzvWV5cKN6BlEo1u6mGhgcWjkoIYawq97KFhfW
         i1y+ih1VZvzFm3gRZcvPD1o6sfUsowqMljk3oja63oaa7Q9hQSRLdiwsEjSwmD8CjRi5
         fqY9KbRZQ04ONqhDOuLGTZYDbrBjQZg4rC3UuLjyiY5/tpFoE5QROTYFqi/WMgeLO55T
         KhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IiFdESaUeR8/Ptk86fBVa0zD7SnyT3cTX82bjeo6Ol0=;
        b=Kh6rf5yH6P9x2PkJjrW41tU09XPAhw5o8pDVcR2MaJJdnrzbTNH2Qvq7cEYs0CfZZN
         wSAUuHvZwM9X2+qGmUojVe+Hmc9PePK5pXPmr4rjLZLt5z6mKkSRgi7vNjvq6IZhnjnX
         fV8K6Pa3z8WwZG2PwMdWVsbs3Qncu8woL7y2QeCgG+xtpkVoHO2WdYFKdnXnEiaapa7/
         pqQsWclvArodxngcmPQ5Fcffwh7G2S04E/e5Z51V2VAqZo929bpTwQQxfJZ2H9dzqSyL
         MugvZq1+nBNpfZRFT827hPYtQQRnQD1ITCaviXgUGdOSrzfrRM3WUOXV5ntu0Ye/qeet
         kn1w==
X-Gm-Message-State: APjAAAU7LMZCcJcCFu3a44RYT9SF4jhiLOh7QaJLpdXP8QB/nWa4JKX2
        nXxln33fHndU4bz9Gkc+jwY=
X-Google-Smtp-Source: APXvYqxMXORux/aenM4EdP7s90WYQY8YOX960eUePbZWCbq3Rn9krdCfhgd4i8pngv6x5rTzAyi6tg==
X-Received: by 2002:a62:35c6:: with SMTP id c189mr59427622pfa.96.1564747860845;
        Fri, 02 Aug 2019 05:11:00 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id 64sm76484656pfe.128.2019.08.02.05.10.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:11:00 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 2/3] net/mlx5: Use refcount_() APIs
Date:   Fri,  2 Aug 2019 20:10:55 +0800
Message-Id: <20190802121055.1429-1-hslester96@gmail.com>
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

