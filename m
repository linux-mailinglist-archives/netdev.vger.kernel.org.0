Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0726DEA22
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDLEIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDLEID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A07519AF
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B858362DA3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15030C433EF;
        Wed, 12 Apr 2023 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272481;
        bh=7tz/mpw0zg7cf4uxIxI7RdGeemhQIQZZKaD4/lDu2A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmYc20lhT8vIvVO+f0lzkm9Y1oJdqwE4HkqREbkCll4jcdmz5K/9qgbucG+simrGP
         AkcM4z3lLCnxdcLZjk6JFSiPMyOj3h/3YxrlpgrDKwwJ8LDVi4fJw8E5IzzhPQNp0n
         9O6OOCcBw0412CEPFcjjqoVdQrEAZTg5xyEVEmZ35JMeGfa/Xa1CUd7lSaDnuQ340Q
         riwNKyKGGQzeTbpYfeqgeU/fKVyOu22NFpeSSejj1VbMYbkF9pJsi4dhG9oLUTDzpa
         4OSTm/vmqyGmjmC/7qiiT/fCbtazYZlgdRf34Q/Nig4LrdJQj0TezI8VTt7ke6ksXk
         28N1IrZso380g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Add mlx5_ifc definitions for bridge multicast support
Date:   Tue, 11 Apr 2023 21:07:38 -0700
Message-Id: <20230412040752.14220-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

Add the required hardware definitions to mlx5_ifc: fdb_uplink_hairpin,
fdb_multi_path_any_table_limit_regc, fdb_multi_path_any_table.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e47d6c58da35..02c628f4fe26 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -880,7 +880,12 @@ enum {
 
 struct mlx5_ifc_flow_table_eswitch_cap_bits {
 	u8      fdb_to_vport_reg_c_id[0x8];
-	u8      reserved_at_8[0xd];
+	u8      reserved_at_8[0x5];
+	u8      fdb_uplink_hairpin[0x1];
+	u8      fdb_multi_path_any_table_limit_regc[0x1];
+	u8      reserved_at_f[0x3];
+	u8      fdb_multi_path_any_table[0x1];
+	u8      reserved_at_13[0x2];
 	u8      fdb_modify_header_fwd_to_table[0x1];
 	u8      fdb_ipv4_ttl_modify[0x1];
 	u8      flow_source[0x1];
-- 
2.39.2

