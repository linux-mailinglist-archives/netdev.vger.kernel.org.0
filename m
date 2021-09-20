Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99576412866
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhITVrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:47:14 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:41110
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245186AbhITVpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:45:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKI6k7A43jGUgQgxqe4yLE4sBdRsKR3bzzKEr+5R+LbtHRufnntgzH42EA5n9SPJRau+doDoaNgc7sRcnchlANz650zE7BuwL6pglMLmTsvNc7UfG0WcMKvFyl+1OzPYaj4aeVrnDX9SIZUy5KgwtHCFbSBaqBW4wHl45uepWG9lUDpghnj5q7tItebzjAfvKfhFVY59tJGdlvFfWiOo+deTYcgwJgUQL7U9GrA1yzauH6eVtlDiVrR9U0FXTx8I1TpfL1GzvsPBfVVGUy8z0s/RFUd8JUATK1Fdno98NVRXjf+zOgWawlu+vsJcZdSD2rs63iNQ6htr7qiNHhfcSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TzJNXqhszzFJbBvFD8Atx4FK+G4wrReHxStOnJFKFU4=;
 b=L9tDJVUjxET2pbEN4WYo74cULT7Z+cX15CINPcZV3DUChihLKtURQIRE+px885SCaxwQIjX6cN8lTm6O5j4f2z6/nKpZbtNEW1YuvjIEsz1D1YpIW9Q7CF86mivm0iSGmauFaAHQh3sYrcN6RoB6ud4sZHYDjoGCZf7fi6JqgIoEnyzIzXfVXI1BKyVJPYIzUkk8GebCSkr4XcQqzize2lXaek5+4hsu+IqXHFGE7JwWst/irtFMhdjcQ1ycaN27dbFvHvzBF12HHpz9ChN6SddW4P4U0RPo9oKHIUg29c/P1NvqUqizV6CgJNKnnE25UQXh/libpg5/LoZisrDdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzJNXqhszzFJbBvFD8Atx4FK+G4wrReHxStOnJFKFU4=;
 b=PDmiPLTArRABu7ex4tbhQQhdIpJYFOL1P5srAOhWgMv3phdOvfHNGB8jufYxkRUT4n90DsrwcuUPLXNvAA34ZW/M86cFgi3V5pGFG6wiszVNM5dMPuHfrpYAkSubeqQWHbksDHRaI3y7K4IbaJK/en9mzfNhA2691u1d6jGq5Vg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3198.eurprd04.prod.outlook.com (2603:10a6:802:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 21:42:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 21:42:42 +0000
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
Subject: [PATCH net 2/2] net: dsa: realtek: register the MDIO bus under devres
Date:   Tue, 21 Sep 2021 00:42:09 +0300
Message-Id: <20210920214209.1733768-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0092.eurprd04.prod.outlook.com
 (2603:10a6:208:be::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR04CA0092.eurprd04.prod.outlook.com (2603:10a6:208:be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 21:42:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4f46b65-c2ae-474e-c55f-08d97c7f9349
X-MS-TrafficTypeDiagnostic: VI1PR04MB3198:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3198A7E8518807FED2B8129FE0A09@VI1PR04MB3198.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/AjU+vOovXNXVOo7pdly+s/JMk2wJjwd+2myhwjUbmWElJkcQGxhrTO0PqRnKVkbGq0ezBmoYIZ8CPqjJkYd9gE5NXU16wAf9hl58J/XRUX+tmoglTfZJ4Sw5o2Ssr+IJslI18JlYwIgrj9bce1ha010moP8rE7X63pTCv1Ajkw0cO5ICyeZU2HMBWynRwo1IuBvBQ9Z5FQFBC258sHRaGxExVgm9RN35zfhgHiEv3Fyb6edsV/5EGcWl33ugsexzAtV0K4sid8HjBut8HVPRuQSRE5MljXnzY7nF5RrwqvKx5OLS2mCBexSYA+qsYzak9IwYujd0q+hwglI8NHQezlkMBK57UP6QC/Celj7+PS82Ue9nhhS0GF2xEnnZ3TNQFBUgk5zkQ+VFKLZ6DRdvPa5gLoJjK8TIVkNf5mIfZ6Uy++yDnr0PhkSY+d/LN/DhhBLxRoQKBNErFmmsMkOMJN7WcIvxhHgwneQZ/svlvR+XG6lVjYJqg43l4SP4g2tO1Hy9iJu1Z2qNKFxWRvoAIEcrTWGmum+0Y1aqzC+H4ffAzKa2P+slhpc4jDIWl/bjVeAREpgvwgf8pGxsLwkjYG5PB+aFpaUsF3gAsg3748YXEpKaIt7g1BtsQcT2WqhR3w87BwB7wh8D8AjJmnXi6T6tu2xBBRcq+IYOurYjA90loKvOwDkvQvMg8QJIxZ1RpnckrpeUQayvmsjmV/TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(52116002)(38100700002)(38350700002)(4326008)(1076003)(44832011)(7416002)(83380400001)(66946007)(26005)(6486002)(8936002)(2616005)(8676002)(6512007)(6916009)(956004)(2906002)(66574015)(478600001)(66476007)(66556008)(316002)(54906003)(36756003)(186003)(86362001)(6506007)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEVuZjUyVkhiSTVIU2pwbWdMR3VNL3ArdlUzZ3lrMkpEcG5BOGdiNFhlYTVM?=
 =?utf-8?B?OUdTaXprd3h0TUFQK2RzcEMrRURZU29TMWEvNHI5UndIcHNGNkNJRnF0dUVX?=
 =?utf-8?B?QktGV3NQTHF4RkRJUzdKVHdvemZTNjMzNXRCMzc5Mk9BTDl3bHg1NCtxUzg0?=
 =?utf-8?B?NGdHaWEwVzFCQXBIVEtKVGVubitnREhBVzRidzV3QVdRcGMrQWN6NmRNeWRa?=
 =?utf-8?B?UlZlYkk3VE85ZC9TY2pOeFNyaUxLa2lNRDlRNlZLOW4wS0JmeUZvVzh0aFIx?=
 =?utf-8?B?MmtOVzJpWlQ5ekNrelhxREkxU1ZPSUVFaS9XZkNwUnUzWGk0cHJGWTFnSUZy?=
 =?utf-8?B?bkc3Y1BsTWgyQkpBNFZTdVBPK0RVRFN5MjlpRVVvbmhicFhEQUl1YmJJWUsy?=
 =?utf-8?B?bE9wWjBZekRiSkhQZkZsYnZzZWZISm9WWWsyMTkwREN0cnEwVzQvaWFpNExx?=
 =?utf-8?B?dWRDTXpQNG5RVWhhY1BzeHRoOXE4YmVxajMyT0VDeHZHai8wdkJpUEg2Q1Fs?=
 =?utf-8?B?N2JDdFZDS01FMHZiOFNWL2xISlErTTBRRnRhdkp4MFhpeWVHUHlXQ09EVGwv?=
 =?utf-8?B?WEZtR1lCamU1SHVmU2M5K0lJblpram9oVXhmUkI0d1dsN0JiRmtMaVVNcW1S?=
 =?utf-8?B?MWtVaXdlUW9SSG1pNm5DRisxcEtvM2xWWktPQlBHWjFHaFJ2aWtNdGdzMVRa?=
 =?utf-8?B?d1NvS1YwZXQyeUpOeXpvU1M0a1ppaEVuRUNmWXZpYWl5RDNBTS9oY2o1akJC?=
 =?utf-8?B?TTFtdnRDYlloZTIybnpoNnRURXVpaWdSREthbFd0SnVjMDIrRUFHTXkybTFs?=
 =?utf-8?B?UGc2VmZHdkxFOW0vQkJvWGRFMEVsdWpwcHZ6T04zQWRhajBPYkZxcjRNWnQ0?=
 =?utf-8?B?cWZZcTAvOHZuTFVOcko2eTFBQnZJZjN6dXNXVCsrSmlkYWpZMkFMOGFiam84?=
 =?utf-8?B?MTJCR1cxem1Mc0pRYlNLcU5qdm9NcE00bEhUS04zbTdWVDRCMWI5d1ZlU3V5?=
 =?utf-8?B?NnFuQVJmRjFjL0VEZG1uMzJYamFmTTN6em5QakdWeWtObHFncHNCblM4dUdN?=
 =?utf-8?B?VnZEZWNDbXBkRTJsOEVKQUpzeHJVdU92dDJyQU1wMHk4TTFTNlFnSStFT3N2?=
 =?utf-8?B?K0g0ZjNzMEdGWFRYTHZ2RVJSRlVSWGQwT1RrNWpYdHpzVzQ3Vng1Q3FleDZl?=
 =?utf-8?B?cWZwT0gxNXBQVEp1d2hHOTZrT3pYdXRPWFpOQ1BPVVJPTktJM1ZLSC9hZHRU?=
 =?utf-8?B?RW5wS2tHT0Nnc0pScVVVYTF5MEdqVmwwT20wdEVwWmc1R3hsdGNZTkVZL25y?=
 =?utf-8?B?eFk1WlNXOHhubVB3SFN3VjNDQXBGdUxCUldOdG40KzZCYWMrK2I1Smp0cmxD?=
 =?utf-8?B?dnY1b0J1MWJFbTBnbHJLcUZKYUY3NVV6Mnh5V05iRjFTdjhyTnAweXhsQk5y?=
 =?utf-8?B?ZXk4ai9uWUNEQVptejZTcU50SUR6MFdmZEM1UnExUVNqVDVseE1UVU9QV2F1?=
 =?utf-8?B?Y0dnbFVPKzRxOWQwRkhydU9jZm1GNG1YYS9aeFVWeVJPSTBOUzd5SWkwWHU3?=
 =?utf-8?B?ajRSRXNpZFZYNDZRSFpPZmZINmlpVE1FRXo5eE02dVM1ZlRldUtqUllNZUVF?=
 =?utf-8?B?cnJDZWc5d3RZRHpDRUlXazd3Z0JvLytuWEh6eHFlcFY4KytEb0RLNFVKa09M?=
 =?utf-8?B?Z1JRT2EvUzBEblA3V3Jrblc0aHpBdjVTTGhQVU9mcEdtbFN0anYyc09oUncy?=
 =?utf-8?Q?4a+YL6LoWGem9z5FBRkD2CfxNPyZN456kE0Dcoe?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f46b65-c2ae-474e-c55f-08d97c7f9349
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 21:42:42.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06wUz0y9XOPTAZc3wisqQ1mawgRvXIN+j/DvcmEcycpq0ahR4lPXqkwnOQ6o4MYMXOxBuM7LGYAMYgTn/Yz1nA==
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

In this case, the Realtek drivers fall under category (b). To solve it,
we can register the MDIO bus under devres too, which restores the
previous behavior.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reported-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/realtek-smi-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index dd2f0d6208b3..2fcfd917b876 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -368,7 +368,7 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi)
 	smi->slave_mii_bus->parent = smi->dev;
 	smi->ds->slave_mii_bus = smi->slave_mii_bus;
 
-	ret = of_mdiobus_register(smi->slave_mii_bus, mdio_np);
+	ret = devm_of_mdiobus_register(smi->dev, smi->slave_mii_bus, mdio_np);
 	if (ret) {
 		dev_err(smi->dev, "unable to register MDIO bus %s\n",
 			smi->slave_mii_bus->id);
-- 
2.25.1

