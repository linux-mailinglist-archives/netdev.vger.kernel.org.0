Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474B43E7D48
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhHJQSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:23 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:23521
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234454AbhHJQPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:15:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwK5Ao3t2GVnjKIBqNFG6SJzroOzjVIOymphggIkuc/XEibt3m1tukecQFXB+7F3ziYv5P9iaIWZIcvNpDjuIcZqEqv0rYNlGYHy0hRbF9Sqqh4FHtdFCO9ICG7h0OmLaCsxdgigqMWsQg3zWARCtAlfmZvav8e2D3/SFmyWg9djug1OEcsjaGrtKXyM+YTM0jRvz4tME+FYBIg2RjYJr/rCFfS0yBXaPXnWAV4cp+u3IJsCEJit8VGzuFBmsje77DSEHNuYkxaBf245GMTEqsDPClV7aEr8NIy+K3d9fQvXXeLxA1cBJECjsuLfvZGu2QGmSfLE4jex4Y4+ursjBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ru/8YH3stzTQLi2rtfduBlt9tQMb0Nd9jRA34V3Cl3o=;
 b=BpaOv1etpRgTjo+hiadiXJ+xQg0r7NGbuSPWLdRQu/24rLPerYMRdz2ZmiJ5cd3m2vmWz5GZHbl/gPW3teLpyPPzsLJZ+DpfPkHgoBIwKvlsFSzw9SbeJFdV7ABrj6zLhgyo1tHcCMWbEExGWH8SiTI7MXrQDOXRHkiN3Fwsa4dxnHI7jbRGTWN9hMt0GHxVLkJQEVhxLjXFRvo2mEvF39YIZlC2+K6qnFzLP6iRv2XnNINyzluMc9ZvonCqJOBVSkotPKxXn+cO3knxCRkrzdiAd07Jg9MxKc202cyvuOz2RU5eLdvK7PNeB3drqdEiGfBICeP3YuzdQaMMUpx79g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ru/8YH3stzTQLi2rtfduBlt9tQMb0Nd9jRA34V3Cl3o=;
 b=nyCWH/Fmjt+r1eQMbzxk0AM8A2tj75Vl5SmoAtjLfwP4o5Mmb8CkI1fVDShUrzRJU/wiSrHplaEKnl4yHSnQcrMCfFu9WNYHWZJFAG0GAWhF5LFtKhUDTV2ACMpmL9JmHaSBC19/vn4W8EiGtcXDK6ynLrHuuy99F4V30Xg63Bo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:04 +0000
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
Subject: [RFC PATCH v2 net-next 1/8] net: dsa: introduce a dsa_port_is_unused helper
Date:   Tue, 10 Aug 2021 19:14:41 +0300
Message-Id: <20210810161448.1879192-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c475e9f8-cc42-4aac-81a1-08d95c1a032b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB280013F11FBFEBD031EC413EE0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDtLQ25Dn8X0bIogEsRlBH2Tol1gUukL4aeEfkPeDgOUNNZzLP3nk/0OrD7bLgSt9y4NLUtPz/rotRjr3NMJn/9zTTMQlFyVzj1QSsTXPYd7DCv9Lc4lAv6taVazJnL/EHgoG8GYak/eV2c8I53fwueRgi4WMMieRr/qrj6rEhuiabBUlG73V4chy/FTSaAa97Ye3u53EPoQHhZe4Z5+sVmH4d3wYKDAkrNgORyv6SNZVcGyE8jDv6imUY+pS2MPWtS3ql/qWYXqoFsFu5xIyqbU5PKzcHh4gr7AMysHzbE47X6xzsJttogFutsL2loNEyuAr/tVliMY10A32Cckuv1EbWhUfhpFZa1P4Trc0INGWpR/QxnCnYan4nlnLOaqcE+MKaaVrqxSfVQA4dCSdDoxbEgUmw1KOsldCaoiM3C7G2QydkEN4AeuyZBPV/BwwyCEuNY/jMKrBCpHfaMsY7Dfc2hEI2ouCFLULVmeISJI5zSQWnpPiobTe9H4KGQRcAxttAoE3Iq69jSUFmgP59VJi2XOdanVuKwK9h/VAIEnI+EfUdN0yCb0GMvkjiu5oCDD6aR0PW25aZPVFC2qt9+PwZxsU9xhecQFNUGkZlgmGR5UOsgxKAXN7mf2k7TK5bhu4EY2Up4mv4lotLNzDVU2SrMyiABlMDjk+ro5tw7qs5cihR48FQE/MaNmjTK5rJTt6pfuLUCjm8F+tpyIWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(4744005)(7416002)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1w8FqfFUr6CNPyxV8/jLS6AdRgsY9UlGljqqKSvGgnnd48PCE1iQKrq7xkBU?=
 =?us-ascii?Q?M+Ilm5ABXLqTUVu4icOOoqHZbEBt60bUE1zgfibhxynTBn+XTFNXw+Jp/sof?=
 =?us-ascii?Q?xm+snOtrHmpcmLilSNR02eI2g7Z7IX5CRj6900Ma2P0ReoNwRYV9iDT/A5u4?=
 =?us-ascii?Q?pQMbfPwSZlQwK28W+xwzQ9yR53AvvZ3EkC43B8wYQWqyCfzOH2phjAmVpl1C?=
 =?us-ascii?Q?A3pphoIT2WBMPw0PuYtFhE2uLST753ANh9EV8Vlaj+DbTlDKYf6BTqjFmUkF?=
 =?us-ascii?Q?MHxkLYezHCDwkE/esmy7qpenscl5koBNFQDXcCl2hipxgv03QtqPt4YAfjRS?=
 =?us-ascii?Q?8Ny0uADaOx2dG0kpesYUujbKMMqx0OuYkWANj2SKDSUkUHgMcHqngPgxiwoV?=
 =?us-ascii?Q?dTBn5zzUVJ7Os+A5sLVvZ0ycNv9MWmJGDOjLWcpgw1V9TJeuhExI/ta8hWxs?=
 =?us-ascii?Q?RRs5nrim1ehN5pULl/f+cp956sazZAxWlfk76OjSEVjzGS80xY/0FIAh3Y8/?=
 =?us-ascii?Q?cHvL+PGJDJDKfQX2Iq7/Q797Ybz+rYi8u1THcLbz4yNESSiA89/KlsMscIll?=
 =?us-ascii?Q?aTdTk0VM0h7uY+HkXX/8+rUJ2mqZ2+vBMHkE+E2pkUlTfALudzo+F8Iy4GIQ?=
 =?us-ascii?Q?fRUKrgRs6OGFnnM/zvSmkj+jHu+hGeMjwr0A9vIFg6rFzcIx7jt/2M6GFNPk?=
 =?us-ascii?Q?1X2Gtp7dqX+k6uZy9xzYpD5sckCsNlJi7PUYhVJRraex2ED800CwkgDlynd5?=
 =?us-ascii?Q?vkq7Zq6xBqdE+eLJW3ndxgxNoetZEBTVkoEpe1uttMYtSwXuraX26rLAbNpz?=
 =?us-ascii?Q?nbwV0+wqOFGnkCYf43+lPjLdo8PnRav7A3bi+MR87h29vGF19Hr7+uanpH3u?=
 =?us-ascii?Q?W8N5Isu/JDpoEqwZmNxk9OtVHP7N1bV0V6t4ckkkbAY/LTXbWgG8vxEK5Ux4?=
 =?us-ascii?Q?D/aBbu39KeA0WEixVql0y3rpwr64P3uIy2tolNELYonD2Qt/jXjX2NEeKq0+?=
 =?us-ascii?Q?Qd2E1+UzN/mkjMnQ6xaWvxB1jUsauYOZi+12RirUFXqIG0dK5AjSsBVx7Msu?=
 =?us-ascii?Q?w496aC4RUpjcF4bAXvCrB3EY/7dmFiYK9ONkYNrqYyhWgzfXoyPnJL69ixZT?=
 =?us-ascii?Q?SZjlNok4/6vhY+Xb38zaYX53QJ+A9CQrfi3GeW4nUC41RT0Vfg55LcYOz2+X?=
 =?us-ascii?Q?EuEIzAnusexo6O86cVukInl2mpx/dxYliiEu7lwVBtwjzRrwiW4OZ1j7bdgG?=
 =?us-ascii?Q?m6m09sTEGu2NaCnAK5OzReYTRQ2bvEqfkbEithcVPTTZ9dtw38fHBsNNQsbU?=
 =?us-ascii?Q?rrhQl0dh+2ihvoNMGJHGFI3y?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c475e9f8-cc42-4aac-81a1-08d95c1a032b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:04.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9E4ufuvcIkwLB3fb3++yOp5dhLyDOcjm6m/MAKId65J6jlkK0ZTo+/bOQZwxm/wuGihE6oS7xP2cAwK9+fX9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the existing dsa_port_is_{cpu,user,dsa} helpers which operate
directly on a struct dsa_port *dp, let's introduce the equivalent of
dsa_is_unused_port. We will use this to create a more efficient iterator
over the available ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

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

