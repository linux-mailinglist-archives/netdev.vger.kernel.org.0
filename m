Return-Path: <netdev+bounces-4972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E22D470F61C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 776F71C20913
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC4218AE8;
	Wed, 24 May 2023 12:18:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B509D18AE5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:49 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65582139
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96fbe7fbdd4so140086366b.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930727; x=1687522727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWOZ3nITNBa37p0wiYOX7g+Tm88ng2N426ddkwEz2IQ=;
        b=T4WrTqZvoSUfGERDJN0UP8Ibg7xy9nXEUyCkxveKjpEZMOmW8sKmyHt0j70cPD/YmR
         G5zcFJbNFxtDoApxowRBJ8se5yEifL/EpcPiW41F0ExSrToInk3RTSkMic4PIDeJXdQV
         O2pZRhSpV7o4MtcOVH3BXKOox+5ldmrzWmhZYD9trHp2B04LegXDIPr3LAkyUckf5vek
         5RIpAtQZMzGFUBNrTEjvf8O5tFafnSljPNUUHcNDzDVXS1wHbGHMLYkFXI0hEOGVtIEA
         tL0f7QRB8oArchmbBmlbH+59UCnWAw7zKOwMFVZ1P1LYBKi0XcpJB8SeP04RWckbqaQV
         /t/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930727; x=1687522727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWOZ3nITNBa37p0wiYOX7g+Tm88ng2N426ddkwEz2IQ=;
        b=jb8Ks9iwh08ar7Dmrafsdd2p2sY9z8ohUZG/TyODiwyBqC5D/GMLNaCk2y3oOxvVQK
         LItNvIMtWu/OfXIo4Zxye5nZE56530Ss1aKcFaiUi30uyY0TleYnP3XRLPF2oNgSGHiR
         PLQGuwxV+xi2TQGZkjOorpKTUxUaAlwZ5A/CPNkRfOP/BC52UqZBKqbwE89X/IODmVJU
         dEGCPVlHpPSiPzjJXq+/RBJdNrKtBWJ8EQpQCOCtwMurJ9chwFBJ65QQmT/pfz+iBvgC
         JjuL/ksJpF7iP/dGgrbuDGtqTmtzBmBz7R8+1KxLygImt/HpJHyNxDvilGVL0uzfn2gJ
         8/xQ==
X-Gm-Message-State: AC+VfDy7p78t59zZb5HW3FVkIF47MqaB/sxcHwhlHx+337uOzEcJF8k0
	jVH+V98tcINai3TjsvuaDs743dojgQotA6jLueDjEg==
X-Google-Smtp-Source: ACHHUZ797MKphvltRb7FW0zFxvkBZNlK/sgFW2YlepycZDJukxrCxy3/puuqLGA2nSPQzjal0xgBHw==
X-Received: by 2002:a17:906:da84:b0:970:164c:31b5 with SMTP id xh4-20020a170906da8400b00970164c31b5mr7572598ejb.46.1684930727004;
        Wed, 24 May 2023 05:18:47 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p27-20020a17090664db00b009737b8d47b6sm926642ejn.203.2023.05.24.05.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:46 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	tariqt@nvidia.com,
	idosch@nvidia.com,
	petrm@nvidia.com,
	simon.horman@corigine.com,
	ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com,
	michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: [patch net-next 06/15] mlx4: register devlink port with ops
Date: Wed, 24 May 2023 14:18:27 +0200
Message-Id: <20230524121836.2070879-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524121836.2070879-1-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

Use newly introduce devlink port registration function variant and
register devlink port passing ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 277738c50c56..fd81c0b7191d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3027,13 +3027,17 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	}
 }
 
+static const struct devlink_port_ops mlx4_devlink_port_ops = {
+};
+
 static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 {
 	struct devlink *devlink = priv_to_devlink(mlx4_priv(dev));
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	int err;
 
-	err = devl_port_register(devlink, &info->devlink_port, port);
+	err = devl_port_register_with_ops(devlink, &info->devlink_port, port,
+					  &mlx4_devlink_port_ops);
 	if (err)
 		return err;
 
-- 
2.39.2


