Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B29A4BBFA4
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiBRSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:38:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiBRSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:38:52 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117A129C128
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 10:38:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/FNZ8tn2LVD9LHmyyO9o/xsUujWqf8I0Tr1q/Kj7NM22n3o1IJVVam2XZ1z0uCifFY7sd6gMvJ1i8atGertO6Yin6Koz4FJMwp+lvmUQnZOOA/Ouqifs/Xaw/1T126eMuUOu1FGVUH04brrTsEuGXIqmBwa6HIM37kgpFAl4lzDXlwgjCkud9rQ8YIH2rfAQUsa8hSaXZkx0hGETENeLJkS6ZVNBuxOnDACX15FXJwHKQKAm6gX9gpl/tfbp0w0/7KHuG3EYQIVQPGsnbGjbETPuA8l+sjNnbibLBVdDQ2wPL2ftyysSaONXS8kKDT5E/aFmzF3cRF+ZrakXQ1Ebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGE0hr84JhtVajDzEyifkEZ7JG4J0lv8MuA9L423rLE=;
 b=AbMd0yD6p8q6BiZ1HsWgOs+XNWM12j6jQxLv93wpaz1nI/gi81fnp/vFkXbTLToC/C4RV8DqbvjwUdcyjHVJFcTsM5qvgeYesDllOqjjBxnbwsXIvZvd8csbxo0YK5+s3W4YEyXY4L6oc2znGaKB9ty2qcOvajofXcdZ89whRwEdbvHK79qF6CwsjAaIlilPSLAx/vprU5c5ovjCLG3y8TrTyIMHJVKZY719bf3nEDNmF2bTz7mZEVTafCjc5pcCeZXBEe+aKTMaE4Vp+UNU1CReM1wwyQSjS8LuXwZVZo1V+HMYrh1qZp8I/e/xY+3dubzpgEIZWTAnaDoHlbDnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGE0hr84JhtVajDzEyifkEZ7JG4J0lv8MuA9L423rLE=;
 b=d6v6KYeAkT64eXDUfq5SmTiw6fuiVBGNTN9+zUeUXXZsfZCsNw+q1ske0Z0Beit5cWpmv8UyzqeAglmxL4gB3CCSW5/V2B0SPFlVYyJV+0FaEqe50Y/JLZtR7QnUIY+skdaWYsRsf+lae2XlNJSFhA1UIk2gCu2pT+wcSjOhjiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by PAXPR04MB9217.eurprd04.prod.outlook.com (2603:10a6:102:232::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.18; Fri, 18 Feb
 2022 18:38:32 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 18:38:32 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com, Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next v2 1/2] dpaa2-eth: Update dpni_get_single_step_cfg command
Date:   Fri, 18 Feb 2022 20:37:54 +0200
Message-Id: <20220218183755.12014-2-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220218183755.12014-1-radu-andrei.bulie@nxp.com>
References: <20220218183755.12014-1-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0066.eurprd07.prod.outlook.com
 (2603:10a6:207:4::24) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9edcc39-43fb-43d1-ac28-08d9f30ddd7d
X-MS-TrafficTypeDiagnostic: PAXPR04MB9217:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9217C85464EF11EC04F25CDDB0379@PAXPR04MB9217.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvkL4ujmzpEpBXfy4fq65JdZt3zZqCo+PsTAwal01uJp9InQx6lgPieQm7S16VTtJO1u7Sa4B15deVlHH+fiAVYcdg6ELcgDrdhcvLuNi0T29jLy32Y2f28mZJZl7euF2yNOAjs/3U0syECpyB2HeSWMHiAgIiA19BuK+bk1HEPdo1tOdqknDlrNpNy5XCl3GSC+OxfCUt+Vc51LtE72w64ioWSQLVosvQhl3eC/UsqTleWkqeSIhnmLtqtawYO2u649MDXwvJhxFe0otuU22egEu+DzLHzPbvbIIdjwfWB/xno1nHyriPqf3MFfOib17YI1Upu4qreYiRxwqGEQMmZwCQECn/txvYf6tjLF1uWCUOJuRY1qS6nAhExCo8CRcT91UeYUmrpmn3vyIsJBpmxq56TmrXcCMnoM7I8lHeUMvNT4RdKVMh+NfAOYUTb5OHKGMm8aswhlGsKthhORZOdJt0M17PRKxKNF/MxTCNQnHl0xBG9HDKv5TeO4ZBkTjximvMrMGxGTA2ly+R8gh9E08SvGb63NqcA1aFO+LX1FRM1N0kUSep4uw2RypVvFeACVW4tI0654EhhZP2OkD39gJ7hZVCD10xk1n0zZs751vKdXs7itgcqUDll91uzfsndFvWCo89QQwCK4Ri2pi+QpGovgzRoCPi4QVm0zfEtMxi+L20VpegCYG4/QfIPacqhwR7M2WmhjY4+z5HAMZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(1076003)(8676002)(26005)(2906002)(186003)(8936002)(6486002)(36756003)(86362001)(6512007)(52116002)(38350700002)(508600001)(6506007)(6666004)(83380400001)(38100700002)(5660300002)(66556008)(15650500001)(66476007)(66946007)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FqqVaRvq6/bGxQvo6zbTMfs+LqezZBzb+6xgS6JE+wnhfBNH79ITaCCARvYZ?=
 =?us-ascii?Q?E5tFVeaCbZuul1ckzqDmeuh9/UQxKjM4Q4d9J5LRKdu1gIzRi8vN0OAZdssm?=
 =?us-ascii?Q?i70KjW6XII5Cyu/Ih6wKFD1PBlHLjlM0TxfjDSCJlKH6bSGoi7lATn59EgTO?=
 =?us-ascii?Q?aLi8gnucfW570zBCzOVUTehruAriarvl29Pk2fi3WFFzg4P+OB761Hr8mKPn?=
 =?us-ascii?Q?JcYWlYaMAGpGmaBsuyVEezvgtnCZj9fWiS7qQ69RUIABFKM4sdnFH//gTPKH?=
 =?us-ascii?Q?KyOGlRmCqMe5KOWmtHiv+JvYSOUCWx45w0zuaoo75p0tSdqFCtNVNd67Nx/6?=
 =?us-ascii?Q?rLr1yq3kcR2pghBD4t6wZdFhHRDMMtnNAmZenG9b90QN9aFKWSbLIT+9CYSR?=
 =?us-ascii?Q?d4IF0Zc2qwNUkpTmZA3KnT+6cmLN8deQ7vWn9o63JPvP7GQ9mLc0br9IF69X?=
 =?us-ascii?Q?baji8aTQhEQfmYeDywDvoo96a5PcnMgscnh3Yu+twNCq/fQLTyAr3uh6hfiH?=
 =?us-ascii?Q?cfv3Q6zXQTVCxbo+CFGs6JE+yBhqrVA+nyl5weLXu89tpiN3nk20r4ObPAPh?=
 =?us-ascii?Q?qrFY/PjO+mcvncKYru1oDdgV6o6UeWe/JSwdXB2M+kN1wum6laTml+E0WWua?=
 =?us-ascii?Q?d9b4gCg056XieMMWRNwhHtk/uMXYX8vnkL4RaOblN+aL+rUu2y7XS3QdT2ie?=
 =?us-ascii?Q?GpVEQ83Cw3Zm2BIAS5epRzy6fI276GMNs54tVN+eb9gCr8KgwFBUXCulY9N2?=
 =?us-ascii?Q?38m9JsrJc8YEbrXmb25Hno7U6Y4UBPTtu8AFPJOGXu//qjDWdlSVPxz+Ztpb?=
 =?us-ascii?Q?DimM5eg9u+r0blCXIYTjMjdJI7YA8cFZvf8Nqi94sV8grHjQ914u9GV99qGe?=
 =?us-ascii?Q?D9CKz2zWBv73TbNdgVUXDnd/L5yPULMZzJJNvMlYUBtl0bTWDk4+oklyl78N?=
 =?us-ascii?Q?InFc+mODmmSN80p7pZSkouaIa8xQwO2Qd+eslu3mSgUdISuz8x6dIDjIQZbu?=
 =?us-ascii?Q?TXJ4+l/W3LQICUbJvYlVweu6ChdALCtWTj5jDQx6bC86nnTO/UIZxVAUpq+H?=
 =?us-ascii?Q?WpQ5sVasfOk8nj0A3P8Km3dEipHnvZPCGcz+xV8wK4MbrFUtSZqnsGQmkn30?=
 =?us-ascii?Q?yz2UrMgSBvUmM5LjlmGKhvyGywjO57AjCOlmbepKWtmdUKKp4p7nuPn6w3OJ?=
 =?us-ascii?Q?aNcwp5N2GBLhBr/nWyrA4gj1eOwcXjA2nZFfZ5IDUQYlHW+jj3p1FaY4wC+Q?=
 =?us-ascii?Q?xZI0he9OVxwlfah2qDmzdD0Mh0+YOrKhaw9rBfznVKxIt9fZxXasfNUZfUaQ?=
 =?us-ascii?Q?kF/9jfqy8ZvvAUxGsn8WQrfbi1PgUjR647CDJ3EIlKtGSiSFVMpSh0jsftLr?=
 =?us-ascii?Q?5L9QMBo+0AnvLi40dcI+tqCFhLwhyRr6y9aAfc9BzoQ3d3/+Eg8zzzJs7qBw?=
 =?us-ascii?Q?YmWxOU1EMqGK38ABvdndkL/ToQlQD7WgLwWD6Q3UoViCa65UYtoOwRcpXzZk?=
 =?us-ascii?Q?Yizx+4NhV+b1GtoK4+/OYh0VcxRey5LULy8OrOZWoi1F3MRhfoGIGSREstao?=
 =?us-ascii?Q?+I17UbS73KdO46Dx/fog/IlroZWIMKJwZiWKdg5zFrIx1u+cNaWlrt/trm8K?=
 =?us-ascii?Q?LdyVCcJ6ylyqZN2j80rknl+r3mOTp2Ry6RJbFxVUXkvyRaaBBaoBbzAWb6F6?=
 =?us-ascii?Q?bKKr8g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9edcc39-43fb-43d1-ac28-08d9f30ddd7d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 18:38:32.7479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+vwTTmSdGrtvsxjQI2EWTcBMOGoOXHxqnOztpRQ9looUOr7n7jo+Xh9FIKiycUcQizc+48bjXQyJ9vJ1i8sXidBwpIRA7+vwWeF+kufjyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9217
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dpni_get_single_step_cfg is an MC firmware command used for
retrieving the contents of SINGLE_STEP 1588 register available
in a DPMAC.

This patch adds a new version of this command that returns as an extra
argument the physical base address of the aforementioned register.
The address will be used to directly modify the contents of the
SINGLE_STEP register instead of invoking the MC command
dpni_set_single_step_cgf. The former approach introduced huge delays on
the TX datapath when one step PTP events were transmitted. This led to low
throughput and high latencies observed in the PTP correction field.

Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
---
Changes in v2:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h | 6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.c     | 2 ++
 drivers/net/ethernet/freescale/dpaa2/dpni.h     | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 9f80bdfeedec..828f538097af 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -98,7 +98,7 @@
 #define DPNI_CMDID_GET_LINK_CFG				DPNI_CMD(0x278)
 
 #define DPNI_CMDID_SET_SINGLE_STEP_CFG			DPNI_CMD(0x279)
-#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD(0x27a)
+#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD_V2(0x27a)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPNI_MASK(field)	\
@@ -658,12 +658,16 @@ struct dpni_cmd_single_step_cfg {
 	__le16 flags;
 	__le16 offset;
 	__le32 peer_delay;
+	__le32 ptp_onestep_reg_base;
+	__le32 pad0;
 };
 
 struct dpni_rsp_single_step_cfg {
 	__le16 flags;
 	__le16 offset;
 	__le32 peer_delay;
+	__le32 ptp_onestep_reg_base;
+	__le32 pad0;
 };
 
 struct dpni_cmd_enable_vlan_filter {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index d6afada99fb6..6c3b36f20fb8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -2136,6 +2136,8 @@ int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
 	ptp_cfg->ch_update = dpni_get_field(le16_to_cpu(rsp_params->flags),
 					    PTP_CH_UPDATE) ? 1 : 0;
 	ptp_cfg->peer_delay = le32_to_cpu(rsp_params->peer_delay);
+	ptp_cfg->ptp_onestep_reg_base =
+				  le32_to_cpu(rsp_params->ptp_onestep_reg_base);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 7de0562bbf59..6fffd519aa00 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1074,12 +1074,18 @@ int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
  * @peer_delay:	For peer-to-peer transparent clocks add this value to the
  *		correction field in addition to the transient time update.
  *		The value expresses nanoseconds.
+ * @ptp_onestep_reg_base: 1588 SINGLE_STEP register base address. This address
+ *			  is used to update directly the register contents.
+ *			  User has to create an address mapping for it.
+ *
+ *
  */
 struct dpni_single_step_cfg {
 	u8	en;
 	u8	ch_update;
 	u16	offset;
 	u32	peer_delay;
+	u32	ptp_onestep_reg_base;
 };
 
 int dpni_set_single_step_cfg(struct fsl_mc_io *mc_io,
-- 
2.17.1

