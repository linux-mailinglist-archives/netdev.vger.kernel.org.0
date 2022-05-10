Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08E1521FE5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346619AbiEJPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347250AbiEJPwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:52:08 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6FE24595;
        Tue, 10 May 2022 08:48:09 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id y3so13831177qtn.8;
        Tue, 10 May 2022 08:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YR9pn4jX9oEu9ZPj21v5YqSNSABltP6KazwK0dihI+g=;
        b=b+d37BcnOOtc833JitSGOc7x3f2L3AE7Nf10xKLmhD4GjDgpUtUBGSvKNjCXlWoFqv
         6YzrP02ahLFBG32O0Ws+15xbHp+dOeXdYG4mz3m054dW6mc4c722EwbQ9AzX+mLaIQv4
         ESgLOi0yiR8EipW8HUqp/tAQoath61KrpL7EIRFe5NTmTAK+1Wzc8MkJakAmihyXNKk5
         JQYymdcaGhZgnIVlvXS6OESpD7BDWVMQKKwcNHxjWTXNIQ5ryfnwS9lOEAZIo6T+A9Gz
         ivAvlL2bGWw2ECqmb0qWK6tD/Dbpw/VQMsOwfpB+0Bvitw4WH0kczgxf39JrhdgbNJbK
         YL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YR9pn4jX9oEu9ZPj21v5YqSNSABltP6KazwK0dihI+g=;
        b=tzOHQMEfD0xji+InY5WoyEFQgqewNXy9B4MV+MjS8OeAgnry3O8zqzmSJHDWHReZx4
         CUmsMWv8mlRc35E6zytTWh1LfizfgHSoJcUdFBVNQOx4t/YC0fqfZxVgmQwgrFOhlJ/F
         StD/ie14Rog2kDuvEMUzWuAZuRTu8O77VyDyGTeLxw/3mKyGjN81o4UXUTj/9RM2YECD
         iXejwkQNgy1O9q+1hKi9iV9w10OBbRgrfgh8mlKY1d2jHkrO+5QRVFN61h7O4bXEq0ef
         s6D3uHatuHHQAK5Rdn1z11GJF/1/GBpeDOXlnnMk2TLzjaA3mzELPjdxks1u3MxX1VHS
         9jRg==
X-Gm-Message-State: AOAM532CYAcfP/bkUWh99K6ZBcyGYSNM7PDr58Jf6ZizJhrRil6S6Ijl
        ZrESImBNpoNWybekJbpgw1s=
X-Google-Smtp-Source: ABdhPJxFRmHP4o+KUAcl9Gzd3ONFTDwlKHVokPABxu3iBRg8vfeqO1O6Qd5Jeytf8QvM2mlUZTuU5Q==
X-Received: by 2002:a05:622a:1213:b0:2f3:a79a:2ccc with SMTP id y19-20020a05622a121300b002f3a79a2cccmr20009701qtx.376.1652197688440;
        Tue, 10 May 2022 08:48:08 -0700 (PDT)
Received: from localhost ([98.242.65.84])
        by smtp.gmail.com with ESMTPSA id h191-20020a379ec8000000b0069fc347ef5dsm8578128qke.74.2022.05.10.08.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:48:08 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH 10/22] net/mlx5e: simplify mlx5e_set_fecparam()
Date:   Tue, 10 May 2022 08:47:38 -0700
Message-Id: <20220510154750.212913-11-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510154750.212913-1-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_set_fecparam() used bitmap API to handle fecparam->fec. This is a
bad practice because ->fec is not a bitmap - it's an u32 mask.

The code wants to prevent user from passing ->fec with many modes
enables. For this purpose it's better to use MANY_BITS() macro, which
allows to avoid converting u32 to bitmap.

CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Leon Romanovsky <leon@kernel.org>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Saeed Mahameed <saeedm@nvidia.com>
CC: netdev@vger.kernel.org
CC: linux-rdma@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6e80585d731f..316cb72c4cc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1664,13 +1664,11 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	unsigned long fec_bitmap;
 	u16 fec_policy = 0;
 	int mode;
 	int err;
 
-	bitmap_from_arr32(&fec_bitmap, &fecparam->fec, sizeof(fecparam->fec) * BITS_PER_BYTE);
-	if (bitmap_weight(&fec_bitmap, ETHTOOL_FEC_LLRS_BIT + 1) > 1)
+	if (MANY_BITS(fecparam->fec))
 		return -EOPNOTSUPP;
 
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
-- 
2.32.0

