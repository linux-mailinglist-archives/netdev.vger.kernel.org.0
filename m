Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7587A2947D2
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440496AbgJUFYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:13 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:29223
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407460AbgJUFYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeTpdTTPPnb2rf+8Gqvx4ZVB1uQiuTGO1O657QkC/d7tIO+/0V6Gni389Ii1o+kG0PcvlL7eFrmd99+jGMALoxwWw2yDOgQxHg5RBgaxyZWIhk8Bl7Ti62JayPHrmIdKjDTyuMTp45SMUdqIIGbUJwKPcZVP8Aj2P3bv8EPkoqVyYQajeCixI5LDGynWDd1dD+BlUK6EFzbaPZtnfazZyKSl3BBTadjXi9fJnQ1uKQuJWPR8UYy3RStR3Jpv0htdVeHoopGbM4vRzWzaR0PSPgSYGqFAYlJEGhOjkhQvuosLpAzPjYytItvhhVznaHanaoqkvgbowik6+l4uU5oThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkDwRQQnDsJ6l4YhI6BNKWr2jPI/N3rQnuj4f1bPETo=;
 b=K2X/zur1TLv9lp1YQO9JNZQnFmt/O/f1EM3zRoog7sHX0YN6MTnSPkno+2EsSXt4lyNWi0ZCDcVBbi1IXHI++joPeGgG6bkbPqLO/8TUI78lQLEIJHYFkoMK/6czFCVRoBd7KVB3ZIXaT32dLSOSIsOSUOT47qzPNqJPR8T6DhcSdrm3o8JdWxy6JE0WXFZswm8+LOFWbBIM5YhCgDICCxafw4RcqCpwDZc6//LjBdvQLEGqvHtc9yKPnh7aMBtWDXmu1Lg5jAnJ2h1V5bCoAizl34S4ez5pELPSQi3jx6Z8gwH/GJn0ePaM2m86BE/YGxyngstE4CxCTz61lFfIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkDwRQQnDsJ6l4YhI6BNKWr2jPI/N3rQnuj4f1bPETo=;
 b=mok6cRxxYkyVGguYlg8P8Fmn4q7jLyk+KBob0IQggHF8oOjpfBKAv0uFQy0sPq+RNFg7zfXM4zV3KGRpXQKbAk+paFQH7yLXoxOGvQD/DN5BRoPU91cir+AsEDqXTQyMk7bOsg72pz6Kz4c7C9vC6rN7WcvwMdGI1n83FCPc3jk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:24:06 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:24:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 3/6] dt-bindings: can: flexcan: add fsl,scu-index property to indicate a resource
Date:   Wed, 21 Oct 2020 13:24:34 +0800
Message-Id: <20201021052437.3763-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:24:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9624453-d16b-4d6d-6f80-08d875818791
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB27263510657E6EC817853C3AE61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00tUj8ACUBG+r7did+GELwGECGzbI1TlR5GTHoRTFjAnD72We3kl8zr+u0Po6Poy5ZClqOiauAIayJT/0Xsq+eGEKe4GvJ456WqfJj806USCgiazICQJq7eB5sfml+ne6LKUtTFIvkKMuq3bpyJ9B2AYU4DzhUSRmv/xMCdwl2wPgFMM4BzZyFHZgB4iDdiDgFmECsLa53kQetf53ki1AS8HkUnvChDfe0Ipi5bKG0d3Ys9VgwG/55aAnCg+l3imNTkL129+2q8eVOEYpz8doRpXvzQLHtbQVUw8MC/Jm0bt6ETCZ6vTc1a1sGGuAlYtOv9vsJ5VVmqLE2wJ2/WYu9DGpRz1/YwtZKAK7zSaxAfYx2gZPOO6p7KQcfFpiGGB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(83380400001)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Pvy5U3Q+cJea0TLz+jCy0rvuxqljHE0zCLSD30Uxs5dPgm084DLi1eZxtgb61EqUarrWGslKWFpSscfeFYnjiiVjtWog8ni6LqjdhA4ZIsV1apw4SILQi5HFD0r3eCJlAmzhEU1K5ZyYFTJVBI+IDrdPgtrImstYwXFcRS+iVUpqQ2WdLRyrCTOCXuOFTtlEt71cHFH8OV8bo3hjhicvOERRo3IFH5ho91WL0EykEVsXV3Jht6OetzI8uDo5HL05PA4oS8J/YKeMjnIopnTIuGf+Wy67aiDfBW8uNzGEebd8w9dssOH0frIqnxMdyaeWx0Vu8Hod6KhGAk+bYQAOOgkXzETms18jx4lBXqLcMj15YTgUk8H/RJ9ls7hOmwTsvQyNeyHoePdZHecRUFQFC7coaYobTofHBUgrRARramBhBJD4bEKRqlLdveMnMYSBpEJ1gEjGi/Ykq5SCi05QbIOdbsEwsEI4o7n/+ehYeMXwk0m2Yc3vG6bKZ9CsluN2iKA00GcDnQdjTx1UXWEhou4VeEgWzHQoCj8FrzGrDqNSUKykdv0eXomT9wmEqU0tA5WPBRlsN2TIbAuvNJqwoN7vYWmqYtgxEH23yjAA1flLyhtUdio6n2AP1lAgBMFyf86fQ9Vlt8PGxFal4+KK2w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9624453-d16b-4d6d-6f80-08d875818791
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:24:06.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tc09uBXldo6shVoGQHcTljhzyF6iC6alTM5VhcsAiAX7rKzCHIJEi765X7Sh692Mb5js00hrJeMN4HZTX76mPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SoCs with SCU support, need setup stop mode via SCU firmware,
so this property can help indicate a resource in SCU firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index 6af67f5e581c..38a7da4fef3f 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -43,6 +43,11 @@ Optional properties:
 		  0: clock source 0 (oscillator clock)
 		  1: clock source 1 (peripheral clock)
 
+- fsl,scu-index: The scu index of CAN instance.
+                 For SoCs with SCU support, need setup stop mode via SCU firmware,
+                 so this property can help indicate a resource. It supports up to
+                 3 CAN instances now, so the value should be 0, 1, or 2.
+
 - wakeup-source: enable CAN remote wakeup
 
 Example:
@@ -54,4 +59,5 @@ Example:
 		interrupt-parent = <&mpic>;
 		clock-frequency = <200000000>; // filled in by bootloader
 		fsl,clk-source = /bits/ 8 <0>; // select clock source 0 for PE
+		fsl,scu-index = /bits/ 8 <1>; // the second CAN instance
 	};
-- 
2.17.1

