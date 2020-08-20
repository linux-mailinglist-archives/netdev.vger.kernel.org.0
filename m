Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB60F24B10A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgHTIbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:31:55 -0400
Received: from mail-eopbgr20110.outbound.protection.outlook.com ([40.107.2.110]:43392
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbgHTIbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 04:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCT+h5i8yZE2raXW097/YdAExwAXtfK2pWzB2zGPzLkF9+/hNHVjHZMCbKebxNehsouInLaS0UVPH2XY0a05MXA0rg4ZRVZe2K2UcQg+Bp9AzNJR2yP1R6Wna1ZM75VbinTtw6SUM+KP1hRVCQ1Hj8foRYQw6SgwSaRk6QWQ1NRiUGwQ5BhXqy1UsOVUdxANFR7NNGW4Fds87eNky8K8fzce0tDnUkt4Dul3ST8lm6KFoKxSElJD6L/u/63srpF9i+/5/jl35FtmZisapjoozWFaPr7yhF5rJMZr9Uz7Nh3MHaDHqI8WuLb1EYE7qRU/4e1SyubtI39BMeV7ceTRZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn/I7C5qoScgi96FdA07+Lx4EWiqsj8J6o983SiNOPs=;
 b=D7tXM2p8/mHw4ggBV61Rs3N2VTNaRhtTX01KouAp5e+JNlW4VcvaqDYEd6nRX8x8v84348XCawKcdTK3VOAyT0/w3qj0pvFkaZ5cO4S/mNY2WiDIHaXW+zi2sUYvE+QnowChy3T/WSukXnu7fgZSIjBBMvXhRvGXxQR5X6jyUxjlfYZNpqnNBYaBMucHBvMylTFnnO7YioyCRz7Y8hskOR8RcIAM/zPH6e7cNx7aSYsXXqlFFl3+4RtD5LyGeU/SPQVZ1CgVbVN/RLBNXBMgtN/EcE0fvsAZ0TH93Lcu4NlcnM4rQ5JhyTYETGfJOQQzlb3AUEU6NSGu2+4OhHFC8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn/I7C5qoScgi96FdA07+Lx4EWiqsj8J6o983SiNOPs=;
 b=uvnfZDkzkQsyrt2EMgM774hXDsqZxjlXrJRUb/2v8rRJibGpxBP8a3ZEncy5WWIo+NpSxkEl4RI2t3Drg+wLu3cb3pU6eVXZPurszvhqEb7Cerqq3GUzIsI4SRRmhkqQbnFOFfyJCJmNNALTbhnvqp5BeJu4AvN+3GwQ0grGnCc=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0364.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.20; Thu, 20 Aug 2020 08:31:39 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 08:31:39 +0000
Date:   Thu, 20 Aug 2020 11:31:31 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200820083131.GA28129@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
 <20200814082054.GD17795@plvision.eu>
 <20200814120536.GA26106@earth.li>
 <20200814122744.GF17795@plvision.eu>
 <20200814131815.GA2238071@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814131815.GA2238071@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM7PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM7PR03CA0009.eurprd03.prod.outlook.com (2603:10a6:20b:130::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 08:31:37 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dc57a81-e3f2-4e2f-5552-08d844e3756f
X-MS-TrafficTypeDiagnostic: HE1P190MB0364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0364694A0F42011AD3325EF4955A0@HE1P190MB0364.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qKIzBFCqP/n6ealpH56KR9idjl1dfdIRoxHc5Ubyf4QhiPZwaMDJbVY64w3xS7jqjRwj1dh/fYt7iZwNsntSesJ8vRZ4+mYIFes0ilsBjmnVjE4XbavPF4ewyC6DAgxSavk5vVM4/DsoLhSX7swB1rsipT9PEflx9+4GP72qpgmrF5YCWXwDtt0kxRwOpdQQ+/hIhPZm1ft9xeBAZhFNNivgFF+NN4HiN9Ek3CLbE2CqsAM3+cI1jqmRKPoDaWIQwOWYuhAhvNLSrrcoVJHGqM37ZhUYEnYsIOkHkJvdKAB0s5lLwetU9tSTE3Cp1+MGkgR5DtGWaYJgsUNPnx4Erg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39830400003)(136003)(366004)(26005)(83380400001)(8886007)(16526019)(1076003)(8676002)(6916009)(956004)(7416002)(478600001)(33656002)(8936002)(2616005)(44832011)(316002)(55016002)(4326008)(186003)(7696005)(6666004)(36756003)(5660300002)(66556008)(86362001)(66476007)(54906003)(2906002)(52116002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Uweddmng0JziHMT/m+KNpcig6VL0t1RhqiFpr+fI2I8FRm4PRs6bUBRSIC2UFSvXLJDkGBjGhCdqte4gMow7HBC90oqQnzLI13HkiCG5M75XsDOsxJLIVu5UW9+8rasPeKTNPn/7Fwoyyvh4R1A4STw9doE4v60pWuWMSNfaI2ikAsH+iX6lqj2Ysr1K0HOGvmbV0tz2aVbtdBH0SU5USV5hdr64oXU8/aP2vQjb3EJZPTeozrJeM+uuSJozebyxrqNOln2Ot+W5Vb2UMvIg2ca6oz2N/VQl5XOGuHVnueSPjBrbc8NzPXXVybF+gtDamDmE4lvh2m1mcjXD24R3+1RG4RAQCgGhwLDf+9tj5FhcUq9iUSZ9QLSxGI13Lwd/DaRHtRUuuPFwTaseQKp99NwR8ytC6rbyavMuk8yOcVixY8uzn2+YYPo2Zf1K4GYhyxhohEpM8gV6hNywAHeI6EmxiiPLJ2pAqzweogkD9Xmjda6UvJ4/0m2/rwkmrbn2885tt+OhoIo8CHBPTzdFIYqxgtvbhbBqqQ1xzA3JO+9PIHdqWb0pa2ssJq9d6DEtdBwadjsgzOHR1DlaYexUhBKNZvrdQqPxxcUZCu+udu677xWf8BDG4d/H53HjQ1XZGAyOCmwnInABnQYQ7ShSlQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc57a81-e3f2-4e2f-5552-08d844e3756f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 08:31:39.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUHMzWyr8IkphSjq6Tlk6uufW2orOOz/7KZ0Z7hA81Bf+7RDsa2YriyiXUqtBfCnSta44FFyIVIP5BVozu/wJQI7s4T7Ib9d4cvJvE8diws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0364
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Aug 14, 2020 at 03:18:15PM +0200, Andrew Lunn wrote:
> > > > Currently 
> > > > 
> > > >     compatible = "marvell,prestera"
> > > > 
> > > > is used as default, so may be
> > > > 
> > > > you mean to support few matching including particular silicon too, like ?
> > > > 
> > > > 
> > > >     compatible = "marvell,prestera"
> > > >     compatible = "marvell,prestera-ac3x"
> > > > 
> > > > Would you please give an example ?
> > > 
> > > AFAICT "Prestera" is the general name for the Marvell
> > > enterprise/data-centre silicon, comparable to the "LinkStreet"
> > > designation for their lower end switching. The mv88e* drivers do not
> > > mention LinkStreet in their compatible strings at all, choosing instead
> > > to refer to chip IDs (I see mv88e6085, mv88e6190 + mv88e6250).
> > > 
> > > I do not have enough familiarity with the Prestera range to be able to
> > > tell what commonality there is between the different versions (it
> > > appears you need an NDA to get hold of the programming references), but
> > > even just looking at your driver and the vendor code for the BobCat it
> > > seems that AlleyCat3 uses an extended DSA header format, and requires a
> > > firmware with message based access, in comparison to the BobCat which
> > > uses register poking.
> > > 
> > > Based on that I'd recommend not using the bare "marvell,prestera"
> > > compatible string, but instead something more specific.
> > > "marvell,prestera-ac3x" seems like a suitable choice, assuming that's
> > > how these chips are named/generally referred to.
> > > 
> > > Also I'd expand your Kconfig information to actually include "Marvell
> > > Prestera 98DX326x" as that's the only supported chip range at present.
> > > 
> > 
> > Yes, Prestera covers more range of devices. But it is planning to cover
> > other devices too, and currently there is no device-specific DTS
> > properties which are used in this version, but only the generic one -
> > since only the MAC address node.
> > 
> > I mean that if there will be other Prestera devices supported then it
> > will require to extend the DTS matching string in the driver just to
> > support the same generic DTS properties for new device.
> > 
> > Anyway I will rise and discuss this question.
> 
> Hi Vadym
> 
> Lets start with how mv88e6xxx does this. The switches have ID
> registers. Once you have read the ID registers, you know what device
> you have, and you can select device specific code as needed. However,
> these ID registers are in three different locations, depending on the
> chip family. So the compatible string is all about where to read the
> ID from, not about what specific chip is. So most device tree bindings
> say "marvell,mv88e6085", but the 6390 family use "marvell,mv88e6190"
> for example.
> 
> This naming scheme is actually odd compared to others. And that
> oddness causes confusion. But it avoids a few problems. If you have
> per chip compatible strings, what do you do when it conflicts with the
> ID registers. If from day 1 you validate the compatible string against
> the ID register and fail the probe if it is incorrect, you are
> O.K. But if you decide to add this validation later, you are going to
> find a number of device tree blobs which have the wrong compatible
> string. Do you fail the probe on boards which have worked?
> 
> So what to do with this driver?
> 
> Does the prestera have ID registers? Are you using them in the driver?
> 

ASIC device specific handling is serviced by the firmware, current
driver's logic does not have PP specific code and relies on the FW ABI
which is PP-generic, and it looks like this how it should work for
boards with other ASICs, of course these boards should follow the
Marvell's Switchdev board design.

> Marvell is not particularly good at backwards compatibility. Does your
> compatible string give you enough wiggle room you can easily introduce
> another compatible string in order to find the ID registers when they
> move?
> 
> 	Andrew

