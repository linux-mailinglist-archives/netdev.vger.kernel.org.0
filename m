Return-Path: <netdev+bounces-5628-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 549AE7124A7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F7F31C20FD7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61198171B0;
	Fri, 26 May 2023 10:28:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DA2171AF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:51 +0000 (UTC)
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7969FB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:49 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-309550d4f73so1480121f8f.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096928; x=1687688928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTjmUuyMK5MwTnsqPAe/bzivjB1ouw4qmuPSUNzg4sA=;
        b=QvGgqGFTVNCjQS1+Ya3DUixF5gTcc7u6FnfRuJewtKpFWeffnEfe1pgHaNBjjdQwTf
         +WCxGQP56/Ft2x7gOvm8+IeOZYpNCIsM4ou3lyyZuN2COWH5ztVg62PLne9jiZGNcEeR
         M53Bpy/X3TEoJeZ/PQCXfIirInEsbcdmfJ/vQqsCtRMODlWtYDmL3pKcizzhNCoEZnrL
         CPNQcRNgmMNGznX6Abp8TGYNx5iwjHNFTVNFHCHCyDoOBuqkS+m2km9LmUFElDcnGk9L
         Ckfh1ZFGVND/1eN8vMo3xbm/ROUtimWsAoiwh+yd9t+zk6JqPHhrO8Lgyp3VF1sNOq9t
         EJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096928; x=1687688928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTjmUuyMK5MwTnsqPAe/bzivjB1ouw4qmuPSUNzg4sA=;
        b=kg2W5LgLR7ieTO7Rpdz/4JEmC5oH4T0feJaZkVY4BRDI8/I0tPOZzzRnCgbFg7RUw3
         Kmh+Ohll1Vv47ahSCvTmWE53/e6+bcA3mNl15JLxGPCroxD68SHwZ1Q/Whg2FevcQw65
         BI57aaYavCGdDcvuNkSyBSfg/jrpG7yK1fmqEgcvZ1QESgJylLxnQZvZH4TOGFkIqwvT
         v6NgungrS5IPTZ/F9PCtm03bxlFJEryqMo7vZQS4GdBUM86vUPNEw+KlGdMYmhz45jpq
         EGO7pmsX0sytjRgEm+h4DY/FcwpTG7bz+61CZIc3Z0epm7UEBsHV2L7b/4t2ln/RNjgS
         pB1w==
X-Gm-Message-State: AC+VfDyxnQnUYRKgaAWuzgig/oKKcTo+HY7eE4zf0+vL2v9oy7XnL5YR
	+Uimg+9MXiU8vqmpIU6UgrMHyuQar8GI9PQxr9+Jow==
X-Google-Smtp-Source: ACHHUZ4BOWbs710o5v6/lKLB97zu1pnIgQTIT79vqWwAl/U15RfGm9dS8qv7DLrd+u31EcSdfM89YA==
X-Received: by 2002:a05:6000:1802:b0:30a:d486:bdb5 with SMTP id m2-20020a056000180200b0030ad486bdb5mr1122301wrh.5.1685096928510;
        Fri, 26 May 2023 03:28:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u18-20020adfed52000000b003079986fd71sm4615098wro.88.2023.05.26.03.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:48 -0700 (PDT)
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
Subject: [patch net-next v2 03/15] mlxsw_core: register devlink port with ops
Date: Fri, 26 May 2023 12:28:29 +0200
Message-Id: <20230526102841.2226553-4-jiri@resnulli.us>
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
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Petr Machata <petrm@nvidia.com>
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


