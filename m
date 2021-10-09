Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0985B427A1F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244873AbhJIMaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:30:02 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:6886
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233062AbhJIM3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:29:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EI5ETnN9LAwsnTpWrO16peoFTdKYgHW7n7Fcz+T3Dokg2G3ZTgYdDSEu3vTARa25S08KKSOYvf46ykM6DyQF6wGh/g/hez8mswuAyYglWiamUUIpT2QGuc3b+hiA1LtbvXpzEOTytcjZCjJ3ejQQXFPJ7LuqWTyrL45h0IVySS9TO6xBSQakmCWOqt9DdAdQJDq+ibqgbeBXKOdg2/FyJlszKra58mPKagXHWneHcindLgDP6ee40iFDy40OZ6LROwSndLLHqd+OKIFvidQSJ0UeE7EGLP2MYXK/3mdSuIsnk4plaFOdeKQjyKw3wfvVlWcLI2IGdh0+GjxzsjxEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bknhEgoryfVm7CNYSvGXgcV+qjUB9Jk3DY3uqZq9YOw=;
 b=UJk7Uxh5OWgH2ZSoaSr5XLZA1AtvX1tAeq6UmfgmeWWfphy4Hy9S1qru/wb2C42j5vtRioTW2LVnZUtSRGo4DUBPgrTJ3LBo5xbnSgG1OitjUmHb9yMct//imkddzm+MQKV2sXwFoCGIzpQPgg5oFS4hm/h3ituvjCUb6AR4lwHT8YHOj/HNosSBjcrXX6XlbfDDocCZ4oUGQURN3SYGbWQ5TSG/ztSxkxYfUO/r9OHfMXBhQZuBmkbmjgRR+ioKsYj4wlpvcL/JIS8DwB+5Or8X1pSRBsZt6VXcdQWKzYIA+S96qw8pVeuajgZs0BvEsJeVsXESIukZ6vGSr6dQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bknhEgoryfVm7CNYSvGXgcV+qjUB9Jk3DY3uqZq9YOw=;
 b=fctR5kL4zjFgAIXyx05jhwSAZxliK3xpfO3q0K8Hh1es6GEoaz3K2sengTVci6NEMG+MIuPBbjMTQSzoUYsdcwY7E2dPR2oP2OMLZHo9vGpWU+ssF99PNiwIHYUH7BmaKoheov0iNJtqPHc1K7Lx4ACeXVBdIPHSYzeLwDqB9sE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Sat, 9 Oct
 2021 12:27:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.026; Sat, 9 Oct 2021
 12:27:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/2] dt-bindings: net: dsa: document felix family in dsa-tag-protocol
Date:   Sat,  9 Oct 2021 15:27:36 +0300
Message-Id: <20211009122736.173838-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211009122736.173838-1-vladimir.oltean@nxp.com>
References: <20211009122736.173838-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5P194CA0004.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM5P194CA0004.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.21 via Frontend Transport; Sat, 9 Oct 2021 12:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6efaf5d5-d87d-4f67-fd65-08d98b203728
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3616884F3F191B93EDEA13CBE0B39@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxOModMuwg1ddWeV8swtr1EEeydxUJ+yRtMwelrnaSJS+Ybt3eqM/6p83WJCOcHgfaGR2NHNNgVdKToXUXeTPCBjTJWv7wR66OXub3YvbDyKMKxP3OrvYfiM58m4HxelJFcat8s0rhnvwTlkML5SIcxP41+4NsIesfTmxzYSMrVd/91oKr44+itCACD8KOsQjeNlpPsWnC3y9XE3dT6fuHuFAcrhD0kekVjaJg9cWpFaQoDvIvxxnZSG1rQ4UtU19Pid2RodJwnlLReH1EAaaJYe9ufPG+hYgt3aXUNh3vBV8tL3MhHAdlGinZoi8FoWpYESKznMa+OmVPDK6bYgyc7287z19Ai1HUI5KT6s6OiixIrsv1CnSaajn/0VnY9hnfLh/mk7l1lAzJtTykQKM2+Y5dibZW2derMw8sMylWIL++VuOBLM02elEewn5KoFctlJunmt/eZPJygj+Qhc5Z6h0Eax+W+XovpXdtqFkTSubfxMLnVP/UQK+H0tBbNWnbmqE5KQ4oRdYtYZ9VjFoIBWM29Sctl35DqPrq717K25gBxcnWRX5/87tOm/1HcdlKTLIsF6pVlZCU3sV9LcbSnYzAANcStnef+qIGLJyba3cTTWQV9Dwoqza0maSAaeqzIhZSTx8GqAI1jexf2NiKX6NHge+1Zq5x/Eggok370G+096eD/6z43BSIXeTnEtaXm5myi4GLKmwe7xpPRpCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(508600001)(38350700002)(6666004)(44832011)(38100700002)(26005)(52116002)(5660300002)(6512007)(6506007)(7416002)(86362001)(6486002)(54906003)(4326008)(2906002)(8676002)(8936002)(36756003)(2616005)(956004)(316002)(66476007)(66556008)(66946007)(1076003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PEf5tTD7QtBbSwpLYAXNYLGoEhVIVfeAMYu8cFvZ5oP+TUcL1tZEKOToX04D?=
 =?us-ascii?Q?vZMg/00Stnycum56z7EwamR6pSxo+vnhDqtQOD68pChKYziy4z0i2cn+ajvC?=
 =?us-ascii?Q?Nq7E4+A4dL4EYMvjQ1DGBYE5uUBsWSKIfgIGh62q3r2zhFzsl+YRhaYsYNEb?=
 =?us-ascii?Q?3qq7lK4HBvOk4jIxVGBfhFZHte45brI3IUPuera06/ghExdm6+pAtyoy/6YD?=
 =?us-ascii?Q?8D7F7ncNKGRbFgy+1RQ/hw+VHeydk0N/bZD01SI5XEHM7fEIIpjR5pDV+Xax?=
 =?us-ascii?Q?p2BbKNvbwS80oEI7Btbjdh1NV+N8I7ysNpXPJDPMMhMZNLoUULHAaNFQtOpF?=
 =?us-ascii?Q?gyxKdMB0pg+kXHhMtCChDMRp9quDE3Fd2tP7H4vair7dCprZF7yjSsn/o0VT?=
 =?us-ascii?Q?SJMo8GM9CwLr9xgYc7yB/o2eZ2JsRddwtWwrhyCi1YyM+UICFmdiKqUyGGNq?=
 =?us-ascii?Q?Fv1mjfW4e2ffSDUuoQNQZhc/9iTNr7eSx55GEUzrxWE8iCB5YDiNsJc8QViQ?=
 =?us-ascii?Q?P/z7ZzfLvUjyj+afTc7mm4H55UG/Ys1gkLX0P3l6kjqh2WbZUyBl/47QxDfG?=
 =?us-ascii?Q?jF68lkbvHNKfIwcbR8aD7lDG/3ms1NNy3IpbcGweP516Epp3otkfiJsG6pQa?=
 =?us-ascii?Q?zC5bLoKc0gDZRJcKBL3yZEvBFuqETuN2vejM8YTjOOTWxCTGD3v+MACF8hGT?=
 =?us-ascii?Q?KlWfqFTzgw+ZHvVj+mfdsmoEcvSoLj0myeIqPWDOpAXekpZ1JgbrmV+cAf/M?=
 =?us-ascii?Q?UwTf5jawXDfJd9j8SjpobaADLBMIIcvrIImGamEp6LimgGgk5hwSro3x6ow0?=
 =?us-ascii?Q?KiC5v+U3GKXhvlUMQ3ZMNBudYSOF6bXzPxRRs/Re00q5lek8FVW2TFUwRWu1?=
 =?us-ascii?Q?0UinH15+gq7skwi/FyLjasNv2r9l4BcRKUH4Y6Xg0JAhc5r3/iPkcFjVeBWD?=
 =?us-ascii?Q?AMfO2a5eWIvOmFGKgHsVXl/dnxikdTWu7s7uDnW/TgR62nDlbL7cRxF6Skrv?=
 =?us-ascii?Q?34EWhAhHOliAH+gSglNxL8VjCPMGkMdvW3mR3qSPOLQ5+KDkTYEkcmxc7aFF?=
 =?us-ascii?Q?1YOwhQAohlvPeDajOuk/JdxNnry1rJWm61PBJwZCcij6D5KfdyfaKLH5On4L?=
 =?us-ascii?Q?MbMnUPe0Xhu7dMqG4ICEkTVepmHcGYTfJFH3UNRgbXz/G9UYkhk6VCco+Jcs?=
 =?us-ascii?Q?uSTjnVNFvA8dk9CWxnSmfib9H/HJUmVGqVdtsbWOGO9h3uO/2uCyFuVvKs4h?=
 =?us-ascii?Q?j8j1g4N3lcCLCC+4ecH9pI8EJHZ3IWazNK7eFPiSvw0U0HQpuFupUUnPHaEd?=
 =?us-ascii?Q?9J0TBLXujRQkJkwJ/VGgfdaB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6efaf5d5-d87d-4f67-fd65-08d98b203728
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2021 12:27:53.5070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HMV5BE2NeX4bn7AxJulH6SshLe9RZOu0mm3tnhsMAmA69t9iE+CPSpZU6iEMpQ0I2Uo78eujF5xaMqHvreC4Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Vitesse/Microsemi/Microchip family of switches supported by the
Felix DSA driver is capable of selecting between the native tagging
protocol and ocelot-8021q. This is necessary to enable flow control on
the CPU port.

Certain systems where these switches are integrated use the switch as a
port multiplexer, so the termination throughput is paramount. Changing
the tagging protocol at runtime is possible for these systems, but since
it is known beforehand that one tagging protocol will provide strictly
better performance than the other, just allow them to specify the
preference in the device tree.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 51f243244f7b..224cfa45de9a 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -78,6 +78,9 @@ patternProperties:
             enum:
               - dsa
               - edsa
+              - ocelot
+              - ocelot-8021q
+              - seville
 
           phy-handle: true
 
-- 
2.25.1

