Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD15415E83
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241071AbhIWMkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:40:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59091 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241073AbhIWMkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:40:00 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id DEEDA5C0081;
        Thu, 23 Sep 2021 08:38:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 08:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1J3C++WJb27jUoYWF1N0uyXN7U3kSVrl8ggVGALGSpc=; b=lgRYzvNd
        8Ri/jIaTRlloXDEwPGREAh5us/y/wDas8cteDw5P153G3LabKvjB+ZNBug1zKl6i
        /TmneMN30dPfn8LXQXmu7//zfjs7hMlWZblHpwjhCjs3k6e3pn8F+g0GCZIR6q+A
        u0Keh4rKjoczfYPgeAdPOQbAgRIYhP0uPLdDysLUYfvhHL/DTgWE0jl//sORYvYD
        RrIze6AmnEnZBCjrG7LsTJJz/FPCRcZIA56ArhJ5Hd/Mwr0ZY95jvDeRofimZqoI
        Q1vn/OhEBn9tPb7OiPGTmCsYyzoQ0NSq1JO2S1xqMOFxKVi6UV8Ahv+h6KqiAzcG
        crb0s8GQTGxhdQ==
X-ME-Sender: <xms:RHVMYWiDGWOg5u7qjx09UYEAYRRHvPWQzHQqT3pGgP13zjFD5QCdPg>
    <xme:RHVMYXB_wrn05aiV1vHGd5Gyl-w-IxBdSfWg7fi5fGzvTtmdu3JCf2dFlcaSEnSwR
    aUu8D_7zQG4T8s>
X-ME-Received: <xmr:RHVMYeE672gY-qztsWy9X4pH-K42GQhp5TyVR9PsTwEsxeOU4Mm87EX6h73V36OtCIgRlkeTcapzZUL4rowmvr61Lpwq2Q5vBgFn-JmG-nR7HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepfeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RHVMYfSjEUctTVZkrqnOHp83IEzx8Bvgzu4_4SLX2qoMR4dXoETjEA>
    <xmx:RHVMYTzLAxXk-QgdOuuS7fnUHP0rxGKeSdScWAKSiPW4DUwQ4nC-dQ>
    <xmx:RHVMYd4MbD97XwOwl_mBLF93doOEnB4CZhnoGbGf4wZWot6Ps6cXXQ>
    <xmx:RHVMYeoSjiby_2UsgM6mGyme6QDb358wr77HWmVSNqCQAB2LUvnytg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/14] mlxsw: Add IPV6_ADDRESS kvdl entry type
Date:   Thu, 23 Sep 2021 15:36:58 +0300
Message-Id: <20210923123700.885466-13-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add support for allocating and freeing KVD entries for IPv6 addresses.

These addresses are programmed by the RIPS register and referenced by
the RATR and RTDP registers for IPv6 underlay encapsulation and
decapsulation, respectively.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h       | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 83ab1ea92d31..0ebbd9b04b89 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -747,6 +747,7 @@ enum mlxsw_sp_kvdl_entry_type {
 	MLXSW_SP_KVDL_ENTRY_TYPE_ACTSET,
 	MLXSW_SP_KVDL_ENTRY_TYPE_PBS,
 	MLXSW_SP_KVDL_ENTRY_TYPE_MCRIGR,
+	MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS,
 	MLXSW_SP_KVDL_ENTRY_TYPE_TNUMT,
 };
 
@@ -758,6 +759,7 @@ mlxsw_sp_kvdl_entry_size(enum mlxsw_sp_kvdl_entry_type type)
 	case MLXSW_SP_KVDL_ENTRY_TYPE_ACTSET:
 	case MLXSW_SP_KVDL_ENTRY_TYPE_PBS:
 	case MLXSW_SP_KVDL_ENTRY_TYPE_MCRIGR:
+	case MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS:
 	case MLXSW_SP_KVDL_ENTRY_TYPE_TNUMT:
 	default:
 		return 1;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
index 3a73d654017f..10ae1115de6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
@@ -35,6 +35,7 @@ static const struct mlxsw_sp2_kvdl_part_info mlxsw_sp2_kvdl_parts_info[] = {
 				 MAX_KVD_ACTION_SETS),
 	MLXSW_SP2_KVDL_PART_INFO(PBS, 0x24, KVD_SIZE, KVD_SIZE),
 	MLXSW_SP2_KVDL_PART_INFO(MCRIGR, 0x26, KVD_SIZE, KVD_SIZE),
+	MLXSW_SP2_KVDL_PART_INFO(IPV6_ADDRESS, 0x28, KVD_SIZE, KVD_SIZE),
 	MLXSW_SP2_KVDL_PART_INFO(TNUMT, 0x29, KVD_SIZE, KVD_SIZE),
 };
 
-- 
2.31.1

