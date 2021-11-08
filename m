Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70F1449A7F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbhKHRJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241432AbhKHRJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34B7E6120A;
        Mon,  8 Nov 2021 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391201;
        bh=D6oLygualEpqhStogmVdQP07kR3ecTyYABiG+i4D494=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQcoSBv15/P8duMJrxu13PQUdELpJAdRKfBUN0QSchjFOdrVL7Qc2+fKK9VSxw4WU
         Fsa7LcZCeyY3FkncZP4F7zpJy7k5Siz6ZX1Ujv0PMH86HaqTUmS8ml1O86dvTbl/bb
         NcSDDa0tonq7yVMRgz5sFJV2tlBD389+0ZJE+e27bP8b8HdZIvgRTyI/ViDxza/Ym5
         k7IwBRLzIerN83S0NvHO+hDsaTbdMtjQIF3/qKt2BR+BlU1JxJYfx/W3pcVS9Woj/q
         UnsnirSqgEYOvoWeG8IWIiixQHNL0RfDXEASzDrSSjG/oUWNOoLINbVIbmInobh0o0
         pn5why2/Bey6w==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 16/16] devlink: Open devlink to parallel operations
Date:   Mon,  8 Nov 2021 19:05:38 +0200
Message-Id: <75088f5c533815580092fd7dca787c06e75ba7ba.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Allow parallel execution of devlink ops.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 147f606cac41..0c118002ef3c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8989,6 +8989,7 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_small_ops	= ARRAY_SIZE(devlink_nl_ops),
 	.mcgrps		= devlink_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
+	.parallel_ops   = true,
 };
 
 static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
-- 
2.33.1

