Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457DB65CE0F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjADILq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjADILm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F61902D;
        Wed,  4 Jan 2023 00:11:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B5FBB81334;
        Wed,  4 Jan 2023 08:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8588DC433D2;
        Wed,  4 Jan 2023 08:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672819896;
        bh=gbAB2Gn23E8leswuTQLuvlYJsRqaa3JIwQbl5Qfzczs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvF99KckduNWzulzQFD+MP3s8WSusd63ci3loBHBdu6mGAX7dra4ysv58L5WZzZgK
         Qeu1CxqzdKkfuDVqp/kT/Jb3BJL6uQbC9QDhPh03tEfBrYlF+EUEiRRRf0rF9R8vTP
         O93UJI0+14bxpDoBlZ/qKSA3hzX6UXNYD6jSKkcOc0b/3vO589OGgqRmZmQ1sx76LW
         g41yX7swGz8p+GJDY+vNVJybFkaY58IdJgaR8YQJDPrclpdn1PeyaymIBeeM3c82w0
         4WIby/tDs9DSceyxeu2R8Qwd2goVswm2FXUWScdiKSOHFqVplzM7JVnAuJ783CKJPO
         QtphWD1Zp6hnw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Expose bits for querying special mkeys
Date:   Wed,  4 Jan 2023 10:11:22 +0200
Message-Id: <3c7243648f72aaed7953bf976110e41068e22dc1.1672819469.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672819469.git.leonro@nvidia.com>
References: <cover.1672819469.git.leonro@nvidia.com>
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

From: Or Har-Toov <ohartoov@nvidia.com>

Add needed HW bits to query the values of all special mkeys.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f3d1c62c98dd..a2ed927c8f9f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1479,7 +1479,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         relaxed_ordering_write[0x1];
 	u8         relaxed_ordering_read[0x1];
 	u8         log_max_mkey[0x6];
-	u8         reserved_at_f0[0x8];
+	u8         reserved_at_f0[0x6];
+	u8	   terminate_scatter_list_mkey[0x1];
+	u8	   repeated_mkey[0x1];
 	u8         dump_fill_mkey[0x1];
 	u8         reserved_at_f9[0x2];
 	u8         fast_teardown[0x1];
@@ -5197,7 +5199,11 @@ struct mlx5_ifc_query_special_contexts_out_bits {
 
 	u8         null_mkey[0x20];
 
-	u8         reserved_at_a0[0x60];
+	u8	   terminate_scatter_list_mkey[0x20];
+
+	u8	   repeated_mkey[0x20];
+
+	u8         reserved_at_a0[0x20];
 };
 
 struct mlx5_ifc_query_special_contexts_in_bits {
-- 
2.38.1

