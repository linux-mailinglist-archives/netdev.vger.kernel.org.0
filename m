Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7144744E1
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhLNO1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:27:00 -0500
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:32160
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232459AbhLNO07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQmI+NMf6B61enoM2+R1ylI+nICLANL0xTg3ba6pise7omiVqen1uZ/CJgo/M2sbByNNPdesHILsy9FEsecxoOcu9ZRK//jrloiUGN5AI26dSp6+y5n5WrlDdGFhS2B9wttat2XcL8VXPPSjSqoH58y8Te1sqJXXPr3HoMEcn8Xilwswhk5mo1Mc/uCMUZs4/3F312yuPo4AzTvp5DNjWlMjVtP8Rq6gNSdqmPRmB9L3EkrJCWik+X47H4xbmk5g4VYQGDPdi8aLp5xq9db1QaWI4x1fPOd/5jaLLHquUFjZUSNX1g0H8ab0gTo8LrMBDvUbgF+xeIPWsoLZE7uqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YltDwW3fLo2qwXucgfJUSgQZRf1KlfwcY6A7VADEX1I=;
 b=AugXOsQfnE61QlBzx69F7FY0vkDGmhqeaUYDVWyq8BqTrgsVWZgrt7FvUvZCvbPzH1jAWGZlxBPSStsXbX+J9GlyW3Qso2txRTHm5CMwBiYDqnJFUF7YJLoRZ8VNlWltireHf/nz2ZFNXriSSI7pvXIXlnCrNx26rBVsB8rtRn9sPnkqLeZZJiT315gdGu2Roh0LwBBi9jndlfcY9MIVgJxnSNLGbA3TWMQbRyDILjlOJ2xFNP6v2LtApVMmrbiehtAl4c/W1we0+JW5Ni9WMlRyR8SXJ1DUgfXn+lnKNOJZOOf+XgXHjIeltRzhqITeFZnOnYYNJeOox5kVhzPplA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YltDwW3fLo2qwXucgfJUSgQZRf1KlfwcY6A7VADEX1I=;
 b=XgHqvM+pgfXE+41cBvZmbA5ClmG/Wct7HosrnuQkMrlppUhCCG42SSh+J2kkErLjsMGwQv1jChHQ8y8fv6O5EoayhmHKN4iiOOITT4mEqlaeYdq+NRr5Haz43xDmGpdkJgMJ1gnsIBdTe8ghX92ZQI4llBPzUhihDbtWlKxkABeeCNY82s7TvVOxV1fzLKVuLQz5uwlgM6iyTJ2aFnCg/oDuPbVE76PmvNGz7tDEMslR/JxDM/DoldDdeaKIe8ooGXeBacJDTax/MXMigcjG/WGL1JZJbTTBsKdPS+Pp4pgyeDzTcPKy4Hry4QIZ7I7uWLA/h4I0+mndWlG1YtKNQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 14:26:57 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: Add support for VxLAN with IPv6 underlay
Date:   Tue, 14 Dec 2021 16:25:50 +0200
Message-Id: <20211214142551.606542-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0062.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::26) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0062.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::26) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 660234c8-6cdf-4a07-9f01-08d9bf0dc8a6
X-MS-TrafficTypeDiagnostic: BYAPR12MB3031:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB303142440799C7E7351DA15BB2759@BYAPR12MB3031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jmSs43AmUMMXjFztjLPNSZDhQPRVoNA/kPsIv4PCMVcpvUyokRhV64vc60fkKjqqP6J5fjphuxNBAXecwRun7l6PS+v30ggIxnoAWHNfV7DvGMA2j/51p1/oUTYQ4PHSJYCHH1cCl72wMbQU9z5bi8pojvIqpXEgvizOe8R4YKMdEjR4QeyV53CJEm0N+RZDaQKVEZ7qtoez87ARcKGU02+5J26pRl2/PU9KQLZfd5JzhfZ+jcZ8dHFnrSyvryqYlfoUfw1Pkc/418U0Fa9xjhy+weL9HKgLaUqw3wVCIz09WYos6mGpm+hXWXbdsNXlYfzC3+2t5/y0MaHJIOeILFtl73sd5aRffFfEXZeq5oMb0fhxLde3SV6vqLWfh5gCq5qTh3TRVmpsgoGgav3ZOG4hNnU127Vd23iiBYww+9Z9puU/aHFDPtOkDidmloAYVTchUTCG5kGlPy/ffXpE1dmZ54KUhfCYLE67OKPIniP6NQBwIvYDcqAKJadM0omUK7BugE1zjjCVVzDp7QPxGMUsQgCcpZutXCX3XbR0SdlcJiFRr9jTze+8EL2Jtmt1VpKdqOKAjslB0P8oqtZmyaSfpDQsxz9nZfPYp2B/+UCNnqNvXB9dmVBK4Agl9lii5ALpnXV2exg/JQ18LjmlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66946007)(6496006)(508600001)(8936002)(83380400001)(107886003)(66574015)(2906002)(66476007)(66556008)(86362001)(186003)(38100700002)(316002)(4326008)(8676002)(2616005)(1076003)(5660300002)(6486002)(36756003)(6916009)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GxGGKN8iZSiCQdlBKcOz7akb24qpPCZMoyv6XdfOicFZDQXETG9ht+H5xS9z?=
 =?us-ascii?Q?1Z4gcnlvSZj2Lzzfqr/klYJ8yVht1os4OWp4lTixPJIohdDflcwTBBnWVJsV?=
 =?us-ascii?Q?9VBodpD8t/TOey/zIg7yuyCMT2lzBVJWuVTgFnO4aZvRvRNIR0n6GNahZE6d?=
 =?us-ascii?Q?O3uPpZlAOGeROyeHTg6oo4b9xoUBdesSnA1Ij2N5OWMy4863i3y+7p4c7HJa?=
 =?us-ascii?Q?YSe74n1+FOssELqXB2eur89/wMryJLGYXIV69FoEDsBV8P/nRrBjdjtMXA5S?=
 =?us-ascii?Q?K2AGg8BeeM1yCFMe+v2ss68w+umfh5Ub3LG3iFyfWeQGdciKH9BaFmUdwbHz?=
 =?us-ascii?Q?4VjlR0lBwKbwMRIaRuIUj7SKsQI186ToIn0vipnw4SF89vnY9EenINl9bFLD?=
 =?us-ascii?Q?g+KyecV+YnF/j6S2JTuDaxj7UAO1trEzVQgqr8c5B4geVG+7OSydj4Lg5Z7G?=
 =?us-ascii?Q?G/YYytPKgbZtdYE1hWcAQ0QO8EG6BnlbFhsLwoYSO0LMuU/VOZx67l9WX9K/?=
 =?us-ascii?Q?xKwYr6nlkGhFZteYXZSz4eKZ7q0ivm5+mYKPq3Zng1AYjUSKvnpxnTVVT0hA?=
 =?us-ascii?Q?137hmG0DhObQt8YrNi7wowQW8G5D8x7is+xB5Cipxg629ufpjiWwWRdaXZ1N?=
 =?us-ascii?Q?4wVfatcF81/kKuwojXksX667r1+cjAIBGR4e0flW1beCsccoLIi4z1d3K82q?=
 =?us-ascii?Q?q2HdLxYbWAtCpMijm5SpM/JtVnUmGnQLoGr2rkjlQciKVIcM+A10/FwxhSDc?=
 =?us-ascii?Q?IxIt9qqpSwGgCrrO8Rx8Flwt1jCXcIuaQVAQ/XdiPCW4yPuavJuXLCowjzgY?=
 =?us-ascii?Q?9mcGYlLpna+h69AakeR3n19s9RhcmQkpIthURWTPc6bH7Z1rb/u2l0lAJ/ZI?=
 =?us-ascii?Q?JPPhomMkYfF9VyIcErGOcjnPAqqemH50u2dDaYIh7MfONYT1/DmVp6yVx7HT?=
 =?us-ascii?Q?OKoND3KBI7fAl4hndq1YZRoFp/WcvbSaBFt3e34hfpSSKTAVbGQSVidpQrtn?=
 =?us-ascii?Q?9q3iQyLAMPuZQxcb5mhtPbrs3r6GgrKHHE/90pI/CzBx3meW97gtufle926t?=
 =?us-ascii?Q?0J0eZP5x+fsH5KNwuipkupmAdEtUfhJB+3s7qURM3yxB/evjWmh35wV4g6DQ?=
 =?us-ascii?Q?Hw2d4zoPWNAJPFOHPukxXy8nc2fCiHXsjvogBvIpg5yMkeGEh1ZgaHGOPmUQ?=
 =?us-ascii?Q?5/fUQ7/tQ8kZtJ2ACnZHlRKkPG1c2RBR+tYel6jn7PnLOYy+vD9YCKQrGgco?=
 =?us-ascii?Q?MqPPu6k7DfRIh30xuYJBZ5bGYM00ibIjSI6nh/ye863p6JgT2LwbD2qJbhu4?=
 =?us-ascii?Q?BoWQUXid7/4IBxYAu4p1CTNr3s2kuhbJsRRKf9Nfm6n9m7sm/rR+xcN2fjij?=
 =?us-ascii?Q?Y67rvfWthiR39HipqkQ18RCuA3HdeKpwnsNZINI2VJCKQJv/TFinwAECT+DI?=
 =?us-ascii?Q?CtFJRynFbepBh7kt+YDngY2D7K8E95cYZuDaGrCT8wZH2a6px8dA0q/PI0ho?=
 =?us-ascii?Q?BHfRmGVuLo43w+vY8OlkQu6Hf+OQWgz5MKQDYzXCkO2mOwFfubY94f3QzXoz?=
 =?us-ascii?Q?J5g3pF6L0cH/PFmuV01i67YNVmiBulyqLQcS493ZdXI+4rU75CxGM4xn9eC4?=
 =?us-ascii?Q?xkxcVnQc0R4Cq1OOY8VXGcTnIGb49sj5MaoXx/Vbl5z+P9hEAsqJJBZrc8yd?=
 =?us-ascii?Q?lMbB238CFwvR6jWp7D2055EdjKo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660234c8-6cdf-4a07-9f01-08d9bf0dc8a6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:57.6478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fiy6KlnK9ENk9xoTlnY89O3nQwwyeoOU1ZttuVeSw/+BEY31LRqVg1X+/Q+wr+f5oylAeh4P2iwmoy+aGVow+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, mlxsw driver supports VxLAN with IPv4 underlay only.
Add support for IPv6 underlay.

The main differences are:

* Learning is not supported for IPv6 FDB entries, use static entries and
  do not allow 'learning' flag for IPv6 VxLAN.

* IPv6 addresses for FDB entries should be saved as part of KVDL.
  Use the new API to allocate and release entries for IPv6 addresses.

* Spectrum ASICs do not fill UDP checksum, while in software IPv6 UDP
  packets with checksum zero are dropped.
  Force the relevant flags which allow the VxLAN device to generate UDP
  packets with zero checksum and also receive them.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    | 14 +++-
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 66 +++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 14 ++++
 .../mellanox/mlxsw/spectrum_switchdev.c       | 84 +++++++++++++++++++
 4 files changed, 168 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index dfe070434cbe..d2b57a045aa4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -130,15 +130,25 @@ mlxsw_sp_nve_mc_record_ipv6_entry_add(struct mlxsw_sp_nve_mc_record *mc_record,
 				      struct mlxsw_sp_nve_mc_entry *mc_entry,
 				      const union mlxsw_sp_l3addr *addr)
 {
-	WARN_ON(1);
+	u32 kvdl_index;
+	int err;
+
+	err = mlxsw_sp_ipv6_addr_kvdl_index_get(mc_record->mlxsw_sp,
+						&addr->addr6, &kvdl_index);
+	if (err)
+		return err;
 
-	return -EINVAL;
+	mc_entry->ipv6_entry.addr6 = addr->addr6;
+	mc_entry->ipv6_entry.addr6_kvdl_index = kvdl_index;
+	return 0;
 }
 
 static void
 mlxsw_sp_nve_mc_record_ipv6_entry_del(const struct mlxsw_sp_nve_mc_record *mc_record,
 				      const struct mlxsw_sp_nve_mc_entry *mc_entry)
 {
+	mlxsw_sp_ipv6_addr_put(mc_record->mlxsw_sp,
+			       &mc_entry->ipv6_entry.addr6);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 766a20e05393..d309b77a0194 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -12,6 +12,9 @@
 
 #define MLXSW_SP_NVE_VXLAN_IPV4_SUPPORTED_FLAGS (VXLAN_F_UDP_ZERO_CSUM_TX | \
 						 VXLAN_F_LEARN)
+#define MLXSW_SP_NVE_VXLAN_IPV6_SUPPORTED_FLAGS (VXLAN_F_IPV6 | \
+						 VXLAN_F_UDP_ZERO_CSUM6_TX | \
+						 VXLAN_F_UDP_ZERO_CSUM6_RX)
 
 static bool mlxsw_sp_nve_vxlan_ipv4_flags_check(const struct vxlan_config *cfg,
 						struct netlink_ext_ack *extack)
@@ -29,6 +32,27 @@ static bool mlxsw_sp_nve_vxlan_ipv4_flags_check(const struct vxlan_config *cfg,
 	return true;
 }
 
+static bool mlxsw_sp_nve_vxlan_ipv6_flags_check(const struct vxlan_config *cfg,
+						struct netlink_ext_ack *extack)
+{
+	if (!(cfg->flags & VXLAN_F_UDP_ZERO_CSUM6_TX)) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Zero UDP checksum must be allowed for TX");
+		return false;
+	}
+
+	if (!(cfg->flags & VXLAN_F_UDP_ZERO_CSUM6_RX)) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Zero UDP checksum must be allowed for RX");
+		return false;
+	}
+
+	if (cfg->flags & ~MLXSW_SP_NVE_VXLAN_IPV6_SUPPORTED_FLAGS) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Unsupported flag");
+		return false;
+	}
+
+	return true;
+}
+
 static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 					   const struct mlxsw_sp_nve_params *params,
 					   struct netlink_ext_ack *extack)
@@ -36,11 +60,6 @@ static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 	struct vxlan_dev *vxlan = netdev_priv(params->dev);
 	struct vxlan_config *cfg = &vxlan->cfg;
 
-	if (cfg->saddr.sa.sa_family != AF_INET) {
-		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Only IPv4 underlay is supported");
-		return false;
-	}
-
 	if (vxlan_addr_multicast(&cfg->remote_ip)) {
 		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Multicast destination IP is not supported");
 		return false;
@@ -76,6 +95,10 @@ static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 		if (!mlxsw_sp_nve_vxlan_ipv4_flags_check(cfg, extack))
 			return false;
 		break;
+	case AF_INET6:
+		if (!mlxsw_sp_nve_vxlan_ipv6_flags_check(cfg, extack))
+			return false;
+		break;
 	}
 
 	if (cfg->ttl == 0) {
@@ -103,6 +126,22 @@ static bool mlxsw_sp1_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 	return mlxsw_sp_nve_vxlan_can_offload(nve, params, extack);
 }
 
+static void
+mlxsw_sp_nve_vxlan_ul_proto_sip_config(const struct vxlan_config *cfg,
+				       struct mlxsw_sp_nve_config *config)
+{
+	switch (cfg->saddr.sa.sa_family) {
+	case AF_INET:
+		config->ul_proto = MLXSW_SP_L3_PROTO_IPV4;
+		config->ul_sip.addr4 = cfg->saddr.sin.sin_addr.s_addr;
+		break;
+	case AF_INET6:
+		config->ul_proto = MLXSW_SP_L3_PROTO_IPV6;
+		config->ul_sip.addr6 = cfg->saddr.sin6.sin6_addr;
+		break;
+	}
+}
+
 static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 				      const struct mlxsw_sp_nve_params *params,
 				      struct mlxsw_sp_nve_config *config)
@@ -115,8 +154,7 @@ static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 	config->flowlabel = cfg->label;
 	config->learning_en = cfg->flags & VXLAN_F_LEARN ? 1 : 0;
 	config->ul_tb_id = RT_TABLE_MAIN;
-	config->ul_proto = MLXSW_SP_L3_PROTO_IPV4;
-	config->ul_sip.addr4 = cfg->saddr.sin.sin_addr.s_addr;
+	mlxsw_sp_nve_vxlan_ul_proto_sip_config(cfg, config);
 	config->udp_dport = cfg->dst_port;
 }
 
@@ -124,6 +162,7 @@ static void
 mlxsw_sp_nve_vxlan_config_prepare(char *tngcr_pl,
 				  const struct mlxsw_sp_nve_config *config)
 {
+	struct in6_addr addr6;
 	u8 udp_sport;
 
 	mlxsw_reg_tngcr_pack(tngcr_pl, MLXSW_REG_TNGCR_TYPE_VXLAN, true,
@@ -135,7 +174,18 @@ mlxsw_sp_nve_vxlan_config_prepare(char *tngcr_pl,
 	get_random_bytes(&udp_sport, sizeof(udp_sport));
 	udp_sport = (udp_sport % (0xee - 0x80 + 1)) + 0x80;
 	mlxsw_reg_tngcr_nve_udp_sport_prefix_set(tngcr_pl, udp_sport);
-	mlxsw_reg_tngcr_usipv4_set(tngcr_pl, be32_to_cpu(config->ul_sip.addr4));
+
+	switch (config->ul_proto) {
+	case MLXSW_SP_L3_PROTO_IPV4:
+		mlxsw_reg_tngcr_usipv4_set(tngcr_pl,
+					   be32_to_cpu(config->ul_sip.addr4));
+		break;
+	case MLXSW_SP_L3_PROTO_IPV6:
+		addr6 = config->ul_sip.addr6;
+		mlxsw_reg_tngcr_usipv6_memcpy_to(tngcr_pl,
+						 (const char *)&addr6);
+		break;
+	}
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 764731eae2cd..d40762cfc453 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1307,6 +1307,10 @@ mlxsw_sp_router_ip2me_fib_entry_find(struct mlxsw_sp *mlxsw_sp, u32 tb_id,
 		addr_prefix_len = 32;
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
+		addrp = &addr->addr6;
+		addr_len = 16;
+		addr_prefix_len = 128;
+		break;
 	default:
 		WARN_ON(1);
 		return NULL;
@@ -7002,6 +7006,8 @@ mlxsw_sp_fib6_entry_type_set_local(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_nexthop_group_info *nhgi = fib_entry->nh_group->nhgi;
 	union mlxsw_sp_l3addr dip = { .addr6 = rt->fib6_dst.addr };
+	u32 tb_id = mlxsw_sp_fix_tb_id(rt->fib6_table->tb6_id);
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	int ifindex = nhgi->nexthops[0].ifindex;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
 
@@ -7015,6 +7021,14 @@ mlxsw_sp_fib6_entry_type_set_local(struct mlxsw_sp *mlxsw_sp,
 		return mlxsw_sp_fib_entry_decap_init(mlxsw_sp, fib_entry,
 						     ipip_entry);
 	}
+	if (mlxsw_sp_router_nve_is_decap(mlxsw_sp, tb_id,
+					 MLXSW_SP_L3_PROTO_IPV6, &dip)) {
+		u32 tunnel_index;
+
+		tunnel_index = router->nve_decap_config.tunnel_index;
+		fib_entry->decap.tunnel_index = tunnel_index;
+		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 53473647870d..65c1724c63b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1321,6 +1321,88 @@ mlxsw_sp_port_fdb_tun_uc_op4(struct mlxsw_sp *mlxsw_sp, bool dynamic,
 	return err;
 }
 
+static int mlxsw_sp_port_fdb_tun_uc_op6_sfd_write(struct mlxsw_sp *mlxsw_sp,
+						  const char *mac, u16 fid,
+						  u32 kvdl_index, bool adding)
+{
+	char *sfd_pl;
+	u8 num_rec;
+	int err;
+
+	sfd_pl = kmalloc(MLXSW_REG_SFD_LEN, GFP_KERNEL);
+	if (!sfd_pl)
+		return -ENOMEM;
+
+	mlxsw_reg_sfd_pack(sfd_pl, mlxsw_sp_sfd_op(adding), 0);
+	mlxsw_reg_sfd_uc_tunnel_pack6(sfd_pl, 0, mac, fid,
+				      MLXSW_REG_SFD_REC_ACTION_NOP, kvdl_index);
+	num_rec = mlxsw_reg_sfd_num_rec_get(sfd_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfd), sfd_pl);
+	if (err)
+		goto out;
+
+	if (num_rec != mlxsw_reg_sfd_num_rec_get(sfd_pl))
+		err = -EBUSY;
+
+out:
+	kfree(sfd_pl);
+	return err;
+}
+
+static int mlxsw_sp_port_fdb_tun_uc_op6_add(struct mlxsw_sp *mlxsw_sp,
+					    const char *mac, u16 fid,
+					    const struct in6_addr *addr)
+{
+	u32 kvdl_index;
+	int err;
+
+	err = mlxsw_sp_nve_ipv6_addr_kvdl_set(mlxsw_sp, addr, &kvdl_index);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_port_fdb_tun_uc_op6_sfd_write(mlxsw_sp, mac, fid,
+						     kvdl_index, true);
+	if (err)
+		goto err_sfd_write;
+
+	err = mlxsw_sp_nve_ipv6_addr_map_replace(mlxsw_sp, mac, fid, addr);
+	if (err)
+		/* Replace can fail only for creating new mapping, so removing
+		 * the FDB entry in the error path is OK.
+		 */
+		goto err_addr_replace;
+
+	return 0;
+
+err_addr_replace:
+	mlxsw_sp_port_fdb_tun_uc_op6_sfd_write(mlxsw_sp, mac, fid, kvdl_index,
+					       false);
+err_sfd_write:
+	mlxsw_sp_nve_ipv6_addr_kvdl_unset(mlxsw_sp, addr);
+	return err;
+}
+
+static void mlxsw_sp_port_fdb_tun_uc_op6_del(struct mlxsw_sp *mlxsw_sp,
+					     const char *mac, u16 fid,
+					     const struct in6_addr *addr)
+{
+	mlxsw_sp_nve_ipv6_addr_map_del(mlxsw_sp, mac, fid);
+	mlxsw_sp_port_fdb_tun_uc_op6_sfd_write(mlxsw_sp, mac, fid, 0, false);
+	mlxsw_sp_nve_ipv6_addr_kvdl_unset(mlxsw_sp, addr);
+}
+
+static int
+mlxsw_sp_port_fdb_tun_uc_op6(struct mlxsw_sp *mlxsw_sp, const char *mac,
+			     u16 fid, const struct in6_addr *addr, bool adding)
+{
+	if (adding)
+		return mlxsw_sp_port_fdb_tun_uc_op6_add(mlxsw_sp, mac, fid,
+							addr);
+
+	mlxsw_sp_port_fdb_tun_uc_op6_del(mlxsw_sp, mac, fid, addr);
+	return 0;
+}
+
 static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
 					  const char *mac, u16 fid,
 					  enum mlxsw_sp_l3proto proto,
@@ -1332,6 +1414,8 @@ static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
 		return mlxsw_sp_port_fdb_tun_uc_op4(mlxsw_sp, dynamic, mac, fid,
 						    addr->addr4, adding);
 	case MLXSW_SP_L3_PROTO_IPV6:
+		return mlxsw_sp_port_fdb_tun_uc_op6(mlxsw_sp, mac, fid,
+						    &addr->addr6, adding);
 	default:
 		WARN_ON(1);
 		return -EOPNOTSUPP;
-- 
2.31.1

