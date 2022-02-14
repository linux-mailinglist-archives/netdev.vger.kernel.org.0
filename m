Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D164B4B558C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiBNQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:04:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356087AbiBNQEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:04:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E179245ADD
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:04:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffgcrBWS5UJLpD/21RWZ+/LwGVM22F7ZgGFP3qSayXh0gVMHpME7oOleJ0MmTpyFSWX8frTFV0w+Am6uCrCkpnk7DLIJRdLTT+ziXCLvW0CfgKtWZT5UlXEikr8H/Wj4XXEmMkMUlS7GVShprJ731kM/98OjTURiRyjcosNsxd1w0efMcATZIViHqki3D1IQuOQ6LOr98XyQ7lx2LBY+AG1VBL5f8+zrwIR8vgxcFq8aR6av3QxMiOg+SVT4mnz/18cOcibqSFB5Z5lxB3QA1MhcwMn5uBQfwKtUH1u7Q6WuA2V/8IiuKythQQX0Q+xoFaV3r/MJxA6vUGduBRVkCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOxX0JuN8QX1ARlf0zHNtwJ2eddrrI+sP7o4NFnM1jc=;
 b=DJUu1ZAD8n2P4/LEF5fSjKNfcV/jKTwfr/nbXA67zgBVyokgbC3ym2Ce5LPaNoBjOFLLRnCXkZjTMb0Z+N9ML0XxEA2FufsW/FXjn4ysBS8fs/KA09y7n5T+CQhwkdqHQWv41T+p7C5SVyuwV7FOzMiW4bC/DSHkvjEfsVnFCXAD9ZzEE8RFQBLYSC2NA2vmchIyyWJlFn09dgl0l/w3u9RumJZ5IMp/ppWtqFa8dzAbshL/dod1zdqtnWwS5YK94wnKEyPUJVCyBwnL4wP4NvTAP+fCL+/o0Q8nDAzZ1RieEZKUqKUOTvUakEtIpjqg4gzQvKqdhEnjkL7Z/TEa4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOxX0JuN8QX1ARlf0zHNtwJ2eddrrI+sP7o4NFnM1jc=;
 b=WkWAJwOKZfTR3ZK5c6uHGcyWAXbqr+JcoyNd6PXN8RE62ZVL3h9BdENZDnPJRCwEPjce2vIpNfN6elcgAIJueyBYpv1luXxLu+1gNaGbGbhcEL89KhbPFWO/76z28UzkMH5K6Et/66ZJ4+qo4a+EJg0tLIbZtRVQxc7yxsVK86E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 16:04:19 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 16:04:19 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next 1/2] dpaa2-eth: Update dpni_get_single_step_cfg command
Date:   Mon, 14 Feb 2022 18:03:47 +0200
Message-Id: <20220214160348.25124-2-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
References: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d7d39f3-3650-49a5-2cbe-08d9efd3a873
X-MS-TrafficTypeDiagnostic: AM7PR04MB6981:EE_
X-Microsoft-Antispam-PRVS: <AM7PR04MB698199E9D12597155E7ABFF3B0339@AM7PR04MB6981.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQ7XUKPu4Q+cgf2gkdFtaV2KEmFJ/fwycrmXiANw74M84Gx8fpuXpERB9Lu4rbjjkSDVWmb07sjYP78FG5aB2jy9KoYWbNu8RTv07BvXPlQvMREl3Pg9iwYQqvknitsPO4DgTtaypwueRBIX0DMhZupnz5qwGoNOByz1Nt1oRRvXGDKO+/WmAQMsCZbyyF29RIIDudnfoL5wf+5Q6LhwINBMggYQoiou9lZvPahv7Lw/alEFLU3OQXO6kXJUJ7vFba6PbhtTMdmOx3rXqdD8Y7FU0UtzKxmOkkdCW7cdBgQaeeISn5pYSvqG2R46UGcktUXDuJRNTaHRAFutprofFv3yWLhNnsl1QVFSzrHdkqZTzbxb+MToQ+febjZaKekXa4NptBP6T1LKMH8WbZTT2M5pbL8pxiJAj/lF95UcgHy+3tFohbXRJxMJAvAUBiEyG9UjIvafzgKypunz04zXQ3oFeWeSxHF2oYrIFQ7rZE/Sa70Rm7Ltou+gm5cGkCUsyus2SNILUlL1eTkqvzTTVuWhfEyrxyWqeWdtTQE0wMSvjUXcOmTY6el14jjZrC+iMdFPfdknmk8OOH/aGcJXy/ZLA9HnbrhLVyf+o2IF4cYtasNr/hNYgRG1MziDNhW5MdSEo3xBcYei+AvJGbRWei+5BlwxBITih+pW9R9NJy48BGiSrrIpowH/NtSHUoLmdkCwz5EiO8Ole74l9BLLDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(38100700002)(6512007)(6666004)(5660300002)(8676002)(8936002)(6506007)(52116002)(15650500001)(4326008)(83380400001)(38350700002)(2616005)(186003)(26005)(508600001)(86362001)(36756003)(2906002)(1076003)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ITWToeyxnwr3f/ABR6/IF0+P7bgpSs2oZQE/t1l7CqsCrD1Bu88sRtltavLc?=
 =?us-ascii?Q?89VYvuiun1tfHE/U0rdvBjdbs/zN5hlH+GagkItRC/umGqwxy0WcsjFjh1cT?=
 =?us-ascii?Q?KzaFxaN+dy8QQ9pIXlFZfYvLIxhK7Nvq/pD3wkErtkD0XILP0rX+60D3lBpp?=
 =?us-ascii?Q?CUXA2u9C8t+fvS96DA6pjculeo90PhNpZMPDF9YZ+5fp8pjGQNatNMe73oyy?=
 =?us-ascii?Q?l377DFOtuqiI6SLrSKI+hx9kwXdKxhApgJnLeQyssXm/w0rtut25AqZ3+ch/?=
 =?us-ascii?Q?DHcNJ9Q4uBqjv9uA4eiAHWtl626ebYtuneb4jnVDSO5Bz7Yb+bEoIj3kHzC3?=
 =?us-ascii?Q?lVCnLr3xlpHs/JWyJBIecoasX7/GOkxPnea+JiFOd/Gsq9sI8ObmrXW1DShp?=
 =?us-ascii?Q?En8pV3/IANU6UWhk7ER11oYFKqpo2brkx+j07ePx9Pu2Fl4cvPgHKjqlvGFx?=
 =?us-ascii?Q?cjBTb8XwcNeCU7jm6sj1TJlFR1E57J56O72GmNGE4SLVAP0qKChC5bx0gw7C?=
 =?us-ascii?Q?zh7mn14z6pYIJ25+4rwtNFSuIKx6ZZgTQoAqncFVUI3gTOuaR0xTFAYZktcx?=
 =?us-ascii?Q?odMgX3k3EqjCNdgMofUl0NQIYlGZODIVsMzfioUKG5G4qKjgukh52h4GASMZ?=
 =?us-ascii?Q?NGRolM0PysWMjvXdyqAPcGU4a9KvHEbiAHZDdxRcf8BxeQk6nfg3sPwGe0D4?=
 =?us-ascii?Q?g5R1wRQhrEp2qaBs2UDC5opYdCvCkZIyp7KjZiR2lkwAQ1gsLnOGF5Rsoksl?=
 =?us-ascii?Q?h0/wTm13cOaJaUHLHo5FYbJZINui2p+rG9kR+UBGGFxhunlxVemUu2y8B6zz?=
 =?us-ascii?Q?cvJJHbgJyeGaR43AjZyQHdB6XBJepd0mr5vQCsNxLjY1iJ+4P/McDvMY/Ka2?=
 =?us-ascii?Q?ysRXH/aFHMd7iEKPjNBWsrjXtCzLiYtwSLzDM6Im0D2wpsP+O/Jqbob4t2MG?=
 =?us-ascii?Q?bnxtBcTJ6ef1Fu4c9sLqDl3s8zsx8WcX0TXq6S3NUVYkuMjMJb9k7LS3Ky+E?=
 =?us-ascii?Q?CwbZ62U/mObr5E8TJwrqrzPSxr/TItzTUKky7IP4Y/NSNEgFyRywR7tm5WN0?=
 =?us-ascii?Q?lfHA2vY9Zs0uskzWrCRSjDaI3P2x8RCaDz9M/KTDx9mkGYrNvo+P1pBvPYxU?=
 =?us-ascii?Q?NSExcEhgmUoW+cPNfwL4KgDRdGy575g6rKHEag9aGSbtSH7nxfFlApVNfESb?=
 =?us-ascii?Q?7BphkeB+PPpJATrlflmlq5q3HmmZUOP7HDIpEw6p1kgKueHk6bZ0Hm1yDFy1?=
 =?us-ascii?Q?DKSxyrIOqGm1BFjCYnJ3CFNjNCBsqomPVIP7jLCiX0iOWC4zOvaG4Ra6b6cl?=
 =?us-ascii?Q?6CnVAs2wiBM3eXhBhxFFcvcIu4733kQuREYujXEWs+4MbpCnsJo5HUsgZ4+X?=
 =?us-ascii?Q?SN0y7Lb8zNmincgZ3pXwBDCF8+70ALxqQWu9FOJNTl1vJlAXs1q0+5HEDDee?=
 =?us-ascii?Q?QOzWqc2bYZTubJPbnTRaNSXnjmz8bGF4xM41a4v/4PNgjdj4ccTtgF1bLP3k?=
 =?us-ascii?Q?BPAhotTilj2xBCP7k1Cm5vE+TpEDoNSN3lkocx2rOosJ9+GUafzKKtFaAnqP?=
 =?us-ascii?Q?Ts7Nl34G7CYFLpGbgMK6MEo3IUf1xQLuHAQ+ydJ68kwhO4sfc+E64p00Ixi2?=
 =?us-ascii?Q?ND8+cZFwxLhjkKrlWds21bM0NbZTtZAvxOXVcWUD+y4/yR/o5sfKMO5l77as?=
 =?us-ascii?Q?7qjC3A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7d39f3-3650-49a5-2cbe-08d9efd3a873
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 16:04:19.4769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9l6ccGIR2usKBQTBgrlkvg/g57KgZycDvo5GV7SOEbecbufmC96yVjPtY0cvon/p36rDEZAz76yNoOWWrC6FU97V2H2Qco+fiRk2l2uo38U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
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

