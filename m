Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A9A68AAD8
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 16:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbjBDPMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 10:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjBDPMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 10:12:12 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B69367C1
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 07:12:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h15so660094plk.12
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 07:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdepUb0Cf+NMGQp5AZtJg6+OIbVexrLKQo1VoGD0toc=;
        b=eTD1JS7yvpTUsF/oPeSB1ZtEzSe5yt0kI9p3w/laO/7Ym5UnK3aIuB5qXoSWVO97lF
         UfuQBbRPz+qnnWOPQ168hq6mRhauAHKsErkgIf/HfAvq2QnT1WMg69odzBxkKTq6xuuC
         tri/Se9hmhaN7sm+IZBIvPbIvAKOBVNuOUElaLojuZDek866NuRfTc7/gILPQPpKCU1K
         LbuGdG02hgBfRsZEp3CW7gBdLaFh0a+gtyFXCVBw16TFL71xU4cGU3QzkkHzzxAVVaRs
         xZq58GBCX1Y0F0KeHE2fOCYEZIp8RzVO3qO8jSV25TlotA8sGOGnDEm39isnTzq2XDav
         lRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdepUb0Cf+NMGQp5AZtJg6+OIbVexrLKQo1VoGD0toc=;
        b=iqld25YPa32w4LJe+pgLxuX3R5lkHf/j+rKxlmqFHRo1BVVSm44VydczEQFZaKgXBL
         5fErN0l8Ipkt3RMZ/hhYoL5zjGZpOnULLuagyAws8Fp7WEjwlcy6gfgWtwDUupFZMEKq
         Cpo8rqSPthQK2WJy8hiBE/abciHxd+t4nnNSlh7tj0ms+TlII61ec0HfoRuLrUuQpAFV
         bqfvMdp6VCCuRy4qswJv8xKTRvmbv4rg/h/5rpwt9vD2C1d8SNcJlwHIGEHUYSkTyyt3
         tuaV/g5nZ/pK9jP+dhSi6a3U4McJ22r/Z32+vxhQcL404d/EZ+cwx0FEkpqFnPvjjMtv
         2c2Q==
X-Gm-Message-State: AO0yUKXNYCsJ8nOXSSD4buzYyFGNmD+ml323L6woF0XDDb8dbWwmFkBX
        HsQk8Z8V8kxiJ+B5R5teWfD8UAvUyC4wDJ95
X-Google-Smtp-Source: AK7set9WJVhdqEyEpwmH/mzZkOUv2+9QpCIHaSJ08AeFYMx54g2aQQJIMA1rI6DFnwOofOfY6QpkXg==
X-Received: by 2002:a05:6a20:3109:b0:be:9893:fd61 with SMTP id 9-20020a056a20310900b000be9893fd61mr14226088pzf.28.1675523529240;
        Sat, 04 Feb 2023 07:12:09 -0800 (PST)
Received: from localhost ([23.129.64.145])
        by smtp.gmail.com with ESMTPSA id p4-20020a63ab04000000b00499a90cce5bsm3137095pgf.50.2023.02.04.07.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 07:12:08 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v3 2/2] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
Date:   Sat,  4 Feb 2023 17:11:39 +0200
Message-Id: <20230204151139.222900-3-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204151139.222900-1-maxtram95@gmail.com>
References: <20230204151139.222900-1-maxtram95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index ff03c43833bb..53c93d1daa7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -71,7 +71,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	if (err)
 		return err;
 
-	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, c->napi.napi_id);
 }
 
 static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-- 
2.39.1

