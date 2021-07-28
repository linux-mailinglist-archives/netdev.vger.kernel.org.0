Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8062C3D8D1C
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhG1LwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:07 -0400
Received: from mail-vi1eur05on2086.outbound.protection.outlook.com ([40.107.21.86]:51169
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236166AbhG1LwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMrM9MiH3mf6yqDOqN3aHoAEEwgkV2HYQQuo18Pki/SHtls2bJZhizhrvvbgtnPD9WDWEesCPPJIgtbCK6bQO9N2kIbbad4iyDjp2w7vgZi1U6WCq4b/vAFJb3f5hTrzEtQrLzFVSaDU+W8TTnKDkNDWhhZehr23CqFstZLXvclPCYzAbArALuuEkB9MQm1W0V9i011odALgOxE6D4WadTuz4kTMYAs7RCq9sfAvAw/OWmUvMWdjMV7Kq5DEXnuAOoVUHn4NpumKhR/g/gGoZya2Th0JDWplNGTue4mAwaOvugsiX1PtqkmRFxDRkDOKszo5z+w1niNNz2JdFXxRGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7hMmrIp9wyAjTpv/IQ+j8xSwqZUGeIZkLUIZawBDws=;
 b=JiRODIYGD7YjqO0q3E45+IraM3lEbDZywOFS+CaysChnzUB7SWG104f17SGL1H9uC6lBrq2mHdAwNAz1uuZ8aVu7FuAS5hASZEX7vKFJAyyPFvrZSLUuYOt4rZeHqKARy0Bsey50IKmL+MW/px1E/lb8XB6Iqw8fqHBRc7Nj5KnzBs0wMxSA/f9shXb8lsn2T7R6cHW1404pQG32cIZI01+/OWerFVDNSPCLllhHq8nlryEsjqxVHmZ3mTE6owf0n5PfpSLFer72xxXgqm/M2SOg8Mtg2gG9qsgl8GZ7B8nDJgD+evOgEKPyJQ15q2bXU2oGMpqE064Q3hwyZFLxJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7hMmrIp9wyAjTpv/IQ+j8xSwqZUGeIZkLUIZawBDws=;
 b=INw2dr8f7ymrjJNSJwGfKF3dy+IjYADhXDZo+Ehgt1igtCrLn5WXXKDRQgHlvTaEhw3bZy++5Zf5ExfrE9u1dtBo6X90ueqkCVfW8lNEXKBbiPvfbHlGpUBIi1wWqm+a6h78XgcnrkHpAlxby7NFcEpHHUovOENx2Lw18EnCrS0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 11:52:01 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:52:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 2/7] dt-bindings: net: fsl,fec: add RGMII internal clock delay
Date:   Wed, 28 Jul 2021 19:51:58 +0800
Message-Id: <20210728115203.16263-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:51:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 874a973a-c711-43b0-1dcf-08d951be1c60
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB30948CD33E897556C0BEFF8AE6EA9@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOnuUn7RIVv95ANtG6VEUM+iRb56Rho6a2XfCiA1++qc5EEwkW18JNA2xC9aevXTnFgMJchGaZ5SEe+gNVmyq/68S30KpKuTQiNF04DBnioEczM+14/sd6WsJWssrcq8mor2Cmx1ZYqWZ1MFyQRjPGaB93v9tEukBviWIoFp9WsAGlfjKrZ5fWNu3XdsTsLLZHSKhHAbzNlTy3giqPlVt7/FPyVaH8wfr0BI+ENYwbK7r2U7w3Ag34gIvi4dDcJHyDT+2/gpAEm4ZFHYYLje09LdM1XRa4NEM8fU9TDSB3ePm8oeOaGHms7li0YeaFIPwW1wshdo46pCiLsD2+kovP6/GphQoH+LWZKPeHnjnolTqN7u/1U3cMHu/I/JLXc14BhvgJQ86VjdUC2/Vid6MiZJaplZxOP7pI8z690hr7ESvxzRiUBsQz6mBt17UAMUUo0VCrvREAuGf3YBPzCGa3jcaEDpsqIN5oC0ZB9DLrqq5sebAm0MTJ6gkF+CtKCQUqDCdMWRCHbnW29M+XXy9pr5K7euXeNkD5Ll5mUFnxShPur6PDfnBINujntILK89lAvEqasObgdHz+lYVJbeAL92Jx97YSindn9Npr8sOV1FcQ0N1ab8nHVtUdykcA93fTriSGEUgLCCtyBJ+oCc92GfHldRJ8MAw9e8vD/CfeRvOu5xV75Q+wv6Y3MH83pkNQ7XAo0Y70sXpTPRCuMXTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(6512007)(7416002)(26005)(2906002)(6486002)(66946007)(66476007)(66556008)(8676002)(1076003)(6506007)(478600001)(38350700002)(38100700002)(186003)(5660300002)(2616005)(956004)(36756003)(86362001)(316002)(52116002)(83380400001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z0VWM+4gkXawAtewOH5A2kexwHx0fm6FM4dV/JQvtNfwKQ5s7ueF5FTBtcB3?=
 =?us-ascii?Q?6wKc/qjT6ouDq9Yy7u/Ir8qbUBs9L7lZPEtszlpFElh9b6EyGJfxa9QWBvin?=
 =?us-ascii?Q?HX/A8R0rpev8arvpr69Y6mrK/tqFKl7Xgy9zYtMDo3UEJjGcW3z/nfnByU1Y?=
 =?us-ascii?Q?qXp6I1fqYjnVXbF1L9uiBo1Rr4+b/CGvn+Ng3btifQWY4r7nZRVGyvG2s2vt?=
 =?us-ascii?Q?aTy5SrDXhLKC7pORb2UtKhr2wJ+WTyoc/emYNRewO9mh6sfVgAFNPBYRmjua?=
 =?us-ascii?Q?ZEVmfvBqJ3h5/Gvar1eAs3AvioqxOPMA/rLIAG7w74ZrAGuxWWN6iWF59UTD?=
 =?us-ascii?Q?Ql2sFr9qg16wIDGsVGFzqvmEhc1Ahfuh/G+Pml4STwDdPDdjDOdVU6TivyNy?=
 =?us-ascii?Q?3JdxGXwgYj7ZhLffdQgjg7NanWoDfWdWfaHaF5C0sifWz8aUxzKm3GsPmb+o?=
 =?us-ascii?Q?nWoXN0nz7Zc1vYoeyUMnYHOtLCyFZt599jVooztg4l2NBvcdWaOEMA7gyrCw?=
 =?us-ascii?Q?wwneSuNXCsZsyl5DicqV+Trt48ggsw6oF5ABNMqeDhDFyf7vvQ8R7270gKfn?=
 =?us-ascii?Q?O63uFfmp33URqqempCNgS896hOMkBRVtSsYZV3fPxV12eqL1FvIeWkEjxjw3?=
 =?us-ascii?Q?EzNpte3pQEImD/RBuxK6lPyusD4HF/7JQYZyBnBDlGTYROC+UaEPs5CsGQJf?=
 =?us-ascii?Q?fXrDTE7wHj1HgqRf9HBPN9zTQb5kkntdn5YWZRXmmDEUCGUrHZ9Xg2rmR2Cp?=
 =?us-ascii?Q?XS/AHumxCoBkRJ2a1DB+sS69Y3FcRnuelsic8XyEUBQt4iV+quGu47M+0L6O?=
 =?us-ascii?Q?6XFtlPOmu6tizJseFekuEyf3LrTV60pW1OKI9uBMmx3mV8vFio46q9vTEOBo?=
 =?us-ascii?Q?8nevVxXR0TsC8xIyTstmdH2KKBjXATsy2bt1mV5TmSpEMAcxsVmJk6MbbwKy?=
 =?us-ascii?Q?41fBQXp5QsSwKGcgpvDNq/NZY5Qlm6MaD5JVPT1UIEESpB2qJHxA762JdYbP?=
 =?us-ascii?Q?ndpOkJdOdVshEeuYZPp/58sTC1JAR0zR7i7BkmUu/ZUuopJWp7AuYLaP6424?=
 =?us-ascii?Q?LwEdErAJAueQwFibd2s4VurGh+q+VH5fX1nVdmpCj8D2Exqo2SbOPNtaqreM?=
 =?us-ascii?Q?n391Sc5gYXkBbUT5LEcWb0i7Jo++EMEMdN5vcqxDNENVNJMLr2HUMLIuE9FS?=
 =?us-ascii?Q?xlajQbagsz0CrkL00po4lJdXvp3IA6xhYSOCZTn0aHTy2DPKiB1QGxRTQDNi?=
 =?us-ascii?Q?zTsOj+gY6kl11X8FfT2j5mykWcTvKFPbSN9AjgEuDTLR2JzUTChC46YnqOmB?=
 =?us-ascii?Q?Oleg6aeu3lznKvfsB8B1SsC4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874a973a-c711-43b0-1dcf-08d951be1c60
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:52:01.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNgjvlGGjW1Ruo1RaVweFZfsLAZhBafGunYIqvzYJOLrHg2jNXmK+RIDzrM6ZuMrK0UcPh0HzBw+FvoDOF6eMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add RGMII internal clock delay for FEC controller.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index b14e0e7c1e42..eca41443fcce 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -96,6 +96,8 @@ properties:
       SOC internal PLL.
       The "enet_out"(option), output clock for external device, like supply clock
       for PHY. The clock is required if PHY clock source from SOC.
+      The "enet_2x_txclk"(option), for RGMII sampling clock which fixed at 250Mhz.
+      The clock is required if SoC RGMII enable clock delay.
 
   clock-names:
     minItems: 2
@@ -107,6 +109,7 @@ properties:
         - ptp
         - enet_clk_ref
         - enet_out
+        - enet_2x_txclk
 
   phy-mode: true
 
@@ -118,6 +121,12 @@ properties:
 
   mac-address: true
 
+  tx-internal-delay-ps:
+    enum: [0, 2000]
+
+  rx-internal-delay-ps:
+    enum: [0, 2000]
+
   phy-supply:
     description:
       Regulator that powers the Ethernet PHY.
-- 
2.17.1

