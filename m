Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1844327A7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhJRTcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:32:55 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:13540
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233664AbhJRTco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:32:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYuKIXv+UC7M7OgK9L0WhxNJzQYt/4YCZVJja3nbAUidouNXEomRcIlAH1s5kc1CkwdYXdABpPsJg15EnlCZ4cPrFW3E9p7WNdPq3YtINV7vi5DVcH/yuGK87qTj3+YNe2osXKIej3FKtyrSTEpyUYcBpFfP0OJF3R357QgMxoHi8dbl3eeeT3mq+xP3xE6958HqbmtwSMIQdYT2Lw74EbuAaQjzxqh32+0/V1JFGrr3Pc0fsy7Lce8XbtS6tp1I28Q+9eiqVRqfT37cViePTOFqnjgEYGzUe32r8H5W4ejZftvQEa7w6kkPvhlhtVBh8IqeSQJ+G+GgzwRH9bCdrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPq293RXjtrJks4emNtlPYMhyYxPohQ3QB4xOkzTfDU=;
 b=BIsHv7UYvS/fZPZ6dGWGep2ND4vKq5QUUhLab6hYHj5YRoh/LvqCWNsMtoblWqk+T0yQfyL0UppD5+ZFCoKGY7d7xzxe3V/JyleFuuZ7FYjFzwPwe2HjnV1uPGALLvP25G5GfsnBv/Gd1+1MXSIt0DIPKKvsjo5W+qaxtM3zczbH9mlLsTtFpv3D2/0e/WlxfEzfkIt9K41cge7wcHIcEj0fH+KZNc3e2XhOZO7jdhY5eN4Re1XiB6uJJklHm1nS74JMJUTC34bWJ07+OHXDnvryQoNz4wZucTycgn2QRexv36PrUL8B2dUF0yVDpdVTi6IQhwaXEZF7wO9NPi0LSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPq293RXjtrJks4emNtlPYMhyYxPohQ3QB4xOkzTfDU=;
 b=MrB08T6BE+OqBlP1l/s0yMXjjer08iY1EvXv8W7IWxrKR0A1GRwZntYecDV2IWRORPwU7TqOpRHJb5Cl+JGD+fNz0KP9mTzWEW/ZXaYhco6D6ZPyIUaZEpt94GVC7lovANHr+0ij7kQO8WLhGTswalTJSULJxYFL38gkYnI1bSg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3711.eurprd04.prod.outlook.com (2603:10a6:803:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 19:30:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 19:30:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 2/4] dt-bindings: net: dsa: inherit the ethernet-controller DT schema
Date:   Mon, 18 Oct 2021 22:29:50 +0300
Message-Id: <20211018192952.2736913-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
References: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0160.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AS8PR04CA0160.eurprd04.prod.outlook.com (2603:10a6:20b:331::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 19:30:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fad497b-999d-4683-0b91-08d9926dbead
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3711:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB371190195BAED3B001FCDB3DE0BC9@VI1PR0402MB3711.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cP3C8PwQsZOg4yXSw1gZ9WcD/1GzAic8wWIGnHjtwXJCa/RmTHnVxo45fGdvDUZG5SQYFA3K7fgDDpZE0K6SA5uLsyeTy3YSS5tDEW2Fs4clM4X5lKjVzKSj1JUzyNXvxMbSUXbVQLq52jjOnaRcjumozxZPZcNbYwIjj01SqbeBeizpxtz6RzAbD/mdfs9CEcrEHU5lCzRB1MvlmrTaRCXsfoe0URf/2M4p+UVtYLEDux/GJQU032/eoakCdnMHxSNQEigz2I35Ps7EZySZF+1EBUKYjYA0o5F6MfSrZQV8rWvm/7DE7QFAUxVjgSbHoJ3JyB/ihyAnC5ceOnn0znP23dL4RGJR9egx1uywvLwRafxKikGltfQK/HylWJhf5sYseLuIZTDrkrIkwXiDoxrjnbau49mtZdTAGj9XdmFqnbRTbKdrdE0xNucj7pIvtajmy6wbNl0lnwugE4yO5D0Vd55MnnCnjmpUW8/r1LxtSgzcdhsMdVbbAceV2nYQBWLfj88mixFg1XNSj6N6SdJzy9JJ5J+JLjiN7OudjOyUs5TxY1nYVS41RDGN5VsZDmmGsYtHqzuy7APLQr0cVcDfeUKaZ9ek/t5Mv78xFu7Oy822yh/JmlX+plloFC3vOh4JbTEOpS6pceo6JQHg0xALR0rbKDIcR3bSt9xUT1GxxGG9LUjS3rvONB3FI2zON/hJ8Tkyd4X9PPRbYAw31tpDmEb4BzBnZIwoL/DmWpTTYI/8jH3hZQmzU2wTKaDO9chYDSo0+EESnQ4xBM2kU2llCHqSNZJ1DbQehxZrt1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(186003)(6506007)(26005)(66476007)(44832011)(2906002)(66946007)(956004)(1076003)(6512007)(8936002)(66556008)(54906003)(86362001)(6486002)(508600001)(4326008)(2616005)(7416002)(8676002)(4744005)(316002)(36756003)(6666004)(38350700002)(110136005)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ah6KmeLhSQ8kChtoeu8OUAbb5sz0DUj2hFhuOu2+vFj1zmc4iTixWsBVYRIZ?=
 =?us-ascii?Q?0g/E1+SYXl5+1yUJIWz6VRW0e9dutI0qdsBu+a5vwO2JAcXl0jqUszWJa6Vy?=
 =?us-ascii?Q?XU2Wh8zoIbluEB5Vky4+/JuK133V6c+LOnNg664Iy4MtdqT3dJZa/CwqFo3y?=
 =?us-ascii?Q?4tYdXDUZIHKVr2AitqMiRh9gdMWFXfCvzqqSdZdRMyXhW/49b198PQ9fV4yL?=
 =?us-ascii?Q?gBHE7ZcVniCo523X8xrryHopDwXOlIOHfdix2BwzI6NY6Q7E2gk+2M6W6LNb?=
 =?us-ascii?Q?Bz1tYMdd1bggLdyvDe4DLuHaa7HyVGaCGnI9FXZKmLItvy6n4JO8eW54KgHN?=
 =?us-ascii?Q?GkxldTWAzNOaTWL2fJn6HhpzNSPf7t6lrtx6w2FswQpy2LAHxtYafnQuNxfR?=
 =?us-ascii?Q?J4UaW/Z5QZiEfz45M6hBBcE3FQdDkcGbwB6WT7GycUMxewEvAKN6lmNNXCYm?=
 =?us-ascii?Q?G9a3gWniPQrCw89j2mPbei0RF1RXRO5SqweluTNrnoiikONqVIm/pwVU7NdO?=
 =?us-ascii?Q?K7GzTwGk9Is2PYoOA8c8OqsiHFVuDosqrso7yLuyl0BnBgZbekhl2+MKPea+?=
 =?us-ascii?Q?rihOIQu7/fipeJBymGdPI7ZfIPVMzEUsBFNBCKC/H5Ukmp27xrs1rRbxCbgL?=
 =?us-ascii?Q?QedVpZx/kDR/94WIeR+bdPpvzyMTiInT2oP3vJml+f2AgvQ4gjmiFBTVJ7bo?=
 =?us-ascii?Q?ofWwE6pA6P37t2gGA0qtaocJYmivwuFifSHHaGktc7m4ewCxvh0M9bIUdfXn?=
 =?us-ascii?Q?anPZ+gKK+5pt7orkHZSNMz3+h6dSt35oM4fxNqqAqg6vBgguzQvQ2yPyp0Ed?=
 =?us-ascii?Q?N2CB0HpCos4zuwUrDaMh4Sw9v3JX+kER1j4ev0aeUlGEQS096KQNUorL4bYH?=
 =?us-ascii?Q?x7NCkA+3uBEgyMYhuTXSQ+B5PClg1h0TpDwlkLWIQ7xxyWf7GA6/uS2nrd/1?=
 =?us-ascii?Q?V5tjydLdNBB+j/ZKHWII76Sb4fVdo7vsLwpl5RoaxvdPIqEyjeT0f9btTFxU?=
 =?us-ascii?Q?uifN6t5sLws7MwnL1XIRpeqOoazac2NPESl75fzNEdXmMNLGeAtyq+X4sPL6?=
 =?us-ascii?Q?30/nvkBOljBpyIhtpGhzLG/b6AadtCtxUhpGVtp8uv4r9pLKzNuJIO7OrTSd?=
 =?us-ascii?Q?P4gv3wzltJPgULJhSqy49s9FG+sK/EtjpKTX8etAA+URbce/xRt4eWPL8aAw?=
 =?us-ascii?Q?EcpL9bvMz/nTSJGlz0XTXRBCbpelmR0JOLAe8BDghtgAD3OqHNAOP6kz1eeJ?=
 =?us-ascii?Q?WuqjYQ4uEgFdS5Jn0A+v/7MAgm02nMRMHsgzsHSlvLJKYxW3TVK0X7Nw2i7U?=
 =?us-ascii?Q?r/jJsuj1F9uhLcdtOYcNsRS5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fad497b-999d-4683-0b91-08d9926dbead
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 19:30:29.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvwyIcBbXqtPATZ8MIe1m+4fn1LynQbw6shxWKI/fdFhHFOH3WInOXHdV1FHvIIhuyJF3U9sJ2tGDA5ElcnTmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since a switch is basically a bunch of Ethernet controllers, just
inherit the common schema for one to get stronger type validation of the
properties of a port.

For example, before this change it was valid to have a phy-mode = "xfi"
even if "xfi" is not part of ethernet-controller.yaml, now it is not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 224cfa45de9a..9cfd08cd31da 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -46,6 +46,9 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
+        allOf:
+          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
+
         properties:
           reg:
             description: Port number
-- 
2.25.1

