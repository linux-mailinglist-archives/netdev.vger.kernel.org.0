Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C023E4C9F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbhHITED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:04:03 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:48992
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235497AbhHITEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 15:04:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGgCPg8B7pnV7cnRaWE+VwtcM+7UMqM/fntu0KK/913+U0LWPONOI9v10QYf0QsYgaICS2joxjdIIsN3XWWxaUNGXX5+Crx0Cq3/LEhNLVTeY0dU6pSJciQ1Yy8LQjuyMziw7W87bOCM7gxs4qTuFtVZIMa+ouFtwPobLZChB1xWK+NDBWY57DgbDZb6NHuTcIrVVCAUu8Qx1oneeEMb5mg75K1EM7gHPTjHDb3KCqbqC3KuXjiVBwdQThXX7gcNzQJPLSX6jTRNqg1e5BH7L1MSXcl81fD/3k14WtZNDlndsVueyJ/XYPjLL8OmO5n/+INcwsvKT9wsZs5bDyRvdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wHhcKMXwD8bwyrU8K19896+yWgutF0dcDOazq2/iA8=;
 b=dMlSEDwW47C1nH21CY8/CDz6PTKS8/ySAo8FVbHDVyALhZsflXufyLR0cNJl+HMvLpoi82mdi3y0lwbL3RMMRPZNH9KNyVGTgjZYrAZMblo3veFiOV8GiG0jfWKg3znxy2gOHvjIi3IInFQ3FMjsVJGeYUbY9dtb6Vf+uUwVseqGzQne8s2u+eRj5K3IchcX3wfhkOIVKTmPItrmU60ivuN4K81t2XlZDaWOGPab+8MxGdD7w5TGUdVEJufYNYvZNMINn336JCd6I1MnpyFl+5VsR5FKRDC9clgP/spRifj5eqW+QAy5TNBXs2xsob0jeaIQyxugzUTXBagNEfeb7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wHhcKMXwD8bwyrU8K19896+yWgutF0dcDOazq2/iA8=;
 b=W2XDTPpUf4Shy2ih+fBlMtpxG6N6dp8bqHplZdD9PO/WtiQO826XjpShnthbRBUe+jV8HOqqlXU2DxFMLKKYyK9pyDfLqZUrL+Pcpmh0HgnDQwmAC/aQNBS4G632taonlgZHA56Lk3LxEHo9JwrzdOL+t3Ku79YH51VY8oTBKxg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 19:03:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:03:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 1/4] net: dsa: introduce a dsa_port_is_unused helper
Date:   Mon,  9 Aug 2021 22:03:17 +0300
Message-Id: <20210809190320.1058373-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:208:1::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0057.eurprd04.prod.outlook.com (2603:10a6:208:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:03:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1810338e-d21c-45dc-49d6-08d95b686581
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501733C0A06DAA1C0170009E0F69@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: inzlA+B//0GOOhRUkMeGOYLZqQAbahVeLaUs/dRPM/XMpW0CAHF9drE/LK6S1JMNifGnFmDFUhTE3E06+qd3AqehS7HjljmmDbDZwhhoOnEm1qiHtQb+Isvbh9UG/x/DaH/40qog7IDrCCh9rXrCPgPcVz1tEdRIYAslmfoU6SxkrGrg9xc68yXHYkP7CFdhIry5HmTVnuhOI+Ryc96SctJHFZLPxPKvemWLbvSayNzrra+oojcSKCuPqspW1c1pnFiaGbqeBCorDIeL2fraKz64YwlxfPIxKMMaerqdPoW9KzyIUff3UOJj0uGC09efaPBxGfmfhR2rar7q4xBTAMlAulzzD4yUW17coaGwifJhQQwY3JXlwe2+R777JBgOCASGeU1ZX219VXzGOK1CKs9psaBES+hYdEiA9Rlk4c8vDrWCvg7pjwTKC7dAi8sEDvMJZCPL0SmwezJbui1rnNoOqanKojN93qjeiM/OgEH8kjYNfzpzJcmmdlzZWBZZRtK4A7O3PypqVCmPLvWr1wXnhyyLXc9r+lg8uS8EmDjZEDCoxA8FWRMhSQzV4rDrCXA3x6gXCSMtNwJ1s45pUUO7XHmUwTq0QV9Se91p3JK7DeMKuFDEDwu1GnMnJqmN+Y2OTRMOQpelggmSikFTpomQ19a77O7TiAWRrnplVT2sfm7XniW8k2Q1Pvbe4rtr175jaRMPDfHpidNN60kG9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(396003)(376002)(5660300002)(66946007)(66476007)(66556008)(7416002)(4326008)(6506007)(44832011)(54906003)(52116002)(6512007)(6486002)(38100700002)(2616005)(1076003)(4744005)(956004)(110136005)(6666004)(38350700002)(86362001)(186003)(36756003)(8676002)(8936002)(478600001)(26005)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hRYlZwzJFq1wsaEeH2k6CLGK4WPGOxwcy/SXh/2Xv05fMe9fTwJI1yl7Ny5I?=
 =?us-ascii?Q?iNj1HEtsVTaCqyxwHdfyyXl0CzQq58HIQqBKoRtP0O2FTEdRcaSYDC3W58bS?=
 =?us-ascii?Q?djcaUUvvXVHcb0DsRTvH9LxKvLShuJrX6YQ3uibKOnYlRgoopFUuMloEzmen?=
 =?us-ascii?Q?HIvmWfevCjfVqmchDrDvFfw4i7rb/pnpW1sWUfJczg8eiHuomFZr2nWmNaN0?=
 =?us-ascii?Q?t/Bg9Ds9jPZr3+SCHUHCkh3u0DEJ5FppykT0nISJxPhEC6+6iaZxyooXMqJf?=
 =?us-ascii?Q?4osRlfe+1NdJPGRhBG0/Xi9BbIZzgXJO+aA9FhpRyc8x9FZOpbURMz/DhOOw?=
 =?us-ascii?Q?8XxYEqAui+F22jqZNcYQSRe5i+tsqHum2nXKmr9AD36Cw/zv0MbyWGKuwsj4?=
 =?us-ascii?Q?H4GvKZJgUhpavMdlqobGx/ixRf3hB7bawCvO7XwtuwcW9IT7n0upPk/Xz4Ur?=
 =?us-ascii?Q?ADwM+K5a6PrnkDfZzfjOufg7ODUhX5PubejKWbMkoSKO/25BmyCRZ9ZnkFz4?=
 =?us-ascii?Q?ceQ8dI0/S3ODo+mVweKM3nXhgwa1t5COBn/80VhCrfBTvxOue047AHNVKynk?=
 =?us-ascii?Q?wX/nAC2yMnr5xPHIU2TdHRaRMlGYf1I0CfZ/cmQIcKDmBSgRiPPUfLxhm30V?=
 =?us-ascii?Q?bKje/rh0/DhbdQqwFd1oZpmy1pE19yVboAGSyO3mT8ApPSstQGnlxDWot+zx?=
 =?us-ascii?Q?vrdcs8qijHwQr0oIF7NJ6L7862936iKKFfYmGGb9CilTPKB24e+R6yODCXfr?=
 =?us-ascii?Q?95esAekpe6NuSBvjJdQTE3SKZZqaJZqQ4nRHiFRhlYDaNfmZlu+F4VVYZUBS?=
 =?us-ascii?Q?AcMemOd2Q4FqleKsam5hkICraUdMVrVqOgU9kXLXNWu75Lq+TpP8hIvyMkx5?=
 =?us-ascii?Q?/iCgVP9G79DaVMHuKXoNp15VQ0sKh71XG4Ii8N/OcX/ccCkTg+Dx0QhCLWHP?=
 =?us-ascii?Q?A4eXl4tIBKIHxe8vYGf6WHeecqWyz42OHG2pvrYLykiivJe6jCS/gyPFHce9?=
 =?us-ascii?Q?xAEzCTq1LjwrA6xfjbg/thwyUve9tuwG8TsNSdtA54ufxx0bAjkQHidwpU7B?=
 =?us-ascii?Q?aT9e9FuCYfcPu7rEj5ZkTLu67edC3GU1m/w+9QJQGouYFgFtbv3OhruNa6lj?=
 =?us-ascii?Q?2Zoak1WLteCWmtEkiee7bDS4XMCFQp/tjdqfYQ8Q9YPXf1/WZ92LX/3T7pkp?=
 =?us-ascii?Q?dOB4X2MdF8mteZjCMPSWLmgy3TMbyVjB11LZJsogCmdSgfBF9idXP/jferts?=
 =?us-ascii?Q?ubNm3Zhx72MT28+Tjc+snjz3sWqpEJq0YClB3IcR+QllYWmZxmZPdaDPsxSh?=
 =?us-ascii?Q?lPzxe8eI4jv4GADPNwTPgZe3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1810338e-d21c-45dc-49d6-08d95b686581
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:03:38.9732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8hP26IVPkfTmWD0RLSZGMUOcoUelDoioijEMRDpXewVyw1QOB/j5XD8N/O0ASfIs4NPFxlgfkA9lEmHpNkgEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the existing dsa_port_is_{cpu,user,dsa} helpers which operate
directly on a struct dsa_port *dp, let's introduce the equivalent of
dsa_is_unused_port. We will use this to create a more efficient iterator
over the available ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index cd7dc74d0d4c..d05c71a92715 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -431,6 +431,11 @@ static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 	return NULL;
 }
 
+static inline bool dsa_port_is_unused(struct dsa_port *port)
+{
+	return port->type == DSA_PORT_TYPE_UNUSED;
+}
+
 static inline bool dsa_port_is_dsa(struct dsa_port *port)
 {
 	return port->type == DSA_PORT_TYPE_DSA;
-- 
2.25.1

