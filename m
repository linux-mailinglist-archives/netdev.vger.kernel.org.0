Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA63A468AB9
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 13:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhLEMOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 07:14:39 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:47618 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233585AbhLEMOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 07:14:38 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F0DC780071;
        Sun,  5 Dec 2021 12:11:08 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fcx9u0x5+Hx5zLZ0zLdvIt69vmgZmaDVzlyjstAExvuzmQZnrAiyzFK/7lT99QyEuFXNxQithDWmkF0HdBjQTWay4Gs6dTznNTmq8BIctwbX6LX+p7hguhDNooS6rWPRmEcx8VqxeUuU4Aa8MmoURtK5kh9DrMA46Hl0i7gUS1S1lvleSt807XH2HY8X2lbclnLBkzse9eRyewwT1gVPOEaUnWdXcIdKQkYgyBM8p4ACB4vu2UibHbr/n7ko7KhLGtX8e0NJ5A6pS1CypnY4O2LT1WbTxhTZgj+d2XgnMmvcMiVRBczVte1XgkP5qqmVq4AMBT7AWyYg2Bw12HwKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEmSMMs3qajC29DoiD4SP0OkNtPnpCCQZo3r04L4RF8=;
 b=e9OUIXQxd0tyABR9nlthw69PfKWLjhSgr0vcZL6OUnp64RHxCOuhcUN+yQv8wRTPCkoMuP5adUmk1rywRq+49Yhq815KeY1op/E+WNNPxMYVDjFHsS/UVceH377Gwq8DzZ5ApQvaw5OVpSYpGz3HuIgqsu4kYDyVopipGKQM6rmZ4t2ViO5bygzXQ/oT9Wgpa9uwduRu1y7/GBess2g4cLRC3U9L6G7VzZjKIs3Ur8okJssx6ohBKQWJsGd5epO49KKI/A6Sn5lbzsb4IyjigaLEhb49838ISr8aYF3vp7AEuAxcKYj2hAf3J99QE6VoHJoLWL6srdc7a7qY9B1jZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEmSMMs3qajC29DoiD4SP0OkNtPnpCCQZo3r04L4RF8=;
 b=HN2yDv9iqPWfsbca+/paPEr6uBsHx8ul2UqkiQRuEadYVxXg0C0l9tXlzOLBWwf6R3K4F6wKmGzWKbgColQMMeLhmWmSbTbdnH28yz4Edi026Oo6eaMkMIK5E0RJ2Bd/gpOPqFQs3bmbICmKF+NNHXXp5ikMNIz/U/S3I4aXULA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VE1PR08MB5726.eurprd08.prod.outlook.com (2603:10a6:800:1b2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14; Sun, 5 Dec
 2021 12:11:06 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.021; Sun, 5 Dec 2021
 12:11:06 +0000
Date:   Sun, 5 Dec 2021 14:11:00 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211205121059.btshgxt7s7hfnmtr@kgollan-pc>
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <YayL/7d/hm3TYjtV@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YayL/7d/hm3TYjtV@shredder>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM0PR04CA0051.eurprd04.prod.outlook.com
 (2603:10a6:208:1::28) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by AM0PR04CA0051.eurprd04.prod.outlook.com (2603:10a6:208:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sun, 5 Dec 2021 12:11:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bb8627f-fffa-45c5-1a79-08d9b7e8505e
X-MS-TrafficTypeDiagnostic: VE1PR08MB5726:
X-Microsoft-Antispam-PRVS: <VE1PR08MB572608F874ED433B9446B69DCC6C9@VE1PR08MB5726.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tviv9PgphKtiv+yH4jcpODHA2xBMOrqZOTqvZQbeXfe+B6vzq9a9icWtnPzaeM4BqoCIXBo0QPWWDNpnYa1IBq4L8m3F9FUgMv55hvMtcCmyTtpJXOMdOo1s+gx9CRrUvfBDoAXTWLWjsm7yPUH+I7iiiq045rCyKCdxNpks9ouyPIL7wTDl0pdto2PZy2EUE580xJ2X06gnjKVxz6akpVvITibAMaRXGVG1kBkzzRAYhVRPFboPDD+gNwMIGYYQYLEoT5KQX4YVDmdzR46hI6HD7JjH+TqmNWvaWwM7PAkkdNvn6sQ3BFPqFOnoPGzJ4uRRmdhiAn6N3aERt4VIl7+4R20l893SiQNJWA17O7WWTKB5I497RFnlj6sUYGASppWT33xvCJP65sa0Owri+yfBV9dRsTO7hsEVbEk9IDYA7GlpnT0h0k0jjetB2JpC8kgt5qLhr5x/DyGsBAfOtm3ufLzAFaACYTdDdiglKqgq9mSQqXUzZ5cPlQjENB0jdDz7nWeDOdkVkrVgAeOUhqk1faeFRZFSBvwlShrv/s9GWenuKoyAXi3FRHFFmF76YgwYMQ+QcLusOqw5IeBZoYWC7QlOamtnyVl8VTIuHyPikceM31QiPrToA4WrPVhtHOHjVGlGt0j/3QCr9yBZTbQi7wuGLjpYAV8TmKB3hgCM3E0RllQl9Q53UOsv4a8KtBABdizb3SZSJXXszPOXA765iQvd1qHu0LxrIBL/DfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33716001)(38350700002)(2906002)(4326008)(38100700002)(6666004)(9686003)(86362001)(316002)(8936002)(5660300002)(83380400001)(6496006)(55016003)(6916009)(186003)(26005)(66556008)(1076003)(8676002)(52116002)(508600001)(66946007)(956004)(66476007)(66574015)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TDJuDrYVVb1Cwl4HOXqGr6xwACUjNh9/6w/pu5hnPY/pzAOScCGii2R/edsK?=
 =?us-ascii?Q?bpaBbxUIEKmUcQYL+Svmis/V02t9icpwvVcIpY6InXsLQrD6NP5cYnUyhwK5?=
 =?us-ascii?Q?f7qqICfreH+zEVlOGSjG5T6TEFH+LM1TJboiC0szqMVtcYrHoxfhpMoAL8q6?=
 =?us-ascii?Q?ObdS1JtaMhde499o+cBO+aU/gvvcdTq9aKmkZeQhx6H/FfocG1zwYStJ/gdv?=
 =?us-ascii?Q?5vY4o+wCeC0UTLgvu3ir0qB2a1mikrIwbu5OJ8Ph8eJ6DsuMbnTqCcI0QLWM?=
 =?us-ascii?Q?o7vezCH7wZzGmewpR0NpmL80aolpW8xXvg2xyqnRO3Yc3r3Dpr52up8S2i4S?=
 =?us-ascii?Q?clz49d6crxC5aGcfljhNY2T+hCkCIG54cv9NAN57c2eV8ZjPZcbmeUEVYG2x?=
 =?us-ascii?Q?9PBINizLhNJF8WRbeC0G8lIcIHXi41sYQ11z19QuyCrXsszDo5xq7C8feMN9?=
 =?us-ascii?Q?nJbbG5Ye+ytAkuLCjTN8fOJ0O7tTJZu/HrJAsVFwlYU0sOFaa9hJEj+Pllst?=
 =?us-ascii?Q?cN/FNFOn/XNSbYMsKssxPjcDeoB+vkmcmGGH/Jj/o3MMfGstI2YXC8qF7853?=
 =?us-ascii?Q?XV+bQZzEexUWqLRmVAAfegb8tWmtVBqFN7IS5ryn4pNgBRVzfUbpP9dMdc8U?=
 =?us-ascii?Q?t8WZOnqYTXhd7iuumalHeeYsm8ZEApiSZKJic+A4rrOi3Y6W/p5YK37dleNb?=
 =?us-ascii?Q?VGpJacDQ/w9yQ7lnfaZxxLjjQ6R5e9E0Qd0r1f8ZTL8J9pLYJP8Rkkvt2vyt?=
 =?us-ascii?Q?3KBn4at9Wkr2SotV7AaR0OAG3d6sA/d72mrPc9fnUFTl/3t0BpiCUg7REz2e?=
 =?us-ascii?Q?djGTs70/0/PqaT4YlzK4DwZQTdJvK1vzApVsFaeIkRO+kS5zyID+QMcQxVyF?=
 =?us-ascii?Q?c2ocge74o8gPLL+bzeXr5xEyHfXp7pU7fdNahWz1+XnYRuzbRUR4WBlXKSVK?=
 =?us-ascii?Q?C0iRJmgHrmI1isTRvUqlkEOSuhcgyBLyO5CeJRhbOC2MXwAduOxDOF8Zwbgl?=
 =?us-ascii?Q?1DNX/GgegYmPZivTuPSgEG+S7IcbkbTMCtiPdlVZtd32/q5axCqi/SrCvPrf?=
 =?us-ascii?Q?D5YGo0G83REAAjY3Skiv66/oTIpUOsAVVBvvLL67ybcEvXpAgI42Ww/IIV9U?=
 =?us-ascii?Q?sBcEBpCOt/pKA6J6qkOEhPoZbyJL3CPqkLv8Cquu9sMvS7ede3tIeou7Fa81?=
 =?us-ascii?Q?4L2Dbyd7KgjhdrvPCn3s53KS4cxPKpMCfhdJ64iR6N6CISD02kTTtQnrO3ZC?=
 =?us-ascii?Q?IoSEM070UnbE3pv8dY0BRgsY6lwZs8hMOWnPGPhASgMVoLtAyMzbmA677Sfp?=
 =?us-ascii?Q?CtlxEGlzKz22c4RY0f9ygmERudewad2iTiB1U0kE2RFegTE2mI8Hn2FnZbLk?=
 =?us-ascii?Q?Q1MdfQyDKC1sp7K0Sgbxkz07W21EBofLiaRvu+uJ3xENf2GlLjVlINfrD9oF?=
 =?us-ascii?Q?mPr2SM8RV6figrPx8IeZj998pSVDvx31CHqTxUjyHIRECrdNvfP2pAQKtK0E?=
 =?us-ascii?Q?ilzfRNonQwj0KzvwlvuYU3oBzIuwU7YLQT8vgmhSevEuR7lVoGvMmrLD4XFE?=
 =?us-ascii?Q?eCpGiCt7UX9K9EhCBz34iH2CB1pWi7456NqaBG4EnoVbgJg7tmbtHEL0OI7n?=
 =?us-ascii?Q?EecVIJujJ6ZJXD2ItMKkGoXAuMl3W+ZcXNkc8UbJWtSFBVFCSs7xKvjpS/wh?=
 =?us-ascii?Q?qfrWsGj7IvVf7cocia9bMAJjpHg=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb8627f-fffa-45c5-1a79-08d9b7e8505e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 12:11:05.9275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REO5acaMyOcHwF0D2I8um35UYJSKP1K64nbWJJ6aKqzaH2XnY4WQuDkbWSl9RPTxXLObr2O3sGwpQw50GpbO15TZWzCyOoflPwfaOvF7Al8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5726
X-MDID: 1638706269-jYk4AFd-h2Kt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 11:53:03AM +0200, Ido Schimmel wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Thu, Dec 02, 2021 at 07:45:02PM +0200, Lahav Schlesinger wrote:
> > Under large scale, some routers are required to support tens of thousands
> > of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> > vrfs, etc).
> > At times such routers are required to delete massive amounts of devices
> > at once, such as when a factory reset is performed on the router (causing
> > a deletion of all devices), or when a configuration is restored after an
> > upgrade, or as a request from an operator.
> >
> > Currently there are 2 means of deleting devices using Netlink:
> > 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> > or by name using IFLA_IFNAME)
> > 2. Delete all device that belong to a group (using IFLA_GROUP)
> >
> > Deletion of devices one-by-one has poor performance on large scale of
> > devices compared to "group deletion":
> > After all device are handled, netdev_run_todo() is called which
> > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > registered during the deletion of the device, then wait until the
> > refcount of all the devices is 0, then perform final cleanups.
> >
> > However, calling rcu_barrier() is a very costly operation, each call
> > taking in the order of 10s of milliseconds.
> >
> > When deleting a large number of device one-by-one, rcu_barrier()
> > will be called for each device being deleted.
> > As an example, following benchmark deletes 10K loopback devices,
> > all of which are UP and with only IPv6 LLA being configured:
> >
> > 1. Deleting one-by-one using 1 thread : 243 seconds
> > 2. Deleting one-by-one using 10 thread: 70 seconds
> > 3. Deleting one-by-one using 50 thread: 54 seconds
> > 4. Deleting all using "group deletion": 30 seconds
> >
> > Note that even though the deletion logic takes place under the rtnl
> > lock, since the call to rcu_barrier() is outside the lock we gain
> > some improvements.
> >
> > But, while "group deletion" is the fastest, it is not suited for
> > deleting large number of arbitrary devices which are unknown a head of
> > time. Furthermore, moving large number of devices to a group is also a
> > costly operation.
>
> These are the number I get in a VM running on my laptop.
>
> Moving 16k dummy netdevs to a group:
>
> # time -p ip -b group.batch
> real 1.91
> user 0.04
> sys 0.27
>
> Deleting the group:
>
> # time -p ip link del group 10
> real 6.15
> user 0.00
> sys 3.02
>

Hi Ido, in your tests in which state the dummy devices are before
deleting/changing group?
When they are DOWN I get similar numbers to yours (16k devices):

# time ip -b group_16000_batch
real	0m0.640s
user	0m0.152s
sys	0m0.478s

# time ip link delete group 100
real	0m5.324s
user	0m0.017s
sys	0m4.991s

But when the devices are in state UP, I get:

# time ip -b group_16000_batch
real	0m48.605s
user	0m0.218s
sys	0m48.244s

# time ip link delete group 100
real	1m13.219s
user	0m0.010s
sys	1m9.117s

And for completeness, setting the devices to DOWN prior to deleting them
is as fast as deleting them in the first place while they're UP.

Also, while this is probably a minuscule issue, changing the group of
10ks+ of interfaces will result in a storm of netlink events that will
make any userspace program listening on link events to spend time
handling these events.  This will result in twice as many events
compared to directly deleting the devices.

> IMO, these numbers do not justify a new API. Also, your user space can
> be taught to create all the netdevs in the same group to begin with:
>
> # ip link add name dummy1 group 10 type dummy
> # ip link show dev dummy1
> 10: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group 10 qlen 1000
>     link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff
>
> Moreover, unlike the list API that is specific to deletion, the group
> API also lets you batch set operations:
>
> # ip link set group 10 mtu 2000
> # ip link show dev dummy1
> 10: dummy1: <BROADCAST,NOARP> mtu 2000 qdisc noop state DOWN mode
> DEFAULT group 10 qlen 1000
>     link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff

The list API can be extended to support other operations as well
(similar to group set operations, we can call do_setlink() for each
device specified in an IFLA_IFINDEX).
I didn't implement it in this patch because we don't have a use for it
currently.

>
> If you are using namespaces, then during "factory reset" you can delete
> the namespace which should trigger batch deletion of the netdevs inside
> it.
>

In some scenarios we are required to delete only a subset of devices
(e.g. when a physical link becomes DOWN, we need to delete all the VLANs
and any tunnels configured on that device).  Furthermore, a user is
allowed to load a new configuration in which he deletes only some of the
devices (e.g. delete all of the loopbacks in the system), while not
touching the other devices.

> >
> > This patch adds support for passing an arbitrary list of ifindex of
> > devices to delete with a new IFLA_IFINDEX attribute. A single message
> > may contain multiple instances of this attribute).
> > This gives a more fine-grained control over which devices to delete,
> > while still resulting in rcu_barrier() being called only once.
> > Indeed, the timings of using this new API to delete 10K devices is
> > the same as using the existing "group" deletion.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
