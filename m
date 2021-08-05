Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896953E0F7C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbhHEHr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:47:28 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:7933
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238667AbhHEHrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 03:47:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1Uv/wKZiVnrQb8yuY9I3ST97g/1jrK8MqLpzN6yZV8NPd+zPf0SUxRqFMhz+WFSwrzSf5g81TWy9qPVZYs0iTgUcCIwwfC+/xBp/vw1ARwFK7UplpgqyVCdFZDDbydFHUYAXIAuL1/g8Kcnqqu+Gw0flcNydJXFMgR6qii7yLNpkEKbYa0Jrb7gsS/JQuLZHXo2flHTMeaYYnD+Gc5jDNI+290om4yZ+Vs1P1j/Ko+pvSkkGDnvPkioRiKX+lZZauVdtij5B/UjHcLQXbQrPiSyDdWyIRyt1Lj49jrzNUKSEf4qsrZld7ZlMDH/k8DmwjgT7gITQTTzGnwaDZURaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94/rPIxYakmkHosteDT6UJDv7X2qvg0g/UrvKsAgtDY=;
 b=MfCCEoeSS39GEfZdoULrJrg+LjyVauSLbXr7NhWAG97K5L4q9fYzUXfTz/jpPctUHMs7PP5SNpI2JQE/3Jy+IGoB0fWzcAzuL/eWp4bBkXniAwZ26/nqJ0Q13dqHX+EKucpnHcYGDdtWb6f5JCqUFCCtyAstwdHM/gxmxR9vvxvVGKuWdwj4zuoevKXXs6uBVkqSJP11RUOgUiROJBXmk4+gbLeQri3Qb4AUMqlKlb+RKN5Ojii1H8DG+pSZcbdYhsLU7cnQ4dqrXDqaULSN80mZwgJGvUxmw6jclVIPrndmrcs44DlHAFNTbPFypROlOd3RuXONehIJcNDU1VfeNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94/rPIxYakmkHosteDT6UJDv7X2qvg0g/UrvKsAgtDY=;
 b=iccgSdtNzUswBtISukk3ZtP8Q9IcVJGLXzhHwn1Zp0gxMLe/9hExYh1P0kh2QIaFr/AYrDh/iBSmr8eGrW5TllaEOf0Wd5KQwkIJD+JAncsVGoreKctA1L+lmm2wpXu1yKjKUzvhZAxzDhfuGg9Zs+VsiXt4OMeQETFBXENec4M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6249.eurprd04.prod.outlook.com (2603:10a6:10:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 07:46:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 07:46:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        andrew@lunn.ch
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/3] dt-bindings: net: fsl,fec: add "fsl,wakeup-irq" property
Date:   Thu,  5 Aug 2021 15:46:13 +0800
Message-Id: <20210805074615.29096-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.1 via Frontend Transport; Thu, 5 Aug 2021 07:46:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc675987-5d6f-4a78-b806-08d957e53355
X-MS-TrafficTypeDiagnostic: DBBPR04MB6249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB624944388B1A089DCA75A443E6F29@DBBPR04MB6249.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgJBLcWl8PKrUbv+bz/ZTE/bmXwzakpWsMrbTIsJv/RGIvf72TDPFptNBEJa4NRN4WQmRV23qQ0tUkVPlhg9z5MAkfnmqY/DKGrMZsiZuNpCNzxfUAG3medScmx7ai7ymchUEeAyQ4PMhao8tQAmF3rAyBwoMi3nPftgLIGOX/Ba/SABXNMZTKiXn5VqfnBczFaNEIHtcobbExkSMRXM3rn5+GV4IRJlfb059FhvRqiO6gys1GO+B24GppWUlZdgJye1h0PZwJgfCslG9u6Ai8M3OQBpkseIsbMsv7UecthdFs72C9aLkQhYbuyEiEDYmp26iU2aY/kcUUNMR6o/K+qtWc2hQ2PSGNIzJBgPc9JwYfPOl+OVLOmfRDhPJI1bo/G9xiwwGqhaZeymYoDNLPaEIZyO9P6X450Ol/TnqZQBa2wK0e9D+v8lEkDN7B3pP526MJxZktoxUjRIklBwEtBx3zNVCJmKriv0Sy2CgH6nCX0aiGGOvTkEf2SJcFMsST9Wifd8qcnnSpfsW1OxZcJ7P6A8T8wWym2rNOE+2lNDZqqi/M0TAc4DC3BKkUUdzFSXx3b0gen0nA6suzWHVcgU0zRuxVpe+AzDfiB3HcKbmhPVf0iVU/JWHgG7zK8sJTzFm+TDs9qFxZFhgOP+ljgdLT+YpbGHsrfhPLfsYqb9/6q+AEg8ynJoHeesaBILNjuxRDEXgqi3tbSaHtgF/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(2906002)(83380400001)(186003)(66476007)(956004)(316002)(7416002)(2616005)(66946007)(66556008)(6486002)(86362001)(6512007)(1076003)(4744005)(6506007)(52116002)(4326008)(8676002)(8936002)(26005)(38350700002)(478600001)(6666004)(5660300002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o4ywZVAHRyPZGXQ3ohratY7gOpm7spA5w+prDjdlzDgO3tn9JCvhJ3uRQsvE?=
 =?us-ascii?Q?ugyhitPqDhcrIZyGeRvpyIzeJa/auS0t/pOgOoJY/fEEJFyTM0Fge97w57XY?=
 =?us-ascii?Q?g4u1kUErE9PYGr3PwA2MegEwnlppm9vLokxhglhBIMTq+30EQk6Gax/QGJkN?=
 =?us-ascii?Q?jbRMSx06G9feyiaIdcVpnvCwAWBOqBU4otyLKnc2TnbjYYCMZHhwFOZaNWjl?=
 =?us-ascii?Q?FIiWB4iTzk1Ps/8T+bFKH1aadF0R/FoRAjzFWWwH2czrPD2hvgfUQQMqgmbc?=
 =?us-ascii?Q?pJxr0XEwO/JghpJUHv+5xV+uv42LIazhAIjwl3Xo3GZF1KJa5BKQOvTHqoaN?=
 =?us-ascii?Q?bDccOj0s67t24QNUCTgQJ9qRaC+hkbedGVHaTfgl2vHLrWfYk8b9dNsE70Md?=
 =?us-ascii?Q?RjUUIJrOvy76LiR2tv5XAu0FPeXvnaYKckYeHX3piiXVhm2eKr0jCMY6Jmjg?=
 =?us-ascii?Q?WJ0Q28mvIU+bvd60+LD0Vv3p3mvE5GXtqhIoaU3asKkB1xFdymhXD8XSFbLP?=
 =?us-ascii?Q?3DRBSmBJUtU/4bMonoYtt5zg4A6AqlgZr+E7FB1/akg18tuC0E2q+6yQeNoy?=
 =?us-ascii?Q?ERl+CcBSd6U+DP98NN4UxuJ+hQQDafAMeXdPOshcPOHYrZ5G5bkNP9ogNmiI?=
 =?us-ascii?Q?LgSj6FcwRHJd2T6QCYVNk2t86euWZXNGYcMC+FUuBp5bd7yEGTZabmcRu4zH?=
 =?us-ascii?Q?ecr8I8xfO1eelDR8RO9HHi0Rh6X/N4sPfICK21oxcRI2Pf3hL9OfQwlQK/sa?=
 =?us-ascii?Q?folMH2nBJIP2Gn4EdwHIa/4JSf5yjuExanGlNy4w5TnHXu14zq4lS+kuxHEn?=
 =?us-ascii?Q?ZXtN09UJixEgtpZF4Cq7rCnXWe/c2UEY8xLhyg2hmK05OkYGG3qodKwosacf?=
 =?us-ascii?Q?XwBU+pXrbwzhLcB7JG1XGKfhMSX3ypGrqUuC/WBAxA/ReufFvyyIZCat3G32?=
 =?us-ascii?Q?/J4XRgIU04T8KqU+tkx7R4MgvYvjVNstf+KiNrWMKC8ChDnuRsOABY83vye0?=
 =?us-ascii?Q?F9Cj2nAWs3AN5aYNE6XrlouQWhmksSLJD1blPp/KgxGMp4OsUKN0ecZRdbym?=
 =?us-ascii?Q?CPkXg+jdIQebFh2rXtCgodkWZ8Vkmumfi8seqitCnYxf1byY4kk00sAk7Psz?=
 =?us-ascii?Q?xih+hoRyvIu9bfua3FHiR8FBGUSZVuipLaDQ7NPxbK37JIG3Ux6cBzSmL6zX?=
 =?us-ascii?Q?ufpRTL2uIvmQOXG/u81Hi1g4Vp7eIk4ET9qcANG+wxAvVtBt+3gGoxmp/kjs?=
 =?us-ascii?Q?8An/QZAd2qXHBDGSCeJgvBlgGUWy7IpCPIbOiDel2pmV5m781zYez35t7Bd8?=
 =?us-ascii?Q?cpmIcyOtg3v06Y4O/vECo4mh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc675987-5d6f-4a78-b806-08d957e53355
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 07:46:57.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4kBmdKFZasQNiPfjMSHXhxXWXZaAYF0uGE4wFZAbLTlKW2khUEsDBMH9Rcgw0X278J+ESEwNVD/eUlskGk+ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "fsl,wakeup-irq" property for FEC controller to select wakeup irq
source.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index eca41443fcce..d83f2103c1e6 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -164,6 +164,13 @@ properties:
       req_gpr is the gpr register offset for ENET stop request.
       req_bit is the gpr bit offset for ENET stop request.
 
+  fsl,wakeup-irq:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      The property defines the wakeup irq index in enet irq source, the default
+      value is 0 if not specified.
+    enum: [0, 1, 2, 3]
+
   mdio:
     type: object
     description:
-- 
2.17.1

