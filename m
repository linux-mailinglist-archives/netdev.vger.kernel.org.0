Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DF66636C9
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 02:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbjAJBj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 20:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjAJBjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 20:39:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED802027;
        Mon,  9 Jan 2023 17:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 106A0B810B3;
        Tue, 10 Jan 2023 01:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A57BC433D2;
        Tue, 10 Jan 2023 01:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673314791;
        bh=l4l5PaltAVow68iJO8Oi3TAG2+KxK22xrLBw7Tx9pFQ=;
        h=Date:From:To:Cc:Subject:From;
        b=iZ/+XZPz9dbjlyKU/lhTX44SKa3NKJowaGZPW9gcnKeu+8R9Qk9yL9wxOZnB5fEM0
         DW2kNwby1+c3ZTUQ4tSJLMA6fF/Frsou/ZFyxjUAptJ2remRoUSWyGb8sm08kULwer
         I+e8k+riaNY5+QOFtKC+uk6SGNoiJecO4ombiEEfGIWyBQcdV4wbibsiA7kVKg0mlf
         VmefWTOFg4HALaYzpIOMjLdwW/FNJifSAfpV9PFK/isJIl+PDIV4IaqXPt4l7lN02Q
         gTCLPGr8lX9Iv8ngVbaS/kSkQS9B7GKEBaJL8IdciFu4gAJDGxpClZhLQQOE6bVOl0
         2UjhPKDfWc7SQ==
Date:   Mon, 9 Jan 2023 19:39:58 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/mlx5e: Replace zero-length array with
 flexible-array member
Message-ID: <Y7zB7shx/u1zWrbj@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.34.1

