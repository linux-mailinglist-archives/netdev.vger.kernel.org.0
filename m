Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C4F288053
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 04:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbgJICVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 22:21:23 -0400
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:22146
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729724AbgJICVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 22:21:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RM0Vc31ckKy6QiRgt/jP7LvQaYiagkG0MPMkGb2i9JE0rcTwKizKAZkHdjMzIdA4/kLCO1UDcEI4CivtQngo8ve+39S8M58A3y+zFxhxREq7RNAPzoEwHEEKV95jhh2Hs8R5Td9BWLWoY4SRUxv+F4N0VNLKGZeuD19fFhdLgP3OKhiP8XkcksW2uw1XSlIxUkk8kkS8a04OdIzJHIt3F05LP5odR/syXvsI0+zdVUFhD9972jeJXXW520lL2Cb457whDOtC5bGTDFKHgmnbGUmYk/e1FFinbULZeiaRfzxf4Em4yDfhfZ9iAB9lNP677UlZA7tB9knAwZUzMpxbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRoeZA5Ndo4c3LYT1USRIH0ChsPCHGATgXPAxN2ZucI=;
 b=U9GwE/jIa6WfsxZdFfK7uEC9VECqU8BfSHQTHbpy96foabYhrVRdt9WeCiY166Vk4lX3nBmk+a2TmnJC+3CUTxdFXOcozqU+EmSCCKrrm/ZOeu/G6hQDmIpI1VdI1IYvX3vZ/KVgygm191+c6ZAmBwIeNzzXvWbFGiH3qBlXgInTCVSNXYRZna42nIM2SzxkejqA2DekEBZp+CGSP4HH1lo3CMaH6Yn4n3dgVgDFjPhZ+paFZyZ3JA22TMj2MiLK+yeESTa91OiBP2ayShmwyRLfia2Z0zjZL/KQGZayvOrxj3Ik4yYlQLZ/r6J/bcvM7y1usaSmMMFc165yDpcTzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRoeZA5Ndo4c3LYT1USRIH0ChsPCHGATgXPAxN2ZucI=;
 b=Fth7qVS/k7NctlGdq8XlxR02PSCUA8MKTtvKcs4etxVv+IGm7Wx2nGhGqpugO4DQCxp4p1fW0W6DxuLUCloYOWFtht5WswJV4PDwWk6pCZpiV97Qk9dzE6lIsozAJAvl+Xelpd7LsVnP1u61G0eOwy2Q5Anx5QHXibtF5+hY5I4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM4PR0401MB2355.eurprd04.prod.outlook.com (2603:10a6:200:51::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Fri, 9 Oct
 2020 02:21:17 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.044; Fri, 9 Oct 2020
 02:21:17 +0000
Date:   Fri, 9 Oct 2020 07:50:56 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Rob Herring <robh+dt@kernel.org>, davem@davemloft.net
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        linux.cj@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to
 drivers/net/mdio
Message-ID: <20201009022056.GA17999@lsv03152.swis.in-blr01.nxp.com>
References: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
 <CAL_JsqLf0UJNmx8OgpDye2zfFNZyJJ8gbr3nbmGyiMg81RoHOg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLf0UJNmx8OgpDye2zfFNZyJJ8gbr3nbmGyiMg81RoHOg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096::17) To
 AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Fri, 9 Oct 2020 02:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c429851-aa13-43d3-7bed-08d86bfa00b6
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2355:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB23553FD12B1B6E7ED00112E3D2080@AM4PR0401MB2355.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtyN0m/2mZuoAM7dYgnCzaJPhtrDG+Tsy9upmpdLwkvmyZRqRGUNupmZ7tBPFSG7Pf60fwXVxdbycOA2xlmKyRl6wWR3mLce9CzLkLh3UJ1ouFIvAittzoRn4S0aHS/orQlXbn/B+QwGyC26Kr8N6vP+W0BOi4trGvzkzwTwydB+YUpm4NMSQ9vju4TcfrG9Mj2yC+P1zPVV8uWzkWo7ciAdpzo6CctmE+6mO6a8WrARioYwXajbNBMi2vUFIskbgblSBHdkOAoAjaQ5egDV/YfXUUjiEaBBQO0F4iBZzN76fvPvMX1BKuo5gowVN8peRNc3FM2sPYm4WzRWLNaP04L8vHD0ssKHYsveCc3bXrOOwGbBPDaGVivSSfa8fSbS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(186003)(33656002)(6666004)(55016002)(8936002)(7416002)(8676002)(66476007)(66946007)(16526019)(1006002)(26005)(86362001)(9686003)(316002)(54906003)(956004)(4326008)(478600001)(5660300002)(2906002)(53546011)(83380400001)(1076003)(7696005)(55236004)(66556008)(44832011)(6506007)(52116002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 176B8fvERKF6PmtNheNGmocOIe0i0vkad0M0p73bRaQsqmPCW3Zm6wdM+E1/hwNFl8CniXtoet27/C4k5GoJGlyTOVLHwJVdso0ZefzD5LQHoRU11l3xlWkN7A1tEOmHq3oZAfAvyhCQnJFnBE2QoRr+On5/48uiegU88j+7hv3kyIvxhW0XljVHbHqeclalwG35nKYw+PhUaphR/9eSzEdsAG0nLrEo7Cc01K8zs/Ad25g2dkOksLV7uGu/Edtg7YoMT9M57eLqMkopum0k6zpX4art2Aufm02B6Zmf9Mmxy/ZZv6TWr1LrYsZYLSfwRHfM80o3lkx6aB9pKTCNRcMehTWOlnftJ73VL0eOFausXU754ubxx3ClMvIclHdr504n3wyyWzur5BteM1op2f47OXxVxaYjODs0i6cIptfDBAwm00C4e3QUaMlx7bWnAarMeRGFeSR7+s+kHygZ/4fQjgevuOZJIjBLH0xtKGeUP/k5KOJIpTTFvG0pycUDbYPPbwx8IxgBLACEBQwr+G+aTwQxbVf8ft6u0ARw/cKcXdBlJGMmmig9dl5aNHWHD97wNAqZAEZE2BBzLEOqr/wxrOjuXf0ml+vIV/nFrGNKefMnScXY99OXhSF0FTTjj7gyYvqSY2LTPpt9/WHxhg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c429851-aa13-43d3-7bed-08d86bfa00b6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 02:21:17.5717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brc7FWA7mRPXHuvrS8FZJYDG6Oq0x+6iUDqRKZ1ox9bVXnvl2r1NUoqdpntS0bRXkhPPZF358bXr4WdDYIed4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Thu, Oct 08, 2020 at 11:35:07AM -0500, Rob Herring wrote:
> On Thu, Oct 8, 2020 at 9:47 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Better place for of_mdio.c is drivers/net/mdio.
> > Move of_mdio.c from drivers/of to drivers/net/mdio
> 
> One thing off my todo list. I'd started this ages ago[1].
> 
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> >  MAINTAINERS                        | 2 +-
> >  drivers/net/mdio/Kconfig           | 8 ++++++++
> >  drivers/net/mdio/Makefile          | 2 ++
> >  drivers/{of => net/mdio}/of_mdio.c | 0
> >  drivers/of/Kconfig                 | 7 -------
> >  drivers/of/Makefile                | 1 -
> >  6 files changed, 11 insertions(+), 9 deletions(-)
> >  rename drivers/{of => net/mdio}/of_mdio.c (100%)
> 
> of_mdio.c is really a combination of mdio and phylib functions, so it
> should be split up IMO. With that, I think you can get rid of
> CONFIG_OF_MDIO. See my branch[1] for what I had in mind. But that can
> be done after this if the net maintainers prefer.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> Rob
> 
> [1] git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git dt/move-net

Makes sense to me to split of_mdio.c. I can work on it once my current task
completes.

Regards
Calvin
