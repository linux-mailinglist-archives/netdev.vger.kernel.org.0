Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A86A42CDCB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhJMW01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:27 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:19889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231204AbhJMW00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TN+jJZvpt895zFa6rD8XmxK/zr3mYOj2A+YiSrKE9LwldgOf63yiz+Q0l17gqHsCf8DxbsYKJoopIc2lRAe3npbERYO9OIYagQF9xKx/mgk1ocuDzBr1p0bH/J6cEqm8GV5ro5E2KSaU2/w3BkOECGsXZ9dyEG3PHheEuV3AkFc3nyJlo08cjjiVYGZdt/IgcqNzXqc0APqv/71GzPsEJRvYb4O8JZk7k0X5GuBCI2aXo2hJENBpzgAv6UDWDqHaHPQyKpqCxMQ7y9boILMqOmPT923cT9ENR3W8dhqxkg92AP6AH6gcJ8fCfe8baJzksPU9U1xJQKTVwoMkqiWr2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6F8epih5lhAR022H9rADcd/SiukwZ03CiW/TM6uGRZw=;
 b=nCMev5qrK1EvBmOCg73msjXW6xBm9LpIbinkJNX2T3OidpJZ+QC5R+aNujtAmFQzV90JlsURtHHoXOTLSlBmbWQlcnhr/2wAOj20YSoiCzr4Zv8uKPyVWkR5ArSBN1Ggip1QpUuZx7SOdvYvHD8vRhVMg39VAozX80lxJsiN45lMrmjZ5k9AibjgJ9vBzrfg+h+HCpKN11LP1qQ/v9yHGIrOjEntZpo386WRiha1+MKy0jv42OLcUdb4qITr5LPNUc4SSPumgYgt/JFqXG+7o3AZIkhEvWI6OVL7cwk3U6h5BJyoMQUZqQDn8XdyZ6I3pRW7T6raUkRWWws3pw20LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6F8epih5lhAR022H9rADcd/SiukwZ03CiW/TM6uGRZw=;
 b=OrfTknPXJt4tY6Mjw5BrztFsK047GAl5XoI22BsQEiZKgk8j/y/cnGvG8Fi5O8FtY8wnEoFPl5SFbCWFCW+2aiBrDosq6R/Ps5YvP5abVo0GaG5d37ZALEX6xeH9ywvBUavg+l7RFlsHlxF78n0EQSKn7KB8Ux5F4dhNelX7Axk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 22:24:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 2/6] ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
Date:   Thu, 14 Oct 2021 01:23:09 +0300
Message-Id: <20211013222313.3767605-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cebc3b88-6e8a-4146-ecce-08d98e98338e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481693BD8F55ED5AD14C3CCDE0B79@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ElgbmRu+fXpyVZ3IoPcO/h0XBN2wJA1LJ6NxnvQRcLjf/kODxdf/J5vhOBWdUvXmRDY63a8qinNer5xPUCBp4U+0tt+JAl98+lWnx3SYmHFkXqIrKxfQKULXfp4aw0jW4YHDdCBZbgyfcaP70AJ0Ou9ZM5D+9ucFxbTP/cUt1Lom09Q89ptvG3xunc9pQbzaWu2hFDJ53ahJLQiVJqfYyzTO5OEN/AAYQRqkPXDz8F8aY3Sk9W7Sx1T1YWZY6aY2FzDWIr9H3jB2c/rowWUkAQmr3zIRpI1R5LhUT7UX238JmHNGLEf6mE/XWWEQiCmnICRH5K2e2nfXmzvgDaUr/QFHbavxlsOg1EF+EMyVwSo4KUZgA6G0FUdmuXnoXio10xKVOfbMx9/3bX2NDf1+DYYd8v81V8XuL65df9TUsMikpBzMFRTftgFCZlmk2LRa0YD6j4BHWfCC33g5yay46IDppy1kOQF/QMn4s5hkNsnTgsGLEsPP7weJFeQvOo8gEU/7Kv++Wc4Zz/ZX9GOkt6ynobPCMu1793z068y72NskbCoXKAyagbeRr+E+LG0I0/0sYDRF9J8BTwYHym01CsSbEdQosXUN3hRw70WEQTPuTWYyU+aZ3zoqEpcn2hh1Fuk+mhWAqPWCgNfD+Et+4ic1EV46Y0aQ+S/mop7Zrc/Uf9tuew4yESWscemT3G8/E0Kvr544NbLQt10nT1pdvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(956004)(38350700002)(1076003)(38100700002)(6666004)(2616005)(6486002)(26005)(316002)(54906003)(110136005)(2906002)(8676002)(6506007)(36756003)(66946007)(6512007)(66556008)(66476007)(8936002)(186003)(4326008)(86362001)(508600001)(44832011)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P/h041JbknUVmQsvxAkfrjnjEtxy4iMYb29yYpOUwfJvYoQVzZNqGGaA2K9j?=
 =?us-ascii?Q?5Ng/HWOXNY/OXIfLx0GL7/kgZAfZ89jr0eYPOfN6ywNRnv9XnYuu3dpvQ+zZ?=
 =?us-ascii?Q?NzRKvsOq8iBpWmVvudVJQZq5d+LkF8jkifYxiIuyFAjPDxVaPgq+MKHJMwbK?=
 =?us-ascii?Q?qMxhzVuWPWSXHeYoFaAFoZcQhYJGHcJKPUjhCfhU1jYYPAAHvFnREnUgT/Xf?=
 =?us-ascii?Q?3X6auyEMv8MpL87Gn4klZckV40hyumM65gbOHey+dIzKs7az8IkutdNvSvq7?=
 =?us-ascii?Q?J+Fav+ZZK2Q0gCo09Vx8EzJNuuNgOfn8N2aLnhMVCAfPXrZW1csXIraualle?=
 =?us-ascii?Q?wMl5kcNFwqjHI3vl095lgvxW0wHT+f6Qt1T+KRDZUU4BID8CtxsGXxoJhEHF?=
 =?us-ascii?Q?q3SSa21vOxgKL6k4Q8iphVkN2rNWkoAf9PTM7wtlqY9xmIhSO9WciMjj5F11?=
 =?us-ascii?Q?oRKENwLQHLBC1v9xP+Eh3MmG0MVjYQwd7XLQiELJVG272TyelXrxgw/E1Wvd?=
 =?us-ascii?Q?RiPvcFkfYDbcbBMxvg/djF0rPij8onvUOV3K2DSGb8il/o9JfAhUGV9Ipesp?=
 =?us-ascii?Q?j3Xuv9D2WwPxit0BGUWPrcNPDxwormZi7XAjNQtqeSN3hCN5GcP7m1ZO5az1?=
 =?us-ascii?Q?G4qC4qsiYsg0N2EXeRUnOBlp5x3OEX8qQI4MQ1Qj20857Lah2b4AcwAaFOK1?=
 =?us-ascii?Q?YANZCz8Rrn+cUPnVqzyIW1fxVT5EB+USqB/vxcX/RuKJ3lY8ZmhKYZ6+0Jew?=
 =?us-ascii?Q?FvjiaawxvU/cta6i3uyq21xUjFRoiKQb6DfaF+CBp+kWtKhxh/B1ZHoh66Z+?=
 =?us-ascii?Q?dNW5juPCx+DhFNwMjKmhuOvpW3avdoOAQLQMRHBQtZ99poK2xaYSs1MLU70a?=
 =?us-ascii?Q?mmqw3OyKlbVMOI1/wDee5Dg/To2NRi7asHP7/FGntpJBcdQd2dl8EOAUD7jC?=
 =?us-ascii?Q?RYlfJSVp8OAMTyVQAzA8t4jrFPJKHANj5n+1WbwIvPWj4V1THbXMxi6iBahX?=
 =?us-ascii?Q?lSvBvWoTRz5MSvZuG8FRiPi43j2ET8F/kjrB3vAFtsD95PwB/r+5HnqExfff?=
 =?us-ascii?Q?12Ve/Umnb84jwFrbHnETRF3k37PMfgU17Hj49taBfsEZMM6d+l8FLPv5Gu0Q?=
 =?us-ascii?Q?4TY3lFPoeoTgSnZxDoB7Xcd1G1XHwOVKhxtayfcpd2iS7veJXMaZg3VKcUHN?=
 =?us-ascii?Q?IJY7f7ylLuBG5KpULN57ekNScpA3Xkr3sDjk6OEv6VijBvOsZ7JiXER6M1Ml?=
 =?us-ascii?Q?6eMipZE4brShxGxz3e9XAqUTMGQef9+lreglpW/KjBP+8FOV6lZqZNkiXSdV?=
 =?us-ascii?Q?/wT9ojS5SLlZ1BYNkN5cj8H0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cebc3b88-6e8a-4146-ecce-08d98e98338e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:20.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5CfpsIOOSk5jw3JHI6T/hrEPYEfLHrAGsKJ/8Cs8s0JAv/Ycz7o4fu0nM0vX6y662lxp39OXoHK3ea08mTLAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to not apply delays
in any direction (mostly because the SJA1105T can't do that, so this
board uses PCB traces). To preserve that but also silence the driver,
use explicit delays of 0 ns. The delay information from the phy-mode is
ignored by new kernels (it's still RGMII as long as it's "rgmii*"
something), and the explicit {rx,tx}-internal-delay-ps properties are
ignored by old kernels, so the change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 9d8f0c2a8aba..517286073451 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -90,6 +90,8 @@ port@4 {
 				/* Internal port connected to eth2 */
 				ethernet = <&enet2>;
 				phy-mode = "rgmii";
+				rx-internal-delay-ps = <0>;
+				tx-internal-delay-ps = <0>;
 				reg = <4>;
 
 				fixed-link {
-- 
2.25.1

