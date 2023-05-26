Return-Path: <netdev+bounces-5631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E847124B0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90EF92817AC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A881C18B11;
	Fri, 26 May 2023 10:28:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E09A18AFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:56 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E8119
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so6730875e9.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096933; x=1687688933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RmD5zGcuwgU5haAKQn8nIw4pPUb9ZdQ6b6VyX8FUbA=;
        b=EeysHCZP99Vk/Kl0XfRSRIyJb1Klej66C1mPgdg0wqqIr1zPYh2v87pKs3xm7lnnC0
         wO2RJj+SJVQuF3Hg29GEoglCzIq+gGsCz3NwMcNvzZ9rnROSMBJ2Pu31aBoAyvDEUFvh
         Ihu8pix+FDGX0NeeG7sb4YkvrXqEK2YUhOyyiVynfkkxlQOLVhqE+Qt45k3VtUR0epWI
         Ipe2joz9zu8g6ETZf8v/zeoJuBXMdSBK6pePtd3ABXz3LiGbP2AtGFuDJoTHPCVScckB
         wyvJMyFzlX+EEIh1peKTJb3d6OnXD6e1yjvdiK3mVP4qfuDhKVmCXWUDoC2MFKl20N4X
         kwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096933; x=1687688933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+RmD5zGcuwgU5haAKQn8nIw4pPUb9ZdQ6b6VyX8FUbA=;
        b=EbXcqidUfhIRjoyJ7yNPBsMn9yvS463IPgGlcSN80AKWpMaia+bqNg3Wtg9SpKm42p
         guZqnusSCTF0SnjcKRmBm4pqtTMnkvsPqFJnSbHQyW1aEJASMFyW2yo5OmgQ6EFkeXWq
         Dvs8dTwnlyJzWzwSILWAQx+5nWVYgosbf+bFODL3qV9Ne1ejvRLscxHBhmkuWJKsLg4j
         TjaQH5qGu9ePvDhOktXbKK890k7pDOPOBjIaD2ZcF7FdGER/+1i6FtGntRqN6BvUXwuI
         waK7XaYaP24WU4XZpNfdTJuA+t75bgZtSNvKzBkHX3RNxz1hakQsrbcH6T+qst5zZH75
         AHVg==
X-Gm-Message-State: AC+VfDw2IFn6Q98Sqg5ld/R88J7OFJwykcFzqHCDKSwtFF43Qu1H8bwk
	qUoX7OM1MyvnMUK75LQlEN2CZSH3GIq6u9WVOJ7fEg==
X-Google-Smtp-Source: ACHHUZ7CQb2m+3idGubhT43TBSqpBj2JdVV58TuwvW5WWDEYsa0eCNKGdaf7h07NFyDiBf72ntxRzQ==
X-Received: by 2002:a05:600c:3653:b0:3f6:af2:8471 with SMTP id y19-20020a05600c365300b003f60af28471mr1132598wmq.26.1685096933731;
        Fri, 26 May 2023 03:28:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c22d800b003f4e47c6504sm8464140wmg.21.2023.05.26.03.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:53 -0700 (PDT)
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
Subject: [patch net-next v2 06/15] mlx4: register devlink port with ops
Date: Fri, 26 May 2023 12:28:32 +0200
Message-Id: <20230526102841.2226553-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526102841.2226553-1-jiri@resnulli.us>
References: <20230526102841.2226553-1-jiri@resnulli.us>
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
index 28c435ce98d8..369642478fab 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3024,13 +3024,17 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
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


