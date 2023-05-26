Return-Path: <netdev+bounces-5630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEEF7124AF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 916671C20FBF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5826618AFD;
	Fri, 26 May 2023 10:28:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA718AFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:28:55 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C9510A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:53 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3078cc99232so494569f8f.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096932; x=1687688932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STSw2gTgeRHuaKaPFYV6fuYPrHCfCUHV7vPRflI7VgA=;
        b=kuUTM8lQZnxy2OcnmxutDNDj1O6atpEsBVdRbj83QtDTwVpIEz+Pcn3oTwRN8XsKnD
         ZL7iN1bvyCA+BFDmKx9Y5189kkdjyyOyblMEd5+PWE0TpxZ9HFRGGIyrWPo4BR60Lxh/
         QaLg6UtqTq2byJvWerC5k+G5IOqvj2MnqqKGgjaVg8tITq1D2hXmagZbSpiVcIy2YZm0
         +EMpastFLqe5cOjxKrN5sgau2ikTvwsvY/ufl13rH/nU8jbX1/XPIXNeTdmEQO8UYIpx
         B+Q47+UZv6KGj7zjrb+12S22K1F7raQ+MmB/bzpzXtqNuunZoph/RM9nGXuopfDNlxsW
         R/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096932; x=1687688932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STSw2gTgeRHuaKaPFYV6fuYPrHCfCUHV7vPRflI7VgA=;
        b=T+fSNn1qhd/BV7MtwXYsm/hkyuOF4WvdguXll57WBmpqTM+TOrvcnRsj3cI8ThcOl4
         FvW3wcZvA3lzbllqrX8saG1zgFOhEpTcajmGG24ZQzulLd3Oo+WrIxCdxj/0dtgbIYXN
         sBYXWHz4tvhVUxLe+T5FEk118cMO4qEJBJ/NUfMUrxtr8X6poN/NyFbKhj9Ee7HgZcBf
         aW5IsJucWvdsyqVmGTXqZZ65PboavZR9+nZt87UWm7ujJd1Hn4A+l1hGdHPJJkQyh6tv
         bsq04XCu87ftDDAtQp3rcsA9P6gRh5ey+OBDdkF5451Ck3CDXyAMqTIAn6oGjCvAY7O5
         s5VA==
X-Gm-Message-State: AC+VfDxwPpQYAar/B9r3uv53qhKfU7yEnzUQtvnSTRQ9ET+oOCLoQ6XN
	e6UXq1TRJRnQ6plWAEdFES8EFYNSxPiPhFVAzp9jlg==
X-Google-Smtp-Source: ACHHUZ6GWOCguPin38U2muW/OFles73u427YkJQSVGbTogFDBTiFrh7FlHW619r1DL1UYyVVjjA0Pw==
X-Received: by 2002:a5d:45cf:0:b0:309:4a0f:facc with SMTP id b15-20020a5d45cf000000b003094a0ffaccmr1065187wrs.40.1685096932037;
        Fri, 26 May 2023 03:28:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g12-20020a5d488c000000b003090cb7a9e6sm4612134wrq.31.2023.05.26.03.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:28:51 -0700 (PDT)
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
Subject: [patch net-next v2 05/15] devlink: move port_split/unsplit() ops into devlink_port_ops
Date: Fri, 26 May 2023 12:28:31 +0200
Message-Id: <20230526102841.2226553-6-jiri@resnulli.us>
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

Move port_split/unsplit() from devlink_ops into newly introduced
devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- avoid ops check as they no longer could be null
---
 drivers/net/ethernet/intel/ice/ice_devlink.c     |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/core.c       |  4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c |  4 ++--
 include/net/devlink.h                            | 11 +++++++----
 net/devlink/leftover.c                           | 10 +++++-----
 5 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 6661d12772a3..80dc5445b50d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1256,8 +1256,6 @@ static const struct devlink_ops ice_devlink_ops = {
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down = ice_devlink_reload_down,
 	.reload_up = ice_devlink_reload_up,
-	.port_split = ice_devlink_port_split,
-	.port_unsplit = ice_devlink_port_unsplit,
 	.eswitch_mode_get = ice_eswitch_mode_get,
 	.eswitch_mode_set = ice_eswitch_mode_set,
 	.info_get = ice_devlink_info_get,
@@ -1513,6 +1511,8 @@ ice_devlink_set_port_split_options(struct ice_pf *pf,
 }
 
 static const struct devlink_port_ops ice_devlink_port_ops = {
+	.port_split = ice_devlink_port_split,
+	.port_unsplit = ice_devlink_port_unsplit,
 };
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 605881b17ccc..1ccf3b73ed72 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1723,8 +1723,6 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 				  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
-	.port_split			= mlxsw_devlink_port_split,
-	.port_unsplit			= mlxsw_devlink_port_unsplit,
 	.sb_pool_get			= mlxsw_devlink_sb_pool_get,
 	.sb_pool_set			= mlxsw_devlink_sb_pool_set,
 	.sb_port_pool_get		= mlxsw_devlink_sb_port_pool_get,
@@ -3117,6 +3115,8 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 EXPORT_SYMBOL(mlxsw_core_res_get);
 
 static const struct devlink_port_ops mlxsw_devlink_port_ops = {
+	.port_split			= mlxsw_devlink_port_split,
+	.port_unsplit			= mlxsw_devlink_port_unsplit,
 };
 
 static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 4e4296ecae7c..8c6954c58a88 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -311,8 +311,6 @@ nfp_devlink_flash_update(struct devlink *devlink,
 }
 
 const struct devlink_ops nfp_devlink_ops = {
-	.port_split		= nfp_devlink_port_split,
-	.port_unsplit		= nfp_devlink_port_unsplit,
 	.sb_pool_get		= nfp_devlink_sb_pool_get,
 	.sb_pool_set		= nfp_devlink_sb_pool_set,
 	.eswitch_mode_get	= nfp_devlink_eswitch_mode_get,
@@ -322,6 +320,8 @@ const struct devlink_ops nfp_devlink_ops = {
 };
 
 static const struct devlink_port_ops nfp_devlink_port_ops = {
+	.port_split		= nfp_devlink_port_split,
+	.port_unsplit		= nfp_devlink_port_unsplit,
 };
 
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 850148b98f70..6ddb1fb905b2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1276,10 +1276,6 @@ struct devlink_ops {
 			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
-	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
-			  unsigned int count, struct netlink_ext_ack *extack);
-	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
-			    struct netlink_ext_ack *extack);
 	int (*sb_pool_get)(struct devlink *devlink, unsigned int sb_index,
 			   u16 pool_index,
 			   struct devlink_sb_pool_info *pool_info);
@@ -1653,8 +1649,15 @@ void devlink_free(struct devlink *devlink);
 
 /**
  * struct devlink_port_ops - Port operations
+ * @port_split: Callback used to split the port into multiple ones.
+ * @port_unsplit: Callback used to unsplit the port group back into
+ *		  a single port.
  */
 struct devlink_port_ops {
+	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
+			  unsigned int count, struct netlink_ext_ack *extack);
+	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
+			    struct netlink_ext_ack *extack);
 };
 
 void devlink_port_init(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 14bb82403c2d..43c97271f299 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1320,7 +1320,7 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 
 	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PORT_SPLIT_COUNT))
 		return -EINVAL;
-	if (!devlink->ops->port_split)
+	if (!devlink_port->ops->port_split)
 		return -EOPNOTSUPP;
 
 	count = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT]);
@@ -1339,8 +1339,8 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	return devlink->ops->port_split(devlink, devlink_port, count,
-					info->extack);
+	return devlink_port->ops->port_split(devlink, devlink_port, count,
+					     info->extack);
 }
 
 static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
@@ -1349,9 +1349,9 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = info->user_ptr[0];
 
-	if (!devlink->ops->port_unsplit)
+	if (!devlink_port->ops->port_unsplit)
 		return -EOPNOTSUPP;
-	return devlink->ops->port_unsplit(devlink, devlink_port, info->extack);
+	return devlink_port->ops->port_unsplit(devlink, devlink_port, info->extack);
 }
 
 static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
-- 
2.39.2


