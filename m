Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E32B331073
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhCHOLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:11:51 -0500
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:13377
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230385AbhCHOL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 09:11:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBbpDHnC0/E7+NoYOAqNom97G8BrOm3BaYjjt2Fn9MfxF1I3LIp3PNb0zm4jSIY5szWYvY6euQ+lapJ1KZygi+QF+pUFBPS3zLPn4AvO7eBvcf5ed4XWSFx/eaqxB2w52aUpWaKRmRlPYhixciRiS4r+B7E2pT/WkztnU2NVzU3BKVt5hfa6tT3rwY3IyzlsnKftQCqW6bmktezH4Wcebpj5DjFON3wKq0FN6R7tomeisob4nCfETZ6fYD6m9fd9ONI3PoupTtussBfL7IYPCfaYVOA0D/IgOSaOlqvELR8vl3JKypX49MzsoMqsF1aAbcqUkRbZYfh2WoQW8kNfbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njwku96z+ik4eZTEXjjEMudbDA/4Gp62dfrdmVfgIwE=;
 b=eH0MWpBvd3N6ZyBxaTNLGk8qETWRwdYgi3UUizln17KqQLcg8NWe11ppRs71q2FMDnV9KV6DjszplAFY0iJBSrIIuJxyXgPWMr7AvN3y9KkqwnSMIQ9NO8/7Evusszj9ugSPJ/esZlFtx3ZgAyB4c7VbG8BpCqD/KwCgOfy28PWmW50T5qFL3MH4fkbQHQSDlRx76vtTs/YK3v2J9WU7Pz2Qf0XmQlnoeq42VfYnr9lOec00WaqBCftlL+hkhpkkwfKOpUZ5EuPLc5bW78+eFwyK/t0RCaSvEmEnvyqkH4ToyNrOfk+JAPCT7nuVv3qAZx4nUvZ3v81IZAlSVeOsug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njwku96z+ik4eZTEXjjEMudbDA/4Gp62dfrdmVfgIwE=;
 b=V35sAx2B5GOMSTsAO9uM+/+znv78D9UYNJ9Zzxz0rJbDa+4ZF6Potfi6A1Gctyw7JX2vOiFZN2vEWWXUJ+lGo1slaM3hnAybhSl8nyNyN/Ow7JUi3Rds6pUHRb6i5skMJbd1j4JuPj8f8AYhhFCgCLCLtoI5nYxlPvKnjX4sUCY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3907.eurprd04.prod.outlook.com (2603:10a6:208:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 8 Mar
 2021 14:11:24 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 14:11:23 +0000
Date:   Mon, 8 Mar 2021 19:41:00 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v6 10/15] net: mdio: Add ACPI support code for
 mdio
Message-ID: <20210308140936.GA2740@lsv03152.swis.in-blr01.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
 <20210218052654.28995-11-calvin.johnson@oss.nxp.com>
 <CAHp75VdpvTN2R-FTb81GnwvAr_eoprEhsOMx+akukaDNBrptsQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdpvTN2R-FTb81GnwvAr_eoprEhsOMx+akukaDNBrptsQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HK2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:202:2e::20) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HK2PR06CA0008.apcprd06.prod.outlook.com (2603:1096:202:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 14:11:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: befe74d6-2155-4866-5442-08d8e23c0e08
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3907:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB39078178730071B917E6DBF7D2939@AM0PR0402MB3907.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yqWYz8o6NPRnuIkpTTiM1C90cA/OI9Axx8qyCndhbvvfU+UfeSxy9mTCreQmtlQtIFOdc7a2CjLBWBZTAas067JdkX4MsOKp7QYfYah33IPd/E8Gk8XBNVagV+XmqKxhEFYzuE1P3RAubwOP1qXvYBr0lRiQf5mHmO4Dq5KFtpbRV00B6Fa3G8XSev5HR4ek3aXh4KJ5Tl34nNMk+9kSn2c5I6vhIe9ptKyIX/9ODZI3ZymF8HT8CzNj0PLg/EKShXzpyw3sGauAUvv7mstM79fUdMWddOS5BTqVv4SBAdsEi41g/AnNdsBpxD4x8YSISq3I57pUnz3/Lo9IqMZE8+5Zy+laUeIp4Fxaosoh9+bPQt/LbU3iNGFG78XlKuKmFukuIxwUYknpUGQZko6qfWIwanjublLWjCTVWhxC20Yae3vMm5NWjDPkcXt5fdbhVOSJEje4NRa5ynWBpNV5YjXLBFZYnumvjS17RoBr/uV0Thxn60c1l7iwS4IG0h12vKeYmxYGYDHCkVu4cpIX2/o7M6uRRokQC3jK8/pELWaJ5Zb6TgBa1UvXS/y6fvUS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(7416002)(26005)(7696005)(44832011)(16526019)(86362001)(1006002)(186003)(52116002)(55236004)(316002)(54906003)(8676002)(956004)(6506007)(53546011)(8936002)(55016002)(1076003)(9686003)(33656002)(4744005)(5660300002)(66556008)(66476007)(66946007)(2906002)(478600001)(4326008)(6666004)(6916009)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ScfYP1dXR3VwRuNq9kOgM1K009PN1XLRLjWEbrM0kyG0Vgel6RN6QDGfmCV7?=
 =?us-ascii?Q?gLOmS0D0e1n6CmQ1yaNkLqgTg9ypK8v4c7hKHvWUgsBwj3R3BIdhsYpQqQDU?=
 =?us-ascii?Q?5ZZRibofRqs2B2CbLTnpqqBNc7ZIHOrF30CJAhN1+Yk/T27fF/cAWYLh15bu?=
 =?us-ascii?Q?OJMNkt3FKq6VD2pt+QK+H+sHAd+6PLbOXe4qjU572dqFclcgNFlIBO4oe/Fd?=
 =?us-ascii?Q?fsbDXhAjgY0BfUg4XRGnySrg1x8c3h1OGZ3rw7kBsg5XurKwugea0BKJbdZi?=
 =?us-ascii?Q?uNe4LopHCvGarhvMokJoJjhp4JYxI4xLxEVTwA+U97gdqdGQ2uwy64JSqqCf?=
 =?us-ascii?Q?Go2PsirCHs/S9Qh4HUBoGp+wjle0fR3h3rrKezDLMSXogLoLdVG1DQpFA3DZ?=
 =?us-ascii?Q?G/+hImjFVPRVD8ADuw4Rrs4gMAAxq4rDJC1w2E02NkXwx73tsnhuHZ0guh+L?=
 =?us-ascii?Q?2/zK7c1m3d63wjJXs3E91GzyO3fuwEOhSJPEjf0A92Xv7Wb1VQ+WfGdHEZD/?=
 =?us-ascii?Q?Z5TCh01Hd0PJQIKIZ3/Bq5/QUkP9bYcWqaglJzwIwqSlxdpJOtLL0DAyoPWE?=
 =?us-ascii?Q?31AVHe1poIll1YmE988TeEePtKdby2Cr6JA1RxOGRi5mpJbkCJ4JBoexwhAj?=
 =?us-ascii?Q?HCa8+BMA5m02aRdxJ5tt+yZx8N9P4NFbMdtTO+pe6c1tt/sTUtsZEauDa0Iy?=
 =?us-ascii?Q?3lrQLYSTfnE29FFsravsrygJiZr5Q7oBW4Smvwej5a3rgofKmvdY8bNJSMSw?=
 =?us-ascii?Q?kCLgsgUbZUKLWJtoQC5rV3WDQuZln8CRsD4yfEM1orguiF7J1K/cOf2hornN?=
 =?us-ascii?Q?tFy9yTT8/T6OXFO9nYJeXbBaLaFr1ZZ5B6mvflVxp7f5UbdyrV6juw+ylBTt?=
 =?us-ascii?Q?OG1hxbUXj1Qx9/8qrBGILmnYHhcQHDjXcc/fAHZ6cRNLvBF7VQE9CbqnJ4wW?=
 =?us-ascii?Q?Uf7lZtPGu6vFH52qY0JjMOuSKUfkowf02FuuN0c+NjzhuwXQA6azSgMcmopW?=
 =?us-ascii?Q?lYkNPEqVdd3jCWF9Ag/LcS2MY95SlB2SgJiB2StI4oTjy8eY7BskuyZwVt/A?=
 =?us-ascii?Q?n8+opc2rDTTYRX42UlYXmyB32bcxznqNpr1lyNkc+DLSIBhEGq0sI5kVJdH6?=
 =?us-ascii?Q?1jLy1lQq7YASNNyRrL7G2Bf6lnHDme62xcPFn50oizbOt0a7+70WATvz8WdH?=
 =?us-ascii?Q?uPWIdd+8UDDSKL8PI3k/xh+UrSM0s3B51JijQ5QrI9SA1+2az7XpQbkT9+Ap?=
 =?us-ascii?Q?znFMCw7+8Qhxh5BVysbzTilWTbxrrX5gioowkUfIacsAHM7+/tUrQ8ktbKFh?=
 =?us-ascii?Q?1jKok4mRfgvKASPGQ0wS38G/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: befe74d6-2155-4866-5442-08d8e23c0e08
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 14:11:23.8734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LbMHZDwRzcq6RokxRlD6Vsah6I8rIhPvaP/Lj2beQDby9bv3Nm7/CpEkVIS5X54oIVPISAZhcZmJ8FydMHBKhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3907
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 05:08:05PM +0200, Andy Shevchenko wrote:
> On Thu, Feb 18, 2021 at 7:28 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> > each ACPI child node.
> 
> > +#include <linux/acpi.h>
> > +#include <linux/acpi_mdio.h>
> 
> Perhaps it's better to provide the headers that this file is direct
> user of, i.e.
>  bits.h
>  dev_printk.h

Looks like device.h needs to be used instead of dev_printk.h. Please
let me know if you've a different opinion.

>  module.h
>  types.h
> 
> The rest seems fine because they are guaranteed to be included by
> acpi.h (IIUC about fwnode API and acpi_mdio includes MDIO PHY APIs).
> 

Thanks
Calvin
