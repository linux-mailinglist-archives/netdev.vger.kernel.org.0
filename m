Return-Path: <netdev+bounces-10647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A4572F895
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAC841C20C23
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896E9525F;
	Wed, 14 Jun 2023 09:01:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5265681;
	Wed, 14 Jun 2023 09:01:18 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75571BE3;
	Wed, 14 Jun 2023 02:01:16 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b1acd41ad2so5275021fa.3;
        Wed, 14 Jun 2023 02:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686733275; x=1689325275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdbmDAjyIdavit0Ud8BynopPjAykxFuTm+oqG8KfGUU=;
        b=H4OL3sFwX4A1zeSBAwsfuTy5oyOVFcxQRoIbJ8VQ/lCA6CXdRNGJ0yFCkUN42MZlCG
         cOLayfWvLGmFoAtbJvU2lXEwEo+VVTkwAMJ/YUqADnFGVi61BskB5qOEYkrKDW+M4AZX
         65v6Gl1nBrAeCxIeXyRFPLyDU4DtBLvX09Zjf2IpK9vo18b+DRoC6Tts34XUzd+YKXNg
         pS4E7uJW9G/FEsJUwwpEOCmJId2r2js7RXnPzN42WLgsuCvibbx4TnDEx4+8anEQ3MJ/
         Y6LNp7w5URrHI2oIn1MBTGmvCb44gu8HIW9hGfPcxMEqLsKJ8uUNMyy5OwCdGRhnG5Xd
         TUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686733275; x=1689325275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hdbmDAjyIdavit0Ud8BynopPjAykxFuTm+oqG8KfGUU=;
        b=JAsV/9IomP1/NhZOUzh/zRecXzAHKE2JRTpJbmC2rUf2JiwuH8e1hPHyeX8r15s6Cb
         qh/QVDJA8kMFVQYuqUiPu111RLJjrtTugv6bqQXgecYR6M5JJ+OLq8pkzoN66ujRhudn
         hzsLkqD0w4a9rsAoDSvYbJm6GL26HfqS/mE1zFIlquXlPs1NHfBYU/UBTfOJ8rS9rht8
         S4RRuLwIWmM4MZ8Hgq+UX4u0wyInetDDpQIQc7P0pv3GSGhEKwiIstP/qMdWhWUnYqd5
         Lhj+nUyPfdXXWndPxYupQoNmIeDG52Q8ykJhrQmyXn8ycJIdrat/L9URdj562mED9OqR
         zSNA==
X-Gm-Message-State: AC+VfDyUv8AEM9UMgT3cAnLjTXxTmBZt3J18+sXgs/OZu+KAzs5CSCgI
	6q0xtVGnFobuhGsWXqUMtq8HjG9NC/T9XabN
X-Google-Smtp-Source: ACHHUZ7nFUaCkEnxV03Os0dohxWzIRD8T8/u80nOHmsoEmbQoU9pzV/B3lNx2SzsrKuBNRtkvJTUHQ==
X-Received: by 2002:a2e:990d:0:b0:2af:bf0d:e1c8 with SMTP id v13-20020a2e990d000000b002afbf0de1c8mr6447306lji.12.1686733274582;
        Wed, 14 Jun 2023 02:01:14 -0700 (PDT)
Received: from localhost (tor-project-exit5.dotsrc.org. [185.129.61.5])
        by smtp.gmail.com with ESMTPSA id j15-20020a2e850f000000b002ab3ea4e566sm2483799lji.58.2023.06.14.02.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:01:14 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	bpf@vger.kernel.org,
	Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net-next v4 2/2] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
Date: Wed, 14 Jun 2023 12:00:06 +0300
Message-ID: <20230614090006.594909-3-maxtram95@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230614090006.594909-1-maxtram95@gmail.com>
References: <20230614090006.594909-1-maxtram95@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The cited commit missed setting napi_id on XSK RQs, it only affected
regular RQs. Add the missing part to support socket busy polling on XSK
RQs.

Fixes: a2740f529da2 ("net/mlx5e: xsk: Set napi_id to support busy polling")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index ed279f450976..36826b582484 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -86,7 +86,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	if (err)
 		return err;
 
-	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, c->napi.napi_id);
 }
 
 static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-- 
2.41.0


