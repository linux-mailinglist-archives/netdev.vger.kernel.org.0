Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568616344B3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiKVThL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiKVThJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:37:09 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5D72C10D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7DWAHwyyJTbK6rKnVnCYf5vciymuBynYVi+Xg/LwYp2gIQSt8N7JBPKwkL9LEFAQQ2y/K6o9vyQ/ao0Di1nU6K7P7SnptggeOSTXOomFNnYmcWOZgWgst4F22RlwkCgPXeC/8FOww/nLSkPVQf74YF/Usqp70fN7ImZEytYAz6YXfhuDQ7r1H3JvlPcgmZ3PzBMMH1OVldsDmH8hs5cuyp4EQqujypZ129XA3e9nB8jU4TxFRnYoV1pxVR+GdL378uzaP2N2djjsauEZd2Wd074VH/6jRsNgu0KqyfpJa+cQMIbN0euF4r5rj65Jcua2qy4ueHfJivBxSAZHp7E5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8u/1uYdF4KFl6fNlMkUbRgvo5NjTzplHrVKF/gJzws=;
 b=O6ZuXKEZSbHYS9/HRIgHltS5IowDXuB/Jp2tt5hoQybA+dgxg6fxcagexMjOZN3dpPUaz0nrFdwo6vHGJYoXUCSp8xD9HVuJaTMKTXvs2dT2I0g44TBO1DEtoi3vtT/jRIOspzAkzQ2PIWG+PnsAc3Psaoks4YaGhJCcVB6cBvoKLnaTipQEUt5bh5WfoP1/9w18kYqO4bcXkMvDiBwxHvYhYuUnycAhwv9PyN15YChEw99l2dIgekqOKOXHCmGo49FguB+BMttkzxOCltMecXMP4jchwODA93ZGRFoULcJdg+BGnAecJS13fzVqSBBMvYfwiQqN3chQ1BUBuBG8Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8u/1uYdF4KFl6fNlMkUbRgvo5NjTzplHrVKF/gJzws=;
 b=O694F4S9ZI9y02Kvon/gf+u8ngLJkX/F/c29rIOlXMXxHOFcU88soTq7d5gBkjnEqRSQWDYpcZMH8DHrAL3wjcj7TCUZdEaoDYVq4lIRtRwFjFSTqgeGpqI4b+DfX5/aoT8EXeaauHQTSPzi8Jc90t2Mvwu77/aIkaPJBNnSc2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7499.eurprd04.prod.outlook.com (2603:10a6:10:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 19:37:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 19:37:04 +0000
Date:   Tue, 22 Nov 2022 21:36:59 +0200
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
Message-ID: <20221122193618.p57qrvhymeegu7cs@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
X-ClientProxiedBy: AM8P251CA0018.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBBPR04MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 770fc80d-2abb-4874-c6c0-08daccc0ee79
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6muApUvxujh8VMgDgrSU/Xz4OM2zrMk9rjN8ac5D8w6UYhpf0J+kcl0Oj7chyMTat7s3Na1wmC2ii/kdSkmMiJEtXmdn8ijuDn8akztnsN6XvLU0pynxj6PnxhzgjQrSs5xRKE3+l1GSsGn004UL8BRNdT5J0a/aKp1gi1pyPRit6Fl1YoquCRla855J1M4ldjwaKXwQ/zgrTJuvm5hvJ/OL+hzkOdUP2Wj+PQj0z+a0IrMdurjkV9ZXZhN8viBm60ewpUhOzzq4t72A5o+qcV4tNC0QILJx71UnEDSXcfGP/MwqqjRsTQmWKM7zyPH6zTnnucukuQy/QqasIooFkv0T2G0LA7ghLmdjG9h82jgjCRj/YbhPeIH9q3lINE12Oqez9aQsxPRFu68Va3ap/KRgNhlWKIodDUjyJcB/0qvS8mEIL1ZmMTSkWH0IIFx4JEg87ZW0sns57tMCXIAZsMGdamVKEbMrNmpWIdZ9Zrav2dQMldplimlD/iGCWtvbrDHq9YLWuAGzZpt0H3eoMxV8Sav+vR9tEY0a5/GnUMDl2EaRQAmah6EU0XsbP7XATlkKxoCL5ismilwiHRFsqnbmRMn1XGhFICYGNDzUV6ARH/MnINRefydyGI3tmqCWJRy2f76ErYjOx2kYD888Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199015)(6512007)(8936002)(9686003)(186003)(4326008)(5660300002)(7416002)(26005)(6486002)(44832011)(478600001)(86362001)(38100700002)(1076003)(316002)(6506007)(54906003)(33716001)(6916009)(6666004)(41300700001)(66946007)(66476007)(8676002)(66556008)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aaXUsxi2/oxnvrZWIb0UUuuFBCBhlwGVxX9rleLPT3pqBu+lRmaETKrxt1eg?=
 =?us-ascii?Q?vCgrxVoXkBqWw8GJuWU4IALEDirWlxF0DQwN4fql6+iX3FkQ9vEnjG7OqDCz?=
 =?us-ascii?Q?GB0Xoar0Joba1M4oS2SSBNzJkEBOqJ/0Isi/cFDxrqDClJ/HLGgBAfY5PigA?=
 =?us-ascii?Q?wMh0b6FscIbmF2BXcuL+0XuTkEZHyCQau1/A+qHLA3XwHKuagNPkbQBk+ZH8?=
 =?us-ascii?Q?23Um2NoIjaHLKa9J1ywiOjHo9n3miKFHx6QhEf0K8v+SHJU25HpdMY5/IEbp?=
 =?us-ascii?Q?vlpLZzHaNE2nm2RuMBpzun/eSyvd3PSo/0cSF7Cgw/e1oR/xwe+ogdTNTkI2?=
 =?us-ascii?Q?UrpVfCdBDtOoDDZUqpDCTu+GgwX4W1L/9QoKstt4bsOIjPgVUuNhwCyABlvP?=
 =?us-ascii?Q?iMoEtkqeidr9i2P0MPfzeEqlp5Sk0qNAAsBz3wg9/57cpbH8Sw+uJ3eMn6Ld?=
 =?us-ascii?Q?neGytUvGzCGPDH42U74tqVQ5C7csizCuC47VehT/VY2zxDmUZgZ+OQCh9YwB?=
 =?us-ascii?Q?SiLVHgeAmmbg3GJx9f9AuUGeG7D+runYfw9txOA/ZHIqF3AkxNgCPErfrLh2?=
 =?us-ascii?Q?Y0L9VoX4RGf+kbiyVqqj1MI9exniEdRtdTHF6rxBg63NIb8E//ADGv1JdmMC?=
 =?us-ascii?Q?jyCxzHkoymcTGHhhV+hw5gUYnSU5096Qo0nk1k5W6ClPwaB4CGxjJHIagPGG?=
 =?us-ascii?Q?yC++7UVAkpQSzl6edRlAkuFJl6qiS0mfWBvmQeKSOEvuP+TemVhDnBL3NCfv?=
 =?us-ascii?Q?//70F4U1AKkMXINAj2uq1LCqm1WxmaaGrZK64sRD794rlmS030v4Hp9NAA7V?=
 =?us-ascii?Q?zBgkQTKgZO5wQfC2gEbOCZeYAt8kAis9bI0JoXLTyusYkdwWdJzHZw+zpqod?=
 =?us-ascii?Q?N5QdtLtINUFAMUlXZdmufTA9bv12wAf6M6+jLZ1HiKOdu3w0w92iNHSQrvvV?=
 =?us-ascii?Q?vL7hmsEOC6G0X768NOGzSc8ek13g29yWKjSvlD2lhthj6+zUn9ZOIjXYGPcM?=
 =?us-ascii?Q?zk79XTyUwwxV/bk4EY/LvukQzVZsb9bqgDuM1ddPw0FLAF+mGKYGZ7f7+ucA?=
 =?us-ascii?Q?OyB730X9Oc7ehQa2Itc6CLS5wvUNClWaH7X4z0uPBxaU3w9cAqhMc0RBHP0a?=
 =?us-ascii?Q?JgGo/WAQ19lbEionsFx5WWx4P9AzM+rvw/Nfau1Pf3LXW/z8DiKNYUOR9xWa?=
 =?us-ascii?Q?44o+FsErU9N+wXUfmIvj1xHo46NY2oGogPt0BRmucnVXpQrTwSifnljr0rYg?=
 =?us-ascii?Q?yKx7HD0k8fLv2JV8bsAQ6NnqZE8jxFWJI1ahwANpuGLks78AbDN28a3Z+s+9?=
 =?us-ascii?Q?62/Bn0ym/SUIbfi3D6mX4JjtSxXQSyv6rozn0NSCst+Ih8A4ovXdLN2NyLuV?=
 =?us-ascii?Q?uFCdF//vplUENhTRe1/lKk7KfxXyPNTwzl2Atfq75VFSydbtWg7RmkO1Qa9y?=
 =?us-ascii?Q?fDMY7si6BkrHE0Fvxziku/f+3VVvPO9lH6tThn8Qoniywcue50DfG0F3jRJO?=
 =?us-ascii?Q?fSMG/TGjAxYLfLevsAtx4cWudb+x0eU3IxF3WBSD7wKyo4dt2kKQ95ZR6U2o?=
 =?us-ascii?Q?BNUgwv/gp4aYSM47UwDigPbI+dUXxycc3SUh8GnyFZk2t0Y3UxFrYQnndZic?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770fc80d-2abb-4874-c6c0-08daccc0ee79
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 19:37:04.7309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2IRnJZwNwuf55SO6RfVomzI/cn6qFn/9HVPQci/nFxNKNeGCW15OoIY+iob9jNZ4EthARCFV7x2pEH9OYw+9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7499
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 06:28:38PM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 22, 2022 at 07:56:25PM +0200, Vladimir Oltean wrote:
> > The problem is not phy_config_an_inband() but phy_validate_an_inband().
> > We call that earlier than phy_attach_direct(), so if the PHY driver is
> > going to read a register from HW which hasn't yet been written, we get
> > an incorrect report of the current capabilities.
> 
> Why would it be "incorrect" ?
> 
> What the code I'm proposing correctly reports back what inband mode(s)
> will be in use should we select the proposed interface mode. Let's
> ignore whether we report the TIMEOUT or not for that statement, because
> I think that's confusing the discussion.
> 
> If we _do_ want to report whether the TIMEOUT mode is going to be used
> or not, the code I proposed is what will be necessary, because it
> depends on (a) how the PHY is strapped and (b) how firmware or external
> EEPROM has setup the device. If we want a single bit, then we would
> report just _ON_TIMEOUT if bypass is enabled - but we still need to
> read registers to come to a conclusion about whether it's enabled or
> not. As I say, we can't blindly say "if interface is X, then bypass
> will be enabled" for any X - and what may be correct for one board will
> not be correct for another.
> 
> Moreover, in the 88e1111 case on a SFP, what's right for one SFP is not
> right for another - there are SFPs where the 88e1111 registers are
> preloaded from an EEPROM, so whether bypass is enabled or not in SGMII
> mode is up to the contents of the EEPROM - the marvell PHY driver does
> not interfere with that setting for SGMII.
> 
> Hence, to report how the PHY will behave in SGMII mode, with lack of
> explicit configuration, we _have_ to read registers and use them to
> determine the outcome.
> 

I'll re-read this tomorrow to make sure I didn't miss something because
of being tired.

I may have mixed up interface modes in the validate() code for MV88E1111
that you posted. I was under the impression that PHY_AN_INBAND_TIMEOUT
always gets reported based on reading a hardware register, the same
hardware register that gets overwritten to MII_M1111_HWCFG_SERIAL_AN_BYPASS
in m88e1111_config_init_1000basex().

But your proposed code is actually a mix between reading the existing
hardware configuration for SGMII, and returning something hardcoded for
1000base-x. For 1000base-x, we will return PHY_AN_INBAND_TIMEOUT, not
because the hardware is currently configured like that, but because it
will be, later. And the timing of the validate() call isn't going to be
a problem, so there isn't a reason to move it.

I'm okay with that, I just didn't understand.

> > Always give preference to what's in the device tree if it can work
> > somehow. If it can work in fully compatible modes (MLO_AN_PHY with
> > PHY_AN_INBAND_OFF; MLO_AN_INBAND with PHY_AN_INBAND_ON), perfect.
> > If not, but what's in the device tree can work with PHY_AN_INBAND_ON_TIMEOUT,
> > also good => use ON_TIMEOUT.
> 
> What do we do for a SFP module with a Marvell PHY on - we need to cover
> that in this thought process, especially as 88e1111 is one of the most
> popular PHYs on Gigabit copper SFPs. We can't really say "whatever
> DT/ACPI firmware says" because that's not relevant to SFPs (we always
> override firmware for SFPs.)

Ok, I only answered to part of the question - which is how do we
interpret phy_validate_an_inband()'s result from phylink_sync_an_inband() -
the on-board PHY code path.

If the code path we're talking about is from phylink_sfp_config_phy(),
then the modified code, to account for TIMEOUT, would look like this:

	/* Select whether to operate in in-band mode or not, based on the
	 * capability of the PHY in the current link mode.
	 */
	ret = phy_validate_an_inband(phy, iface);
	if (ret == PHY_AN_INBAND_UNKNOWN) {
		mode = MLO_AN_INBAND;

		phylink_dbg(pl,
			    "PHY driver does not report in-band autoneg capability, assuming true\n");
	} else if (ret & (PHY_AN_INBAND_ON | PHY_AN_INBAND_ON_TIMEOUT)) {
		mode = MLO_AN_INBAND;
	} else {
		mode = MLO_AN_PHY;
	}

or in words, essentially prefer MLO_AN_INBAND except when the PHY driver
says that it requires in-band disabled.

At least that's for now, because we assume that the PCS always supports
MLO_AN_INBAND. For the purpose of this series, let's assume that's a given.

> > > > If you can prepare some more formal patches for these PHYs for which I
> > > > don't have documentation, I think I have a copper SFP module which uses
> > > > SGMII and 88E1111, and I can plug it into the Honeycomb and see what
> > > > happens.
> > > 
> > > I'm away from home at the moment, which means I don't have a way to
> > > do any in-depth tests other than with the SFPs that are plugged into
> > > my Honeycomb - which does include some copper SFPs but they're not
> > > connected to anything. So I can't test to see if data passes until
> > > I'm back home next week.
> > 
> > I actually meant that I can test on a Solidrun Honeycomb board that I
> > happen to have access to, if you have some Marvell PHY code, even untested,
> > that I could try out. I'm pretty much in the dark when it comes to their
> > hardware documentation.
> 
> If we can agree on the reading-registers approach I suggested (with
> the multi-bit return values corrected), then I can turn that into a
> patch, but I think we need to come to agreement on that first.

I think we're in agreement, but please let's wait until tomorrow, I need
to take a break for today.
