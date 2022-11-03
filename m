Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265BD618A40
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiKCVHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKCVHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:17 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE357CE01;
        Thu,  3 Nov 2022 14:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swqp3LtK9xTImVQk7xI5EYsGBk90+eAY3K3jPhWtDP/TLycEZigAxJDqHO96J+maAbSPfEcywnxMAGJH9E/lXQF17TJLOoS8s4CSBYb3aw/vcPz9QKAsA2xbYF6iXC6wtgYZbBUlGhV3XmKR9BBQ7mOUZMDBHcAOhBsb01W8mu8MvKbP9+GmIdgqK2S6AR3F1FG8JO4K1yuKiEFVPslbIe19hpnXfUct66UFae71nRuPaVSO5/We73BqOmLPShCxzGfuRRBTSQSFxdMha+3sW2h6bTqWxRYI7TnsORF+PnnahA/TUnNEUSDNTTNLIWThG39LUjxikL1gLOHYu3cKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuCtP7RlVuZsya4mFYQPAm/vwU+6Ay7rGbjbFvrDQf4=;
 b=LxlBd29ZEuaR+XRK43u5EyQWunsDthJ5RVhiWEFxOGfKfw+jVCRqchCNTsIqJBqaQ15zSXC9i/myLFdKfcUCEamZs13ofG2xM0Ayss7VZXrR0o4PDi4bEY5+R+gdpSaQy3PhnXKl5zbd/EEllkdNgT4OpWYLMR1kAm54NiCBxyBKh2hXAv0ZoBy88SUppG4cVb5fmDg8eDk7M7Qqqsex1fFUIhKOrt5av71muFcYZ2eWDFMF+zW+xGVGPZEP1QM7o/z0w7+RJN/sPoaYPytl+4QluKysj8ScgaX+ZDPVR4GfPJ1VAs31n4VJo++vYXFDdV+MtHqWgtzQmwrZybvCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuCtP7RlVuZsya4mFYQPAm/vwU+6Ay7rGbjbFvrDQf4=;
 b=WgJ+Z89P83ys0kaKgtxxDvSzMkNivh+oAKb8tPw9/nJPpNRTutIfiNaeR3FjpP3gXO2+MtgJlWXQtaHo9ZCxKeG75oSQGtcr20yfIGVgR666eatNJbn8VJqD4FOIkG+AzUBRz8aMDm3wA9jXEw76ORVSYqyDkhfOpE/5Fl9ZGPQc5m7H1zR+n63TAfKwgY+MZYOxNdZC6yuSUBh382GSKZl/0rhtw5Q3vpfyAofrgmSS83LfWke+plhzLFkZvaglbr8mXl2tUx+pTKocpR7Do8i38PiIqZIGgY+gPDZW+EBUtMRdYZ9WcD/sAfvRq4LLFB/zSngFY5f1NgZ2ygctOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 06/11] net: enetc: Convert to use PCS subsystem
Date:   Thu,  3 Nov 2022 17:06:45 -0400
Message-Id: <20221103210650.2325784-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a990866-a9ba-4519-2a4e-08dabddf6143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1pdKAUyqHYwsHafKX5+4fIJJLdYNc+w6UL751T0GjKKfGFv+sIwQUqCiV04ROiEeBThLmMp3Ojc3hbsbfE6tZ/BYfvy9A2c7NHOz5KgY+5z+h1FQJFIGfIyCbmEFy5Xj2wvJaBK7cn+QooFVxw756e2oE6gC17PE4skUgIWBXa8Y4UFLHhI4eVVtfIrxBSMhp+KfQhZ0PpzdX/LZmzukdQIxd4hmWR+PTmIXdNfD6zHC5ZbXiPmva6N8EZ7KoRMQm5bUstQpFNhX+4eNVYfie7xtXc4XbIG2pu6UBI91H86t8uysY8zA3aomJCY9whLuPH+IuCM8bR5M2ZbH9CzX9zOc12go3+MkSQfeEmvhIJXgANiKICgOvdpWjZAkQSSzM+ggi++cJoic/DIlJv/yjexjVPzIC0o11xftwp4T8jakQpK/662fOyT0tNRI+ipCxYiUXovpot0pGBU8bm9BwVpY2ynacx3ov6xtWagYv1BRvXxvXWmwKzpnBu1MNUBw38WVjnppzCtjVk3+AK/9c61I96jldJJHrq2X7H0P3U4pEa/cLurCaDUUsNw5C/u54TF9SZbeXPmS1POOAp6hFUeKiFR3EJNRhPVXgCfJjxIDxXNvYsV83paAGdHTYgYXBrhl6hhtvMOPaL8teTdXmB6QfIKC1UNQWxfXYyMObQLnnYmcYeDavHRFNxAyd6Zfg7y51y5D0rVdv8DCkrBG+pBJ1O+LM5FiV7rxMGD/gsdcAiTMvCxEL7Gv85D0RMv1HyVZGcH5SxIOaco6qlZNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mjka91DDSZQSJMSopz79IWT+58rbKSNayLgydFCrkLtGPvlob/LzzYbWgece?=
 =?us-ascii?Q?3VwBCF76inov45yQ+BXXuzbRy17C1aoLfwM5IPOcNusNFIxkfTatmOYBp3Nn?=
 =?us-ascii?Q?/klbk6AZQ5xms1EbqFitK/PH/MSgw6V7Ijh9iYiqaQ5H48j8fxyPJsfvrUv9?=
 =?us-ascii?Q?aHZpnNb6FAe8TzNYxLLdjLBaDDWqnkfADV7DsGgKFv/XhWQ7HPbUTYL9tuRZ?=
 =?us-ascii?Q?FJ9P8rxZLlyGab+M0UoWFCjgAdYYkPXkDOHcIHA6u2C+qVEZl+WIFwxwk5dI?=
 =?us-ascii?Q?RdPGH3Fx5sLK5DpRGgCftwqEhJy0kQzDYtahyaDBL07+aNQVe5KmgBkdyBlz?=
 =?us-ascii?Q?ZRkQsA3aDFW0X1D64G8QZ68gXWr1lrnZb+8bLyItmSx1iEt9UTwwi+8orog9?=
 =?us-ascii?Q?NFuKFoGxZaZpOXibwsJ0Ckm2Kmg3+Qrbj3RGpaVuywQ3X15wmTUM/dv8Gabt?=
 =?us-ascii?Q?Aj6Tin/TZWdIV9pBPmSE5AaeZPSNaCEkElmXnZCsdx2rTQ/MKW8D+zrMH/f2?=
 =?us-ascii?Q?1vOQQXRg2/4W8m3IItkqxw00ApT/B1J7ccIP4N4H9LsOCkrb2PVP58oQ7LRy?=
 =?us-ascii?Q?2B4PDOozRT7td54O+X1skW1UbP6zGu+CDjdglqnbX/0laO9SZvzbW0nklOTj?=
 =?us-ascii?Q?xjg3azwfJHh+Eum26rLluVegLoOwerL6oj/eGrmon57bpSCYF+uX4i3V9wSZ?=
 =?us-ascii?Q?KqV7HUMTMLpA+T1NLLQpvzPkyPZiobTZY7hVxWH6LtFDrF1pfKaSIAGNz9PY?=
 =?us-ascii?Q?lZXh8HHP1a5BXKt5QC0lxSM3sm8Ke8RA9ES/0yavijsf07qlZ4MGd7pJEc/i?=
 =?us-ascii?Q?K7ZhZhTYZv3n+j7sxHqMBybzj7KNUJ8mzRRGIrQG6gEkDo+QCkIxqMmPq5O6?=
 =?us-ascii?Q?9v2i32oBzWCM8jFTWWKMyeF3ilA4ppNZdS9xZ/hh1+MXHXEEKBcBgF0G7SQb?=
 =?us-ascii?Q?3nltk/b7Use0W7dLmqLOMmFVUmcO26R6Re8E26LL66tOuowfewYuvl7UNCUB?=
 =?us-ascii?Q?cX6vREfwyHkzcJwofFrZQmbdr7AyXRcr3OXMled8fiPIvG7fzdPfYPY/o2KT?=
 =?us-ascii?Q?9R4eOHS08UyjuXP07dFIwSZHYZ7bPMeG91z6SAL9MQJS7+KLy+y5IZj1aCIK?=
 =?us-ascii?Q?0HAv1R4To8A0LSMG9siuifBdwXikp9d9aW/gpwo2ykE+ucL/xG+kZucz84cp?=
 =?us-ascii?Q?bcNzUSDBk1yvMjxznZs6vgtFc5oJCqaS42MxiUpqlliacnyrbgRA16wWxx+E?=
 =?us-ascii?Q?GBq/BfKMco8B9sqEYCBHqZcv/fgbIHI945i3r4iA5qKg312SstFgZRrQiDDP?=
 =?us-ascii?Q?6e94tgBsVekq8UovvvrJNPmD3N6x6MhyS09tSsip8AmlQzfQYNaf47ZlbuOm?=
 =?us-ascii?Q?wDEb0+OCFSUgoV7pItc2wdFlV29JZXX5i+ebl7KnOJ7fLG6sAzq42RbvllMx?=
 =?us-ascii?Q?RfENNEdQ81x/5JPIxWlRNlUzg3UtPvzzFXSB2jIoO24KMt+yr+1/kno5PIh9?=
 =?us-ascii?Q?Fp4Wvncb/b1thMnz9QkxTO+LNbkxcnVeBF3kXgDdoP9C/OxPv/cAJWwnpWjr?=
 =?us-ascii?Q?US2/FHaTEi+TmYcnAJh4YS+d6drW4m2Ck70NGYy0hN7M/NN+VSSKJ8i/Oy7t?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a990866-a9ba-4519-2a4e-08dabddf6143
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:13.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSk/oVzKyJYZUz0wyGssBY4FNP+ukViHhKmwqJPkPiOqtnTSAVaHt6Tp/KIbVp+wJONdpeXZoZ4wLcJtbDqeEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the ENETC driver to use the Lynx PCS subsystem, instead of
attaching the Lynx library to an MDIO device.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Split off from the lynx PCS patch

 drivers/net/ethernet/freescale/enetc/Kconfig  |  1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 23 ++++---------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index cdc0ff89388a..c7dcdeb9a333 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -5,6 +5,7 @@ config FSL_ENETC
 	select FSL_ENETC_IERB
 	select FSL_ENETC_MDIO
 	select PHYLINK
+	select PCS
 	select PCS_LYNX
 	select DIMLIB
 	help
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bdf94335ee99..c7034230d7c0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -8,6 +8,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include "enetc_ierb.h"
 #include "enetc_pf.h"
@@ -876,7 +877,6 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
 	struct phylink_pcs *phylink_pcs;
-	struct mdio_device *mdio_device;
 	struct mii_bus *bus;
 	int err;
 
@@ -900,17 +900,9 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	mdio_device = mdio_device_create(bus, 0);
-	if (IS_ERR(mdio_device)) {
-		err = PTR_ERR(mdio_device);
-		dev_err(dev, "cannot create mdio device (%d)\n", err);
-		goto unregister_mdiobus;
-	}
-
-	phylink_pcs = lynx_pcs_create(mdio_device);
-	if (!phylink_pcs) {
-		mdio_device_free(mdio_device);
-		err = -ENOMEM;
+	phylink_pcs = lynx_pcs_create_on_bus(dev, bus, 0);
+	if (IS_ERR(phylink_pcs)) {
+		err = PTR_ERR(phylink_pcs);
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
 	}
@@ -929,13 +921,6 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
-	struct mdio_device *mdio_device;
-
-	if (pf->pcs) {
-		mdio_device = lynx_get_mdio_device(pf->pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(pf->pcs);
-	}
 	if (pf->imdio) {
 		mdiobus_unregister(pf->imdio);
 		mdiobus_free(pf->imdio);
-- 
2.35.1.1320.gc452695387.dirty

