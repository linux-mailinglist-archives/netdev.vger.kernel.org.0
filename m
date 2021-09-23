Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14091415E78
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbhIWMjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58715 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240874AbhIWMji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E90C5C00DD;
        Thu, 23 Sep 2021 08:38:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=IYq6AipQJAtvp2SULK3mwpQm0oyrVkwLnpLUXbUw5jY=; b=SQhF3Huw
        uKXVEe84N9Utz7Ol3baCTfVuFplwyzM3cDwAcnj0MIjA/FewMwRja31fr7mABkDq
        T47/i/OMSSA5uiRcez1USBR4RnE8mpiho5XruJblPma54DyryoZQEEqf2b6BCKN1
        rfgLJiWsf2Kjv3A449L4W/GJiz+IWbO+tbw8NUOc8F01qxvQeaRk2krH07woE2ps
        ALDTiX7Yukmv5ffkW7F5t9n4MdWZJOSUa+MQG22iVvpRRuJiIQ6LkvdH0o+OnGoG
        J1SXlvWy09VTNMaK2iAIuiCR0QQ0La33ncVXRNMsvm8Wky+qz/3Inw0wqqT9CUa1
        R0FMrLWUFJYIAA==
X-ME-Sender: <xms:LnVMYXbBAjvjww9NgQzra83eXDydGHvHeBPm1URuW55U5VJiineCRg>
    <xme:LnVMYWZ_uo701tehlSUgeAYgYBbrYB1ENd-GMpBAJQPsQrKb-AkDhjuZMNMV5bCnG
    YjRa5sZX3_XZzI>
X-ME-Received: <xmr:LnVMYZ86RjGZdEKQFmNOVogydqHocgkz9YC_SHu7eUXZO5POYDrWcu1mp8QiIetXvqgoFfQK66mQYyPQUpJUeQPsNnOxTmw3ExIhfcdotvNw_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LnVMYdo7CUWheLmB3hZ_aRFf7bmvkGBHE1KzGwc2XFcrO1EHMTNWmA>
    <xmx:LnVMYSoc8CWw7zA8Od5VDKnBkTKISa1Q8k1pXTK4AXIdHPRaX_SEvA>
    <xmx:LnVMYTRWKMTW9zeQ7XjVhAXMgworqJm7IqVceZseYt8jLx8DBKm9gA>
    <xmx:LnVMYfAFrXi1DI9BsWAazz1RG8l90Qy6drTDtQnWixU6O6tKz8DHsQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/14] mlxsw: spectrum_router: Create common function for fib_entry_type_unset() code
Date:   Thu, 23 Sep 2021 15:36:47 +0300
Message-Id: <20210923123700.885466-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

mlxsw_sp_fib4_entry_type_unset() is not specific for IPv4 FIB entry,
move the code to mlxsw_sp_fib_entry_type_unset(), and call this function
from mlxsw_sp_fib4_entry_type_unset() so then it will be used for IPv6
also.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c   | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 331d26c1181e..0454f3bc27d3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6069,8 +6069,8 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void
-mlxsw_sp_fib4_entry_type_unset(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_fib_entry *fib_entry)
+mlxsw_sp_fib_entry_type_unset(struct mlxsw_sp *mlxsw_sp,
+			      struct mlxsw_sp_fib_entry *fib_entry)
 {
 	switch (fib_entry->type) {
 	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
@@ -6081,6 +6081,13 @@ mlxsw_sp_fib4_entry_type_unset(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static void
+mlxsw_sp_fib4_entry_type_unset(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib4_entry *fib4_entry)
+{
+	mlxsw_sp_fib_entry_type_unset(mlxsw_sp, &fib4_entry->common);
+}
+
 static struct mlxsw_sp_fib4_entry *
 mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_fib_node *fib_node,
@@ -6141,7 +6148,7 @@ static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
 
 	fib_info_put(fib4_entry->fi);
-	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, &fib4_entry->common);
+	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, fib4_entry);
 	mlxsw_sp_nexthop_group_vr_unlink(fib4_entry->common.nh_group,
 					 fib_node->fib);
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
-- 
2.31.1

