Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEFD421730
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbhJDTSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:22 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:12353
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238862AbhJDTR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGn0iWBZhw6fF8OYbOwweXPLJZo9BMehNgqmVKA429nzicrtrMt8xzmuiTLh0LoMVYjDkM48TvqRV79Dxi/uQMWh0ORIFmDXlywbYYCynnOGtDUtm4sADCnD5KsvNzFY53h8JnQWcYm72cDJEVyYoYFl6irv3qLFtMc900f/txTNa0ve0eQ9ladr6Kd66kmsfvIuU1gMskiHoyzs2W4BxM/znL3pc4KXK2sa37mKv2KOZoBd+/64kMSZ7QwzgEYDJEiTnqOD+CnOfFC2F2jj2jcAhw0NTHCjQtlRPo+/ECTqgisgkcuZvub5dzYLxJllDAalJEdYeyrGYhHJlgytPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dhPr8MGXC9UUahNrbi/O4wBvyRmOPYg1jFblu+Lxzg=;
 b=AuSNOGpZ4rrydxSFGX8CKxOyvA6xDsjNvIGGjFkFwTKpkyIWUGU3J5NuvSM0Hahp/vyu1rcjyh8x8A97sdP9wky2EFO7PxGZXDppX609Fe+OD0DmA+1htXniZDPPKm6fOlVBvGZhDLcdF8zNMp8mDVW1F4bytREnFhjiInD/3OlrSM+q9+J0IAbpNIdBb4JDY056YzxQaLqshf+nJkQaAnw5kEIJthjhGsIMUunCDXXS3P0nzHWVz6h5bJqvckM56soHgCTlnbFLnBwnj0rK0Aas5XEJaT2//7YxzsGAoXP5IIFJYXhOY+NBwm3LeU1MyuABK6g00rIPAL35Id0FMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dhPr8MGXC9UUahNrbi/O4wBvyRmOPYg1jFblu+Lxzg=;
 b=EcaqNHoKtu+YAIWNO4UdVybwELBzHgwGNFICQLcfdEm9jfBv0wYaIqdVNLo4KksnNsVNxhe6PbOq1nBJQQsMw3MAAxI8UDB/OBpsiyh7dtKnFBo+Y69N/rBk/l0UVT0d9aJyLrtnBQljbC6wBc3QznOcf+xztPWIe0QH986eTUk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2183.eurprd03.prod.outlook.com (2603:10a6:4:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 19:16:06 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:06 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC net-next PATCH 12/16] net: macb: Support external PCSs
Date:   Mon,  4 Oct 2021 15:15:23 -0400
Message-Id: <20211004191527.1610759-13-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cca3a8c1-2275-452b-1e86-08d9876b6a68
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0301MB2183DAA06EB19C843AEAC9DB96AE9@DB6PR0301MB2183.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2vLfpQuMTgU2H530aB9qwRAhyiIO5908VqZ5eD92Bde2rvdzsliB3jTjDXa4c5vPY9xFTLYUjnKCdhZlhnRRceci15+Mfuut3bGuyt4MxQSqgdhfWvPjljq/r6m9IX0O1NZ6QqjGcpQHWGYAUdoehgi4CJwobRjZqjo7VkKsfZdKOe5J6F9xbV7qvuXkjxF5J2vbgvW/oX40STTJOGdIUg4t9GvQPF2VXNCzSetgm1kkteyvZPa/Nqz60VOr0Q18P9CA/ZMkPf+sy3nQ1X8/WQDuh0Rt/ZdfPE6vflOjwC15mm+VLra6OaOlM2QPVMq9X8RnAd7cVqRf3PP8EK7qXtotgbZGr0vq1O+2xZ5xCv2U+KFLwbsqoonDYmDjyCVcdeJuujA94lFfTAagZyvpCOE05qOQxY5EaqIQlvP1MuYNBhQQKuLbAd+J2IFQvyM3GooOB3FXIRVP9lTJtbEVE+TWRCNeo+ptnCtqcc3rZrpF3AQTnNPIaccy+Jel3O2g6tdm/0grQtlVeTmMIvlzuAVaG3Iu0SjxBZ4aX1navRdCAq1eY2zlZaTerb224xLWhfo6wWwkqqDGyZo3bjpWT7xDvvjrn3YMgVLlbC3NZDwLCEqMvhjnwwauY6cnDYDDRakMdHOo+nEHID1XFWYB0cyt0GXtJooWExpUiNH/6n7s54OIgZlzYHWsZ7I+BJ3n0aGlupNEQ6MdJwQ+X75Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(83380400001)(2906002)(54906003)(5660300002)(1076003)(52116002)(26005)(66946007)(66476007)(66556008)(44832011)(8936002)(110136005)(6506007)(2616005)(316002)(6486002)(6666004)(36756003)(8676002)(4326008)(956004)(38350700002)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?58dAl8FwAeXlhOR7WJtawK00yzUELmrtUWng6Mu1XokQ+BX7DbGWcQ654Okr?=
 =?us-ascii?Q?hrCOaxGHC05FMQQo/STd6bPPtL5eyxQHLJSAfvocRBh+7Bdloc73YGwOLe76?=
 =?us-ascii?Q?zq4hjMW/F8HNd/MMu33fSGsO1qvhwzjPjAFqyXgAuv8sN6Y7Xa8AqjApXuzo?=
 =?us-ascii?Q?hzKxq8pLVHMw/wmd1qlbbXG8/ClGzmHwoyDppQKIRAZGYn4dTRbGUQXS2dDQ?=
 =?us-ascii?Q?6dRopqs0XluZrLFhVfYqMH7hCuA2D9XtxvE48+ETx2rOFSLtdSDJeR6j73jH?=
 =?us-ascii?Q?1vDif7l95sDVwspt2qHYk6i5aGMPG6bezPK0jodyawo2QttP72eTNxj8f/ig?=
 =?us-ascii?Q?yvfwFgadPDDUR9Uy3QJtElI1Nnx0T0NFgghMpnvl93q+jP8X24sijdJ22SRW?=
 =?us-ascii?Q?5CfpZ1SjlJHQvlcbPiZpG8hoYhmqt1BGDyzA4LWikhY26XhFBaQSLz61RMhY?=
 =?us-ascii?Q?3m5YWIyIPuv+JLuc3mGZYpGWqdk3UDcrJHCPi/o3ousJU+F9Iv981L+adZhi?=
 =?us-ascii?Q?ZEczktOsQzU09sC2vfvaJ22MLijSQCD+W+qop8wItIjEDCk8eBfkd4T+UOmx?=
 =?us-ascii?Q?nTk6XralO4d3JOalAWuLLHEZ6NJoJNvcMGGpoprQlcvx1fEUvGHeqQIDSA8A?=
 =?us-ascii?Q?H9nue3A3QkKjxXT4DFbIsHB9k81+k3ncBt3vdAnl/jviwEUCCBFNVNB2sjS3?=
 =?us-ascii?Q?3gW2QrtVLn2L8ZvVlhuKUTNFBdrsZ8PfYzXhAznHb/O/xZeWN1xAvbxwCKpI?=
 =?us-ascii?Q?wUwz5BYU7lElx2TuvWEmYRJkd6AkPSMIll3DV9xnbAe1cbF/EK02vEnsM9Yy?=
 =?us-ascii?Q?rCjPu+iwlx+v1u0mk90Umq8GxopMCc0/lj8wHYhyIFqpD7epjHM2TXPTXY3Q?=
 =?us-ascii?Q?0r7c9kQdhxQH+0NKE5ZL3pyBkURYi67q2FZs9dKGjuW3MQQR7H5NU2Ka19+t?=
 =?us-ascii?Q?S0iXzG4e/e1hV7Wm8AOnQOHnUX4kbcg9DeHtp94DmK2cI/2oI3yLgl77LxFU?=
 =?us-ascii?Q?WfcMpfSYpZIp/TPkRGZk0PhPFv2H1SUUAixUnqZzIcfJ3b28GLq/ix9wOTci?=
 =?us-ascii?Q?+66bba164Wo0mtnLRg9PTdnlNFUl4z56ySQbbOqMYoIlHrbau5aolJkedOT/?=
 =?us-ascii?Q?IPdUnxAnGKuPGnTQB/9/0mKL3Pjr+qD1gWdr1PlcfT24+TESXNOsebQyuuVQ?=
 =?us-ascii?Q?4HcmsK3Ziu0lhuyyVopDPf1vHBk7kcdpC1gmoqAzOVor1diJxUbjyVLNDzTS?=
 =?us-ascii?Q?omAniahfXJhxBJCeMS4Ipmi6acZ43SSYcFRzhpbVm2C+R3fmcoHidIXKrpGQ?=
 =?us-ascii?Q?FowMzJXnbI8Kg1kh6lvmwSSG?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca3a8c1-2275-452b-1e86-08d9876b6a68
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:06.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXb8ABwaRf+GNNg27Nyxh9eloqlueDDDzOH3ooEysl0JIIKNuBl/0NVLAbic4c+o+FZRySAqJ0bprm/+3Y03ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for using an external PCS. If someone else has set the
PCS beforehand, then we will use it instead of the internal PCS.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b938cdf4bb59..7e9fd12c09c8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -862,7 +862,7 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 	}
 
 	if (set_pcs)
-		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
+		set_pcs = phylink_set_pcs_weak(bp->phylink, &bp->phylink_pcs);
 
 	spin_lock_irqsave(&bp->lock, flags);
 
@@ -877,8 +877,11 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 		ncr |= MACB_BIT(MIIONRGMII);
 	}
 
-	if (macb_is_gem(bp) && set_pcs)
-		ctrl |= GEM_BIT(PCSSEL);
+	if (macb_is_gem(bp)) {
+		ctrl &= ~GEM_BIT(PCSSEL);
+		if (set_pcs)
+			ctrl |= GEM_BIT(PCSSEL);
+	}
 
 	/* Apply the new configuration, if any */
 	if (old_ctrl ^ ctrl)
-- 
2.25.1

