Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6512B2DCDA6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 09:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgLQI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:29:12 -0500
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:17632
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgLQI3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:29:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffSyFEDr+9YgCsb7PTKyjViye1CcHBy33ENqb2QfZOPJHIpLJssx3yLSBTAuPNiXOUnVINfj8alwCm2RXX/r3FPVnSVqHrr3Id5feqE35BThQ9ujelfhc2yAfb77nSQnBdHKaKZR0ZoA7qIXt2BG/MwbH0H7TGt03eI7zgF0ceL0h/2Gv3BVi8rpCzVenf9jOk3cGMK6ltwapYZ/2yOksHw2jrNleja1/4iy74GZcL1ip/IBiFt9ArXpkA1AqKvT5Fy7v01jX+s4d1Q0tpMo0JmRbg8o7G403VwVI5vMjyWZcUwZtb7p/6ZmJJCgF3IWB0BD3wgqv+K85GuPLY8yew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MydZuylGKOYhvw0U16zsCggDRgIx3owZPAw59mNCzNQ=;
 b=eUP1P8eWYtreuFux9HunpD9o87r0QVPcTrLrpujkvqgETyl44KhSugqZCa/fJ1Zmt/VDtgUxmzUPQkcPg+IzHuKFN9IdpIHcLFGjJq7KqQel2QNj2ZWMR558UVBKvCBKy4gUFq8PP6f5KNMC7E6E4YbDCW9nYOuMr4ANV/tG7uFyZb85Wp2stGKMU3+e5FfPdMyQoBzh0IMuxMaxO8dYVZMfMdYmcITxqYn94ohIMuN7aOq/Cu3xijMTKjmFZJwmtKUK9Se+5We4+ELRoDRJ53Fdrhpg8c2a02I3KVkLHUGcsWbLCGiDiRjdCbOFOa6be2gSqNGz2YSHL6T4mBju7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MydZuylGKOYhvw0U16zsCggDRgIx3owZPAw59mNCzNQ=;
 b=IY94xYyG+O+PXByHcavIpi9MVWy04JQssNAmQENUlJq+078DNFMDFkG2EDNrUR/upjWaktZ9653elYicJiWhWn1tKg3cKLkP7RShtntuV4LP6XXOrZ/PlwrvfJv61yBnlwviCbRLzO9DasfFOsZ/YvmE3YDulJNKKYC3DtoiMn4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7891.eurprd04.prod.outlook.com (2603:10a6:20b:237::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Thu, 17 Dec
 2020 08:28:20 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Thu, 17 Dec 2020
 08:28:20 +0000
Date:   Thu, 17 Dec 2020 13:58:04 +0530
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v2 04/14] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20201217082804.GB19657@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-5-calvin.johnson@oss.nxp.com>
 <CAHp75VcHrBtAY3KDugBYEo9=YuDwbh+QLdOU8yiKb2VyaU2x9A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcHrBtAY3KDugBYEo9=YuDwbh+QLdOU8yiKb2VyaU2x9A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0130.apcprd04.prod.outlook.com
 (2603:1096:3:16::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0130.apcprd04.prod.outlook.com (2603:1096:3:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:28:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d3fbc94b-8bd5-46b8-2c38-08d8a265b61a
X-MS-TrafficTypeDiagnostic: AM8PR04MB7891:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB789168DFB65A26023EDE9DC6D2C40@AM8PR04MB7891.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSg1uidOuWftp9xap8h6LmcPJdLBWD2KhUVff9Vsap5/a4Gadr5rsuizV8l3nEaQyeY89s7VdRBuY9mlCpp26F9NSkjdAHRq8K/7JDIg+xA1HQq87Lau/9F7ybFM+TqS60fXkpbFDgoLlKAYcZ0N6ep8/kyvbCeKAB1HDJWvzcpVJ9XTLxiCwCoI7/WZBTe77Rg8IshoBRXglFIZFrCccosa5uMXbC7G2MLchQapuJNp/kSdTDuo2zTj4oGofp7drnaS+YTbfOEViRU3/vP/1isvCZC844vDQ7a4dFJYAZJEKkknMpaGsmim4BPpWj7mpTxLeCDZPEjnheKs/2IhHJPGhtqDETYGjNZ4OmNq77hlN+mp9hVUHZRIsI4LU6xT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(7696005)(53546011)(16526019)(66476007)(8676002)(5660300002)(4326008)(86362001)(52116002)(66556008)(1076003)(33656002)(4744005)(2906002)(6666004)(316002)(6506007)(8936002)(54906003)(26005)(6916009)(1006002)(956004)(44832011)(478600001)(66946007)(9686003)(55016002)(186003)(55236004)(7416002)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x3gInD5jJAONIC789sblHqo89ZsKKrsskKFmuiT1Mqkx5F3FFOSsSfRG2a51?=
 =?us-ascii?Q?ijR/RgPNmKLyu9LniE08dcIP4bGxGOgRczyVC3ICMkVwXP15Zhtin/V02Za1?=
 =?us-ascii?Q?58cbCYjsC0JBzqYVi0vr9ZCdOaESyWYnCxN9D781SZIjldmSMshjQyqwwU5Q?=
 =?us-ascii?Q?f/MUNPDQXEWhZGa/8RvgnGn16NmhzREIQF+IGxPlJ/wrxa6sS7ZTte217a+4?=
 =?us-ascii?Q?YT/ctwk9Rwq8UoOrVQPVtE13D5+VBbGRCrcx7tQC44XrwaOPUOjNVBhnZM8+?=
 =?us-ascii?Q?UrPO6dOoN7okT/ibwUYhR5M2slPuMJmdQ2amNzQ1EyA+geBJvQAHa28vSYNO?=
 =?us-ascii?Q?YqiGJio8Kqo19ep09tgfbaMlHeFDZhzCkAVXUsEymaq/cfBP1/EjmNntjfh9?=
 =?us-ascii?Q?BKb3rPRpo9kI3TcHWWZVdmYnwmNpBuqDQCgQ1cNxeEYLzIMY1zboTHnjOPnz?=
 =?us-ascii?Q?AaPgsIGVR0I3/jIuqfmcxZSYXC1pczd3LC/wx9kYewuuEbfZbCxHjDEdz19w?=
 =?us-ascii?Q?3aAl4Gdd8+/MIC56dYeD8YWtIfw5cbsZKlxc2qmO8bZRw4R3N2+KlsuQgfAe?=
 =?us-ascii?Q?dYzBD5FjRC24hCEQtqlDX8NnmSuI8EVCSlqvb8GReOq349KtxjvRwMPdDPMq?=
 =?us-ascii?Q?/W3Dbu/rvMhVOkdWSLrGz3NuT9MInQz+5Z0zn07ntwKvnrkRbf/NEbTH1P23?=
 =?us-ascii?Q?7vH4xxriUP6pzRPLnJQ5cuqUtDCnWaVQje9mmCNfKn4Vwvs7rVQ/kPEeoz1T?=
 =?us-ascii?Q?lKb38gudiys+CS00uelS5/jwQDz7/QjHfn7+KqCWlOl120U/isjOrjEHLMZI?=
 =?us-ascii?Q?9k7sa0g9wM5LadCiBNvz/YEKx6oB7+/YeP4W+bNCDjcGmTroQ+gDlAbPbbdX?=
 =?us-ascii?Q?G7yO6ZKy6QoY5gM5FF72N2EgrOK30mE47xcH8ZKIxhUfmfQE5BWQaZCBQJjn?=
 =?us-ascii?Q?r2St5df243fQ5gwQ8Nn43OlLjGmPT9kSMwpqFOvPQSQNxrH6SKolh/zA2D12?=
 =?us-ascii?Q?4rG5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:28:20.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fbc94b-8bd5-46b8-2c38-08d8a265b61a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4qtuilQgTAkztOG+BIT0d7sOyqFqDrswpPtL4Ca6J71EzXCUVqQrxiVLBydm0iYHUrnlWEa/yTJWCtsJaAwNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:28:10PM +0200, Andy Shevchenko wrote:
> On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Extract phy_id from compatible string. This will be used by
> > fwnode_mdiobus_register_phy() to create phy device using the
> > phy_id.
> 
> ...
> 
> > +       if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> > +               *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> > +               return 0;
> > +       }
> > +       return -EINVAL;
> 
> Perhaps traditional pattern, i.e.
>        if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) != 2)
>                return -EINVAL;
> 
>        *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
>        return 0;
> 
> And perhaps GENMASK() ?

Sure. Will rewrite accordingly.

Thanks
Calvin
