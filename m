Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8E645C22
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiLGOMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiLGOMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:12:45 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F62430547
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:12:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f11-20020a5b01cb000000b0070374b66537so5103877ybp.14
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0Y6R8MJmFOTORaqeUXjZKoyrZuFPm8b7UShjzzFan0=;
        b=jndSP6lWO+TkuSBRJNopdk90z69DoB9ZweoDe6KJogaEjcGqVzqXxGaN/mDzare91p
         SaCXJ3yxx74S+dZB7GVQTYyuzg82ZhF7rplQkyfZCPK+pNyeF47q6wECxY8Om9FzTJJV
         FlOgICWuiZySYUHERTcfRHs1YRD1RTTTaAeBMtToK5mrzCy0+JN1t/x2yBsb4eYYJp/S
         4wCvS/cD61JtgeaI5pU9FZ/LKEUqlOyajWoPhhZz7PnnKS4BrdhSbmPwP/oZPrsBbBS1
         pTRPpbZbK90UsgptCd4CRBihqaJsEfqb/NXq4hvHewOCDP+UUcJ/tzPTztVUN4qrdprx
         zUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0Y6R8MJmFOTORaqeUXjZKoyrZuFPm8b7UShjzzFan0=;
        b=XAdy1HeRxq1eJlraDNsOxawu83aneisSSxEGR8tASZEaJ4RhVKIbzO7/3bRkriX0nI
         KBdvHJ3EEDhU3HiO/PvmJZvoK7bvaJmN4Q57PvbXLq8zY4KkJJ4HjphWGaxcW+Z3nezw
         WYKTbCM4PRCbq1JT0US4fanDd4SaljGCsRIz4qlHzF5DTM3sf+Ejb/OEPPUToLizUKij
         u7WTzCT9oszm7brwsUAkud9fbJxe1Yaycf7ZKWhJKIYJdlXOyyQRh33oKjnumcCWpXO8
         JXkeHNmtwogCMq1VGkrMH49IKjk2Y3uz0rbct2EdneLLmTBHnZ7KzNsYxQEK0wRzlkmQ
         L4ZQ==
X-Gm-Message-State: ANoB5pkIE8Xa1Xzmio4x9z95DVK4dB5pGUH0kl0KlybroQl7IC0ACt/Q
        B/xasZvyJIddXB25pmxwkUyx7LZYLx1VCQ==
X-Google-Smtp-Source: AA0mqf4Zxnmkhs19p/sUIasx7lsU3rjOjRNFfhUuABNknGaolJiu/ayMr0IvAmIl2mXHw9moN5DBScxj8X62xw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:4e:0:b0:701:823f:4098 with SMTP id
 e14-20020a5b004e000000b00701823f4098mr12086395ybp.37.1670422363497; Wed, 07
 Dec 2022 06:12:43 -0800 (PST)
Date:   Wed,  7 Dec 2022 14:12:36 +0000
In-Reply-To: <20221207141237.2575012-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221207141237.2575012-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221207141237.2575012-3-edumazet@google.com>
Subject: [PATCH v2 net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends
 on MAX_SKB_FRAGS
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Google production kernel has increased MAX_SKB_FRAGS to 45
for BIG-TCP rollout.

Unfortunately mlx4 TX bounce buffer is not big enough whenever
an skb has up to 45 page fragments.

This can happen often with TCP TX zero copy, as one frag usually
holds 4096 bytes of payload (order-0 page).

Tested:
 Kernel built with MAX_SKB_FRAGS=45
 ip link set dev eth0 gso_max_size 185000
 netperf -t TCP_SENDFILE

I made sure that "ethtool -G eth0 tx 64" was properly working,
ring->full_size being set to 15.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Wei Wang <weiwan@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 7cc288db2a64f75ffe64882e3c25b90715e68855..3d4226ddba5e6582e9420d853b6535b806219e55 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -89,8 +89,18 @@
 #define MLX4_EN_FILTER_HASH_SHIFT 4
 #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
 
-/* Typical TSO descriptor with 16 gather entries is 352 bytes... */
-#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
+#define CTRL_SIZE	sizeof(struct mlx4_wqe_ctrl_seg)
+#define DS_SIZE		sizeof(struct mlx4_wqe_data_seg)
+
+/* Maximal size of the bounce buffer:
+ * 256 bytes for LSO headers.
+ * CTRL_SIZE for control desc.
+ * DS_SIZE if skb->head contains some payload.
+ * MAX_SKB_FRAGS frags.
+ */
+#define MLX4_TX_BOUNCE_BUFFER_SIZE \
+	ALIGN(256 + CTRL_SIZE + DS_SIZE + MAX_SKB_FRAGS * DS_SIZE, TXBB_SIZE)
+
 #define MLX4_MAX_DESC_TXBBS	   (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
 
 /*
@@ -217,9 +227,7 @@ struct mlx4_en_tx_info {
 
 
 #define MLX4_EN_BIT_DESC_OWN	0x80000000
-#define CTRL_SIZE	sizeof(struct mlx4_wqe_ctrl_seg)
 #define MLX4_EN_MEMTYPE_PAD	0x100
-#define DS_SIZE		sizeof(struct mlx4_wqe_data_seg)
 
 
 struct mlx4_en_tx_desc {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

