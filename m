Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F325509AB
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiFSKbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiFSKa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A68ECE2A
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPcY0ya/RniRpvxfU94GNUDvooi2s4rrvoZvuVXxZhO4JcADF+TQ3Pn2oi46LiTSUS8n7Jl7aDZZAR+xjs2l9FWCvPzMCXV0QpG3sGoTJHdQ8mVbVs3s79U5MPByoPTq+VKC64NQVCUqDdiwXyOSCWYfEyVZ1TYie8BgbURpAMKrUYNw4n9NFbhxcYmfFLsPregDP+7/qJdT9tw7qR8/of9CzN/Kux0v8vjPa7bkSHhzW4yourQRqL/zxs+XMEChuELwwwZmi9nla5VL3ib3t58laZ38yhm31JyY6NiIOHW2cHZbBGv5JfvtM4n/1cG7t/26nLLaeloLHt+rT5dtqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6eWm3bcaFViWOEj8aev5VZyfqXeg5F8Q6sVc4pviXM=;
 b=A7NqpvQXuJhM99J021PWXl9yGIeJ4LVvjNOeLRWzuFc6D6jxEpoGBqKzSnjgpvjNiJc8VvjOCR5OU5gZUM+htUBGvEt/GwpXKwEIXHyeNK4zMg6TSqGWKYnhrexYtRogsSuewWImeuvg4+gT+EcHSJJ5TqXVPEfDce/LsneB1f3XJhEq0w4Jbu1b2F8sdiZxg+7qtonbgHESz3UH5OijcJDUdRVU2vMN1l+kGvWj3EnUmI8f2tlaIIxZu0Gl1APmdr2FTclO1gWGca7U+Dh8qDnsDoe07l0m21LiSRS0NNggwATFEUWBo04p9Y5HTM3T5a2arbJP6xbk9/w0FlVLkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6eWm3bcaFViWOEj8aev5VZyfqXeg5F8Q6sVc4pviXM=;
 b=Q2J8yhsIZyx84oC60IFSPT6cNVM5MLuxFhRl9+fO9K5OumzxTF5v7M4rNjZRFt+fP5R9VHrS56i+abXHCiu2yJpEkTDicNvBlJ2nltYTJQJhSpSjq/JFKlhurr/3WkPvoMP38oRBOxv86v2pwl3MMXNzD00H4/LG4zAg5+zlF8UwpESJ7JenOGOsI/8pmLO2KqMqyu37WMVBW5bZLLVO3LCVhNM/2q7PcB0ibpinTeV2Cc2kLaBLh6qkxt+AmeooEVnFtFJJ9tVFgSWVpTqgG/ocsEpoK6wccQrqSgTta5esbCWzI8Go+54CvqFf1ZIFrZO5Pk+tD5p/9fZohp3BMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:52 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/13] mlxsw: reg: Add Router Egress Interface to VID Register
Date:   Sun, 19 Jun 2022 13:29:18 +0300
Message-Id: <20220619102921.33158-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18b077d9-5fa0-4cbb-8048-08da51dec92f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11937B802A3A23F4DDCC3FEFB2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJtKLX5TNNbCB2xNVFwHySJVWaNqcns0pnQRiqqd+5sWNkGcgUcN99YK/TbUU5+F1XHRGE2P4A71Hf3k0lSvfYRgoqi77kLkCOpIF2b6Jzd7L6Jawx6pVuasMvckl1Mt+5mO7ueFm1oHZ2X6ABt4AH0BurElU3DQeGDHOjqe11/NxD++YF7nO0PwVWr6K8y9J6AIh7BP+RSZjJpBQy7cGVG1BY7zXAECSli28K+DxEZLWW0QPgZU9BS8d7r4kP71N+hhujIsDeFDUlzfzIcivYAzjXQNA44BnyPO+5T4alqkwkv9Z82MB093Y9gYA1nXSSPp6Cp3bP3IJrikM6ro0E1A1Gp21AFY1wVJ7hqf4P3KGh0MLp2YZWIJJ7VM8aWAf/oe0hpQDwCf5cTSso8OsvZgZWbNm6iWtW9p6MmBe7EnLM10JqEmlFu82++816Icoux4Qx5d7bVRRzpcGTEHQJCsUteEwuFr3G8EhUfYd5A27nLekd17PlCxVMTRy+e4FHYfXrt61aR6qJzFijlPw4WQqPq/sSC8RXZbEYUkPB9XsyRkQDv/CsN0xaCDc8NfV2gtUpIX55qaFaATpJ/hXyGlZuadkZAifqtWxeMIIdSI6pz2LhKbiMRROZvO63U2F8OdiumV5+nsLx8xKfGupQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hdZvhmc7/Fo+A7OHWPxILe3AKfye+xZmSg3wb/LW/thNj6es4BIrklMxwdVd?=
 =?us-ascii?Q?h1ESf/0Vaa18sDqSSnV58mX2vE4KrD7C55a3iJ9FJe0H5ADGU9iisjHL9rag?=
 =?us-ascii?Q?vAwrGGjrhbJcHzsI1SmTdYG+OLnkVOQkGKA6OoApqlmmcSOM0PI7iOfcpVC3?=
 =?us-ascii?Q?re23efbKXdZoboGLrv/noXF5ZtZi2hEowJ49HbvEvzzkVFQLDFbLRsO6ztWD?=
 =?us-ascii?Q?zplOlu4dDVw1ksoAph0LHxJCN9b+ywYLmj5NkoDm1NJ60TEkQssJIxvjoAHg?=
 =?us-ascii?Q?onjIEzYPMfb9GcaOjHJ+sEH3jr/BuvEdftDPaS6SYuAR2XWlvh2ATumZ+/bm?=
 =?us-ascii?Q?pjjJ3Tfyg18QVbGJ7OImTLx+V4aQo+IctO4aVzPHWh65VbvxDuvlgN20VXOZ?=
 =?us-ascii?Q?VrUPi3y0ROvHN39t4FKVNK6LaDLgWJnM9szwP0v9MF7lGpFg2Iaxq74t8+kk?=
 =?us-ascii?Q?kV1Lt/YXKK4MRSLMqRELfbmUiMaA9KjHckjXVU56iMJmcidXnUQscyH3725S?=
 =?us-ascii?Q?JnfgyIaO43mWDLxFPHjpPKvnh2JHX2VJycYBUxCIVtax+5/wj8H5woWh6pcN?=
 =?us-ascii?Q?TS603KklbkNteDP7fWkWa19Xn4liO10BxyPIavlUJTX6NI7gifp9/pDLoTuq?=
 =?us-ascii?Q?0mtROowC+pQ/hjGtlY1DP961DT/WMKND8+Btz/FLPv8jqvCAk5tOOY09P4VG?=
 =?us-ascii?Q?MtMsKNo52EBZagLEjNfVus440BorK8DX5QAXboT/ea1astqts3WW6sr0yjx4?=
 =?us-ascii?Q?6cfy3RFZ5tCMudfQtttLFqfcupGL7Qs7t2j2+o+Pif7WKBbakRR3VY2bjXq7?=
 =?us-ascii?Q?Wkek+XwsOUOc1DmW2v+Mj3U2z6gU0n8xotWB4ZPHuIuWt0T94zhL9VFuDoYD?=
 =?us-ascii?Q?/poSDBaoyVrY9zYMxlFprRG6ImAfMZLcflNh8c93qWSvcX+bxR4uiJW1n8St?=
 =?us-ascii?Q?MeS6xeM/7SiCg5eQPr0QuuNb9hfiVoHDXCl9WDHdYB5wi6+6GjlArdESzys6?=
 =?us-ascii?Q?sv/pyqXanhpWfoxsbqfolapgT1Ec/AVIm3ecnHkCtMOADWbr7vA6iLR334Jo?=
 =?us-ascii?Q?BEtuPF70Ww6pMLTFjbJg0Hdn35cy5bOPkAp6UuZH90PouV5EN6NQIA5WvCDi?=
 =?us-ascii?Q?9Ndu1LPfmQ9UIGQXx4qbD0dS+li/p21fOXgu49eOZbVrW+ahvcNNfcEBqfYw?=
 =?us-ascii?Q?OuXDVC5ttrP4E4x+yIMPVQufzSnQOBBAn+lGMi6YVXTjaPEq0sEQ2ZTuRq7j?=
 =?us-ascii?Q?OXuYL+aZIw4k5Fj96FFlcHz85gPW5XpTxLmd+xHGkJ1wT81WPd8Ne6gRcvS9?=
 =?us-ascii?Q?Om07WKx+OEEacwgeQbQ9Oosnq+GORVU3h5vFpf7K1HB0zBcdLDJGyZrr5OzV?=
 =?us-ascii?Q?SVDN2LK65WmXoiKoXj/IUgLSpJk9bGMNfeC5xL5nQ/e+V6tooAVOzWAS/J+b?=
 =?us-ascii?Q?CR4u21TTZSVa0Ib26XM5mMnEkotakiW87PQWyWT4l14d3C7PWleSTL0QNHuM?=
 =?us-ascii?Q?TYcdGz8fM2NBbH6tuIHeSpoINjbmGbePcAVeswtv0ihm96aonN/6+BNzNSZv?=
 =?us-ascii?Q?wWzxKLniBD/d455+IVtQRhZYwgSUJHIgJBXw+UlIN2z+Hm+0UxjVEweMynKi?=
 =?us-ascii?Q?Gmr9dCsQvKwH9UCzHcwtpCZJbZnWVx1n64LtGbimfFXy3uwXv/tOc+Pmd7LG?=
 =?us-ascii?Q?Pdn/vV4f2N6lzaQ14jwq/U+SGxp+vrwu7l/NFooKL/vla9dxlaJAvRKeINLF?=
 =?us-ascii?Q?jykfaDEtUw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b077d9-5fa0-4cbb-8048-08da51dec92f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:52.8301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CedrenKkl6eq6J2DElLxVX96WTNg4a2gCsg7wnZ9Kd5STCto8YBIYOpBrPwqYa86OzjPqRt4F0D6mRPDwBJFEA==
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

The REIV maps {egress router interface (eRIF), egress_port} -> {vlan ID}.
As preparation for unified bridge model, add REIV register for future use.

In the past, firmware would take care of the above mentioned mapping,
but in the new model this should be done by software using REIV register.

REIV register supports a simultaneous update of 256 ports using
'port_page' field. When 'port_page'=0 the records represent ports
0-255, when 'port_page'=1 the records represent ports 256-511 and so
on.

The register is reserved while using the legacy model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 59 +++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 160a724c9a6a..b9f91bef74ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9099,6 +9099,64 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
+/* REIV - Router Egress Interface to VID Register
+ * ----------------------------------------------
+ * The REIV register maps {eRIF, egress_port} -> VID.
+ * This mapping is done at the egress, after the ACLs.
+ * This mapping always takes effect after router, regardless of cast
+ * (for unicast/multicast/port-base multicast), regardless of eRIF type and
+ * regardless of bridge decisions (e.g. SFD for unicast or SMPE).
+ * Reserved when the RIF is a loopback RIF.
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+#define MLXSW_REG_REIV_ID 0x8034
+#define MLXSW_REG_REIV_BASE_LEN 0x20 /* base length, without records */
+#define MLXSW_REG_REIV_REC_LEN 0x04 /* record length */
+#define MLXSW_REG_REIV_REC_MAX_COUNT 256 /* firmware limitation */
+#define MLXSW_REG_REIV_LEN (MLXSW_REG_REIV_BASE_LEN +	\
+			    MLXSW_REG_REIV_REC_LEN *	\
+			    MLXSW_REG_REIV_REC_MAX_COUNT)
+
+MLXSW_REG_DEFINE(reiv, MLXSW_REG_REIV_ID, MLXSW_REG_REIV_LEN);
+
+/* reg_reiv_port_page
+ * Port page - elport_record[0] is 256*port_page.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, reiv, port_page, 0x00, 0, 4);
+
+/* reg_reiv_erif
+ * Egress RIF.
+ * Range is 0..cap_max_router_interfaces-1.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, reiv, erif, 0x04, 0, 16);
+
+/* reg_reiv_rec_update
+ * Update enable (when write):
+ * 0 - Do not update the entry.
+ * 1 - Update the entry.
+ * Access: OP
+ */
+MLXSW_ITEM32_INDEXED(reg, reiv, rec_update, MLXSW_REG_REIV_BASE_LEN, 31, 1,
+		     MLXSW_REG_REIV_REC_LEN, 0x00, false);
+
+/* reg_reiv_rec_evid
+ * Egress VID.
+ * Range is 0..4095.
+ * Access: RW
+ */
+MLXSW_ITEM32_INDEXED(reg, reiv, rec_evid, MLXSW_REG_REIV_BASE_LEN, 0, 12,
+		     MLXSW_REG_REIV_REC_LEN, 0x00, false);
+
+static inline void mlxsw_reg_reiv_pack(char *payload, u8 port_page, u16 erif)
+{
+	MLXSW_REG_ZERO(reiv, payload);
+	mlxsw_reg_reiv_port_page_set(payload, port_page);
+	mlxsw_reg_reiv_erif_set(payload, erif);
+}
+
 /* MFCR - Management Fan Control Register
  * --------------------------------------
  * This register controls the settings of the Fan Speed PWM mechanism.
@@ -12606,6 +12664,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
+	MLXSW_REG(reiv),
 	MLXSW_REG(mfcr),
 	MLXSW_REG(mfsc),
 	MLXSW_REG(mfsm),
-- 
2.36.1

