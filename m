Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED3E4B249
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731163AbfFSGmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:42:02 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:32931 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfFSGmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:42:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AFBE920CA5;
        Wed, 19 Jun 2019 02:42:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dThxJKMfrv1/w5G3vK1sfHD+Bs3RL/r06OccYkU3Azs=; b=SAaMjNqf
        cq7rhLcNaKsYNDiy4bQHN0RuapQCwblh79sT/k1b5C/h4sFLxRs8BuGd9rK7KZGY
        AgEdK+H0Yn7r0dwA/CVG1Cj2blOkhcSCy7HmpoYiIplXMqjEDww4luEQm0cfNIpx
        Y7YRMtk/Kqx3y1uPfuyEJPudtj3gZN+1iNW5WzODaax8tKd3W22XrIwrGO/HpuvK
        lyNnXueIYWQ/HmdziOBkfHIMo7C9vSK5KEG8MR6Rp9Zb2dtOa02Tud6RNrPxKIyf
        3WFjFsIjP7GWZ3z9Vu++SzRabqwMrCAHAq0/48ZrJ1CT7YoBoJI2z0hLmmpWKBjG
        kn8icL6DY7iKtA==
X-ME-Sender: <xms:OdkJXU82aDifG_zBKRZjg4r5ccc8fUR6Jy6MxaOdBitfXz3DxQ3RQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:OdkJXZnuG7_-8wU8IwRJ8xTfWP7lobL1vmea9Vm3qZKOvEcguJ6FNQ>
    <xmx:OdkJXZzC2iejl4F21omAtOdfLiLErVKq2gRepK2ACIMlbjvScQsn7Q>
    <xmx:OdkJXT40TbQXi_9yhUSbskaGCGqJ6o--iaTNeboW9RyJSltNwpaj9A>
    <xmx:OdkJXVVM8ZGh4YbwRxWcgpUrDAPly9cF83cdZIrRYfAqeUzwbeZ9iA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39EFD8005B;
        Wed, 19 Jun 2019 02:41:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/8] mlxsw: spectrum_acl: Fix SRC_SYS_PORT element size
Date:   Wed, 19 Jun 2019 09:41:07 +0300
Message-Id: <20190619064109.849-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Fix the size of the SRC_SYS_PORT element to be 16.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h  | 2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index d99a70eec357..cb229b55ecc4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -74,7 +74,7 @@ struct mlxsw_afk_element_info {
  * define an internal storage geometry.
  */
 static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
-	MLXSW_AFK_ELEMENT_INFO_U32(SRC_SYS_PORT, 0x00, 16, 8),
+	MLXSW_AFK_ELEMENT_INFO_U32(SRC_SYS_PORT, 0x00, 16, 16),
 	MLXSW_AFK_ELEMENT_INFO_BUF(DMAC_32_47, 0x04, 2),
 	MLXSW_AFK_ELEMENT_INFO_BUF(DMAC_0_31, 0x06, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SMAC_32_47, 0x0A, 2),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 96fc981ed851..279c241f76f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -12,7 +12,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_dmac[] = {
 	MLXSW_AFK_ELEMENT_INST_BUF(DMAC_0_31, 0x02, 4),
 	MLXSW_AFK_ELEMENT_INST_U32(PCP, 0x08, 13, 3),
 	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x08, 0, 12),
-	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 8),
+	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 16),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_smac[] = {
@@ -20,7 +20,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_smac[] = {
 	MLXSW_AFK_ELEMENT_INST_BUF(SMAC_0_31, 0x02, 4),
 	MLXSW_AFK_ELEMENT_INST_U32(PCP, 0x08, 13, 3),
 	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x08, 0, 12),
-	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 8),
+	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 16),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_smac_ex[] = {
@@ -32,13 +32,13 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_smac_ex[] = {
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_sip[] = {
 	MLXSW_AFK_ELEMENT_INST_BUF(SRC_IP_0_31, 0x00, 4),
 	MLXSW_AFK_ELEMENT_INST_U32(IP_PROTO, 0x08, 0, 8),
-	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 8),
+	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 16),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_dip[] = {
 	MLXSW_AFK_ELEMENT_INST_BUF(DST_IP_0_31, 0x00, 4),
 	MLXSW_AFK_ELEMENT_INST_U32(IP_PROTO, 0x08, 0, 8),
-	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 8),
+	MLXSW_AFK_ELEMENT_INST_U32(SRC_SYS_PORT, 0x0C, 0, 16),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4[] = {
-- 
2.20.1

