Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E9288336
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgJIHHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:07:02 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:61166
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbgJIHHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 03:07:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPvGC6IqvZut2zOBs5ub0a7fVngAN8d+VWi9c7RoUUVeZvFBaqC8f9AtWTFzlSMGzlTyQ+siqr0p6FssLSzVJuIQJlOR3aETmI9gSao/hRbfRumoORgqSA8LnYhZ2yqIhQ5g6DWtufNF0Pfihf2BWCxrBj2aS3VChc76wzsykG2KsMWJBbGVVpTriqgBLowl3jBoPE1/bswwkEw3sa4aWXKeKCiu+0Bx1kcTFmDKVXOx9L+F3kmrNHKO+9IuP5yXTehcKpokq0lVsP0UxWzCF2Hdf7wYcAxnnOJTBQkpmIhJM3tKsRxABj5hdwe5zRvkVMdqIEn8LOia80Gh2x9Nog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKbBKdnc2SdXFjz+I83fRQfF8M92fAL3yqi2QBP8kGg=;
 b=PDHm+G8ZERnsalPnT4hunw/FedSc2cpq9sXRMDJOsppcnHBKINnDh5H1z7EH/359EEgiGXx0550itwF3vWnsbGlZAUsN/75ouV17e5KVI9WL1j2vxICeK5BWxjjWAvRSiYmDWpLmwXry3pe2zhPHxJWjYJDV2aq3076pnd9+AAu1+rqoXTQxlGqpsf0BvBuni2UC2v+6lC5fQE3mRWAs9F7QC6k2bC0artLfcsGQo7ypWJw1+dO4Gzu+gPkhug7DXnqJq3DnkLL5ncf2lj0qARZuBrqZkQV7pOOvYVzGDGehOSHWTial/MWbcl8+9GmXXNLtOEEZc/vhBsH+V77uVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKbBKdnc2SdXFjz+I83fRQfF8M92fAL3yqi2QBP8kGg=;
 b=gLcvnntwSj++p0QlV1QnsAth8NJt51b9gV0sbjbhRKT3D1c5Ii0nxLN7s/z/we9CHGgrDtgT9/qGoIYsSMa8Pr9vsXoI+LlUqIfUkfQLS5hqapct7N/PzNqOWEKAczpg7WVlYy1AK9PgaQidhqJ5TFzBA57qe5qCxNBEemOPouk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5953.eurprd04.prod.outlook.com (2603:10a6:208:10f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 07:06:58 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.044; Fri, 9 Oct 2020
 07:06:58 +0000
Date:   Fri, 9 Oct 2020 12:36:36 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>, davem@davemloft.net,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ACPI FOR ARM64 (ACPI/arm64)" <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to
 drivers/net/mdio
Message-ID: <20201009070636.GA31495@lsv03152.swis.in-blr01.nxp.com>
References: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
 <CAL_JsqLf0UJNmx8OgpDye2zfFNZyJJ8gbr3nbmGyiMg81RoHOg@mail.gmail.com>
 <20201009022056.GA17999@lsv03152.swis.in-blr01.nxp.com>
 <2a0f9055-9110-ecc5-aab2-ff6ec9dc157a@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a0f9055-9110-ecc5-aab2-ff6ec9dc157a@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0233.apcprd06.prod.outlook.com (2603:1096:4:ac::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Fri, 9 Oct 2020 07:06:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e629b30-fd8b-48f0-86c7-08d86c21e8fa
X-MS-TrafficTypeDiagnostic: AM0PR04MB5953:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB595307A2A16101F475C02563D2080@AM0PR04MB5953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kahgQ/vHNas60RUDXWlowBJguxWbIEDIcFDMS7kpR7mgGqBmAWEJZ96u+ZA84SjFRG2rS08beJCukI09UsZbK0BpHceLMJDUSSLRYymQzgwWAw5mCClMUFU0X8kc/V6AND5rPEI/WjToptig4JJepCn76yAghFAM9mEB78UDh6tz/jtPcTbn0lVL2Yqs4ksmzdKpA8WHP87q5nMiHYBz1QpcnEsIAYNlTQZi5gk6gGjQnPVyOzbHuKcaCzUsbn1tpcIArV/r3qA6kX4s10k8axtjq1VVHqu7+Vsek8a13BZIdKJoYF0jO9+sHz98FtOx6LVD6ocYc7c9EqVAm40Az313CFSmEyk3Bk6dX3QadsMg8Q99OFbWpZjaa4vkrc5j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(6506007)(7696005)(26005)(7416002)(55236004)(83380400001)(52116002)(53546011)(316002)(4326008)(54906003)(44832011)(5660300002)(1076003)(478600001)(66476007)(66946007)(2906002)(6666004)(66556008)(1006002)(86362001)(6916009)(9686003)(33656002)(8936002)(186003)(956004)(55016002)(16526019)(8676002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: H//lD80z49Z03zPiI4/tmsDbGahgseOPHjSjBXT2/1GwDtalo+/qWANiJLudqfOYfndKc6riTy+kfdAGfwIbGFuOU4AvCmZTlf6LQ7mNvPWDphHe80NMBAqqgC50irpuG8LjMoEnGDo/mpzhVCAiwCJDBMdhLtMYBuGPc0or6Tkf1VRDQnDnbuATxCfgwyPH3xoWQXi6+lv4ssxx/A5r+++gxz2bJDxMa6P9hk9nv5r78g1mXNGfxiZnTYgdDNnKnt+C5oPMCzc1F3MJM9pGAixp5eJ9iYdYhVhPNAG3wJd1JaOOI5TNbbH6fYfo3IbKz9Z0gnniwLd9x+K9aZHK7jSUWyBXfAmqbH6Sl8xWWb3fraeGdqpp8yg3Qr7RxV9F4lr/3HrtxkbiZ2Xe7awYOlt1K0YRQoZAonxS1nq9n+W0qMFhRMdiWsKShHqYsCRoww2K7Eihc2HniZYtWtQborRLRsxuTaloMLAEaFJMH69nJxM2w/0bOeTNzO0BpPGM/11f/isDKSaDjru/QlxrIiRBw10U1yqd07VsER/2ONrgVVpW3fXYCALb2K4Lw12LG3jETM3rLlyW3QoHikdupXMLzf7YjfEQfpOlZcbaYuFNYePtq79SAVgLcpmUtljkgGo8etsg7/gnYv5JLPqHyg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e629b30-fd8b-48f0-86c7-08d86c21e8fa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 07:06:57.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPI/yU7ea4qilJww+nCqTBUgK4qQtvNju1DGYUdQbFL57gBhERdBnFhcs06lqmrdbze/Myybkovecx5s8y4FuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Thu, Oct 08, 2020 at 07:26:44PM -0700, Florian Fainelli wrote:
> 
> 
> On 10/8/2020 7:20 PM, Calvin Johnson wrote:
> > Hi Rob,
> > 
> > On Thu, Oct 08, 2020 at 11:35:07AM -0500, Rob Herring wrote:
> > > On Thu, Oct 8, 2020 at 9:47 AM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
> > > > 
> > > > Better place for of_mdio.c is drivers/net/mdio.
> > > > Move of_mdio.c from drivers/of to drivers/net/mdio
> > > 
> > > One thing off my todo list. I'd started this ages ago[1].
> > > 
> > > > 
> > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > > ---
> > > > 
> > > >   MAINTAINERS                        | 2 +-
> > > >   drivers/net/mdio/Kconfig           | 8 ++++++++
> > > >   drivers/net/mdio/Makefile          | 2 ++
> > > >   drivers/{of => net/mdio}/of_mdio.c | 0
> > > >   drivers/of/Kconfig                 | 7 -------
> > > >   drivers/of/Makefile                | 1 -
> > > >   6 files changed, 11 insertions(+), 9 deletions(-)
> > > >   rename drivers/{of => net/mdio}/of_mdio.c (100%)
> > > 
> > > of_mdio.c is really a combination of mdio and phylib functions, so it
> > > should be split up IMO. With that, I think you can get rid of
> > > CONFIG_OF_MDIO. See my branch[1] for what I had in mind. But that can
> > > be done after this if the net maintainers prefer.
> > > 
> > > Acked-by: Rob Herring <robh@kernel.org>
> > > 
> > > Rob
> > > 
> > > [1] git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git dt/move-net
> > 
> > Makes sense to me to split of_mdio.c. I can work on it once my current task
> > completes.
> 
> If you could take Rob's patches, given then a round of randconfig build
> tests and update the MAINTAINERS file (no more drivers/of/of_mdio.c), then
> this looks like the right approach to me. Thanks!

I gave a quick try with those patches and it needs some more work to apply
as they are bit old. I can look into this later afer the ACPI work is done.

For now, this patch is good to merge as I've done some sanity.

Thanks
Calvin
