Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A0B63431A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiKVR5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiKVR50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:57:26 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5DD657E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:56:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf3Ap+hGghY+bED8U8WzaRM5uMmLlAYakBBGS0UOe/g96lj4T0A+ztshaR8TXiZ+dk+hV3Bq1xnEFqdrElXXIKCArfERtImOSm2OWhel57IXSwj7vJt8bP2zDkayRCFXOIGK35a8blJEzYf5+IY+uyA61Ho11+V4ekp+vBjeLF/4YafwqnVb1lRtuj5ssx9iw8tr5pvQUlbZ4Q00kX5Hky0KcKJ1FEKOitUbxvsNNK/wED8oRv0SiN1O/K2qOu73bwFk6OOz/2emYRbKz7APmqOeaMWdGfRuNRP/nQ8KGBsKAi0/BLkNuwKuSnKDtgZFznlTU8a6U/19G9jJE6lAmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNKTX9vNsAh9GK/zccHR9jHivlNbwHRHBxm5jDz6V1U=;
 b=SQT7qUDrhCpW2XvI7E5qi+IQ+hL2JYdnqg7oJK3wHOssCZvpjUodDCEypsyYoYL0vsV8Xu9Z9HmM/h37+M+qvz+fOG+lypUq7a7cLiAz9APiARhwX59wzra8Ex73dLlj0+A47LygR3iLKQxfIT5r3vU8B2ehwNanFjNNweUfgZ7W+CuBS6mIb569MlzRx3Hfwo2+RMTNQPB0PoNWxUvWARHa8kHifKnKYeKCAw5ndBy3iD8OSO7psApCrHMwoHPPteUdRurppRe8b8LpETF5l3DSIx25YhxwFo1/2+DqFSol+UIw/J81DQnSAI/pDxiJt0h7xGnZaeczZEvmu7b57w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNKTX9vNsAh9GK/zccHR9jHivlNbwHRHBxm5jDz6V1U=;
 b=N7wByFHzMt5KuLxk5BgQSaqAtlMU/ay5Zz7+PWZfmvzN2hTxUB2v4/xhqihocR1FRW/8vp94HSUzJpnYMviGFWZAx/o4YPQzw1CmgU5zGWqUymOvi40oOn/2WeRLNPwm4N9cKeslfvVVPAqmkyMzP0dx2uy2r7iX2J7WW9SlVnI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7766.eurprd04.prod.outlook.com (2603:10a6:20b:2aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 17:56:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 17:56:29 +0000
Date:   Tue, 22 Nov 2022 19:56:25 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <20221122175603.soux2q2cxs2wfsun@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 56fb9059-2b4d-4f9c-22cc-08daccb2e1dc
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNWCbA6yv2z7dycoIc3sWB9W9Oa+MqGM8+XI/dCPAVhzqzwnUGn1+MHzomsEH2QNRnze9hAc1NcfIBsAIg1nYnFvEwZry9C1Y546p0qScrnwhG93Ksa1LBMoluFkG9qsBjTiIP1nnOpviXjLjJUAjIU5N7vt5/+cZWdXsOEvFrRECTgQQxwAVAKG39Tu3c8mN4rw/eq+Bubxi6bvQqHbQxV1UXMd7hgQ4C93G6gGmwRgovM7BwJvb6hTxlHn73b1s1o/Z2UIxKxK5gz7OGOdoXJciuzihHxa+88/O3bW6wGaU+HPML3nv1ANgHSxp41jP0uDctsVl2ze0izDwjaBwDBjwaVQt6165Q9WiPkNqX69ti+xFEo8OotuP6BBdUduN83TD09fSV5y+xhmH+oHAzNvLcLiN9UCNchl7v3o3dpl6ue4m7+/bk5S7CVyiy8c+GjbURTddWXufwEimOZOynEqBvG+AEkugLWHCzpw6V3Zwiqhr9Bgz/cQY3P95pX98K5/vZlVcLCLXwra5+7K9gsHg3wrO2ss/l11r9G9zO7PaoDcVT3pWTV90/knBmQC5bpjOy/xYui9ouBvycqhqhvIxnc1V0b65tnDYRZx1L28kE7dGNEq93iNufSV/BCgiKZYxXTWK2XEO+02L3mmmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199015)(6486002)(26005)(2906002)(6506007)(6666004)(86362001)(33716001)(83380400001)(478600001)(38100700002)(9686003)(6512007)(1076003)(186003)(7416002)(8936002)(44832011)(41300700001)(66476007)(66556008)(8676002)(4326008)(6916009)(66946007)(5660300002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UP/sFqQttQoqras0d/rjl+FFW7AwH3DRGcnN6cqIkzPkFF8hR/mcZvDX8Hsc?=
 =?us-ascii?Q?ET4KIAX6vVk4gyp1NCyhbi6n2XCoJ5cff7oUdEFEREp4daCgMFwSTZns2AMw?=
 =?us-ascii?Q?+P+dZ6p9OmfQrJ7AmHqP+cN0WEj8zOJbuv+ZkNFcLh5lHGvq7OR9sfdy4f6l?=
 =?us-ascii?Q?nnUIEJxuRnMRXKE3jppdTsRUtXlVV4J0XCH1lAf4gpRXE043AuiOouC2qwSk?=
 =?us-ascii?Q?tqRUnnWDLM4E29Evn57PpkN0CX7LhiaqOygCFxz3NeXF0gjPrb3iNjS8CIBI?=
 =?us-ascii?Q?qa5mmDcY49RoU6URmiJtj5T4GKIphgQEcL4bcrHF0BbKCSlOistlHZPCeo0N?=
 =?us-ascii?Q?+0KREqljcQEt4y71bOzLm6d1zbnnLsU60VX4+GecM8dvY/E5XE80yhdesGL0?=
 =?us-ascii?Q?p1YflcpITPpY5v0f03camVvmYPupNjX14m7R+r8KjhzDyW2EdZgrPg5Ll19/?=
 =?us-ascii?Q?htfCbm8cO1x0yc9v8vjpaeF98nzDQVEbuGtbFRjo3VmApNtwWzvnXnjJ6sbl?=
 =?us-ascii?Q?jTB08DgmncKL3SDJ2A+ZTmaBPn8EAZZ6LdrrqrlxJnLP6/LuspBwWy36kMjF?=
 =?us-ascii?Q?WgPFQSzxJ/FUAwyW5K08JbnBzxtMYIlZkDzjaBV98MCSWb25Y7KwEjtkN1HJ?=
 =?us-ascii?Q?Hjd5dasOH6mLCnLfW17RU3nLYShcTs0JIXQBebRphU7nt7ZGo60P2K4bs5bB?=
 =?us-ascii?Q?1FQIZad7PzC9+kNjzX2TZYdO9tnl8VuzUOisHNplW4P7XxcTcx61LhnNw8i4?=
 =?us-ascii?Q?LBk8dIMqff/Ts4bJzXVjtl3UrakziihOYq3gLSHpMYq9QcgcVeeqiO9KgNZT?=
 =?us-ascii?Q?fuvKgIcfGHRm/DxFNzEqbPHy6BODuzPAV5cshim66z6o9EKMXUQKwDzYsbZc?=
 =?us-ascii?Q?o55OFJgVCReaV+7vMh0Gwo8m/dkgtyVrEN1cLJlVy2Par32x2x1VNoqQceyd?=
 =?us-ascii?Q?hKEm2vz4G/Fs4eNKKSaSo+Qvvcf7bKVpzLbJKdc+oEfQAuAkF3cQn3mBGHI/?=
 =?us-ascii?Q?GEPPy4AlXSfxxN8nltbBYMMSvkZFfGbxleR4IhluQBPCW7j71yKZUbjnKDrP?=
 =?us-ascii?Q?HbUo6IN69Td8zNSu3t236byKpPmR5JVFOLBBKOXKsT9N8QYF6ilDoqVGiili?=
 =?us-ascii?Q?fpd++UjXJZhAJoPE/EwmgV3ClNleZiIPyS9DZPm0P5GxuPvG4+Jevh9SHg72?=
 =?us-ascii?Q?HZaiZO14jbOfIAXuQwV16pD3mb1LJyOiV5ohXLsrgrQxvC6QANAJZFcARf3V?=
 =?us-ascii?Q?jnk5mqw93IdcDMXiLqCHxJ/DoFCik6yUOFMtCFG7H6H+8i9qZbuprMAA2Ymk?=
 =?us-ascii?Q?y9rrEbyDUHZXkUbWfvBGyl5K4E+w4PU7K2YXI8a82edKDq7t4180ZbjTSWXS?=
 =?us-ascii?Q?Lk0g1iygSO1jLvSzlfJKbX6cncD+SkhyyFuHx+EZxBKebeJjukUuuO9T021q?=
 =?us-ascii?Q?xosJU4NT/HeW1GPPUMVdaCauYibbRRjh9k5hwpKf702IIcYlQETaOAL2tYbF?=
 =?us-ascii?Q?wza5hPMe1o91Mx78/SDdAxNqZoH1FTdoStS+1uwF5CMereSCI5cSou5rd8g4?=
 =?us-ascii?Q?S2s/sgu4mlgVxCZSG6uHygJdC97a3rZWZYxiZlPcMShkps6eOBvsDqXtL7ej?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56fb9059-2b4d-4f9c-22cc-08daccb2e1dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 17:56:29.3923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: leWt9sRs/kwVxKsEo4LYLhxuX7+Kb5uUJsJwfm1O0ljE0zykNzmIESXjBMn04Mwp+Po76MzwWC0F0s7iQNhzvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7766
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 04:58:45PM +0000, Russell King (Oracle) wrote:
> The intention of the above is to report how the PHY is going to behave
> with the current code when the PHY is in operation, which I believe to
> be the intention of the validate callback. I'm not proposing at the
> moment to add the config() part, although that can be done later.

Again, all I'm saying is that with validate() but no config(), you should
report a single bit, not PHY_AN_INBAND_ON | PHY_AN_INBAND_TIMEOUT.
The code which you posted does report multiple bits, and we won't know
how to make sense out of them. We'd select what is the most convenient
to us, and we'll call phy_config_an_inband() with that, but it'll return
-EOPNOTSUPP, which will be perfectly reasonable to us. Except that the
PHY may actually not currently operate in the mode it reported as a
supported capability. So things are broken.

> As I stated, with the 88e1111, if we are asked to operate in 1000base-X
> mode, when we configure the PHY we will allow bypass mode and I believe
> in-band will be enabled, because this is what config_init() does today
> when operating in 1000base-X mode. If we add support for your config()
> method, then we will need a way to prevent a later config_init()
> changing that configuration.

If config_init() is going to be kept being called only from
phy_attach_direct() -> phy_init_hw(), then, at least with phylink, we
only call phy_config_an_inband() from phylink_bringup_phy(), so after
the phy_attach_direct() call. So we overwrite what the driver does by
default.

The problem is not phy_config_an_inband() but phy_validate_an_inband().
We call that earlier than phy_attach_direct(), so if the PHY driver is
going to read a register from HW which hasn't yet been written, we get
an incorrect report of the current capabilities.

I'll see if I can fix that and delay phy_validate_an_inband() a bit,
maybe up until before right before phy_config_an_inband().

> 
> For SGMII, things are a lot more complicated, the result depends on how
> the PHY has been setup by firmware or possibly reset pin strapping, so
> we need to read registers to work out how it's going to behave. So,
> unless we do that, we just can't report anything with certainty. We
> probably ought to be reading a register to check that in-band is indeed
> enabled.
> 
> Note that a soft-reset doesn't change any of this - it won't enable
> in-band if it was disabled, and it won't disable it if it was previously
> set to be enabled.

Similar to VSC8514 and the U-Boot preconfiguration issue. Soft reset,
but the setting sticks.

> > If you implement just validate(), you should report just one
> > bit, corresponding to what the hardware is configured for (so either
> > PHY_AN_INBAND_ON, *or* PHY_AN_INBAND_TIMEOUT). This is because you'd
> > otherwise tell phylink that 2 modes are supported, but provide no way to
> > choose between them, and you don't make it clear which one is in use
> > either. This will force phylink to adapt to MLO_AN_PHY or MLO_AN_INBAND,
> > depending on what has a chance of working.
> 
> Don't we have the same problem with PHY_AN_INBAND_TIMEOUT? If a PHY
> reports that, do we use MLO_AN_INBAND or MLO_AN_PHY?

Well, I haven't yet written any logic for it.

To your question: "PHY_AN_INBAND_ON_TIMEOUT => MLO_AN_PHY or MLO_AN_INBAND"?
I'd say either depending on situation, since my expectation is that it's
compatible with both.

Always give preference to what's in the device tree if it can work
somehow. If it can work in fully compatible modes (MLO_AN_PHY with
PHY_AN_INBAND_OFF; MLO_AN_INBAND with PHY_AN_INBAND_ON), perfect.
If not, but what's in the device tree can work with PHY_AN_INBAND_ON_TIMEOUT,
also good => use ON_TIMEOUT.

If what's in the device tree needs to be changed, it pretty much means
that ON_TIMEOUT isn't supported by the PHY.

Concretely, I would propose something like this (a modification of the
function added by the patch set, notice the extra "an_inband" argument,
as well as the new checks for PHY_AN_INBAND_ON_TIMEOUT):

static void phylink_sync_an_inband(struct phylink *pl, struct phy_device *phy,
				   enum phy_an_inband *an_inband)
{
	unsigned int mode = pl->cfg_link_an_mode;
	int ret;

	if (!pl->config->sync_an_inband)
		return;

	ret = phy_validate_an_inband(phy, pl->link_config.interface);
	if (ret == PHY_AN_INBAND_UNKNOWN) {
		phylink_dbg(pl,
			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
			    phylink_autoneg_inband(mode) ? "true" : "false");

		*an_inband = PHY_AN_INBAND_UNKNOWN;
	} else if (phylink_autoneg_inband(mode) &&
		   !(ret & PHY_AN_INBAND_ON) &&
		   !(ret & PHY_AN_INBAND_ON_TIMEOUT)) {
		phylink_err(pl,
			    "Requested in-band autoneg but driver does not support this, disabling it.\n");

		mode = MLO_AN_PHY;
		*an_inband = PHY_AN_INBAND_OFF;
	} else if (!phylink_autoneg_inband(mode) &&
		   !(ret & PHY_AN_INBAND_OFF) &&
		   !(ret & PHY_AN_INBAND_ON_TIMEOUT)) {
		phylink_dbg(pl,
			    "PHY driver requests in-band autoneg, force-enabling it.\n");

		mode = MLO_AN_INBAND;
		*an_inband = PHY_AN_INBAND_ON;
	} else {
		/* For the checks below, we've found a common operating
		 * mode with the PHY, just need to figure out if we
		 * agree fully or if we have to rely on the PHY's
		 * timeout ability
		 */
		if (phylink_autoneg_inband(mode)) {
			*an_inband = !!(ret & PHY_AN_INBAND_ON) ? PHY_AN_INBAND_ON :
					PHY_AN_INBAND_ON_TIMEOUT;
		} else {
			*an_inband = !!(ret & PHY_AN_INBAND_OFF) ? PHY_AN_INBAND_OFF :
					PHY_AN_INBAND_ON_TIMEOUT;
		}
	}

	pl->cur_link_an_mode = mode;
}

then call phy_config_an_inband() with "an_inband" as the mode to use.

As per Sean's feedback, we force the PHY to report at least one valid
capability, otherwise, 0 is PHY_AN_INBAND_UNKNOWN and it's also treated
correctly.

> > If you implement config_an_inband() too, then the validate procedure
> > becomes a simple report of what can be configured for that PHY
> > (OFF | ON | ON_TIMEOUT for 88E151x, and ON | ON_TIMEOUT for 88E1111).
> > It's then the config_an_inband() procedure that applies to hardware the
> > mode that is selected by phylink. From config_an_inband() you can return
> > a negative error code on PHY I/O failure.
> 
> So it sounds like the decision about which mode to use needs to be
> coupled with "does the PHY driver implement config_an_inband()"

So do you recommend that I should put a WARN_ON() somewhere, which
asserts something like this?

"if the weight (number of bits set) in the return code of
phy_validate_an_inband() is larger than 1, then phydev->drv->phy_config_an_inband()
must be a non-NULL pointer, to allow selecting between them"

> > If you can prepare some more formal patches for these PHYs for which I
> > don't have documentation, I think I have a copper SFP module which uses
> > SGMII and 88E1111, and I can plug it into the Honeycomb and see what
> > happens.
> 
> I'm away from home at the moment, which means I don't have a way to
> do any in-depth tests other than with the SFPs that are plugged into
> my Honeycomb - which does include some copper SFPs but they're not
> connected to anything. So I can't test to see if data passes until
> I'm back home next week.

I actually meant that I can test on a Solidrun Honeycomb board that I
happen to have access to, if you have some Marvell PHY code, even untested,
that I could try out. I'm pretty much in the dark when it comes to their
hardware documentation.
