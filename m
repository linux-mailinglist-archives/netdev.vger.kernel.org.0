Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDDB5959F5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiHPLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiHPLYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC65BCDD
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 016AEB8169E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2840BC43145;
        Tue, 16 Aug 2022 10:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646312;
        bh=r6YwTncXx6PDh4c6SPV3KsumRm412lS39ExoqKlTgJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KofTsorpTNIxRUCRmA3DdTi9dF4Yk166xnhNO9FE/Uj4c/JGOsnPg8utWeSf58MLn
         s20hlVDF7MmvymgC2sMj4Ubr4QS3CBYYicR5+pM+kdvR1C3LLZ9RW0ca6lAh8ozAeN
         mNeqGfQwYug78cPAeEyf8eTIGj0GnL8J+kLc+WX6wuySk7hdSsDKbrlIrXVrUyHhKe
         /mh9t7YW/2nA3ZWMn1FsdSH9LoNXH208bh7kzhsiGY+NsUEQc0jyBMRbL3rwFS5Chn
         3xjkcZfrTjxLSyDk66ijSTkwtEIO7wyGXGw+xTpSq+vpHw9KMleF0ylnDPYjRPNJdk
         UEWTCO5DrCl5g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 01/26] net/mlx5: Delete esp_id field that is not used
Date:   Tue, 16 Aug 2022 13:37:49 +0300
Message-Id: <ad100173edfe2ced1ff8306ef7645d801d024509.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The esp_id field is not used in mlx5 code, hence we can delete it.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/fs.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 8e73c377da2c..714a4c40c5d1 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -243,10 +243,7 @@ struct mlx5_flow_act {
 	u32 action;
 	struct mlx5_modify_hdr  *modify_hdr;
 	struct mlx5_pkt_reformat *pkt_reformat;
-	union {
-		u32 ipsec_obj_id;
-		uintptr_t esp_id;
-	};
+	u32 ipsec_obj_id;
 	u32 flags;
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
-- 
2.37.2

