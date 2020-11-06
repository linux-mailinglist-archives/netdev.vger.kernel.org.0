Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9F92A94DD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgKFK4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:56:21 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:41045
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727153AbgKFK4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 05:56:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKbeh3YpKMUnsO9k451CyrLHgWgM333m48H6cPPWtcyT/dGXykeI9XLDDEhaE7RSg8lvw9m8E3zKuRoaG/Ou3OP5Zed7vT4yiea6nQfQkS9m/lehhfcDZ4GFsEKjylJ2PxQVERfM4BK3RC6svnjouPhqF+nLSmdOrMNBKCddlVK34yNmGKAus+dbsLn6pbZIFSJyrRfVQenV5vZOFAL7uqaVmTbgMHQ8LODd3yxRLV4jpx5MR7AyD1CCea1kXNnEWEAWhkH/6zCJduu0dGQ0FBxBinxZncyOvU2AauQ7e6ku3gqKf4avfFyUTnevCy5zg1xtSvgS9ox5Xexg7RKYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQnydRfZnn2tiZPlhxcKVX9s3J7j8WqDBnvzUHKFAd4=;
 b=W4ceUwRDIqbAoxs6k+fgxeQI5Qxb3tAk1Py8xV9sQdwzJUa5kdTH0Lb4XILyUSWkgym7hew9fHyIyyfYi2dGrTO/w0wbBje6Q8Z9iXDXQsUTZ5CES+LE4RZKizougLsm9d5mFEG0XeZGHCKydS4W0BbHibXIJcn8piF/Uq52myaPDlx80mDzFADGrARNxjm8V1+Gk90ne/Pj2yNShEITm8TY62MNRFjZXSj69S2vV66nv0aFfP6GVjoIu5S7XIbS0xIJHxv563dtXbR3v9aSqb83Mls3CinV4DRHcUrrnacAq30Pv5uHYLDj1GaRG4bLfXLll1iR18wKUC+N+nR5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQnydRfZnn2tiZPlhxcKVX9s3J7j8WqDBnvzUHKFAd4=;
 b=Ggo4y0KvhBQ7u4Hj6Nf6+eLrGImyvDxaR2MX2Tzx60lM8+BHLIXu4MwD1ULZ3hLata5pefDIg/+KPKjyMon/m4Dc97pPtzAO+8pJRTs/6os1LnLaZ0oWAL6NBRiuzOTTPASMh2r4ZBGG1Bv/Uz8wLwJNzv8BTYtd50dm2pHQA9Q=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 10:56:10 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 10:56:10 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 2/5] dt-bindings: can: flexcan: add fsl,scu-index property to indicate a resource
Date:   Fri,  6 Nov 2020 18:56:24 +0800
Message-Id: <20201106105627.31061-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
References: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 10:56:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22775c51-61c0-4668-8b2c-08d88242923a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB428288E9E49FA3A49B35D035E6ED0@DB7PR04MB4282.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMfLkmgQ13Q24vSbBuRPguoYcJvaN2+LFrLLMw81wWyQgi/7r2AAu93xv/OUskPnxgJ6pC7h9aVL+XsPnRgU8Fe4fvxmYGVm5Uwrscx61QUnfGpn1fJvaNjMfb02adWfLkmjSvKsk9p4XenUBn/sOGCqb4/AqdbdFDL6Od+1w9Yy5N1PwebKGAoxt9d2z7EVy0MgiJ+dvc/HJa2+DMCkPfszS8nn34u6e58pebMvhQ8WesBzw5kKcZyzZYv9MMnW90HS3VKZkfJBOdwJM/soDWo2iyLJM8XyxXLyMc+2w1NZXF6xNRCDAye43lG7pZXUBH9LtXITotL6Ay6ZCjapTbDFlPNByho1xaYjBDWWEcRF0uxBIm+PPlKU9gnYnWiQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6486002)(5660300002)(478600001)(6666004)(26005)(4326008)(83380400001)(6506007)(956004)(36756003)(66476007)(66946007)(8676002)(69590400008)(52116002)(6512007)(86362001)(186003)(1076003)(2906002)(2616005)(8936002)(16526019)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /FolAIcXqN9/iPVeQ3FV/Zs/8k1YkkfWtrkJFhi7hPZnWyEMllMwUuK2otC7wfTQWa++15fXUQWD2AUHZMEA3iYXaYNFEzVtAy0THPLUJHi1w8apS7NcrJspsVCG6aFAPfsclmS22HoKSh1KI4IDMQowsy2mjVg7f62YA0OAa+M/Bww+ADMJw4ltR14R7EFbUA55EOBMtEE5BkFO8HSgxwy0tSmpXf6C8W81+zcOySE5A4sZwg+Xqkf8CJhPWS5IQTBnr8Y3GRhveUeOVIzf/+x5GxbL3Pm93M7o0b6LamQ9lHmQqVr8p3WBYXQcY6UZt+2gj9yEUzf0yfl1mDY7tjqIydOZQ/SO/zA23T1zK83yXG7YuqJtU46H6csFe+iKXCTSSmGaES4EA9ClwRc7kF5K4p3iMiw3MTZR1r0let6rz+4+JF0GvVUmSPucD9ukUJfkLcZrkrSg4hIc0LlsfarjVnzNe0/Pb7ksR43TKdF31hj7MqqJn2uuOkAWVWB5PF+8DlchwULndZvDnrFH0k7a7FzviFjgjYoAoqP77NH+EDgvaUs/PSt9FDdPloIMDfvuiGMe9QLwqt92p8MULuUYr4ivOmDC65UJUXUu+uXMaiMqHs4M9TpsMk5UGiK0DEEq4YBvctc3Gejja8APTg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22775c51-61c0-4668-8b2c-08d88242923a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 10:56:10.8804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XT3embq3a+hvripFXSLbOwNewc3Z3NmKoiXGxXEjrEoApcpM1DGOGRn5aUX5655VZw3ppnrOnTtzl0a6UmDSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SoCs with SCU support, need setup stop mode via SCU firmware,
so this property can help indicate a resource in SCU firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../devicetree/bindings/net/can/fsl,flexcan.yaml      | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 8f4db883e16b..2631dad8f85f 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -105,6 +105,16 @@ properties:
     description:
       Enable CAN remote wakeup.
 
+  fsl,scu-index:
+    description: |
+      The scu index of CAN instance.
+      For SoCs with SCU support, need setup stop mode via SCU firmware, so this
+      property can help indicate a resource. It supports up to 3 CAN instances
+      now.
+    $ref: /schemas/types.yaml#/definitions/uint8
+    minimum: 0
+    maximum: 2
+
 required:
   - compatible
   - reg
@@ -132,4 +142,5 @@ examples:
         clocks = <&clks 1>, <&clks 2>;
         clock-names = "ipg", "per";
         fsl,stop-mode = <&gpr 0x34 28>;
+        fsl,scu-index = /bits/ 8 <1>;
     };
-- 
2.17.1

