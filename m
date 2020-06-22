Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037142038E3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgFVOPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:15:40 -0400
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:6269
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728753AbgFVOPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 10:15:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEKl/tWzv3Da1U7kD+42QEtm29EY8FwPx3kHDOXWTaNVFy+8dfyWLsn/9JEKBoiAZsLZsixvaGZxI45lLIsnensGpORocd1eaWjSJB7tjhIywFqxheA9HhSJ+5iEq3ugINDzqO5mAoIwkRUPZpj95CNUrKztcAlGFhcKpQhCQcupDIuYfYhzo7jmPmffct2aVSq8zSDhE+D+7j6c3gn90kR1OufGl7PbqEYeGhBzGo66WlZwoLecsrrKcljpALTPr5kgcJfyuuNrzgKLSZ7JcZbQb4Ug8yCCtfq1M+oSjP9W36e4O0DZPV96oNUXSYXAlq7fbOju8vDmobWje7psaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUTuq6KADorhUsTZ346cLM8GX5wOYubY0YAWtH4Mw1k=;
 b=KaWSKh3fF6dHNrBjCjFrCVO506/bi1nBcv5PPp9YbTzX6yssBeZL5dVo57J3/xBzXAZdB8R5D9CCLgDgo0fmpBSZKquYfd4oYu5I/+p25WoSfSMWjvWu0R4EH+mQ0kgUDHfV+Kk4PovpEY5QWNORwgsSBObEHNQ4o/u9M+bkKHPNuyCJ+rXaZXozr6UjLfGodLlUw4dLrt2STaornPwgNjPFCiWUhBRrx09E3msrKmG90NqAp8JzyKEXmTT7jxL6PofaR/BaOYHPupU8vP33FflYZPzmHzhhLKLwW3nJSFmrgOTfT6XMYlGZn6/EVx88LFGsKhPZ7RScbtN/yUT9pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUTuq6KADorhUsTZ346cLM8GX5wOYubY0YAWtH4Mw1k=;
 b=hc3HjR5lwSgEBPZ+3dkbNlP4IMtu9Dzd4LF22esV1BDVInUMGoumwIU2sIAarwYAd+41TrIn88YXU2LMgIGMMDQHXcJu4y2SiUGb4gcm0UouXNzJPoRaAmHj+wn4cctF0lCYwDUDnasEQSAzACML3QUSDSTO159P5fpmTQO78G8=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4738.eurprd04.prod.outlook.com (2603:10a6:208:cc::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 14:15:35 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 14:15:35 +0000
Date:   Mon, 22 Jun 2020 19:45:27 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
 c45 devices
Message-ID: <20200622141527.GA16418@lsv03152.swis.in-blr01.nxp.com>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
 <20200622081914.2807-2-calvin.johnson@oss.nxp.com>
 <AM6PR04MB3976D2F9DFD9EE940356D31CEC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200622131652.GA5822@lsv03152.swis.in-blr01.nxp.com>
 <20200622133619.GJ1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622133619.GJ1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0120.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::24) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0120.apcprd01.prod.exchangelabs.com (2603:1096:4:40::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Mon, 22 Jun 2020 14:15:32 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28498a6a-d021-4258-95e4-08d816b6bb43
X-MS-TrafficTypeDiagnostic: AM0PR04MB4738:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4738850073659A99983B2E9BD2970@AM0PR04MB4738.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkxQnp6QJaVIbfhS/DL12yDxqL5bDF+kUuDo1mf4tpNAjwfZVVp2rLfUuPK/qemUoFDTHgtoVQ4Ryd2mb4CmGzCfjhSPvBePjttvAXFRY6Bn6WdmE6NV157WK4p8BK5u+JVHLRBKURPtbmQwrnqjtzvYQGNlWq79WiXcQ8eq3fwZrx9kEpE5lYQcXipeeh78PeC9X+U9tIhHD7/QkZKDaz7zaWjqnoO9al78zx8txbDLSZAJtBfwS5oGOAPUZV9Mn8RwklYPPLj0JYahjKxffCxxq+Y2+Z2XNqykmNNP+ZtjSN/YS8rCtV1wl6OGagr8fkpmaPtfxuDUOjZcMcGwxHLknmbBLr77rVK2SaMPbbOgOEKV/HALi8QPX6ri2wsa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(478600001)(6506007)(55236004)(26005)(16526019)(316002)(186003)(53546011)(52116002)(7696005)(8936002)(1076003)(5660300002)(9686003)(2906002)(33656002)(66946007)(66476007)(44832011)(54906003)(66556008)(6916009)(1006002)(6666004)(956004)(55016002)(4326008)(86362001)(83380400001)(8676002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c41GLXggPdoh33ruXhrGnu0oXN94Hw3GySa0kZ6lEn6PNbf61WLxlWaqkY4G4nUtplQ8FS6dJvToq1eYbl9Ze+jEDHvDuJbiz75qhA3HVbigIpIEIaOoBvJr2ufkQaGELBmipp7dX3aymmBX1NJwL8qK0CMCw9XaoomAg4ssHKPnDBQ9CozRrEAcC2WMBkdpmc0s8OyZZT8FsEr60i301iie8ryQZgMv1GgHzLm4KWthDXOSES6+LROcshqYAhGONEhXlMKDqs/SSpxOKl/5pxaFbG4XZLR89oW6RD0VquJjbhY34l+1WvXQaEegeULFjy5dOARZT2zsXro2vgd8ZVKByu0NdQIAiV2w9FmRRYPPrSS7IJQuLe/LRzdWawfRmMnA/XUn/E8Or15Mk6+qLk+g6xwSBd/CLY8CK5NJZqxPpvwbwR1+WmRwGve1/J+hiYsRe2YMJ8uYusosNSPuax8CaTWGcRKxBs7oPDkKCUqrKwSQbusu10BpsG/RIKvp
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28498a6a-d021-4258-95e4-08d816b6bb43
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 14:15:35.6561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cIhPUEUrtshj0YiTwj8eSVD1lTJtd1nw15stNhbECKQJEH7/B8+5Ghwqg+PQh0IlFZXVPDwbGGEJZNjTvHMLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4738
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 02:36:19PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Jun 22, 2020 at 06:46:52PM +0530, Calvin Johnson wrote:
> > On Mon, Jun 22, 2020 at 09:29:17AM +0000, Madalin Bucur (OSS) wrote:
> > > > -----Original Message-----
> > > > From: Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>
> > > > Sent: Monday, June 22, 2020 11:19 AM
> > > > To: Jeremy Linton <jeremy.linton@arm.com>; Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk>; Jon <jon@solid-run.com>; Cristi Sovaiala
> > > > <cristian.sovaiala@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Andrew
> > > > Lunn <andrew@lunn.ch>; Andy Shevchenko <andy.shevchenko@gmail.com>;
> > > > Florian Fainelli <f.fainelli@gmail.com>; Madalin Bucur (OSS)
> > > > <madalin.bucur@oss.nxp.com>
> > > > Cc: linux.cj@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> > > > <calvin.johnson@oss.nxp.com>
> > > > Subject: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
> > > > c45 devices
> > > > 
> > > > From: Jeremy Linton <jeremy.linton@arm.com>
> > > > 
> > > > The mdiobus_scan logic is currently hardcoded to only
> > > > work with c22 devices. This works fairly well in most
> > > > cases, but its possible that a c45 device doesn't respond
> > > > despite being a standard phy. If the parent hardware
> > > > is capable, it makes sense to scan for c22 devices before
> > > > falling back to c45.
> > > > 
> > > > As we want this to reflect the capabilities of the STA,
> > > > lets add a field to the mii_bus structure to represent
> > > > the capability. That way devices can opt into the extended
> > > > scanning. Existing users should continue to default to c22
> > > > only scanning as long as they are zero'ing the structure
> > > > before use.
> > > 
> > > How is this default working for existing users, the code below does not seem
> > > to do anything for a zeroed struct, as there is no default in the switch?
> > 
> > Looking further into this, I think MDIOBUS_C22 = 0, was correct. Prior to
> > this patch, get_phy_device() was executed for C22 in this path. I'll discuss
> > with Russell and Andrew on this and get back.
> 
> It is not correct for the reasons I stated when I made the comment.
> When you introduce "probe_capabilities", every MDIO bus will have
> that field as zero.
> 
> In your original patch, that means the bus only supports clause 22.
> However, we have buses today that _that_ is factually incorrect.
> Therefore, introducing probe_capabilities with zero meaning MDIOBUS_C22
> is wrong.  It means we can _never_ assume that bus->probe_capabilities
> means the bus does not support Clause 45.
> 
> Now, as per your patch below, that is better.  It means we're able to
> identify those drivers that have not declared which bus access methods
> are supported, while we can positively identify those which have.
> 
> All that's needed is for your switch() statement to maintain today's
> behaviour where no declared probe_capabilities means that the bus
> should be probed for clause 22 PHYs.
> 
> This means we can later introduce the ability to prevent clause 45
> probing for PHYs that declare themselves as explicitly only supporting
> clause 22 if we need to without having been backed into a corner, and
> left wondering whether the lack of probe_capabilities is because someone
> decided "it's zero, so doesn't need to be initialised" and didn't bother
> explicitly stating .probe_capabilities = MDIOBUS_C22.

Got it. I'll add the MDIOBUS_NO_CAP case also.

Thanks
Calvin
