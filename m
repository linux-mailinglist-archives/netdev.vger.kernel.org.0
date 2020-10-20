Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB61E29363B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405616AbgJTHyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:36 -0400
Received: from mail-eopbgr30084.outbound.protection.outlook.com ([40.107.3.84]:61051
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729928AbgJTHyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvHZXQ3FnMCGollJVZERhb9c3Z1Mejh9ttOjrTMG7H9geJANCCIgkAqgyAnTauPP7nMgxhbkqVIYkDOfYVTrHNQFgfHdRqxuMVaCL4mP7OG76AatTRxsJYckvdJtIB8lXLTaCIKWquEkgCRhZWuo+cZzAWa2SE2Ri9UykrmNdk5iGMXiqHt9I1ZoZjslipyr0zFQ4lNhecIJ1WZazYCu6pHWjKlhpUgdRHgWC9YaP+vzHbDlfOf/V3gFzATyOk/VqkNXqxiamnrAKy8o1Ba5hWT3lvEUnxgUDK3MNNcJj17CWDqEyjJ87DgalTPCsZ87EzHBQ8NKm/EpsYVX0dne9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkDwRQQnDsJ6l4YhI6BNKWr2jPI/N3rQnuj4f1bPETo=;
 b=dYoQ8EVYqHqkZte2xrlO5toQAzoPe4LHA51LUF1gpGVUXiLIzCFWS5gyXcpJ3SyJtCFBmLD3H1rq8d6jj1nqgS+v2eQUdHNhDDeD3Uyh0W6M4XtZJEhqEYRcLE8Lv1qrieWSfaKyEv0RyYZcNsGC720yxYqYhUY/xSehKv8L1aFPORbxWApe8TDhXYleWgCfDPLadUKEGIRIWR90FCIMFo/YPsikmPUQWQPMszp49K9K6yWYEtJZgIXiNfteqOtQ3yG94DHBTkULnWfX6MLb+2fWR/IROjLjOYl0Ic6B2ZjgFQAR0PDIwMlFtwAmqeHnTzbhUl8+sCYRldJM4CpCfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkDwRQQnDsJ6l4YhI6BNKWr2jPI/N3rQnuj4f1bPETo=;
 b=LrahR1eXPY4lwNdoALTD8XYwmuosuqLdT1W8pq8zEeVte26DZwgyH2ckKq8qmVc36YtW8zZrleObu5rWcg/hrm1u05pP0AKhG6nP1Kef7oGoydxF5v7ez34NdT4ZNoqHdiL6spSGdaDUQ1A302y1d0n5K+2WWAzkAkJEUNWgKOg=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4106.eurprd04.prod.outlook.com (2603:10a6:5:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 20 Oct
 2020 07:54:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 07/10] dt-bindings: can: flexcan: add fsl,scu-index property to indicate a resource
Date:   Tue, 20 Oct 2020 23:53:59 +0800
Message-Id: <20201020155402.30318-8-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bf74e246-27dc-4920-b8f4-08d874cd6188
X-MS-TrafficTypeDiagnostic: DB7PR04MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB410697ED8B2DD83D14FEDFD9E61F0@DB7PR04MB4106.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30Z+B2OKauYl6pIrVOk9vRNtDK5xuHKgZHTCexUpCcEWTYKxxFHnBlXfrQMdOGPOrNFTM3ilL4DeFINaCZkBKDVQ/fCp0RItVIe0ry/RwKR4nbBj6Nwg/lb+iSRAa1frzrOSeWqLzcUrSveFfi496dr0CgJcSScRKH9fDigPALG7SrESpcyr8FzOtnr8bdBD69LRPuYhnPjbN/cj83CYntHZIxcJrbpEwMgbjlCeU3LCBrbvZDH2ygZ519DPQfLQCPt3Q3lFrvSKsZb+TMrbITF4YGKzfRw7SHGwVyTCEq2zdwf9YK4KNIybGaSaY7Sf3jTlmvf/21+1+ietUyr3mKIjNmfbBxznF6bm5dCHbTNHc27tHYOaqZkK+uZ/BQeb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(36756003)(6512007)(2906002)(69590400008)(83380400001)(956004)(2616005)(6666004)(5660300002)(66556008)(66476007)(66946007)(1076003)(16526019)(26005)(186003)(316002)(478600001)(6486002)(8676002)(6506007)(86362001)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zMVuOQwCOn0s0jidy2YtP91moacFek0tw5pntbdjMSEhrOBOUFkDuvKggGZAIQpxvQ0OxOtTvqIU0T66ubr5pxpKP933ZlU2q7CRn4JJTSkDlzscmFu3rYqtwgcFmyIDdEXvmX/gIVt08R817hfRFrEDJqc/VdfSxjIzsPI6nASAUNhB5Gvp53lTf+fmpJYN5rO1fu5D3ExLOqbafbegNqovd9JOv87vMqMWnAM3zmTXmQ0g3qyz3d3zo4RC7Y9ErkvgJqS8yNiRZEVDT+UwMQzbhvSRu1TGYwGT28D5cDL30MQmoKfap62hNOEx25F+1KdjxhxNMUgbgPz2E4ZOmuJcGuH8BtmIlfdETsLaidaUo9NIdZPEZ3gguWYROZFPipaEQnALGJPTRSulm+rAg+ODWDNAR+3EfGfOM2Lyhee2aMtBuPYBRUhDnVVHnHdgo3yuWRe4w/5R3hOZNxblfv+MKKxVxY5U5sQ7HydVG4wmfdmgGNJQw4JKqcVoFkNdJw9Xc8kv67VgZ6NcPBHWsBlhDKyAcFszqkg930+hd8tP7GCiteO8UIbCBfBEzkSjRLlq7okj60dumf5UjPw94zSuZx7allI9zNgSEAq6itDgl/JynB/9f/Zuc88uKPXaqkN800nqE0T4b5UHAcjMCw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf74e246-27dc-4920-b8f4-08d874cd6188
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:32.9449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Swx3v32AgWpEsj3NL8hLts8HaW+fppqohk9aLzgY7i+fPIrM5iXtM1msz6zyzy2XCeuepy2DNlKv+Jy6GgBQ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4106
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

