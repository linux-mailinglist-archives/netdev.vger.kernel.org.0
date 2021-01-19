Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3A62FAF59
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbhASEJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:09:52 -0500
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:25028
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730605AbhASEJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:09:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6IjAu5sjhNbmmbJ8kibt1Yl4N+qHk9F2Zgw+q3Zs2ijFbfUSHmi5DDsZPhx4itr5kOTJEm6x2c1BG+pvXYX6yVG4XmiXFj6Gd5V79yLG7fA1pPZK3ll73dBwPTc2MlEsVcGgBeX0zBP+VRICUqh2Igydd+AuYRmGTSYcxrT3e8IPGrTbTmDXC0awEYIaJGC6ZW4N47LwiRLYB9iv+1UnBKm1/SfovdY9KikUt306N7bPMyW+yYO3BYp5HhbJPsliXGIC/Wa4DW1HLidGd034FoTB6c8xzTsXRy/4Q/Kf5i9yTVB2Z2qSRvF385JRy0ZtbV8Ll9nkvg+Dn/CnuqoXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifIqMjfF/b1E/ZgqtwPwvaZetJ1gjiJX0vi+0mlUQwo=;
 b=LCaAvIuKvZmwGMVg/80stjW2HXJ65XxW/mDGw6ct/Y2yQ5VmKRSzF90+6I5+YbtwEJAFzEMT/yoXvRGwTgKe0nmy3knUkLyeCqIkzr//ZQ1TG0RLYaw7aXyQ+7k0HpgZBtYkRXEBFfRTpIsKUkuMpl+sw2rbr1+kw9j7seVyGTHCPZkYZWSJPKvGq5AvJB6wht7wWOWBurcLqmt0afrZ5hjGSJGbIOsnwS7CvSvHwMb5YaiDU1WT+nz+4xk3dgjCY4M7OWOHdyHA/Bc2OCCRkK25Fi8Ke0Kx28rlm6kKfGBCNSzeSa1usDeFtfhMIvvWvzO2usQyVrfV/F4G0zpEIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifIqMjfF/b1E/ZgqtwPwvaZetJ1gjiJX0vi+0mlUQwo=;
 b=EjDsRu6qSZ1lE7ds3mivIec0EEzW2AXVxI6y9IpVUePlqF3s9NrFSXynM5uGZkz2suQ+LL8mgJIBvlk9hMVgA6oz7p4wp2zlDpTr/yWN7oWIVO4fW2jj0VLrrIVGa7KkK5ukvQM2RgG+ZbHFg6ihzz3xFPUpLXHktoQ9b5vFGGs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7155.eurprd04.prod.outlook.com (2603:10a6:208:194::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 04:08:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::bda3:e1f0:3c08:b357]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::bda3:e1f0:3c08:b357%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 04:08:23 +0000
Date:   Tue, 19 Jan 2021 09:38:10 +0530
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v3 14/15] net: phylink: Refactor
 phylink_of_phy_connect()
Message-ID: <20210119040810.GB19428@lsv03152.swis.in-blr01.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-15-calvin.johnson@oss.nxp.com>
 <CAHp75VdAB=k10oLHbYEekbQAhOqnoVWHxN-gNW7zcayZxv0M7Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdAB=k10oLHbYEekbQAhOqnoVWHxN-gNW7zcayZxv0M7Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0150.apcprd06.prod.outlook.com
 (2603:1096:1:1f::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0150.apcprd06.prod.outlook.com (2603:1096:1:1f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 04:08:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69c67499-80d8-42ad-a793-08d8bc2fdcb5
X-MS-TrafficTypeDiagnostic: AM0PR04MB7155:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB715507377F57D25C5DD8C88AD2A30@AM0PR04MB7155.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NfJr/KNyF8N/g/tsf7cIqntBVvg918IkzUpMkB/Gp5Nnnaki9KQ960Pg7YkYvX0DV1uSC2Gza08yowSqE1b+9efdszgCkIhjawV7NqwYb5fsLpPzVbQw3s8qTulEYDEqrS6DjUVDgn4Xx2NXJ4OJ5/2Kw0YxlDm9K/UWcVjcM3LjZria+VcPlhUFv/5zvMeoKsRvi0CEhJ2fnlq/dZD//O0GFKQree4Jqwjjnj/yKhApURmenG6m97KjUVt1Aebt9Mftf+x6Q1jhNn7jBqfD7pWNQ3dDnW/xx4SmRkrNl9yV5VZqpHReI1ar8gqwMTI0JHQpoHqYU9Ek7AaoEJwFAzKPKYjgNXhwvCU7nCRMe153WnKwVsPBZQfVRUSM9+XXxWLCqi7RPmkAEUcLEqOFAc7/rxpEHpqisTDq2NSw53K9NPKnUpph7O590/ebbUgapYxvYMEzYvXty4w3rm/woCuagMIicwo7PVPMbzFpTUrw5i09F33CqyTa99EWGc8BAvpQqMiikPIQ93Yu0kmHIbtEZ48GssdRweG9ZDeFEtStxDNuFHTX05vwQyQGcFm07DQPXdpYOWzZNRUP5nxvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(66476007)(4326008)(66946007)(8936002)(1006002)(956004)(6666004)(55236004)(186003)(478600001)(33656002)(1076003)(66556008)(16526019)(86362001)(2906002)(7696005)(6506007)(53546011)(54906003)(8676002)(26005)(6916009)(52116002)(44832011)(5660300002)(4744005)(9686003)(7416002)(316002)(55016002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h9hyY8vVPYBmUJip+H231q/K0pv6kgpqR0pW+MD6jrulIp7q3P6vJYblM76y?=
 =?us-ascii?Q?a9MdSuC8Mxf3fCg0yB4lbsPS44H4SvqrwcoJB3DwsHnqM7ybENfZriNrlVSg?=
 =?us-ascii?Q?NQcTN5pOttwvDFx9sxQNQk28GFuRMGek3OX3WZIiX71HVI6pc5eCOGZAdI+K?=
 =?us-ascii?Q?vf6JnEa47nwLH5pI2RLw5xADsgPkSa5ewA3PrEyi3AiTUgDV7CgUR4CaWFjc?=
 =?us-ascii?Q?5EE8jcwjJV8ZnMkqwjumiDxQKnE3d3eYnuz55KiyLpMuav714KG/+x0y7EM7?=
 =?us-ascii?Q?Hr5ZKbJvtVWhLpEm2753Ba55fxHwatulMdo6P7vcTGJzD0c4sifuUHvB9xPX?=
 =?us-ascii?Q?uC82FM55ccbw3D7IUTpAfCExLweaZ4YX+nNk9cL3Zp/EmARBNr6+MGoOFIBB?=
 =?us-ascii?Q?CT/ZEHGHqpP9y7Ud3yumoNf/D6JciiHgLlMe0lwUac+RZJNcKiXK6l2H8NK0?=
 =?us-ascii?Q?PBhGqL+hpNX0mypeDliWjfeHi9lWVzBKofK35USad6ciAGmJZdlRoT1roDBj?=
 =?us-ascii?Q?yFkgwA0LVJx34losGjSUo24rPxw52Vc/uafUmxRrspXV79U312VDa7Z2PHtC?=
 =?us-ascii?Q?svrCkko0vGZw8D/z3YbrxyFudjUj7U0yOyUu5P7sKZhwKsoaejLZyv1lkev+?=
 =?us-ascii?Q?AD2J8OvhThhAQDPlMJfu415fUOEi+Y7SArCk5wQoJ4AkZVV+0eFX5H2xIaKw?=
 =?us-ascii?Q?0HW+fJX9EoE1Sm4HObGbWFI7CLsAvkubufxxXRUQ/a894POAY4WLk2v0PF0A?=
 =?us-ascii?Q?hJSZXXp9ZXW6cmYur+8GlQqdm8G0uKhBr4+drYBXderlQWdjxgZ0wWX4wuBc?=
 =?us-ascii?Q?4pcjIElKNpmvD7Jl2kY3QBLqGI2tb5CRiVCqAwaAmBpOBTQIPwK6jROOE5C7?=
 =?us-ascii?Q?5glD4NOCY3rNj/7nA2AYZwx4S9XNxOXr/aneOmxKvV3VHA34/0dDC2Izryk1?=
 =?us-ascii?Q?JFKvT2Wm4NVwmYSBvfWuCPuxjSsnhLUK4gfMlneU2TFczDrSQ+q8DIBHKKNO?=
 =?us-ascii?Q?eR1d?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c67499-80d8-42ad-a793-08d8bc2fdcb5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 04:08:23.0619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUIr11w1FfhjtLFBof2XHPxTYc3auDwLLFUT1Dk0C0QBjmLGW/uAxclfdIKm0fSnDbGLOoGvbyYu2k+7D8rSgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 05:57:01PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 12, 2021 at 3:43 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().
> 
> Same Q as per previous patch. If it's indeed a bug in the existing
> code, should be fixed in a separate patch

Sorry, I didn't get what you meant. This patch just refactors
phylink_of_phy_connect(). There is no bug fixing.

Regards
Calvin
