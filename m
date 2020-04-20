Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6591B1063
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgDTPmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:42:20 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:59877
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgDTPmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:42:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keYPZHid56H1OkopylqDMRrdL5I2fXexqBknwWroQl1d+zGeG9zPDrs3PyRBgqa4Rmo4R3nGKNoQPRh3mtaxmQElPEvKuuyTkkTdP1hT1+O4qN/dd1J1Rfw0GIDxKJ7tU7tvNLR6Nddkzo9vuQdywTHnOldKmGyvBnEIXFDJJogFmEfvlc8rZrxWrQIsEND3NKP6siHqjZHJO9rpg22GE849CW6jLeO7O1RbK464o9eI6OpMUmctnrXn1Q49/3rhPWLviSgwZDXAhjjti0lpXFTIES8Dbng/oixw4R6F7oAxNSZaw8KyfLaamEAyWq0nr4XESC+9a4/pc9OSHUMBQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/II/Ycv1coMzjXGzGCL9JnrbmlZ8FYi1sjsVKxTGjI=;
 b=fL563Gm7B9BBgBBYjcttlGm9eA67kRH4aL4RWcyQtxZn2k9rgIEHloa56G3wgKZqI9eLdhDBAKaI6+LzI/5HltUoDoeaq8cw4MiJsf134J6XEvbM71P9z66Z6YwHxK0Bx99KY7J+KgmFVXZXyb7EeWuPcYeUv+DsHynKFYJ7KB38olu6PmTmZYFEmqGIs16OpSSpYwZfomLhgt8yAEg379voEOS8hSouRsuWv2bSeIxO4cBS3qXmn1EKnDVqqeg7Blqm1vzDWvNdVE+zT/nMocowtPRp8jiWgV0bAfW5YexwnJm9A5BEuD+4Mb9yLnjxX7x3KZ9ryIx3IAFtqvnK2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/II/Ycv1coMzjXGzGCL9JnrbmlZ8FYi1sjsVKxTGjI=;
 b=A6oQYxrGpezvwLBuqsJHGIu30xSzy0Uo36mnrJUv8idg+p5UzoORqRN50dSMAhOEkJDl10F9g/iQ1LKnfRbDCGbX2WbDCftOxwvLZPCiVtq3aBx6Kou8nj3QVeYVd1IkDCrEtcq5BG+Zag61hfxRRKZkD3I/DaPxeCHQOFg/Huk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6084.eurprd04.prod.outlook.com (2603:10a6:208:13e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Mon, 20 Apr
 2020 15:42:15 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 15:42:15 +0000
Date:   Mon, 20 Apr 2020 21:12:02 +0530
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
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next PATCH v2 1/2] net/fsl: add ACPI support for mdio
 bus
Message-ID: <20200420154202.GB27078@lsv03152.swis.in-blr01.nxp.com>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-2-calvin.johnson@oss.nxp.com>
 <20200418114116.GU25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418114116.GU25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0186.apcprd06.prod.outlook.com (2603:1096:4:1::18)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0186.apcprd06.prod.outlook.com (2603:1096:4:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 15:42:09 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e1d9552-0ad0-468f-ac60-08d7e5416632
X-MS-TrafficTypeDiagnostic: AM0PR04MB6084:|AM0PR04MB6084:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6084A45BC26BD48725513287D2D40@AM0PR04MB6084.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(6916009)(8936002)(8676002)(81156014)(55016002)(966005)(9686003)(7416002)(478600001)(26005)(5660300002)(6506007)(1076003)(86362001)(55236004)(66476007)(66556008)(6666004)(316002)(4326008)(33656002)(54906003)(1006002)(7696005)(52116002)(186003)(2906002)(44832011)(16526019)(66946007)(956004)(110426005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fBlHXC33NnvInoBMszuuONW4dSIDTknBLfZkiSxyWfM4qosBEBCE7YWGtssSxIu+46QgnD8t+l5xKk+CfNJZI9FYUQpSSAkrUFnVkAyXVq2yYNI9mMHPxOV/2YlAA7BV/dEjS2w9P9SbLrtncxUigKlVbs20PM+Dt4krxwZFQCby8m9UIJSCblFk0mxuDWg4cPb5bvlwktDDYfViG8xqt0DcMnPAqOYP0iXACCSsy54xzMN30ZbeTLpA/cOGPjHrlXRpKttCJJZ1z4jW1S76B8Rr/YfCchlv+32QktDjCN62XFXqDGUI/3YfBxF5YLjVH/RxXqUrcFdBIN5S58yzVo/kY6Y/2Qrz9BrDMa2HJY9OK3JwpXxpxjtUgH5QmCsJLSrFjdY3EOZHucH8DbBOwtMlZYMzmqBy58mCw7ICeqQnI7KG4ckWCvlzKCIin6654KBdiOIB5+ZuDFSTQSy8+G4LwZ/pAuULH/ZMDt5mQoOMcd8bwYvFvT7V7Kwm3wxMka8TsyP/1Xq7LQuQcOrp3t3sYOyrZbKmCLJE5cF3XPgR6O/ghc35pRyW42kp4hK+SmweYhcPeaA551O1PaWuQ==
X-MS-Exchange-AntiSpam-MessageData: ZWuZZYuCnBotM3fcTpiZMGuCTa5canTiv7uc30Ifr+9Rz14cMxn6OkcxU1KBZKm7FDG3oOlbidWWxd3O8BNwRTqw7MHQFTu+V/fMTYRJLOtvS927ubKLP6AraMzkce+IC2ZH/zwQw7mRroANza7kag==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1d9552-0ad0-468f-ac60-08d7e5416632
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 15:42:15.2183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7nShog1vvtx9yeiTswYBMGgD8MuLMCpaT9+qKe3jXS6EvWVsTe2jATLiqLScgXeqhevwoZXHRauHklW0qRfxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 12:41:16PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Apr 18, 2020 at 04:24:31PM +0530, Calvin Johnson wrote:
> > @@ -241,18 +244,81 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
> >  	return value;
> >  }
> >  
> > +/* Extract the clause 22 phy ID from the compatible string of the form
> > + * ethernet-phy-idAAAA.BBBB
> 
> This comment is incorrect.  What about clause 45 PHYs?

Agree. Will correct it.
May be we need a comment update for of_get_phy_id() also.
https://elixir.bootlin.com/linux/v5.7-rc2/source/drivers/of/of_mdio.c#L28

<snip>

> > +	/* All data is now stored in the phy struct, so register it */
> > +	rc = phy_device_register(phy);
> > +	if (rc) {
> > +		phy_device_free(phy);
> > +		fwnode_handle_put(child);
> > +		return rc;
> > +	}
> > +
> > +	dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> > +
> > +	return 0;
> 
> You seem to be duplicating the OF implementation in a private driver,
> converting it to fwnode.  This is not how we develop the Linux kernel.
> We fix subsystem problems by fixing the subsystems, not by throwing
> what should be subsystem code into private drivers.

I've used some part of the of_mdiobus_register_phy(). Looks like some
other network drivers using acpi had also taken similar approach.
Anyway, I'll try to make it generic and move out to subsystem.

Thanks
Calvin

