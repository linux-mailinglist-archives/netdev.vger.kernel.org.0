Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB3F6B8AC2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCNFnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCNFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A1184F58
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007FDB8189A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA1EC433D2;
        Tue, 14 Mar 2023 05:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772575;
        bh=jLlMIzHkYt/XqQiJpe6Wwg7dZ/TXmCwAdDWB9RwFbrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpNLTh7JzcJSuEv4dwjTKEg53zStcfgNe4IwaaD8X6vowBAOmjQwXMYEggsKQ32Eg
         80xXcmbSP0BnEK2FRgM8ajLmVrZlTX7krG0L25BaPvGrLRAtdG5+I0Picl0JMRGkuf
         Nwg1ML/6pwmOvKX1Bp2wS0ZAXKIym6+DbQtVTeclP7MUMwX1DfY7Z6ZQp/Q9XQWS3h
         7HOPsl/wadBJer7O7kKQfp43EYbw8ENMysROFUi7/FvZ8RwuxVIXwNu245UDG230C8
         8SRTtVBGR7B0r0zuWYaz5f18Qf/SZJHT6Rq0EHXhcFT0LpVxGjOn2MFE+x9iIT8Kkj
         QvspieZrqHpTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Add more information to hairpin table dump
Date:   Mon, 13 Mar 2023 22:42:31 -0700
Message-Id: <20230314054234.267365-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

Print the number of hairpin queues and size as part of the hairpin table
dump.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2e6351ef4d9c..a139b5e88e2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -583,6 +583,7 @@ struct mlx5e_hairpin {
 	struct mlx5e_tir direct_tir;
 
 	int num_channels;
+	u8 log_num_packets;
 	struct mlx5e_rqt indir_rqt;
 	struct mlx5e_tir indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5_ttc_table *ttc;
@@ -929,6 +930,7 @@ mlx5e_hairpin_create(struct mlx5e_priv *priv, struct mlx5_hairpin_params *params
 	hp->func_mdev = func_mdev;
 	hp->func_priv = priv;
 	hp->num_channels = params->num_channels;
+	hp->log_num_packets = params->log_num_packets;
 
 	err = mlx5e_hairpin_create_transport(hp);
 	if (err)
@@ -1070,9 +1072,11 @@ static int debugfs_hairpin_table_dump_show(struct seq_file *file, void *priv)
 
 	mutex_lock(&tc->hairpin_tbl_lock);
 	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
-		seq_printf(file, "Hairpin peer_vhca_id %u prio %u refcnt %u\n",
+		seq_printf(file,
+			   "Hairpin peer_vhca_id %u prio %u refcnt %u num_channels %u num_packets %lu\n",
 			   hpe->peer_vhca_id, hpe->prio,
-			   refcount_read(&hpe->refcnt));
+			   refcount_read(&hpe->refcnt), hpe->hp->num_channels,
+			   BIT(hpe->hp->log_num_packets));
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	return 0;
-- 
2.39.2

