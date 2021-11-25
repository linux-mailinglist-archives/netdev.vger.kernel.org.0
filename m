Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA59D45E173
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 21:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357023AbhKYUS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 15:18:28 -0500
Received: from mail-dm6nam10on2131.outbound.protection.outlook.com ([40.107.93.131]:31905
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356926AbhKYUQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 15:16:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ3p9JuRmqQyaf39v09SJ+6uHBLdD5XHKjASlp4z92815qRW/XhqyUNtk6C4UpGN+InGobaTY11tOlVhV3SwxEsS34E3gZQ8dHh3VDUko2zDUESQ8hMIQBV3O+13esSPSiGzgSWIBDJZGIqP7nzVTp4Ad8qDlJyiVjEa6kYSalPCzYXR/yDX7HzFKnMbf5FCXfgi+W7WwcLYJCCgIsc7AZ0jWkAhas2YGge5IEM0HhBO5xdu3mYtTO4+X8KxbY0cYUZEQD625x2utfOOIBmIhH6gT/2DfhrFqQyONruHXkX1o3aDw4Hos0G2dn1QYmrpBJq71EvewaI9Tmq53xvLRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teWH3hIwMFBYnGApZq4W5Op1sj66sQ6tWyuyTDdfIM4=;
 b=U5XQwyGahCupw2GOdYX0IwgaaXr/COddGcSeCPxFDoCuv8ccM4oznWL+R+rd3FxNtWAosaZ/PY/ccdx3ZmLk91Td9RDD2drizskuw3Sa3waSg+bw63Zg8FR5fOFnbV+t1pwXGNmltM6JljdiPTxkqjtbPN3gumLHc086eOVotXMrDMBatNIa9xm+5eSN0fmmxQYIlv78u/j+PMRn1rBjTKyh9N4KbLQ2jxCd/hWWtSPTi89GeHU4JEUOKhjtX1wHpz62A3//rSNf23DTwBAtAZQEc1x0mDt85gKhR+FhWcVdOxLOgrOUSJyWCPP4g68tMBFCb/BAQoQa6wymTkJHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teWH3hIwMFBYnGApZq4W5Op1sj66sQ6tWyuyTDdfIM4=;
 b=lGMMOVriZJuQiMyK/vP8i9NbKOIR5CjNlKmTyh8K+iLd0j/fGgabwppST3MtDE1peRRpaPhExAupFUbVaQNVMa6MRP9LttGxKXFBnvIx92iWCZY74hVZvixHCrSeE3I33FV8PiIY79CzqEE9yxhUV0NEwaTN0HGyilqSFaQfCeE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 25 Nov
 2021 20:13:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 20:13:13 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 net-next 2/3] net: dsa: ocelot: seville: utilize of_mdiobus_register
Date:   Thu, 25 Nov 2021 12:13:00 -0800
Message-Id: <20211125201301.3748513-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125201301.3748513-1-colin.foster@in-advantage.com>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR18CA0071.namprd18.prod.outlook.com
 (2603:10b6:300:39::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR18CA0071.namprd18.prod.outlook.com (2603:10b6:300:39::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:13:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f00c69a-c4ee-4a4b-f2fd-08d9b0500286
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:
X-Microsoft-Antispam-PRVS: <CO1PR10MB55219B83E57D59E0C3FA3FCFA4629@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmgNO+uvEYmxBbFgw7TG6/70MbJgnP0f3139mzCtkvYbrv5VeisAOa/Ue+mpSRvSTbcc4SU5Tpz/tCaBX7hUIzsSsm+2+Q9l111B9+pkGM4/K4UjGZgTyjMBDDI8n39L6KU/zcMF59TkUH7USZMeW0Kqh+v9iclB4Vk9xRnQplb9+So/XE9oiCTwo+VaGaCPual+Q764l1vCrugQ0sd2pSDeh+ZFBz7s4xOWTtCZkJg5sEuwwigjiO/79oht/btuNWbdzYCcBIwQrJKJZoA7JaU/nT1+oNd85PAVGdB+k0RgCI1P2yXzUaFwdiU4ovD/Fmh+dXKFeVaaZMZBkuH9STbY1rJ5iuH+u4XiaMHUUu1gqNfeh6ZrjeIVBaIIXJAVvoEFM6KAzIYLPEs9X/+Qu8QHTi1FYRE5ZPHu88Lk4JZJ7H/pgdRDzsds2fqKt4DQBScum1mptPeOhuwnhU/4WIdMVXSXxQSwZ7EYl10UXE7zypYKMyDCJ0WocNpfQ4jC0UPK3d1wId2GPQ2qnO8fZm9kyRZ+PH50Mt7dHYs7sOyMezv+vOxm/W6nNbyC9IAHeQ4ydCP0s9DDG5bWxF0DLyiPzMK1edSCHP4tuc1kcqvs/4iPX8yMAY9HdMLVeGIA1Ij/A4+vPwx3l8ZyXpRbo6nb/64PBTqswgaoemAtDERdzBfUorbbVu77js45zzGcB4zJheFBjBONpWk0DcWqJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(376002)(346002)(8936002)(44832011)(5660300002)(6512007)(38100700002)(8676002)(508600001)(86362001)(6666004)(6486002)(7416002)(186003)(26005)(38350700002)(2906002)(36756003)(316002)(66946007)(6506007)(54906003)(4326008)(2616005)(1076003)(956004)(52116002)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V0Q5vSDEfM87OGaIfFhU95w6ZHlq6sr96iBTgi6dEAFAPPHukrr3/jDelbkx?=
 =?us-ascii?Q?IXLOUhzH21cCUyfRk97pHHXsIsTRuOaguXPkEiXKKvkUG64t7pQlM4Jfhp1Z?=
 =?us-ascii?Q?ofYs+ReH3gEbdVRVpo3UZv2zFX54aWgHCpiVdgEO7jQfvEd7q72aJfKI8VUm?=
 =?us-ascii?Q?0L6esXaRW7gc5uYBNESVrcwchtdtnefkEefTf6qhKLRkg6NG021WwgP+JmHs?=
 =?us-ascii?Q?yXbgFnZnOUv/kE6csjovqWCGNxtTIsLdQ56rB05QUUe81DZGoEEgOSzBcmew?=
 =?us-ascii?Q?IF2RjyOo8xXNY4WY3ddFNlAZGuDV1ztNplFykiikBa6EVHdYSUkjBuP6Ye21?=
 =?us-ascii?Q?J4Lfplz3pUv6ipVxc5ustw2h/XrUC3sTuJc7wzb7gAJRu6n+47I5BMN9Me0+?=
 =?us-ascii?Q?GsuL4eq6Pfe3U7LlQMEhDF5hWHOeoA/zuxQZKro62I/kwTnH8fv8qkvB5vS8?=
 =?us-ascii?Q?aCoNMOZ4VPOFp3GnwdaGihSYTHjEiNBwBVBRwuu5GuaYcWEUVKz/JGAcs2CC?=
 =?us-ascii?Q?1jutZvmYHDv+d4/sc1sYQM/PZwEs5D97GqKG9yFFkfPhhp8dqA8/8zN3BrIZ?=
 =?us-ascii?Q?aBhg7BnoL15DfY8xDbdVukt63cVW73otyX6/R7znEb/aWcX07GKzTrzTBu/f?=
 =?us-ascii?Q?5S573JgCFxN0u2fAoBREgaF5Y+Mvc4LCXlD0+ditSU+Z5kvn+o9Qpo6nK6AK?=
 =?us-ascii?Q?/Lp3oBICsh6yPVEoztlLqLkhMYq43CMyrobf8+sfQqUpvrdi+ah5d+NGxjmc?=
 =?us-ascii?Q?yatwMLKlgyyJitXE7qM2O+KsYYmwlbiOevB7hIbM1NadsuRendHgGYuNmoX3?=
 =?us-ascii?Q?1MpRu5qLjc8NC4wSjZirK0s5uIKXzwJQaSNtUViuWUAnQNqm5HlSfoTyYp4g?=
 =?us-ascii?Q?4wlKnbCMH95Oeq2QebtNIzkjXjv2nudmlKMucLRrVtTE/KiGBJ6dQeXoAU2g?=
 =?us-ascii?Q?kPi5FtBgMzfjEGPTjSKDhWPaKAkSsDE9z1CHHT4MllsWv2YxFinQJpxpUkQS?=
 =?us-ascii?Q?768ZT7BMQtpTmkkmau0eLfP59AG6PbFygr+X/a1/IXPmPPf8NYMdLn0LOeVA?=
 =?us-ascii?Q?dnu6IsrvQ81Uth94eHP4Vvx+emB0o5NmzPnMWZXpu7TP4pGbnGkZQkqXmBXN?=
 =?us-ascii?Q?giUVzVPnUARQeWUuvB7klJ2vKy69MlwIWbFyX1brI2J4FtzFK6K62cPwcsHf?=
 =?us-ascii?Q?IEkr9me8QByDUEBcKr2Pe/Sk1I23rxtuoFur/D3CWsGrl3I+nElyBCgroWXF?=
 =?us-ascii?Q?+yfrWJR35VJmJXGr+whkYDgWao8TIXa0iZv9oHPpPFaoINPll9TSYZ0fEWWP?=
 =?us-ascii?Q?ietvmSzyeT/flcrioJIpI6JH9PnuZ+ScG3ZMxkx2uky7bYCe0oBxSRZ6xcDc?=
 =?us-ascii?Q?VRJYL7Dc3qJKk/u+ttV5DiaUoWdx5V73lpA0sxO8VPMO5jz4RJhGf4dRcvoE?=
 =?us-ascii?Q?vcWIrrT9+juWP8dYdMh+h0oUJZbFyYnhEKI7ffDYw+kwOCk5PJvQ+8Wgu5AD?=
 =?us-ascii?Q?bw9DO+HF4CV67Y8S9TtftkSl2lF1YDx13qKGIExpIkgeaNHan/VZgI4Sshkr?=
 =?us-ascii?Q?zj3iBp2Eu80uUR8OPv3fIGDjwqBwOdp1x3icRHJukQdMVwLFTQ8UpT2CO2wR?=
 =?us-ascii?Q?TOsTGMZOjNzQyIfAsbX3LbwQsw3+NOt6+FfkVpnyagGXEayjKWDbW4YJJWy6?=
 =?us-ascii?Q?P1Mpzw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f00c69a-c4ee-4a4b-f2fd-08d9b0500286
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:13:13.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Badr9hgDMJAFO2kDzPlWIAo4NpqIXifl/ANGn9YrqXxR7JcxHk92AkwrQxQtqthQ+Ao04ybHMap1BYMMN30pkMcNPW93koDLpuh94Z+RsA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch seville to use of_mdiobus_register(bus, NULL) instead of just
mdiobus_register. This code is about to be pulled into a separate module
that can optionally define ports by the device_node.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 899b98193b4a..db124922c374 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -10,6 +10,7 @@
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
+#include <linux/of_mdio.h>
 #include "felix.h"
 
 #define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
@@ -1112,7 +1113,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = of_mdiobus_register(bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
-- 
2.25.1

