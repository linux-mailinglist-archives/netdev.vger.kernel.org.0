Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3D21BF70
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGJV5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:00 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbgGJV47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:56:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsFZqxprPsDzk+b8h8My9X43kL43GNtqvx5+0pjlwt0a86jZScBiIlNzUIgLxpYrJny2msjyCxojbD1geyzGkNa6c6BVYLpPwTT1hXFsQ8ztLxekG+CHOgNolkmNQh/BjWRWTB+zAU04gkn1hIkiRjPrHeLcRBaIgIie0IDUSGmvbJUMTs0h+k6LPRqxGnjIDZfhHy0zuR/vpFXa+P/HchLiuSU2c7mmzvn4TCGBM+N+6fVEmTbHNOx6Uc1qsVnhZjtYvNYNAP2UTQmEa4NNEv5X9p2WschUZPeqkZZN7cFmAaMx0JVAAvK8ymMs7INNgVxf+Z2guzXo6n/4m2kj4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc1HhnHKCh7ScvnI6aHguqH675iLwRXp4OOaV45Nkks=;
 b=CRvSnmco/wIQ2LLOZEhMb9llEBASHvmS6tKx2fuHdE35/+d6LZU1ZKsPFgR5Bh0UPRBJhhXmJJNqHefosATo33G/OlC+nrnnByr55qgsgaHVkfnMpQn3rHtw4W4Z+LygZq2X9Irw3OMBLDPRV6gU5YepbnU984vrk9uU5hy9WdJEi3xYDMxe2aZkCbQXM+9z3/BZU582u6BI4rmtcNOiCR5DRhnBmueOYOibLasyU6lZaiWQ/wZjOrApD7n1kM5eKGSHb0ylKCKwPey7vufku48J9fT6Lybt34ISBhU1NK5DAaBLNQUpVdIKDuT9zGGq7L5vn0rrd1ZjY9tBkKPP+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc1HhnHKCh7ScvnI6aHguqH675iLwRXp4OOaV45Nkks=;
 b=mLntc/Eo2VM3m8+/RPns/8Zvc+pgRR7DAqjmpYs6u61bMU3kXZG4rni0k+qkyxa76z+d6EAUYMlNRiMk3hR+ACF4sJGko+Yp9y8p3twl8AlFIh6E6UA/rPK2FvYOlgNsqSKY4/N0xTqE17mtoQm3t4DAy0o2J/v+AwaFIzhi3XU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:49 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:49 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/13] mlxsw: spectrum_span: Move SPAN operations out of global file
Date:   Sat, 11 Jul 2020 00:55:06 +0300
Message-Id: <2e6893ccac65334fd64ae5cda6ff7e0876c254d9.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:47 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 598473a0-594d-4b48-f0c2-08d8251c2568
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33543A0AC6FBDCDC003AC0BEDB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHw19CXvIk+klvaEmZZC+M9bw3AHuySaMM+uF3u+IGRRejg/2DZA/o6EyEXkiwck9Jd78rO2zt8IMHxsdSv0CIdu7j/H8Kx2P/eUneYouimUZkmikNKrbqh9f+ur2yjPmb2pwQ/xTiWM8d6s2DEtHk5/0gy08HlF7ut2WTMHXt39dbZOdkPRMXa9I3Xm/PuP1wHvw9gj37djwsVBt8udISfndaKo5sl6jQ9e/ZOK4h7eWkaDECIh+/IpYIgph04nhSUu4IeOesKldFeZJ8aeFIE1I0E6pOJBpa9ngPf110XMmL7vPZcmlnIInCSRlp75i2Ps0eerIYJbJIl9aD/WHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HrmIQ4Iv73ir8o+mGhOGyTPZ6PYiZnh3DRKRcmnJYA1lWmCUtdzihojvzZnmcCWO2IJFgYHlhGVtGPFrW83cQP7roGNYIjpG0YACtZwYDH5p4WveGkiBnsiMtw3pVTNtV7apP83IeBb1rSttm8eMAe2m8duLtQ8PnIbRvd0gD3Ri5G2Kt75lUiCYlLKUJsYwpnT3wjI7A5w91EbAaqSWrHYdJLPI0y5sS+SP37iYwgnorEqEHPkOs2XQpt0Y9+6RWdRkKqkIJcmLXThnBAQ8Dx4vzrz2YAuhwJlifostFxo9Hxr1HnLAdm4diTiy+ow0dZ6xn/m7KVbaBQWdDlpzMuzz6wonvNvLbcmeiORsLPNhCanOallhxCeV1a/YWGV6YaDHw/wism7OWI7tmQNO3FcMJ8nADLcpnt6SD3zgrcJorO/txjkzzbQvLR8mxVDBMLaAlfV5xVdekwICdTIDMbf5D1eF4fzzKbvN6e6N6qNZAFMOwjG3XE3/RbdEcwfw
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598473a0-594d-4b48-f0c2-08d8251c2568
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:49.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIzxOp03uHFZHbRgmi/djGXIwRM7n6Nr9W89AFqBkq0PimTt1a3MwXHNuuZl4V3PD72W/FLRM1ah0pS6/M1ilg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The per-ASIC SPAN operations are relevant to the SPAN module and
therefore should be implemented there and not in the main driver file.
Move them.

These operations will be extended later on.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 50 -------------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 -
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 47 +++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  8 +++
 4 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index eeeafd1d82ce..636dd09cbbbc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -175,10 +175,6 @@ struct mlxsw_sp_mlxfw_dev {
 	struct mlxsw_sp *mlxsw_sp;
 };
 
-struct mlxsw_sp_span_ops {
-	u32 (*buffsize_get)(int mtu, u32 speed);
-};
-
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
 				    u16 component_index, u32 *p_max_size,
 				    u8 *p_align_bits, u16 *p_max_write_size)
@@ -2812,52 +2808,6 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.get_stats	= mlxsw_sp2_get_stats,
 };
 
-static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
-{
-	return mtu * 5 / 2;
-}
-
-static const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
-	.buffsize_get = mlxsw_sp1_span_buffsize_get,
-};
-
-#define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
-#define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
-
-static u32 __mlxsw_sp_span_buffsize_get(int mtu, u32 speed, u32 buffer_factor)
-{
-	return 3 * mtu + buffer_factor * speed / 1000;
-}
-
-static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
-{
-	int factor = MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR;
-
-	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
-}
-
-static const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
-	.buffsize_get = mlxsw_sp2_span_buffsize_get,
-};
-
-static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
-{
-	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
-
-	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
-}
-
-static const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
-	.buffsize_get = mlxsw_sp3_span_buffsize_get,
-};
-
-u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed)
-{
-	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
-
-	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
-}
-
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 1d6b2bc2774c..18c64f7b265d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -539,7 +539,6 @@ int mlxsw_sp_flow_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				unsigned int *p_counter_index);
 void mlxsw_sp_flow_counter_free(struct mlxsw_sp *mlxsw_sp,
 				unsigned int counter_index);
-u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed);
 bool mlxsw_sp_port_dev_check(const struct net_device *dev);
 struct mlxsw_sp *mlxsw_sp_lower_get(struct net_device *dev);
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 92351a79addc..49e2a417ec0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -766,6 +766,14 @@ static int mlxsw_sp_span_entry_put(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu,
+				      u32 speed)
+{
+	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
+
+	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
+}
+
 static int
 mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 {
@@ -1207,3 +1215,42 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
 }
+
+static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
+{
+	return mtu * 5 / 2;
+}
+
+const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
+	.buffsize_get = mlxsw_sp1_span_buffsize_get,
+};
+
+#define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
+#define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
+
+static u32 __mlxsw_sp_span_buffsize_get(int mtu, u32 speed, u32 buffer_factor)
+{
+	return 3 * mtu + buffer_factor * speed / 1000;
+}
+
+static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
+}
+
+const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
+	.buffsize_get = mlxsw_sp2_span_buffsize_get,
+};
+
+static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
+}
+
+const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
+	.buffsize_get = mlxsw_sp3_span_buffsize_get,
+};
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 9f6dd2d0f4e6..440551ec0dba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -34,6 +34,10 @@ struct mlxsw_sp_span_trigger_parms {
 
 struct mlxsw_sp_span_entry_ops;
 
+struct mlxsw_sp_span_ops {
+	u32 (*buffsize_get)(int mtu, u32 speed);
+};
+
 struct mlxsw_sp_span_entry {
 	const struct net_device *to_dev;
 	const struct mlxsw_sp_span_entry_ops *ops;
@@ -82,4 +86,8 @@ mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_port *mlxsw_sp_port,
 			   const struct mlxsw_sp_span_trigger_parms *parms);
 
+extern const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops;
+extern const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops;
+extern const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops;
+
 #endif
-- 
2.20.1

