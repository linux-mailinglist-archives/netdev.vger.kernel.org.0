Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C591359812
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhDIIig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:38:36 -0400
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:61615
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232161AbhDIIid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx9mkAV6rvNR46tIQpss9qc0oLZrff97TsSnaciYqOJGuFf7J8fn8D7zdComSDO5/ixF2llWWU0qIxxW+mxFSb08jMb/+L/jmrQnq9OAQ7CIYTb/+VM2G/hph1CSHKydcQE6HLj4XFu+7VoEM7i8aLgWLVNIo2pf9vHkXnA1oA95fnTACrgVCK8rHlS95z+yrT4izE7F4EcSUl78zKXJnKX0OWl+JkkWiib/XDzasjHuudvlC1VMJWV43qUniXJDRiOR+N4UdSIV3JLly6RRwpPjAuYS6/whVGuPFxrxczmiM+CLxzr7JQFNyz7tafK7i8k+e7dgNv0LckaSye9d3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iB9kddQliaUKAkoLWowI2Km+Ju0958c8++EXuYyz0Y=;
 b=SGwUHhcfhAcA6Qje1EnQCergD8jI+nO6o/blyLsPx/I5CVFuxQIR8nHvG2EyW5FJZoQ1tW2Cb1H7vlImGcHA4eJRo66j05NlKF7B6ku+rgdNgWIlnRqdCE4mu7CwgkJ2VfWDrNJFw1RZU97Xwsr/WafMe6SRe/VtiD1pN/oDGL82oSFKA8iSHVSvHXZIIpXTNgt2E6QTGzdDeliLNxKt1XxkyBZ2mgUKzimNVhFJmbE+KxZ1O9vODA4X3uOfb8ngf5VRi7o7ldhZFVYIytvZLlgIw2ZmaduHWrmhS6IdfqcYUBpgDnucOOIq7i1UHdOZdvft8PMaLGhk0+n9KaZZNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iB9kddQliaUKAkoLWowI2Km+Ju0958c8++EXuYyz0Y=;
 b=ZHquo/VAdubbsghaHuFTCouXS2sGRnJ7r18+olPMnm4AaRaw30tBSIjZnDuEPmnaVlzcdfgDRINWuLb9mb9sB5q1+QlAwhkcbZmJCkMS2b06sfIz8p2lY+pdRIEvw+nA0OXNE2aCFjPEQWhoZ5SbFNrSwSN4YTeqB2eMgEWPUew=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4521.eurprd04.prod.outlook.com (2603:10a6:5:39::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Fri, 9 Apr
 2021 08:38:19 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 08:38:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ethernet: add property "nvmem_macaddr_swap" to swap macaddr bytes order
Date:   Fri,  9 Apr 2021 16:37:50 +0800
Message-Id: <20210409083751.27750-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
References: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:202:2::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:202:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 08:38:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 004d3919-dba9-49ed-f8dc-08d8fb32d3bc
X-MS-TrafficTypeDiagnostic: DB7PR04MB4521:
X-Microsoft-Antispam-PRVS: <DB7PR04MB452192BED83D12F352256900E6739@DB7PR04MB4521.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45GDGOHwwfM6Tm583Z6BN4Nb63uN+yAIWQu7q5uOInWsGV9cvf/ndxtlrYMpq2fR/Hr8C6SAWrByR+ZYRX269vChFWsSZTIVzSZhFYFNgTh0ENO2fnuOXaHcdmXn+VlsWEUH3vd6vljl8ozw56tCB5w1c1vmUcDh59zLZN+2pdk4vyQ1iEqXMiD2OAbXmtRIIm0Cqhtkei9jL1NAyn4DmERZp2hfIAqgAWw2zKdJ8XZ0ccCZL7JoUdQKv271b16xX4M6Ggl5qnWpcRa3IKu2HNorV8jy3iC6Pm35cl71vq+OOOxfaZqe5kRhVvOL93jRJDin4kA3r7v077A/J0QO7arQRxBaL4j9TiTb7t/UstLVvNrylm3r2AstiWK/uYGpKYiF24hL4YCksAO6T+gaL2NTRKOP2hU/zWwcABtsfuKug3a5GOXh60j2wke34xvGp8YtVfiGk9/qNp/n5GuJYrlSFGLFLNj/3D5iMYf0d2vSp51s6ManXWIkp14bJiRM+pU8aud3FVu4Nz7iIQGNLtIQ8RiHfv8n9Fc3in+KbgSDAd6F9Nb6E3jk/xvpNROtQPPWY7Slpp94LWIAw0XO9moOYMdhkTjLwM1qhGMuSZqZnuYzf5UUHxRuhmcVwRW/FlmXDaAAsMNm6nxGmc2MGfLqsyq7XlObwQaY9ouHPDPpAdjR/1qeImtMwalWOw2xRQwQq45FdpqOJjREsMOzhdFYsrvOKIOzxKNM47R7LQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(8676002)(6486002)(52116002)(316002)(6506007)(6512007)(478600001)(69590400012)(83380400001)(8936002)(2616005)(36756003)(7416002)(2906002)(26005)(186003)(956004)(38350700001)(16526019)(66946007)(6666004)(1076003)(66476007)(66556008)(4326008)(5660300002)(38100700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tEyeKy9IxcjhcB3Yshd4KrUlk0YuZqcbCMF0exWvcAxFg9xNy67GzaRv7sJU?=
 =?us-ascii?Q?yvT2t019O1/juRXGm6OImH5FJ2/1qBH/RsHCxo+p3Bjv72SOZNS72Je6zN4r?=
 =?us-ascii?Q?5Ct5Ulc8oPl7HC84256aMNabWh8HRWXKpoPCLTl85kfbMvVKUMx8FVs93kTo?=
 =?us-ascii?Q?hmmybvUhn6Pu61DPkdQ57BLxkFSx3mHF0XI91aSkX/Fz0aV00fH02DOLhdUW?=
 =?us-ascii?Q?QA5W3N+2V2Bp8bMHEEl7fVb/5DYjl2xaltlsNtalpwH4sjVs2Jr8N4eLxXe/?=
 =?us-ascii?Q?Y2GMWmFYJiX+MtecUT/l2elI9yQH3jEhw3rps/vsWZvlDJvbBbejguKut5EO?=
 =?us-ascii?Q?CaorXDqfAmCa6LducURb2nxkTwYTARNixgnl9xCjaSF+sWZyYZCxoJdas+pG?=
 =?us-ascii?Q?V1n1MteCTyapVN6vSqQzcKL6U3xaSYUsPzUH1cs68q7ndknVuQ+Je1tqQ7N1?=
 =?us-ascii?Q?+3mnZ/s+IZUC3PSDo7OqnkcoenSiN5VcyFLsmAFI/27oqtGnE1Ict1Dn3pu8?=
 =?us-ascii?Q?AwIm1kRY7WKZ4uC1wZCB6O7iPq3pvapxM2EFC5cw4whdDLHaqp04MDM4ADRm?=
 =?us-ascii?Q?YA9wOT5A9PF5J3BEgXcaS7CLXvVyC1qbHhMq4XTK2wXThSTG+qI/k8YVXOAe?=
 =?us-ascii?Q?21Tqg7hEXFe4BFMWKeRFF87Fevm8CHDlGiyPfuidY+V59ZWmmpzgbRVOAVPi?=
 =?us-ascii?Q?AsrL1MkwHqu9qlaT2FQAI87sgDu4hFFyRw+xSgHkKCRMGycIiaKTqNhHh1Lo?=
 =?us-ascii?Q?giRRd05MNn45fuYDilGj5CgkRXnLZhLxMwOxPUJmFdD7NOa6Xkqo0RZN1ofj?=
 =?us-ascii?Q?c11mosSXS0dNW2SoQA2809z5iFCyU4UGr9q0oYG0czZfDqTo1Ee6kjLYbkTA?=
 =?us-ascii?Q?8pTCzCLtpFxq+jmAh0RIaV++9WzRemKiMMaN703vHvIcGijxAov79sJDnazP?=
 =?us-ascii?Q?82QsWIhLnPeOrH0WkwmcGz88pbmd7T+ZhE+bLMwzKKdJ+tllDvjYgHvJDzb4?=
 =?us-ascii?Q?J6qGMLYcOOGKKeLNSb4WfzZ/KsGQOVCciahdMS0zqtV40ueGC8sUi2cvaEci?=
 =?us-ascii?Q?Colojp2zkpl/z9Kbfsz3JF+gKqO4nKt4XSp8PkchWgbt2Q8MFv4D0+1TLSU5?=
 =?us-ascii?Q?if+/FkRFKAw+8bdtFZg5Dfy/i+7XBamcfkSfmlvfKVbeP6mcHX2DCeoZ2ILF?=
 =?us-ascii?Q?VHVt5F9iU9GboUn4QThI3LFXhSVqn8SOmkHKHWn8nsarrMJeLuw9rx7S0Grb?=
 =?us-ascii?Q?/4ypQaFHMpuyuiDnIZ5wUxv/C7HJ4Y79q7GqNZxaGJONGJ/uumGGtxoLxvEH?=
 =?us-ascii?Q?ObFhGvUKbO9i1eNmRwqLxGlR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004d3919-dba9-49ed-f8dc-08d8fb32d3bc
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:38:19.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: stWM380tICWbwHEwRGLX3WZZcHC9taJxB81XGqJHEl5yu7afnBG5I5ulOOrkOC6DdNMDctaoumTKFqV6sZq1QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

ethernet controller driver call .of_get_mac_address() to get
the mac address from devictree tree, if these properties are
not present, then try to read from nvmem.

For example, read MAC address from nvmem:
of_get_mac_address()
	of_get_mac_addr_nvmem()
		nvmem_get_mac_address()

i.MX6x/7D/8MQ/8MM platforms ethernet MAC address read from
nvmem ocotp eFuses, but it requires to swap the six bytes
order.

The patch add optional property "nvmem_macaddr_swap" to swap
macaddr bytes order.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 net/ethernet/eth.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 4106373180c6..11057671a9d6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -534,8 +534,10 @@ EXPORT_SYMBOL(eth_platform_get_mac_address);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 {
 	struct nvmem_cell *cell;
-	const void *mac;
+	const unsigned char *mac;
+	unsigned char macaddr[ETH_ALEN];
 	size_t len;
+	int i = 0;
 
 	cell = nvmem_cell_get(dev, "mac-address");
 	if (IS_ERR(cell))
@@ -547,14 +549,27 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 	if (IS_ERR(mac))
 		return PTR_ERR(mac);
 
-	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
-		kfree(mac);
-		return -EINVAL;
+	if (len != ETH_ALEN)
+		goto invalid_addr;
+
+	if (dev->of_node &&
+	    of_property_read_bool(dev->of_node, "nvmem_macaddr_swap")) {
+		for (i = 0; i < ETH_ALEN; i++)
+			macaddr[i] = mac[ETH_ALEN - i - 1];
+	} else {
+		ether_addr_copy(macaddr, mac);
 	}
 
-	ether_addr_copy(addrbuf, mac);
+	if (!is_valid_ether_addr(macaddr))
+		goto invalid_addr;
+
+	ether_addr_copy(addrbuf, macaddr);
 	kfree(mac);
 
 	return 0;
+
+invalid_addr:
+	kfree(mac);
+	return -EINVAL;
 }
 EXPORT_SYMBOL(nvmem_get_mac_address);
-- 
2.17.1

