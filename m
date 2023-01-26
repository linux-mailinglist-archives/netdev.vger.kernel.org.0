Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB74267D522
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjAZTLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjAZTLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:11:24 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C5147ED3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:11:22 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id rl14so7822250ejb.2
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tqYThsEyvBfa4vP3pF/e7lpGtERv1Meo65M4KPES54=;
        b=LY1K/H+roSDpJnEDZsYoMumJxlvzjhB1n5mpWknN5lPHCSRg3u2+r4uWZwk85arJrv
         eDvd9uIaMcswVsVHNyYq+eWx94Nmw6ZsUCt2PPw4n5O6sRbMx9qNmPky1sWDgaJKJGy8
         LlzrOfHDCXWddPMVZjtWsblw4zF22QvkgJgJIb5eVF2byWjKXRIEKf8CuMNYr/dCydbb
         nUdSFrauc2hF/SqoO+mlPXOHiK1biybmvxW50najYveDH9nw4LGVxCRoZCDTaln5dSVs
         GLKrtvfa76Ofk3JkRqxVi04yiktbFZ1MKtWxiUNUQEhHJlZriz8c1FcP0nxOXdrqDWQU
         KB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5tqYThsEyvBfa4vP3pF/e7lpGtERv1Meo65M4KPES54=;
        b=2o68P/AincpNbVByO90sR1K5M9QNnMGTAB04KUjvUUTb8WeFpSSfZsFo7FhgFojAOS
         hrNQF8Fa3ue0ybhPdmc3bQ5RQnaQHjTsVy8zYl5kMg/vAO+ZHz1BRsHPMby40o3Iwjgi
         eaXenmoag98tYgOSvQxmBGxdUZD6fM32GsnGXWmBfw7xVEokyIu0TTIPD6X2wHF9PMWv
         /yBfd4fbC3O7SSV4yNvWQNAhTDJQ5c0knkDCTCGhz+X1Oo1gYXe+OeMswFKNmYhg/Ebp
         I829SA3/Gy+bfwpDZu/w/irM2MOpMn5bMRTFMuPqrblizRcXYLDJwch8hMEsEmWaimdN
         +UTw==
X-Gm-Message-State: AFqh2krdCC/1df3lsyy7Y2C2+EMsnk5hJfH3LfmHZgiJ3TwsYyu4riC+
        UYNyYei3hdOZbehR8iTt869IIPWV4WunKwNEnJY=
X-Google-Smtp-Source: AMrXdXsXS/MC3g0Q4hXs7g1zE+VtWVtbug23E4axT8qMI3dfI96/RaeLynG2tYyIsZvGMGPliIXxIw==
X-Received: by 2002:a17:906:7f18:b0:877:77f5:a8e1 with SMTP id d24-20020a1709067f1800b0087777f5a8e1mr30121818ejr.35.1674760280734;
        Thu, 26 Jan 2023 11:11:20 -0800 (PST)
Received: from localhost (tor-exit-relay-3.anonymizing-proxy.digitalcourage.de. [185.220.102.249])
        by smtp.gmail.com with ESMTPSA id ke8-20020a17090798e800b0084d4cb00f0csm991479ejc.99.2023.01.26.11.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:11:20 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net 2/2] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
Date:   Thu, 26 Jan 2023 21:10:50 +0200
Message-Id: <20230126191050.220610-3-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126191050.220610-1-maxtram95@gmail.com>
References: <20230126191050.220610-1-maxtram95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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

