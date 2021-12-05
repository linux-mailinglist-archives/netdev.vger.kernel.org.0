Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972C8468A1E
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhLEI0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:26:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56292 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhLEI0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:26:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 118F060FAC;
        Sun,  5 Dec 2021 08:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9C6C341C4;
        Sun,  5 Dec 2021 08:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692559;
        bh=LPz18YIw1LqOomM1gNNkIRMKSug19RGD5XK+ZURwjLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPTF76fVc7UHTzlH+LH1bb/3B51kIGrQ0nA8qSjfz3VE/QD/+DpFtpGwYXR4FW5w4
         4a8ELL6R7G/6SBkH4vuP90/9DSJzdv+SrxRd8+MEEUn1a04/22f9vCFgCcxzq39ryL
         ZBVUTs8P924Fuohc9f03LwiDQWdiYijdWFSu5vOLVUnmI/KiVBRyi/MfY13wXJ0BSn
         Blhqmeqr7tRG5NuYQXyi0DdeYCJmr6VE1kVL2bOCSspnitFwzRRQkeo3XizlOtrZhC
         uHHj7utdzh0OSON6yx35EXnq03MwrLIozRbdpRIdE+L7ivwV9BukXSDDcvwImopYWP
         Z2bne5PbLKPSA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 6/6] devlink: Open devlink to parallel operations
Date:   Sun,  5 Dec 2021 10:22:06 +0200
Message-Id: <0f0ff7178e2c97fcaf36f81d9ef4109028c13874.1638690565.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Allow parallel execution of devlink ops.

Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7666249b346f..3b311043cbff 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8979,6 +8979,7 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_small_ops	= ARRAY_SIZE(devlink_nl_ops),
 	.mcgrps		= devlink_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
+	.parallel_ops   = true,
 };
 
 static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
-- 
2.33.1

