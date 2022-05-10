Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B627E522001
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346680AbiEJPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiEJPwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:52:13 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D8B27FE4;
        Tue, 10 May 2022 08:48:15 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id fu47so13827619qtb.5;
        Tue, 10 May 2022 08:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yb/F6YFHx8jMmT8NzFo+iYOEgGU08YViXeElbI3tjgc=;
        b=MMnXS3xA1tmydR2qCDMamehnHI5FTZPQnT0YdSBT4isID4m9dejiQqAVaASciKXh2t
         uNvjLP9M1SpNR4L9suFWs2GB3zj0kW6tIw+HGOGD0qgwx94I6AWsORwzqjwEJ0Yw8Lon
         SHAjLcmqVRiNW8qsl5AfmJNSQJxIMdeX/5OhcZCWobvLe1G4TOlSiS1f4gQUkC3AyewE
         s/5zKTm6e85HXpPxzZGWWHF7kuC8kNjOOFMOLzuI6valozkPvbjyLJR/echRLonbSXes
         Vef44tpvYg2wXOOhFuE8RU0X4TxNWG/udFq3Emz7Cl/FRJe4tXgux0zhuZj3kBgh3jZD
         9N3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yb/F6YFHx8jMmT8NzFo+iYOEgGU08YViXeElbI3tjgc=;
        b=76KRrIAfArRUp4oHOH+q8Q1eCGeF4C0taImlIGbukwMIGyjKwxuWpkklPgrT/kuhc5
         yJPlwBiUUp3BfXD23HIutJPzok2gMTbXuAj4TuMCfatte54JKnaTs071rCvslAIwfiXs
         GjRWKXwZFo9LmnbeHU8EjetkITZw7XCvp42ZLbB3JLqyzZzL1+DB9cnrgumfFfx3XEFu
         81YqUvKwGGgrNZyCzo6JE1EVaALx3h+bAiMXJl4CHM1eEt9COp5aKE8QD4F5RSCIpWXf
         x+OskF7rVUhA5bp/XIPd8YDkylrloaraa3kfMW70URozjbjLZN88Y0WDdn4hP1GoV2s2
         ZjHQ==
X-Gm-Message-State: AOAM530b7Dwz3XLIq9adoT9BAqCT1884OEYOjet/Y45Lk+w3lWs23hnH
        poNcC8IgoVBlCZE81XbzsAg=
X-Google-Smtp-Source: ABdhPJwV70hoAcYnRzaFrPNRGD//htdKIyrvhMG9B5O5rgnhDgAUf7COuLmQzmUbet3XQOUvrJCg2A==
X-Received: by 2002:a05:622a:93:b0:2f3:c4ef:6c71 with SMTP id o19-20020a05622a009300b002f3c4ef6c71mr19568082qtw.505.1652197694757;
        Tue, 10 May 2022 08:48:14 -0700 (PDT)
Received: from localhost ([98.242.65.84])
        by smtp.gmail.com with ESMTPSA id c2-20020ac80542000000b002f39b99f67bsm9312717qth.21.2022.05.10.08.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:48:14 -0700 (PDT)
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
Subject: [PATCH 15/22] net/mlx5: use cpumask_weight_gt() in irq_pool_request_irq()
Date:   Tue, 10 May 2022 08:47:43 -0700
Message-Id: <20220510154750.212913-16-yury.norov@gmail.com>
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

cpumask_weight_gt() is more efficient because it may stop traversing
cpumask depending on condition.

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
 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 380a208ab137..d57f804ee934 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -58,7 +58,7 @@ irq_pool_request_irq(struct mlx5_irq_pool *pool, const struct cpumask *req_mask)
 	if (err)
 		return ERR_PTR(err);
 	if (pool->irqs_per_cpu) {
-		if (cpumask_weight(req_mask) > 1)
+		if (cpumask_weight_gt(req_mask, 1))
 			/* if req_mask contain more then one CPU, set the least loadad CPU
 			 * of req_mask
 			 */
-- 
2.32.0

