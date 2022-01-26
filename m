Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACA849C796
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbiAZKbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:31:52 -0500
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:6624
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239996AbiAZKbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:31:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MREDtFkrDtwp6beeGo6TcaICDfJOxUpdJdukFvyzKeedZicIvH6ClwcxZeWWCBcsewuNaJYLgQX4uhd5OnfbgJE5mk05qp2ZWlA1ED8jz93gh+VXmBXmc5EmYD3FbjSCq1oVFV7eCGoC9Uk7XyoRmomKDVoO0RmJCdYv69NefCU5djEORuksN4KYsieiTNOiZwVfxboASb7kcZtc/d/R8g6AVkP2s+gNjMUcUWt1CNfyrTIhmd3wNWEMJZuXABH8DHHMp1b2Umo8iY6roYF5BVSdT9liAwXyF9VGe7ZsF6cqELhsc9dIFaSb4gX9zuVvh2/oKaoWJGI3eUtpjmPXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gV6JNj8ugacjTfwfeHNrCYf2k3MSVsHPDjXL4aqT1iw=;
 b=PBOrbyysKerH1RjUjitiRh6DOSIDYDd/9Ti8S86x7UQltCNHalco7bMmSixCamgHQQ9+vL3rcxa7CasJUEtxp1NZFa8qoWfS0hfBf4xtsTmBk/bfxjSWQGt6sacc1l7j783Mi9KvEHCYZONsMJoYCbT43esDFTkpsyGrsGmi98FyJ377APdjF5s/eBSAbWpjd3mPueuQmL6xZNxM0Xc8L2VlN4MvR6SpLO4Bbm0pb5r7lp6VnlAfvvzVMvEu//5tGh2Ukf5Rf5SiwtwFVUXuUm5SRS82VQ+R2WMhAH0At1A4t3hc1Z5Gw013qAFHKix27eSoqX1UDmGHKC9yqF7l7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gV6JNj8ugacjTfwfeHNrCYf2k3MSVsHPDjXL4aqT1iw=;
 b=aoc3TR1SLOJh6/0jmriz98JIXBad4/l7qj80BFT4Bf8n626a66+BlxRB2s3eTc/HajZr2U/S2/GPcYnBmJrnAUFyUgek8evjJ5bnxKR8xEWOvkXEd9WC5+vM8BskLOSKKiWnb4YocDOWIXPoaaqkr3vcT0J4vweiDtOKkaSjU7VIxwnFvqHyYZ7PpBzRhvFiCkgZYgbuZSmx03/KS4/uBHrGy4kiVjiL8fnozG3kN4ghjzKPqqwhBBKvtyBXGihfYYK4eoO0McAt/zq/DV+BCgNcH2zMrM4f5ctzUFd3U91ZZKCmmxApr5HXtopJ3kmjciASyHzzM7tVrNlXq2ksdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 10:31:49 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/9] mlxsw: reg: Add Port Module Type Mapping register
Date:   Wed, 26 Jan 2022 12:30:33 +0200
Message-Id: <20220126103037.234986-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0147.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::40) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ec39e25-2122-4b9c-dad1-08d9e0b70f7c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4461:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4461C319580014DAAF5A777BB2209@SA0PR12MB4461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LOOITNXX1Yk0vq+p6Opx0k2/2Sbb+0/RNnbH1i17ngSUh715DwRU2NyclaAoq9JAMDDzWfkNEZNqYRodmPcYSyzqnnHZkVCSSgpuTrMPVTj3JPrS2WwaXQTtL5PVZuuRxtF1zT3k6GNanHtE6l5S33eaZ7RL65/+VOctKTVaCQAgQ6NlasPI3fFxmnAV2LzwbF/61yVkCX8L6oXj9qL2BVq8LMfNVysmqHc6rUTAR3ks3wBUV/qn9doqir69BAEbKNchMHu81lWtieLbGs3bPDknYnKkzqAisd1F3lHIecbhaADssi/J4Mth7o92peT7tPnew6dbmdde5AmZgkDXQjToBAUyj6mfqpIceMfi0ggf4OfLxtca23lJW+9XSLew8QjS5euPK5so38sbqISuE5zZxJqEnGQoQ4QdXj8I2+qWjEfIu2MO4YcF/L9MdqsIet+AzmKgu/+ENyuY8xGh0VeL5qaMGzViRw0Jeq4RmEP52n6iNjblvgcEKKytu1JwCAK226T1W4Eq3SwRc5Dt+CWZJIOg1b7IHpWd9dojOi59gpDypAoftj7A58Am1fzrjgD6okAkQybeQ56xuT0B0NSVJ/wfrAOa/JTodVWC3IdnOex+RUSKy2kbGsj33YQJUt1ewvYcBtdIo2cvkGPPcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(107886003)(86362001)(66476007)(508600001)(8676002)(66556008)(38100700002)(2616005)(5660300002)(8936002)(6666004)(83380400001)(4326008)(6916009)(186003)(6486002)(6512007)(6506007)(2906002)(316002)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sFkK/RDYwGHkIvSBWYwAiDGWFDuY1HIAXLYlSO6dEXkFs8OM8hVNvmhWCaL2?=
 =?us-ascii?Q?e5RpLqNzeJH6v6yBofc7WIVRAMY/Ma78xNTPVKu5oow62gbIXKggbU0MDFsD?=
 =?us-ascii?Q?/4TqqA1YHakgeB043Pl63JKYKuRh8Hj5krPU7SG11lllPcOWUJB1TOg0XwR4?=
 =?us-ascii?Q?aqXGgg6OMn0IzxSyGIHMl9AVDBhzCB16LFewV4yZhg4lxT9qwdfQTtd2kKyV?=
 =?us-ascii?Q?Ctc1N1Ho7/DK4hROxEwISAOMmnKvPWIlDuEl6w4oE2L6g0WcF8v9P+GsCB8q?=
 =?us-ascii?Q?cBr49SEfllxNlBN8vpFiGYc2fsul5KohJeuclbNOz8DzNklsrLoHUda2U8IS?=
 =?us-ascii?Q?nhKVWOfrA/+xu4O5qitOvsnqNG5lJWR2ArGg/E9+PpvotVkPWT4L+mSVeagb?=
 =?us-ascii?Q?wdehi1eQmWOMHKiVIt4BqSY8EZrbrEUOzbRjS456ZpZDpnR/6UDhNFjVE6ID?=
 =?us-ascii?Q?mGyz6Eq823W/dQqpVw4f0dWVGNi2DDch9fNsr9a79v4/iT1RtlprxLRYZY5T?=
 =?us-ascii?Q?dVxf8ozTO66WmTVc7y2z+KZd4OV5PDuIdpWwkGuo6E5TxTSewJqJSsO9lA10?=
 =?us-ascii?Q?dAoX6p61o71QkqI2X8PUOBY8DiNR637EGXl4QtnxduSpdes9I2Fu6rXdT7Tp?=
 =?us-ascii?Q?4xr0Ou7fBsFDq8rjZS6rdcNG4qr3D9nKy7OTfRZvGpbLAgzcBjCqpL8C8Qfl?=
 =?us-ascii?Q?hZXS3vF763tB4wykM4+AMlZ9lnHhOl6q/N/Lm3gvt26eYpatEXVZPYckDpgj?=
 =?us-ascii?Q?MVY002uMZMCKeoYkiPUUkZSFFnBUivU2EuNsZPlhtzGMGfvxLVZ2OaRbNwt+?=
 =?us-ascii?Q?cFFAchtFxIuNYbUEKfLBIA85Lcsp3P/h0CK9sYIhAWpnGzpvckPcm3lkott4?=
 =?us-ascii?Q?fC2ec8DiAfDaISINDC8z7BIkieO+k++WtY7qc6Lr2Ph4MGTmnXmSS/HG5j7e?=
 =?us-ascii?Q?75tgJBPqwunNG/S5WpPEAN7BBCS47/7/TyTnkuhdBNeG+Ag9/O8GeC/DR0EI?=
 =?us-ascii?Q?UmSjQg8/zffdRmFfmkhP3ZgPf9USRYPAQDiKPUh3kX+9V39KyJTY8JDEOnb1?=
 =?us-ascii?Q?Wjb+eIlRbZkRpbwcaoyI4C+V28yPj30dEqZIsTxeWImo5WzWPXY18lCqbC67?=
 =?us-ascii?Q?ewZsqgPz+TN5S/D33hdrmc3jGNXVQkP5NSlCOoPCdfgav7yxZUK+En1CHRet?=
 =?us-ascii?Q?ewMdGUNd4Ou2AskPIAaVOB/rxFvc/2vkHKA5GQ2oE6qE7U0uC38ZAgM2yH/M?=
 =?us-ascii?Q?jL+MtYOUf8WMlU7ZR0raW1YNCgA6/5dZLcEpfcJQpk4j7HKVM6smaRwAinaj?=
 =?us-ascii?Q?t+Gd6vRiZO9TVCLvMsCu65dRYuXjrezoNlr2TEx8v5avkEq6DW1sgvG5/JXH?=
 =?us-ascii?Q?Ii2G8fO2gTes4aVEZPOoH2r2DKXApFri9HwwibQW2xEHOE8VGAuTl9vnUhiD?=
 =?us-ascii?Q?TRTkac+tEOfQ3SHbOimRo6lJZgw843xMcdI3CrLiBKSWW3cUyL/fZSQwMkNP?=
 =?us-ascii?Q?7iiPRwUq5Iv2p+HJ6JVLlj+ip2Zim6zALZbr2sUqjI2NrL8NHomNtWXMEC5w?=
 =?us-ascii?Q?VF5gqH3vmucNp3UrzPKWMX8LMLWqUj6SdEbgehiHIfUrY3LAIKQcGJlOr/sd?=
 =?us-ascii?Q?6U0BnODqGRX5peNB53PXKhc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec39e25-2122-4b9c-dad1-08d9e0b70f7c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:49.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYph/kJKyedAou7loos2Ai4K/aZ7FhUjLdZZv/EfQo9AdRH/KVS28I4h9pdjLRnD5tXks8UE/KeEyCO6zI380w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add the Port Module Type Mapping (PMTP) register. It will be used by
subsequent patches to query port module types and forbid certain
configurations based on the port module's type.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 53 +++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c7eb48f350e3..aba5db4bc780 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6064,6 +6064,58 @@ static inline void mlxsw_reg_pllp_unpack(char *payload, u8 *label_port,
 	*slot_index = mlxsw_reg_pllp_slot_index_get(payload);
 }
 
+/* PMTM - Port Module Type Mapping Register
+ * ----------------------------------------
+ * The PMTM register allows query or configuration of module types.
+ * The register can only be set when the module is disabled by PMAOS register
+ */
+#define MLXSW_REG_PMTM_ID 0x5067
+#define MLXSW_REG_PMTM_LEN 0x10
+
+MLXSW_REG_DEFINE(pmtm, MLXSW_REG_PMTM_ID, MLXSW_REG_PMTM_LEN);
+
+/* reg_pmtm_slot_index
+ * Slot index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtm, slot_index, 0x00, 24, 4);
+
+/* reg_pmtm_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmtm, module, 0x00, 16, 8);
+
+enum mlxsw_reg_pmtm_module_type {
+	MLXSW_REG_PMTM_MODULE_TYPE_BACKPLANE_4_LANES = 0,
+	MLXSW_REG_PMTM_MODULE_TYPE_QSFP = 1,
+	MLXSW_REG_PMTM_MODULE_TYPE_SFP = 2,
+	MLXSW_REG_PMTM_MODULE_TYPE_BACKPLANE_SINGLE_LANE = 4,
+	MLXSW_REG_PMTM_MODULE_TYPE_BACKPLANE_2_LANES = 8,
+	MLXSW_REG_PMTM_MODULE_TYPE_CHIP2CHIP4X = 10,
+	MLXSW_REG_PMTM_MODULE_TYPE_CHIP2CHIP2X = 11,
+	MLXSW_REG_PMTM_MODULE_TYPE_CHIP2CHIP1X = 12,
+	MLXSW_REG_PMTM_MODULE_TYPE_QSFP_DD = 14,
+	MLXSW_REG_PMTM_MODULE_TYPE_OSFP = 15,
+	MLXSW_REG_PMTM_MODULE_TYPE_SFP_DD = 16,
+	MLXSW_REG_PMTM_MODULE_TYPE_DSFP = 17,
+	MLXSW_REG_PMTM_MODULE_TYPE_CHIP2CHIP8X = 18,
+	MLXSW_REG_PMTM_MODULE_TYPE_TWISTED_PAIR = 19,
+};
+
+/* reg_pmtm_module_type
+ * Module type.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmtm, module_type, 0x04, 0, 5);
+
+static inline void mlxsw_reg_pmtm_pack(char *payload, u8 slot_index, u8 module)
+{
+	MLXSW_REG_ZERO(pmtm, payload);
+	mlxsw_reg_pmtm_slot_index_set(payload, slot_index);
+	mlxsw_reg_pmtm_module_set(payload, module);
+}
+
 /* HTGT - Host Trap Group Table
  * ----------------------------
  * Configures the properties for forwarding to CPU.
@@ -12570,6 +12622,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pddr),
 	MLXSW_REG(pmmp),
 	MLXSW_REG(pllp),
+	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
 	MLXSW_REG(rgcr),
-- 
2.33.1

