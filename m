Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB707468B97
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 16:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhLEPJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:09:10 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:39458 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235147AbhLEPJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 10:09:09 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DFCF24C0066;
        Sun,  5 Dec 2021 15:05:40 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJ1VgOwUROUSB9c2ZCos1jiLqH07KBeME0mp0/lIlPlKV0W8ZCpPc9FogaeVknULHDqfn81U+trqrm1j1bxm32BSmg3SMlr5U55iI8iOXeqdMHhtHTrWtPHpi4MU2nitxkzFOniOJk0jrp/Q/xiqzWklbBsNpQCvfOkVgNVehkZr4dp4u0gsKyLpU8XUKkl1ZDu1D6U2Vql0jhrfCaueG8jCu9bWLJevk7hEtDQetD+vdOQo3KrDe0N9l2imcygxEVd2UstWUHIQFJr/L/cePTmKmJRDeUi7Ig0hefYp6G53OhpYCn1Elh2d6PMPP7yLw53XR4R46wpwyhnl/omuyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/NGZm5QUSgKzezKtfuvuEm+tc290ZbRGYTBhSGuz2Y=;
 b=YqBHNlj/07GwglIWi9HowdivNyDpg9IBnQyDAr13wXZF0Z3J/4F0QHUI7E1smVhNX4TxKZHz+yCQLeolpBmXTvCvJjW/Ibxdi2AZ4ScXiFdlRxACnNAw+PLIq+XDFIQt6/bEq4wr+X+3baOKiX/EHWX2Xc1SCgx9CVYToCEHT3ZohHqWGc0Y50iw/3zHz9MkgucEA+t+CojHqbbZbXmwdGHhNkW7NEz2+MM/zrzRtZaQOrIv5mdtqW77v9cwJ0i6FBIIgBiGCyuAvL5XR6N2nxqH/WKmay871djxt8s/3zYsXGCuYnwopFA7ezkI/dZenzt3lww0YVOvZ5CSiYapHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/NGZm5QUSgKzezKtfuvuEm+tc290ZbRGYTBhSGuz2Y=;
 b=B3QUJ7UDk7KvS6pIPSFAMEuX0uoNS5Z+4RScJGCcGtdpVolJXpGmfzfalRblHSnSDQzC088bAkNqjtHlHljst784sV/j58LOgSS/iqgOvxVkQ2VMwD1YfqWMj7caPUPvaEaaXui6LKD8Cu0KRplp+VJiRRyYML216fzZLOA+vyY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sun, 5 Dec
 2021 15:05:38 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.021; Sun, 5 Dec 2021
 15:05:38 +0000
Date:   Sun, 5 Dec 2021 17:05:32 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211205150531.hy4rv7mtgau37xe2@kgollan-pc>
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <YayL/7d/hm3TYjtV@shredder>
 <20211205121059.btshgxt7s7hfnmtr@kgollan-pc>
 <YazDh1HkLBM4BiCW@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YazDh1HkLBM4BiCW@shredder>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::33) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (82.166.105.36) by AM4P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sun, 5 Dec 2021 15:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ff51b77-bc7e-4719-99e3-08d9b800b24f
X-MS-TrafficTypeDiagnostic: VI1PR08MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR08MB5504B0A4507A0CE9772F6B5CCC6C9@VI1PR08MB5504.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iAWiq4o7IXKDINJmqCu1Ov4EpRoubu9QHzCRPEgd9NLLa1RbVvW3rXlL32yzzqoQCCO7rfhtldG9yoh3gl/3rgVqMHueRNusUnSKHKJcfCCLjBnz47HYxKbtZcnH/BjuQDxhVk27/hSFUFHs/6fTuKfAfsgb3apu0hMDt71yGqYwuBlZS1QQn672mklsXFBfurHesJSAQjSCAhm44/Kr8aThUBpzxNGRRuJKBmv6oOgCM+VrzAOa4ic/013/RI/Sgq5/kkpqqzPLnjVpgdnQpgX7QZRWozfSW6MAroAC5mcjccR+VaWSSah5dTdMgTvMvkuobRNsafUUyWPHgImpCUCvoqOmzxstPO22Wk/jf16F7yMNb2M0XvzAyoWHMigvGNTz3pyghGYSIkgJrIooRbwnbkXkI1lZfZEZ+ZmPCp5qLYcF06QtKpgLjl+UhVUKTGvRkZlT2/xLIvfED0zdmDutkfVzryM9yvb2GKtg2fgiU9DbJ7JbyukDQGKO2viJdqtoPQFHtLceltHgh20UKuEKgFl/Ork9DSsUy7gQfGYq5lTG0j8c5hfq+DzhLLYc5JeGpJx7p3KCTXHUBJSTRUSMwFsjgff7SvQrI55XPjizxmMfN4mX26qgkacuB4BZHf6Nmn1+YRnT0sGP1s+aYx11Ey6WhGQ3z02PXVID2y1ZlJHzp7dw3umIYp1WpOzWEEb6Atro0JDq0nyBxfMwxAiYkijNc6D6+bSEjGdBRP0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016003)(33716001)(83380400001)(316002)(26005)(5660300002)(66574015)(38100700002)(508600001)(6496006)(38350700002)(66476007)(52116002)(66556008)(186003)(66946007)(86362001)(4326008)(1076003)(2906002)(6916009)(9686003)(6666004)(8936002)(8676002)(956004)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njJBUyi2dFE2brwkl7J9q251yRhFPTxUmUhyPJjR9A6/TVUCFrSVgB8iuJQ9?=
 =?us-ascii?Q?o9Bewxd3kWkEgd5JJEW/IUAosB7bm7CM8paCnx9wqA8NSHJqFXeM33AqckDt?=
 =?us-ascii?Q?3Ld94Zoyxl1rXEv0h1O+FFdBWeShpoHM3SCtFEMxy/ftif1g2wAgUzc62YRn?=
 =?us-ascii?Q?XsZxzvxF1+BYAYUnRcyi/nPoG/p9MMuhTQz59DApkqyqU9rg58mSRyxLSvar?=
 =?us-ascii?Q?AGXfnE0E+EJiz/woZYlm/swMHlh9/T/3oKaOrHZivBE7PRD1ktnGtDWeEEUx?=
 =?us-ascii?Q?B5F+3kC4YOwrI+RQaNHVoW69b8VK4JeMdu8qEP3afhBG5TUaWvftr2DvGjmC?=
 =?us-ascii?Q?3iuAorcNCirct87/rvRJ2X1F3/1uUZfyVqtoUSRUnAZffikoFkGrRLau/Ae3?=
 =?us-ascii?Q?Gwet7WGZ0dzFrFqnFI/ZFryA72sFVviZaZdwtVAJCjoE+661uYyvpyhiBlci?=
 =?us-ascii?Q?+Xd51jWjUUrqgOaAEpQ8rP5YbU6Sn0FOqKAYqEqRrdRfYylHeGe3ds6XXi5Z?=
 =?us-ascii?Q?8uP8lXLv+gQ4I6Jww23qmUtFB5NkR8ZNXhjT5scRbnjUKJ/Th8vyf0Zviqv1?=
 =?us-ascii?Q?dwv/VHKmhQaFdYu1WJGZUS8+9NFzDPLXspXxgCHtwyMUwGrc5zt5INGOp15T?=
 =?us-ascii?Q?wqeOxwjvRr5OjKPylmC+cZOIqVsjWJLc7bGXr9Or/xYDdbZ/U32jQpKqu1W6?=
 =?us-ascii?Q?AdbF8zOki+COGhBn45cyayJcWFx9IH0jsaGr/M89r/f0vDBWWuTkM0mGClSG?=
 =?us-ascii?Q?LHb6VcTf6Kd9Ye2DyCXROYjbL5/o8fsNdU2RSuqVxVr7xJh1psFgUaTDOWet?=
 =?us-ascii?Q?aeyjddRBaGKKXb+k+9sDnti/90i0GTKI4YhFrMXuc6/osWD5FUe0BMnWfctp?=
 =?us-ascii?Q?x9cXMWnnXEY+0t6Zfcxhjg2a/QbQMO7US+uiZjr3NMhDMrMroxkB5JCyam/Z?=
 =?us-ascii?Q?P5Za7xoqEJvX9La0eV8rgv37C9UvTUi3R96toB9EK2ZlA/R7FO3Y2mwAeBvF?=
 =?us-ascii?Q?kr6NbrwYucQ6UT/ID+X7vZUIn4VwM3zmtdLvPaTJ5D/usYZ09lnXNQGeeegh?=
 =?us-ascii?Q?SS/1HWikLsb1LQvvEjvCItJ0KuyS0vtzzbRJwBB/uxbf63UPwnd08sB6/0qh?=
 =?us-ascii?Q?anLFIlxR5H99+AkkuJN/PBA0u/mGtc76b0NUR5RgjBBFWtC3m+baoeTK0X2h?=
 =?us-ascii?Q?mgEfYYwIKgTBUksVEVgYlF03p91D1adkH3jrXzieUebWkm4aDEhwrAGB62PT?=
 =?us-ascii?Q?Jg2QB3UsvQQiqpg0vpWqyGPgZEgbb3C5p20ftjWYQyyUkm0erj4u9HxuX0J8?=
 =?us-ascii?Q?ZtK6YDBQGHy5wPN7JkmIkJ9H53VLCs3oPskYgE8PVhLEFRYQ5NqbQaeUUrna?=
 =?us-ascii?Q?/UNaXzNnkcd3M+XJWoZNwL6MErJWB300iZlr5E0UBa4IOV9KELQB+H8cx7y3?=
 =?us-ascii?Q?fSN4H97m4LicFLIBOXmu9FVsIGiHu4e04d32dc48H/Pcy4sMhH769GIuKaxl?=
 =?us-ascii?Q?gNTh2xx+6kHAgUeXjSKiNgArq15Nke7Zqfc14njb5xCk+qvoIYRSmR11JC63?=
 =?us-ascii?Q?lnGoaEXQkxjo2iV0ghrBsTBw9ePqLQu0u+dfnFqDfrCiTeFU1Cxvdmtrtmrp?=
 =?us-ascii?Q?MV97DSQBX95Eb9oPRn2PKrtg5MzvjwL9pB+UIlb0GI6LppRKAvZAUkFWdWPa?=
 =?us-ascii?Q?meNl3Q=3D=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff51b77-bc7e-4719-99e3-08d9b800b24f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 15:05:38.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7uWiiNkwTYusfMOue/vAgFEL/blgLLxRQPtyjD0J5a8y05P1WDrRH8LMOSaFCCk73AjsIUv79TcLrz7m41sAlbc54tMxR2LJNZ2sPHMT1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-MDID: 1638716741-lSQom-rvbOOo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 03:49:59PM +0200, Ido Schimmel wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Sun, Dec 05, 2021 at 02:11:00PM +0200, Lahav Schlesinger wrote:
> > On Sun, Dec 05, 2021 at 11:53:03AM +0200, Ido Schimmel wrote:
> > > CAUTION: External E-Mail - Use caution with links and attachments
> > >
> > >
> > > On Thu, Dec 02, 2021 at 07:45:02PM +0200, Lahav Schlesinger wrote:
> > > > Under large scale, some routers are required to support tens of thousands
> > > > of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> > > > vrfs, etc).
> > > > At times such routers are required to delete massive amounts of devices
> > > > at once, such as when a factory reset is performed on the router (causing
> > > > a deletion of all devices), or when a configuration is restored after an
> > > > upgrade, or as a request from an operator.
> > > >
> > > > Currently there are 2 means of deleting devices using Netlink:
> > > > 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> > > > or by name using IFLA_IFNAME)
> > > > 2. Delete all device that belong to a group (using IFLA_GROUP)
> > > >
> > > > Deletion of devices one-by-one has poor performance on large scale of
> > > > devices compared to "group deletion":
> > > > After all device are handled, netdev_run_todo() is called which
> > > > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > > > registered during the deletion of the device, then wait until the
> > > > refcount of all the devices is 0, then perform final cleanups.
> > > >
> > > > However, calling rcu_barrier() is a very costly operation, each call
> > > > taking in the order of 10s of milliseconds.
> > > >
> > > > When deleting a large number of device one-by-one, rcu_barrier()
> > > > will be called for each device being deleted.
> > > > As an example, following benchmark deletes 10K loopback devices,
> > > > all of which are UP and with only IPv6 LLA being configured:
> > > >
> > > > 1. Deleting one-by-one using 1 thread : 243 seconds
> > > > 2. Deleting one-by-one using 10 thread: 70 seconds
> > > > 3. Deleting one-by-one using 50 thread: 54 seconds
> > > > 4. Deleting all using "group deletion": 30 seconds
> > > >
> > > > Note that even though the deletion logic takes place under the rtnl
> > > > lock, since the call to rcu_barrier() is outside the lock we gain
> > > > some improvements.
> > > >
> > > > But, while "group deletion" is the fastest, it is not suited for
> > > > deleting large number of arbitrary devices which are unknown a head of
> > > > time. Furthermore, moving large number of devices to a group is also a
> > > > costly operation.
> > >
> > > These are the number I get in a VM running on my laptop.
> > >
> > > Moving 16k dummy netdevs to a group:
> > >
> > > # time -p ip -b group.batch
> > > real 1.91
> > > user 0.04
> > > sys 0.27
> > >
> > > Deleting the group:
> > >
> > > # time -p ip link del group 10
> > > real 6.15
> > > user 0.00
> > > sys 3.02
> > >
> >
> > Hi Ido, in your tests in which state the dummy devices are before
> > deleting/changing group?
> > When they are DOWN I get similar numbers to yours (16k devices):
> >
> > # time ip -b group_16000_batch
> > real  0m0.640s
> > user  0m0.152s
> > sys   0m0.478s
> >
> > # time ip link delete group 100
> > real  0m5.324s
> > user  0m0.017s
> > sys   0m4.991s
> >
> > But when the devices are in state UP, I get:
> >
> > # time ip -b group_16000_batch
> > real  0m48.605s
> > user  0m0.218s
> > sys   0m48.244s
> >
> > # time ip link delete group 100
> > real  1m13.219s
> > user  0m0.010s
> > sys   1m9.117s
> >
> > And for completeness, setting the devices to DOWN prior to deleting them
> > is as fast as deleting them in the first place while they're UP.
> >
> > Also, while this is probably a minuscule issue, changing the group of
> > 10ks+ of interfaces will result in a storm of netlink events that will
> > make any userspace program listening on link events to spend time
> > handling these events.  This will result in twice as many events
> > compared to directly deleting the devices.
>
> Yes, in my setup the netdevs were down. Looking at the code, I think the
> reason for the 75x increase in latency is the fact that netlink
> notifications are not generated when the netdev is down. See
> netdev_state_change().
>
> In your specific case, it is quite useless for the kernel to generate
> 16k notifications when moving the netdevs to a group since the entire
> reason they are moved to a group is so that they could be deleted in a
> batch.
>
> I assume that there are other use cases where having the kernel suppress
> notifications can be useful. Did you consider adding such a flag to the
> request? I think such a mechanism is more generic/useful than an ad-hoc
> API to delete a list of netdevs and should allow you to utilize the
> existing group deletion mechanism.

I think having an API to suppress kernel notifications will be abused by
userspace and introduce hard-to-debug bugs, e.g. some program will
incorrectly set this flag when it shouldn't (on the premise that this
flag will "make things faster") and inadvertently break other programs
that depend on the notifications to function.

Furthermore, such ability can be used by malicious programs to hide
their activity, effectively masking themselves from Intrusion Detection
Systems that monitor these notifications.
Allowing this flag _only_ for group change can still be used maliciously,
e.g. a malicious program can covertly change the group of a device to a
"management group" (something that will usually be detected by an IDS),
and depend on a trusty program that performs bulk group operation on
said group to change some configuration of that device.

The last point might be a bit of a stretch, but I imagine there are more
creative scenarios where such flag can be maliciously used.

>
> >
> > > IMO, these numbers do not justify a new API. Also, your user space can
> > > be taught to create all the netdevs in the same group to begin with:
> > >
> > > # ip link add name dummy1 group 10 type dummy
> > > # ip link show dev dummy1
> > > 10: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group 10 qlen 1000
> > >     link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff
> > >
> > > Moreover, unlike the list API that is specific to deletion, the group
> > > API also lets you batch set operations:
> > >
> > > # ip link set group 10 mtu 2000
> > > # ip link show dev dummy1
> > > 10: dummy1: <BROADCAST,NOARP> mtu 2000 qdisc noop state DOWN mode
> > > DEFAULT group 10 qlen 1000
> > >     link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff
> >
> > The list API can be extended to support other operations as well
> > (similar to group set operations, we can call do_setlink() for each
> > device specified in an IFLA_IFINDEX).
> > I didn't implement it in this patch because we don't have a use for it
> > currently.
> >
> > >
> > > If you are using namespaces, then during "factory reset" you can delete
> > > the namespace which should trigger batch deletion of the netdevs inside
> > > it.
> > >
> >
> > In some scenarios we are required to delete only a subset of devices
> > (e.g. when a physical link becomes DOWN, we need to delete all the VLANs
> > and any tunnels configured on that device).  Furthermore, a user is
> > allowed to load a new configuration in which he deletes only some of the
> > devices (e.g. delete all of the loopbacks in the system), while not
> > touching the other devices.
> >
> > > >
> > > > This patch adds support for passing an arbitrary list of ifindex of
> > > > devices to delete with a new IFLA_IFINDEX attribute. A single message
> > > > may contain multiple instances of this attribute).
> > > > This gives a more fine-grained control over which devices to delete,
> > > > while still resulting in rcu_barrier() being called only once.
> > > > Indeed, the timings of using this new API to delete 10K devices is
> > > > the same as using the existing "group" deletion.
> > > >
> > > > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
