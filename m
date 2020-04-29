Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2965E1BD412
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgD2FiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:38:13 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:6236
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgD2FiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 01:38:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+Cb+/V1Br2/W+bFkkuIObVHynOg32Bu/+Rq7OrjslVWtId59wtsyMp8yDL5uRcE0hCOhT25BbPUmg5kWGIQpGyf66tHt5O0rfxzVRPTCwLR+pBbuezCKp5svPaIFSlHI2iW8J1ZOcrXGqWWKMmcBbNhSbz9lAAPPXrEfWmgbE2ZmnbegI/h/AXV59DQjxAoR8IIT2X47PC3/irSwToJ0fcDv+oNYvA4WWJPi8fU7hxKRb2Q90SefJRCuMjyl2QDN/O05daD8enZsNIWpsyThsSOufBClXDOfgR3bqZX02C/IG/Sq3RS53ginr3TJBgUkHfPwRMQIN8Gm4OBCOvz5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tS/k56e3hRWL4sJxPHRQPtL/GBehb5Kq2UfTvVvtMDI=;
 b=GrKG7BT/b+Ru7zr39sfpHhgL77mMtbhUPsLoByGxBZCjURJio8BDcOifgtEeEmn02mgzTjJV+kaz40cvLm2ksCW0wQQ4gWmr1Q7TDJ9VUPFpiuEWQL+gIBLxrNN0WQMSkyRlw2qFg8mGws2QHNq234M2DZxcj0sCP4MOj/nO+FFZuKuWjMg0uwB7qNoMUYwsgpAsF2YQuUhRK32E2bRf5tAufIDWGpXQcrd8Xb/DW2yratLA3khs881Gj+Kv2zb8qjFP69YoEb89meA006YH8cuEnvXu8x285zVan3K4PwybkWEAcksSAkJyIsBtWLT/HvJ2rkOFdDR+d3cZWNwdBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tS/k56e3hRWL4sJxPHRQPtL/GBehb5Kq2UfTvVvtMDI=;
 b=Emwkccryy4E7r3I5+R+XjVd68dSqBIktIhDGHGPrpscW6gjf7fRzbAdfWweA6g1FkelsjtsfNhVqFdPj7Y9KxRdqIMf5EsBc6g2NIfY85x9eE/byjGonxBEkr2d4rRxszsgxvSlAGP/vQE9fyDOY9iRrTnqH6HtPgs1LeWoynxw=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4289.eurprd04.prod.outlook.com (2603:10a6:208:62::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 05:38:07 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2958.019; Wed, 29 Apr 2020
 05:38:07 +0000
Date:   Wed, 29 Apr 2020 11:07:53 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
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
Message-ID: <20200429053753.GA12533@lsv03152.swis.in-blr01.nxp.com>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427135820.GH25745@shell.armlinux.org.uk>
 <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
 <20200427144806.GI25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427144806.GI25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR0601CA0008.apcprd06.prod.outlook.com (2603:1096:3::18)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0601CA0008.apcprd06.prod.outlook.com (2603:1096:3::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 05:38:00 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb74a273-cd8c-4f86-a5aa-08d7ebff7e69
X-MS-TrafficTypeDiagnostic: AM0PR04MB4289:|AM0PR04MB4289:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB42898099225447D5E00C1920D2AD0@AM0PR04MB4289.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(16526019)(4326008)(6506007)(8676002)(186003)(44832011)(26005)(33656002)(8936002)(55236004)(956004)(1006002)(6666004)(7696005)(52116002)(478600001)(110136005)(1076003)(7416002)(5660300002)(66946007)(966005)(66556008)(66476007)(9686003)(2906002)(86362001)(316002)(55016002)(54906003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mg+lIVCHYMIvWKB2x9J7SixmBXNiAyFxDOWYi9/TFrmNGVO5gMrMlV3gU7AFVe4g0KBsko1VB/LePer2F+42VxcqbChHq1bW6w0k4FpzdUFKo5Jr3qaGNCKC0FiR20P7yJl76OAoPYnQUDkSmsvsQyuditkSjk1cctLz924Vnrzqenm9IBJz1ax8QtxY5rJg0XIeYJU7iyzFQANqRYLzyhY3ALN5i8PaT62B/wyvnf3NSR4sKdFXXFNiOF67JGLAiEFv3JEywgAaDKMQk83Uzhr1zpGgyBm5ajepIFglMDgmsDQdHRAW5oFSvrrcIX/LZr8t4Lmju0woca87ULDPmDR2JoifbQQWCTLlbgOU+kS4TH4PfrKXydpHjLag4Az4dN1NMQuMHUSUWs8YHfg2vhewRKmHpHeF9ToiYU6OO+uDA3+u7zC3xoivBlMwm551Lk/0OyxTfZuDvu49l6HdQ8aPN23uQBeA28ySBbksf5j+AU5v8xSP/P+Dr+2gu6cQYkF8lvJOI7IjNUtiz4d59tQqq+g/6UM/YOy/onp3/scxrBgC5SgmPGCB1uDjV2RsIfLz1zvO0LyDV2r3WOqvpQ==
X-MS-Exchange-AntiSpam-MessageData: UatfF4FxUcFTNpqZ3bQ7wleq39hdYuC6HpTH8j4lJ+CuYu7SGwqE+CtooMlFe59LjvImFTP9PtdTlnv78U1DoV14EtR4m/9lADDVwW/IS+RCBwqByv1Ziks9qphmZ1Szzauxcja3bHSRv+Cu6qvlOSMtbHDMisIYaOjYuUYWoWu5yGgn5DDid1oPxQOG596cX5RKd3cWSuco9KclTH3JaGuRhYZgAGuP3WZWeDbZev8HTr4kh7pWH0BcAJK/VGdOSRs3MGJQu0sm2vO28CoZKUbdEIBsSIJIbysRB0fQ69Q8mboMSPDlpj6DALel1G1QATFnSD/UVcNtaoyfThCzFZRyLncfI9FOqV2lw+mz8r8q9fkwk2fnUiHW0thWyZMlOVcUwx+Ibumfqv3n6ohPjR5I81TvPcnDyjIFAThG4LB2rVmDAUz4oWHJAJLDwIcxYrC19JABME/vv4Iz+LIt9rvJDpBF9BLvcWPWK6jPMCGYqQgd/6xTcgEp0oOu8GL34tzxnEFEYdeBzRMTNnZ9n3ff5EibFEwp0vovI4BmOCrbAhGGWBBf86etY6EL/e1a/OGNeVnqcqTdYA6lC5jB1CmVFlMMJrBgwKk0RucRFOqKVGY0hmARE5Slkc2GzTKqLkcXj+Q1BDX0eu9D1NgsEYR6+FG14zUpXSwTklk3030pR64vZQgDf2ENf+VK5kLFgzcPhC41mCeTlC4C0SFkp2VCP4gql9fZiGIPnsjGRCylBr4YfsCo5l4VGwp9uo1AA6x2p0aPR98kJkhfaeY+t8z1YxozlAEjDhXwk0QtvJI=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb74a273-cd8c-4f86-a5aa-08d7ebff7e69
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 05:38:07.4890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvrMzby+8RThEKE7PsZZ78gZp9Qs/Zunl6ULXmE7qrfG2DkIquiPl3U1y9dHEFfN8LuEEED2xCDphPD+LwuRJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4289
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

How can we get attention/response from ACPI people? I've now added ACPI 
maintainers in the To list.

Thanks
Calvin
