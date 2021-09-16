Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2440D0D7
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 02:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhIPAb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 20:31:28 -0400
Received: from mail-mw2nam12on2126.outbound.protection.outlook.com ([40.107.244.126]:56659
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233237AbhIPAb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 20:31:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Krl+ckGxIMlnjeMwy/1tLy+g+GMme7N19pAMPKA7Oao9k3Z7Rk7oaWEVIw7upbnbgUWAAF6cVK0//mGb8kynReL3/0C9sMkkPEB2mSq+9nfYe+XMuuozEURwhtu1gColJkPLwz9RTytUqtaF8Y4temZvg7mQuluHqZSuF8BQOLYlD16YkOXIKrOzp4BrDMATjptXyhJBJ1JBtqkvVkGzAGLNEKX541IlYuf8HCV5/e+vnrR4uooUah4Gj9zaCe6LPVQst9ggY9WU0cEP08luM81hdapabZSudfs3T5fOKQQo4zWMedEzhubB+sab0DWQ0hGJ3pdst3uI4e3cVoPyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JAP4e9bgENaPxy+/RMEzAlOj9heJ649ZB7DMUgOFI88=;
 b=h/quFiysbLYqpkmG7neiJihFXHAXQdX4GXunTlmw12nIq6ItnQfYCwkyW1z9t0ql3YrSLa9SoUT6xGdS2vEmQtmZ9onbYOh+wrAp5fA2p42zrRtyzHlfFcusZy+0nDzl+WSC9X55tn/V6LvC7poInNPPMxrzmomWsS/+FmjjCwPE8pPp81TVB78oUG00/109+p71UPPkPE5w3kSQtIKF2of72c4QFuJFZN0aaIX6lYn8Rd9VO3w6rQeZY1R04AKfcGHGQRBd0sPsR5aYMYEF6bAYXgNqdCtbbx1SNmmL43CXOiUQvDpWyGA+sbQL3oTza8cp0Gtjn75n6jv0wxbp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAP4e9bgENaPxy+/RMEzAlOj9heJ649ZB7DMUgOFI88=;
 b=IvXbHvf3qTh+Po6/x+DHiSF8mqzsb7qnMiXdgv1Qd5bfMxUeG729V4BDrTlOEIypoXC5H42Ye2VPT3J2G7xf4f2uMMY0WI5WOd/Df30OPtP/t9I5EissDxVgTLTAKtDmdKt+CdC+VWYx4uLUdgHzPK0TDjQqaS4npay2N/xURxg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Thu, 16 Sep
 2021 00:30:03 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::fd7c:b9c6:ad90:72ba]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::fd7c:b9c6:ad90:72ba%6]) with mapi id 15.20.4523.014; Thu, 16 Sep 2021
 00:30:03 +0000
Date:   Wed, 15 Sep 2021 17:29:57 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing
 MAC speed
Message-ID: <20210916002957.GA513411@euler>
References: <20210915062103.149287-1-colin.foster@in-advantage.com>
 <20210915122551.kol3f5jz4634nvrm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915122551.kol3f5jz4634nvrm@skbuf>
X-ClientProxiedBy: MW4PR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:303:b7::19) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MW4PR03CA0104.namprd03.prod.outlook.com (2603:10b6:303:b7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 00:30:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 208b0cff-e5ec-47e9-96ce-08d978a91fdd
X-MS-TrafficTypeDiagnostic: DM6PR10MB3146:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3146578A030D9808B3654194A4DC9@DM6PR10MB3146.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: miAEqsIzv6myp1fBqLdQi3QsFZ+nxnfcnebnCJjOPPTtox/z5tPHSLmRKTnTn3mBlZ3nadkdYohyjtohNTOwxkgpQMlMSGcT/zEG4CWvqdBPc8w6pkTEEJbavtVYylwJIR+HpXOTNKFOFS1aDURsJWqB39GceE133HwQ0uxGIqpJybGlWndh1Yfw+PUczRiFSKPjSwEcuoyJaRcMiIEyIpmdLaRIwp8ZGflosfld42NXWjgLehyxKBVJSYA8TtDBr+fTw75ybXH8MLEVQ+w6GiK2oN9FBTC4YKqB+iHMWXGsKq9V0bv5Uy2439rAHPgkuNZrK4TyyRWU/Wt2/JMa6iruf6g6SaQpQgXflaIYuIFU7KpA+KpeTsz/G7ZOsW6Riy4LIEmHmklGYZJop433L7nqa8Zf84feU5s0xWHmRaDk/GAyZDnjGZFr2IVLIG1MNRJVpFBlxXWPgOEaugn3aqYHidbFb9bMRZ9ZbImuqqHPnDZyKW9rvtJh6EmDEro7qwb/+A4HRATomQztEJkIBHe3bILuLsZUpu+628FS2hu+KtHtGlMD5YYNq5PftRkLAJHUd3QLli/taO0cxESU7eavHzfzL21z2DVMeRmukMqOzjaLS66V59GPJtQ9xRVLBW75istFTHFGb2v2/9J1WAaveV+AXSDLRW7aBjb7j4g3FXdGV5tNDaF9Q3ZiI5ZOj9e/i1UbG+Wixxfcjm6K1xtW7UB6Bv9m2Rg4VC68mi0qh3TeARTgy3zcxFUHoDRwORgU9VKc+DPbun4WQQwJzIvCzgc197reQsN3PYU9n24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(136003)(39830400003)(33656002)(66476007)(66556008)(33716001)(956004)(9576002)(52116002)(54906003)(83380400001)(8936002)(55016002)(38350700002)(1076003)(44832011)(86362001)(6916009)(5660300002)(186003)(66946007)(26005)(8676002)(38100700002)(6666004)(4326008)(2906002)(6496006)(316002)(478600001)(9686003)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sScwZlb2O8J52ijUXtZP2y9zu8riOsN6pUKJXDL2GXDqz5CLiMoD0WAr3PCp?=
 =?us-ascii?Q?/a8YUM+xJ+7CB/vaSeg2YBXAicCdu6XUduC7cRS7m7kixL1aKyIJyRpd1WKO?=
 =?us-ascii?Q?G/9x2g2o+jqGjJIiFxCso2cmu8yxWJrhvve+4V+0qnmoEbqqMi7FlpoOBUZW?=
 =?us-ascii?Q?zqxjoaQCfxQVcNHjQq3tqRdyrRKhTnhWdprJ0bumimviPwODPASbuSlODZ4B?=
 =?us-ascii?Q?V2pDpFtdNh+n1jyqcpWkisj7lrADcy0wQPKzBAjG+i9P8hqDXpluFIYfWQwU?=
 =?us-ascii?Q?dqIYiZwiNkAgsx6pbuaCGNBZ+fDJYDcZ63wRj6bEr4nXgTJCcmsyfd3YJ/J5?=
 =?us-ascii?Q?5Hi1g7oKs69aab//AX1Xz6zcfdASv1NhoMWEY6D8OczYUli09Qrt1tGbDICH?=
 =?us-ascii?Q?/tWok/gDUWgq2VH3jnKMhGTUfXGaAWwR6p4lvWlG98xRS0Kd8l1CbPsY2VUF?=
 =?us-ascii?Q?Xow2BTRgUrmJidSSVrJSzTxes3jBdpfGtJOoTxuxW/XFv2p5YTY/USPeNNAx?=
 =?us-ascii?Q?zUyDCX2QfSXRFNjOynxqKONdf3f9wJMcwS/HCEa13bA9oKGvDsD16FeZYjxT?=
 =?us-ascii?Q?z8HN/vPrdH5SwtsIwD8i+q4mS7MkPxbJDp1NCfEI7TA4QKwomJM3T5kEN9k1?=
 =?us-ascii?Q?AcHzxCItrZ5MTo9ROU1sqMtXbK29kpfjhaBiwqSEIhKtJTNJ4tEYLKx0xXVn?=
 =?us-ascii?Q?csvaS2D9agWpX1geu6JGV/2DwfL6HggKMnqzcEk0b1eqkEdjE2DLpdSj1ObD?=
 =?us-ascii?Q?8305fe0xbmIX6wFDHdyYV99POg1tXUl99C9G+i5vCgPvcw2Es1ujJtfygirl?=
 =?us-ascii?Q?sks4CM4P9nchUqtKBRXOAG0UZOhftrvYoKgzI5SJvty4MzpIo5dQPvILoleu?=
 =?us-ascii?Q?RKZM0Z+k0feDxVqxY5iIN40+Qb7nJK4pkeYEKXd+EY/LmUCjj26/WRNKEsL4?=
 =?us-ascii?Q?KC4f8cc7un2UsmxkhBJX89eR5ZeiWNJknpnqt8Hjt/ineqQhOfxsRjZQoIM+?=
 =?us-ascii?Q?hhR7jW49wfLbyQRDg4r1Wed2XGau0NJBKv4D65anATiMAQ9QRtfX54jVQhHL?=
 =?us-ascii?Q?Qjl6jqSvbwLKHlDSNHOzblzOKxJXlAKLGLB0ZHPENBSx1gpaOUziRiK7vQrF?=
 =?us-ascii?Q?xQ+6+8iMbHu7+hdMK+2/OWto4CfPxJHHgsIzUk/Vyi9wUIOCY2M3ewyWWUEV?=
 =?us-ascii?Q?1R1KoQCmy/mKm7sXIv5yspJybrSjwxltaIiE0jTUhPVqxcgglrNXt+RHZH/M?=
 =?us-ascii?Q?dYPFKlv+XZJDyyToNWcltQ1F9ONr1iRpPh5R7Q47H+YQgaHpEurj/ydqsxP3?=
 =?us-ascii?Q?aWrU64xwkH7v1ucjhh2abHeK?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208b0cff-e5ec-47e9-96ce-08d978a91fdd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 00:30:03.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2cjzTGe3h7Dj8+Fwo213Lu0vY6071xFghu+M4YevxbjYwmxpkBQXlXMokJaDPtH9MGt4hPbs+FH5QjRiq/fzxiG4f7l8txhAegNfPIgNkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 12:25:52PM +0000, Vladimir Oltean wrote:
> On Tue, Sep 14, 2021 at 11:21:02PM -0700, Colin Foster wrote:
> > Converting the ocelot driver to use phylink, commit e6e12df625f2, uses mac_speed
> > in ocelot_phylink_mac_link_up instead of the local variable speed. Stale
> > references to the old variable were missed, and so were always performing
> > invalid second writes to the DEV_CLOCK_CFG and ANA_PFC_CFG registers.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index c581b955efb3..91a31523be8f 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -566,11 +566,11 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
> >  	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
> >  	 * reset
> >  	 */
> > -	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
> > +	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),
> >  			   DEV_CLOCK_CFG);
> 
> Oh wow, I don't know how this piece did not get deleted. We write twice
> to DEV_CLOCK_CFG, once with a good value and once with a bad value.
> Please delete the second write entirely.

It seemed odd to me at first, but I looked into the datasheet and saw
that multiple writes to the DEV_CLOCK_CFG register in section 5.2.1
https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf

11. Set up the switch port to the new mode of operation. Keep the reset bits in CLOCK_CFG set.
12. Release the switch port from reset by clearing the reset bits in CLOCK_CFG.

From that it seems like maybe the routine must be two-fold. First a
write to set up the link speed with:
ocelot_port_rmwl(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed), 
                 DEV_CLOCK_CFG_LINK_SPEED_M, DEV_CLK_CFG);
ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),
                   DEV_CLK_CFG);

Of note: I'm currently only using the VSC7512 ports 0-3, which don't
have a PCS and therefore don't have the PCS_RATE_ADAPTATION requirement.
So all of my ports should be good test candidates for this.

> 
> >  
> >  	/* No PFC */
> > -	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
> > +	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(mac_speed),
> >  			 ANA_PFC_PFC_CFG, port);
> 
> Both were supposed to be deleted in fact.
> See, if priority flow control is disabled, it does not matter what is
> the speed the port is operating at, so the write is useless.
> 
> Also, setting the FC_LINK_SPEED in ANA_PFC_PFC_CFG to mac_speed is not
> quite correct for Felix/Seville, even if we were to enable PFC. The
> documentation says:
> 
> Configures the link speed. This is used to
> evaluate the time specifications in incoming
> pause frames.
> 0: 2500 Mbps
> 1: 1000 Mbps
> 2: 100 Mbps
> 3: 10 Mbps
> 
> But mac_speed is always 1000 Mbps for Felix/Seville (1), due to
> OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION. If we were to set the correct
> speed for the PFC PAUSE quanta, we'd need to introduce yet a third
> variable, fc_link_speed, which is set similar to how mac_fc_cfg is, but
> using the ANA_PFC_PFC_CFG_FC_LINK_SPEED macro instead of SYS_MAC_FC_CFG_FC_LINK_SPEED.
> In other words, DEV_CLOCK_CFG may be fixed at 1000 Mbps, but if the port
> operates at 100 Mbps via PCS rate adaptation, the PAUSE quanta values
> in the MAC still need to be adapted.

This makes sense. And I'm hopeful once I get around to the rest of the
device's functionality (external phy / fiber) this level of
understanding will be second nature for me.

> 
> >  
> >  	/* Core: Enable port for frame transfer */
> > -- 
> > 2.25.1
> > 
> 
> So please restructure the patch to delete both assignments (maybe even
> create two patches, one for each), and rewrite your commit message and
> title to a more canonical format.

I'll make a submission for the PFC with the suggested formats. Thank you
for the feedback.

With CLOCK_CFG, there could be the fix for the duplicate write, and a
second patch to do the reconfigure while the port is still in reset. Or
a single patch that does both, since this behavior seems to have existed
in ocelot_adjust_link.

> 
> Example:
> "net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG")
> "net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG")
> 
> Be sure to include this at the end:
> Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> 
> So that it catches the stable maintainers' eyes.

Thanks as always for your direction.
