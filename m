Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61C757F3DF
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiGXIEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbiGXIEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7145519C17
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzbydTFHBUx5rWeLRdgacDafD1W3MaeGt/89sXZdw0uzPffAcrnnkSvCULbCyT558oLpuY+/kmr8liZg6pDTZp2u3GK67GP+S6fNXuP/+RqmUv55+2xqG1BS1cXItmcl6xLenRz1njVH8OBRXkmbdQf8igXKkGcLLOiVLwgwA2GUa1tKAjb4ksakDSNGSK86BmPdhjU2+omAxBDodYXiSlye2mKLXXvQAaEWzU9nTXwQpi5Pd2nHkpGTm4VNK2XwudFeFzy7P93NQ44uD/sQsdgL5XBDPDyhRBElM6yRFpo3kLHEqQcGGZ1Om1/tpd2IKLnCGmCsaxdAYGXkxHYKlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3NDnQ1JogGEo4f1Fh8FnoKlfZPcaa0W6WMOPlZ+zXs=;
 b=hgQcrdTZwzHYrItN0JAMYShiCvbpJj8N/u6+W5VeW/s7NlRdkVhftnGFP2q2z5X8lnSrMBLAinSQp8S3QeBXsp+WaDULJ0awYaT7AS/IL38Xifj/UHNU6rKAe3LHLne+u90mzip2/2oWuJlaGqzJmYyTUncUzwSR3Sxert3yRUlkYaOJt9ohUppEAWKK3HBFxtlTFzz7lzK/NHtlzkRxMWxZfT0Nh5pXcHBQW/eqI6D3Q1w0Q8NXq7y+vn0QpYDlMFHTnLuRNywiJMi7+3DQ0XXONbuAWe8mTlTITRYklbTcF1zEYicSUkrpmG+beKX3X4Eq/LBcFVMj89w6aWv4RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3NDnQ1JogGEo4f1Fh8FnoKlfZPcaa0W6WMOPlZ+zXs=;
 b=IbVtMvFSlWnWsDqLtZWAcwcgqBKFXB4bbcSVwgJ97OtEP3oHSzwtAxJHdVe3IEIacElXrIcfWExjkuEjuQKFQEx20qtowSsj/JWwCMg3g828d2xkV5piddaDwPpqBf29fL6jzDyFR9gkEnrGoND4wgijB2S0J4oxOPDkHIt4ofX9fZC/bBEhvaOQE5uIAkZfgNlXLm/tl22TLYqFTFOJOFTD/DkA4QJbDEhHp0OZ1F8nJ8zvC26g8h/c0SkDBOTFi9t1lOnZXKroNEIPeDfZmgY1TYLyfYsSY34QOd1mSIUXYN2wCVoLrrga/EHJKMoWmIosfzJS+kNoDStu1aOSYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/15] mlxsw: reg: Add Monitoring Time Precision Correction Port Configuration Register
Date:   Sun, 24 Jul 2022 11:03:17 +0300
Message-Id: <20220724080329.2613617-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0168.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0573a950-f336-4264-0462-08da6d4b26af
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pol5NWt7bngffVn/AdmYMBLzt4xrC1vgqiEnWcJ2CJ9wo5hKE8UWM6USP+Nd0dLSEiPhvJm1lins69ohP/WRoWVcQtsvE5zKZW0yCXnAsLRTTM8xCy235+DPie9lfuoKWz/HGQCxURqoKz/YXIxSumPoRH0NNfp3Vn86JJFQxGTK1fvbqDcZauyixqK57HL+EbQD6FfSqm507sEDjt/U7t7r6cTR741Y7Mioa3VfmithwhfzmTpSfJJMlnRLxqg4ENHjiBtWUwOoJMQURZGB/gwibObAs6f8ISTpRx1NSFrjNdBpmXzEyTlmkb9uomsokG+oBKKfUFqcYoR3xxbh0yYAAHqCUXiNBcNPiqCbp76taSWam1sS10BjzxsK51aHo6OGUhZJ2r85RfV7s5X+/IS6BC8nJmJO4RHKqhVLEaAMB/R1bbZkIxCKrZMyg9IZKLlZV+sPaFzul1TrkMkHWzVgEls/tLHv7PMMG4WCx78AAXlKOULApx06THGMLeFi7C2AB4Ke91QD4O9UgsFVJTE2buSt/Ykhr8zyWepI9Yu/97Lr9vkqvrf2nhUE1vCPqGhnF4vWNIxtugfH53EVVrMyK+qEcfSUVZqBg0k+CV51CoWoUz1iVptN1Cf31YzIIjW0ZwZiAxncfTg7ybaOEIgGWat/n5YtBbiggR8D9AORejoy+nxSqmGYFmJUbqm1gEEqAkaKXrsvKrvvHHZUMU0xjaZL4KCaEGxm3qCuTITAL1vYvJQwPVUCUSFPD4Qb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5nTLcgKhpksOFCezBWM6hQMCwqG1YEmJxk0QmtiH/nxmL/ApSoASapmXX6fY?=
 =?us-ascii?Q?4sJWIJ1vhjA48s9ZeyjD8nvX68KEPnPavKtJyfr8gwSwylM8g3YKGVnLC6Sd?=
 =?us-ascii?Q?esVOwV3ceBsLplWmqs2L2wi559RbNT3xa7qJXWi8bZ7OP/TEoFUueUAJcjzr?=
 =?us-ascii?Q?081y2/5rvjTCdi2DdMTy7lVtQRngpqpPlYa3T90dOzPEH3pt0cXnzjtEPM1E?=
 =?us-ascii?Q?Qrq46oDGW1tRoa+0FvBptmJ4eeJAkLSIYVXGE1eV90FlDxVLe6ugXDGIlor6?=
 =?us-ascii?Q?VZZHRSxZRIySOGPgWgGGdk630MrxIq01mNkPAjb0sh6j08XgtxqnPsxs1Fb+?=
 =?us-ascii?Q?1z8v9ngJhNr/lt14na+esZpdaboiuWWwKpc23UzD6ExdysL6Seh1sbNguMVJ?=
 =?us-ascii?Q?Eer59TGnVDEPGtjwmaoa/UMWFUPpZGRxOU4Eh8FqslKMIcKsyGbaStOzzTwY?=
 =?us-ascii?Q?ptX0kI7eWxLxR04FGe+EUwlKMq+j/jbNSLnb7+sQ563y8O9JhLQTQzQqMBaX?=
 =?us-ascii?Q?ziytQE1zvObuGKjaqhrm0O+RGqHgVfLYBRfGUr3MmsKRikdtG4h+hV/u+aBh?=
 =?us-ascii?Q?xxGuZ1Gr+HCqfYHh2vl+6SdQqr/+0PFvpmyDehctR2IKQh0o1dtHMqwCyKXt?=
 =?us-ascii?Q?S4tInL/r4HNVA7tFkkSc0KF63Fappe49bS7FgjbFtTGWSuEvX1KvN1FOrROk?=
 =?us-ascii?Q?L3l6lO8HbiCyX2rDUChY69pUOYn4GLdUQBx1riRC/65WwhqqeLLsvcIEJYH/?=
 =?us-ascii?Q?evtnRorfpenq3+WCt14dYXEKuxRFg1wYSQccM/TDaEj88FBvEkLQMvN2nNgR?=
 =?us-ascii?Q?zyWEO34cbbqUv83HnrwpHUk6qMZOAC02KldoGfR6DlJ7yfhvT8f/adb1/WzI?=
 =?us-ascii?Q?2K8HEf+1i0BH73dfGxWeuXdRsy5Ec3cMjS9WIXpqOJiPLcULi6ziQwiGeJ0a?=
 =?us-ascii?Q?gYSpP2cVb1V18edkIxggaKhMf1VzZhQvbrHpzhO8lQFThJYQ0xHkmQu98pLL?=
 =?us-ascii?Q?A8pwG51b+R/lHUhOHBIGEwl2TthwzhF3mNGJkBGlYwVHDi10moon21L/F7S1?=
 =?us-ascii?Q?oiCHvnEBim1Js6CILL03KDOdo7FSMwMuFRaNApGJSr7AIb1DGnBf/6hqOHOs?=
 =?us-ascii?Q?i4syDI6GYwsxcKSZ1Fk7onNaKuj74zsx0S2TgWgCNGERweTFOSt8XJfK63Gr?=
 =?us-ascii?Q?tSOoooJxyFGziawlbbJ2eTNViFrqCqXzI2BlEPmlfM1t1N6o4ZWbrnHdIr5e?=
 =?us-ascii?Q?WiQG9KSVDJ360dlKK9INqHxRVIZ7EGQ4UBOSlz7qT67SG2Q4P/GGyAyU6aGT?=
 =?us-ascii?Q?kgBFi8EAlFTPFyBI85NGZcq4r/2jN6fxiqXumjJGG4skWn9aDXhPXnLsbxzT?=
 =?us-ascii?Q?yQpzYN8/Ax5kG8fzLXVENR7R4nFlD96bmcumCRFXFPNEVFfbF0PG4BuVcaBx?=
 =?us-ascii?Q?jtEIL8wfZBukccJD1+SSkC0jOP/faFHFSM9XvidMXeDGTAo6rgFVxpyA1Wi1?=
 =?us-ascii?Q?X6zIOVnYEt6jgRHmmP2SR6nPQXU7Ln0haXYqfsnX0tJhstKuHGr6VdtN20zI?=
 =?us-ascii?Q?gl4dQXYEZ/JfywPtkklMCttKDnIC4Ee9U/rSEZtH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0573a950-f336-4264-0462-08da6d4b26af
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:36.6887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xj4saIMEf6PNDtXoEESje1dk6qwUYatDWOdB5GF2py8El2xNyis7epRvooifQCqFEdklPbnb9WjhlRy9qSIeiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

In Spectrum-2, all the packets are time stamped, the MTPCPC register is
used to configure the types of packets that will adjust the correction
field and which port will trap PTP packets.

If ingress correction is set on a port for a given packet type, then
when such a packet is received via the port, the current time stamp is
subtracted from the correction field.

If egress correction is set on a port for a given packet type, then when
such a packet is transmitted via the port, the current time stamp is
added to the correction field.

Assuming the systems is configured correctly, the above means that the
correction field will contain the transient delay between the ports.

Add this register for a future use in order to support PTP in Spectrum-2.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 62 +++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5665a60afc3f..ddab5476c8b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11081,6 +11081,67 @@ static inline void mlxsw_reg_mtptpt_pack(char *payload,
 	mlxsw_reg_mtptpt_message_type_set(payload, message_type);
 }
 
+/* MTPCPC - Monitoring Time Precision Correction Port Configuration Register
+ * -------------------------------------------------------------------------
+ */
+#define MLXSW_REG_MTPCPC_ID 0x9093
+#define MLXSW_REG_MTPCPC_LEN 0x2C
+
+MLXSW_REG_DEFINE(mtpcpc, MLXSW_REG_MTPCPC_ID, MLXSW_REG_MTPCPC_LEN);
+
+/* reg_mtpcpc_pport
+ * Per port:
+ * 0: config is global. When reading - the local_port is 1.
+ * 1: config is per port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtpcpc, pport, 0x00, 31, 1);
+
+/* reg_mtpcpc_local_port
+ * Local port number.
+ * Supported to/from CPU port.
+ * Reserved when pport = 0.
+ * Access: Index
+ */
+MLXSW_ITEM32_LP(reg, mtpcpc, 0x00, 16, 0x00, 12);
+
+/* reg_mtpcpc_ptp_trap_en
+ * Enable PTP traps.
+ * The trap_id is configured by MTPTPT.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpcpc, ptp_trap_en, 0x04, 0, 1);
+
+/* reg_mtpcpc_ing_correction_message_type
+ * Bitwise vector of PTP message types to update correction-field at ingress.
+ * MessageType field as defined by IEEE 1588 Each bit corresponds to a value
+ * (e.g. Bit0: Sync, Bit1: Delay_Req). Supported also from CPU port.
+ * Default all 0
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpcpc, ing_correction_message_type, 0x10, 0, 16);
+
+/* reg_mtpcpc_egr_correction_message_type
+ * Bitwise vector of PTP message types to update correction-field at egress.
+ * MessageType field as defined by IEEE 1588 Each bit corresponds to a value
+ * (e.g. Bit0: Sync, Bit1: Delay_Req). Supported also from CPU port.
+ * Default all 0
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mtpcpc, egr_correction_message_type, 0x14, 0, 16);
+
+static inline void mlxsw_reg_mtpcpc_pack(char *payload, bool pport,
+					 u16 local_port, bool ptp_trap_en,
+					 u16 ing, u16 egr)
+{
+	MLXSW_REG_ZERO(mtpcpc, payload);
+	mlxsw_reg_mtpcpc_pport_set(payload, pport);
+	mlxsw_reg_mtpcpc_local_port_set(payload, pport ? local_port : 0);
+	mlxsw_reg_mtpcpc_ptp_trap_en_set(payload, ptp_trap_en);
+	mlxsw_reg_mtpcpc_ing_correction_message_type_set(payload, ing);
+	mlxsw_reg_mtpcpc_egr_correction_message_type_set(payload, egr);
+}
+
 /* MFGD - Monitoring FW General Debug Register
  * -------------------------------------------
  */
@@ -12797,6 +12858,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
+	MLXSW_REG(mtpcpc),
 	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(mbct),
-- 
2.36.1

