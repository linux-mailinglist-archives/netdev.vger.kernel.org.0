Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F58596580
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiHPWaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbiHPW3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:45 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDD47B2BC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4+hmiRyxrw6nqpIp+lA+F/ja82UCCIQeblkUo65dzkR0L1VQb4sCLv4gF2rVh2BI7zGrDBZGMYIOLMNSG+dP4pAVgMK72NvdILthoDILjKu1ZOEmXFyFZs5QQfZ+obBQ8Eo1XfcbES/YrNvgCaNkd2HdVfabq5XPvG22+YyIMXph59L4BdKHii/wh1VL6qQZykeGJDba9JSgPqyJI6rlqveK4Jy2OwMVN5Hw1yLBidKXwKFUShy7aSPW+MA2Exf+o8DgDkJy7XkgV167KzK8ZNRnlliWddtdIZ0UeNRUAG/iV+lWbKWo8AzOaeK2mgNsF5YEghJOH/wQcrghrgUQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ha117TNM1voikqTY0y+AdVW12QCG2cr1c0e7lFKDS3E=;
 b=V7Af8fIqmvIKLrLsSIqVSUrfDDS/xtJLqgcIyWRSKv8DGnpBCvCw0jGtJ4FiAmsg7ZE1VM9A3RBo64PG0k0utLOIN4kPmGPbWNtpWPD5bt7tzFnbQobqB8AZ2vb/aL49uzCLZTT43LBkdPuaPflsTIWIfza6tSBIv+fij45Vv02zVOHD0UOyGUCfg8AK41jvzfyQqhS8c0KZeI962zfqY7VU0ZhYXAtEhLaktHUP67NA7InkHyvwrKYKh7p5D2uNpVzeRNeylFwnVJ0xjyDwctuZvsHmVC2eGv9oZupflzn8qZ6nepRohcmNQy88Sg2m8cngyd4/G7qTS7wJscYOpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ha117TNM1voikqTY0y+AdVW12QCG2cr1c0e7lFKDS3E=;
 b=L2xSxaVFNBglWORG4QAvcDsK/MEwVCgeks2GrQ5UsNY5ZvYMmpsQehIikwVRbZO6uED+8ygCL/cUUqdOmJfAN49Z8oTWf1INHWxrZz0Kt9c5MzFnopU2J/ZUl961RdgpDeqLEUEKNBPcvzkzw1lm6owXExzXdBUlh2M/3EZ+y5s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 7/7] net: enetc: add support for Frame Preemption and MAC Merge layer
Date:   Wed, 17 Aug 2022 01:29:20 +0300
Message-Id: <20220816222920.1952936-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ebeba5d-357f-439a-b626-08da7fd6ccc1
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SyUcOCKebGgnAseK7m5pzMCrB9lGQydr/2DuvWmolCudRSkTIe1jJHN1S3cMgC/3y7MGxZUp5igcjMubrs87SdmtS1n9yg5gOsZUs/OloZ7G5sFDCgxqFGQ1nCv/QjEDoupvMA9aLi7ksH34YP/MaahttJRm0s5Aq/APl/w5ViYx0M5PmNo3I3DbsckLpfv89jhLACpf3Pou2JilmBawTE1Dc0yro5b3uqgQZJIJp/P5+bThHUFGliJHsgxc9oahHdkdn45Aw+rGoigThoM0L9lnu/Pa4ESq7fXpdS3UiflC6KsIHia2AaECoZSXAIrmEPHnM9r/giQpXrnC0rC2vUNhUwpInYw+3hep2dNNfwd+ZsCjtV7K3BGm7dFIJ/KHT5e7xGbbN0vJAsksBjDPCBGhs68fF0LEs6zuwuM7dar0fYyi/t2GlX5xL5VNn8/jakUcozILeQLHrDQTA+a+ve2uNpfhQEO0ly+MtW2e30VVl/zFCAkxe9p5ZS7yyJ6JoZgOAoSOn61BVDwQ4heZxnxl0uWir5Vd7BF5VMDr595a8Fvnwt5zsZJG+JzM9ePDOcTe4Tg4/1VBrl2y/zAn5jFnMDxJgmZrc6fGupkDlZF5IxxFJ7Cz/OMOebOMZAGyHTm8LWjLPE9ff+NA8L44L8bC9yHKQ0dEgYlI0iibvgqfpBo6XULRldC+5x9kTKW8OXKJFlLX5rEzCy1dYbHe1Xp1+1CO3SN2EpkV2RDuILGzK+I0KYzpBakhM3XBzPzBt5uBIN22VpqJj3UYKELUwDrX7L3v6kuGHsPvNZWNC/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WkD++nv0hUef88aI34+G84BSM53Ls4cObFS12X2pVh/RiUIRSJmMTRQIJawo?=
 =?us-ascii?Q?PJuam8PqJhGdc9EMGQmoAzP2PEkq15eYiHRL4MqnlRW2rLyOP2kQFWjmi4f9?=
 =?us-ascii?Q?Gj9qxA7OjI2VSP16tqtMJFs/A5AU2lqeEMpokvW5nrBf1BGkQ26Za59fkxHz?=
 =?us-ascii?Q?OxmMLugcjaNqmXcbUrErnpCJRnwXZU8dlHk6+iz4miHiFlNM+nxRyS8j6Aff?=
 =?us-ascii?Q?Sa8PAo9ULatxcWotMBZapOvzh2B+6Kz1TdiHwqxmlzWX9QJOBdH7OpKuLTKp?=
 =?us-ascii?Q?0gBjSmppovmQflxgMRSwv/JMRgjMtuTVbYW7+LwBFlSSBhtxb4NndYRoFm7M?=
 =?us-ascii?Q?RQ/dA4DwzCbJZVBXcyAqjrw5T722bk0oMRmfY4QjB1LGdzZ9fsnwEqmc/g3q?=
 =?us-ascii?Q?ywQ2oDUZQkOWJDP0XF22TtU7PJKwTmQ7Mt3TwmfO+QV4ymqDQid827s1PI2H?=
 =?us-ascii?Q?SwS7GM77TaHczWRdPft6zgzM/7th+sgcNp4WiF7V0Ra3zmtNwziVl6WDrP+h?=
 =?us-ascii?Q?KzPO0Dzt3mIrKrwBcoNN+wtwYHIKUBcPsj/PfnFrqoRf7LmhHh43fUSDqyzk?=
 =?us-ascii?Q?sW29qXfItWVorAHHFTkJnMp7YK5zJmJ5+0/ZrcXi0H9Nl/H4WGxgMlCNyNO1?=
 =?us-ascii?Q?jCCeGspPhEndn6p1pbYL7hxPyrVlmv+p0PZESTCZjOGxfXW8su4aDond/12r?=
 =?us-ascii?Q?5RGLoex6icOfhKA10fvVpw55/Buu+sW3bKj4uOFmZeATjE/n1sjKH4ff2NTd?=
 =?us-ascii?Q?Kn0gQ5wI2TYQKs8AN+ye6g5I0wpen3pGl7PFfTy5yvkr3kTtZCxEv9NWfMco?=
 =?us-ascii?Q?EVe3KmvgtLDwIVgjK187xpUaR03wS0jrAu7zPkkxk59RE48tjQDRr2usNXDI?=
 =?us-ascii?Q?RvZx9F3L60ahkVV7zVAd5F4npjVYNzFK9erfxak29p+DtW6NHexaiaOxUWCo?=
 =?us-ascii?Q?/VhSV8C4i4irqHgw69FIG9MFpge6xQP/T78O+4v2uIPpzrlDwp95w9q9Qt4D?=
 =?us-ascii?Q?wBPpY/2soBHWcMnZsxXnDBrFQboAGVodOy1Bjjpzi9Xe49NjfJDHHobnutUe?=
 =?us-ascii?Q?rKrCBH/jqY/C1YjcVrp6hzFo3X/rdCHTho5UFZ/BQIHDrBB0VHLqLlSsRQZJ?=
 =?us-ascii?Q?sOYXRjNJgWAOrCU9adgPpg5wQYFNGvKfjVUyMRHmiRFhkc1aiCt2LZR/dq8M?=
 =?us-ascii?Q?p6jp3GAL8CeSbx47cvgpuurGZ2bmCgIli42Wb+g5LrfJUrgZOKpTLYSO0qXX?=
 =?us-ascii?Q?vqNBSGGr0LmycrOwoyYZkR37uWCjM2JJxd5xpygUKQF+MtyKrOtIaBMfqhKI?=
 =?us-ascii?Q?lXAPrjGPJUcxk8xLOsfA3eNenyN+a/Q+r7caJg3CmFqJ4N7xcljuWcZ0OOiC?=
 =?us-ascii?Q?hmJP52J43QqQxAi8MVVkvHxqvGEsAn0NjwD20BcFiYCAZkny8ULio7SFiwhi?=
 =?us-ascii?Q?Rots3j8EMHoV/xsTqzla98Wju686GSNpSHhN4rKyRfeVhZCpYLdX+pHdSJVe?=
 =?us-ascii?Q?rce/F30ssHZBewloU2fAQmJm1FSkMoHYzvXrUn6ZjwVxBjpDkF3atDik88Gb?=
 =?us-ascii?Q?XCbgOf04D3FlNxQEu/j/+cU4eFA67O7OnxUsd8TQ5+2kRRB87DUbZCKclr48?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebeba5d-357f-439a-b626-08da7fd6ccc1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:36.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6YJwsXG6xHH7BQzBQvlGkRwJE4oG4xmBjDNUuZuMMI2vVcaOnLTsGQoZy8bQWqo7Sh89dPuqXo3A+wQlIVBCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PF driver support for the following:

- Viewing and changing the Frame Preemption parameters. Currently only
  the admin-status (preemptable/express per priority) is exposed.
  The spec also mentions HoldAdvance and ReleaseAdvance as times in ns,
  however the ENETC treats these as bytes, and we currently lack the
  proper logic to do the bit time <-> byte count conversion as the link
  speed changes.

- Viewing and changing the MAC Merge sublayer parameters, and seeing the
  verification state machine's current state. The verification handshake
  with the link partner is driven by hardware.

- Viewing the standardized MAC Merge layer counters.

- Viewing the standardized Ethernet MAC and RMON counters associated
  with the pMAC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 164 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  26 ++-
 2 files changed, 189 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 25705b2c1be9..9a6869c7663a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -408,6 +408,34 @@ static void enetc_get_rmon_stats(struct net_device *ndev,
 	enetc_rmon_stats(hw, 0, rmon_stats, ranges);
 }
 
+static void enetc_get_pmac_mac_stats(struct net_device *ndev,
+				     struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	enetc_mac_stats(hw, 1, mac_stats);
+}
+
+static void enetc_get_pmac_ctrl_stats(struct net_device *ndev,
+				      struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	enetc_ctrl_stats(hw, 1, ctrl_stats);
+}
+
+static void enetc_get_pmac_rmon_stats(struct net_device *ndev,
+				      struct ethtool_rmon_stats *rmon_stats,
+				      const struct ethtool_rmon_hist_range **ranges)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	enetc_rmon_stats(hw, 1, rmon_stats, ranges);
+}
+
 #define ENETC_RSSHASH_L3 (RXH_L2DA | RXH_VLAN | RXH_L3_PROTO | RXH_IP_SRC | \
 			  RXH_IP_DST)
 #define ENETC_RSSHASH_L4 (ENETC_RSSHASH_L3 | RXH_L4_B_0_1 | RXH_L4_B_2_3)
@@ -864,6 +892,134 @@ static int enetc_set_link_ksettings(struct net_device *dev,
 	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
 }
 
+static void enetc_get_fp_param(struct net_device *ndev,
+			       struct ethtool_fp_param *params)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u32 val;
+	int tc;
+
+	for (tc = 0; tc < 8; tc++) {
+		val = enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(tc));
+
+		if (val & ENETC_PTCFPR_FPE)
+			params->preemptable_prios |= BIT(tc);
+	}
+}
+
+static int enetc_set_fp_param(struct net_device *ndev,
+			      const struct ethtool_fp_param *params,
+			      struct netlink_ext_ack *extack)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u32 val;
+	int tc;
+
+	for (tc = 0; tc < 8; tc++) {
+		val = enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(tc));
+
+		if (params->preemptable_prios & BIT(tc))
+			val |= ENETC_PTCFPR_FPE;
+		else
+			val &= ~ENETC_PTCFPR_FPE;
+
+		enetc_port_wr(&priv->si->hw, ENETC_PTCFPR(tc), val);
+	}
+
+	return 0;
+}
+
+static void enetc_get_mm_state(struct net_device *ndev,
+			       struct ethtool_mm_state *state)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u32 val;
+
+	val = enetc_port_rd(&priv->si->hw, ENETC_MMCSR);
+
+	switch (ENETC_MMCSR_GET_VSTS(val)) {
+	case 0:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_DISABLED;
+		break;
+	case 1:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_INITIAL;
+		break;
+	case 2:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
+		break;
+	case 3:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
+		break;
+	case 4:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_FAILED;
+		break;
+	case 5:
+	default:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
+		break;
+	}
+
+	state->supported = val & ENETC_MMCSR_LPS;
+	state->enabled = val & ENETC_MMCSR_LPE;
+	state->active = val & ENETC_MMCSR_LPA;
+	state->add_frag_size = ENETC_MMCSR_GET_RAFS(val);
+	state->verify_time = ENETC_MMCSR_GET_VT(val);
+}
+
+static int enetc_set_mm_cfg(struct net_device *ndev,
+			    struct ethtool_mm_cfg *cfg,
+			    struct netlink_ext_ack *extack)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u32 val;
+
+	if (cfg->add_frag_size > 3) {
+		NL_SET_ERR_MSG_MOD(extack, "addFragSize out of range 0-3");
+		return -ERANGE;
+	}
+
+	if (cfg->verify_time < 1 || cfg->verify_time > 128) {
+		NL_SET_ERR_MSG_MOD(extack, "verifyTime out of range 1-128 ms");
+		return -ERANGE;
+	}
+
+	val = enetc_port_rd(&priv->si->hw, ENETC_MMCSR);
+
+	if (cfg->verify_disable)
+		val |= ENETC_MMCSR_VDIS;
+	else
+		val &= ~ENETC_MMCSR_VDIS;
+
+	if (cfg->enabled)
+		val |= ENETC_MMCSR_ME;
+	else
+		val &= ~ENETC_MMCSR_ME;
+
+	val &= ~ENETC_MMCSR_VT_MASK;
+	val |= ENETC_MMCSR_VT(cfg->verify_time);
+
+	val &= ~ENETC_MMCSR_RAFS_MASK;
+	val |= ENETC_MMCSR_RAFS(cfg->add_frag_size);
+
+	enetc_port_wr(&priv->si->hw, ENETC_MMCSR, val);
+
+	return 0;
+}
+
+static void enetc_get_mm_stats(struct net_device *ndev,
+			       struct ethtool_mm_stats *s)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	s->MACMergeFrameAssErrorCount = enetc_port_rd(hw, ENETC_MMFAECR);
+	s->MACMergeFrameSmdErrorCount = enetc_port_rd(hw, ENETC_MMFSECR);
+	s->MACMergeFrameAssOkCount = enetc_port_rd(hw, ENETC_MMFAOCR);
+	s->MACMergeFragCountRx = enetc_port_rd(hw, ENETC_MMFCRXR);
+	s->MACMergeFragCountTx = enetc_port_rd(hw, ENETC_MMFCTXR);
+	s->MACMergeHoldCount = enetc_port_rd(hw, ENETC_MMHCR);
+}
+
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -877,6 +1033,9 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_rmon_stats = enetc_get_rmon_stats,
 	.get_eth_ctrl_stats = enetc_get_eth_ctrl_stats,
 	.get_eth_mac_stats = enetc_get_eth_mac_stats,
+	.get_pmac_rmon_stats = enetc_get_pmac_rmon_stats,
+	.get_eth_pmac_ctrl_stats = enetc_get_pmac_ctrl_stats,
+	.get_eth_pmac_mac_stats = enetc_get_pmac_mac_stats,
 	.get_rxnfc = enetc_get_rxnfc,
 	.set_rxnfc = enetc_set_rxnfc,
 	.get_rxfh_key_size = enetc_get_rxfh_key_size,
@@ -894,6 +1053,11 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_wol = enetc_set_wol,
 	.get_pauseparam = enetc_get_pauseparam,
 	.set_pauseparam = enetc_set_pauseparam,
+	.get_fp_param = enetc_get_fp_param,
+	.set_fp_param = enetc_set_fp_param,
+	.get_mm_state = enetc_get_mm_state,
+	.set_mm_cfg = enetc_set_mm_cfg,
+	.get_mm_stats = enetc_get_mm_stats,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0b85e37a00eb..b39ef6f03b3d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -222,7 +222,27 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIVHFR0(n)	(0x1e00 + (n) * 8) /* n = SI index */
 #define ENETC_PSIVHFR1(n)	(0x1e04 + (n) * 8) /* n = SI index */
 #define ENETC_MMCSR		0x1f00
-#define ENETC_MMCSR_ME		BIT(16)
+#define ENETC_MMCSR_VT_MASK	GENMASK(29, 23) /* Verify Time */
+#define ENETC_MMCSR_VT(x)	(((x) << 23) & ENETC_MMCSR_VT_MASK)
+#define ENETC_MMCSR_GET_VT(x)	(((x) & ENETC_MMCSR_VT_MASK) >> 23)
+#define ENETC_MMCSR_TXSTS_MASK	GENMASK(22, 21) /* Merge Status */
+#define ENETC_MMCSR_GET_TXSTS(x) (((x) & ENETC_MMCSR_TXSTS_MASK) >> 21)
+#define ENETC_MMCSR_VSTS_MASK	GENMASK(20, 18) /* Verify Status */
+#define ENETC_MMCSR_GET_VSTS(x) (((x) & ENETC_MMCSR_VSTS_MASK) >> 18)
+#define ENETC_MMCSR_VDIS	BIT(17) /* Verify Disabled */
+#define ENETC_MMCSR_ME		BIT(16) /* Merge Enabled */
+#define ENETC_MMCSR_RAFS_MASK	GENMASK(9, 8) /* Remote Additional Fragment Size */
+#define ENETC_MMCSR_RAFS(x)	(((x) << 8) & ENETC_MMCSR_RAFS_MASK)
+#define ENETC_MMCSR_GET_RAFS(x)	(((x) & ENETC_MMCSR_RAFS_MASK) >> 8)
+#define ENETC_MMCSR_LPA		BIT(2) /* Local Preemption Active */
+#define ENETC_MMCSR_LPE		BIT(1) /* Local Preemption Enabled */
+#define ENETC_MMCSR_LPS		BIT(0) /* Local Preemption Supported */
+#define ENETC_MMFAECR		0x1f08
+#define ENETC_MMFSECR		0x1f0c
+#define ENETC_MMFAOCR		0x1f10
+#define ENETC_MMFCRXR		0x1f14
+#define ENETC_MMFCTXR		0x1f18
+#define ENETC_MMHCR		0x1f1c
 #define ENETC_PTCMSDUR(n)	(0x2020 + (n) * 4) /* n = TC index [0..7] */
 
 #define ENETC_PM0_CMD_CFG	0x8008
@@ -944,6 +964,10 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 	return (u32)div_u64(usecs * ENETC_CLK, 1000000ULL);
 }
 
+/* Port traffic class frame preemption register */
+#define ENETC_PTCFPR(n)			(0x1910 + (n) * 4) /* n = [0 ..7] */
+#define ENETC_PTCFPR_FPE		BIT(31)
+
 /* port time gating control register */
 #define ENETC_QBV_PTGCR_OFFSET		0x11a00
 #define ENETC_QBV_TGE			BIT(31)
-- 
2.34.1

