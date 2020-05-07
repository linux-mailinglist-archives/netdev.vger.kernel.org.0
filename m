Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F191C83AF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgEGHoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:44:54 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:18689
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgEGHox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 03:44:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRyBeIrOAEUQbxeasaHvdp7m2y9cZoYKFrZ+2Bje+bKMG7WpUHnfdKegwQ0hxmb6oclopjB7XcODCezDopNJy+CbrQD2sNSe3jV76LLPzwjM9PtkT1Ekm54HgAabsG4XBQ97K16CsMPB785flJB6oXq5jm781oL6zd0v9eTWnO0tVv4lMEmcuWflDUW5RpO4zhEI/9YqjX1F8YOto3xqm+K10J0kO8aTh6+3T3JQcQRweUGv38Z4wQ7cV/Xk/eDImhJ846kvrlhDP7Adq7KnfIUiSn5lQtMovO/Rk9HnEt4rZdoF4dEnSIHsxYFDzK7MvWlvM+nrv9VuXw/bxiFoEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHxS2xyHpsRPPIWtvTHszsk9Bx9HstHAWhmIu41Ty+A=;
 b=lvz5xD4Az0ATdyhL1OQQWcX/yMGAzKRqArYTzSKf9N48jO84bRxZqgc9ByWLe/dahCUzUVgb3d87EQiPXbmAKGqEQOlgcDOWwR5LcI+9PijUy+JqC5JxITg46GETxt7/KAkOuyB7UDnHd1yhooOXf7BRZo+OpbvPvymUsQkyjg0iAFB7fdZPJNzy87Rzi++UurQZJEXATFFE0L/mgQgi5zG7iBfJl6rZjL6x/j5+RO6PnXP7uq81z4+AZ/IYWYz/xYhgMERqmn+0c7gyaIXabP5LxMSZ6+U33V85n0v7qCf3WyFDlEVz89LZp5DTul22zpRoPUDOzJt9M3mo5c0Uqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHxS2xyHpsRPPIWtvTHszsk9Bx9HstHAWhmIu41Ty+A=;
 b=QHYOA1ooSBTAbu3/o3hwhBdCZd/3vavXINa1ZxabOQJtnBROF3P65XR16uJGONz69Yb+XqR6b9sSdt+jH1bRjqcfh3yIDwwgGsND+39P9D5HaQCWXMrHb2J8+2sDWo2pyxfd+OGZ38VdC35fRGaWPYSCAvpWAVIE6DvJEqbusvU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6516.eurprd04.prod.outlook.com (2603:10a6:208:174::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Thu, 7 May
 2020 07:44:48 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 07:44:48 +0000
Date:   Thu, 7 May 2020 13:14:35 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 5/5] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20200507074435.GA10296@lsv03152.swis.in-blr01.nxp.com>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-6-calvin.johnson@oss.nxp.com>
 <CAHp75VfOcQiACsOcfWyJSP1dzdYpaCa-_KKf==4YCkaM_Wk3Tg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfOcQiACsOcfWyJSP1dzdYpaCa-_KKf==4YCkaM_Wk3Tg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0097.apcprd06.prod.outlook.com
 (2603:1096:3:14::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0097.apcprd06.prod.outlook.com (2603:1096:3:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Thu, 7 May 2020 07:44:41 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5084270a-3d73-462c-d2e8-08d7f25a8416
X-MS-TrafficTypeDiagnostic: AM0PR04MB6516:|AM0PR04MB6516:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB65167C8661DBFC1EEFDFE055D2A50@AM0PR04MB6516.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZFywUdbZKsBavJMQXUJVzCcKRLgFyFnjtrJrcAfCQgDP6RzwLdAkeIv7pJzi/7kb1RkoNgG6pxsVFP2V6Yn+lGl6RVVoCL1YHllZIidnGNyaf8WJCagtU91nquwHul16IL9ywX2YRurinNQtQM1dx90u+fNXDho+UbBGSZSime1qUwz5aSYSLo6OocE5CApwjVosFB52IgDyJ4dTWenFNlf5TR/wJfUfRdJ0OuDN3cWDuF89EJREWUnM53PlQdxGUWw22+43zK7jBQ3syK17MY2EbNrZokodEDU4nk7tuCC+6TZGsPn3YkB7g/cNmxGqNRPQ0obofPWzRFUa5aBososMh5JQw740VZi30aDdheY/vcQ0ZL9UhZjlKNqZaIZ0wAdb5kTuDS9YhCJqHA5NLewiFMlKlH2PjSzxypfCEiFGJMXZHYN1HoRDMjEb73zSxvVHmbx0GHOh4Bx7pfGwt53fV0ecXH5+5GTvuLZ9e5cJbHAMfYwuDHIgW5w4O61r1WrtRuH3k8YBkq4lmIWdhQ2OuSYGxadMViykkZcYJHHPb4RGi9qmpWWjbNjsFUj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(33430700001)(7416002)(6916009)(55016002)(4326008)(478600001)(5660300002)(33440700001)(66946007)(6506007)(2906002)(53546011)(54906003)(66556008)(9686003)(8936002)(66476007)(55236004)(956004)(16526019)(186003)(1006002)(1076003)(6666004)(33656002)(52116002)(7696005)(86362001)(4744005)(316002)(83280400001)(26005)(8676002)(83300400001)(83320400001)(83290400001)(44832011)(83310400001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /KHV1TmiLjANoEnpv1d1Hymyd0o5yD/XgwVYNVPrJHnWIzCIOjNxX3+rl1iJWTC9TWQXxp9YvFTSEyOIYe22qv/kcsSeugW0Kp7MfWMD9kr/BdqwsgzzJLQHx3pFxz3irahH0OOav/r8F0HqHNONtdIZAe9KVleIGkSD2fD58tMJZ7gmBYHWqbWIFsJWIM9JPXqned6/ZjNEEATJFyUdgsQ0d7h/CVLG56fpRN8JTYYhKxHVaUG3IJSPwEeOtZefjKUVlXMPXDhRU/lSMHWqZ9fJeaNQlpKmITIAFM8GOttSNR2LVaQdLd04/StUlTK/nrg/+ViySIITuMxp4K/gQ51m0nh58402/4ZYhF7FoI7TWCq3HVCtKDtoKoCuMv5CdW1NNFZlVLOJfLH/CnaSGb7N+PkvXrTl4t4xrid1TAMrOsKqTJA6svNt2l9f4mQ04PPwkYUSWYOe1tUpOgf2se7euc/viNaRJhwwfhxUYQqTr7RGPi1zpIrmz7XunZDH8IDlCNTEMGO2ojtCNx63T/YDLFEjDaUPActJ4q4890S6VcL2K9tSq+8LoseYkLdNtd0dy6OkttbUGbSNwOcErwqtcn/r6GPxNybxQP6MX7LjZyy/YlTYgSQSCeazEMI8sxa1viM2WneMLWGBCvTumWgt7nnHiMkH6pvY7NTtYjZQqBIeeO2+wKX8SYcUhT0ULEsX6sm50xt/9Cy9zqXAPavXO+AS9F5ji06hGXhWjQrjP6JOJsvr44zOJ3YZfXTC+81ABxD+d0dAEtiTTjxfKN195+VAlZX/Gj0McRSun00=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5084270a-3d73-462c-d2e8-08d7f25a8416
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 07:44:47.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+IOurK3LSnC7+4BH5QRxmcsVhATqMME1Iz3OmrSdHewnKrQ4JYtGe81HBmSjENa/dInowbZNzjWyivuHRpkRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6516
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 05:22:00PM +0300, Andy Shevchenko wrote:
> On Tue, May 5, 2020 at 4:30 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> > mdiobus. From the compatible string, identify whether the PHY is
> > c45 and based on this create a PHY device instance which is
> > registered on the mdiobus.
> 
> ...
> 
> > +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > +                               struct fwnode_handle *child, u32 addr)
> > +{
> > +       struct phy_device *phy;
> 
> > +       bool is_c45 = false;
> 
> Redundant assignment, see below.
> 
> > +       const char *cp;
> > +       u32 phy_id;
> > +       int rc;
> > +
> 
> > +       fwnode_property_read_string(child, "compatible", &cp);
> 
> Consider rc = ...; otherwise you will have UB below.
> 
> > +       if (!strcmp(cp, "ethernet-phy-ieee802.3-c45"))
> 
> UB!

Thanks for the comments! I've considered all of them.
What is UB, by the way? :)-

Regards
Calvin
