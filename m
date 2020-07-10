Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CA21BF6E
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGJV4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:56:54 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbgGJV4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:56:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bc3FXf3nCYowH9KJJhMJvP4jY7rnJ+hYWLRfL1hg8o3jk22tG5dfLggQQbb3VE5wQZ/ccK/vsqwjASkczggOZrEz2Iib6KwfyBztLuX2sFtKcjZaMCjOOjBPf2edKysAfVOrFpcB9S2fUf1odIs9zz2ehk2ApnfrChYp9Hxjt+O9AJxF/bOpCCRyZddiRczbjFfCEwurWV6EJXZ3Z8i85muERMKelK32kOLCGQz1DMimzKzf036NsaPQEpDIAbyQfWcWp3GzPFYB0gqjdG40nzgDBQObF4rKdGmcTUKbKMJ/i5sh2IfCIAIijyvDtiYq2GQmsB6jlxuXd/wzp11upQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrZMY1OEEGTouL36PG3hV/9AdMKr+DIWys4Ccs2DbWw=;
 b=DuBiJsbT84dBRxaEOj1lV9KZSqgt7Xtbag66iwbIaVMRN3GElrKAFZsiTcfXHFqFrocVXV5fICQ1gjvc7sJJFbj8pZO2GB293GRhDC0y0CfB4rH0/uTdMBnu60ULW+FGFOgcGUl0rghJB6RJwctgDpcUYoG6LSyClnVPh14lxEoZsaLLNPvGVGWqX3bNRiLbkBaVk1PlLwZ5zjk8HBOzBJwaeFByE6UIrqx7Wtzj+s91JmfDdAOKycRfG6+4w00z/ga/PHCNXa8BLybcntJKLd+y9UtQIXxzz6ASvVg9Pkk3bcJ4j0x+cfX03REskuDnDyVGosAJLVbHmi0XBnnlEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrZMY1OEEGTouL36PG3hV/9AdMKr+DIWys4Ccs2DbWw=;
 b=NdTutI4FVP3ixxGQ64TzE24c2FclA/+5ZfPLa1BEIPFatJk2H6GKfe8Ew0zjfBvMQmmH2wo7nCdEyePBA6KNfke1ck69wtYAtTtP33g0ClBf1ZdP9ji3E5MkVX0qa2DHa6dmJ0FKP4TM1ybGx850eGAMgW6Xu3lUhiG2okBGqyg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:44 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:44 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH net-next v2 02/13] mlxsw: reg: Add Monitoring Mirror Trigger Enable Register
Date:   Sat, 11 Jul 2020 00:55:04 +0300
Message-Id: <b2cb5330e28e56a629df5c19a0f0c35dd41ccbc1.1594416408.git.petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:42 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d25728b8-00a1-491f-326f-08d8251c228a
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354E6B7E0E15BFFFAD25314DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C076kjS9LIHXYgScFLtpafGscQntigJ2oOpWD8CZpinUdSdvIIyCkbuUcRmU5wXXml7swwKXUFz7YimxiXLJEVVdpF+doV/zE9CdVzqxl7AIJ0vuHYkRRxwytHuq2mR79+4GgeB1xeZ0J8M2AGrgItX6oyjX/nHxFjxjilpg000BWU/BbohFsvP9HMsNs+rKyXlFTxbPjKTKiCZiIxoiXFQ3JMX9q87meSg5c1huJ02G0nJ2XOCgEThqtso2V2pAkCzpqCePTwrF6gVzPYeiclT3csn5/DbeEOZebXaTNoO7JYYcoTxy0KpHrBB61McE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o/foDYWEFu+POGmsVIGzkJWoPnqMqmHRNmntp7739idneAClAdZX9KnBvy9RNBnPac6lmrPwl8EoTepaI4YKabUNLCbMDQUxYkNQZP+fFkPIJFiB2MlaUFCkIlUOFRHX41lPf/6PmN0eco3FNLlCZy/1Vton6kfODWHPrXy1tIXuRi5mLXeI5ZeE93BusVxG50FQ2ckU63kxFN79X11blVquPFK6gPQqH4jnkz4tUk4anQHY6m75eOztD7ISonWIyzlPZr1F40+F5T1RXwSBP7HyPhcl5/6osDLyZ7Uk2cQ7H4IYt2SkY0UAZvkrh6P1tbqX7Ex5Sq3q2bp1yIuId9Bpy63cjK+LeU1ptSF/rKZhWBjNXKwPLD7zOpxJXdTznjicvrXp66NP69C+y5qrd80IOda9Vhhcg/ZTUdn5zvFIcyRBHg6rkultTh8nX8bjY9XtEtT3ZDW2hULLvUb/mN6WJ1rIqvJ26IsT9Pxo+ABAYTOiobbJyPJtOTUPDw9i
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25728b8-00a1-491f-326f-08d8251c228a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:44.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ALfBq30PNj6e9FZf1eAguo8e2MjG8o60IPtrsluBzlqL40lhaxL39t72KW+KVyYohc9ufQursY7fNVZCM18Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

This register is used to configure the mirror enable for different
mirror reasons.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b76c839223b5..aa2fd7debec2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9502,6 +9502,55 @@ MLXSW_ITEM32(reg, mogcr, ptp_iftc, 0x00, 1, 1);
  */
 MLXSW_ITEM32(reg, mogcr, ptp_eftc, 0x00, 0, 1);
 
+/* MOMTE - Monitoring Mirror Trigger Enable Register
+ * -------------------------------------------------
+ * This register is used to configure the mirror enable for different mirror
+ * reasons.
+ */
+#define MLXSW_REG_MOMTE_ID 0x908D
+#define MLXSW_REG_MOMTE_LEN 0x10
+
+MLXSW_REG_DEFINE(momte, MLXSW_REG_MOMTE_ID, MLXSW_REG_MOMTE_LEN);
+
+/* reg_momte_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, momte, local_port, 0x00, 16, 8);
+
+enum mlxsw_reg_momte_type {
+	MLXSW_REG_MOMTE_TYPE_WRED = 0x20,
+	MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_TCLASS = 0x31,
+	MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_TCLASS_DESCRIPTORS = 0x32,
+	MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_EGRESS_PORT = 0x33,
+	MLXSW_REG_MOMTE_TYPE_ING_CONG = 0x40,
+	MLXSW_REG_MOMTE_TYPE_EGR_CONG = 0x50,
+	MLXSW_REG_MOMTE_TYPE_ECN = 0x60,
+	MLXSW_REG_MOMTE_TYPE_HIGH_LATENCY = 0x70,
+};
+
+/* reg_momte_type
+ * Type of mirroring.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, momte, type, 0x04, 0, 8);
+
+/* reg_momte_tclass_en
+ * TClass/PG mirror enable. Each bit represents corresponding tclass.
+ * 0: disable (default)
+ * 1: enable
+ * Access: RW
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, momte, tclass_en, 0x08, 0x08, 1);
+
+static inline void mlxsw_reg_momte_pack(char *payload, u8 local_port,
+					enum mlxsw_reg_momte_type type)
+{
+	MLXSW_REG_ZERO(momte, payload);
+	mlxsw_reg_momte_local_port_set(payload, local_port);
+	mlxsw_reg_momte_type_set(payload, type);
+}
+
 /* MTPPPC - Time Precision Packet Port Configuration
  * -------------------------------------------------
  * This register serves for configuration of which PTP messages should be
@@ -10853,6 +10902,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mogcr),
+	MLXSW_REG(momte),
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
-- 
2.20.1

