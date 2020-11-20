Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51292BB337
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgKTSbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbgKTSbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:31:02 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E7B24137;
        Fri, 20 Nov 2020 18:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897061;
        bh=WXJEfqRj94HpGAo2eaWvHvqPElV8GZV+WC7FXBXG4DU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YE4KnDQkCFztMDeRF09ZPZtRZbJybx4zNL3956kFoUonKqcY67RxpgAGwo0d+P9xu
         nmpsw8Dkv2ffoVIXorC50bc2vW6F6QhhDLFRRdkpHAJOkREa1Ev/n0IIo5pruiqsun
         J+nOVgTFVXHWXiymvIrUMziVH/FmU9mpgIW3GqRY=
Date:   Fri, 20 Nov 2020 12:31:07 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 044/141] net/mlx4: Fix fall-through warnings for Clang
Message-ID: <84cd69bc9b9768cf3bc032c0205ffe485b80ba03.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 1187ef1375e2..e6b8b8dc7894 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -2660,6 +2660,7 @@ int mlx4_FREE_RES_wrapper(struct mlx4_dev *dev, int slave,
 	case RES_XRCD:
 		err = xrcdn_free_res(dev, slave, vhcr->op_modifier, alop,
 				     vhcr->in_param, &vhcr->out_param);
+		break;
 
 	default:
 		break;
-- 
2.27.0

