Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126424AB048
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243953AbiBFPhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiBFPhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:37:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C434DC043186
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:37:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sx4TK+8FzEhdqbXSeVnNidTAxy6UwXKSfSHIjyBSXkkBuge1dq813P9oKst59t/joHymyeYt0wvSFQIY4AhJ2tdXJfANU8omMhB+pcL1mx2aULp6i03ty1Za9/YE9uyvzpObqxkHXzCfxiPrXFXGjZsG4mEixgpglxrak4WAgQWWKEjcU0dwnTM98OuY4D665XO7RBcYIdGgkxqb7mtWO4uM+6G2IShp8T5t7zHnT75Ct8q+Xs2Pq6Sxn3rUAF7+KN3hX6u5VCKVioEPzsFqfd+wKDSyq8S7rIsHsXRAAdNk7JqHf5G97ayGx1vFDMNqpqlAox0/qEpSzqmGx0lTsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZqrEsaOrrfXQaKNVEyMiwjknDyBZJ9tZW1JwRDmFeU=;
 b=AwGfGkQ6ipReFrpnsmaaed9iN6Xe0Yr6uQiIPZoGXFxBbRX59b/U6v9rX2iDjxmtm+a9csSDVDgoOUR8Od42z7E0xbr5QpUPtbitiaUufNTTQAUnr5d99YafR7gPC428QdtSZFs2EtffKMMxUsH9Zvx+DABz/VS8vduxAtK65JRB0JRCtG3Z/3yP6f87BBG3feb5+9wVbbhm/5XDYrd/nXfcLowLxNjfk8YBLilsGKGujsV+qBYQuBUYi492dYjvV3Ef94hS1Yn8QWcp9QwvuVIaovPvmXuIWHqpGorpuBt2LJI2iugJNdBZFDr9CpJ51TUJ7TaLj4cmFVE1f385Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZqrEsaOrrfXQaKNVEyMiwjknDyBZJ9tZW1JwRDmFeU=;
 b=tVF3HU/MrFFwJ7TnmJVNY+fz0WZZlrSzvS9guA8xNZ3Dzv1pJrXLqocD4sqMpcjRk4jTkPD0cuMDg6S/OFbuvW0F2Or0yb7rcIVtItczbNMEE8cHmV6F1blip78stQ5G3UJWIpt6dOWJpBh5t4vHEF7RCqn9o53XWaDzcnwHcyEkJTgdF3YEQdMvrQir5ZMK/vzezeyKm34wZrYy1GPKxS0ck1F4Gox2cZ2GZwl+k71OI+I8HC5n560cQuf32oD8iYhOt+wl9P0QcZrtfraB+y4+NJ8iZ6z28vfYvUabdGqAXXUm+W2e6yGNs6jI7DqVGxKmSzILEeFgk21M0ZyntA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN8PR12MB3395.namprd12.prod.outlook.com (2603:10b6:408:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sun, 6 Feb
 2022 15:37:16 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff%3]) with mapi id 15.20.4951.018; Sun, 6 Feb 2022
 15:37:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/4] mlxsw: core_acl_flex_actions: Add SIP_DIP_ACTION
Date:   Sun,  6 Feb 2022 17:36:10 +0200
Message-Id: <20220206153613.763944-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220206153613.763944-1-idosch@nvidia.com>
References: <20220206153613.763944-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0134.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::18) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27b6a3e5-a96e-4a76-6492-08d9e9868db6
X-MS-TrafficTypeDiagnostic: BN8PR12MB3395:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB339588DEE46813F8FAB8EC55B22B9@BN8PR12MB3395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6bhp03vAxBtsNX4Y6JUSRbCvipF/L4QpWsX1TIgaBp3T5BaU03AAtMRXjwUJqQnIuoG0Ko8y+fIcnVbDM2U7hpBQWiNvwFLtCIHRxR27c8UBt7ReLruqxNWK9oqz+C2yqmVW2j/wkBd6BXC0AuHfr/ochscGLSx+hR593efmAZI4tFCyq28xUPnccURy5JBz3Xn4hpEvk1OGZbri0eBbH7OL+2lHpQQjP8YGsiwVvTHzEgyA9j8QMzj1YzfRuYQnP777s2qnOURED48I/aUB5NEvdmvs1wTVbAYPs0R7g1i2Of3OdGKQ1O6LRFsdEegeQqnGmj0lTS5UfRJwQuzh98r73zDvIsSL/NEKqBzWdaPo3MRMj7nyvviDBD0shZKgjRTvn/q0mS0dIDQiH+3QyCObem4GMoZEBGEmW3cPIG+CzaX9IlMgE5jrSpbg2bHIxFzljT6ywu535gTwvQiywSESvw+RwX9MWDKA8iir2wmY1qZObHdDoHBr+1vu09jlc4MX1aF0HQkR1IcuzunjnvItHsdJ09Gh6iszaEfPPNFEiR/ufc6iOepAOgcJzdO96lEo1oC/eOjdFDBXx9+yPkOj8jujh2kM+tYLDvJ2HHkN0teRXscIoEgtGNNojNiz+bpJxjnqh5FI1mOE+CzIPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(26005)(186003)(83380400001)(6506007)(6666004)(6512007)(5660300002)(6916009)(316002)(36756003)(8676002)(4326008)(2906002)(66556008)(66476007)(86362001)(8936002)(66946007)(508600001)(107886003)(1076003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XDowa06lkGL+Lj1GiEHChtJ3rzEd8/I12SVVg3fBj2uAUFuZH7GimzrOssg3?=
 =?us-ascii?Q?0JGfNkfHlxb25gPX/FNd9b+e98dr+2Fva0SzciPM3r5ZaHwkQ5inJlL8wswo?=
 =?us-ascii?Q?05mHLF83NvYGTnpJ3SHzU/wAvfX4kAlLtbzzPyfK76Gf1qFMDA2vyJD7eTkn?=
 =?us-ascii?Q?TKki4tYvgUiFDxBrC7wIIxaHyI4/p8IhlJp34urAvlpoPje+Sm4idaltK/u/?=
 =?us-ascii?Q?y0rEaAIZRNV8CGEjpfhxVtPId595AGEA9q2Uhwf3VdxUwQfUhOBSdZHfyJMG?=
 =?us-ascii?Q?munxVofEaead3hX8H+TQBW22aVib03Gf7X8hG3WVwWnM018Xd6S5O0DhH9Fp?=
 =?us-ascii?Q?zYywR15vvCphZ6eADN0mpcamVDZquXvoQBtKkXWmH1bXc8x0tx3dH7nfzp4Y?=
 =?us-ascii?Q?SkgC7AyuKiQqZ1SZNOallMANX0k5EAnEAqfw2OMv7E4TNsbNJ6y6iMD/qYDk?=
 =?us-ascii?Q?gWltzteyphtY+YneVLAp3E0T2UZYdNWtpLm+jDhOoszMe45dzPQqFSuYThXD?=
 =?us-ascii?Q?I+ZmqAWrkP1290L550jaZ3xI8+9wV13+EysbyNUDxS8k7FDkDI/5sa7U7ZRL?=
 =?us-ascii?Q?5B+xV76Ut7+0Es48RK16X09BgsD/PYAPLpZW46iydDatQt2OGM0ySYljwGYl?=
 =?us-ascii?Q?O9vgilbag0WDfgxKfa0Ady81UQOI9YmwfE2G1oI3pf7lMSbFuzXt4TojXNFY?=
 =?us-ascii?Q?PSDDX5sOXHjD3Bfmtz9I+6ZbD2WS2uAwf8iy9QfnLdXwBrikqDRwWKeHF59A?=
 =?us-ascii?Q?NBdUU7L0vGBnM953P3JhTL32uf+qaHud+t2seVPQCMa97AaKR3ab4soyGSSp?=
 =?us-ascii?Q?qdgcDKIOV6Nfij3xhoTtnqBE7uAbFsd7txfKubRMT7Xt90Gpb7homcOYgTEX?=
 =?us-ascii?Q?UWL45afn1iazNHhXcdDjhmneTqBK+UKTxKONHaw4S/2xPwWrH1rFjNwgtqnh?=
 =?us-ascii?Q?RovTRKX7AXKtsGTTta7FeCfWFhy9Sr/doXWbhWjmjwAfMwecUhnOtIYUUevb?=
 =?us-ascii?Q?pT+WFs13Fm428j44l9O2b4t97E8tttNoUVeD7c3wh/rL1WaRDXX4JSzJHdD2?=
 =?us-ascii?Q?jJB57mlyCtHDXcGxAtSq6n2OpUl0DpurwddyOIfBAntggLrU1mzDI312lX2R?=
 =?us-ascii?Q?bFgiy51g2S6f4yoYp3AaCZ77uLv5BE8P70edOd7x1gUu/XJYIe71cZo0uTl8?=
 =?us-ascii?Q?dTTXosZyaEC6s0l1see0MXh2mdaeSW9tGZbTjBYNsg/JXDqP0sJzRj10aMyr?=
 =?us-ascii?Q?kUxMws0SlZ8vNO6a51v3wLj4oZNDj3iooz02f9xgymkFojLQrX643JSsQQ9z?=
 =?us-ascii?Q?CUSJfU2jeb+3Ei5fBAQSrmPDcuqUnFBlqeg905j48DiqucWJVwn+03bO2IIg?=
 =?us-ascii?Q?a4VvAEAgSU+kO4S/Dz19RO62fYgacpQEhd0sGs55EWUPK6Y4wXOYKbBY4yrO?=
 =?us-ascii?Q?Dwd6HfIMjfFd+kbfYJQlFfUm93ojNbAa7rXS0bzoGC0h79fJyXInNXkn3cZP?=
 =?us-ascii?Q?MoyKaRI3twiikJ5wqHv8tQ0vpBJG774k5Bh/KGGETgvyAg+lULXGLPLQ3bx5?=
 =?us-ascii?Q?h5kH6CABLr0cPajLtZPXdZS+h0Q+P7A0UIas5lbsOH4JKB0tPMbodR9kV/aI?=
 =?us-ascii?Q?hccHqps3Lg0/hM65jOxAut0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b6a3e5-a96e-4a76-6492-08d9e9868db6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2022 15:37:16.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iiFtbK8zu4+UoeQeDXojadC3XCg86SM+90Zjj7UMBOF+Crpi8N5mfkoKKLM/LcThQWPQf+u8zk/w2zvS7RZs3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3395
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add fields related to SIP_DIP_ACTION, which is used for changing of SIP
and DIP addresses.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 77e82e6cf6e8..b6fe26ee488b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1957,6 +1957,51 @@ int mlxsw_afa_block_append_mcrouter(struct mlxsw_afa_block *block,
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_mcrouter);
 
+/* SIP DIP Action
+ * --------------
+ * The SIP_DIP_ACTION is used for modifying the SIP and DIP fields of the
+ * packet, e.g. for NAT. The L3 checksum is updated. Also, if the L4 is TCP or
+ * if the L4 is UDP and the checksum field is not zero, then the L4 checksum is
+ * updated.
+ */
+
+#define MLXSW_AFA_IP_CODE 0x11
+#define MLXSW_AFA_IP_SIZE 2
+
+enum mlxsw_afa_ip_s_d {
+	/* ip refers to dip */
+	MLXSW_AFA_IP_S_D_DIP,
+	/* ip refers to sip */
+	MLXSW_AFA_IP_S_D_SIP,
+};
+
+/* afa_ip_s_d
+ * Source or destination.
+ */
+MLXSW_ITEM32(afa, ip, s_d, 0x00, 31, 1);
+
+enum mlxsw_afa_ip_m_l {
+	/* LSB: ip[63:0] refers to ip[63:0] */
+	MLXSW_AFA_IP_M_L_LSB,
+	/* MSB: ip[63:0] refers to ip[127:64] */
+	MLXSW_AFA_IP_M_L_MSB,
+};
+
+/* afa_ip_m_l
+ * MSB or LSB.
+ */
+MLXSW_ITEM32(afa, ip, m_l, 0x00, 30, 1);
+
+/* afa_ip_ip_63_32
+ * Bits [63:32] in the IP address to change to.
+ */
+MLXSW_ITEM32(afa, ip, ip_63_32, 0x08, 0, 32);
+
+/* afa_ip_ip_31_0
+ * Bits [31:0] in the IP address to change to.
+ */
+MLXSW_ITEM32(afa, ip, ip_31_0, 0x0C, 0, 32);
+
 /* L4 Port Action
  * --------------
  * The L4_PORT_ACTION is used for modifying the sport and dport fields of the packet, e.g. for NAT.
-- 
2.33.1

