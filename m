Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249BE45B615
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbhKXID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:03:56 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:51854 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232944AbhKXIDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:03:55 -0500
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2021 03:03:54 EST
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A23732244A0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 07:53:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7598040088;
        Wed, 24 Nov 2021 07:53:06 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSmizu0z9X/NIpMk+3i68rol3sj3CzGJoxzTAUVZKDOjnGBKS0i/JUsAsI/SF3askzQ4nXi6jp9LB1u6oI/NsxDcfCRxg+yZZ7kXwTu333WHnqbk1TxsvCrrEbjDcGpWnpcVBzt87qnNZaJ9Zxcy+0/vQzTGb/TorRl236LldIFzdzkGTbXdCtRmhIgLxt3vP8jwS/iuex4pMcW0eYvfLvCwSobx3aUPnfczsrlsBJs/h9vieCFBG7sb4M1JTIM6Me8ObFKxzTRUY5WE4rOvhKqt2EH0jbX3t9mpR/225JDnwDF4qOs4n2eH6IG6189sfGf4J7bSA+sdgwx8SOP8tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F15Dtexwf96nKQkHY6tBlPBrc+/TNXTwvIWUDzoqUus=;
 b=mBdDeMCPQeTJsWqozQu5e3yZVgnI/J0XLuwwT+Go1eKG1jsimQjrJtNXsYrBcTuCh9VqexEEgv6Pxf/Saij65WwD6VAmjVZeVghGJ1vOHcnmbk06itpotOQSfKrkBE2I3dKNzDX0Hj8AGtNIkvpNMFYbZBwETAKcIQhCoUYW6d0FznbDweE+ojjP+RBF3BKgG0qj5p1XFzGAFol48iYcdrraW/KEWMP4anOsALnK1++6KaJB96eOb8+A3hEriZTrofZHsEA2bp8JWSIkrlS6INAlztR8Ed2IPprECEjqz9LiJKqrF2I6E7sxqeRI7dhlZq8Nf7ddTjz0d1J1iIlrHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F15Dtexwf96nKQkHY6tBlPBrc+/TNXTwvIWUDzoqUus=;
 b=Q22VcsclnyPg0PYUw5nPT1viPih6W23NhA6vZz/mCRMdALArDxBkLaICnB/kTMRDGpJHcO6T3e7ELbeIzgGMcOjrCAF3l8OtqhmPkRyYaXjUKiL1o21jry0hgEP8FjfBzOPkhagC3ZGvSR6OeONXnaQg0pM3R7aRpmkMixd4ko4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0801MB1661.eurprd08.prod.outlook.com (2603:10a6:800:56::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 07:53:04 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d%6]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 07:53:04 +0000
Date:   Wed, 24 Nov 2021 09:52:55 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] rtnetlink: Support fine-grained netdevice bulk
 deletion
Message-ID: <20211124075255.iloqmw4hrf6lv7nn@kgollan-pc>
References: <20211123123900.27425-1-lschlesinger@drivenets.com>
 <20211123200117.1c944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123200117.1c944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM3PR07CA0098.eurprd07.prod.outlook.com
 (2603:10a6:207:6::32) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (82.166.105.36) by AM3PR07CA0098.eurprd07.prod.outlook.com (2603:10a6:207:6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Wed, 24 Nov 2021 07:53:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fd5a160-43f8-4b0b-9eaa-08d9af1f71f6
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1661:
X-Microsoft-Antispam-PRVS: <VI1PR0801MB16614FB3D348DF7B5A02BDBBCC619@VI1PR0801MB1661.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUpNhVxYfFstw65ZXRMfxVECRJEs2b/U/CST+odBbcS/RZJyfo5bMmJm/2KVXKluvkI/yGKRxuxpr56qJYAb/ZLHWoqedSD0z7d8QVtEH4u2zssDU2Pcy9c4+l5lLn3MJ19w+yK77PIVtVG4nkRTB/16SqKKnzGd+Zmk7guNyhrbEP868lw913hh2DdzT4PJfu503zm4jyIRiUFtsWNEFveqBvf/Xa0me2RjzJAqhywVPBja7C6DPqEb7WAgXQpHFBaJA417C60ZJNPPrRecyA+DHCCspopC4CTFSS7YlNF2t3bAWqZdpM7Ue7nl9gQeAv9UmO7XsNl3HSTJvrJpurORI/mggN8pFpVrzCUNv2Nb7EnxTilp6OotKxtT5UVSI0JYjLtsxeAWXDGd7NVftIO5n+O0TzMZa/nBBpOB/MbyewmoRgtprd2qv+T21ZdFdoggvF2/FvJjeeqHzs4aP/ExfdVg5WRG2Gf/Y7Y2DSbdktEDoC6/s74DE/gdH+Zzvznj++3Xxan2sx90XOLIllMCGCEuOZuPE4EmAXxma46tlKeQ6EvgdwjEoc5dYk8h/0qbGtRQ25+52+6xH0di3QhHKBi0qwVmkcImhAhGBnfrJNyAmpnICHK4lADShhDlX9FoMFYfFDzEz86+US0cXB0YA3b9H497H4PdrIcetc9rBI7Wi3MZTPeDoYd3vbxJcaVfOeZwvl2DUn8O/QafnZbIflv/1q/ls2AIRET8uaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(66476007)(66946007)(66556008)(4326008)(956004)(8676002)(9686003)(316002)(26005)(6666004)(8936002)(38350700002)(2906002)(1076003)(6916009)(5660300002)(6496006)(83380400001)(52116002)(38100700002)(186003)(86362001)(33716001)(55016003)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zhcdCOUyfZGm5ydZkpeORRGkvXWHiH7CXc3YpgT9O6jJOB9ua0u9Ph5TBPXX?=
 =?us-ascii?Q?Dj4gEfFTe/hv/yC6psAnrKRrmYnV8uWAFmbmQw7inviG2Z+QjEdh9BJPMlxL?=
 =?us-ascii?Q?ylTe+0JBgdnCLE4Vpp14Yln9zoGMpOpqFTKVcFs2xe8z4ohd49V/cX856n4G?=
 =?us-ascii?Q?YQxI3c6+MCkfTJz2JoCAUH3llSw7g7+jnYLRt4gE7u9WTYWH+7Yuj396GhNO?=
 =?us-ascii?Q?2axLSm4BsNdUEP4T3RsmWJxvbmixqJCmGDd7dnCC+kuGqi+fES0Dt7udVNPh?=
 =?us-ascii?Q?yJ51XVlVgVJAGthEdbElL2dcLZXZmUGVl51GkZuChdZTlxcaPedfHs9F5c6N?=
 =?us-ascii?Q?ua3MM7n7RPvjdfHpiSxd6CNSDls5w+oWqWKyRnbeypI78eAXcr99QnR90auR?=
 =?us-ascii?Q?x3G37ObmHMVt5TQLDAtgoWmchnYhZYt7sqja5V0kMhc8u158ChYK41PAeFPR?=
 =?us-ascii?Q?k7GtC6irqcLDN26aCJqjq3TQlLgBeX+gk81p/i4zgCZOlTpgb9x8V4zaGcMY?=
 =?us-ascii?Q?hmz1N1D7VumRLlYpY/CIz7KE0NW8wBT1zRxuZfvSNv0hrZLjeOue/pklA8jx?=
 =?us-ascii?Q?H9od25hEFR4wWxFKc3jjyvdWIY3DGHxsNach9XQJB4iyvi2JraauL+4eySW7?=
 =?us-ascii?Q?vk8hrDrRkkXiiWknlemSfTEBqe1QQg7YrWF/Fca4F5B38TEevQgyoW/+GWAh?=
 =?us-ascii?Q?wHnPK1z+PUbDe6eVNjTX9E/hG2Q0n41A9lOgGXi3xQpOg46b4y+qdc6D4N73?=
 =?us-ascii?Q?VI1VQeNDQ66z4VPnolyltMT3uWHjsXVfbBnOKO8oHRG/ey5LBOmuyciIWvU/?=
 =?us-ascii?Q?w/2nwtCuv8p/t09rzzX9I9Frhd0g59yo3mIIjkOlXKJnkr2XZbIELbgzjuGL?=
 =?us-ascii?Q?8VYLbSfUs9KXLUSo+Ig61C+I9XjQ48Yx4mdiNsH/Mx0RUtN52tIyNQMdLqb4?=
 =?us-ascii?Q?vGPyZgbzKcHF7IRceh8IgBIcMza9zkm+jPDo2yL16ffzNWtwsI/V54xB50Le?=
 =?us-ascii?Q?sQWyX4MDPWWK1bHb3k3+HXk5iEryUKVdEYPL23Fj4fcNqmcCZdSM8iYm5N+m?=
 =?us-ascii?Q?fVBFUXZ6hRKP15bzwiJnGE0/6uvLR8WPGvUWGf5wwe3wLcG4Dd0FCZeAQ1Vl?=
 =?us-ascii?Q?x6P1O2lic37OiuQ8oMHhSeV4JpKhsllF1BZImIA9YXweVBJCNSSf1hPRCq1i?=
 =?us-ascii?Q?Ma3hb6UpphUzhDJG6f3b7+KDnQMiY5X0olim2M9dNoAZZV0cOnQx0W9mWyd4?=
 =?us-ascii?Q?HhXlw7zJCCekn8C7+Z13ya8s2yJaXfKL0pa4YLmbieNg+seen51lXJIcJss8?=
 =?us-ascii?Q?stpc06dwqAwlSToQ8ODb2lzLLfzyOeZstKt5MpxvZDZFO7Kxa0UesZan5g9s?=
 =?us-ascii?Q?BWl0kt03XwHhwAp0R3uBVx1KMfLEW3fM7Nk4+rBX8YzxKyPOQ7+liFF7bixQ?=
 =?us-ascii?Q?fPPHGoNatwZ3SRWXS3WncvPNOTuni7D7aI7xs71EwPoXmSmXgvNCd5CpqMAc?=
 =?us-ascii?Q?M+AA0EBhz20jZdjKEMvYaK1TTqcAbsGNlzho/yNF2tcC/2DKSRuvsSEXrebn?=
 =?us-ascii?Q?RIETU5hl7yi93e64hIj9wYEi7psuJEXWSxsFBdg7aS8jS7jlDAh8odkytBZb?=
 =?us-ascii?Q?uYLiJWsNalRWyCSGdQfi0PwEpds8cpVw18HyrA6bCA+EfGdCF3LOPCG/hd3M?=
 =?us-ascii?Q?9HFkgQ=3D=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd5a160-43f8-4b0b-9eaa-08d9af1f71f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 07:53:04.2629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+R18O5DZxUN88pVUZDmRAdcha+rqRbXFi5mcKJYOtRH+ocPSySvis+MfBsNrxU9yEz5j6pi+HZZp5XHpGiUlwL8lkrZvgqNJm/bxLJcxKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1661
X-MDID: 1637740387-m_FzK72pY-XD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 08:01:17PM -0800, Jakub Kicinski wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Tue, 23 Nov 2021 14:39:00 +0200 Lahav Schlesinger wrote:
> > Currently there are 2 means of deleting a netdevice using Netlink:
> > 1. Deleting a single netdevice (either by ifindex using
> > ifinfomsg::ifi_index, or by name using IFLA_IFNAME)
> > 2. Delete all netdevice that belong to a group (using IFLA_GROUP)
> >
> > After all netdevice are handled, netdev_run_todo() is called, which
> > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > registered during the deletion of the netdevice, then wait until the
> > refcount of all the devices is 0 and perform final cleanups.
> >
> > However, calling rcu_barrier() is a very costly operation, which takes
> > in the order of ~10ms.
> >
> > When deleting a large number of netdevice one-by-one, rcu_barrier()
> > will be called for each netdevice being deleted, causing the whole
> > operation taking a long time.
> >
> > Following results are from benchmarking deleting 10K loopback devices,
> > all of which are UP and with only IPv6 LLA being configured:
>
> What's the use case for this?

Deletion of 10K loopbacks was just as an example that uses the simplest
interface type, to show the improvments that can be made in the
rtnetlink framework, which in turn will have an effect on all interface
types.
Though I can see uses of deleting 10k loopbacks by means of doing a
"factory default" on a large server, such servers can request deleting a
large bulk of devices at once.

>
> > 1. Deleting one-by-one using 1 thread : 243 seconds
> > 2. Deleting one-by-one using 10 thread: 70 seconds
> > 3. Deleting one-by-one using 50 thread: 54 seconds
> > 4. Deleting all using "group deletion": 30 seconds
> >
> > Note that even though the deletion logic takes place under the rtnl
> > lock, since the call to rcu_barrier() is outside the lock we gain
> > improvements.
> >
> > Since "group deletion" calls rcu_barrier() only once, it is indeed the
> > fastest.
> > However, "group deletion" is too crude as means of deleting large number
> > of devices
> >
> > This patch adds support for passing an arbitrary list of ifindex of
> > netdevices to delete. This gives a more fine-grained control over
> > which devices to delete, while still resulting in only one rcu_barrier()
> > being called.
> > Indeed, the timings of using this new API to delete 10K netdevices is
> > the same as using the existing "group" deletion.
> >
> > The size constraints on the list means the API can delete at most 16382
> > netdevices in a single request.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > ---
> >  include/uapi/linux/if_link.h |  1 +
> >  net/core/rtnetlink.c         | 46 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 47 insertions(+)
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
> > index fd030e02f16d..150587b4b1a4 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> >       [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > +     [IFLA_IFINDEX_LIST]     = { .type = NLA_BINARY, .len = 65535 },
>
> Can't we leave len unset if we don't have an upper bound?

I thought it will be nicer to have an explicit upper bound instead on
counting on the implicit one from the field type.
I'll remove it in the v2.

>
> >  };
> >
> >  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > @@ -3050,6 +3051,49 @@ static int rtnl_group_dellink(const struct net *net, int group)
> >       return 0;
> >  }
> >
> > +static int rtnl_list_dellink(struct net *net, void *dev_list, int size)
> > +{
> > +     int i;
> > +     struct net_device *dev, *aux;
> > +     LIST_HEAD(list_kill);
> > +     bool found = false;
> > +
> > +     if (size < 0 || size % sizeof(int))
> > +             return -EINVAL;
> > +
> > +     for_each_netdev(net, dev) {
> > +             for (i = 0; i < size/sizeof(int); ++i) {
>
> __dev_get_by_index() should be much faster than this n^2 loop.

Right, will change in the v2.

>
> > +                     if (dev->ifindex == ((int*)dev_list)[i]) {
>
> please run checkpatch --strict on the submission

Oops, my bad

>
> > +                             const struct rtnl_link_ops *ops;
> > +
> > +                             found = true;
> > +                             ops = dev->rtnl_link_ops;
> > +                             if (!ops || !ops->dellink)
> > +                                     return -EOPNOTSUPP;
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +
> > +     if (!found)
> > +             return -ENODEV;
>
> Why is it okay to miss some of the ifindexes?

Yeah you're right, will fix it.

>
> > +     for_each_netdev_safe(net, dev, aux) {
> > +             for (i = 0; i < size/sizeof(int); ++i) {
>
> Can you not save the references while doing the previous loop?

I didn't see any improvements on the timings by saving them (even
compared to the n^2 loop on this patch), so I didn't want to introduce a
new list to struct netdevice (using unreg_list seems unfitting here as it
will collide with ops->dellink() below).

>
> > +                     if (dev->ifindex == ((int*)dev_list)[i]) {
> > +                             const struct rtnl_link_ops *ops;
> > +
> > +                             ops = dev->rtnl_link_ops;
> > +                             ops->dellink(dev, &list_kill);
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +     unregister_netdevice_many(&list_kill);
> > +
> > +     return 0;
> > +}
> > +
> >  int rtnl_delete_link(struct net_device *dev)
> >  {
> >       const struct rtnl_link_ops *ops;
> > @@ -3102,6 +3146,8 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >                                  tb[IFLA_ALT_IFNAME], NULL);
> >       else if (tb[IFLA_GROUP])
> >               err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> > +     else if (tb[IFLA_IFINDEX_LIST])
> > +             err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]), nla_len(tb[IFLA_IFINDEX_LIST]));
>
> Maybe we can allow multiple IFLA_IFINDEX instead?

One problem is that it will cut down the number of ifindex that can be
passed in a single message by half, given that each ifindex will require
its own struct nlattr.
Also, I didn't see any quick way of making __nla_validate_parse()
support saving multiple instances of the same attribute in 'tb' instead
of overwriting the last one each time, without adding extra overhead.

>
> >       else
> >               goto out;
> >
>
