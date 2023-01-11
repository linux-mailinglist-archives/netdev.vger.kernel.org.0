Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9756653D5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjAKFjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbjAKFiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3659D1026
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:31:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5C4C61A30
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2145CC433EF;
        Wed, 11 Jan 2023 05:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415061;
        bh=cpXDSGtc9hWGiqzEcXuKUpQaWRhm/4z+ZVCKy+90C2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2zrr9uk4utcO2A1iw5Q2ElTWs7JWMFxy4HOdy6lmL3FarQpJV6ndi6a2eZUeInGy
         7Ni25n80Qtc9XKmJgaLb/HyzwGMrM/4YhFuhZAm3o3f1jwOYzh7LhW7nDJo31ZNsk0
         GeWPWpocLG9cwH33GtaEQw8ELfmGPcMvoY+mFXxmHJDD+kFL9LymH8uUDeotxHCk0H
         FsjxGW9adSLfyqxkd2VME5Md7/nIh3ji2ZVrDXmyAe9cvBGeKGzqS7qkWN+peh17tu
         yxxVgpQ80JXwBZFCpgjCAtBXzm3gtkOue/aqvZTbV3ohz6+ZcCqcZOZg8wFFEWhzSF
         bP9baX4U6Hn5Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [net-next 12/15] net/mlx5e: Replace zero-length array with flexible-array member
Date:   Tue, 10 Jan 2023 21:30:42 -0800
Message-Id: <20230111053045.413133-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Zero-length arrays are deprecated[1] and we are moving towards
adopting C99 flexible-array members instead. So, replace zero-length
array declaration in struct mlx5e_flow_meter_aso_obj with flex-array
member.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [2].

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 78af8a3175bf..7758a425bfa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -28,7 +28,7 @@ struct mlx5e_flow_meter_aso_obj {
 	int base_id;
 	int total_meters;
 
-	unsigned long meters_map[0]; /* must be at the end of this struct */
+	unsigned long meters_map[]; /* must be at the end of this struct */
 };
 
 struct mlx5e_flow_meters {
-- 
2.39.0

