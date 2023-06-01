Return-Path: <netdev+bounces-7160-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94DB71EF20
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80A5A28184F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47345156E8;
	Thu,  1 Jun 2023 16:33:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C42D533
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:33:45 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2068.outbound.protection.outlook.com [40.107.249.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B0D191;
	Thu,  1 Jun 2023 09:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnwoDk1AHW2jmo5twZ6HTEHXfi2KhvHVV0S+n7fzCuwoaQs2E9ucIUiLsQMgDVw1UggdUKmIw4bzySyUW/VuomXZ0Qmb4gewdam2rfi5aBFAHSvQGJb39LNCjeZFT6MmSvODThpH3Vo5aDKZHol0dHFVYHBNfFCM94hUVb2a3LsxtesG1V4SK52/ONzMnWOm1oZyGnGnDl+gK8lQ51QjpkLH1LgGD/6Z0wnvJE40P2RlygZpd8+q4mW7ib2FX7lYxVNIMQdzn3EVrfulpfgO4n/PyrzoK6jM3voKUbEHXyo4/LsHekniJ18aqC+g3A7drtYkJTysZdjbY6fOGbFRkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kGgXEki6P0ZXuxbW+x1+eVgW8YLmD79Koz27CcYezg=;
 b=YsdPKGLyab/Y7q1Ui2uHSKD5PPhap9EgU3d5thZ5eg1hT4HuLHoAp7kIQ1Cpz7g9o2gGQQt3jgEZREjtpQY+aF6jy0xKCEuAJ5jvcdpaaVth+dibXMn8tZ2Oc6mkg0SNn8i9UNzEkIfqrgZknwRVpitJbkBgrHHdaArhNk+wC6PHAJTovmFQ2sNGkHbUS8GGHBlw/EhGAccRFDmfmuJwNfw+Vy9ScidHXoRHA4TD7V4awg5/Tg78s0f3R7pXrHirXfwDaNJyGwP+b3p27a6ZEjlxvtmSkB7QKHBpcAjmvJ1a01uJ1HThBl1e0kmHC6aVg3WKUgPmRi1gDmPHc83b4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kGgXEki6P0ZXuxbW+x1+eVgW8YLmD79Koz27CcYezg=;
 b=SJV6VOvqO7Mg7AeHmja0yoawyn66V3hxunvaDqc2CiIsA4UQeZlcAYAdOZ0AXYG6C5HH+hhIY30eCDZnXhmhxkcvF29i5X04vB//I/RtouLn/k17d1Fc6oZhcofUW0frKUy2Kz7J7Whheifzp8YcAgnkmhRBqvSLqCus20kNtuo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7760.eurprd04.prod.outlook.com (2603:10a6:102:c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 16:33:39 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 16:33:39 +0000
Date: Thu, 1 Jun 2023 19:33:35 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Liu Peibao <liupeibao@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
References: <20230601081156.zyymihd565fscuha@skbuf>
 <ZHi87bqTFQGKDhYO@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHi87bqTFQGKDhYO@bhelgaas>
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: 70bec76e-f81c-40f9-056d-08db62bdf458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p2RF0Xoly17lSjj9DIqWVbjN5ney0rdgCNDJHHcUwbXpyepC5b0CALstPi/CMxn2LdQzS7mnxtSxmI0rZBgMLwVxNvPipm0iKl1oE4D4oZcol8R40lQbKmQy8Mt5cUx9oBfOjwFD0tD+TNEDiwilGF2yR2dpiACW3bsbOsO1Pjvk7wwaIF3C1dRbuPZDjHhugKjAyRb0iQcF92klGniKx0zprqoOhTW/86ezMT7PDdpRB2PsD2ycRC5JCxNAnQ4XA9aOQxtsYf0Vt/eOuaxPd39DbsIsjGdgnMRXTlrxOx1MOoPNYElsTOHFyT9sF3240vdPGNxAeJMEVy/CYyM9pQEwsSMdEg119ecc0q5ItOkt3vzHvQeUL47ZT7j7Dre57vjPcMOUUBadyKkZkcET+pECzC8CPZL0fm3dD73Zve5vbTKKqepGocB0m7ojHfXT/4HKwD8zCJnkT+bprJ/lkcT/xY9MizvAdAI29gVY2HXXhmqDp4YmhdlhVcFQ+aZvRi22Ge8/nrwzYjpR482vEpscQqw9fy4SHgjvu3oOb3N+0HVXtIEdl41VpvElBD6w
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199021)(478600001)(54906003)(8676002)(8936002)(44832011)(7416002)(5660300002)(33716001)(86362001)(2906002)(6916009)(4326008)(66556008)(66946007)(66476007)(316002)(38100700002)(41300700001)(83380400001)(186003)(6506007)(26005)(1076003)(6512007)(9686003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T8MkETrqGMIMJOaX0pmrcwQcAJ1AjkLV98zrFJezIOeTvd9emaefjHQMUIyy?=
 =?us-ascii?Q?I7AHYJHVEJxzOiyg/s//hp/1LhtWvEwtTixpi1Ia7ZvL7Fk9cQvjEMYkC5B0?=
 =?us-ascii?Q?Li77vh6KhSOP0Bmh0z4bw3AhxDDK+FKT5LGVouST3vJOgozlH53Y00QpgYsd?=
 =?us-ascii?Q?7QNIyABsOmfG/4IWaVZMDIRCqYKK8TKw7IZr5lpLeLLKaJEpxDR7IOqjgeAh?=
 =?us-ascii?Q?tO9g8+irCvCyTwPTL+pqW1dSQTLLS4X80gSgczSPrZRmEW0zBF2oUIefQVcB?=
 =?us-ascii?Q?T4RI+k5g3dKMFRY5HFryU6fmjlk8/KHgWlEJx5+VhKnq40uyemJ79B7afmfg?=
 =?us-ascii?Q?ZJIa2kTUPt6cYbdE8sl591tV6QBKNns1HVC+xZeSJjdRyLK+xprNe+kQ8hBw?=
 =?us-ascii?Q?gzB/u9ZhutHOYd0EujPGBM7kZ8nVRi0en5rbTfz6nHWbzC8ZhUT/tPDCCzqI?=
 =?us-ascii?Q?QUP3GFuaWPGfvX8gT65drvly4ugNSXIUoy+Jc8lGl/5xHfAuBDoPB0BSTCL9?=
 =?us-ascii?Q?huXDGbcFGOWbuPySsz4ev1aHyabqhYdik17qNUxg+O+NYZXF2q3blk0SZwB1?=
 =?us-ascii?Q?Oi36BAqy2e/Pm88YuwBVE5yQeTf2YXf07Gzl0Bcrk4mVc46LYhTDAKafZ8Ao?=
 =?us-ascii?Q?zUN5ZtyDZwBnNi1bK8V5aeO7ivdJJmWx9NqPHFNbpTzpZVNS2I4kEA4JrhM+?=
 =?us-ascii?Q?5UOllN8FyBDpz5q1B1b/z0FyqBU1mh+YnAODrkIAspTFdWN3lj+azwMONZD0?=
 =?us-ascii?Q?uozV7wMaLHHK9iVQs5eleG0wZGVQfi+KIu8TUoLy0gRCtMXc8jzJS7nhysXf?=
 =?us-ascii?Q?EhaFOF9CL/GwMXviqQeg1dyIFKCciQxFkmd9lwlXQ34sRJuuF0h+GrM5o7Fv?=
 =?us-ascii?Q?TThQrDmuyXV1RMuHIOYaSRQO1Bi8az+AHWFXzbu7j3qLAUkQLlmUAs/aMlxs?=
 =?us-ascii?Q?2KcjHi/UgH+bL2TIselnXzXfCqE2j4p5tG46pqAALYrFmYTN8CFi1ghW3b83?=
 =?us-ascii?Q?NX/f1BAMCHoXjNqQp2X5alVM+ST1cJ2NK5bGIey6k2nvQkqt92/rqydqhxM2?=
 =?us-ascii?Q?8X9A8t5jqz/aw9phB4DJXxhvU1DJDzRX+OqlJTMVJE3Bk6734Xco0lQy/WD0?=
 =?us-ascii?Q?V+ZI+rVv+BxAVxANevZcB6YOR/ArO1J7IgO+iJcACRP9Qz7kdAuu7iiSDlW3?=
 =?us-ascii?Q?S9UlCrUxeSqTLZBu/Puxq7BS6kVeJBOfxV/gauep1cgCD1+0pYEOMWuJ3cP6?=
 =?us-ascii?Q?P7olYliCyxg+w0ZPM5xL234zYdc2S9fzkjR1lachu4zB42uXgDvpus+64ENC?=
 =?us-ascii?Q?D5Z5IosH4iiwRjYvaLjDT5RUYXeWG5/8WtrXGo4UAiDL0DYSp4Ex97/P9kuU?=
 =?us-ascii?Q?xsqIR/eKSKiOGwnODWeU4W5Vqy44QtvhIW6w+YT8nW3wCrhrci+Ffcn7dEAZ?=
 =?us-ascii?Q?LETq+4LyFtw3CWhk1ItnghqPZZ7mpweLJJcM2uS69h/QhOVDVOZi5qHw/Bdv?=
 =?us-ascii?Q?jlJRhDxzWqSbdTrWJ+NxEIXCZb2BX/NybxKCvBI6VRoD10KF1vsld9IIHsLR?=
 =?us-ascii?Q?q+lFOCV0H+aWORmYRmN3HwVL6aaq9TKx8BmvfqOqSiLfcOs4+hVk81jXYCpY?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70bec76e-f81c-40f9-056d-08db62bdf458
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 16:33:39.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eb2dJeblOXzmGDeFaQkG1ZkY+f5qluY2xti3bmzG1T08MSYLQDjRYaZBhj7rh5FpQigbj5ax3KqPVCw4UMZwWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7760
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 10:44:45AM -0500, Bjorn Helgaas wrote:
> To make sure I understand you, I think you're saying that if Function
> 0 has DT status "disabled", 6fffbc7ae137 ("PCI: Honor firmware's
> device disabled status") breaks things because we don't enumerate
> Function 0 and the driver can't temporarily claim it to zero out its
> piece of the shared memory.
> 
> With just 6fffbc7ae137, we don't enumerate Function 0, which means we
> don't see that it's a multi-function device, so we don't enumerate
> Functions 1, 2, etc, either.
> 
> With both 6fffbc7ae137 and your current patch, we would enumerate
> Functions 1, 2, etc, but we still skip Function 0, so its piece of the
> shared memory still doesn't get zeroed.

I'm saying that as long as commit 6fffbc7ae137 ("PCI: Honor firmware's
device disabled status") exists in the form where the pci_driver :: probe()
is completely skipped for disabled functions, the NXP ENETC PCIe device
has a problem no matter what the function number is. That problem is:
the device drivers of all PCIe functions need to clear some memory
before they ultimately fail to probe (as they should), because of some
hardware design oversight. That is no longer possible if the driver has
no hook to execute code for those devices that are disabled.

On top of that, function 0 having status = "disabled" is extra
problematic, because the PCI core will now just assume that functions 1 .. N
don't exist at all, which is simply false, because the usefulness of
ENETC port 0 (PCIe function 0) from a networking perspective is
independent from the usefulness of ENETC port 1 (PCIe function 1), ENETC
port 2 etc.

> 
> > The ENETC is not a hot-pluggable PCIe device. It uses Enhanced Allocation
> > to essentially describe on-chip memory spaces, which are always present.
> > So presumably, a different system-level solution to initialize those
> > shared memories (U-Boot?) may be chosen, if implementing this workaround
> > in Linux puts too much pressure on the PCIe core and the way in which it
> > does things. Initially I didn't want to do this in prior boot stages
> > because we only enable the RCEC in Linux, nothing is broken other than
> > the spurious AER messages, and, you know.. the kernel may still run
> > indefinitely on top of bootloaders which don't have the workaround applied.
> > So working around it in Linux avoids one dependency.
> 
> If I understand correctly, something (bootloader or Linux) needs to do
> something to Function 0 (e.g., clear memory).

To more than just function 0 (also 1, 2 and 6). There are 2 confounding
problems, the latter being something that was exposed by your question:
what will happen that's bad with the current mainline code structure,
*notwithstanding* the fact that function 0 may have status = "disabled"
(which currently will skip enumeration for the rest of the functions
which don't have status = "disabled").

> Doing it in Linux would minimize dependences on the bootloader, so
> that seems desirable to me. That means Linux needs to enumerate
> Function 0 so it is visible to a driver or possibly a quirk.

Uhm... no, that wouldn't be enough. Only a straight revert would satisfy
the workaround that we currently have for NXP ENETC in Linux.

Also, I'm not sure if it was completely reasonable of me in the first
place to exploit this quirk of the Linux PCI bus - that the probe
function is called even if a device is disabled in the device tree.
I would understand if I was forced to rethink that.

> I think we could contemplate implementing 6fffbc7ae137 in a different
> way.  Checking DT status at driver probe-time would probably work for
> Loongson, but wouldn't quite solve the NXP problem because the driver
> wouldn't be able to claim Function 0 even temporarily.

Not sure what you mean by "checking DT status at driver probe-time".
Does enetc_pf_probe() -> of_device_is_available() qualify? You probably
mean earlier than that.

My problem is that I don't really understand what was the functional
need for commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled
status") in the first place, considering that any device driver can
already fail to probe based on the same condition at its own will.

> Is DT the only way to learn the NXP SERDES configuration?  I think it
> would be much better if there were a way to programmatically learn it,
> because then you wouldn't have to worry about syncing the DT with the
> platform configuration, and it would decouple this from the Loongson
> situation.

Syncing the DT with the platform configuration will always be necessary,
because for networking we will also need extra information which is
completely non-discoverable, like a phy-handle or such, and that depends
on the wiring and static pinmuxing of the SoC. So it is practically
reasonable to expect that what is usable has status = "okay", and what
isn't has status = "disabled". Not to mention, there are already device
trees in circulation which are written that way, and those need to
continue to work.

> (If there were a way to actually discover the Loongson situation
> instead of relying on DT, e.g., by keying off a Device ID or
> something, that would be much better, too.  I assume we explored that,
> but I don't remember the details.)
> 
> Bjorn

What is it that's special about the Loongson situation?

