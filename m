Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B4225CBE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgGTKid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:38:33 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:51840
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728200AbgGTKid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 06:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5wqStpiyUgOgsBZQNrIovjfmM/EW+lt9H2zZ5Xvo7C4nUiNdTnANNWZ9bdS2jTizhh08bJbia45OYzLOMFjRw2eDQe73xhQZmTXZgdSl4N6J+ALpaGMjBxgV2VvhrgVPer67O0YktVbtVSuEqJIGaN7q7lQllpTgRDWkGpCihZ69t++PBHPzlUwR2Nh0ohhXDVjRsKbOnPHndS8wtkGOHbJf6p4hmCzqzuYhVqtUCpy+7BjuKpsXHNc08NDX2mkCV9RPLcfDYkcNh8eVmYuP2Tk3eaSAVOHh7qfSUZXNoKxCPP4G44ztufQBkhNcycL9VNkuV5AbVHLaI2XCjcjfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Plgb1Y7EdU4GAPagI7YeaATcZqrNuHiqbe5le8Xon98=;
 b=Ri8XrCFyOC6wtHsGNpXG/riHgOosP9Q/8QnG6DyQmHMvIp0Gl34kdVRkiY6J5jQdvxLJqt99i+LC6wKtXwEYccvIWQSxyTHy9XeREr4vxporXHc/N+L9XQCGVCZ1lPMiCwkq5jNiVXSa/9nW7NXsDyT0eNJKtXMHxqxj0pPe+oX3ub4eAd35Ju7rcIwi+0iBfv+bWdjvwRBrCy8x7Xnyt2LSWsFkGh1ia0YQcQfytNMt2Ci+Wty0c5zVf/Rkq9O+bbJv/90m/11sT8X3O1e4sYrv2QpbISPlIBdGmO3tlOr9UA4Nr8isG+hHCWBWZaa4tsotNDI2ANJ5wo+u7Q3eOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Plgb1Y7EdU4GAPagI7YeaATcZqrNuHiqbe5le8Xon98=;
 b=bgYq4sPmDpxQv3NPr9B6fuckcjogi7tsW4bpOBbCUKRn0/+geCe241JiObI16+57DuqOMqn5/LA/PIeEeSppYk0hX3Rpo+h8l84MZqn3W9R2z29VxJYqcVcE1OVNLpGifCSejsaGS8HQAOJRHYD2lhwyUjtatDEtUwnlwM65fqE=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5005.eurprd04.prod.outlook.com (2603:10a6:803:57::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 10:38:30 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3174.030; Mon, 20 Jul 2020
 10:38:30 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding VLAN for dsa  switch and port
Date:   Mon, 20 Jul 2020 18:41:18 +0800
Message-Id: <20200720104119.19146-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Mon, 20 Jul 2020 10:38:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e822d21e-5d83-4d5d-92a2-08d82c990ac4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5005:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB50050BD105A8DE63C9CA0B21E17B0@VI1PR04MB5005.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apJkkIwemWwcGn7UjH+grPrNhTcBsSo3hbhc246ELLAgxnD3lyQatYEnhQjDjaBzkXW8TK3hazmCA/qkQ/4tbfVN7yCQuT6yxsHOVkx+NSMrxw0LKQYJaeBWfhRZ2i+TWqQmH5cs+zo1GnaBLHTkjykCB1/tL0RhytPtQ/JPxVSi3IcntG6mTetSgPOcE+Sx5CoaifiiXwkJ3QcIWfjdiD0B1dV8/Kyw3i9n31rApFipXyVWAm49StF5H5wqseUyM6UhPIaulpUJX6o+dgQfsU2f3omu69U0QqU6ufRfXGBKvKmUqi99utL95jwazgfZWGLj3TcAGaqNW0K7K71XXP+Jper6s+CsvJcSoaZVaIs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(26005)(2906002)(316002)(36756003)(7416002)(83380400001)(86362001)(186003)(16526019)(52116002)(66946007)(6506007)(66556008)(66476007)(6486002)(2616005)(956004)(6666004)(9686003)(6512007)(8936002)(1076003)(5660300002)(4326008)(478600001)(8676002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dI4UoxmPvHtplLTdLqt9pxEOKCy89OWzsMhWTia1qz8tFs+6jeeGunsajuACGPsImvFZY8hRhVuFJqabQNOkq/ODryWQ1sy9bIqvPVPbGIQXUmSRPTOFMoEUVmW5xHdOu+1/wWrqMBkjB2t30168XEV0wGGBOdbfgqjhb+ZeavW/AcVxQL8jz8cNUuwdoqLsPLDeVa7qqkwVMfT76STIa0sRpk0iwAz/jRxCdhju4LHuARxnLdlpGfLhdNGpi/pKD7zOPaelI7NvpzHhKahfClGFvswNHhpFzlSDeJglcUzkeIadjEam4yRd6X1vKeiUKTXBpYq0x9oGiRlkf2X5IdsGyk+lhOLP1tS3fIhg7kHP5Wx4/LrWa+YaxhfCq5ry1T6/3LtjsSLku4XzBckQUcVLEYOq7VtkYDDcHgOKQcFuwwvLFWcaZbiA772h6/U+K4I3vle5EEzutO8Dk0KA2Cm7d4AImseQMH5wpZMwZxs=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e822d21e-5d83-4d5d-92a2-08d82c990ac4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2020 10:38:29.8326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H665WB22f1jTHmu0wU6OgmcFIsMcGtGQw2e6agANPySlBBmTVkzSj506sRWZu5+jY4zSmPRkgzkBTtFjbACW4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

the following command can be supported:
ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 include/uapi/linux/if_bridge.h | 1 +
 net/dsa/slave.c                | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index caa6914a3e53..ecd960aa65c7 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -132,6 +132,7 @@ enum {
 #define BRIDGE_VLAN_INFO_RANGE_END	(1<<4) /* VLAN is end of vlan range */
 #define BRIDGE_VLAN_INFO_BRENTRY	(1<<5) /* Global bridge VLAN entry */
 #define BRIDGE_VLAN_INFO_ONLY_OPTS	(1<<6) /* Skip create/delete/flags */
+#define BRIDGE_VLAN_INFO_8021AD	(1<<7) /* VLAN is 802.1AD protocol */
 
 struct bridge_vlan_info {
 	__u16 flags;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4c7f086a047b..376d7ac5f1e5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1232,6 +1232,7 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
+	u16 flags = 0;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct bridge_vlan_info info;
 	int ret;
@@ -1252,7 +1253,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_add(dp, vid, 0);
+	if (ntohs(proto) == ETH_P_8021AD)
+		flags |= BRIDGE_VLAN_INFO_8021AD;
+
+	ret = dsa_port_vid_add(dp, vid, flags);
 	if (ret)
 		return ret;
 
@@ -1744,7 +1748,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
-		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+				       NETIF_F_HW_VLAN_STAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
-- 
2.17.1

