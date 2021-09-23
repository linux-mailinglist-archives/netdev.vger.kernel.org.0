Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181AF415E7D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbhIWMju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54601 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241033AbhIWMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:48 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 5CDB75C0120;
        Thu, 23 Sep 2021 08:38:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 08:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1EWlLXkzbLQZOKjAX5ddeLPsUvHgjm6Gp9LZCWknHEs=; b=kcmYtsYH
        kIiptzhc5Hq627x8MWUzynrn+zZ963K/9xYaAJSokRSPcGinmw362Mr9KHztVVEg
        acLOwa7yb2QgbaZ24mXGPEp60Pqj8QHaWTkG2Et3VfuldXOHmoTgt/YRQsKjnzwR
        6dglPff3kx5ao1nx6NwG/gJbphi3H6++LjKxghcrHGlwtVmMCpQ3aHZP5jktWiH6
        qxGK37MSqMTAx4ilW2nysMohBIpelnPNAaKAwIltoKpNHXvrkCIPZYmz/x27DDL6
        71nlEeSri3evfkfb7jWmpT1ofd6uuUKi6guDg6jQ7U52PkZlt8KuSBMyTw8V5QYN
        A9WOMmG4Y/7KwA==
X-ME-Sender: <xms:OHVMYV7S50WSo1PA248zVJqVrdAcIAXCzbbBHUMJZkxrkoyq0mvlWQ>
    <xme:OHVMYS4iU8WHIGRVyqYFOsBZs96NPay3dZXBTWtcWPXepWivU41i9CPpU9Lk8iloW
    xmEWz8MNafQIqw>
X-ME-Received: <xmr:OHVMYcc54xIfUYdZuxVaue4uYqvv5Kmdg1ru5G2kyRlrxnDZdGyPrGC3p9vqutEATy7Rb29UgdjrQGTw7taLYjDFa8yHzy7IsI2DYk-yO21T9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OHVMYeLP_0rMWIBDKJFHqIzUQ40ZFXUpnxCnqzJt3YVxks_QXMGnDA>
    <xmx:OHVMYZJTTKAN6Bk8hTAvGxFhQXavgDvRUCMdf-fHOAalw86ahWKpow>
    <xmx:OHVMYXxdE_txCB6qLaku_OfNAlXuKvyi93J1w90YEmw4tPD5qpps6Q>
    <xmx:OHVMYXjb5RbJ0HKgVS47OHqbjTSJaX5H1rWOPXTD8Ou5HSjB0HCeKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/14] mlxsw: reg: Add Router IP version Six Register
Date:   Thu, 23 Sep 2021 15:36:52 +0300
Message-Id: <20210923123700.885466-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The RIPS register is used to store IPv6 addresses for use by the NVE and
IP-in-IP.

For IPv6 underlay support, RATR register needs to hold a pointer to the
remote IPv6 address for encapsulation and RTDP register needs to hold a
pointer to the local IPv6 address for decapsulation check.

Add the required register for saving IPv6 addresses.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6c96e124e4c8..22f5c26fc0e7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8200,6 +8200,37 @@ mlxsw_reg_rtdp_ipip4_pack(char *payload, u16 irif,
 	mlxsw_reg_rtdp_ipip_expected_gre_key_set(payload, expected_gre_key);
 }
 
+/* RIPS - Router IP version Six Register
+ * -------------------------------------
+ * The RIPS register is used to store IPv6 addresses for use by the NVE and
+ * IPinIP
+ */
+#define MLXSW_REG_RIPS_ID 0x8021
+#define MLXSW_REG_RIPS_LEN 0x14
+
+MLXSW_REG_DEFINE(rips, MLXSW_REG_RIPS_ID, MLXSW_REG_RIPS_LEN);
+
+/* reg_rips_index
+ * Index to IPv6 address.
+ * For Spectrum, the index is to the KVD linear.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rips, index, 0x00, 0, 24);
+
+/* reg_rips_ipv6
+ * IPv6 address
+ * Access: RW
+ */
+MLXSW_ITEM_BUF(reg, rips, ipv6, 0x04, 16);
+
+static inline void mlxsw_reg_rips_pack(char *payload, u32 index,
+				       const struct in6_addr *ipv6)
+{
+	MLXSW_REG_ZERO(rips, payload);
+	mlxsw_reg_rips_index_set(payload, index);
+	mlxsw_reg_rips_ipv6_memcpy_to(payload, (const char *)ipv6);
+}
+
 /* RATRAD - Router Adjacency Table Activity Dump Register
  * ------------------------------------------------------
  * The RATRAD register is used to dump and optionally clear activity bits of
@@ -12281,6 +12312,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rtar),
 	MLXSW_REG(ratr),
 	MLXSW_REG(rtdp),
+	MLXSW_REG(rips),
 	MLXSW_REG(ratrad),
 	MLXSW_REG(rdpm),
 	MLXSW_REG(ricnt),
-- 
2.31.1

