Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285DA460610
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357251AbhK1MUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:20:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52492 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344973AbhK1MSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:18:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 119D4B80CDB;
        Sun, 28 Nov 2021 12:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6BAC004E1;
        Sun, 28 Nov 2021 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638101691;
        bh=w2PBcalS1ykskZBRf3DR2pu4+sT/joJW05T8O1uEZUY=;
        h=From:To:Cc:Subject:Date:From;
        b=NXibq4g7SZgB/N4GcS4IMTlksNj+893pxtOaq/roLYGfXUL1D6Mt79mWJZn2Hm6VM
         Z2A/qXVitRIs7GDr+uZdJ2Ewc15jw3aFPNQtypC/lr1A4xnH/zbHi+8NdxEqQmAuoN
         CEl+hBidkVrOoothdDrRQVyajS9wWCaohX+1z4PNULRJLT6UG14cmB/VXYitTY3FKg
         k2w0knMJFC9RzTl712BOdB68QmqDONDnNWRT85YJwOK0MtH9ACgDceKp1TadYCLNFn
         VktDTgrZfe0h+tspOHCA0RItL8WqMmrU+i8vYc74tZJjQdsFXSBKNnk8B9Z+bnwyMs
         dotOa+aI3hI9g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Aya Levin <ayal@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next v1] devlink: Remove misleading internal_flags from health reporter dump
Date:   Sun, 28 Nov 2021 14:14:46 +0200
Message-Id: <f85ab0a57f0206e9452c32ab28dc81e1b2aae3d4.1638101585.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
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
v1:
 * Sent as standalone change
v0: https://lore.kernel.org/all/cover.1637173517.git.leonro@nvidia.com
---
 net/core/devlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d144a62cbf73..fd21022145a3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8845,8 +8845,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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

