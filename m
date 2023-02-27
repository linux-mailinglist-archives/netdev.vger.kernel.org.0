Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485F16A406E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 12:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjB0LQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 06:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0LQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 06:16:17 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057321ADD7;
        Mon, 27 Feb 2023 03:16:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r7so5789194wrz.6;
        Mon, 27 Feb 2023 03:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Ps8Y7+Ejt1AHKdclnAH6zj4e6Al9QTv8MXOJjOfZmM=;
        b=ntL8S93v2p9U/eHn/f+dpwbqRiUYHO0SzYq1BlIIdWUiV6Yn+XtHWTZGGo61OM1gzo
         X5PqufuDlImw5Q2BjpRjlOrNAVlIJj4lRsphCjLVMq5sZYrdWUTPlhYyNeCeESwrtNzw
         clwsqJKOs0/21SCiAWN4w8JCBXFLPdR6JB64OSshLcaNsJhqzzS8TZs7qpGf35K3UmHb
         cu7K+VC/Ftkt6gsVnBDPmJ5pmRYkSvz1y5S5LTyorYZrkILMlKMmKeCL7/pES62dPoDu
         yq4xxsApW6+DNqRZAxRXrvMk6w9Z6vigC1wa+uRavc/mf+4ouzvCWFY3RcY/BQtCGrNw
         xczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ps8Y7+Ejt1AHKdclnAH6zj4e6Al9QTv8MXOJjOfZmM=;
        b=ha0J4j9WySW6gLwgrAYUaMeKFWzmNEdsTltcNJPlaw91nZJ0o+coXdwH3o9eiWXg5p
         MWxeEkR4Xb0A6aGnXzdk+94f3u63i+Dw7PmC50OcXbZ0aSOE5YnGqBOtRCTZ90pXqZ0V
         aO/BkS/0YEijfvHWLIUB7lkA3ClET7Eu9SY+tN9rbgb/BsaS89JCMBtkiEQaW+PxO4AC
         WEkLwVa0q0VbwlaTq3/ahQFJ7YDObTumLjhFmWvcPa0kBPK3HIXWfYKoqfC+Gk7eRPNI
         BWA0ITEeMRtq310Kte3zjgDQv9lMeDrdUACTE1JNn05v9eqKoohZq9R8lU4xWAIP7REz
         oAjg==
X-Gm-Message-State: AO0yUKWl7ruagzGP+yCVmtT6vGTgSPpIu1sNxEURSBBMbmPadMOXdNTI
        7ME718w+G7G5LZbwJnjCTRY=
X-Google-Smtp-Source: AK7set/9XQ94Kqsib+UINK8qTDI4AJ3ncYrscyTFGG9hF+1o9UCiX+topAmLZXQyq/1EXNk632/isA==
X-Received: by 2002:a5d:6a03:0:b0:2c7:84e:1cfa with SMTP id m3-20020a5d6a03000000b002c7084e1cfamr16506971wru.40.1677496574341;
        Mon, 27 Feb 2023 03:16:14 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k28-20020a5d525c000000b002c556a4f1casm6742012wrc.42.2023.02.27.03.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 03:16:13 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:16:10 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Vu Pham <vuhuong@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/mlx5: E-Switch, Fix an Oops in error handling code
Message-ID: <Y/yQ+kk/cQdXKBLw@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling dereferences "vport".  There is nothing we can do if
it is an error pointer except returning the error code.

Fixes: 133dcfc577ea ("net/mlx5: E-Switch, Alloc and free unique metadata for match")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index d55775627a47..50d2ea323979 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -364,8 +364,7 @@ int mlx5_esw_acl_ingress_vport_metadata_update(struct mlx5_eswitch *esw, u16 vpo
 
 	if (WARN_ON_ONCE(IS_ERR(vport))) {
 		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
-		err = PTR_ERR(vport);
-		goto out;
+		return PTR_ERR(vport);
 	}
 
 	esw_acl_ingress_ofld_rules_destroy(esw, vport);
-- 
2.39.1

