Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E34665F3D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbjAKPg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbjAKPg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:36:57 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F35411463
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:36:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFI9fOQIUgxorna6si7Vo+LHURBZA6gN3Jp8S+DNj9dE57qrf9dA8KrqgiH2U3phLl84VEk593t88gMPFy2vdlLH3fdZHqpRJ2CQn9wbybwDINF+sW0rhRQyk5eKCzG4ulOESDxOrlGJ1kMxwd+OuxyEfHSKFWfclMiAGOHjQCkwZJvfwPoND4ybPrSwSpl+SVzmWXSxeUJhdcdLgl5PvXV7vPTaWwhuQAtAyP0QFvPGMN4FwueagkM6kxd9IzRtAgnTQACUzvjpoxczOVTt+qgDQT5dx2DMGJuaV6kVZWzXP9imyC55pi5N+V5GK7zv85J7O8egNwWu1W5mXalVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY8dUfZBR8uzpbIOVNfnUVNw1BmuoIFYNGRTOMCMnAc=;
 b=f3AIII2FKKKgHvBMWuTSaOcp+w5kATjjwVTMEeFbUQAb+uIHFLSUlaycXBdMbWUbgJ83Ch47HkMBlBshwAjYP+6FaZpmSNGAkvOq1pe6lbVvXee8PUvrJtdntIZdvheaZuhKj4Y7gH/i2ucqPFxtEZnnKk57lKV1pv1V7cBAKZFFlcXgDgaS/ximL+7/wX84xqFF88MwzYk4qto6/Xr30cXHaXxvhGtCey4uWhMXGb9JwPazlLmm3D54wOjOC8YRFA5PTJKZOLBaLQHXcGJLMkKexmnP6KBuhDtNoNEC0FG/ZL/ubq9VCox+onIdiKzMCQHjCJ3rE3PeOtOiuf94qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KY8dUfZBR8uzpbIOVNfnUVNw1BmuoIFYNGRTOMCMnAc=;
 b=NwEvRkTe8+/EhS0uL/3wGaMLbe+gD1I8L76+c6UBDU3FOfb52Q+hxKDQGtB1JFyth824hHw7U0si8CTsBRaNS1bgwzoih6RFnvqQzTG5A1az7qN3f0QMlonWkjIWqeu9IhG8VT0+tTXPlmHnxZa5obEl61aeoBtcxGvjJc1+gnI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7219.eurprd04.prod.outlook.com (2603:10a6:20b:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:36:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 15:36:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH ethtool 1/5] uapi: add kernel headers for MAC merge layer
Date:   Wed, 11 Jan 2023 17:36:34 +0200
Message-Id: <20230111153638.1454687-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
References: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5363b0-482e-4b80-5c79-08daf3e9aa1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KidHnGSEZbOgLj4CvxnrFVrfAiUfzB1ju2PcgxvQfKRzwHYUJxRvaq8M0pzfnBBc1LgBKFLeWWINQMYXo9PFVanI3lE0y3fjAqrk/gckLzmRT1+tidROijdliM2WaJjo55/OsjUsBzPlTDOHzUhjpmFJA9ij3nwZDQz9I2gAQK5i83vm1UskZLkTLHut96HVq5mE27bi5A8QoNPfMcvSC8huvkYxX500VaVxrVzbQIvrW1rFKgFytu6Jwn18IH/mR6r9DryggdQB9elv4w0lM3eXMbm7D/rkPAVUQ4DW7It/sKUZ6HEeV1A+BqiaLnEexvnI1Jbs0YLqsjeGaRMVD3twmNSVn4HU4HSD0GHeLsxGIZnVImr7o8sJppDiQ1j5DGKjKAEIrOnWA/n84mWcTFAj/Hr2AzNLMUenH3Fbsx8zltBBILmm0+3hbUjW0CSiDTuUhglypGwmNiInYH3No+CV4SDkJv7O8Psea4kmWEeNnIRcYCgxHUdZyArie+AY4+r1lywS6C6Dqxx20xL9IpxE02ALdOsZ1dmNzVO8DD2iK42pEmsR0B0ofvwBKcPn60wjRfPSAPDwkoFDWdRFF7yDJft6WTAoEdA9nrvhngYf+bWNfOVER+RLj88NIl3cj5T40A27zD2T1JscyM5gFzTIVg4I/1X/edjvR/szNx00AeA0njMLoIeBsg225yyaGSpY0fQSsCwcGkoKd7pzPVGeg/vwbLj48S5sB+6WOQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(44832011)(52116002)(4326008)(316002)(66556008)(8676002)(6916009)(66476007)(66946007)(54906003)(26005)(6512007)(1076003)(38100700002)(2616005)(86362001)(38350700002)(186003)(83380400001)(36756003)(6506007)(6666004)(478600001)(6486002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG1oclYzeUF6NzJlbW9GL3AyRXM0QzBycDZXR0NEWDIzdG1JcExLREFJTHpP?=
 =?utf-8?B?dDFqbXk3cFlOWEhBdHFaY1V3elZvckxmVjJPSzBsWWM3ZVRaRmYySy9LOE43?=
 =?utf-8?B?N3RpL2hoNGdEcGJmQzN4dWh0bm9xbkZKMUR0R2R2VWpINkhzQ0Z2dkwzLzJ1?=
 =?utf-8?B?cXNLeDlkUnlLeU5seVRzTmJ3UlcrYk03RW9UWkdQYWl2ak5JRDUrdUhCVzlB?=
 =?utf-8?B?cTRIcE8yaGR3clJMM1o2NEptc1d1ODdFcGhaZ2Y0NWhQZ001OEZtYVVteHlu?=
 =?utf-8?B?NHIyNjc3aVpKZWppN1RnMHgvSmo4R3FHZ2ZtMnNGQnN1TEJXTEsyTGt1MjVw?=
 =?utf-8?B?ajJCMzhWY1dGa25wNmV6aXU1OUkxQTZMUjV6cFJmRzVvRWdQQWVpVGVwOFJu?=
 =?utf-8?B?UWFQMmM2M1huZjFOSnRMcWRjeUZia2o3V0s1N0NSY2JGd2ZKYXF6NGUxSmti?=
 =?utf-8?B?UkV1Z3dLV2dWcXFhWFRsLzRuVzZSa1J6YURkdlMzTjdKalNPU1AweWZvYmxG?=
 =?utf-8?B?RHREbUJxS0lyT3VSdWNHNlFTdjI5eVNGbE4xTXJtNEtGWGkwUVpLSDVLSUpF?=
 =?utf-8?B?ejhBczlzZFRDdm9FWHQ1SlQ1TGhOd3hRN1VWL1VvYUZVdWxSdDJlbEcyU3JB?=
 =?utf-8?B?cGZza0VQSG82aDNoUUFSNzhFTUNBaVdXdURab0VJYjBWVmJIOHhkQ1djanRx?=
 =?utf-8?B?U2RQVW9mbVhWYTJBbks5cXhwb2FQWVlWdDlxQWxSTEhNUnhuY25DYTg3Kzlw?=
 =?utf-8?B?bE5raEkwb3Q1ZFpBWm5HbVBQWjkzd3hPKzJzN2VjZXZlS0dSaERsQkJsS2pn?=
 =?utf-8?B?QmkzTWR1NG5qcElFU1dxWmtVZ1h5N2x4TVdSU3U3VGYySWVLVlhiUVg4c1Ji?=
 =?utf-8?B?REdvQzJrZWpUQS9FSjJ2cFNKVEtpaVFRZFNIa3o4d1BQRnBJbHRScnVjdUJh?=
 =?utf-8?B?NUZ0aWtxTmFEZ2dSSFBoU296YlVsMFBsc0MvZmw3RW40cnlSeGlQZkFSMlNx?=
 =?utf-8?B?ajc5bkdMNFhvbXVLbUdDcGYxbHdtNFBpM3ZDaUFPMTFRb0tpWHJ4TGhzTXNm?=
 =?utf-8?B?M05kbG9TVDdPNDlRQkdpNlRnTU9hbGFIZ3VtZW5JRTlsVG5QL1drMURJMFdj?=
 =?utf-8?B?WFRaTHBYcnpWeG8wVElJSXpxYlhFSXRLSlpsNmFwUG0va1I1ajB4NUlYdS9x?=
 =?utf-8?B?U2k5UGJqc0VHb0hNK2l3aUZEVy9LQS9kdWtlY3RjY2xCek9SdHRpVFlReld6?=
 =?utf-8?B?TGQ0RkNXNXh6eW9DSHh4RWhtempzVGlDR1p1dEMrZlgydlhBWmZJR1NUMS8y?=
 =?utf-8?B?OEY1OXV2VGJ1eFpwRGFRTWVsN1lUbFB2cktNN2dHM1ZPUEE4ZmZYWlgrdVEy?=
 =?utf-8?B?WTgvUWd1Z1VKbWMvWGNaUzRrMUw5UVdBWTArSUI0KzBvSHFjVDZjU0JiY0ZG?=
 =?utf-8?B?R0FsM0U2MC96WkxBUWphTzdTNVRPOHo2S2E0YTB3R2FjTVZWVHZ5cU9BbTJ6?=
 =?utf-8?B?QXI1WDJtM2FiOXQvSnhJc2p3dXpJT0dlVVRDemZUYzVOSEJ3UzZjbDRPN3h6?=
 =?utf-8?B?R05VaGlLanpDS1puRVRXRVZGYkNoOGxUQWtYQlcrUnZaLzhGbTFyK1k0VlFh?=
 =?utf-8?B?YXlobVY4WmRKVFJXUjY4ZE1yanljNGpPdWZOTFh4Wm96dE9IYmpTK0VTaDV3?=
 =?utf-8?B?akJuaFN3M2lFRG1mZjNoaXlYY2wrK3NRR3dYZHg4amZtY0hwRGpnbENibUlG?=
 =?utf-8?B?MHNVYi85aG92Y3U3Z2JxaC9YRnFrcVNoaGd2NWh5dzQvdWVoS3VITTdvTVdK?=
 =?utf-8?B?WkNmVUxFMXY3aVRaM3NJU0U1bXl2bTNmVVowS1RyNTRnVzZKZndyS2J4S1ZR?=
 =?utf-8?B?NEhPN0ZMMEtyOWxCRDlpS3VXZW85UHVGVlUwZUZJNW1reXgrMTQ0ZUVYR0M5?=
 =?utf-8?B?Ulk0V1BHdlJLcTNIbWFnTU9mZVpNL3pmT09qTlVIQzA1dGo0enorbHVvZFdI?=
 =?utf-8?B?UUNFZGs2ZW1wNFlVQU1zcHNaU1FVMnZJRlRFY0Y2RGF2amNNbGliSm91K1ZN?=
 =?utf-8?B?Rkp4cGdKZkQyc2hjRlMvR3NFLzNLbUxES3VSeis5SjBJcXBzcDlKYjVvN29p?=
 =?utf-8?B?T0J1WmNtR1FYQ1llZ2J2UHlXd2xFNjZKU0VmSjJLbTdneEl5dHJQb0d2TDJY?=
 =?utf-8?B?Snc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5363b0-482e-4b80-5c79-08daf3e9aa1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:36:54.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrAg/XeKTyV2zBFmvikSU5d1yoBb39oatmSIP/0bnnumg7KvxJ95xYTzoUHrytut3470xJ1PhdD3MfbXls4zcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Import new ethtool netlink definitions for netlink messages and
attributes having to do with getting and setting the MAC Merge layer
configuration, as well as its counters (plus individual eMAC/pMAC
counters).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 uapi/linux/ethtool.h         | 43 +++++++++++++++++++++++++++++++
 uapi/linux/ethtool_netlink.h | 50 ++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index d1748702bddc..2eb1f8c2a89c 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -709,6 +709,24 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_stats_src - source of ethtool statistics
+ * @ETHTOOL_STATS_SRC_AGGREGATE:
+ *	if device supports a MAC merge layer, this retrieves the aggregate
+ *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
+ *	statistics of the single (express) MAC.
+ * @ETHTOOL_STATS_SRC_EMAC:
+ *	if device supports a MM layer, this retrieves the eMAC statistics.
+ *	Otherwise, it retrieves the statistics of the single (express) MAC.
+ * @ETHTOOL_STATS_SRC_PMAC:
+ *	if device supports a MM layer, this retrieves the pMAC statistics.
+ */
+enum ethtool_stats_src {
+	ETHTOOL_STATS_SRC_AGGREGATE,
+	ETHTOOL_STATS_SRC_EMAC,
+	ETHTOOL_STATS_SRC_PMAC,
+};
+
 /**
  * enum ethtool_module_power_mode_policy - plug-in module power mode policy
  * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
@@ -777,6 +795,31 @@ enum ethtool_podl_pse_pw_d_status {
 	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
 };
 
+/**
+ * enum ethtool_mm_verify_status - status of MAC Merge Verify function
+ * @ETHTOOL_MM_VERIFY_STATUS_UNKNOWN:
+ *	verification status is unknown
+ * @ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+ *	the 802.3 Verify State diagram is in the state INIT_VERIFICATION
+ * @ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+ *	the Verify State diagram is in the state VERIFICATION_IDLE,
+ *	SEND_VERIFY or WAIT_FOR_RESPONSE
+ * @ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+ *	indicates that the Verify State diagram is in the state VERIFIED
+ * @ETHTOOL_MM_VERIFY_STATUS_FAILED:
+ *	the Verify State diagram is in the state VERIFY_FAIL
+ * @ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+ *	verification of preemption operation is disabled
+ */
+enum ethtool_mm_verify_status {
+	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
+	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
+	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
+	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
+	ETHTOOL_MM_VERIFY_STATUS_FAILED,
+	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 0d553eccea81..2b96f6212fed 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -52,6 +52,8 @@ enum {
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
 	ETHTOOL_MSG_RSS_GET,
+	ETHTOOL_MSG_MM_GET,
+	ETHTOOL_MSG_MM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -99,6 +101,8 @@ enum {
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
 	ETHTOOL_MSG_RSS_GET_REPLY,
+	ETHTOOL_MSG_MM_GET_REPLY,
+	ETHTOOL_MSG_MM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -415,6 +419,7 @@ enum {
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
 	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
+	ETHTOOL_A_PAUSE_STATS_SRC,			/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
@@ -731,6 +736,8 @@ enum {
 
 	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
 
+	ETHTOOL_A_STATS_SRC,			/* u32 */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_CNT,
 	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
@@ -894,6 +901,49 @@ enum {
 	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
 };
 
+/* MAC Merge (802.3) */
+
+enum {
+	ETHTOOL_A_MM_STAT_UNSPEC,
+	ETHTOOL_A_MM_STAT_PAD,
+
+	/* aMACMergeFrameAssErrorCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS,	/* u64 */
+	/* aMACMergeFrameSmdErrorCount */
+	ETHTOOL_A_MM_STAT_SMD_ERRORS,		/* u64 */
+	/* aMACMergeFrameAssOkCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_OK,	/* u64 */
+	/* aMACMergeFragCountRx */
+	ETHTOOL_A_MM_STAT_RX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeFragCountTx */
+	ETHTOOL_A_MM_STAT_TX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeHoldCount */
+	ETHTOOL_A_MM_STAT_HOLD_COUNT,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_STAT_CNT,
+	ETHTOOL_A_MM_STAT_MAX = (__ETHTOOL_A_MM_STAT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_MM_UNSPEC,
+	ETHTOOL_A_MM_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_MM_SUPPORTED,			/* u8 */
+	ETHTOOL_A_MM_PMAC_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ACTIVE,			/* u8 */
+	ETHTOOL_A_MM_ADD_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_MM_VERIFY_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_STATUS,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_MAX_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_STATS,			/* nest - _A_MM_STAT_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_CNT,
+	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.34.1

