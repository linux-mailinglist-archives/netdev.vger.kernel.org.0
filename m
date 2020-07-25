Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD51622D5D6
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 09:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGYHhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 03:37:11 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:8799
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgGYHhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 03:37:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oH/CgnYs46mvIklv3cYwvUAv5t0YBIxHoM+M7yMmDetc1+1y0SBxQ85hl0Oe6G8c4CquY1YloH07VOnAIriPrIJx6V1dCGYrRatfOSZJNnJ3OaW9UG28Be5o2jktIw2dwUZ0Xir8hWXQ3/Ku7mgr1iiaVglVlqkuDJQ5sCRai/2Y86UfBIws5sYGJ9HSTpQAUadBo6Hzxp3Fj0bk9m+PC2KfP1t3CK0sUL6Ky8ugvuhSnvAD+mc3qyQ6Mlb42ySMe9PistJCKO8Nbvqr0qdBSh4ryi/J7Vi8MhZJfRlgIc0AhPBrOrT+lwS6CIwBcNc1ZQugnMUIP1IdMFM70+SKYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fCVq9UpW8SG9Tj/42SRAPYcb6pDWvTtv4Q/q4JPzqg=;
 b=jjDHFia17PLkzKvkukJQ3hVftL33y33fV2u8fQJ5/7HYPSPt1ieN6+JkboH0UkR5MZhbylmf3/7l9lgYdejhm5Bn0qILKZzpVkYbrXs4pIzavZtmTHYVzwFnIRF8KX8AHoJXSHRbtgZbEsuaQaJ9lPUQNQf/nZxNjn9CixbI/FlB6IqxnIBkm/4vhaF8B++WklXlKH0cWdoXzt1g34wZqFIX/x28CPZB00DosInL3rLDvj/KF4irRoy4EoC5Fi1Z1yXf1/3aJbxAfUkBNZwi5QvtoiEl3s9iaivPdw+MG/X+eTBvHU0CPkvyNEBhB8p/k0+6sszY8+JRKoZgXh+5BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fCVq9UpW8SG9Tj/42SRAPYcb6pDWvTtv4Q/q4JPzqg=;
 b=edzyWd5kqcVpX2tuTcOjYSK0bsPkf702KktNk+ifKEDFO6Evg0pvzTeLyM2tKgiiONm0VKTtypQL0FgsV1H2M+Le4qGdXmuKt+SIfVek5GLrRMpYVL9BjR22Vecg5HG+xPDjuEG6mrpt8oJPgl1KQi/tFKxGmg7xnYiaXoxTwDc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6612.eurprd04.prod.outlook.com (2603:10a6:208:179::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Sat, 25 Jul
 2020 07:37:05 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 07:37:05 +0000
Date:   Sat, 25 Jul 2020 13:06:54 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Al Stone <ahs3@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Paul Yang <Paul.Yang@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200725073654.GA12097@lsv03152.swis.in-blr01.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <a95f8e07-176b-7f22-1217-466205fa22e7@gmail.com>
 <20200724192008.GI1594328@lunn.ch>
 <CAHp75VdsGsTNc-SYRbM6-HHXSoDdLTqBrvJwyugjUR6HTxwDyA@mail.gmail.com>
 <2fee02c2-4404-cd2e-8889-97e512a117f4@gmail.com>
 <CAHp75Vf4nDX-LQr=_FCmv5rj_v-6ZHr4H8pHmAU_N2Wgy=c5ug@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf4nDX-LQr=_FCmv5rj_v-6ZHr4H8pHmAU_N2Wgy=c5ug@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR0302CA0003.apcprd03.prod.outlook.com
 (2603:1096:3:2::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0003.apcprd03.prod.outlook.com (2603:1096:3:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 07:37:00 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4797df8e-d75f-4563-b417-08d8306d8700
X-MS-TrafficTypeDiagnostic: AM0PR04MB6612:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6612A3D0BBCF8A702F92C1E4D2740@AM0PR04MB6612.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmlRE+j+IyRsF+EWLnHqcZ2+v0tHSwGm55ywwf76O88/9AxlKYBlIFfivp1GRkQNnRPzp13YCToCNjURibqBRktsnlnA0dQO1+2DsWyFVg0+VV9FXzsnmaf5pf0z0J1GZSvV2E/ATN8ZjGUZ/0c9z7SokhwZ4PRukOIV8tfs7Qavi3/uerkAK8sIoKGu6pYvvBvqQaLtE1PZ6dMRkaMjX7/kHBaTENB+nQCM9BLCG8xbm3vT2HKUfneeqKHvIOyuxd8TzYdXT8Vi5tyId6vWhyh3ok9jBhnniJu+m4AjSG6jB1uo8TEQGQZjurdA8xZ283g7JyHY6rg1sSajM+MhjGoo30Iy434nq0jgcqRldeRCVRZRDVIOYahA8BVH5ptumBOiIck0EoG/njq38fFa0a2zZW504EYt8Ip8hKx1ACGrqapT+xvbFKhuA0sy40K/5EshSmmVC0MbHUoqTknFAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(5660300002)(7416002)(44832011)(956004)(33656002)(2906002)(9686003)(86362001)(66476007)(66556008)(66946007)(316002)(55016002)(6506007)(53546011)(4326008)(55236004)(16526019)(186003)(26005)(110136005)(966005)(54906003)(7696005)(478600001)(6666004)(1006002)(52116002)(8676002)(8936002)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ic7U5MTlDX97eedn/YQRD8rqXzqgTg4x3wEM0XM8eHXMbsLr0FkmfT3cFOeHw3BcIaqUEU172hLxOtWzPdNFlTmla/oCfkLUEecs39BR6wkw4nz8zIwhhFZHXpJcHzd0Tk0OzSZ1A9qEo5VQ4fCcfEncsA1tLGJlPp8uWpzF5nIymKEAyNp993TZIwnKF+x5oRzkzoACU5YlMHuL9Bp4wqbVOoH9WSMMotBaAAZQRV1gZdrlyJi3BHlS5vWkEn8XssV4G6AlXAnO650BDnFyufaENJCq2JzTWUWw4CnH0PwyXDLz3zgrRCstW8b0JdHzcrPJ6eaMywFM+F0X29d3boMyUM67TTnBNuX2+5fAFxIDsspn7rR7ZjKPs5elh6QsLdXQFXDtqH3HNfzE8GX7viT+GXrEz2SZdjSrJvbWyGn/cRB+4jjRWJj1znmBbrLODvIcQAPzLW0McLvo6QPaFWeVXn7fJjJ0GhPX6L7DfF0B9dmZ6BJa0wgjJs5bdtYC
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4797df8e-d75f-4563-b417-08d8306d8700
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 07:37:05.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3DjbHf2axuQXktc0ehq0n0WV9IKybtmmrSsyHvMOMXruC1mwwP3ovsismcwIFgTwznPCC4lL4RcYVsLZtblnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:20:04PM +0300, Andy Shevchenko wrote:
> On Fri, Jul 24, 2020 at 11:13 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > On 7/24/20 1:12 PM, Andy Shevchenko wrote:
> > > On Fri, Jul 24, 2020 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > >> I think we need to NACK all attempts to add ACPI support to phylib and
> > >> phylink until an authoritative ACPI Linux maintainer makes an
> > >> appearance and actively steers the work. And not just this patchset,
> > >> but all patchsets in the networking domain which have an ACPI
> > >> component.
> > >
> > > It's funny, since I see ACPI mailing list and none of the maintainers
> > > in the Cc here...
> > > I'm not sure they pay attention to some (noise-like?) activity which
> > > (from their perspective) happens on unrelated lists.
> >
> > If you what you describe here is their perception of what is going on
> > here, that is very encouraging, we are definitively going to make progress.
> 
> I can't speak for them. As a maintainer in other areas I expect that
> people Cc explicitly maintainer(s) if they want more attention.
> Otherwise I look at the mails to the mailing list just from time to
> time. But this is my expectation, don't take me wrong.

Sorry about this miss.
In some past patch-set, I had added Rafael but somehow missed him this time.

From the "MAINTAINERS" file, I got two maintainers. I don't know who else
can help with this discussion. I'll add others whom I know from ACPI list.
M:      "Rafael J. Wysocki" <rjw@rjwysocki.net>
M:      Len Brown <lenb@kernel.org>

If you know others who can help, please add.

Hi ACPI experts,
Would you please help review this patchset and guide us.

Please see the discussion on this patchset here:
https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t

Thanks
Calvin
