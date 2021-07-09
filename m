Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7546D3C20A7
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhGIIUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:20:32 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:46499
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231278AbhGIIUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:20:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz5TVEx72H5RCzXdy+8zx8XP7faRTMRtotqTkmk+9phyeLPo0wvMygzsczWp11gwA1ox7FNpgbMMFvxQLxENPSY1cXJ9qJfobCMzi9OC2qtF5tTb3tOhBl9t+YMOpoh1/GUav8yOzwOLDCWoZlz9xDj31MAdv9JORveXmb/8DIIr3ABR7N9IAHp3BoDw4FT9zdpVVIFC30XBEH5lykOqp1bdeKWYCWR1cSzkf+C7jStq0s/qu/FOo/bkhRsP9LRcIJwEoBmJwH5vlaWccvnNgm2yEkgVVWKMN9CIdVaPjVTW2n13wg4N12lutWJfj/px8YZG1FeprsaOue7A4F6E3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lO0bExdu8zoU/hgPi2gIotbXHcsLGPC1XQ+LkxG4bM=;
 b=dn6BbygKOK6WRdUU0AJtk9CGy1CR+uDH7WBjs3MvIPVNySpAF8BHLx0LKZ0FrpQdNEjqOsI613s1k8Wg5vBmDrjMa07cXjTZ7KKJFCKJzh0h2Bfeek1G3QtFrfnTOwlSZRT2DvIpn5Q6LullUnb76obSgCUXYGPROUXyO37cF5UvtT5WROkeZOTcf95a/hcqNLok411Qh/6Vhj8sfXL5nzKjjSJvdEBX+IXTdCkbTigVlUTVAwyLfu4xgyK/gycC1VmhodV+ZJK9UIJO+nvdvrJm+EyZqVIkg4fDqDQJH1DXQaOLgH+qfh8l0oRoadsKHqLk+SoVjFdasyxyBJbjKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lO0bExdu8zoU/hgPi2gIotbXHcsLGPC1XQ+LkxG4bM=;
 b=d9Rzs68nKjPH1AJOLc8s3xP9PreD3spOn2I9UrYVCqqoWM7i0U3Z0iXqcGI2e+6wiYf3Kecisu66LPA8RgmBTU2qWvlCffabfeTfEzyz/CXZJ5CqRU+8O3NwrXHqRxeosjGBXP5eVREVE9UNujI4xoJrXmjGoZKO5sWixYLc6HM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6140.eurprd04.prod.outlook.com (2603:10a6:10:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Fri, 9 Jul
 2021 08:17:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:17:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 1/5] dt-bindings: fec: add the missing clocks properties
Date:   Fri,  9 Jul 2021 16:18:19 +0800
Message-Id: <20210709081823.18696-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:17:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35f48127-8bc3-4da5-8acd-08d942b20822
X-MS-TrafficTypeDiagnostic: DBBPR04MB6140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6140B21C10D2A18D246B5A4FE6189@DBBPR04MB6140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxco26P/on/4cT8xXqROAqyum2ORMLwAro+k+GnDMXtj8uelodWT2a9kOsNiS9B/EL2GvNdG5zYyHswY6YmWQ89ws99Rfx27BOkLmDuZeh+RlhlIyqOnXFw/DGIa2SKCtIO+iugrvYYWLUABq31tzciUc9pPoERBqDpubpdF6+sMgFOfjvA/yzWkIXVueKIwlCbXrvl2pLtxDTfpFPD+sYLoCoMqlcqUWlVKKAyU+FWUghbf4nC9VXVR9c/r/qdWjg/0xj3rJSllhN1EfRrfMA3UkRWmax6hfy1p3p71nEFTfl+dwiAQIu17/2MPV+BSg+BenEW7DjydavHqS1smCxcqOtxa3QGS4s2Exah1MviI26CtKAvWmMG+S8wpYUwuln5kbcTvaXd9szhAbvZ+NStr6MyFs47PpOEsUJ++vMCJ7NTJkG+fNAzLyCBdh6FbJcLaTIKWwVlKGS7eb82NM1f8OUofiSeh6lYdONRWVrV//Hr19OLyv/dbGz+4Ei7cmv+xaJGZUusjz1Vu8JFAGpawUwJEe6SmR3C/hTpkpa0AkOf2EGtTKjErIx1257iyvbkdS0Yg0Sih8lmrQ+zOA3/pvHB3KnLwwublwM5vGSYQkGwCwQiAnzhuyKUTaoHx6oF0C22DPMirN8xW88yJitLOD3YCZLCfpXYq52O6eX6o9CNsZDnv6o39HpxAU3FCjwlQU/SdgS/8NL2yVeGO2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(478600001)(6506007)(38350700002)(316002)(956004)(8676002)(6666004)(6512007)(66946007)(6486002)(186003)(2616005)(26005)(66556008)(36756003)(8936002)(52116002)(2906002)(38100700002)(1076003)(5660300002)(83380400001)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJkojbdBHcNYdKVwgqqP1OcK5r/0Jhgo4Mybr/90yk7PZzjVIT3ax8/7FXTa?=
 =?us-ascii?Q?yBlK5W+4+AUPBn9oRzmd3OWUfl8dgCGpIyilVOunwYHgbjbZyFpscX1LBu5j?=
 =?us-ascii?Q?xyWbtC9z0tLZZHDP35AzvYxJOsN4ctdnJwCR9jEQiedzkYiiJpKdOloS22up?=
 =?us-ascii?Q?fYQ64xae02pyDeea9QULr5pinCwr++sYyyyDofZ9diPdJLEK6ig7nVPERqu8?=
 =?us-ascii?Q?rtPMHib3zPinbZMMlQ6RBoHET7uj3qiiX0BKJ2Xs5kEawrYIb8TZaQTcMIWU?=
 =?us-ascii?Q?2xYC/VOtsl4hn71PJfvWNVQPBIY6w7o9ryprz+ExwY+Ucg0jzmt/49CFy8XT?=
 =?us-ascii?Q?tBX/hA7a5IBp07SPLQ2pBUFMT3G5MIJYPRquuu+eupt9Pb3lqCT2qy0nGNbn?=
 =?us-ascii?Q?3aT81DOXF0UrwIXxO3Fl1FC7TOSUn/Y0WyO5xtswMtnQCdhEqvbtmIpBFiSf?=
 =?us-ascii?Q?mYDwy1xWpWLgszYkz6cWWIVknpFSO5uiInHD18KTvqqWp0/T9VFUbu8lDH+r?=
 =?us-ascii?Q?4CNS4TjrNWgf32sT6QFE4f8JGBN23fT35sJ/Lz1CqkiWjuYHLRp9zWbuuoMk?=
 =?us-ascii?Q?qhyscOPCtl0CkEIQG0/OPJQ1O/te04rEnk7IstDPmKI1gbXbZ8ck733MbqyO?=
 =?us-ascii?Q?VeZRNK7bkFK5ANntTPF+Kk+7arzIYpjqMvAyJt8C/Z5QCxGvTHHnMt6bI3q0?=
 =?us-ascii?Q?WPGMn3V4NZd+KYUsH5aaz4xcIyyUMwdEvL+smS044eHX9FwDFPaYz1AmVrcm?=
 =?us-ascii?Q?LoHh0ayuurFa6PiwEA2FiJ+2EV8OFn74WFylmk8jK0t0r5rtY8lDQeTWINpb?=
 =?us-ascii?Q?upjTJTHHqzMs9U16bZ9ZQRgUZiRM1Kj0blqyYu5fu6lAvyv84eIs/RgWstjO?=
 =?us-ascii?Q?k3M6eVBsmbwOTeZ7xtTEM/pDhfUx27GIN12GY71WEe1sDImWgavJ6P1Z1eeB?=
 =?us-ascii?Q?Uh6XJ6dbZnFN/TZPsVymoxLSj9wuvjHfbpyTzMk5WKLdoCKBTapDvM6bfih6?=
 =?us-ascii?Q?ehPT7QOqtpnWWqK+dXg7ub7gK4vAtdCXZicGOBQjNgmukAQImvJjattqaRrz?=
 =?us-ascii?Q?cWh8l/3+GbsEdaY+G2a3aNTMPcEeuizy2h9CQoIcO4USkxy51k558iQl1RdP?=
 =?us-ascii?Q?uTicCKTuyeALKjQ1uomaQH+8+FwB3bIDnrw4YwxcXrJSDq3NT7bICB5yq5+x?=
 =?us-ascii?Q?deeJ1Buc53j3BNBkKw194gqXMaNGSn4ispAe8Zfu2g965BocM9za5wi62H7C?=
 =?us-ascii?Q?+ykDWQqnnubq8NAITJ0tIWMP9xaYYF5kl5bWm8LaS4eB33VD9WplAMe8K/7O?=
 =?us-ascii?Q?UXbmRqirbdsOdT7diaGZpeHt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f48127-8bc3-4da5-8acd-08d942b20822
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:17:45.9451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDJtPAQSkpZIB6YyyIOjsktk2R9zlQzptqZtBmOju7ZtwWZUOzL3219O1ibMjXyUNTPLR6FSeMNqbQgf/hKm7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Both driver and dts have already used these clocks properties, so add the
missing clocks info.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 9b543789cd52..6754be1b91c4 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -39,6 +39,17 @@ Optional properties:
   tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
   For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
   per second interrupt associated with 1588 precision time protocol(PTP).
+- clocks: Phandles to input clocks.
+- clock-name: Should be the names of the clocks
+  - "ipg", for MAC ipg_clk_s, ipg_clk_mac_s that are for register accessing.
+  - "ahb", for MAC ipg_clk, ipg_clk_mac that are bus clock.
+  - "ptp"(option), for IEEE1588 timer clock that requires the clock.
+  - "enet_clk_ref"(option), for MAC transmit/receiver reference clock like
+    RGMII TXC clock or RMII reference clock. It depends on board design,
+    the clock is required if RGMII TXC and RMII reference clock source from
+    SOC internal PLL.
+  - "enet_out"(option), output clock for external device, like supply clock
+    for PHY. The clock is required if PHY clock source from SOC.
 
 Optional subnodes:
 - mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
-- 
2.17.1

