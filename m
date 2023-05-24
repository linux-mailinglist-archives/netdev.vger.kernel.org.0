Return-Path: <netdev+bounces-4981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED7570F63C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66FB91C20CAE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E392E1951A;
	Wed, 24 May 2023 12:19:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FB19504
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:19:03 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C32130
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:19:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51190fd46c3so1730847a12.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930741; x=1687522741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=feTvn9xrp/0lxRGp7LllYvD/0WGV/fiydTMIJPyan48=;
        b=dAjMt0IA1D3MuPoccBdc0eqHxrZBHqFcC4n49ylr0rA7cgvLh/gCSru8Ub6u7JknOc
         +JVbjvwukuivU4zZwP8S2TJzbLxN0zmyX/dt0bfRVHowpl55wQS55mWHPgEvcCNpUwaA
         hAGH3uZCDpLZfPKSSYIOyCYaGkHFZTPvn2sSs4FfPmFrOTy4mpidy539Mok2rBpADixz
         6Vu3aMKUvsjBY6MFawR0tDiUFu471XLusYdMP4AL/G5ZpXwEm64WYzhACuhz2xqdsNZk
         /LRsaWFcOcZ/uw+8aaxi/bImARuC0uN2+LAXX5TCbGgmJ61Eoi7+2+tA+lPZ01gzX+s2
         JTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930741; x=1687522741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=feTvn9xrp/0lxRGp7LllYvD/0WGV/fiydTMIJPyan48=;
        b=J2kqurlTd7WmpS32PmmfKuFUj3frqBVpvPETYWpmq+bvTJg/bdsl16u6cCx/PndOba
         yG5m40SaK9r28cmwvHIkw78Zj/OzaiWjDAlROdYGigdN40XvbpD7gVYnb9U4y9Tei2sw
         LhP8AC2iFmzOik37HC65ub+ypSoyV11qPwUQliL1MxONJF6OqzoDCGc1XAPC6FK/Xck0
         ME5juQHWAgirWKMgbVFrcgHQY/JHzomSEiy0VlQvkDw3/dACiyAVfobs3W6gUTGBBCGR
         5crA3Fs+h8mRLfVrK7hq7JxhkavZAURsIJz5gdzB+Ncx2nyauaty7McrrWiCcKWmcqU2
         Jntg==
X-Gm-Message-State: AC+VfDxZI2wUqIlcBggZBUOgUvIxClcClYMpFIybM85DGkhZ1oEWxIDz
	b7aj+oMoRZYI+rXVkaCEHGp6QvB9cFImTtLDGa95EA==
X-Google-Smtp-Source: ACHHUZ7GDASBRYPcPUbHQYbeuYfptwGYuC+oVS2XKnzLcU62tsUeUqJM5xwMa6VNEB05rSb46ntbSQ==
X-Received: by 2002:a50:fa8f:0:b0:50d:abde:c7a3 with SMTP id w15-20020a50fa8f000000b0050dabdec7a3mr1610605edr.42.1684930741065;
        Wed, 24 May 2023 05:19:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d18-20020aa7d5d2000000b0050bc9ffed66sm5111101eds.53.2023.05.24.05.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:19:00 -0700 (PDT)
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
Subject: [patch net-next 15/15] devlink: save devlink_port_ops into a variable in devlink_port_function_validate()
Date: Wed, 24 May 2023 14:18:36 +0200
Message-Id: <20230524121836.2070879-16-jiri@resnulli.us>
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

Now when the original ops variable is removed, introduce it again
but this time for devlink_port_ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index b35dee4dddbc..fd2b1a40b61e 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1185,16 +1185,17 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					  struct nlattr **tb,
 					  struct netlink_ext_ack *extack)
 {
+	const struct devlink_port_ops *ops = devlink_port->ops;
 	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
-	    (!devlink_port->ops || !devlink_port->ops->port_fn_hw_addr_set)) {
+	    (!ops || !ops->port_fn_hw_addr_set)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
 	}
 	if (tb[DEVLINK_PORT_FN_ATTR_STATE] &&
-	    (!devlink_port->ops || !devlink_port->ops->port_fn_state_set)) {
+	    (!ops || !ops->port_fn_state_set)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
@@ -1205,15 +1206,13 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 
 		caps = nla_get_bitfield32(attr);
 		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
-		    (!devlink_port->ops ||
-		     !devlink_port->ops->port_fn_roce_set)) {
+		    (!ops || !ops->port_fn_roce_set)) {
 			NL_SET_ERR_MSG_ATTR(extack, attr,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
 		}
 		if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
-			if (!devlink_port->ops ||
-			    !devlink_port->ops->port_fn_migratable_set) {
+			if (!ops || !ops->port_fn_migratable_set) {
 				NL_SET_ERR_MSG_ATTR(extack, attr,
 						    "Port doesn't support migratable function attribute");
 				return -EOPNOTSUPP;
-- 
2.39.2


