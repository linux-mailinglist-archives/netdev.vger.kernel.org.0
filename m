Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EF83C2046
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhGIH4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:56:46 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:29654
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231343AbhGIH4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:56:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ym7P7uUGk1sNzr1aiZ506+yBOzamlgECg+gWMgaFA2dEq98BMhTfEHKbWs5hM8f/BjaM15/sPzAuBetEQi0vhKiVnKHHO/bN0TsKZz60hfWnDAQDvXAkdH/Y4Od1k7Af2WiRV0DjwmBMnRbkJ6yzJiUq5NPbASoCfD6fAHhgStXxLLBVrotCTcGxJkFeiNdb+EDXNAlez34BInfv6HNit1rxx9Vq1lln//ibHQh6eJnTqMcgKtgh1gL1aF41ZiTZl+zmtoNScFrhKfloWZFU1rW3G6B1p7cPt/obI/UTIux2uxjAR9zdte/GacNiZGoD6m8W2rT1GnYuSHAHhPg4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lO0bExdu8zoU/hgPi2gIotbXHcsLGPC1XQ+LkxG4bM=;
 b=nXifYoIx+j/P7ZC5Juj+brVcqDfvvU1UgD6daG1u8s84bzrDYktuVUb5fllJk9Rp+BDwcuC/fPppr7TSlPmW/7lbHSO+IeeMNLXWFT3cpaNkkmqab0mwkGzh3VTlkqtIKzr6klZ4DtGF/usmUktX612OkYI3EPyhmBSmgCGJPd1GaOB1/QdWun6uWvnflkrHqzL2E39K5OfH76ZIdOK2TSbGoSg4wgYoWOpMu01w9w/SXZLaaCVV4GHe9Ae1y/NYK44/dtY5eI1RDIAr1+I8b92VSDxKPUCBbtCbu04hWnHeYhUuT1yUlVADZNY/KL96DuJFTQEcRFjanvtcmew2xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lO0bExdu8zoU/hgPi2gIotbXHcsLGPC1XQ+LkxG4bM=;
 b=AL4inryfo5MtTK1yTvQ5dFHbc69VDFGO1OM5M/suj2KKlnDObDJmC2XZhzvOJcSIQyufYZCIXY0DOaRFurvyq5KOJeWfcipG0C9tKgXhEdyMWXZm0fzZ+qM5PFl1fSQ0DvJvTF2+vEJ8BSlyTLyv/Y73EtjkGqS+UqzTJnuLt5E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2502.eurprd04.prod.outlook.com (2603:10a6:4:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 07:54:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 07:54:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 1/5] dt-bindings: fec: add the missing clocks properties
Date:   Fri,  9 Jul 2021 15:53:51 +0800
Message-Id: <20210709075355.27218-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0147.apcprd06.prod.outlook.com
 (2603:1096:1:1f::25) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0147.apcprd06.prod.outlook.com (2603:1096:1:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 07:53:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7e27411-49ef-4aa5-8a9e-08d942aeb6a8
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2502B7FA971708A18C6FB299E6189@DB6PR0401MB2502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4hFcmfIYbcuiceF6LenkUqPOnmxH0bGYRaDbJ7NfBRIQs0M8w//vmDxANq4YiZuGiu+8dUGliCg50ePna+Y4UBWWtoTjkiPjGCowOsOwQKCO2y7Cxc04qjj74jULXgiIwb7vMaGecrgW/TIHzA7sjz0ewdQfIcERsrLJpUlMduIYcCEYHxG+jrS7ivLqkO7H4nPOdqxyg3N400p9P8czZkU8VD4K6WrmGg2WC0D8LwlF2HDuWvRggOb6LwDNRG9ZjueQCwRUKfqV0gfv2bd8VTtx1cfi6swOr2p9tdtJJivY54Fsp0zixg8PdBE0HgNt47BImTdYXDjsjg2mpcWZAAwlOXry8vLkw2LSDq/t2kMrQJc7Kb/oAZWLeqKCwFuCup8eE2hSRRxI/JeKkdmmwnFeu8+RY02cuHP0bvUGJrdU0f82vEQPf/BUCYuL5EmkTMD3hE64+VrNijqbGKF+T+YUh8dCY63rFUezdVw28rQwhU3xwvY44UUwXLJgkPrEHE8DrikVfGKWyJ4UIhS+SJtnWb0qt3itHVsDc99TDmh9cGTDhroa2Qv7XpMY5hDU2lAHT6hD3DuyvTq6eseZzJ77/+qYTZNWDOL/lU7lbi1yBxIBguyy1QRZiVkt3o9Svg0x8AYapsD3mIeh+ArB6krNqwbqFuEdbjglAzjOe7nl4LDpO5GDyNW7W0CXY99GFnFSR1waph8gbLYZ7lxpxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(956004)(8676002)(86362001)(2906002)(6512007)(1076003)(8936002)(83380400001)(6486002)(4326008)(36756003)(2616005)(5660300002)(6666004)(38350700002)(316002)(66946007)(66476007)(38100700002)(52116002)(6506007)(66556008)(478600001)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?puS214lZmU/hgNspzKICIdybPTk0fIzejCPblfJRewV1/Q56/2+jC6dDpL+m?=
 =?us-ascii?Q?gbap8pGT/eKzLNTpHkv3SG0wqNQCASoT1plpsgSPqBf6FMELHrp/kP54JymZ?=
 =?us-ascii?Q?H8F40X3Vng5BMRh/Pl4dqxNivNZkkb0L6JKg47KJeESMkq4KjdB0Whm3vu6T?=
 =?us-ascii?Q?Vk/mOnJn5OmUipDJkWq0W1geu48tQnECE1/P16Fks9j+0aCalVpckOGG3SPE?=
 =?us-ascii?Q?DMY+LvhUt+xWLO8cgElLe+tAW6wUs1zZDnfgGH4UnSD1cW637hVv7A0A+Q/+?=
 =?us-ascii?Q?g+JIcx9ontMYayL49m5sG9quqRz1Vkl+dw4NGqwdFDAL/AlRn62thg6DnH4E?=
 =?us-ascii?Q?FAWpcHRPYKbuQtitk5effYfaMi1VAKoetWsnUgol4zQJyhK2scFid761KUSD?=
 =?us-ascii?Q?uIg/vNo5RgyAovpXLFsdDOUI9YUgaL6CVg4KgG0qgHyDbK07y23gcBCTAH8i?=
 =?us-ascii?Q?mOtPj19nNJh5BM7TGfuSfcbYH3QKoadWOZhwPgB793aVerZqmpuEb8qe0xLG?=
 =?us-ascii?Q?DGzFOFYd8BMaVF86AfubDsdcBYtLiQbeyALOQOtH2KT+XUE9zusgYgv3rCd3?=
 =?us-ascii?Q?BPhPTA2QgCQyX6n8I9bkY3wAL/AaH27xrLJ3E2Thw4p7SwcbKXULqwcE9yB5?=
 =?us-ascii?Q?gibDY+RXgKj27Rw9XMnBa8I00hczxZwTBuetL4TBcfd7JHSklpvKo3447uYK?=
 =?us-ascii?Q?5UXcUxrzoZo8bRdHCESuDA0d2v+5sCnUOeQ9dhL2JVaUvLopv4JG/XZYVtKR?=
 =?us-ascii?Q?fk8/A08KbwdOxu6ZbuNbnF1hBBj/CwZH/VlA58JI/7i0ZzvA0C2JQU46mue9?=
 =?us-ascii?Q?zUTZYftXzv8JGEgJS8O9Lwxpn0Kn1lEcr6pY0w7d+hhoBd5T1vo5C0KTUerE?=
 =?us-ascii?Q?wsCOr0KEcxY/5ZkoSACLMWGYC9tA/UEWEBVIqyA7bO4DH9Sb7O31xDG31cGo?=
 =?us-ascii?Q?9eUHTU3TnaLgvHyz7UcyyPm1pDDtlo7oGkhTTtE70HxMiRT0t4BqQsOVLQ3T?=
 =?us-ascii?Q?/fcMvLunBevjl8znOGBRtmK5enJQIv71g+XLN+egZ82XzRS3V/EVbNYFLlwc?=
 =?us-ascii?Q?VAmptrkhDIqewNBtqQGMgYvOqnKh3huIMsdJn+JOCg7Rss0ZAeqoubUokp+6?=
 =?us-ascii?Q?5VPyzymjyfep7QA2WWoxziE37Jb3MSIh+eNiBi4omOLLphQL935ly9W4czHR?=
 =?us-ascii?Q?ppDFpCZS8hB0G975Lm0UmSAB9qNDxkCwmiCYUfVTybRSXObp2hY7DnlxJs3a?=
 =?us-ascii?Q?Fe6Jp7j8DDGTSluiIZng8hqtlj4eYHqMX61NdNCpl2OrlLD7IARvwK8S88xv?=
 =?us-ascii?Q?ho1sswZHl0QD4g1tdJqUA0YL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e27411-49ef-4aa5-8a9e-08d942aeb6a8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 07:54:00.7619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFQxxa5zWtkTt7FWxncaQ0/1KeDQXI1fpseiVrguwyxpHE29MRLDBUfv8vrMeikWsF6uVclE3WYZFPlz2EW3Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2502
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

