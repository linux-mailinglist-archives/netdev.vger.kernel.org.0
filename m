Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D4F27F8B3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJAEdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJAEdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:16 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A3A22204;
        Thu,  1 Oct 2020 04:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526795;
        bh=Enhrsj8jzTY4TQqMUmcWT3F8gE5k5AkZbiSu6Q3oy9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB4/KnYaRyVDTQyXYHIFZ1wr01ERjeqLWFGpDlSWWEJ52Fd94yBX56MiLEhAhtJ4b
         QqUwVE6SK5OGqN0EfgXNw1hkW3EEebE8x1cQ2lGPaf8do1H3xJu9u43oHGJZz7Lv9O
         8+BOqBkShAjYLEt3XO+pT5AvRPLaMtuUHM5RLc9o=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, Remove unneeded local variable
Date:   Wed, 30 Sep 2020 21:32:51 -0700
Message-Id: <20201001043302.48113-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The misc3 variable is used only once and can be dropped.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index a16d7faa2bb8..7df883686d46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -203,7 +203,6 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_matcher->nic_tbl->nic_dmn;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_match_param mask = {};
-	struct mlx5dr_match_misc3 *misc3;
 	struct mlx5dr_ste_build *sb;
 	bool inner, rx;
 	int idx = 0;
@@ -309,8 +308,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask,
 						       inner, rx);
 
-		misc3 = &mask.misc3;
-		if ((DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc3) &&
+		if ((DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(&mask.misc3) &&
 		     mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps)) ||
 		    (dr_mask_is_flex_parser_icmpv6_set(&mask.misc3) &&
 		     mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps))) {
-- 
2.26.2

