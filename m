Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B548F449
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiAOCIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:08:04 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:44512
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231258AbiAOCID (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 21:08:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKBC8pJA6HUtaaAmF5Y9IAB83X9Iy3WHIKXmyp46+udBRLjg1SKky2lzgE/jrwLRQxaNQnJAdfsTTsV69sz4RGFfrpQ/RlZubKXq+yTHIW+q2YjLpIlU5hEATUZ2P7smdtaiAmpkxTnxhNiipFi21lG1BsNDj17D5RwdvsfwaDf9bM4DKnYPiYBMH+KfFUMZ4Lp5Uz1ZRXAidOvEx+y7eHdwn1pePZfl5wG8wS6rDkCeXUdVuK0e8YUPUVJGNaGMqIRKH7U0YE1QZjUVvdfZ9dEe68jzQorgNmkFU4FG4DjVYb2cwCyxJn0dKr2ygb8Mwy+a50lypfXkApcTm3HBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ceb/y/n6X+IMdV333snPRK4x6Ofax5dBmjhtApnR8A=;
 b=j4XyDfZwMVYRAuvHW3q/ULMPFEA2LQNjjDLVGBsDN19FF4DDaLJFUpOjysKmEIpcQw4aTqfTfXhsfZFcd4p0Asm8+ClLQ/CeSQdjwARfPC2KkcCX5VKP0lf3ZmPnFtoHJ9dEymHOZA6zWg23/YzA290vFQTsztcfOcxPMXKdXHoW9qiaqm8kBEW78rf9I2MQ3VUL+JrSbrKmUddTmhW/s9j09YW6B58cGThR7t76BKUFG0VisBfz0YqOZwK+1QHaawTujAeO17pKjzbIKfVvS+URJZIlkKxen8Qvm0GKIA+/74rfFuwSHZsxMFp8V3CmIgi9rz7HY2fxQaAAtlQ+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ceb/y/n6X+IMdV333snPRK4x6Ofax5dBmjhtApnR8A=;
 b=d+pNE84BmE1gZ3VxZoIfoiG1Y/l0TtG+TeXLuvLYTB4ejop0q/4aSYTWm2Xoz24123X/CiUSrU2+SpE87WetrMgvsOYjmqx/MZ+eMgupic6KZseXCz2IUo64HuZ0OuO5s5KujJxjjPfBDwB0r4YW0wgIARAEdy+QTL49L/BBkZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5396.namprd10.prod.outlook.com
 (2603:10b6:303:13c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Sat, 15 Jan
 2022 02:08:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.012; Sat, 15 Jan 2022
 02:08:00 +0000
Date:   Fri, 14 Jan 2022 18:07:54 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <20220115020754.GA1510938@euler>
References: <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
 <Ydwju35sN9QJqJ/P@google.com>
 <20220111003306.GA27854@COLIN-DESKTOP1.localdomain>
 <Yd1YV+eUIaCnttYd@google.com>
 <Yd2JvH/D2xmH8Ry7@sirena.org.uk>
 <20220111165330.GA28004@COLIN-DESKTOP1.localdomain>
 <Yd23m1WH80qB5wsU@google.com>
 <20220111182815.GC28004@COLIN-DESKTOP1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111182815.GC28004@COLIN-DESKTOP1.localdomain>
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e459200b-4abe-4d54-7b16-08d9d7cbdab7
X-MS-TrafficTypeDiagnostic: CO6PR10MB5396:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5396F22D4006D5662CC487D0A4559@CO6PR10MB5396.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpVMJaIv76nQt0uliMZ7z1somKjHBvFnxQ98hljwZIbyu9S0svLH3vjgKw42FxlhiKk3sP93208r/cO7tYXEVyH/gXXulanjiKyC+Iww1ztGuSnToZmlYR9mIjvGg8m0KApz/HTVdqBHKzEMRLVCAaHPW2J9dJvpX4lSb8Q+u9fi5foSS+TxgWjgVf1Dg02Df9npZ/0xETgXVRWh3faHcsSxpf2AAy8fF1YPUR3oiroESOWSJIxw1TUjKGYIDRZ2wLskloVNHti4IjOcc7VgRss8Q/Wdvpym6mS6eQ2dvL12mZMRWRkWbD1WaWvaziFki/pETvGvwYOQPrg5SaYGZSzkK8BVBXPZkQTmaNo1dic041sYaD6f5vfqEjmcLJzVHwz9ck+3ghRy+6XBTytnZ7IigdwvGZiB/KikYmMkTGxpsC9x035GxpBHFz01qPkpDKmJPtTR/Z9cnT+XkwrljuauUYjiAIUDTRMJTD9xWXWclUMBvihXgTCodqjiblQOLYykmMKSsxX8iKfh4fJLNzhuaCVmE8Fz6UlK4jlH0rYiW4wDkMAHE+llVb/D71w/T56Xksyq+rI5NmVhbPqlyRYxhDpvpjGIFgk1uLcRVbCDZGGM+LcVzBlJI5ynnpLrBv4h7he/OS0t+A+1rBZIVTJZa7eK8hDkpfK7U0vVMKQpSy3LTnLXrIWxBeQziBPorZhIlS6OT0N8Egt8pF08YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(39830400003)(42606007)(376002)(346002)(396003)(136003)(54906003)(316002)(33656002)(2906002)(508600001)(6666004)(86362001)(52116002)(1076003)(6486002)(9686003)(66556008)(4326008)(38350700002)(38100700002)(33716001)(44832011)(5660300002)(6506007)(66946007)(66476007)(6512007)(6916009)(8676002)(26005)(8936002)(186003)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NcdA1sjlm9XBy6zJgy6kN8ARdCYDjO2TBwdQkGveVRlJa6KGKbZj4I/5XE4Q?=
 =?us-ascii?Q?gTxlgSwO7PrEfZCuR1zSm7nFmD3rlfQpvg6geiGNLVQOt88oKENfOC6gXE7R?=
 =?us-ascii?Q?H9GSPLjakZA/wb/FCTDOpiBnvMNB+JOBu04uuEafZPZ+Ir2ir4/XSgZICFzu?=
 =?us-ascii?Q?xi+QRUj+R3K6wJaTS5o81GIIrGIf8uJ76AS32hn++DYuNa4LBPxN/AiyRc3W?=
 =?us-ascii?Q?URPWS4JU/uLndnXbXZVEjrtQPA309xkCqmVill5zZJKLGi799/dFw60xk/tD?=
 =?us-ascii?Q?s7TnT/Seh81NJWlFDeUH1baVHyp+nqg6/Prgjl+GSDe68XnDmsLQaFLovKqa?=
 =?us-ascii?Q?ne6b2aSQYVZ/vO7ahMLpQl2zkmJtxUXCJNIgVR4G5uCJLmS+A/KuHC2HhwpS?=
 =?us-ascii?Q?ZtJpx0LYs7qGPob7WXKj5d/WMSkGZezYTOZbcgHI2dOsnVQrOPepVNJPuAKk?=
 =?us-ascii?Q?IxEvV3pMVdVtn4D+DbqsfMoxmx5yMCQg44EA/4S2M6hasfZTkCVbiACpuyM5?=
 =?us-ascii?Q?w+gUNQPGmA4gf/x0TxQ7u2hNHXlwlOudDGGbHYRkXyLCYRgP5/GWGay9vDTo?=
 =?us-ascii?Q?pFA6rilW0XwujASPrEXG12e4GWrOJc03FVzjZSTq9e0sGG6dI14MKG/QJnv9?=
 =?us-ascii?Q?P0dIX0zSKCm97ojSXhTH3WRuHFN0DaC4/xEwvXUnJPQvjlnZIQ0V3x5Fqj2K?=
 =?us-ascii?Q?bwpTIeJQf3Tb7iwbemGu/sHrRqxVDf9ECsQ7gn+g1JvrVlbp2rcuy6678yb0?=
 =?us-ascii?Q?6fl0NRNNOQ542rUiw/2xalrzTMaX66dRDz8H2rKcQJPK6Ka1BwVwBesWwMWT?=
 =?us-ascii?Q?xMK4u2JxxPRBOP4UOLeap7nBXNqd/S6OvceA8CpLeHp9cxqgGOKAz9aQh03J?=
 =?us-ascii?Q?SEtcswyasmsQg+gkQALY0LdU/iXm6//wHw5oeVnl08aaFI9L6bwxNCnHZDfb?=
 =?us-ascii?Q?xJJjvwtL+YUqWFjENSiVydGGhcKYHykLhl6p+qPbwzAjgOK7PUEVwbYKllkg?=
 =?us-ascii?Q?D9sv/x/JdHSl6RiXufq/ON4eN4PSA/rq4Afthf/qV3EwlQXuZvIMY36v2GWM?=
 =?us-ascii?Q?CZgc+NohW/DkyASs+8WgsS6/uCXt/H7YxozLMJH7KAMSJPEJY2fjcxfRzMLP?=
 =?us-ascii?Q?bjAl+b7ybNUT5Hsge0P3TlKyq1Ff8BLi76r0djPbwsGs40wZjxhvQuU4ubGV?=
 =?us-ascii?Q?3LM69JtEgnslH+vb27ycmILaxl9jFyPt1KERgrCwoe4OUJ0h/X/DY5xF8Gys?=
 =?us-ascii?Q?0ifWK1aX7vpD9R2w7SVY9eAiFLP0qT/VcvghGbYD/92wQBYwG0ufdzKgoVCq?=
 =?us-ascii?Q?QeR9fFQi9S+QH95wjBvMUYMqaPClqMAH115ntdIBI4BexQd5u/4KaytjaWtJ?=
 =?us-ascii?Q?KJgomLmzOPm4h2sai3DZhQnaIQSbxvKKLbotoLDX8HUaTcq95Oxie5MG1S9g?=
 =?us-ascii?Q?wBQALLcohO8OoOuCCVmvGLTrzSaTmD8MCyiTSR18wdcqFMgeW/nHy1rqoscF?=
 =?us-ascii?Q?EshZz7J4pJ9+JSX52OAz0u8JsrxTwN2vhRuASHl3+4f7dyH5rFphnBFaYy1C?=
 =?us-ascii?Q?0Ru8hLfjRpYTBmpEJuIYUv3Bo61Tmb6EyfF0G1nWXUmfufYFNSq+95WV1Fko?=
 =?us-ascii?Q?/EpFi7aYZPwOkAbQtnXPgzMJ/TC13okF6j8qRD5PV5kfwqYUEBBzIBUdcMIv?=
 =?us-ascii?Q?DyKUmg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e459200b-4abe-4d54-7b16-08d9d7cbdab7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 02:08:00.1957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J17attrkZk6UtK2CUrvSQfZlDOs6byw6Jg6D/WFFKJc4+8wGS2sKSrJCZquZfE2u8GoRtZxNRYAzqccwrUSepFTuDa9l3MjJvWBbjUi4UCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 10:28:15AM -0800, Colin Foster wrote:
> Hi Lee,
> 
> On Tue, Jan 11, 2022 at 05:00:11PM +0000, Lee Jones wrote:
> > On Tue, 11 Jan 2022, Colin Foster wrote:
> > 
> > > Hi Mark and Lee,
> > > 
> > > > 
> > > > > However, even if that is required, I still think we can come up with
> > > > > something cleaner than creating a whole API based around creating
> > > > > and fetching different regmap configurations depending on how the
> > > > > system was initialised.
> > > > 
> > > > Yeah, I'd expect the usual pattern is to have wrapper drivers that
> > > > instantiate a regmap then have the bulk of the driver be a library that
> > > > they call into should work.

I'm re-reading this with a fresh set of eyes. I've been jumping back and
forth between the relatively small drivers (sgpio, pinctrl) and more
complex ones (felix). I was looking at this from the narrow scope of the
smaller drivers, which typically only handle a small regmap... only a
handful of registers each. For those, there's no problem, and is pretty
much what I've done.

The Felix driver is different. Currently the VSC7512 has to allocate 20
different regmaps. Nine for different features, some optional. 11 for
each of the different ports. The VSC7511 will likely have 19 different
ones because their ranges might not be identical. Same with the 7513,
7514.

In this example code, the resources are getting defined and allocated
entirely within the felix system itself:

(drivers/net/dsa/ocelot/felix_vsc9959.c):
static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
        [ANA] = {
                .start  = 0x0280000,
                .end    = 0x028ffff,
                .name   = "ana",
        },
        [QS] = {
                .start  = 0x0080000,
                .end    = 0x00800ff,
                .name   = "qs",
        },
        ...
};

(drivers/net/dsa/ocelot/felix.c):
for (i = 0; i < TARGET_MAX; i++) {
        struct regmap *target;

        if (!felix->info->target_io_res[i].name)
                continue;

        memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
        res.flags = IORESOURCE_MEM;
        res.start += felix->switch_base;
        res.end += felix->switch_base;

        target = felix->info->init_regmap(ocelot, &res);
        if (IS_ERR(target)) {
                dev_err(ocelot->dev,
                        "Failed to map device memory space\n");
                kfree(port_phy_modes);
                return PTR_ERR(target);
        }

        ocelot->targets[i] = target;
}

So Felix will say "give me regmaps from this array of resources."
Resources have been added as development of Felix has progressed - in
this type of scenario they should be able to do exactly that without
having to "pre-register" with MFD. More specifically: why should adding
precision time protocol to drivers/net/dsa/felix/ocelot_ext.c have any
effect on drivers/mfd/ocelot-core.c?

The patch that I submitted utilized the function
ocelot_get_regmap_from_resource. Does this qualify as a "wrapper driver
that instantates a regmap"? The more I think about it, the more I think
that's exacly what the current implementation is. It just creates
regmaps for all the child devices... and it creates a lot of regmaps...
and it will have a lot of child devices...

Maybe something will come to me in the next week or two - clearly I'm
prone to changing my mind. But in the meantime I'll focus on cleaning up
the rest of the changes that were suggested and prepare a new RFC.

Thanks, and I'm looking forward to continuing work on this for
(hopefully) 5.18!

Colin Foster
