Return-Path: <netdev+bounces-4969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A25D70F616
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 312E01C20C9F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63943182BF;
	Wed, 24 May 2023 12:18:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59736182A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:18:45 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B14184
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96aae59bbd6so136232966b.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930722; x=1687522722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djeZrsWOk0xjFSpIhZMqzXpKAy1lry4yS2RgSZQ2AII=;
        b=qGBKXoF3thL8ALwehUEM5T+EqMFvurEaIDK+cJb6XFCg2JA01BPdvJYxaIt50YoCOJ
         GaQXVkXTBmKrDPNc42x/mxIMaB215VJ2+Ky4RKcVIno7rZWw/sBVNyxKH3H5mvLp8xjV
         fzDj29v1y48eHgzphnAco07Q1BkrFYp2+mtwmy+aVdKN9ncU3xNhfHOKixTNbvqtNPJ4
         Vqd7CsKviPyRISUkVG0Z6qB8whieeqVjq4Nbo61IMpXpJsypqpIV9kJbeQdxGhE6Z3xv
         BQgnREXzXjo02TOVVUCtkSf1sm+QXhbaNNBJQyJUaHG2TOau0NwdNYqe6SvjkeK5mqZ7
         XowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930722; x=1687522722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djeZrsWOk0xjFSpIhZMqzXpKAy1lry4yS2RgSZQ2AII=;
        b=ZyebGIZsPEcNtHMrWSmaI4syHCNB8JD/ywoEXcgu4LRzF7ITNqLTab2XiLemnlr5KJ
         lBMzV1bjRMXCTzSjUVFQo+Plwofg6320W4zUfANk4v20uKlBYtt56/76+io2NnK0dZJA
         aoWAFnDVczhsiuE/sWHIn06PFcq1Di5NZigndxUea2jEnkq8JMhT2yDrgWxUTF0aFaz5
         X2BBU/oFhIcsbBOoMJZlTuPPWqYbz1uMZcayY9HuQkqG8YqaDqkjrg/M6Mbd63mbiUBZ
         eYkcLYD2towVeuIcrKv90RKbchi0kR4NEYEAenaLJBplV+tt+HnBw1n12sEksz2wJhB9
         JyBg==
X-Gm-Message-State: AC+VfDzh11prfAN+8vE8O64DTZX8mropschAAb81wa5tXyTczxwx0cZ7
	4JGnM4KJcx86dewxV/pZ8kiYiLqLecKqGUMCqfOHNA==
X-Google-Smtp-Source: ACHHUZ7stYriMnt9typ9OjYFg4OPDJU55Toh24F3oXVlW4tIB2fucE80cEpg9r/Gnua2Rv2hWdUmRA==
X-Received: by 2002:a17:907:9716:b0:970:19a2:7303 with SMTP id jg22-20020a170907971600b0097019a27303mr8452443ejc.19.1684930722416;
        Wed, 24 May 2023 05:18:42 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id jz3-20020a17090775e300b0096557203071sm5772181ejc.217.2023.05.24.05.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:18:41 -0700 (PDT)
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
Subject: [patch net-next 03/15] mlxsw_core: register devlink port with ops
Date: Wed, 24 May 2023 14:18:24 +0200
Message-Id: <20230524121836.2070879-4-jiri@resnulli.us>
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
 drivers/net/ethernet/mellanox/mlxsw/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 22db0bb15c45..605881b17ccc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3116,6 +3116,9 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_res_get);
 
+static const struct devlink_port_ops mlxsw_devlink_port_ops = {
+};
+
 static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 				  enum devlink_port_flavour flavour,
 				  u8 slot_index, u32 port_number, bool split,
@@ -3150,7 +3153,8 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 		devlink_port_linecard_set(devlink_port,
 					  linecard->devlink_linecard);
 	}
-	err = devl_port_register(devlink, devlink_port, local_port);
+	err = devl_port_register_with_ops(devlink, devlink_port, local_port,
+					  &mlxsw_devlink_port_ops);
 	if (err)
 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
 	return err;
-- 
2.39.2


