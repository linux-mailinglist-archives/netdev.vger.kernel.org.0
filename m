Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3A628255E
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgJCQbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 12:31:32 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:1122
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbgJCQbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 12:31:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ6qORbPf3HJYroUlH2E6LGFDGXlBVCpVzbbOnjFqqHS97h3ibuuwfEb7zVMV6yHSuhhfFFni0l/hTmzAnmN+tbYPx4hDXZJx+snuBabx2XnqjkTeXzjeIP4mM6A44+imSR5xmx2aRvuGHnn4HDz3b5FMuOqQ1vmzqFwoMdA15hpR4Q5Ibg8w+Vnp4tBIVFTTAT0tpVxtE/AnB6hpeDxKpEwB0+MHMkzwP6cCBgfbu2aH/i0GkJwxoZxz+XWyi+U8etupvxtt/nuX8hEgEhf15zH9ERV41iz0P30BUxSZMmfjlTKOxTjKgVUpEkTUsyepyQqQ/+TbAKGf1H5JZYBAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+4JQJtPkJpVlcyqQ15CAQkJCO2UyuqQJUKjIPkeefc=;
 b=f8bEasfiYO1mdPH3uDXO6dzxZgmht9MKABbufTfyaKzgdI2b+PNrtoWqjPPC+8HceBFwSyQthMS7+sCtDJzA4/sxs69fogJP6zGtTa7RUrtHMof+XamB0cs+3KRZKKOT2pMZLiNSBiXiGHBr8DnDP6S5gh2t//yihIZxEkrQh5mmHWOT7HYeqoPgxzLYHi4Ldrk4qAXs57C8MY1UUnREDIQ0B98PIl+SGyz3XmWg5jVhc4rWrCCSwfLKFDVDiEqKJwZ65M8FD24Z+xjhk6X+WAfKroLIb648HL+0iWDDU9kOJRBc6FJmPeFniuutYLAA8kz6vPXgObjN75ORGYKWMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+4JQJtPkJpVlcyqQ15CAQkJCO2UyuqQJUKjIPkeefc=;
 b=jau4MB96LHl689lVWb058qX1zVZTNni5Scif/v+TOAnjbwP+sxXpHphpwstzI6ppxAb7JbzlmFlKVDRyRT3OjYm5fx4bfTSlVwcXC25EV+p03Bn55cF4Y4NkGGBjguyx4Z4yay+mmTi+mwwi8FbpqtV8y2bJB2g0MbKCpUrQrlQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3764.eurprd04.prod.outlook.com (2603:10a6:208:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Sat, 3 Oct
 2020 16:31:27 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.038; Sat, 3 Oct 2020
 16:31:26 +0000
Date:   Sat, 3 Oct 2020 22:00:25 +0530
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 6/7] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20201003163025.GA28093@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
 <CAHp75Vfu_-=+CNYoRd141md902N2uR+K0xvHryfH9YCQi9Hp4w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vfu_-=+CNYoRd141md902N2uR+K0xvHryfH9YCQi9Hp4w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0125.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::29) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0125.apcprd01.prod.exchangelabs.com (2603:1096:4:40::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Sat, 3 Oct 2020 16:31:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b7fd94a2-c2b7-4733-a6cd-08d867b9c615
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3764:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3764CDFEF275F03D8FC74CACD20E0@AM0PR0402MB3764.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQ4YCKgk2uweXrjcfOQGQVRckPI1YHaGf0pgjFzp/Kb2X1mdb3myWLmpcwVVjMWfZqf+On09WmbOH3ym6v1fpHzxVbVxgMp99Ek9oDD9QJreXGUiIyhtpUpIh47ui7iXic6+wFboqtaAJmicXLB+ruQm29VQdBIMHGueKf6GXzk5AXTRBpU5BdTvkDnOcxFxXb86tVhn2QN0ITE/heUF7z6Ubut8YHsCPVvwJKF4mBCP6P76WaX5nJjsLbHyDNKKBqkHYyoh3RntTAwMqRq4522lP3BSZ22aipK2dOG9bu9c4liSaDv5it8uhOH81vYEa9pBhgSEFatC5d0hL1GtKu13bNh0aPI9KPjOCTRj7qyL8q+eWusbNC/ad1pLCgkGnlgcNMDq/wt4w+DGUTAq9UcLEMCzfmLYrJoAT8B8AgDga/rQKR1UpaYvqOKBLGCr/PSR1eXOaqTQjCquI8r5kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39850400004)(396003)(346002)(1006002)(86362001)(55236004)(2906002)(83080400001)(956004)(8676002)(966005)(478600001)(16526019)(66556008)(186003)(1076003)(52116002)(55016002)(7696005)(7416002)(4326008)(66946007)(6506007)(44832011)(66476007)(53546011)(316002)(6916009)(9686003)(26005)(5660300002)(8936002)(33656002)(83380400001)(54906003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: g4Pl7bqTwezxc6fWwQ0oMfqcUm4lXMy/9zISyKL+vquHFkQc0G+AeLh+4LoYSBg3vKC805Z/bOspmvFk8ycj7r+pcg2aWoBTukz3+XIo/x6sbCuNBSWKMz8ITWH4iqQsdjJXtfAFCK3Q3qLZ7KD31SQHf7c9VixlxxDrRvJS6Id8YV1HGbajF7PJKputvp4vuiFXKVQzlksXMVkEGWq3L2iDw0uO1xE8/AWa4UYJvc0f+TCsLtaOP6line3OprtbpHfSgL5qMmV/Bb+asaQRJP4mAb560wSoQReCkN5nn6cMw62P8Tta8Jfkyxj7NVhZiE7oB1z4OdvqKaaDXP2wQTmSaaN5E7RAXr5Bbb5XLqCdAEdTySRf9vxn2JCCnWQ4ZHtvx/xVyjrFPLKgNfbFKZWaRLe7FmHwk53/Gm0LUd7TGDi5JZYwr9/MMYA/JJeM07pFAz3NhjIR4xpug4tcDZM9kz4lgKvmNWknR8cWRD65dKMZemjtJjWbP/OJZFJUVZoP1rEkc2m8mME4iemCvV+5dceEuzFvcXsAjnMIh0O6vmSvWCLsbHGJJ2xgz7wa3z9yZYxbKWqJVW4GzOBhxRHgleN19H40njgQ3hyIMRqBP1u3iVkfWfBnsBdjpHtpAkJswYGdNvORnuVbhPvqpQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fd94a2-c2b7-4733-a6cd-08d867b9c615
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 16:31:26.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKVHzar0Ri7MyfDemFmLW28VRbH7wi+k9pXHcSfyBnRb6qKJaKN2UMTOFqZMYSxBnwLtiB0Xs5h7Hn9QBGwrFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Thu, Oct 01, 2020 at 06:36:06PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 30, 2020 at 7:06 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Modify dpaa2_mac_connect() to support ACPI along with DT.
> > Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> > DT or ACPI.
> >
> > Replace of_get_phy_mode with fwnode_get_phy_mode to get
> > phy-mode for a dpmac_node.
> >
> > Use helper function phylink_fwnode_phy_connect() to find phy_dev and
> > connect to mac->phylink.
> 
> ...
> 
> >  #include "dpaa2-eth.h"
> >  #include "dpaa2-mac.h"
> 
> > +#include <linux/acpi.h>
> 
> Please, put generic headers first.
> 
> > +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> > +       struct fwnode_handle *dpmacs, *dpmac = NULL;
> > +       unsigned long long adr;
> > +       acpi_status status;
> >         int err;
> > +       u32 id;
> >
> > -       dpmacs = of_find_node_by_name(NULL, "dpmacs");
> > -       if (!dpmacs)
> > -               return NULL;
> > +       if (is_of_node(dev->parent->fwnode)) {
> > +               dpmacs = device_get_named_child_node(dev->parent, "dpmacs");
> > +               if (!dpmacs)
> > +                       return NULL;
> > +
> > +               while ((dpmac = fwnode_get_next_child_node(dpmacs, dpmac))) {
> > +                       err = fwnode_property_read_u32(dpmac, "reg", &id);
> > +                       if (err)
> > +                               continue;
> > +                       if (id == dpmac_id)
> > +                               return dpmac;
> > +               }
> >
> > +       } else if (is_acpi_node(dev->parent->fwnode)) {
> > +               device_for_each_child_node(dev->parent, dpmac) {
> > +                       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(dpmac),
> > +                                                      "_ADR", NULL, &adr);
> > +                       if (ACPI_FAILURE(status)) {
> > +                               pr_debug("_ADR returned %d on %s\n",
> > +                                        status, (char *)buffer.pointer);
> > +                               continue;
> > +                       } else {
> > +                               id = (u32)adr;
> > +                               if (id == dpmac_id)
> > +                                       return dpmac;
> > +                       }
> > +               }
> 
> Can you rather implement generic one which will be
> 
> int fwnode_get_child_id(struct fwnode_handle *fwnode, u64 *id);
> 
> and put the logic of retrieving 'reg' or _ADR? Also, for the latter we
> have a special macro
> METHOD_NAME__ADR.
> 
> See [1] as well. Same idea I have shared already.
> 
> [1]: https://lore.kernel.org/linux-iio/20200824054347.3805-1-william.sung@advantech.com.tw/T/#m5f61921fa67a5b40522b7f7b17216e0d204647be
> 
> ...
> 
> > -       of_node_put(dpmac_node);
> > +       if (is_of_node(dpmac_node))
> > +               of_node_put(to_of_node(dpmac_node));
> 
> I'm not sure why you can't use fwnode_handle_put()?
> 
> > +       if (is_of_node(dpmac_node))
> > +               of_node_put(to_of_node(dpmac_node));
> 
> Ditto.

Sure. I'll take care of these comments.
Thanks
Calvin
