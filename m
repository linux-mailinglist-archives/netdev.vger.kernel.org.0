Return-Path: <netdev+bounces-5640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCFA7124C2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 386951C21062
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBD5261E4;
	Fri, 26 May 2023 10:29:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC08156CF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:29:11 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CAFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f6d7abe9a4so4120205e9.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685096948; x=1687688948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iB4waUIWmV+BGRfYFQ7oeCuxtGCEhXCmhgsGifY6VfI=;
        b=5Jl+Syahug7PvAmAQMDuk3PMzGhyzA3RAHCLQGSQ8oPAlX+jLs3CsOjICfm0ZvieBH
         /hCSoVwNNOfBs+ekghWUObKm22YD2uK4MWEY93Dbn0LbftaGgQK1R3e1MIEsrXWM4z64
         W6Ogve4s/snuBSwTiEyu5pysKXtpG2QpHGL5WTy1eNlrO352lorv2Ue0GwcIUxOi1Pq3
         auvKgfMfN3Qs6d5LyZKkCHSM8iNkKuC+mh8xgzdclmMBg8ho2Ct8NAn4USHQnAHEKAyi
         dLv6f4yLA9EUG1W9xuVvzWKJwbNtS5u4zQPE9en2YsTimLbHJSOG74JMeFMCQJg6FxrV
         OaQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685096948; x=1687688948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iB4waUIWmV+BGRfYFQ7oeCuxtGCEhXCmhgsGifY6VfI=;
        b=R2TgtnT7qAiDoA/BnG2Lkzt18c1MBQIQlRGz6JOkZ1IUQBqVJt3j8HXhXuhsFaEtvg
         NDFkG/hg4yIwkBaax2O36PxPYosW1Bu+59XFq0kDKSWgsSA0EUaieVIg2YjYvI5PsRl7
         +mRlAnjyNODXYO3rb8aFi2ugjtw4VPKcMVLkrf9tt8G+n/JGtQSPOnf/GBnlGVw6ykYM
         mkKDBfnOdZpHTEuILG81ZSCvowJPheATB3DFeGDyuysXQu9s9IUJgMqaPouzEDv1fgBd
         IXsVNIJZQ8kK19bf2I/0AqJr+1dizCddSZkGr8hsSixwIyGxLaUVE8TspqEMDSpcq4sy
         v36A==
X-Gm-Message-State: AC+VfDyPvw39TpOUgQXkMX8hUUa1dT/x2/SGmzV0PPW4UG+69RDLwqbY
	nGDjomZ4qf5WnYn30M2iEXmkp5ZTmwra7tom5sQ5sw==
X-Google-Smtp-Source: ACHHUZ6bLS5AO8BDHCBXrn0UK9dylm3nVhmra3NBq2H+USaMYF+WCWxpmkAVcVRKNSfiW0K244LCFw==
X-Received: by 2002:a5d:45d2:0:b0:309:4227:829c with SMTP id b18-20020a5d45d2000000b003094227829cmr918203wrs.36.1685096948559;
        Fri, 26 May 2023 03:29:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o9-20020a5d6849000000b003078c535277sm4610250wrw.91.2023.05.26.03.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:29:08 -0700 (PDT)
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
Subject: [patch net-next v2 15/15] devlink: save devlink_port_ops into a variable in devlink_port_function_validate()
Date: Fri, 26 May 2023 12:28:41 +0200
Message-Id: <20230526102841.2226553-16-jiri@resnulli.us>
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

Now when the original ops variable is removed, introduce it again
but this time for devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- rebased on top of removed ops checks
---
 net/devlink/leftover.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 52aaa439caa5..bfec0a744280 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1185,16 +1185,16 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					  struct nlattr **tb,
 					  struct netlink_ext_ack *extack)
 {
+	const struct devlink_port_ops *ops = devlink_port->ops;
 	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
-	    !devlink_port->ops->port_fn_hw_addr_set) {
+	    !ops->port_fn_hw_addr_set) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
 	}
-	if (tb[DEVLINK_PORT_FN_ATTR_STATE] &&
-	    !devlink_port->ops->port_fn_state_set) {
+	if (tb[DEVLINK_PORT_FN_ATTR_STATE] && !ops->port_fn_state_set) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
@@ -1205,13 +1205,13 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 
 		caps = nla_get_bitfield32(attr);
 		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
-		    !devlink_port->ops->port_fn_roce_set) {
+		    !ops->port_fn_roce_set) {
 			NL_SET_ERR_MSG_ATTR(extack, attr,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
 		}
 		if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
-			if (!devlink_port->ops->port_fn_migratable_set) {
+			if (!ops->port_fn_migratable_set) {
 				NL_SET_ERR_MSG_ATTR(extack, attr,
 						    "Port doesn't support migratable function attribute");
 				return -EOPNOTSUPP;
-- 
2.39.2


