Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C64449A6D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbhKHRIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240421AbhKHRIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576E961502;
        Mon,  8 Nov 2021 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391159;
        bh=QLAxWuDdKbcg82EJBjG6bhRnXeJytmGCjgZB0eDCtsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBuGqtZCOOLLnNxT/T24VhocsdaXR5Q3I/eq6NOWV3vrP1E/uXi5L1ZuAA40rcCOC
         41r+Dt1eQccvxZtPuOG5HC/hnPTeiy7rfPy5Nngtw71LXfCVG/q6tYV4EjkboPdUBS
         tle1YniDaT1CgjGJjZZtQUNWQChLO/gPUhQl+BdoodJlIICELJSTI3E6q/DCluS6dD
         BHa00xFx87xQ5PmGt1/SXGSPOfGbToXqLaVSh3oTrEgXdkIgnSETdI6KZaD+nnN2py
         hb+3bKjAV/3PfFtVusJoUeuPOsC0+YeWD6mAFqF1NaH9coUVUJepKv2s9VW69N8BHV
         227vJL7TY5T9g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 01/16] devlink: Remove misleading internal_flags from health reporter dump
Date:   Mon,  8 Nov 2021 19:05:23 +0200
Message-Id: <d7e2716a3112e316627e386720da01d3891bbd3a.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET command doesn't have .doit callback
and has no use in internal_flags at all. Remove this misleading assignment.

Fixes: e44ef4e4516c ("devlink: Hang reporter's dump method on a dumpit cb")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2d8abe88c673..fb9e60da9a77 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8836,8 +8836,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_health_reporter_dump_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
-- 
2.33.1

