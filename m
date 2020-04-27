Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0881BA710
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgD0O4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:56:51 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:9185
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727771AbgD0O4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 10:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1qhAExW/B2qAj591iWKiO3seLgmgJwj7OKzTpeZNZFijnYRbxD7lKMsPH89EsOR0J6mTvgCRaiAVrQw5W8xWLrziJhKhddnVE+650RgJ3hKwf+0dS9xUgO0/QCLzpz3N2Fj8loXQdE3xJxtw1Se+l2aRAXoQIv9shFQmtJDLNZTdz1mWxyrOLfA4sLuWK/MGvwkwWHaCPVumPCqAstREc6u7jjqpfHsmzWOOP0YH/132xo9HH+6ZR6lmXisXWk6NmyAvz79h1Q7Y8o+1AqySGgfTVRsPETg8a3Dj7OLzlrCGS525gcqBOgG8CHeLuV3XdO+2Gx+iEOSQq0/wMG5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RqTidZ/al2c0fdcVeXocP9OcDBd6e+WEYScpD5GaXs=;
 b=ZEysBDVBeTr1Yl4ZLOEj6LcwzTQwRafsokhiO3EODfXaQNqYAltzdJnzeaaEQhMcxlzxAtFd1utR4OWawAL5XdnIRFfoio5fB9nvGQN9V2BpFM+SfG2h4hUNMC7Yr/cPte3XgmIzM2JpWU+TaDkzEWTy0f6B6bc4CCpt+FirpnutF2fCcTi/2JmjM2pEq0xT8C0/Eiwae4I5Y0FpAvy/07lQ8FytNtIJMmCJA2Onn1a4yA155VOzkCov8A413xfph1PyTEvglVihgfP5AkzdEb/G/fBITrAEvGFmrsWcPQbqauevIRuo1vBTdVRm+3lbkj7Qs79iE3SU4rHPqFMJXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RqTidZ/al2c0fdcVeXocP9OcDBd6e+WEYScpD5GaXs=;
 b=J2Q5b6qDdaQdIt+ogi7c237H2GuZKc7+0J4XCu+0mijAuBFfpJkJv3eRpaOHYiqQ/pK2Dkv/1P9bHvnfe49PBje/sJCHaoUlhYacCCCA2+bpPtT8UmzIRZLuxjCExgx0I3CdsTj0VSGejswOoUII8wwJiHwh5r8lvFlrbxATVYQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5844.eurprd04.prod.outlook.com (2603:10a6:208:12a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 14:56:46 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 14:56:46 +0000
Date:   Mon, 27 Apr 2020 20:26:33 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>, linux-kernel@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v2 0/3] Introduce new APIs to support phylink
 and phy layers
Message-ID: <20200427145633.GA28011@lsv03152.swis.in-blr01.nxp.com>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427135820.GH25745@shell.armlinux.org.uk>
 <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
 <20200427144806.GI25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427144806.GI25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0165.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::21) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0165.apcprd01.prod.exchangelabs.com (2603:1096:4:28::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 14:56:40 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad4eadc1-f557-475d-92c8-08d7eabb3498
X-MS-TrafficTypeDiagnostic: AM0PR04MB5844:|AM0PR04MB5844:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB58443087DFBCB1E82A4CDFD2D2AF0@AM0PR04MB5844.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(8676002)(33656002)(55016002)(9686003)(86362001)(66476007)(5660300002)(16526019)(6506007)(55236004)(478600001)(26005)(8936002)(186003)(66556008)(66946007)(1006002)(6666004)(6916009)(7416002)(956004)(54906003)(52116002)(966005)(2906002)(316002)(81156014)(44832011)(1076003)(7696005)(4326008)(110426005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahq1pFWeBQwyHcXjJwjtfDQ//ysn2jg1KX/PplN0TAhYWThu68FxO+zBViHk1zvMABFaYlPxcTO9Ki3xksbAB+JZ8ENX8Hcz/zyiv8hgsIVU+xRkxrOSCdqMiBT3gTe0fF19sJMzxLHwH8/D/RIsEQ4mTToyVB9pqLm2fF1G8xlVVWuYCZCXneGItlk5mRf9lYPHS3PQxjDqHR5braBsogZmwI71y3Vq+q5Mv4QE5dK15rZhEKFIfPVWc7IXT+DSWcoTJa3reRQ1ltxXRujiwb3WvGalCsXMyOWgOg4mmz5RO6GY1hTIJlgvlTZzuH/bQTD0OnjrGLiQn2qB24GP9uWIW8/9svS9mdFfEfX2EWUD7dxggHoFxidUrfCbqH8aC/FYrChaesw9r3nyD19ui5Df4/T+FOixDK2cFN7RnRdVhnQumwDyQ1iZ/JGBGtVcCY6EWJYPeAKn2YFz4ANL442vMnqMSFjTXZ2QxVoOvSq9k1OfdTZSdbgdZ2S9RRDDg/D3292aLx/4hheyYTxJjaG4lmwWDAaiWTZ76WjS+V5UYKYQsNeDFj0Uu5zvskM2eLUKMEGo2B+BryMql+VBmA==
X-MS-Exchange-AntiSpam-MessageData: PYyRQNrI8XqwAQN7f0GfmJqBm5TCvFJJ7A8Sgrvyif19+de78CZ66qMJwcrC+mhFJ9O2W1piAvKqWyMKiZcHeysCCzWVwXIbSvTnZSxwhHew8VMX4uX63/YgKtSLDkluaHolJZYsnNxo7k+pvAbWfgRbtWSQecIWzXhsloksHe1pxBHHL4H8GKw+zdtgaAAMqy0ZfGGcD+RHgXUxBWWPuK0qHW00KvF4PRn0i+Pve+BPzBeC0OeOKo5dJn8AbCfAw0VxLyRuUdBxu4rCGwvUHB72zNcdJCHjdss/SNjyuEAjqj7HJVlt6/4IgvnrmN6VCAZPyeSU3mRc4pg7Bhvm/JEFhsoNXDm0WAqHZHmkdMrnuGyAhosDea4R+8rgfvi8Q+CIuPW9xGLd4IWite2zYy10z9fP1EVH4nL4twgA7x5baNN62xS9hdeGczGAZnEbwxJQV+Vu7MlJn8Rpmq/G9Nw7PacBK3Ue9ewrGlwuYNL9fiVeWTBkYMJgy13A10ChzIQ9Pks0NJ0Dc8uZQ3B9dvo8bfxobqEDdkC6ZIxcLBlRqDLbGHYNZKRe/CkclemD7fX518uMXbnQpEjRhU0F7YkfVTTKd3ioTKEG09av8s5w0kFG1W4AygBHpn+dAdX48zdJxYCvGXrQ3tge4rHmsqRwGVbTHQfWwcA45P7t6jfAycvXcxe1XiozHPsTk/zZdHZcaQ294rRdkMWXKccdcKH+vZCkiSusKvnbuU3lX6leR+VZKA5MU0VWRRb8Hjuyy5zvyc1DjOpKbAE2PIeYFdpNZYL3kZPaDXY8SH8R4lU=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4eadc1-f557-475d-92c8-08d7eabb3498
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 14:56:46.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNhuCWXclNBvSWjTKQSmNYqa1vjnOe/BnDQdARGU9NPMnz2iUxCZxdxZ/txGMvlN7ZXG7THXHV9SxRWj2gNNoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5844
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 03:48:07PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Apr 27, 2020 at 08:02:38PM +0530, Calvin Johnson wrote:
> > On Mon, Apr 27, 2020 at 02:58:20PM +0100, Russell King - ARM Linux admin wrote:
> > > On Mon, Apr 27, 2020 at 06:54:06PM +0530, Calvin Johnson wrote:
> > > > Following functions are defined:
> > > >   phylink_fwnode_phy_connect()
> > > >   phylink_device_phy_connect()
> > > >   fwnode_phy_find_device()
> > > >   device_phy_find_device()
> > > >   fwnode_get_phy_node()
> > > > 
> > > > First two help in connecting phy to phylink instance.
> > > > Next two help in finding a phy on a mdiobus.
> > > > Last one helps in getting phy_node from a fwnode.
> > > > 
> > > > Changes in v2:
> > > >   move phy code from base/property.c to net/phy/phy_device.c
> > > >   replace acpi & of code to get phy-handle with fwnode_find_reference
> > > >   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> > > > 
> > > > Calvin Johnson (3):
> > > >   device property: Introduce phy related fwnode functions
> > > >   net: phy: alphabetically sort header includes
> > > >   phylink: Introduce phylink_fwnode_phy_connect()
> > > 
> > > Thanks for this, but there's more work that needs to be done here.  I
> > > also think that we must have an ack from ACPI people before this can be
> > > accepted - you are in effect proposing a new way for representing PHYs
> > > in ACPI.
> > 
> > Thanks for your review.
> > 
> > Agree that we need an ack from ACPI people.
> > However, I don't think it is a completely new way as similar acpi approach to
> > get phy-handle is already in place.
> > Please see this:
> > https://elixir.bootlin.com/linux/v5.7-rc3/source/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c#L832
> 
> That was added by:
> 
> commit 8089a96f601bdfe3e1b41d14bb703aafaf1b8f34
> Author: Iyappan Subramanian <isubramanian@apm.com>
> Date:   Mon Jul 25 17:12:41 2016 -0700
> 
>     drivers: net: xgene: Add backward compatibility
> 
>     This patch adds xgene_enet_check_phy_hanlde() function that checks whether
>     MDIO driver is probed successfully and sets pdata->mdio_driver to true.
>     If MDIO driver is not probed, ethernet driver falls back to backward
>     compatibility mode.
> 
>     Since enum xgene_enet_cmd is used by MDIO driver, removing this from
>     ethernet driver.
> 
>     Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
>     Tested-by: Fushen Chen <fchen@apm.com>
>     Tested-by: Toan Le <toanle@apm.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> The commit message says nothing about adding ACPI stuff, and searching
> the 'net for the posting of this patch seems to suggest that it wasn't
> obviously copied to any ACPI people:
> 
>     https://lists.openwall.net/netdev/2016/07/26/11
> 
> Annoyingly, searching for:
> 
>     "drivers: net: xgene: Add backward compatibility" site:lore.kernel.org
> 
> doesn't find it on lore, so can't get the full headers and therefore
> addresses.
> 
> So, yes, there's another driver using it, but the ACPI folk probably
> never got a look-in on that instance.  Even if they had been copied,
> the patch description is probably sufficiently poor that they wouldn't
> have read the patch.
> 
> I'd say there's questions over whether ACPI people will find this an
> acceptable approach.
> 
> Given that your patch moves this from one driver to a subsystem thing,
> it needs to be ratified by ACPI people, because it's effectively
> becoming a standardised way to represent a PHY in ACPI.
> 
Thanks for digging deep. Makes sense to me.
Will wait for ACPI response.

Regards
Calvin
