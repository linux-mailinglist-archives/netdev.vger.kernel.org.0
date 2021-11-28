Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6F24605D7
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 12:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357230AbhK1LSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 06:18:46 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:40120 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235944AbhK1LQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 06:16:45 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9713D80071;
        Sun, 28 Nov 2021 11:13:27 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es31FIUeREg/W2oOmehCneC8Ja+RZVk6xh1jab/ARvtwDfBVWD/ug5sMbnvGhXc9r6JDjhKuHVmCmsmJ2Uzxv79V1B3Ut7ed2KHNI8IrxRNcdaVJ2jbnGwfJ7e8e43nHGlGxXeYKoJrpQyddqaJ/a5HYKHjCpTPMwR2W/ixHpaEGoaTBSP5ZZTTYo2gp+oj/7dbCxFmS6TlXj0M0wpywQ4M7hD3N7tDnQjiKMb3Jpb3GAW2Avg8wchfP7Tv4PTBs9VYZeTrCfd3ahQTiAUEs2tNpphoHvVn7yV2mtk/hv/C4XtZMkRIZSMUZ7dzNVJQKInIdm8VZqpMcbvcvDKCXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ym0Lzmj80KDOEzCIlENx9kQPT7TU10xhvVl6+5dlnf4=;
 b=XGyGQQSr2g7ZVLbAeiOxj/elL99pHcpymye8VWTfObwFlzVBihZXvHgoK3xhJ6LouNoM59tpdOxWz42fmE99bXxaL/ciVMQGfpyIiMArbpX90bB5hvJvz9gG0/i+nRpscyD2Rber5fCXLDnbqYOQGAjbhqxGM3cicRUwb3jyuPd0qbE+bWWsdpBVU8QYeXBa4nqwxXIZfiXPd4KrW/eCqXDOCQ6uFkH2bowwP27fiRp/I0sLDmWu1YFP7ionJbSqJxrVD4LR00OCiUvCvfXH5xSVIH9OkDmWWwIRGe8iEjFTLyDDgaGUYIcKpcXRYI6OiumoUd+RWhjSAGFbO7JvxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ym0Lzmj80KDOEzCIlENx9kQPT7TU10xhvVl6+5dlnf4=;
 b=DMRhL2UE59Xtso0z63brwihXp/dvkxwpGYfelOQwlkzVe/OlqHnAjcb0SYLUDTDhA9wYGCrXH/45OzFiFRPMrJYxHuJK9f3Ted0Lwlv4i175IrNGKzIBZ1CBZV6c4kFfZ6OL6lSgeK8KHxu9q7+Tbx5RD/C5Bz684E4hplJnrEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB3789.eurprd08.prod.outlook.com (2603:10a6:803:bd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Sun, 28 Nov
 2021 11:13:25 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%5]) with mapi id 15.20.4734.023; Sun, 28 Nov 2021
 11:13:25 +0000
Date:   Sun, 28 Nov 2021 13:13:14 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaMwrajs8D5OJ3yS@unreal>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::19) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7 via Frontend Transport; Sun, 28 Nov 2021 11:13:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2302f727-0cd1-4d49-c701-08d9b26018db
X-MS-TrafficTypeDiagnostic: VI1PR08MB3789:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3789FEA389E0A299810BC3DECC659@VI1PR08MB3789.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baBwAreCqD1G1trJAwbJA2Q7yxmt1KYn5KAtgZQTk/Hwm2XcLMDEuRhvMeJGo7KZp7jupcWN6PhfcuivLvPyPVun/b4HzOt9smIvRRqXY7ockQX7se06r7sZIuwb7U9pj/nCITus7Yb2w7mKQ1PpZkTwC4DhKGMDowfbOhvDgQ3ay4q3yJCYRDefcsDkV5zP7BWDD/K7pSTYTNCfWNfQ/FLHcFwd+jba2x0yMq8VQ2TMBNdfyOcFSPev0HpoDVjqDekdGqoPVwcSy+VC2CznSHFn+2T7eIgCb9uk7DXvTAyNLj0BvGZAyijMC2KERuW5pCS7lQwBJzBMIyJsU71mP1hJRwXreUmdRPlw8DGwoYTz0Rlko5A41KT6inH655/Xpz7GshB5nxaDiOaP014yyzcR+sXYawhFAc8O2LXOw5p3xpba/5pryF20Rax8IG7Pi1SNKtMZfz+Nmeekwvj5Mcy8iOjCinOGLzGH2LgVJtWhPTEAZdEAA5C4tbg2ggE9MdO6+YnraKxI6+jIdeYrw/i6m4pji1tcnJYlxxs4dnK4NohxhJVD3bkH4RBmSKe5SnvXIak8iSi9WerA779fa3ADycHIsUgxZO90DcuM3XIZKjpra8/iE25lLeZjlfdVUy9WpVBcqUUbEixdCGAx/r3ABDVQUI7LhD7YznsSoJlmmMqcoLUSgH/lO4De0s6/Im/9NdKHqd7h9VoENze53ZgQ32MbazL0QH/+Zzmmv+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(6496006)(66946007)(2906002)(86362001)(6666004)(66556008)(66476007)(52116002)(508600001)(9686003)(186003)(5660300002)(26005)(4326008)(316002)(33716001)(66574015)(83380400001)(8676002)(38100700002)(6916009)(8936002)(38350700002)(55016003)(1076003)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+dyKgloZkpha0NSeqaNmcJmqtZf1wHU2MQYg0fMnu2OYi/3MUhUPSeijy3ei?=
 =?us-ascii?Q?j6easiHhJVxN10YaNN9SXd87zq4PJepu09+Ctny7CC1FY8VZpXQWNA4jFtin?=
 =?us-ascii?Q?Ku6qGywPRAmxcfRwdvtxI69Y1M3CCiHWneEDA2naK3PyBZ4QNfk6D2K0sFPY?=
 =?us-ascii?Q?YmK46bp7S4X8MeGcO28I3Q9o0wlPfhrIejrzVjrYpgD15ZJy7t7EZtSM6jpc?=
 =?us-ascii?Q?2K966rneA/menRSLLsRM+ufIiG/xOsVsgj5yroK6DpzllhyZNFPFG77Ap6r+?=
 =?us-ascii?Q?EcNTMbG/Mdl6XD8g8Ap2pDVmJkVbLQShlIXJIuXnyqj2HY2xzlw/4SipYB2/?=
 =?us-ascii?Q?2yuFWQ3OLvlJfq818Q7qw+8XCkpjlRffwmZNRAx2dhcTFrQd/y1/qRUKM8HT?=
 =?us-ascii?Q?pTuIBtzv0qgVuZecb1uyOLnDgdPNPHwcAUg/bXLYhuJLJthsqFSivP7wVO+O?=
 =?us-ascii?Q?aP2FtDc6T8gfQgJ36MF56xShDSpGdKITL3sXWl6R+dwR+CLY5OYIWI8LCjBN?=
 =?us-ascii?Q?Um0cnaa7cYZ/+BcLVklbeiz+g+eADeHbHZfHRoPDOWTCYet/JoYWg8awB4dJ?=
 =?us-ascii?Q?HFf4zuhKo83S/QozmazNak27bec4PFpynZeuZz1XTmLYaKOgtrDOH/FuA5Ru?=
 =?us-ascii?Q?yCpuyF9xZ3girGWpVE2JCZo7oVa/I+0kqF88HKiAVgsmZALe9cOvv90/V3iX?=
 =?us-ascii?Q?l3IjCdK0jIvdk/5rEfXEDUe+H/ZLSlqHWVbVstbYSQWIPb0TTdmdbKh+d2JM?=
 =?us-ascii?Q?ecHN7avOZ4XD+mJV3ag9HqMkw5COu0mR4nl7t2gjOLJWVI5+9Q9H9j4AEj61?=
 =?us-ascii?Q?moCUroQ5Gd/HRB77oFakTOceCB0xU0HZl121BH5uqsMbwuxR3dUqNhPszwmL?=
 =?us-ascii?Q?a6jwfy3GZ5M34EtpUKEeCbKTn83yJUM453TKU9xX4Otv0ReIxil73QjlthyU?=
 =?us-ascii?Q?4n1/LvUgql/EdiusHPMoBKRqRYE+sitkLi8T1oC71FvXnhK7JSWr8ccZv4dr?=
 =?us-ascii?Q?9B27bb/saWA5blo/ZQhkKos7DFhFSiDwT+VVJeuYx9HcmMzQ0q8eWVWO3/cs?=
 =?us-ascii?Q?+Ttq323yR1zDmxk88vHE0j39CftyDHxGZwrb7nXpO/o0tI0iuTvecEmHEphD?=
 =?us-ascii?Q?cRs7vmG0XPqzFBkGjH1uG7hVDpjtqdje5t5KBf+OZyh+dCG021PhT3zrP9NP?=
 =?us-ascii?Q?LPO/gCL6W60eQfXbWFFUExaNm53/74UzUdsn2wFR65lkFRH+DFYDe3/qYXDR?=
 =?us-ascii?Q?FRpM7sKhGvH4xfW4XvAdzfUeu8G2w6woLZi0P3Vw9qAKCus8G8ZUN0pJCEWn?=
 =?us-ascii?Q?Jq6mIJt1pf5u4sVcxCcWsmjXw4Xay/0qgvly4PVr3m25Dpg3e5Ro4WX3lVK1?=
 =?us-ascii?Q?TjvlnIBspYbeDzIAsLgir4xZ0nF2zCaa6RlcGD/aOHEGKykZ5wHeOjMA1r+H?=
 =?us-ascii?Q?EHvycd1O5g/oOxOKTrQPj4HyMCwhgWLHuBVdr8TsgeKwxGyB+tillA/zmO68?=
 =?us-ascii?Q?fHyWsi3SY1QNCo/JZZcJznZyopE0Q0h6l/VKG952KNrs4KngCm+4plrUS4Qa?=
 =?us-ascii?Q?YLNEFz7U/PzhU4CrxLCtg4NfniaDZTLGPwft50IqJajGILsHhyJFuRZA7scr?=
 =?us-ascii?Q?CLlgXjoO8LeTuh4ZqHi9t3/i1p0PaP6qZKgBpDk+FFF0+Wfy6ez4lbcgFNYK?=
 =?us-ascii?Q?kdlOCYUJniWGcZ2mnAtcvqYNkVc=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2302f727-0cd1-4d49-c701-08d9b26018db
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2021 11:13:25.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4/KbDW3A4wz44hlDomDOA5gc44wAYJ4JCyIe/O1fRiQr8OI52O+/fgYA7FQS/tOn9/0VVbBoQcko+kNwdUzbJETuzeRgVaUUCIp59Vo4fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3789
X-MDID: 1638098008-EjiaU2BPWH1z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 09:33:01AM +0200, Leon Romanovsky wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Thu, Nov 25, 2021 at 06:51:46PM +0200, Lahav Schlesinger wrote:
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
> >
> > This patch adds support for passing an arbitrary list of ifindex of
> > devices to delete with a new IFLA_IFINDEX_LIST attribute.
> > This gives a more fine-grained control over which devices to delete,
> > while still resulting in rcu_barrier() being called only once.
> > Indeed, the timings of using this new API to delete 10K devices is
> > the same as using the existing "group" deletion.
> >
> > The size constraints on the attribute means the API can delete at most
> > 16382 devices in a single request.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > ---
> > v2 -> v3
> >  - Rename 'ifindex_list' to 'ifindices', and pass it as int*
> >  - Clamp 'ops' variable in second loop.
> >
> > v1 -> v2
> >  - Unset 'len' of IFLA_IFINDEX_LIST in policy.
> >  - Use __dev_get_by_index() instead of n^2 loop.
> >  - Return -ENODEV if any ifindex is not present.
> >  - Saved devices in an array.
> >  - Fix formatting.
> >
> >  include/uapi/linux/if_link.h |  1 +
> >  net/core/rtnetlink.c         | 50 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 51 insertions(+)
> >
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index eebd3894fe89..f950bf6ed025 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -348,6 +348,7 @@ enum {
> >       IFLA_PARENT_DEV_NAME,
> >       IFLA_PARENT_DEV_BUS_NAME,
> >
> > +     IFLA_IFINDEX_LIST,
> >       __IFLA_MAX
> >  };
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index fd030e02f16d..49d1a3954a01 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> >       [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > +     [IFLA_IFINDEX_LIST]     = { .type = NLA_BINARY },
> >  };
> >
> >  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > @@ -3050,6 +3051,52 @@ static int rtnl_group_dellink(const struct net *net, int group)
> >       return 0;
> >  }
> >
> > +static int rtnl_list_dellink(struct net *net, int *ifindices, int size)
> > +{
> > +     const int num_devices = size / sizeof(int);
> > +     struct net_device **dev_list;
> > +     LIST_HEAD(list_kill);
> > +     int i, ret;
> > +
> > +     if (size <= 0 || size % sizeof(int))
> > +             return -EINVAL;
> > +
> > +     dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> > +     if (!dev_list)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < num_devices; i++) {
> > +             const struct rtnl_link_ops *ops;
> > +             struct net_device *dev;
> > +
> > +             ret = -ENODEV;
> > +             dev = __dev_get_by_index(net, ifindices[i]);
> > +             if (!dev)
> > +                     goto out_free;
> > +
> > +             ret = -EOPNOTSUPP;
> > +             ops = dev->rtnl_link_ops;
> > +             if (!ops || !ops->dellink)
> > +                     goto out_free;
>
> I'm just curious, how does user know that specific device doesn't
> have ->delink implementation? It is important to know because you
> are failing whole batch deletion. At least for single delink, users
> have chance to skip "failed" one and continue.
>
> Thanks

Hi Leon, I don't see any immediate way users can get this information.
I do think that failing the whole request is better than silently
ignoring such devices.

Perhaps an alternative is to return the unsupported device's name in an
extack? To make NL_SET_ERR_MSG() support string formatting this will
require changing netlink_ext_ack::_msg to be an array though (skimming
over the calls to NL_SET_ERR_MSG(), a buffer of size say 128 should be
large enough).

>
> > +
> > +             dev_list[i] = dev;
> > +     }
> > +
> > +     for (i = 0; i < num_devices; i++) {
> > +             struct net_device *dev = dev_list[i];
> > +
> > +             dev->rtnl_link_ops->dellink(dev, &list_kill);
> > +     }
> > +
> > +     unregister_netdevice_many(&list_kill);
> > +
> > +     ret = 0;
> > +
> > +out_free:
> > +     kfree(dev_list);
> > +     return ret;
> > +}
> > +
> >  int rtnl_delete_link(struct net_device *dev)
> >  {
> >       const struct rtnl_link_ops *ops;
> > @@ -3102,6 +3149,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >                                  tb[IFLA_ALT_IFNAME], NULL);
> >       else if (tb[IFLA_GROUP])
> >               err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> > +     else if (tb[IFLA_IFINDEX_LIST])
> > +             err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
> > +                                     nla_len(tb[IFLA_IFINDEX_LIST]));
> >       else
> >               goto out;
> >
> > --
> > 2.25.1
> >
