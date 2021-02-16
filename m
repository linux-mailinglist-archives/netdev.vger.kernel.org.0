Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796AD31C879
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBPKBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:01:22 -0500
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:40830
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229635AbhBPKBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 05:01:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKtuM0jJ4rXtZn4t/W/s+eStU2n/w7gFfsHZdpPZwhT2/8c4u89duX3s9WdWIHn+G4vtTA3UwpaPoC0r+16uP66ZALMRGRiMU5Xc8zlguaWn5KMMpYJOZeQbeSKnwqkE/MBBWresba9lbTkPgv2PvMxI8YdokGbsdKEYoDfewIpqlnXHAcnpBc+/JzR1B8d0lwFERSjshEzMdBcJCGhb7GbecAWi3Lit9mViStS4xlKQvZMNIpdjJGaxuWpvHqXnT4SXqS+Dt0OuPiw21mTG5jB/t27RKp+Qj8Bgx3TyqmcIlv89NGVpz+zdV6c2PXWJev+RHUlJVicD/DdgvCUXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYRx0sY7ceFw88FOzi3Zek4uPZymid44to/SEXt0+SY=;
 b=NLBieBle3LGhpDSKXus1B5U+GeWrXre8TAoYnWeu4Ablk4dkY6kOKI2nQeU5WkyVPiGCEsU7W540rC8m6hjHRmfgvJTYlgvTLd8fzxg2dx4cxkzMbqDziGJBA+OjWMIGeR7u+foWIVF5Hm0G1Eq+LOyXR3TOqlOG24BKW1ho71En7qhzduSCr5F58GRHFes4ELXCHokjiWgsDORuUtz4V7IAwLgYAD4p2QUXFZFc0CzUi3VM4snr2kXgwWyR7F4rFarP/9Gw3Zuhgpv1gAYA82CTa63xkOO17o6u6UQCbO/tnPuv1wwTdDM/xG9H/a7AMNpgF1C6/zXMUTn954pJRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYRx0sY7ceFw88FOzi3Zek4uPZymid44to/SEXt0+SY=;
 b=QG0OLZr9GISUza5LhRSqp8iFUV/WyVkkAjCFquAliePnjCILEJj7i/IsMYt+sM5l63dec3p5kyVPP9+IcVsw4wYw87OoqO0v7WMGCqDNci5RnYEiLunmBhOkZ20jZUwPLWip4W10dvwq3SbvCLDWqn1oJwYerxBkMUhf19Krg5g=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7891.eurprd04.prod.outlook.com (2603:10a6:20b:237::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.30; Tue, 16 Feb
 2021 10:00:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Tue, 16 Feb 2021
 10:00:22 +0000
Date:   Tue, 16 Feb 2021 15:29:59 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v5 15/15] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20210216095959.GA1015@lsv03152.swis.in-blr01.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
 <20210208162831.GM1463@shell.armlinux.org.uk>
 <20210215123309.GA5067@lsv03152.swis.in-blr01.nxp.com>
 <CAHp75VcpR1uf-6me9-MiXzESP9gtE0=Oz5TaFj0E93C3w4=Fgg@mail.gmail.com>
 <CAHp75Vfcpk_4OQDpk_rvySJbXAyzAubt-n=ckFzggdo9fKvJ4A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vfcpk_4OQDpk_rvySJbXAyzAubt-n=ckFzggdo9fKvJ4A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0091.apcprd02.prod.outlook.com (2603:1096:4:90::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Tue, 16 Feb 2021 10:00:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c4c8846-17f4-4598-cbb6-08d8d261ac0f
X-MS-TrafficTypeDiagnostic: AM8PR04MB7891:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7891C043BE170A5BA9C07E21D2879@AM8PR04MB7891.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5rJwajVEkmIUh1RETGD6iQhHLJpuTAyPAJYcGmJDYjuKs2uSfST4+qHX0yiLpBR+wgzMjpTF6ECRuQM/fKUJjA7YsU+myJFuxrIY9V4ilXpqAphcEWIPMTvexjeeqjV38aeEElU6oyBQDb1bIGdKh1uPDEjlr52VdH2Hq6MLPfS2h+5Qb5dSHurePlESTFRidmpwJ1GGJq95hc7bdkNoTAahBKvAiYq1MZmnmpBU7fmvIUvdTSX4UrJdRumh5m47BTKxHerfGjrMdoG/mr7wdgCab9+8sEXM+YrN9G66mtS9N7CO61m2FGRcJnaVrU170ZGtmW5qch8txgrOzZB4MXs61vUP+z622trPfCpRo8kBVQI/v+3ZEHEhVu9MfNN9Ht9rfEyPLTgcecdLA2kC0mGbN490eoSYMMq1wS5CWg3ttrDXgwjNEBhQAj5HqgQsk4D+WRte/UR1wS3WaRner0ZElZNLRqWC8jS+5YAcsMU9SZAyOW4QwJGAvwHXcCJeatpDx5ZZ5OcMOS0POuVjmBH4lUd7NJCdPViE9ejHs0fw2WfBdsJrjNqal7km6Uz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(1006002)(7696005)(44832011)(6666004)(33656002)(52116002)(8936002)(2906002)(316002)(54906003)(478600001)(7416002)(956004)(55236004)(8676002)(16526019)(66946007)(6916009)(26005)(66476007)(186003)(86362001)(5660300002)(4326008)(1076003)(53546011)(6506007)(83380400001)(66556008)(55016002)(9686003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oaXCp9gdeboVoCji+nbBy4wP4O13ta0ddYnvFT9hfLKaL+U95C7OD3CdDreR?=
 =?us-ascii?Q?25jvyK5QZPjKKHvSVN3u01pqJrLzzAzR3lTBzQf8+CPb7TuFwni2hdpRN2s1?=
 =?us-ascii?Q?51n4Mz0LeWHrvYI8MCU80yMOiPjjrfMKf7+LpuTR29WvRQZ7qEPzjJjWKmK9?=
 =?us-ascii?Q?Qf7De+I/85MVJQ4fazhUVjsbrhZLgUGgXm4LNjD0ZLjTcnpRvZiptHQMBkKl?=
 =?us-ascii?Q?oIndtlbH+bb5P6/EJMwUPWfTKwBvWNNd00h9W/Hr1RJtraf1wfidrOlc13fH?=
 =?us-ascii?Q?pEPX0cnzDzRLKKvFdpbVa8xqI47P6Tlnei0gL7WsHLPyf5B6Uh91dVv9upfW?=
 =?us-ascii?Q?lfN2Yt3rQyxq7j9sYmkH4+zJRZK22dSXOIM2anu6KISdqw6ra43BM5k1IjND?=
 =?us-ascii?Q?SzyWDYfYg2sAUu+tMxaMtOPWuPuZ66D2Lt25OB7SnLSHsuXTNP+ukI/vGWst?=
 =?us-ascii?Q?AFabV4nNHedh17BQvqEcb60vsR5R4/eD8P67W5v/i415JdZoz/Uw0QXXa8bR?=
 =?us-ascii?Q?RUsA+9PNFOC+OebVyd/wVkZCmP31MRB6XZrY22UDt/sw0H1qRzhitNGJ7xPn?=
 =?us-ascii?Q?EP323ue2MGiqaRh12ddLiC/JN5yFBqfpMVBN7NjfQaqB9x5kHEWDHTvg6fzN?=
 =?us-ascii?Q?5gLUmD9LclgzAwUeLqzRvekg9l+j+It1NuBnZE/Xs4mrAMqpCNrGkpS7sWrY?=
 =?us-ascii?Q?Dx+MF8zsbXIQE7j+aDv29HMs6seVJi2+ylHNE4qjYV9cMQuXjMKdpUA9hAdJ?=
 =?us-ascii?Q?2s8eKZ5vXUf7BT4X2qkBiO4f6Iqia0fwjUM1OhLvwiIDL4TE6XHkjzlH7j3o?=
 =?us-ascii?Q?DoD7HiTMDDveSy1+oxo84rVwGHyegVc56bhI6xMisfxT8IpYr/h02W2QMNN7?=
 =?us-ascii?Q?rGjBFG+LJZRalmPhL+bxetna1hZvNPy8W2/ZFjzA4awO3lS01LT+yZ8o5vrb?=
 =?us-ascii?Q?pBy1F9ehSdEFLkLVGZwucljc7mr7gWRemTY9mpMiSHXjPhqnvzG8+J2dvfY/?=
 =?us-ascii?Q?bEzjSAyWF/6RS4mv7Ve6hdUd5Z08mlfCZCVMI/H4FuTLvFCH1hR/uy5t6ZbW?=
 =?us-ascii?Q?YAIzu5ViQhGikVwwF1zDAZnGnlt1ILxa9HdklILgtsQ8J2cl0p7TPHcc1Gwt?=
 =?us-ascii?Q?F6VVf2cmA45GLmvwRW1lMEvpYyqxFYAPYzd1Vq7DyH/Mj95k7wsPKFDJYvm+?=
 =?us-ascii?Q?fehAfAzUULUzgDnzcvlyqAx9Lg6FZKPTdRMjcwTlT73whZ9SjMBGWremd2z2?=
 =?us-ascii?Q?wy9+foRLeUcW2dvPGdHd1HQ3IB2cX9tNyAm4pU8jFkm0dr2n9nQw4T9psnzC?=
 =?us-ascii?Q?P8uXgLQxCknTLYyXEVAbST6Zqgzud3yytHu8VQ9WQ2bAkw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4c8846-17f4-4598-cbb6-08d8d261ac0f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 10:00:22.4046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QxRVSp370fsZmMurgyzjO+EvaR8YAMmLV6X0Xg/TKPkrdj0P5mMghwkBRURkIzTwtcWivbTxQM+vY7eSStaIzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 05:15:36PM +0200, Andy Shevchenko wrote:
> On Mon, Feb 15, 2021 at 5:13 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > On Mon, Feb 15, 2021 at 2:33 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > > On Mon, Feb 08, 2021 at 04:28:31PM +0000, Russell King - ARM Linux admin wrote:
> >
> > ...
> >
> > > I think of_phy_is_fixed_link() needs to be fixed. I'll add below fix.
> > >
> > > --- a/drivers/net/mdio/of_mdio.c
> > > +++ b/drivers/net/mdio/of_mdio.c
> > > @@ -439,6 +439,9 @@ bool of_phy_is_fixed_link(struct device_node *np)
> > >         int len, err;
> > >         const char *managed;
> > >
> > > +       if (!np)
> > > +               return false;
> >
> > AFAICS this doesn't add anything: all of the of_* APIs should handle
> > OF nodes being NULL below.
> >
> > >         /* New binding */
> > >         dn = of_get_child_by_name(np, "fixed-link");
> > >         if (dn) {
> 
> Yes, of_get_next_child() and of_get_property() are NULL aware.
> 
> So, the check is redundant.
Yes, all the function calls in of_phy_is_fixed_link() handles NULL properly.
I don't see any way this function can oops.

Regards
Calvin
 
