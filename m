Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC0412863
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbhITVqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:46:44 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:57732
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242319AbhITVon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:44:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zpvleg64dsmr3vwPG/BMPx+tjHP4VZekxtdUSGyswXcakg79q8hKV7eLs/6OKMnXHerRNHhPzgBNte7rv1FdNft3Yf44zy6Zu47eo33cweF8LFcq4XTD8RWyuXQVrj0d7ZR2XdjKl1G8WLBYzXHU6gsFWF+DBMaPJGibsHXb1lhTgqEy/AYl6g9xdvkNOlovE6s69jpKUov1GzxE2rjAktfDOFmw6RKFfGs3sDSdZVn3YpPy3S6nu82DGd8TCtmdL3/aFvFyM00Qzv58IV9IVo9NGO00E5Db5oeQ1qifbE7ax7483xWuIq9HyrdIJPDL3+5bdaTgyA62owyGAZ+nXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aEnsN31ODS8Y5+Y9sQH9j/D93dSyuz9jU8xo90+KYSo=;
 b=T/lluOa/PanIKDlMRa8zqj38eQwYBkB0Bz+RNWUjVLvlqNET+bRl4unaUC3ZrEDv3vNbdh1iYjoFnW7OPOCTELa+s/3CbDTGfiyjWMe02rE8tj1RMBpnA73FxHZJXrQwQ69zNSLvvPjXot5WzP9JBItod2gVFTaTPNeY5uflrB2O+hieeqMHZivkYfzPr+0siCGAvZyCVtg3S6yqE1amsc1kcmGLSOSUPpMwpMCG1IVTdkOa5bRbXgevwG0dJ90Uf0inEuU7Vjq9EJ5A6ILIPzma4URsHEVbaMc1EU9ndVWuIJdavDH04Xh+WYwoVafFv6PHVzbR8/oXdYTjBOPDmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEnsN31ODS8Y5+Y9sQH9j/D93dSyuz9jU8xo90+KYSo=;
 b=XPTWrj3hH9yi+Civ9LTUy5OYohvbuvi7PbFtlHY+K5X63agLQJ1yjY3KaK5rxFgCQh/ECyjeW9RbTmzj8m1LwZiodxsfs9uIeg/UzwGmG/Jaef937vCbkkpQ8g75OpuyxL3rz8E9SK7/v3NEf9w3FAwrB8Eu4SJM5pRk8EQc6eM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3198.eurprd04.prod.outlook.com (2603:10a6:802:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 21:42:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 21:42:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH net 1/2] net: dsa: don't allocate the slave_mii_bus using devres
Date:   Tue, 21 Sep 2021 00:42:08 +0300
Message-Id: <20210920214209.1733768-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0092.eurprd04.prod.outlook.com
 (2603:10a6:208:be::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR04CA0092.eurprd04.prod.outlook.com (2603:10a6:208:be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 21:42:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7595772f-893e-4316-120f-08d97c7f9268
X-MS-TrafficTypeDiagnostic: VI1PR04MB3198:
X-Microsoft-Antispam-PRVS: <VI1PR04MB319881AA56258FDDC10F15BDE0A09@VI1PR04MB3198.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZU2rv9AqpWCMkAguox8oVUv9OpnUEGTAvWmZplbexX1a+NQZgpBgldsyDZiqxhMfSXpT/COrKv/84f0H4wXYaLnkK581XoDTxdPtPVE1U6YzfjXccADdm6PCcXGx43e+fm5KJUhfj7NtINDAYY7HXWDza+hRo3YuZ2ZQUFMTZZG46rug3Nqzkrh8HChPgc/M0Fuk/edbDgcF9bqjTxHN5Y8sVJsAqiKBV9tBaZ67nM5puwJAWe8COEZJHQt49AcxUVilNy5UG6/V/M/Hb4+Jya11YCncZ1T6raktxERY2ztgPiMNYSr+U1SKNOZASVNvYHkaQKqaYQvwLkSCvf2se1vniUWFmgZJKoKb47Xvy5Tg+jmY1fiB5HEWpIF/imo872xZiudKvcJY0lyHMa0PpacuVvutOrvJOopuq8J14ZjLvC7BtmtF8cLcdXSHKIdMK9zvLDgVnY9MuYlQNXgmk8M4DCaovpUDtoA8pSIepi2POWxhjg80QXJfKz9XEx64U+vKJA7OsNu+wXg9uIrv50+jDyhja4oGfbLj1ux8DF64/zHMDBsHqfD3okabyGhwXUZaVxllwhQ/S4NYa/m0m9gwqAvGj1Z3Cw35weH1def+qEYFPotlqVRndjsLn8GEqwbMgVzc73k1VQV2E4eZij1VzW7DR69G68ToPMSB3w/RxZorOT75mFpX1fvMbVWpMBU0GAnqcfgbajuQjLK8ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(52116002)(38100700002)(38350700002)(4326008)(1076003)(44832011)(7416002)(83380400001)(66946007)(26005)(6486002)(8936002)(2616005)(8676002)(6512007)(6916009)(956004)(2906002)(478600001)(66476007)(66556008)(316002)(54906003)(36756003)(186003)(86362001)(6506007)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4OvVWCnjrR9hQuNACZgcireChPmXy214Ht2sFOTdGwCPSBlR8KXMG3OiYOls?=
 =?us-ascii?Q?LF190Nv80knYHBX2TmY1ee7+WnSuDA/kPUCnZJXKESxsULMxtcpSh0Ph+YO2?=
 =?us-ascii?Q?HkivoUcVzdcLwOp2qV69N7Ds8riGnr7f/D8vm3vJ98NzeP+QuhM4O+wewUG6?=
 =?us-ascii?Q?I7OIF9DX/FbyfyAkNlv8ceOG2CQDqKsISUgPignIvheJQ95ehlLRqoX0bYzp?=
 =?us-ascii?Q?vCgqiKyej4ahy2yeJ4/PH48Pz/hDV+jLSJLJLWflcUlZd9Mx6uTOs9efgL/q?=
 =?us-ascii?Q?A1gLUf8cGZrkCeLNRPHrdDVuK08i7BlDNqcFzbHaG9TCwfpKQdl1ZzjklkNl?=
 =?us-ascii?Q?ouGWG8UQUNAeUbuj1Ud1+Z0Htd+KunZnFeFhNvySW0qCNdt4ycfle392a8te?=
 =?us-ascii?Q?ScgJxx4mnq2KumcePFOA6yX338FCakDjUmK/fvRcQHSTUQDzC0i2ReXl3r9x?=
 =?us-ascii?Q?RfwcL6+gxqsGpKvYWFPo7Pk7HyNMTvWzUFsEnPmJNwV7I5aNVKPlf6puB3lB?=
 =?us-ascii?Q?ygxNHlNygigW97ukO+dYU/J5QAD9Lp2WN6/Zz5axngTWiWG+h5avwi2GGO9r?=
 =?us-ascii?Q?R797UoMd5LqjH5QPXnJ4VCFXSLdMWj1H4ReHJwiDUvDM5Txy1AyUuO5PlBUC?=
 =?us-ascii?Q?iOOyVyd+IsCs9Jd3tMAmWXz44bRtGds1Z372gzxIFoUD6fOijiLvw3rJUXqu?=
 =?us-ascii?Q?Y7p+PQHvAtF+BGaVAvHOu8lN7gleOBtzQB9mN/prU2l6Cpq4iUAJGuZZ8+jq?=
 =?us-ascii?Q?q40Hlv0WnEdXUL+Aky+V3sSyuaSfVXnSOx9zIa61n1Yb1xfufTfdgk3PxDPf?=
 =?us-ascii?Q?bVOdExUUGeRj2S5Y0pfNmkhm89swGCU4YWs9COrzUWBRScdy7P5GpPSoq5/p?=
 =?us-ascii?Q?vsiY7JXFfEmCVMXu54UJzxsrpFxIc50bLvU03vUZm4iYQ+t5T7IKAAOwvPjp?=
 =?us-ascii?Q?ksvjYLYNagAHFWmCGiDZnTEbUV8B22yXOpfu99erJ1Z2Hjy6wfrSKF9xkMVf?=
 =?us-ascii?Q?eIEkZfx50FsMSk1YuDo/k+9DonB513Rflxfn9kFXgrNH3MN5r30DuvlmpDvK?=
 =?us-ascii?Q?HK5CnnxtGkMoJb2sY6Qqs52LhP3N25bRFJT9K1hOxN2FuC1FvrB+0HKdwFjR?=
 =?us-ascii?Q?ygBkn/4V7iSCNIu59Va3b1iXIaPEO8wBraFC2MHOLihY+GbQXzGGw/WJkUsB?=
 =?us-ascii?Q?Sgzg4R9Igb8/V3yMMUexKUbii91LkeHXX86kQm4XNQHrYbX9GuQshzhQzwwf?=
 =?us-ascii?Q?VkP51U77LOcsmq78KS5ChnJc0Hv5SZOOzip13jsfiKWJqLMAPAm3a6tdFfUC?=
 =?us-ascii?Q?S7fqatiUSaEKWLM2U7jNocQd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7595772f-893e-4316-120f-08d97c7f9268
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 21:42:41.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZ599JOZ1VeJY7cL7dYxz9ukJbghxs8NV9a8RF1BbGfLjamWAxzBNesVDugyvBx9bCe9l83beq344oqKWepoHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3198
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux device model permits both the ->shutdown and ->remove driver
methods to get called during a shutdown procedure. Example: a DSA switch
which sits on an SPI bus, and the SPI bus driver calls this on its
->shutdown method:

spi_unregister_controller
-> device_for_each_child(&ctlr->dev, NULL, __unregister);
   -> spi_unregister_device(to_spi_device(dev));
      -> device_del(&spi->dev);

So this is a simple pattern which can theoretically appear on any bus,
although the only other buses on which I've been able to find it are
I2C:

i2c_del_adapter
-> device_for_each_child(&adap->dev, NULL, __unregister_client);
   -> i2c_unregister_device(client);
      -> device_unregister(&client->dev);

The implication of this pattern is that devices on these buses can be
unregistered after having been shut down. The drivers for these devices
might choose to return early either from ->remove or ->shutdown if the
other callback has already run once, and they might choose that the
->shutdown method should only perform a subset of the teardown done by
->remove (to avoid unnecessary delays when rebooting).

So in other words, the device driver may choose on ->remove to not
do anything (therefore to not unregister an MDIO bus it has registered
on ->probe), because this ->remove is actually triggered by the
device_shutdown path, and its ->shutdown method has already run and done
the minimally required cleanup.

This used to be fine until the blamed commit, but now, the following
BUG_ON triggers:

void mdiobus_free(struct mii_bus *bus)
{
	/* For compatibility with error handling in drivers. */
	if (bus->state == MDIOBUS_ALLOCATED) {
		kfree(bus);
		return;
	}

	BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
	bus->state = MDIOBUS_RELEASED;

	put_device(&bus->dev);
}

In other words, there is an attempt to free an MDIO bus which was not
unregistered. The attempt to free it comes from the devres release
callbacks of the SPI device, which are executed after the device is
unregistered.

I'm not saying that the fact that MDIO buses allocated using devres
would automatically get unregistered wasn't strange. I'm just saying
that the commit didn't care about auditing existing call paths in the
kernel, and now, the following code sequences are potentially buggy:

(a) devm_mdiobus_alloc followed by plain mdiobus_register, for a device
    located on a bus that unregisters its children on shutdown. After
    the blamed patch, either both the alloc and the register should use
    devres, or none should.

(b) devm_mdiobus_alloc followed by plain mdiobus_register, and then no
    mdiobus_unregister at all in the remove path. After the blamed
    patch, nobody unregisters the MDIO bus anymore, so this is even more
    buggy than the previous case which needs a specific bus
    configuration to be seen, this one is an unconditional bug.

In this case, DSA falls into category (a), it tries to be helpful and
registers an MDIO bus on behalf of the switch, which might be on such a
bus. I've no idea why it does it under devres.

It does this on probe:

	if (!ds->slave_mii_bus && ds->ops->phy_read)
		alloc and register mdio bus

and this on remove:

	if (ds->slave_mii_bus && ds->ops->phy_read)
		unregister mdio bus

I _could_ imagine using devres because the condition used on remove is
different than the condition used on probe. So strictly speaking, DSA
cannot determine whether the ds->slave_mii_bus it sees on remove is the
ds->slave_mii_bus that _it_ has allocated on probe. Using devres would
have solved that problem. But nonetheless, the existing code already
proceeds to unregister the MDIO bus, even though it might be
unregistering an MDIO bus it has never registered. So I can only guess
that no driver that implements ds->ops->phy_read also allocates and
registers ds->slave_mii_bus itself.

So in that case, if unregistering is fine, freeing must be fine too.

Stop using devres and free the MDIO bus manually. This will make devres
stop attempting to free a still registered MDIO bus on ->shutdown.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f14897d9b31d..274018e9171c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -880,7 +880,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
-		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
+		ds->slave_mii_bus = mdiobus_alloc();
 		if (!ds->slave_mii_bus) {
 			err = -ENOMEM;
 			goto teardown;
@@ -890,13 +890,16 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		err = mdiobus_register(ds->slave_mii_bus);
 		if (err < 0)
-			goto teardown;
+			goto free_slave_mii_bus;
 	}
 
 	ds->setup = true;
 
 	return 0;
 
+free_slave_mii_bus:
+	if (ds->slave_mii_bus && ds->ops->phy_read)
+		mdiobus_free(ds->slave_mii_bus);
 teardown:
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
@@ -921,8 +924,11 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (!ds->setup)
 		return;
 
-	if (ds->slave_mii_bus && ds->ops->phy_read)
+	if (ds->slave_mii_bus && ds->ops->phy_read) {
 		mdiobus_unregister(ds->slave_mii_bus);
+		mdiobus_free(ds->slave_mii_bus);
+		ds->slave_mii_bus = NULL;
+	}
 
 	dsa_switch_unregister_notifier(ds);
 
-- 
2.25.1

