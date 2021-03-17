Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312DF33EBCB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhCQIpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:45:54 -0400
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:14176
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229508AbhCQIpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 04:45:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUchZsUX69TLoHA0tuNrKwm2yPtYLer5+1j8wxmF26S0T+6H+Q8mOlTJHkmuUSa5+gODpvOjcifunjMV2ahsHF8LUR98se2ZNusU66+zlOmAFwlJ7GkOLvMoTGlTphhAMMgFQtkx6LF3hwmxXTb2nfMHftWYBiUtlRPs6kFl9q4DSDR2CqjpXSbBo2O5C8bOGme9sFoP5Cw/1h0KlSrZtBbhB7rEX0nD1FLVLEhMJ2aCFuWQRIVZTvDw+RvAQQFBpBnROKXzCqwj2Nm3qb/9pfYECxb4JN073VS7onHMZGtvt6q7eEnRSYQW6ePCDo8vr0lm+GS0UPSXHee/L4y/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLvukkUxnZefbzho6SbIBs3oOzjyo1+hCeJyL3sWfWI=;
 b=fLBHJQLeByuCwQfioLl+EHjvjiOxIGXqAsfmXZ6WixWW/OzBcFhuIxP5HLyQHCr9wh/WHskj7dbKDGdiAzAmqtIG/X8S0NplgK/oZCWQMACYGiDZi0T4D2PUMNJgNmjph4XQYeRkvEdEZROuM03cJBkri0B8tnMRdt3i+QTA2btaRMk/M3i89cH/LfEtLCOJKbNCwDGtx1PGJfI2dwCDtarWATx5W1cEOvmn5U/dAlBOZeFtMddQohWPLewGn2C0LPLG8fPZpHxByjOUQQ4AnUUO/RxSe0sHChMwnFXX8Xpa2MwUOhv87tVDN3nhGLxYAOEwHtcDkFWHU1eVTzSrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLvukkUxnZefbzho6SbIBs3oOzjyo1+hCeJyL3sWfWI=;
 b=DvyFAfLxTzxSs6Y9vG9CmCgHinLPjgvFiRL9qEWovqZofixBFh8YB5V5Eltgna8nnD976ZfMiD0AH2FrHV1QELNrc3sVp54GMzeIVAdYYTwEarnwfk6cCiJj4cnDl50S3Lq16QUr1YRYtRuFaBjqTJ6v6BBgPCdRI9SBx6eq6zc=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 08:45:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 08:45:47 +0000
Date:   Wed, 17 Mar 2021 14:15:20 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 04/16] of: mdio: Refactor of_phy_find_device()
Message-ID: <20210317084433.GA21433@lsv03152.swis.in-blr01.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-5-calvin.johnson@oss.nxp.com>
 <20210316191719.d7nxgywwhczo7tyg@holly.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316191719.d7nxgywwhczo7tyg@holly.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:203:d0::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR04CA0018.apcprd04.prod.outlook.com (2603:1096:203:d0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 08:45:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22374e8b-9ee5-4b02-bab3-08d8e9210ea6
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963F88272332B4989BE8730D26A9@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTiCFy26MX5C5wnIgkhj4GD/BY4NtVZeUob0CXPbgS3T3swPAM+J+DlGnyltisEJJqJw19Xj53AA2BhBMpypdB+vECqqXyx9BhYjDgHWZpYi3QzYVs5KFS+2Q0rHvaBxauI1vzXjo4W+2xPbwRj2PSoAEFZMx+zSwVOx9vmNqT3CoZ2nEuanYBvAGoU6cKC84Gi2l/cD70bDHXJVqt8nMXLkaQqTcNVdmuGyUk1NupXZ4+CX+/RObkVPro2MKpa8SZQ5TdgxxAVwU1aSeoFIKxPPimC6XssYIfLfCexSEpvsKDBwHgxVmw3wFa7z3P3HRqAggahnDTupDr9zKko+AJ2QN3grBpAI4DowFc07JBJBOTVjXjevGVBIlLDFhu7DbaGo2X+ffchQhADXugc8Vil3A1fMv/Zw7AlzJsLXnj03i8+RRdOxwvDaaOTsIwy+Kk8IBHaZ08176hH6mtlhAhq1y2GuCqHH9X0P1H2NDeGnmykMa85sl8aC8BreaJG0F8yusbjMZfG4YrousJHCHlMErypf4xIWW2Jo7n30BhwoOx6qJSuMHt1ERxWPydWlX/i7MN7IEXjs5/gM3cxFLya4Fmiy+VgpBH+/kmrounL6UJMKqWuuA3hSc+f/HYi8vRRcvrirFTVkpNBJjpsUcQNCHtKHAndgLl9cRbzvWQXRg07RvchSplpFxOrRx5iC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66476007)(498600001)(66556008)(2906002)(6506007)(186003)(6666004)(33656002)(16526019)(1006002)(7416002)(6916009)(9686003)(1076003)(966005)(52116002)(5660300002)(55236004)(4326008)(86362001)(26005)(8676002)(55016002)(8936002)(66946007)(54906003)(44832011)(7696005)(956004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+Z6bTfvR8aqw2SrBFXZHWN/OB3APRnZEEz7G3rUjHLQBLNmDXoUqv2lBbDIM?=
 =?us-ascii?Q?uECLWEuzRkQAG87s9uqEmLuOHbSLGPweSy40EfRGPW2r7FVwxzH1WJ1ekN2i?=
 =?us-ascii?Q?D8CVzsmVzArh8zMhSEI7Dn5reVht+REjy6fSx2ba9SB3XekoLk8LSUZucvYJ?=
 =?us-ascii?Q?Ut7UCd5r9bAu7Na2g0KISNDxOXHQpCM5oPraqosgH2XaJooDzcU1Fpdn81eX?=
 =?us-ascii?Q?ouUYNzqKOo+BDEvh7NcYvDANOZS/BKCyhB7JyCaacZ2TyAa+xn0HIkS1fF2T?=
 =?us-ascii?Q?/QHWdsxC9FCmCgqV6GY1X4gVFkpN/xFGISIwJO0UR1ImMVftIKdvuQJ7Hrgk?=
 =?us-ascii?Q?5Xq0iLrhRTlQ39ztY7xqPLn3IZ1kKh8vEE3DFyO+KRBKDcN7NO5EuW/cJm8f?=
 =?us-ascii?Q?SxZoa2xgRBdslPK2kAghkjoa1U9/oJyQWeQ+C4RSYLCR+MxyNXMvrQBGp4WK?=
 =?us-ascii?Q?MlLG0VcIV9XeM1dz+6Z0OC4efQo1CgDfUaOOaSFdmM0BVaKPSp3a//HTOqJh?=
 =?us-ascii?Q?pXSfB8TDL50N9XBNX8M6G/kiaIE1KwgPE2l1Ymxo6ZBoypwKW68eExKimwHQ?=
 =?us-ascii?Q?2Jol7fOydtSY+hfEiCl8wNaJxM9IBEJUorXtQ5g5r1drMhGqi0WLx2mwq9IE?=
 =?us-ascii?Q?FI6LRWNl7af6VMcimK6AwHGCIivHZARVA+UwlftOk99OcsdJbYMc0BD7n4/D?=
 =?us-ascii?Q?s/CAehCDuXLZiK/U2ZUp7AqUXKLj4ck8IfjhfzawuRgc5jShqCunn5q8oeV3?=
 =?us-ascii?Q?zz4yg5CGxxroyH+Muw21K7Rw1BchyzAk5DA0DO1biCqOSe7gAMgrcm+b6+gC?=
 =?us-ascii?Q?0JUcbxho/UdJdlZXwttrfMCoHx8DDzELmNYG5lB8lqcB68jUVTerAzYXEsFP?=
 =?us-ascii?Q?8w9jZRtEeszevvqhV+DIBpsfEALBwjPASZfG6G0f7r8RyfoA08RlxNJrFD7K?=
 =?us-ascii?Q?36CAceTF/Fs/MyvzPH8ftYBqBvNGC3068LVBI09Q/ZlOryM3cm+Dx7DxJ0fB?=
 =?us-ascii?Q?oTgfkTNg8z7QhZbawnUUloXztsdE1K/VPtEOu8A8Y0vQkx1YcV7lkovT107Y?=
 =?us-ascii?Q?LdVgYU0uYRMll9TcIe0uk4dc0/mdxX6IZySg1FVUoTq6zwIm9LLDu21XSxCU?=
 =?us-ascii?Q?VQq4V3sQUmlslUYNn4Tmqma5MoIwDjk3ibc76QtiEA0bPvS5KMfXQKCAVGoS?=
 =?us-ascii?Q?p66Rgo3NS7B+eu5NjazQXcRlCQ2tO9upHLt3FMpvbWdicxgJAzgK1Tkyqa4/?=
 =?us-ascii?Q?yqate4iEFE0u5C9fKdTB6+s9xATD8rb1NiuinciRyITSTOlPekJiyNwMFY4J?=
 =?us-ascii?Q?+BExNYt/S6E+MNVZGaJNrY8z?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22374e8b-9ee5-4b02-bab3-08d8e9210ea6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 08:45:47.5847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TLwj+nKQilMqa1235DQPLWEqJP+7fMZCAh/56O6TC9G4cdMR3dAFC/tLfIO71PXbNGDckcMjRCfLnrmNBrIuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, Mar 16, 2021 at 07:17:19PM +0000, Daniel Thompson wrote:
> On Thu, Mar 11, 2021 at 11:49:59AM +0530, Calvin Johnson wrote:
> > Refactor of_phy_find_device() to use fwnode_phy_find_device().
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> This patch series is provoking depmod dependency cycles for me and
> it bisected down to this patch (although I think later patches in
> the series add further cycles).
> 
> The problems emerge when running modules_install either directly or
> indirectly via packaging rules such as bindeb-pkg.
> 
> ~~~
> make -j16 INSTALL_MOD_PATH=$PWD/modules modules_install
> ...
>   INSTALL sound/usb/misc/snd-ua101.ko
>   INSTALL sound/usb/snd-usb-audio.ko
>   INSTALL sound/usb/snd-usbmidi-lib.ko
>   INSTALL sound/xen/snd_xen_front.ko
>   DEPMOD  5.12.0-rc3-00009-g1fda33bf463d
> depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> depmod: ERROR: Found 2 modules in dependency cycles!
> ~~~
> 
> Kconfig can be found here:
> https://gist.github.com/daniel-thompson/6a7d224f3d3950ffa3f63f979b636474
> 
> This Kconfig file is for a highly modular kernel derived from the Debian
> 5.10 arm64 kernel config. I was not able to reproduce using the defconfig
> kernel for arm64.
> 
Thanks for catching this. I'm able to reproduce the issue and will fix it.

By the way, is there any integration tool/mechanism out there to which I can
submit the patch series and build for various possible configs like these?

Thanks
Calvin
