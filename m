Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B7264C7A4
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 12:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiLNLCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 06:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbiLNLBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 06:01:49 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116E2248F5
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:01:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2WUPqAh7GCcO9x06M16Z1oCCHRkCZJszgRTMZ5RCeKTocYWxrWKlpHHAv6H4ibium27I6QIhbPgcoFwiC/96XemC9dS7Xf/y5VdXnce4PRqkT8MEaMoxhkpA328XFuIvwDOWeMgFkJ0BG68SWyvFYGwVvCt/9itaLDGXBME0FcoiQ676sQ5pTFsQ6MVuC2iVntC2O4aW5gVCVVBPIXlCw/LUjuhkAsa89egeDRlkViKlCKrOddRLbg4YmHromJHbJ3WGD00UYO5anF6onFl0hycyjb/GOVoRrSgGYODDa57dSRUDlCc6gqprlt1aRxPwXIzG75qspOwpSfdPxlLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COUXadaezfNODZJHvCIpyXuBgf5ws0Waq4Vt5l5Tfdc=;
 b=WpIMiZbtVevP7zQGUsYT4oiZSTxwU6FC6ebRmBfIqN5XvmtqWXBUfFi9AzrvyMuEhICfYho1bwBZa90UuBTZghpvIONIAvY6QUa72nWnCWpGI01YVC/3pr6Zb9u0oVWYdOAAqbzuK6ICbCQkS9WGQ/LTHbcbBi+Kd6Xap7Vji/IElzkRLuY6FxeBhJ3CD6sqC2pZBqw6G9Iq8DLQzEMurPb68iTnKxI7x+hlEe87puZ1LUTZnq4f86F7Y5g35e0XaY+GsWlbocPVN/C9hXOms8ntLz1ULBiA7qIYKvJt9JTBut3i2kFmqIzpTxEh3hkrqJM33jkhixzRk1XgV+A83g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COUXadaezfNODZJHvCIpyXuBgf5ws0Waq4Vt5l5Tfdc=;
 b=T/RPif8LT+fdu/hVZA6OxHT9Np6d/V2GXXqDbCnN5dZGFrqauB37zDkBhg70JKALj6kj7NpsEOFTi/t5Ccx6NLKWe8ZtUaSOe8GXQ0ujLMTwiaWw7Jf/aoBMIVoopXYkYfJWVTvcyds/qQFMtQ9Hb/c9UBAwvpHHwozQUvh5/dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8447.eurprd04.prod.outlook.com (2603:10a6:10:2be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Wed, 14 Dec
 2022 11:01:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 11:01:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net] net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()
Date:   Wed, 14 Dec 2022 13:01:20 +0200
Message-Id: <20221214110120.3368472-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: e89b5ab4-6d8c-4ec0-0e9a-08daddc291d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /gGYZ/jPAxOYBt0medktBhDcy3t6NwtayMNpwOZp6WjpWvezrUzc+U3yj5Nf816Lc5+m66MSlCQDYok1ZPVO57dudExp7pybs6YWAdwzDR0TNuHy6fbW+WBTz7twn4bztE5iLnzdspRtMn3FXS5gkuqRneWU5bA9D5XogjqwnyhldkhUMAIk1wt5Ti6KTXBWq4MnJulpMokm51ZEzNPQLIbvMjgZyATio6DtFsTKaPZigOf0C1QslSLKdW5lbuzVaVTvybpcknsU+NE2APWI8q2h0Ps7mzQ+mJu0F3Ffd4lqYZI677/xshl0e9ahOMZbL+doQLMvAPlWkFZh7NxEjdtYb2HuTWWc4ozflJZb+8oY2aTYKnHZ7CwuZIz5vWe/DxFfUHuOHnP3JkCpuu3P3Pqx9RotOr/+5MOwL+8KZc+ovLrTLJDyrQoZ9kEjDA7Bt+qPYGtmQwz/XXQHrrUQYJ15yqnXCiLzuTkSLkTfr3hgi/B1oN6kv9DOhWHnJEsT8CMPlMR8cwjx1SgGhMnBJwFlAyTm8GzEezpmT4cpZ8TZ18ITBw+9aq/TOvjKgQuUAItKpYLBD9zPgfcLeOq3y61g7vzwE1kozMaXrqco/0XSw58S0ZS3/fE/ZYlsuuX2u2YtvHrySYw8YOxLIiLlsa0JR+GmGPMPQQzoITEcRiy5gwOezKgTdIfuCivW9l+k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(54906003)(52116002)(6506007)(6512007)(316002)(478600001)(6486002)(6916009)(1076003)(2616005)(66556008)(4326008)(6666004)(66476007)(26005)(8676002)(8936002)(38100700002)(44832011)(7416002)(5660300002)(83380400001)(41300700001)(2906002)(36756003)(186003)(38350700002)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?davcMLBE7+xnfzHrQYvrEwG56FZz/rKpTYbeDt6M8YY2PLOdSMWS98d5dlOk?=
 =?us-ascii?Q?gPKsBvQkIZkgaev8ZMOKW14G0GUshhWsyLPw86rh2UhgW/uBqPH/ee8r711+?=
 =?us-ascii?Q?Ic1UGwe+eM40EbGUCKDJ1FlTaARK1pqXaRKwljGnQeGyeh+qeNCEE7tDHQ7v?=
 =?us-ascii?Q?H+amB1/yPgOboAvpQfjwrEOYleBAPwFqxfHJHeDtq44y78IMTHYmrhNrQ2Dj?=
 =?us-ascii?Q?P2GP+RiYlCQL6JuFlJmgGDyo4jWLjejMRGu+Y5MyBjBCdSzHpBO253SRRn7z?=
 =?us-ascii?Q?ZQUozQejYJ8WAI58lpn3GN0MlAYhCMiv9I5eLZO3+ZrOayE//rYAP0cayvHG?=
 =?us-ascii?Q?bJe9y8FHA0BXnqFMXboVycH55R6kFVROzTTcQvDYIFs7n7C8aAvia3uTfZso?=
 =?us-ascii?Q?YKETBx38Gdxw3zLOxEiYaHIMt6C+nboahYtZ3pzoqqMtidmcfSkE6dNWidc9?=
 =?us-ascii?Q?p2PnZmZQfzvt3hV4b3NxxxwSGfGbHLZecdXH6gDQSKcjAS0iwI+RzQGXtHia?=
 =?us-ascii?Q?j/nzbHisqn0mkVh3RwETVsGIeTjf7lozR+v0kWzVK2BJcB0vgOQdAQiOJbH1?=
 =?us-ascii?Q?Mm7bWhiT2Ma9nldgq41qmldjpb0o4sq6NgnzpAgEijdukZU/UOUlOw2avGBI?=
 =?us-ascii?Q?IwtkltEPK2xdLPxPbPw5HjJocYpUrICnOJhKsKYjIZbfsgYNsqnkTq5lEKTt?=
 =?us-ascii?Q?09M368UxSAnWECx3fKlEHOAhyHOR2f48dmZFGVRDW9Xex68NbWgwbfzJ8lqY?=
 =?us-ascii?Q?GzznMebvuokAbdy6OPDHlQdlljD5+xwbYlu244WhwWU19qRXKUGVf6RQT6p7?=
 =?us-ascii?Q?ApMN+tAGKGuVDjedH5K5IaXPEs+c0Bz35/y/GKJGA1oEvb/8tNx/VdBcK5fV?=
 =?us-ascii?Q?26aTPgr6F5jlO0YhNaGCoihmBXGNxPXm1I4MoebLqOUQ0+kTkgO9IS44E68t?=
 =?us-ascii?Q?f5vm02jGDeqkwp87iW0H3nM32+veaTRWT4MPTz3UC36PWVaY99D0IHf6vnv0?=
 =?us-ascii?Q?M245NtkRR7dM1BUOXOoXmcsir5PUW2pXyJjW9k61zxOmHY4CMiPFX4a6Jc1p?=
 =?us-ascii?Q?aSYjc1770X8vCiM5Hwx1rmrFxUu0rNKAFX/LXeTmXAhN3yYfcMsKbitmtaKO?=
 =?us-ascii?Q?8W/ZBgyWXoSoBxLtgxJBDJo1sJVguRTd/B5S3p+QzD5b6a32/1b1sd2pq8/l?=
 =?us-ascii?Q?I77A7qFm9Fb5uTrooIx6uTdixcNxGz//z5ilf3GPQV+qf9L0bZbfj5GP7jKk?=
 =?us-ascii?Q?3tt+fzEP/SHrht6OZ2jJHD9KiLZ61A5FXdHhfAXWYbB8JDuV1Y4T96/VCkYs?=
 =?us-ascii?Q?OJEepoEBz0DY9mvQk+Ypo8rnw1hsjUUfyBYuU6+5C52zCb/VTUwpeqa5HUpx?=
 =?us-ascii?Q?m14EmcZhtKzVNWadjsdYNZeaSpwSScOzd50RGWveHo0XN7HIivynJrNqwUQm?=
 =?us-ascii?Q?tWIWBSgVJyIjk1Wj/OgL+7BHLhCP1pVbIrDxRicgyC/+KONHXFXFq7eHvJyJ?=
 =?us-ascii?Q?LyeB4O+GpjlQ+VAILDA/Vzz16c9BmJeKm7gyXK6pZ7T8tih+ulSaYI1gRQEz?=
 =?us-ascii?Q?WWD0DT76nwZaqPHDRozd0VlTFwYw+qi0Wfhe1W+kFGLKB38DWv8wWzsVihOJ?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89b5ab4-6d8c-4ec0-0e9a-08daddc291d9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 11:01:36.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjlaIXTm+B2Dj8tw7HSUg3b4EcxZO0CltbXDRuRA8/0nJ8SBn3A6dj6qUJ4q4o2DAamw9Gnn/DtnlS26GgZqZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8447
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the blamed commit, it was not noticed that one implementation of
chip->info->ops->phylink_get_caps(), called by mv88e6xxx_get_caps(),
may access hardware registers, and in doing so, it takes the
mv88e6xxx_reg_lock(). Namely, this is mv88e6352_phylink_get_caps().

This is a problem because mv88e6xxx_get_caps(), apart from being
a top-level function (method invoked by dsa_switch_ops), is now also
directly called from mv88e6xxx_setup_port(), which runs under the
mv88e6xxx_reg_lock() taken by mv88e6xxx_setup(). Therefore, when running
on mv88e6352, the reg_lock would be acquired a second time and the
system would deadlock on driver probe.

The things that mv88e6xxx_setup() can compete with in terms of register
access with are the IRQ handlers and MDIO bus operations registered by
mv88e6xxx_probe(). So there is a real need to acquire the register lock.

The register lock can, in principle, be dropped and re-acquired pretty
much at will within the driver, as long as no operations that involve
waiting for indirect access to complete (essentially, callers of
mv88e6xxx_smi_direct_wait() and mv88e6xxx_wait_mask()) are interrupted
with the lock released. However, I would guess that in mv88e6xxx_setup(),
the critical section is kept open for such a long time just in order to
optimize away multiple lock/unlock operations on the registers.

We could, in principle, drop the reg_lock right before the
mv88e6xxx_setup_port() -> mv88e6xxx_get_caps() call, and
re-acquire it immediately afterwards. But this would look ugly, because
mv88e6xxx_setup_port() would release a lock which it didn't acquire, but
the caller did.

A cleaner solution to this issue comes from the observation that struct
mv88e6xxxx_ops methods generally assume they are called with the
reg_lock already acquired. Whereas mv88e6352_phylink_get_caps() is more
the exception rather than the norm, in that it acquires the lock itself.

Let's enforce the same locking pattern/convention for
chip->info->ops->phylink_get_caps() as well, and make
mv88e6xxx_get_caps(), the top-level function, acquire the register lock
explicitly, for this one implementation that will access registers for
port 4 to work properly.

This means that mv88e6xxx_setup_port() will no longer call the top-level
function, but the low-level mv88e6xxx_ops method which expects the
correct calling context (register lock held).

Compared to chip->info->ops->phylink_get_caps(), mv88e6xxx_get_caps()
also fixes up the supported_interfaces bitmap for internal ports, since
that can be done generically and does not require per-switch knowledge.
That's code which will no longer execute, however mv88e6xxx_setup_port()
doesn't need that. It just needs to look at the mac_capabilities bitmap.

Fixes: cc1049ccee20 ("net: dsa: mv88e6xxx: fix speed setting for CPU/DSA ports")
Reported-by: Maksim Kiselev <bigunclemax@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ba4fff8690aa..242b8b325504 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -689,13 +689,12 @@ static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 
 	/* Port 4 supports automedia if the serdes is associated with it. */
 	if (port == 4) {
-		mv88e6xxx_reg_lock(chip);
 		err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
 		if (err < 0)
 			dev_err(chip->dev, "p%d: failed to read scratch\n",
 				port);
 		if (err <= 0)
-			goto unlock;
+			return;
 
 		cmode = mv88e6352_get_port4_serdes_cmode(chip);
 		if (cmode < 0)
@@ -703,8 +702,6 @@ static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 				port);
 		else
 			mv88e6xxx_translate_cmode(cmode, supported);
-unlock:
-		mv88e6xxx_reg_unlock(chip);
 	}
 }
 
@@ -831,7 +828,9 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
+	mv88e6xxx_reg_lock(chip);
 	chip->info->ops->phylink_get_caps(chip, port, config);
+	mv88e6xxx_reg_unlock(chip);
 
 	if (mv88e6xxx_phy_is_internal(ds, port)) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
@@ -3307,7 +3306,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		struct phylink_config pl_config = {};
 		unsigned long caps;
 
-		mv88e6xxx_get_caps(ds, port, &pl_config);
+		chip->info->ops->phylink_get_caps(chip, port, &pl_config);
 
 		caps = pl_config.mac_capabilities;
 
-- 
2.34.1

