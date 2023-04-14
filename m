Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88A66E2C58
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjDNWKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjDNWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3341868B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C374564A92
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A316C4339B;
        Fri, 14 Apr 2023 22:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510193;
        bh=A2Ym5Q7HgJKSTuTinMh8rd3Iplf2qSjWWUSj73f9hcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zz4oUto2V7LvMcNWbU57wlCvB+wIKmPB4je43Lg4Nx4VUpfCzqIHHHT7C5mHOASQ2
         /HJjXYhqsTh4zde/iiM9ijwxDh4GR/V3ZpXUtKXtTJp1q/qQ8HhP3aVSi3jgbw0eSO
         UiBa1xfuyCQ3NfzfUkiRGuc6JNgCnpQqxq4/A1GkEzGuE92d19xeg8D4p4/AfR09sn
         W45iLeA1mL5AhcxW1GlamI8Lro1HhR+L+Pf6R+2mVT6SxeXsg8LCjhPRe4jd/Wu81H
         wfMB+IwQ/9N8YC/rBWKqTX6EjyGex3Rs0108wG4iFBL3tfnZxrM8f7qnM9/3LF/Nmt
         /2kwLdjYBWsxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 15/15] net/mlx5: DR, Enable patterns and arguments for supporting devices
Date:   Fri, 14 Apr 2023 15:09:39 -0700
Message-Id: <20230414220939.136865-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Check if patterns and arguments for modify header action
are supported and enable them accordingly.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index c4545daf179b..9a2dfe6ebe31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -12,7 +12,8 @@
 
 bool mlx5dr_domain_is_support_ptrn_arg(struct mlx5dr_domain *dmn)
 {
-	return false;
+	return dmn->info.caps.sw_format_ver >= MLX5_STEERING_FORMAT_CONNECTX_6DX &&
+	       dmn->info.caps.support_modify_argument;
 }
 
 static int dr_domain_init_modify_header_resources(struct mlx5dr_domain *dmn)
-- 
2.39.2

