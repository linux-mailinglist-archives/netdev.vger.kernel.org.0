Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BFDA215B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH2QvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:51:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56141 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfH2QvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:51:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id g207so482116wmg.5;
        Thu, 29 Aug 2019 09:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ieTbADRtT05Y0/VomMmER6T0zXu2SWOP6oz60FuDLI=;
        b=WNhqjvEGtJaeN/iWXP29s40EtlnDjloZPkf1Weo6yv2cDZA9uDgY0gLS5G5cDrZTie
         4TMjwFlS459MEVkb2W+rWT3O5koqUvY+yx32o7RaM3sWejRH/GpvXxmkwGxcsH4XaPd3
         pf8YW3nTfd5ANAtUbd734/N7b9uJ1Bi1Q9bPUdwHkvoXJ5Kq7Tr2upWaTVFiqJquLA58
         PaCmvG/5TY/KznZ1x5zLWpR4+Nmcb6EPv/NMr2R0pEGF9d5Mha2PnZdLdIUij4gvwmtk
         1Yt19Hz0rRxK3PxJ2ovNN+wp9RhwycU0IvQKE5l8Pa1d5Dvm7WmPWR+fYgft2KVXt7Ix
         Y0TQ==
X-Gm-Message-State: APjAAAWfnJaeUvhdHTOdgyoleB8p/F9xa9hq6N3G5hVwxNsmkrNsfixp
        PtRUlDJSdKX4R5CgmZTlmeLlB965
X-Google-Smtp-Source: APXvYqxstFjJ2jreH9Jsr5CvMiR/nmCdhiN/2IkdgDDXP2+2wBUQdtca9USjmS7vdn5kKVx5n4VjlQ==
X-Received: by 2002:a1c:4b0a:: with SMTP id y10mr11658200wma.78.1567097475563;
        Thu, 29 Aug 2019 09:51:15 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id o14sm8340770wrg.64.2019.08.29.09.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 09:51:15 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH v3 03/11] net/mlx5e: Remove unlikely() from WARN*() condition
Date:   Thu, 29 Aug 2019 19:50:17 +0300
Message-Id: <20190829165025.15750-3-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829165025.15750-1-efremov@linux.com>
References: <20190829165025.15750-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"unlikely(WARN_ON_ONCE(x))" is excessive. WARN_ON_ONCE() already uses
unlikely() internally.

Signed-off-by: Denis Efremov <efremov@linux.com>
Cc: Boris Pismenny <borisp@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 7833ddef0427..e5222d17df35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -408,7 +408,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
 		goto out;
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (unlikely(WARN_ON_ONCE(tls_ctx->netdev != netdev)))
+	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
 		goto err_out;
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
-- 
2.21.0

