Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84E71BA67D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgD0Oc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:32:56 -0400
Received: from mail-eopbgr150055.outbound.protection.outlook.com ([40.107.15.55]:27622
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727919AbgD0Ocz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 10:32:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3fCZ8ePTuHZoZyMuR8LU3ZDNflocFQwAoQ7DaysKKa94k563rK722+wLvJ8RRbwyU8V06zZ5NLVWseEcGiT0XctnwJJy6HDHnRlFN+5KX9v2tLjF0CyWYREVFTxlfnvF/pxwygVCL46r3UyCyS+xAThnMzvbOmoieURwUNjHKbcVvmD0l33lFWagVetPp5lhGuwSdRihT2wrcHng7omLU2LBIBLSUuAWprRjHj6x9uex3hnD2sL2y8jhIGsgPRtXvnsTv8bNI6BdRx9ltNsC9hlA84j7isdg3RFAn8kfjMc/XlOkAgNTcquexknWnrcRjOUi2iNFmGRGkZK7xWXUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2FV4+wRxSrltxQB9r1ACsnyt33dj2TOjl/xGlPJMfs=;
 b=Td4B/9GVcwQloQq6zKn6qVRU9Xy3bhZPSv7h7kKvCN6UB4hGhpN5Sx8X6yvkOwO9ocqomD2Q6ejNRpEV7ZFv7EkNFu7W8A5veI40tbSDhEuwbE63fLz/BujW4UONaOwRpAc3+Gqa7SKhx1nj0TR9N+zIglagsTudyf4hgfEb6ih/ie05W0bZcvbrrhAlt9+eNRocOarBq4vkX1o6K+c+scREIySNIQJvB4YUfksgfLrw2V1OyGL8wdu1IxNjITuALeZr80dcaUlZ7N5hXtB4+zvkN//tHEqg3Yfvc+6SyyjfUHLdXC/OPEThvRm1oP8KYMD5YOnYU8EwPtBU2pol2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2FV4+wRxSrltxQB9r1ACsnyt33dj2TOjl/xGlPJMfs=;
 b=Bohy9IbGkFfGLgSGb+QeUeeqKjAjY2393O2V5gRyIcLJ9YKdhqrykcLO9knY5sptkgv1G0hDIFNeyjq5lmmp2rG6Ku0bo3ibZbCCksRjXaQFqeue2kPRr8K9o8NeHeb9ko5JSt4M/Hok4LOM61gcGMm2ZQCDje5wD4yEiobD02M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5841.eurprd04.prod.outlook.com (2603:10a6:208:132::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 14:32:51 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 14:32:51 +0000
Date:   Mon, 27 Apr 2020 20:02:38 +0530
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
Message-ID: <20200427143238.GA26436@lsv03152.swis.in-blr01.nxp.com>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427135820.GH25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135820.GH25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0022.apcprd02.prod.outlook.com (2603:1096:3:17::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 14:32:45 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6470ab6e-657f-4acc-e5e1-08d7eab7dd14
X-MS-TrafficTypeDiagnostic: AM0PR04MB5841:|AM0PR04MB5841:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB584199300FE2C55886CA1FA4D2AF0@AM0PR04MB5841.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(9686003)(5660300002)(54906003)(66476007)(8936002)(316002)(66556008)(6506007)(956004)(44832011)(1006002)(966005)(7696005)(52116002)(6666004)(8676002)(4326008)(81156014)(55236004)(6916009)(186003)(26005)(86362001)(2906002)(16526019)(7416002)(1076003)(55016002)(478600001)(66946007)(33656002)(110426005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1F1woza9U8tpFo2QkT//BVRZVDnDmcyhlczDxI9qdNYT7FBseptDyN6JdFzPWrxL/xj2ZfaHZd5Z86u691Hk33qZcQoFKM84jHx9DL+3NlspllEKqo0eRHnO7jptxSu03L6UwyiE2/HuxfAwSHNDLwIZAB4Ey+gl07qm1veHPNPDh/o+MVc+O9NjqztGI1yEGpwGLURUtC6zPxRVkAQloIXEmONPYOy+A/AhtSPx4btETLHqf2Da5c+kgJAFdJrfdUb7zJQJI0xocCVW7dCGK6PLjWpSlnfpzTOQTw02Uya7h5byFb8AA9WzGAQz7qnKTw57EeHutYb+fQ/GG28l+K6gXBB9sWKEOns8brluDyaxR4z9ZSZ/9qMptWAfKPApiYYiFM2ee3IPCMn/AUPy3UwlLZhpcC2J/Vl6M5ed+2kBIX2pRmvz9fWfNo5+OGnOCpfY7cGzCU3kXdj4WGmeza08j77QQJzWuADJEDNt8JzJzB6f6PURM6ULIse0+0rA3iEQ7jsRFRdgQX9oQAZ+A+0xZM66ErPMz11ozlNqLHTpD9lGj4gIkSxNfz6+cPQH8Z6ZAongUfLMJyUJ+UH1Wg==
X-MS-Exchange-AntiSpam-MessageData: Sdk2rgRpLsfnKlpENmUzUn+tvlwotz01mQhOADGUYIINT8FLPcLufb0DVr72M/VhTjwFTG3a4ZCzAIGt01jdX83/USJLzNmH1l0YQpyW7EWyI+tiDXPZZN7bXaOloBpnF26vJQXnm94kKVC+CU9nb5mkXs26UZ1rEvInqB7+gV+oXoYe2wnUORMUtq/D1HxVfzrsXcdgcZKbzd5VfeYA31DFQujomhrU77dDnFSaTLWN/nUjnJfQ6TJ4aSyzYYJmMR49Eo1jmwx2KTzD7TdNej3juut1zxVZJzOmZJMgHbETGTOmnBTjQkNV22h4CHVNkrfo7IK2PJqTRNnaWEv58Iw39TnSozDuTIPAb683Ejodv4FVmmKKc45M2d3QK46eXYduMHSyskIpOrQOAEdZVWu38Mm2AB+N1gyTql5yc38zHKQqZg5SsSrUkoB5MSBm3ZSi3QM1Kp7nO1R9Pnp39mT3gzmIGrrOBaSeudRf41i6lmHr2ANwOODHTQM9FMvIfcr5WZ2y3EODQqStk+5wqPKRZ+Rbd2NzFd/YnqezLVVxICF7Y7YjwSwNvv+3V5yDPXeO6AmHO1o5UUN3ymb0WJNemfU9a4TmVk/wg6suFwBQYo+PjaLSRYjXazqNlBNxXMmLZiojBmpt/ubyH5y8xrczUq/e+oGYtKqqYUZATpk73q8AYvGGJR7B8g4hwFeUEryqmpJpKZ4TtiDHw+eoDbql4DBOkxkTdxC0zzfJs+EA5TulUXAAAV8StowlXcxcELNhCq+CJztfAZiUfWJFBH5Ow2yhC0bI8mLKLAiScZ4=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6470ab6e-657f-4acc-e5e1-08d7eab7dd14
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 14:32:51.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiJ46lkwaNRBbDXxjU4L37WCs3HBZK2/jLXU8MraUSOqYPafsDmxK4mVGQwEUKA+sAPWO+AMW5MrquSrbTfOwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5841
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 02:58:20PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Apr 27, 2020 at 06:54:06PM +0530, Calvin Johnson wrote:
> > Following functions are defined:
> >   phylink_fwnode_phy_connect()
> >   phylink_device_phy_connect()
> >   fwnode_phy_find_device()
> >   device_phy_find_device()
> >   fwnode_get_phy_node()
> > 
> > First two help in connecting phy to phylink instance.
> > Next two help in finding a phy on a mdiobus.
> > Last one helps in getting phy_node from a fwnode.
> > 
> > Changes in v2:
> >   move phy code from base/property.c to net/phy/phy_device.c
> >   replace acpi & of code to get phy-handle with fwnode_find_reference
> >   replace of_ and acpi_ code with generic fwnode to get phy-handle.
> > 
> > Calvin Johnson (3):
> >   device property: Introduce phy related fwnode functions
> >   net: phy: alphabetically sort header includes
> >   phylink: Introduce phylink_fwnode_phy_connect()
> 
> Thanks for this, but there's more work that needs to be done here.  I
> also think that we must have an ack from ACPI people before this can be
> accepted - you are in effect proposing a new way for representing PHYs
> in ACPI.

Thanks for your review.

Agree that we need an ack from ACPI people.
However, I don't think it is a completely new way as similar acpi approach to
get phy-handle is already in place.
Please see this:
https://elixir.bootlin.com/linux/v5.7-rc3/source/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c#L832

Please let me know, if you see more work than the ones you pointed out in your
review comments on previous patches.

Thanks
Calvin
