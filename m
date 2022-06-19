Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDFB5509AD
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiFSKbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiFSKbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:31:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E48CFD1F
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9AmBzRBZ8UzaDx03c/LykCG4PHmpLQqXD7fxIFjNh7Lvbetesb7UQQBezrgk2XH9F+ARkBopK89GiVG3bkhTC4K3Il0roK04rRcgj3j8NIY21KJpKu3cAgAq7Kh3RxkTEE52nOwYDQNXoEEW6XYvattxlGLxYaFKxavj1OTAqP6QF8BflDhxYh15Rl2F5brg0zVEBuvyRX6ZMgaqXLr8AyRwFfW5gbR+v6rNW/NLb5znk0tgvMsQiDHTWlCxJapUXHSPUWClq0xIe4Y4FjyMBNz8KX2kWydXBdko9tbeAJbIGgi94hSd+0dg/E0qrj6LX5y++XSSuvCsitw2VdEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vYXvLUk/7LTbTAr0fRwg6T8tEtlha5cpODhFWpcjlQ=;
 b=R3MuFY/m3n/Vg7DNxcvPEOvuj6JKcndcnIbgtc0Mb+/P8KstpzitI6AQ79bUrnxJMTS4rZYlbNfXd6WluBdw4KNS8dJ1brFIxEOlwb5mF91mpW5tx5zmJaydey/JHCbpW2rCeyfz6tsUx/LpRDFv58b4Xowe2FEm6nBQ98hxPUgbB9DSjjYK+xwyOf7yPL8JoKvCx5Irk20ekeEB1NY+mtt+2yy/3S+Zz8ES+1SNbjqVzQAeDXFT0zjP6LmNwZh6+2Q8zhSPe1r2R4+ASpqo9T5WAtTkgeQY7nKWA0jHqhVNJmNzyuTfC0FbbHjmpYuytqp0j87eBzGJcbD0r2x/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vYXvLUk/7LTbTAr0fRwg6T8tEtlha5cpODhFWpcjlQ=;
 b=WZs/poBwiiIDGCD7WVlarGzNNP0sKRqEBpTNf7/0GGOW8pwMnMRo9ZfYecCYfmgO6MuE7io/4kQ/eK0/lSH8lZBZU2uGWQZnnp5SxCQvv13K6va7EFfJRgQjgCtT0vU5Eew1atPrauicaLcL5A5APwMV82V0Or+j1bie2fYiPHsv/g2bWykd6Ce4Ya2R9EM2jLo9K556DgTNH5T7QpvLy7owB/PXSLJCOhCYqHJoIqWu5Cb8ryAODTC83Z0mASf/chSROD8ACAnvMN3jSdut+sKYRVjjQCI4s33eypCfur3oaQHXcQjxK/ZPc1K4ulQlyn6rEo7TNMcrJ6aQe3tGrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:31:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:31:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/13] mlxsw: reg: Add support for VLAN RIF as part of RITR register
Date:   Sun, 19 Jun 2022 13:29:21 +0300
Message-Id: <20220619102921.33158-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0128.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 870aacff-eab0-4075-2f72-08da51ded345
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11931650D7A16EB29C114164B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKdv3guqaX0Um+MLOjTZ940joTFGFDw72MZgu41guftTDS7l8C7rXlvAeqwYLPcuvBb5SxHKMmljMCMSrKX24uopu08LPFsmWmSYe71fkW9kCSyMxyW83ysZMPThDjGi21QVsX9CzVz4xnYITk2z7V0cCF6Bb6E9v+xb9kgK6959r6ngb91IBxT4beWjzAoGdz6dg1Sh/LcBj5IL6IVe/dOgWHH+2vXWfzfGTE0tORkV79/E4cb8lbjYEhHhOL2Z527M9dP4gHTWDyRQRV7dKsG2a47hmRr2umkcROheKBiBWjeYuDfPZItOifP1ieNtwH4S+X3WDz3Rlek6h3OYooFSnmo65Ucwc6yDsVSaY9TSUKStsmokIsnIETMTPSAoRYYS0X0bpLvEtnNNWv9pimCDd2PU6qlNaCLFDLVyKricGOXW5aWXclDVcIdPvlhzaCe05MThJCPDDH0mr97gfbAIqSkxec3CUo2vuQ3O/edNnEg+4M0HKk0m5SFI6uM7vzzRj05Ch1p/gkOSZ8G12B4Ln9BUNmE4rCMOMUmu5OHwYh+nrMe91F66wlsIVTfMkQ/SrRLTlFj4jzAXtMlTweMaQppjpsHpjDyKhtEiEUMMas/pHPC/c7jZsgrMlyLjio9AQhkN98kQMdqUdcVvpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OWi+Q9T7SwGuyC9Z79FyEpurLH4fKbFmvdKbtG0YDudgWFSp6S0/Hc1qfsbq?=
 =?us-ascii?Q?RnvTkJVRh8wyce+mdF5lSluv/YXu3Xz3sQQuDsEhWkvKrAlFuBrlTpNc/gVV?=
 =?us-ascii?Q?U8mfJaohLmH/axC1xl4vpwQt94HXTvVjEx/OEccoGuu0h9jbSaKekgjU9Yw6?=
 =?us-ascii?Q?MzJSL53qZKfx1nfQsFq6kKoCCCU/52m1jCfeV/u8rMgJQKXJRHz/ANiJEoCD?=
 =?us-ascii?Q?FNDQ2WPyG5qFhjw8Qw/wceeZPDfAPX4opGRnZBabDUN6Ywi8TPsT4wV7XrKa?=
 =?us-ascii?Q?Kk36kWTzK29COCvWMvvBGcUCiNKnjt/FqyO2rd+aZtScVZcrcFIVmq9nuke4?=
 =?us-ascii?Q?mCE0WqNJjOMeIspVjedGvuzZliPwWtXUt9s3ArkJV8lB+ToZYMlTJH2m579+?=
 =?us-ascii?Q?HPYC32rQzybQJtotxtolYnRUqNjRkezNGdWSQH4+iH7d0X0MHDheVKDxVriT?=
 =?us-ascii?Q?3RwD+Z1v7JwjnPSoointaGWR+k+OuHbbdjBo79IjMt+pJQUQiPFgd1FM/dam?=
 =?us-ascii?Q?KMA42E6ChyxDqVBfgrZKY8xvKyzGlSGbZXAjDsb7rxhhv0FeEISUmin6NCwY?=
 =?us-ascii?Q?gEmXcCsC4puc0RG9K27viw4dDBLlxRvY7GDrV9glAQaHYJZlhoUbhEAuVjNs?=
 =?us-ascii?Q?GnQsrCQhD6wIpawSNVbOXdQxDZI2kz0ZFoFF/nlp5CggM591GyA3xUhdzPn6?=
 =?us-ascii?Q?2wQC1heQWJbkaotzcCHnEkyJVaIbUGmhPj4VnfpHT9YMUxooJhSs9ARETgxG?=
 =?us-ascii?Q?iTZCo0bMDhVBQMzgnlgVhkm6d1KQNSrPoGdqcScLWWpvlv2bO4l83XwIBqG9?=
 =?us-ascii?Q?CVPpfrV2lcs9OLSfCv7t16JKY1P7dNFockh+naaL/eDctW/C8aatNpfL43do?=
 =?us-ascii?Q?OfjwEP912ndmiqmuWuPO2D6pUammkK3btnGN7AKDwoFQserg58vbs3KUovjR?=
 =?us-ascii?Q?xyYahBGEkvWBUj4LjvlWsAvNqCRCMe4KZAoQjuF1/Mj62hzdsaTGSs3N2BgB?=
 =?us-ascii?Q?0dLf5HEe61viTC+DzptOzFB9CoWBg36Iz4l0TlU2YIdl8ZBOBkGTCvlB2NYZ?=
 =?us-ascii?Q?24pQNpMTjk/J6uHICrqPZSUP0INLoPNkCXbj9/g/z7t0YmnunfjTlrMDyos7?=
 =?us-ascii?Q?JnY6GOPSTYNFhvBc9BuAKedkbO6jGfICwfRZpPXu5t0cT90XE5BTPGktLvc4?=
 =?us-ascii?Q?3FRk+TqfPGncIFu2bN2IO+S2rcNZEJgzoWO5wvfmIXs8AK4qCZTXySgpBQ56?=
 =?us-ascii?Q?g4CGvx0JzAgUHe1p6c7luWzkXY7rh01nFz5TOO0OXGorNLgKnlWxYhZbcvFd?=
 =?us-ascii?Q?T7XsSuVdmbw3E6EuSrof4MzieCROcQiAPcglqN/mVbJ+DAApAXpXigKzbfzP?=
 =?us-ascii?Q?W8aXfoDRvuxfrIejmy+1LhLWJ4ZvqTOnuPnEIHqdCG8Dq/vZ3mcGifI4/AUl?=
 =?us-ascii?Q?/oXqWHxiIS96RrcSE/xyNJyFsfKUE7a5zAFbNzl9W6yGWNo5DLFqdH7ipQZU?=
 =?us-ascii?Q?Jtdp0q2glk3bFav4Pifr5n1/dEY+eUF+SaJOhr+5bhVN+abv31CJtq17Oers?=
 =?us-ascii?Q?1oVNzcDU7+XnTp7OCYh5DcoNydyJ0OSK7ibBjXeYM1tE6JjxrCxxipLCE67L?=
 =?us-ascii?Q?hxJIn8MMB1DJKZBfU+pT+heUdRjttSAC+u7DiQyrtOe9yRkoTdOkic0s/4aV?=
 =?us-ascii?Q?y6PyUDboJdLTOW/wFwqc7QaVE2jYekRea+ovgLtVU0T4BLSkhtqQpChHznEf?=
 =?us-ascii?Q?oxafq4oKZg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870aacff-eab0-4075-2f72-08da51ded345
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:31:09.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: br6AFs54UGZB697bHE8Z7DZxLEZn8jU6+W0JLlOizCNSd0+wnci39/bPTcCdg6eXSHqyMOENRlDCCX7D53ClXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Router interfaces (RIFs) constructed on top of VLAN-aware bridges are of
"VLAN" type, whereas RIFs constructed on top of VLAN-unaware bridges of
"FID" type.

In other words, the RIF type is derived from the underlying FID type.
VLAN RIFs are used on top of 802.1Q FIDs, whereas FID RIFs are used on
top of 802.1D FIDs.

Currently 802.1Q FIDs are emulated using 802.1D FIDs, and therefore VLAN
RIFs are emulated using FID RIFs.

As part of converting the driver to use unified bridge, 802.1Q FIDs and
VLAN RIFs will be used.

Add the relevant fields to RITR register, add pack() function for VLAN
RIF and rename one field to fit the internal name.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 29 ++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 33d460a60816..c9070e2a9dc4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6911,11 +6911,20 @@ MLXSW_ITEM32(reg, ritr, if_vrrp_id_ipv4, 0x1C, 0, 8);
 
 /* VLAN Interface */
 
-/* reg_ritr_vlan_if_vid
+/* reg_ritr_vlan_if_vlan_id
  * VLAN ID.
  * Access: RW
  */
-MLXSW_ITEM32(reg, ritr, vlan_if_vid, 0x08, 0, 12);
+MLXSW_ITEM32(reg, ritr, vlan_if_vlan_id, 0x08, 0, 12);
+
+/* reg_ritr_vlan_if_efid
+ * Egress FID.
+ * Used to connect the RIF to a bridge.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and on Spectrum-1.
+ */
+MLXSW_ITEM32(reg, ritr, vlan_if_efid, 0x0C, 0, 16);
 
 /* FID Interface */
 
@@ -6935,7 +6944,7 @@ static inline void mlxsw_reg_ritr_fid_set(char *payload,
 	if (rif_type == MLXSW_REG_RITR_FID_IF)
 		mlxsw_reg_ritr_fid_if_fid_set(payload, fid);
 	else
-		mlxsw_reg_ritr_vlan_if_vid_set(payload, fid);
+		mlxsw_reg_ritr_vlan_if_vlan_id_set(payload, fid);
 }
 
 /* Sub-port Interface */
@@ -7139,6 +7148,20 @@ static inline void mlxsw_reg_ritr_mac_pack(char *payload, const char *mac)
 	mlxsw_reg_ritr_if_mac_memcpy_to(payload, mac);
 }
 
+static inline void
+mlxsw_reg_ritr_vlan_if_pack(char *payload, bool enable, u16 rif, u16 vr_id,
+			    u16 mtu, const char *mac, u8 mac_profile_id,
+			    u16 vlan_id, u16 efid)
+{
+	enum mlxsw_reg_ritr_if_type type = MLXSW_REG_RITR_VLAN_IF;
+
+	mlxsw_reg_ritr_pack(payload, enable, type, rif, vr_id, mtu);
+	mlxsw_reg_ritr_if_mac_memcpy_to(payload, mac);
+	mlxsw_reg_ritr_if_mac_profile_id_set(payload, mac_profile_id);
+	mlxsw_reg_ritr_vlan_if_vlan_id_set(payload, vlan_id);
+	mlxsw_reg_ritr_vlan_if_efid_set(payload, efid);
+}
+
 static inline void
 mlxsw_reg_ritr_loopback_ipip_common_pack(char *payload,
 			    enum mlxsw_reg_ritr_loopback_ipip_type ipip_type,
-- 
2.36.1

