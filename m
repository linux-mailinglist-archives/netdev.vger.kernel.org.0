Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430775F0AFD
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiI3Lrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiI3Lr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:47:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA003FFB2D;
        Fri, 30 Sep 2022 04:44:03 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v1so3749852plo.9;
        Fri, 30 Sep 2022 04:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Gg0A0CsuZvn3gbRKVVoweIsGGQktuRgro3yyKRZC6yo=;
        b=S+rHi0IQSlE7WkWXkHzEMCYAR1eWbIOMxU34v3/uqSUu6rWSlQ4XA7Mzr4vhHHCauT
         FoM0gfdBofAk3PbMoCHFuWL64F3WYU1ow8kT2j5JXIjEluv6DMd4+NuK6BpzDklJ/3BK
         pamHa2SUGU6hFOLg8JtCAPiHwcWNH/ZZolATHka6ri+BTZu09AIDPMFU+tyybnclj5gv
         txzO5jhYXDkK+cvUhIE0AkSXFlhxH0KFRJD8JnzipQbr/DzJLfinSmEN7ilXrEUq/ZgL
         UtuOvkB7baze3Yl7SD1duleGsmBFF1OS51ez9Q7WYyPcj91o6q8Cqnma8uNSHzj2z8jd
         2CRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Gg0A0CsuZvn3gbRKVVoweIsGGQktuRgro3yyKRZC6yo=;
        b=W5SVhfLSKC8jttS9/8w8kGRtSDENNiTxWBTUpgD+3V7csaB8SPe5vrK+Czz5BDc1Pj
         /TB7Yd69CDTOTm4SInOK/xKchi0aP+cm9jPuo1u0pEulZ3A856OytEGgi2ldNgEiiiYf
         DrgR7N3Zj+G8re3mNaYns9KbZuPByb15dQmj77oBhHCWuu/u0frkKI9e3c0gUCM4pE0B
         kGQx1zu2t+3qtWOhF/inBP2UOpmp/M0egwKtVN/vOYXrWM9lfLcYRe6orX0Z6tH+kZsh
         +OL6Qm8Rh+TcV7eeiKMehRL5reqcj5zYurpHGS+Jh+uUHICljnxQ8QukymcYX0sfkHkQ
         yYTQ==
X-Gm-Message-State: ACrzQf0g94HYmimzWX7BhEPUMhGdiRyu1K2WU17oVPqq6U6cy34fG1+5
        nv7NUqDHWFzUgJL9d7g9icE=
X-Google-Smtp-Source: AMsMyM5irRGrmMh154wuYn4XRa9MjbS0fbaOivd2pICaLsfqAP45ZvvxrOMGKbXZv2kxePcQ1XGJog==
X-Received: by 2002:a17:90a:db85:b0:20a:607a:3701 with SMTP id h5-20020a17090adb8500b0020a607a3701mr1209544pjv.187.1664538242883;
        Fri, 30 Sep 2022 04:44:02 -0700 (PDT)
Received: from localhost.localdomain ([49.206.115.111])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902d1c300b0017a00216965sm1642129plb.218.2022.09.30.04.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 04:44:02 -0700 (PDT)
From:   Praghadeesh T K S <praghadeeshthevendria@gmail.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "GitAuthor: Praghadeesh" <praghadeeshthevendria@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     praghadeeshtks@zohomail.in,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] net: ethernet/mellanox: fix dereference before null check
Date:   Fri, 30 Sep 2022 17:13:35 +0530
Message-Id: <20220930114335.608894-1-praghadeeshthevendria@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net: ethernet/mellanox: fix dereference before null check
macsec dereferenced before null check
bug identified by coverity's linux-next weekly scan
Coverity CID No: 1525317

Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 5da746d..e822c2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1846,11 +1846,11 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
 {
 	struct mlx5e_macsec *macsec = priv->macsec;
-	struct mlx5_core_dev *mdev = macsec->mdev;
 
 	if (!macsec)
 		return;
 
+	struct mlx5_core_dev *mdev = macsec->mdev;
 	mlx5_notifier_unregister(mdev, &macsec->nb);
 
 	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
-- 
2.25.1

