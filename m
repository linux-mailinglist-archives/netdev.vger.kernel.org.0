Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C8F28FDB6
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390146AbgJPFnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:43:19 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:33504
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389786AbgJPFnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:43:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNP+uSgk5wIpUfVPlK19fK8poI8c2Dn7BC2YmnvP0xv1jWpnKY6KkvzKaZc1Vr8W0IIMp9r9zPzKrPTYWAzG//pnUlUkm3MdsOLIK5SuwnyR7+RKwvy6s+hMbwPdQ2VP/9q6wefvBczpS6/C4fwKY6bT/pd80AjJwRO1LTwphD5jQ+sJP6z1I5dbjK5Nr3axhK8A5a80EBZjv9mcubDJoW766/bdAoijxuYeG4UnG/3n2wvxovrsD7bGTZGqzt3vujchH/5RHTszu8dAn9NGtMl5si68guq1t0HD8ZV2Gsf+wbaXdBViJEBEx4LH5J5CGEpye+zMGvlCNLxelOiBqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hS+++hXzQHOHWS1Go95Fv0Zz3XGkSwcC+5QAcYja7Nk=;
 b=S/8zmr0osnrw1RUqGbjsv0sxGz/bma0epBdsfLEvr9vgSx7X4Cot/YCJdubIkaP90mPS+yt+91qhHum+hGIf2DwDoldk4MtAMjg9TtSjW4yWXhlokioCFaLza6aaDgz8miId0cwsa2GkVN8HiQKmO2hK0E046pyK2Fjlt3oEWEmbHldQXiKfY+vfdQycsdvaAT/poXQYWLscJ2KTmZst50gbHvYq4CqAHyHNYxXVf0WcvPFO5kQRA5ZF4bNkW2XuvwsmEyvIjylZbqzCYV9t/998DepyfRfeurySc8spue8HYSK2hdjFI0Rj6kVtbqJI3RvDHt9HUScHuIJ7aFHwcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hS+++hXzQHOHWS1Go95Fv0Zz3XGkSwcC+5QAcYja7Nk=;
 b=DtsWcDp87uyZ4h8FHMzLSol9hfybdpCk07QG0ubRfFJYMDP9nZpOQsAm7IqesT7PbJpwh0uQT3VMUmakj2ciL7g1/9FdBLR+KB6JgSVzox/1XXBSZ576oz9Qxgq0BIUzjXwmTJ5Y3GnJYMAnEWaZyBZmphF7vvLTU2LvE9UHGm8=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:43:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:43:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] dt-bindings: can: flexcan: add fsl,can-index property to indicate a resource
Date:   Fri, 16 Oct 2020 21:43:17 +0800
Message-Id: <20201016134320.20321-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:43:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4405f036-5568-473a-170b-08d871965ce4
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73335ADBF3E126795223E629E6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +3iDj8LMJMxLEFw4x97/vgiL4zNHPxWbx6IdX9roFjUXkS3IZLABGtmIe0Y/YQA9jGs/MxBIgJPUj/E5Y1d8wlDjeda4tsMtlAKJis6mtvKjBNQa+PbCGdX5alg+WbTxp/+2kh4AsPrzlTYyfAn7U8w+7CaCAK1qtFKjR4u4DYF7Au+dxverCjybuTAukJkavC69fYY+xSyoS8/AI20KzCxBeqy6bBe+wQCRpZh/UuukTAsBjjqurA2uw4nCIDXX28E968Fw1liga0znqBVYSSGiHPBO5G3BkBgMC66ZnUjCcLbzg4iUsWZ8sIExp0BkiHSV0V9pGIPPc05nMhUDH4CRB9YFTRDYO5hDTy8zZYOkdeU/J/O4ZFfydAX//QCgBBXlPdfXv58pNHwPkprcKn/HXcPpwJP5NKif2qSkruU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(6666004)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lHwFkqt8u6vbduuO9aAkEiUCaNeaqwCpTM+aMPVXmgQFzOLmC70gjCGdIQHfN3hsz4qUiPTJiVJ9W2MXerk92i9KaOfJMbynA6I9pbBqSKrnC24C6UchuSx5FxadZUOMFmJsa77xSHq9p/Ee80bh4hEG1F8iL3ZUm2E5ilEnKBOZHux2SgKeAGT9hCEVbm7Noc/Wmx+UonYHqgF0P0Rh3fOdey7GopQMSjyszLkglC7DwoQQe99c/6g/JzRe6H1Gc8/KwH6eX0jqwhVM3gtaUM2L0s8YdqPk2fsL5de7HRCv1IjNh03ZopCLcPbaPDSNgDLGMku1mzhkMgGfCB4pukuiAkyribuGzWRIUVEdgqfLuB+fnNHDKidScO042wx/2LT6Dwotn3wozLeyXrlqp1t+SCpt2kzyc8JvI9ZZTXSvULywRzNr4sZgXLl8OI2q4we3+QhmLt0Vv/A9g9E36idJMP+ndQpOjPuoVwmiYEV2e0Hi9aKX0fax3M1CmWgoqlPf8tmPiUKdRtO9TUYh/ll8omLJbmTjs5nKRjcZa0HXVRPoSvc7nXHlrU95rQLLuIIeuzbnY2dI1mp1mzkVKDL+Jf4oBNf2MerDKuMSuRIiMtIbDY43FpfMebblZu4Q2T2I8NXM89qgpyc5dDpS9w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4405f036-5568-473a-170b-08d871965ce4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:43:09.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWCtVDDwrDmg3hyzWQp/lWQL1ZTPCnHpqhdTh1uLv7DDBbGd3IadL4/Pxt6eL7Y8oLUR4kKaNfRnXqR0tC2Tzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SoCs with SCU support, need setup stop mode via SCU firmware,
so this property can help indicate a resource.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index 6af67f5e581c..839c0c0064a2 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -43,6 +43,10 @@ Optional properties:
 		  0: clock source 0 (oscillator clock)
 		  1: clock source 1 (peripheral clock)
 
+- fsl,can-index: The index of CAN instance.
+                 For SoCs with SCU support, need setup stop mode via SCU firmware,
+                 so this property can help indicate a resource.
+
 - wakeup-source: enable CAN remote wakeup
 
 Example:
@@ -54,4 +58,5 @@ Example:
 		interrupt-parent = <&mpic>;
 		clock-frequency = <200000000>; // filled in by bootloader
 		fsl,clk-source = /bits/ 8 <0>; // select clock source 0 for PE
+		fsl,can-index = /bits/ 8 <1>; // the second CAN instance
 	};
-- 
2.17.1

