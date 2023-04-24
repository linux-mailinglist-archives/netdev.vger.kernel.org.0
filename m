Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AD6ECB8E
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjDXLsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjDXLsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:48:00 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2048.outbound.protection.outlook.com [40.107.255.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C0B40F2;
        Mon, 24 Apr 2023 04:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xct/Q1y0FzmIP8gFCc8LhbXpbPToiRqzUlqiDJ4grrEeAlRiIKjc5wEIr7zmcqHzmej6Bp60xalwDiK/a3lMess6JBKl1/k+EzI3ETshDUK6bAJYz1rPboNDYP+YmsOw/qLsD8ROiCaeo/I/tVZFrAvFSLJAMdk4XFc1WqjzrPQO+UjOxQ39iYns4wL2y7tNfUKzqj9LkTkooiJhJb9L+H+ltZqbExfyR84i+m9vYCdGKXQ/+JhkSpbp5YBy05RCWa3wtNzaXM/xVQZtLvwMZU7q5jHsNhFg6cxjCXlgrshm84R2RFTvx+3W9bb6yoZbcybYIgEl6wqpllsixotbFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21jUOFczfDqy5Pif9Oq3osfayLT1I5sXge5E4zgQLbM=;
 b=CSTtMxX31QzMQnM9VoqKkkKg2LB5P3KgxkwRqoNlzSq46Gm6+LIhLPSppsPMWC7RnfCd5CVDE3nfQy3BuUFTECMpHc4FrZp3vz3lHA+HpCaSPV34uvm5RF+38DXa27qtVRGhyAbasSAWT1iT1x+YKNaRbARfMlhXXofty/6H+ho91rTwhraXyIOHnBY+E+NoSQYUFsrt6iuMY2bNShWg7O1sh1Di/+ithDVGz1anNCocqbPbt0Q4t+aWw/zqI5KpW26sAzRZ//GfTxaAeAM2DaC0TlNRmRpk+w3JZIvXcICMHL51hjWrSbVDfpt2ww0mp0L9pWMQ9LhlR256e+JYxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 211.20.1.79) smtp.rcpttodomain=stwcx.xyz smtp.mailfrom=wiwynn.com; dmarc=fail
 (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=wiwynn.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wiwynn.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21jUOFczfDqy5Pif9Oq3osfayLT1I5sXge5E4zgQLbM=;
 b=dg3BsRGabZA3bu5ep4B19uJBp369WcJG5m3X/Dhpn4PjVlM6b8pJ5Vnqy6YKWqLO6AoBUYiv1QfH6UdfrtVlPITSD0vFreUee61hRZd3qfYGXoSrfW/8SOYpjKoKkOLPpf6dF1Ow7XWWjqzfb9ZKX5aGKshsOgWRw9aTByAClaKtDlSXATBegLJWplcJTEtVxethZzHCMxA5Ui8i+KfMoh+JKgg8eT/QIqjKkJVutiLUKC+DOgADAjT7thZ+T0FWRxw00U/EDsqoFJ/euwyA53lyCL0Y+YtXiVQbeYbC9MV9IXF+c2V0AHZjEUAcNhZdBerVSDYE/u3EIMem+ZUvPA==
Received: from TYAPR01CA0044.jpnprd01.prod.outlook.com (2603:1096:404:28::32)
 by SG2PR04MB5937.apcprd04.prod.outlook.com (2603:1096:4:1dc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Mon, 24 Apr
 2023 11:47:54 +0000
Received: from TYZAPC01FT014.eop-APC01.prod.protection.outlook.com
 (2603:1096:404:28:cafe::22) by TYAPR01CA0044.outlook.office365.com
 (2603:1096:404:28::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 11:47:53 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 211.20.1.79)
 smtp.mailfrom=wiwynn.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=wiwynn.com;
Received-SPF: Fail (protection.outlook.com: domain of wiwynn.com does not
 designate 211.20.1.79 as permitted sender) receiver=protection.outlook.com;
 client-ip=211.20.1.79; helo=localhost.localdomain;
Received: from localhost.localdomain (211.20.1.79) by
 TYZAPC01FT014.mail.protection.outlook.com (10.118.152.64) with Microsoft SMTP
 Server id 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 11:47:53
 +0000
From:   Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
To:     patrick@stwcx.xyz, Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Delphine CC Chiu <Delphine_CC_Chiu@Wiwynn.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] net/ncsi: Fix the multi thread manner of NCSI driver
Date:   Mon, 24 Apr 2023 19:47:42 +0800
Message-Id: <20230424114742.32933-2-Delphine_CC_Chiu@wiwynn.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230424114742.32933-1-Delphine_CC_Chiu@wiwynn.com>
References: <20230424114742.32933-1-Delphine_CC_Chiu@wiwynn.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZAPC01FT014:EE_|SG2PR04MB5937:EE_
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: aadebebb-4df8-412e-5732-08db44b9bd2e
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: keEvQZ1dqDZNF7r4MHDttzfHtVa6/wFqLhDMxZqzQrfeyhPYY4O5NO9p+ZUuLyBHoqDPLIUTbr3hF0/jMM/oVxLZuJ7xFS9F8Usiu3+b5oasP+FnJrjmNPtbo5EykZP3WssIrjmGI2QTBwrTqLOKaBXDgeaxdy/YaUJkiLPSyFAl55dc9NqtnsbUE8mqRHn9+d9ZzqrvntkSgW8bJSalhq2Otg2wuE2P35Z6VY06yJwK6X94LNaLc6+Q3A+eb4REtA6moQsgj1w6mdb68P4ReUZXgjke/JKbExoP2VpwRLebX5GwWfOSySYZc8YJWbOswvAZxr38gEM55J502f5BGV9gwu2nvw9xJk5QnGIHaKiyTzNMP2XcScz/sw59X0hKli7Bfox2QFSwDpMLiAoBtNdONPJajPUH2P7Iumiq26A1a+mbMz2jI2IjWF6XUxk8pfCYRg4T8ZLJlwXU+PpILFzVZ1iboWYMulvh11YVbcRsvqFoptITHzFez8p71/BdOwDXTgxF8kIBZCN/1UXnP1TNlg7yZxc2W4Mo3ohwyejb3iBI+D79FnYMXUWdZQaw5rWjeAF3SbzVW/d/TwWlUucVBSRv3/ApI3qlnvLgWg7unprqMU4yLFoBW5Tfk1fqvEkbxK4yjRWGHlxYmEurErz+AhDjx6CYDNqGr0kkwFA=
X-Forefront-Antispam-Report: CIP:211.20.1.79;CTRY:TW;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:localhost.localdomain;PTR:211-20-1-79.hinet-ip.hinet.net;CAT:NONE;SFS:(13230028)(6069001)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(46966006)(36840700001)(2906002)(6486002)(2616005)(956004)(6666004)(6512007)(6506007)(1076003)(26005)(186003)(40480700001)(70586007)(70206006)(8676002)(8936002)(316002)(41300700001)(4326008)(36736006)(478600001)(5660300002)(110136005)(82740400003)(356005)(81166007)(82310400005)(36756003)(86362001)(36860700001)(47076005)(336012)(9316004)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: wiwynn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 11:47:53.2876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aadebebb-4df8-412e-5732-08db44b9bd2e
X-MS-Exchange-CrossTenant-Id: da6e0628-fc83-4caf-9dd2-73061cbab167
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=da6e0628-fc83-4caf-9dd2-73061cbab167;Ip=[211.20.1.79];Helo=[localhost.localdomain]
X-MS-Exchange-CrossTenant-AuthSource: TYZAPC01FT014.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR04MB5937
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Delphine CC Chiu <Delphine_CC_Chiu@Wiwynn.com>

Currently NCSI driver will send several NCSI commands back
to back without waiting the response of previous NCSI command
or timeout in some state when NIC have multi channel. This
operation against the single thread manner defined by NCSI
SPEC(section 6.3.2.3 in DSP0222_1.1.1).

1. Fix the problem of NCSI driver that sending command back
to back without waiting the response of previos NCSI command
or timeout to meet the single thread manner.
2. According to NCSI SPEC(section 6.2.13.1 in DSP0222_1.1.1),
we should probe one channel at a time by sending NCSI commands
(Clear initial state, Get version ID, Get capabilities...), than
repeat this steps until the max number of channels which we got
from NCSI command (Get capabilities) has been probed.

Signed-off-by: Delphine CC Chiu <Delphine_CC_Chiu@Wiwynn.com>
---
 net/ncsi/internal.h    |   1 +
 net/ncsi/ncsi-manage.c | 101 +++++++++++++++++++++--------------------
 net/ncsi/ncsi-rsp.c    |   4 +-
 3 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 03757e76bb6b..6701ac7d4249 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -337,6 +337,7 @@ struct ncsi_dev_priv {
 #define NCSI_MAX_VLAN_VIDS	15
 	struct list_head    vlan_vids;       /* List of active VLAN IDs */
 
+	unsigned char       max_channel;     /* Num of channels to probe   */
 	bool                multi_package;   /* Enable multiple packages   */
 	bool                mlx_multi_host;  /* Enable multi host Mellanox */
 	u32                 package_whitelist; /* Packages to configure    */
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index d9da942ad53d..c31b9bf7d099 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -471,6 +471,7 @@ static void ncsi_suspend_channel(struct ncsi_dev_priv *ndp)
 	struct ncsi_channel *nc, *tmp;
 	struct ncsi_cmd_arg nca;
 	unsigned long flags;
+	static unsigned char channel_index;
 	int ret;
 
 	np = ndp->active_package;
@@ -510,17 +511,21 @@ static void ncsi_suspend_channel(struct ncsi_dev_priv *ndp)
 
 		break;
 	case ncsi_dev_state_suspend_gls:
-		ndp->pending_req_num = np->channel_num;
+		ndp->pending_req_num = 1;
 
 		nca.type = NCSI_PKT_CMD_GLS;
 		nca.package = np->id;
 
 		nd->state = ncsi_dev_state_suspend_dcnt;
-		NCSI_FOR_EACH_CHANNEL(np, nc) {
-			nca.channel = nc->id;
-			ret = ncsi_xmit_cmd(&nca);
-			if (ret)
-				goto error;
+		nca.channel = channel_index;
+		ret = ncsi_xmit_cmd(&nca);
+		if (ret)
+			goto error;
+		channel_index++;
+
+		if (channel_index == ndp->max_channel) {
+			channel_index = 0;
+			nd->state = ncsi_dev_state_suspend_dcnt;
 		}
 
 		break;
@@ -1350,9 +1355,9 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 {
 	struct ncsi_dev *nd = &ndp->ndev;
 	struct ncsi_package *np;
-	struct ncsi_channel *nc;
 	struct ncsi_cmd_arg nca;
-	unsigned char index;
+	unsigned char package_index;
+	static unsigned char channel_index;
 	int ret;
 
 	nca.ndp = ndp;
@@ -1367,8 +1372,8 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		/* Deselect all possible packages */
 		nca.type = NCSI_PKT_CMD_DP;
 		nca.channel = NCSI_RESERVED_CHANNEL;
-		for (index = 0; index < 8; index++) {
-			nca.package = index;
+		for (package_index = 0; package_index < 8; package_index++) {
+			nca.package = package_index;
 			ret = ncsi_xmit_cmd(&nca);
 			if (ret)
 				goto error;
@@ -1431,21 +1436,46 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		break;
 #endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
 	case ncsi_dev_state_probe_cis:
-		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
+	case ncsi_dev_state_probe_gvi:
+	case ncsi_dev_state_probe_gc:
+	case ncsi_dev_state_probe_gls:
+		np = ndp->active_package;
+		ndp->pending_req_num = 1;
 
 		/* Clear initial state */
-		nca.type = NCSI_PKT_CMD_CIS;
-		nca.package = ndp->active_package->id;
-		for (index = 0; index < NCSI_RESERVED_CHANNEL; index++) {
-			nca.channel = index;
-			ret = ncsi_xmit_cmd(&nca);
-			if (ret)
-				goto error;
+		if (nd->state == ncsi_dev_state_probe_cis)
+			nca.type = NCSI_PKT_CMD_CIS;
+		/* Retrieve version, capability or link status */
+		else if (nd->state == ncsi_dev_state_probe_gvi)
+			nca.type = NCSI_PKT_CMD_GVI;
+		else if (nd->state == ncsi_dev_state_probe_gc)
+			nca.type = NCSI_PKT_CMD_GC;
+		else
+			nca.type = NCSI_PKT_CMD_GLS;
+
+		nca.package = np->id;
+		nca.channel = channel_index;
+		ret = ncsi_xmit_cmd(&nca);
+		if (ret)
+			goto error;
+
+		if (nd->state == ncsi_dev_state_probe_cis) {
+			nd->state = ncsi_dev_state_probe_gvi;
+		} else if (nd->state == ncsi_dev_state_probe_gvi) {
+			nd->state = ncsi_dev_state_probe_gc;
+		} else if (nd->state == ncsi_dev_state_probe_gc) {
+			nd->state = ncsi_dev_state_probe_gls;
+		} else {
+			nd->state = ncsi_dev_state_probe_cis;
+			channel_index++;
 		}
 
-		nd->state = ncsi_dev_state_probe_gvi;
-		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
-			nd->state = ncsi_dev_state_probe_keep_phy;
+		if (channel_index == ndp->max_channel) {
+			channel_index = 0;
+			nd->state = ncsi_dev_state_probe_dp;
+			if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
+				nd->state = ncsi_dev_state_probe_keep_phy;
+		}
 		break;
 #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
 	case ncsi_dev_state_probe_keep_phy:
@@ -1461,35 +1491,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		nd->state = ncsi_dev_state_probe_gvi;
 		break;
 #endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
-	case ncsi_dev_state_probe_gvi:
-	case ncsi_dev_state_probe_gc:
-	case ncsi_dev_state_probe_gls:
-		np = ndp->active_package;
-		ndp->pending_req_num = np->channel_num;
-
-		/* Retrieve version, capability or link status */
-		if (nd->state == ncsi_dev_state_probe_gvi)
-			nca.type = NCSI_PKT_CMD_GVI;
-		else if (nd->state == ncsi_dev_state_probe_gc)
-			nca.type = NCSI_PKT_CMD_GC;
-		else
-			nca.type = NCSI_PKT_CMD_GLS;
-
-		nca.package = np->id;
-		NCSI_FOR_EACH_CHANNEL(np, nc) {
-			nca.channel = nc->id;
-			ret = ncsi_xmit_cmd(&nca);
-			if (ret)
-				goto error;
-		}
-
-		if (nd->state == ncsi_dev_state_probe_gvi)
-			nd->state = ncsi_dev_state_probe_gc;
-		else if (nd->state == ncsi_dev_state_probe_gc)
-			nd->state = ncsi_dev_state_probe_gls;
-		else
-			nd->state = ncsi_dev_state_probe_dp;
-		break;
 	case ncsi_dev_state_probe_dp:
 		ndp->pending_req_num = 1;
 
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 6447a09932f5..c3045ac974cf 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -822,12 +822,13 @@ static int ncsi_rsp_handler_gc(struct ncsi_request *nr)
 	struct ncsi_rsp_gc_pkt *rsp;
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct ncsi_channel *nc;
+	struct ncsi_package *np;
 	size_t size;
 
 	/* Find the channel */
 	rsp = (struct ncsi_rsp_gc_pkt *)skb_network_header(nr->rsp);
 	ncsi_find_package_and_channel(ndp, rsp->rsp.common.channel,
-				      NULL, &nc);
+				      &np, &nc);
 	if (!nc)
 		return -ENODEV;
 
@@ -862,6 +863,7 @@ static int ncsi_rsp_handler_gc(struct ncsi_request *nr)
 	 */
 	nc->vlan_filter.bitmap = U64_MAX;
 	nc->vlan_filter.n_vids = rsp->vlan_cnt;
+	np->ndp->max_channel = rsp->channel_cnt;
 
 	return 0;
 }
-- 
2.17.1

