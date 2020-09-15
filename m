Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F88F26B042
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgIOWGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgIOU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:00 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3914C20809;
        Tue, 15 Sep 2020 20:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201554;
        bh=ST3cSFqSSpB7f/pNfFFvHDFCM9EzKTIepJ3nW1RhTFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drZ3yJETy9CYVELlJJW3GP8UY0+iuMFBQECnOyqyYwY00ssLxuQ2CboUlfUYGiV42
         GnZlB9kOiK/gJVkWoO051nUqrzcfDEIwqkyI5jNlHuf9VdFGeWrS9/nhsntOvoW6qG
         AX2Cp2U+UTZjELrifmSGBUej/bUpWoymOPiLX3xc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Tal <moshet@mellanox.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5: Fix uninitialized variable warning
Date:   Tue, 15 Sep 2020 13:25:18 -0700
Message-Id: <20200915202533.64389-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@mellanox.com>

Add variable initialization to eliminate the warning
"variable may be used uninitialized".

Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
Signed-off-by: Moshe Tal <moshet@mellanox.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 3dc200bcfabd..69a05da0e3e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -242,8 +242,8 @@ static int mlx5e_health_rsc_fmsg_binary(struct devlink_fmsg *fmsg,
 
 {
 	u32 data_size;
+	int err = 0;
 	u32 offset;
-	int err;
 
 	for (offset = 0; offset < value_len; offset += data_size) {
 		data_size = value_len - offset;
-- 
2.26.2

