Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55753F1BC2
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhHSOlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:41:09 -0400
Received: from mail-eopbgr20077.outbound.protection.outlook.com ([40.107.2.77]:1368
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240264AbhHSOlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:41:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7DxZyjZ+creYkIuSwXVLzxIa2MdSIiuAnYyVIvNmZklFfFgyHQ2XgnDWlD1623WSjW9A3hYxzvEGCRSNb0Ba2yLoqbhsXI1eDxD/6JyykkIO72iVYkfVJO0kmHlC9KTCEtuRvFC4TnLVmVffO+t1PtSvF3FzlElmmMFbXPQjD62puyq0tL6HqMePIiE3oQ8VzH2dN1YvVk3EYi/G2na2+B6ZYD8W9KEnZWfQ1G6wkk0vRbGKVpUDfDKgmGD2VtFGty/44ipT/VRZ2IN0MT7LmNj95b5DPH3fDYlOBeq80GyzmSr7deRrB9kJMFIovywqpRqwEOqdzc2OP8ZtJ53+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/IhAr63jrm/1gBecsiY88y2mduy6JX971kek7J4tKA=;
 b=OB460l8niWBzLZ2+sYkpFh2zgd9rgmCHulTvnifsK2TCyPX1hLEX1qF7hR8ZT1DzBslIShdH0NcEGLvukTdqJby72Ovo7wjqVeNVOiWh0riBOv4jo9Cqdq9GheNamFhHPUdVcjuEJAwtvaGbxTAdOxeH4evGosLhp0vjm8w5Yv7HuzMfAecJqQo9YNNyWl462wXHLBDOv9ZOssEGoABm6vSzlsjM6YVIrhUsaV1as6EpmDnVBGVzPS9MfolfKM5E88Q1Oz5kWPHzFdrajQQ5QZU9dCEUgZBiNW/RNZDPNKSBbQ9BwzHQV02bl6eMkJjo68CFCdbpAMEazesOyeiFIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/IhAr63jrm/1gBecsiY88y2mduy6JX971kek7J4tKA=;
 b=XieDYBEPiy/Mgh6Y8uKzanWwLZfeu1kFSKGjUvzkS74P5V29MDBEx/tO1nnimCDHfB4mRUJ3r8ZcSPCPbc4aITc3PslXCUUlgj+SEDfXCZ+FrCX0QrDcFSrGktbJLEeHn6p7Kv7f7QL54MND9udyNk6ixlrvyDA7NMRPwKtog9U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 14:40:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 14:40:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/2] dpaa2-switch phylink fixes
Date:   Thu, 19 Aug 2021 17:40:17 +0300
Message-Id: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4P190CA0011.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 14:40:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b81a96a-2e35-4bc7-0509-08d9631f4ac7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB62695CE448A1BB4BB8EDA4BFE0C09@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDrmNOsn5h4dOAneLOH5e+oE5QnWivph/VgbC3nK1X3wNueExSjWH560jOTcWs3J49pFB6k1jQKdoXMgX7nA8xp5ZcB9iGR8haeU/yb0eQ1z16tveVLe/wX0eOs30Kxnf6jddhfGtmo4atoYGyd0xM+j3O2MtEkD0Q/yTYiHM5kpwj0KUt17i68+53nxELzUwKIQAORVp2ncdzJB9jTuYvfoLpSa287PaChIXpec5EPjNnHO+jzF+zsHQkM9zVY+vbeHjy5mampnSs+oQt6crTQDDb7wHSwXFh4en3Fb2piiXUgSrVfDun6jBSnT4Nx46kllJtvkyuoMPG7BFeo2e6pDMVexSnFR1n25Us2/NjFJGVbANfPemBUxjZgayydHn39d27ddD572q2cwq8bzoZrOCqaRP4RYRgw9YUYbx5in1PGN9GoinuGuliOguAwybUdBihueY5dr83abVADJo7ZT3MD03DxtbtGUFKiUQeQz9Nd2YGSrWnvz4Cp2YsdNX1sLpr069+chP5t4papDnydpztk+zAZm7/booVoluILfwb5c4ptdtWsI31rHG9Vi+KwVoYp00ZZPoyw833RErLYWr1y6fZ/AIoZr3H1eXmsScU3kI/z7O0OcJ15KYyppMXES7OnVSA5ja1/ySxP7KhfL5Cjnw1i6pWfncMEokTiWT9cmPmvDtzy71FFaY9VSo2ekOvJ3SzvS6RMHAm6U3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39850400004)(2616005)(26005)(6486002)(5660300002)(38350700002)(38100700002)(8676002)(4326008)(316002)(110136005)(6512007)(6506007)(6666004)(44832011)(478600001)(186003)(1076003)(956004)(8936002)(66476007)(4744005)(52116002)(2906002)(83380400001)(36756003)(86362001)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jr++ayqjvspgSgMc4wMnhbnBBI6yHxVCmINzYb5AE02u8eoMCGHYieoaANBZ?=
 =?us-ascii?Q?d5d6PAUMRoSeJy1jmEPdbg39IMpGrSWU8yTf8vl94sj/J+Vsnk0b6rA1ls/q?=
 =?us-ascii?Q?BZmQi83gNNhaV6aRbywDETQXx/Gv26c1eGsWNj2nHLtZBnGvsvvgbnVq5Oe8?=
 =?us-ascii?Q?Q4rj7iqxgCjDrXbA/Tsg4UxbvN2HQopi3kThfIQxAVR+3W0zAHNgSA3EUjiO?=
 =?us-ascii?Q?0b5awAP0gZZVouG6637/EANl6VMuA8Wo7uWZzUBMLIf7CGI/xgjfwJNcxfhk?=
 =?us-ascii?Q?97Qv2+x9M6vpG7WoiANiCQZAyjaf9WNUu/HrOirFeZcYZLQa4MPp/tVntAkp?=
 =?us-ascii?Q?MjDnB/2rV+ELbtLRjrO3OJCnTFUa68PjMRNR409btvjKbL3SWo/9p8iSjGyi?=
 =?us-ascii?Q?cy34QKmzXDD2lYwPSkEoAzM1yFoAp2O3ccQrjxZOjEB41rOCXMxeKacKCK7d?=
 =?us-ascii?Q?w6/3VcYGdF2/tDGdUFUzUtcoOkbBaO8Sjm7CYRNjJgbYLZtDuXF5Uenz1NNx?=
 =?us-ascii?Q?XjhCmjr10Uy7srxPq9Y6rRj9YZrNqueVS3cXjHXEpuHe6Xy1n62mtdYsJA9l?=
 =?us-ascii?Q?SMCX0Cwkn2Hmx6PStaWVSGuI/rjC5solCyiG18PhtoYEfodR+3M6OLFfWjGO?=
 =?us-ascii?Q?kYpNZLbZ8euWTUTZTT4rIC/R7Zs4rFK8mJxLcp51bNmh0JK0qN6f9gio7srF?=
 =?us-ascii?Q?bQ55Fdx81jpPSyW8r36OMVOOTr7it6HfRIwyXvmuQzbIaJG+0ii562phd/2V?=
 =?us-ascii?Q?8TSGs5I5OtSv0jSLqEw6lXLiNkrTwg1Us6YZ7veJLXfPzeCo/Q4EheMTKD5o?=
 =?us-ascii?Q?Mfa+rNIP0uaMF7MLctbsdxHAkK1I6XWUzIv8T4ERUdp01VjaNqvqztFaKYlm?=
 =?us-ascii?Q?x2Vxad4uNYoVWzMJb6RqCQMZHTv/yGLcJlCkWyqK0l+jIfSkbak0BHOqcmaC?=
 =?us-ascii?Q?kIsX7ruscN7AcDNxcqHpn08LjrCQ2CmcQ3eg4nV0LfdG7sLRFn8jTJK9MycK?=
 =?us-ascii?Q?tB31i8Gnz8Lt461S091xvsyCaZwhVUGYbX+XL/qUbvP4+kqkfwkGGwS1TZtn?=
 =?us-ascii?Q?1f80nmmSywGeSlECMq/yt+Kn2LY8VPn4aKZY3ao7ZjfIq7OICaMGt87JuzD6?=
 =?us-ascii?Q?IrefAWSLbRf+uf++w/AbLElQkIU1F+HBOM72SiCDU2uHK8e3+/q4MjNo4mA2?=
 =?us-ascii?Q?qCBZSRjNKmwuRL6GBhIQLhXJ+PP9mvvcIFKxWOTHvm6F3hEjDPS25U2k1hMV?=
 =?us-ascii?Q?Ax0KE2MOyl34lD7kZpPJfJ965Q8gaJC9FWZg1yB4KZ1OLe/VpLoMAhfPnwCV?=
 =?us-ascii?Q?fRFgBOETlu5S7r2TWhOhr2nP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b81a96a-2e35-4bc7-0509-08d9631f4ac7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 14:40:30.0588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwtD4EIRuL6tJ7d7MBCrfZgpEh+HVsvcaGVqBZ69Ivve/GsYb/bADrkppzGDOedUgIs3w7HhI/Gg0Kv+dO84Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is fixing two regressions introduced by the recent conversion of
the dpaa2-switch driver to phylink.

Vladimir Oltean (2):
  net: dpaa2-switch: phylink_disconnect_phy needs rtnl_lock
  net: dpaa2-switch: call dpaa2_switch_port_disconnect_mac on probe
    error path

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

-- 
2.25.1

