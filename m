Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE1E484960
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiADUk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:40:58 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:59006 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbiADUk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 15:40:57 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2058.outbound.protection.outlook.com [104.47.0.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 628C54C0061;
        Tue,  4 Jan 2022 20:40:54 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERrCeRpMe2itE8oDOrAkjbVqouyrqnujnYBgrgbKZJlH3Kq0haU0pjXV7z9gguqzKrnQcML2Xi1DmSSDV70KFLp+nnqTUOwsyptgINsQp5/DlwWA+rmdZksheGeEs0xZAPe6HdsKEy4bDDfM2sD9fMVjR43pQL0B+MlCfyewYy/EAGCIwsSO/1ubQyWP2xq0kgxZ0jM/wGweCkQ5ocBIvhS9SoWJfSuHGAmdinJpFVlXmMJT4sNbdk1uEADwve7ZK+SyVZdrSi8KMgDBxLwJzB6NcTnWOm106v1GI0CYEj/QNBgM0CsQ55WeamxxMaLODYAbINkm5Col15o2/1YcKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxwNsGoOrNPi3Sm5QvdrCAvSG7VMZ29nUmP01hFI8Fs=;
 b=UM2h246nziIVYxJwdext2H4HRMyYCOSKd/VPb/WY3lrav9HxcG9k39aAIgQEWmYbMkXpg9vQF1Latl9Kt7FmojZ66RohvpEGzEm7yrqe2jr9dFTZ9VvXjosBxcAp72jFIoaC/P7e6WR8Pz/DZIhGL4jeyXH52VlwhmPfzIgOnSbtqm+/pCBNkjE233zTyV9PQH/4bRsN73jCA86EvCf2OJJ+Ih+1jerYaUD4YLctrflN0xzWKBEVwP36ILzwPbHoiMhvxyQ8IMSFRIn5sMFVutzAXG6nEY8sIvKs3oBMCx8PBWoUu3T0i2ZK6VDokAYKp6fpzk8ZE0prgi9b8q5wgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxwNsGoOrNPi3Sm5QvdrCAvSG7VMZ29nUmP01hFI8Fs=;
 b=HiQ1Myfz/GzsKCOqPGDHMT8HvbKznulHYSnVG3ivVcRTf9QeMsk1y4uB3QdMIRLp/slxLtTrvgp8FeyvALN+boXOrVNLj31GTB6y4taOTAQwVu/I9Urm/NgJcV+ZB9Wlm9S4FaPSw64dZYH1x5M8L3WSKtmcE5ygKKQziCQzohc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0801MB1981.eurprd08.prod.outlook.com (2603:10a6:800:89::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 20:40:51 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 20:40:51 +0000
Date:   Tue, 4 Jan 2022 22:40:43 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, kuba@kernel.org,
        idosch@idosch.org, nicolas.dichtel@6wind.com, nikolay@nvidia.com
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20220104204033.rq4467r3kaaowczj@kgollan-pc>
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
 <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM0PR06CA0081.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::22) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b4a9c8-1eda-4689-60b9-08d9cfc27f25
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1981:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0801MB19811BE356BE9CAC3F65E125CC4A9@VI1PR0801MB1981.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:47;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCWUHSsT5KpdrQSH0vUsrRrvV/UI8Te+NKfRSf0av+Ga/t4f2H0JJ5E4ZKZEJIG7Ze8QuX6gdBBlJSxkcSpojtLZkhusCM8jYUgMrKS9VILuP73SPR7UPrJzCVocGgZTPX4tWBDY6p2eohvsq8mJ8yU5SNxYQ025qqbi9Yfj6b0zAqxV8s8JXy4+2kBMNL58xfQaxDxpPKxoD8crns6DwVDZEARZJIfTu32p59Y5y6Q6Z9SIsmw18sQnwzQRLuEPKobtc3FCeRsln3LKsGtc9+0e9m4eU8Z0bl8BEsuCdfqWtJg5Ar/A3Hv+ABWb1UyDUIsAS4lpGxTY135klMm2xR/dwpI/Rq7ohhtw7L41xyeCEOJ3Poppmj2l72yQntQn0s94eF+i9flua+HOzRna1C569xu/ydTiwqXSNLhmpMWhITpCheQ45uQhX/Tg9bLByXyuq2t5jAW1rD++rTe20ucEH+AElH00GO0htGQZUScI7oX/oxR3aRy+h5PWL++fiAM89S5q6Cw0TOKfC7DZ09gCe3hviBTLrP1jiKx179ExoAxNijt5ynaaGJtnaHXHoebuTAXqIl8+hJlp0lG33tP9z/YLejlD2UH19BVdcCl4BZhHrEwYcUDPKiVou0mUJSu/owvN+6yBFUXAB3tz1IjENNIIbckd0WhrbD9K31awifj62nnu1nstNpOxFJUIVuNPHzvsyGcSMVtOVJiQwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(66574015)(6512007)(508600001)(2906002)(186003)(38350700002)(6916009)(66556008)(4326008)(66946007)(52116002)(9686003)(38100700002)(83380400001)(6486002)(1076003)(53546011)(30864003)(316002)(5660300002)(6506007)(8676002)(66476007)(6666004)(86362001)(26005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QAHQFbXnOFSmu7/EkDGwCL6gc4OifgQ4y5B9lZumZIxWqQMsTrUUkpNwijal?=
 =?us-ascii?Q?u9BND2Wb9uQJ3xaW/UHd/GNwYWSDRNPhYymN10DVw0yhjrrv6eRtIr2wGgvW?=
 =?us-ascii?Q?h+4yjwfxMEfpwzAV3QwVVSIZ6LGw6ljP0M1bkuTUOiS8Py23fyTVDBy8OcPU?=
 =?us-ascii?Q?5/ArFV86AUahRWdM+9iU00qzfJA3evW76ktree1RkqZSSYQiJLT2qwTM1ZIJ?=
 =?us-ascii?Q?9pMb5Zsxbxv7cAMTzcMuKDMx5Rg/aBoIRNIvaxXVTDOKRxZsoPSKb/t57vcA?=
 =?us-ascii?Q?85uXlrzxn0w2bLOXuTs0tDxxQ+plyDravEb4rDzg1r8yqTRj0Ey9GE1/jhvL?=
 =?us-ascii?Q?J0C3OuumtcNZ6H9AB/bfaIsz4XZwvHrOyErAUFRnPvWalqj5KZSQFQ34+gmI?=
 =?us-ascii?Q?b5EA6ww4E3lmIj3Drg7DtNxvofcXUFjVADVApc4Y+3zKOefZTM0P6T0ck9Ow?=
 =?us-ascii?Q?skUvH1hUvBqsCrYzyNLq41rU/1Cs3W9SIYHCnlVxhd61qvuqgUZQvhiNmFPX?=
 =?us-ascii?Q?lyLQTw3S9slwy0CvPt7Ue4azHXo5v2Ruzczi69kYZRzUhdfJbCMJu2wP4y8F?=
 =?us-ascii?Q?cQlbfAx0ZZM7BnNtt9DU5g/AvaFuKj+0p8gb+hudw9EkGcp7cNR7xllR8yMe?=
 =?us-ascii?Q?xt19Ofg35wMnFh064HuCokzIcwNj4r5VBSdrS3vpBugSIhansytFMwAhR7zp?=
 =?us-ascii?Q?al+zhTLL7PM8c+7tvNFr5fPcBoglsOvGYdtUAKvRQ+g+ClbqeRnxxW5sC44j?=
 =?us-ascii?Q?xGqIOWtnqm7SOLL9HJck4KMyEjI7UuvHzyMYC7NYmFG/wXc8vBZt+ARoyhUB?=
 =?us-ascii?Q?PwpssRsgz9iQO280odW6JQd3B9x9EouRf//wjK/h5paAuSoxFF/SeJhpa8pg?=
 =?us-ascii?Q?iOdYCOK2coMYzVu9bNuurNNePE1OySxm+8e2X11cMGadTMvA0pKiyr+V+egv?=
 =?us-ascii?Q?+CUhHk/LXpgnqYA4a2V71Y6MQJU7uBu/dT38mNodV/EA+qxpO8WlbPIgpCO9?=
 =?us-ascii?Q?whA2IMOHwVBOylgTOXtVneYreSTE2Ndo5vuCTMY0GMNo/n1YDMpqyv1MxhcG?=
 =?us-ascii?Q?xL5g9AYeoNlh78DumMlG+oU9MdzasLpDOYJ5NtMa6rNIF3Ba5wt3JRKdkoZI?=
 =?us-ascii?Q?wRg07l5/RrY/D31GjkdYg7pz8lrNVOFnop3drPePKNzodMyrXwC5HX16zqtG?=
 =?us-ascii?Q?F+vShucqZ0oYh/Nq3nvBy0VS95wizlXRZHbOay5wMrx6+2L/9rE62iMmB98X?=
 =?us-ascii?Q?tBg1TOet4BIt+DY8E4wTGLkHIZOhHWhQ4qeIB150yM2Q33bk7JVCwhE9PyJY?=
 =?us-ascii?Q?F5EZbFI2BoeU2jLqIaOQ3AXjvjrXN9XGshglXbP98Gw+tBaz8sFUCPD9Oetd?=
 =?us-ascii?Q?W4+uXMxviz8G1nzmzzfnp4+gaZBKmeBLm8lLtesgkZnPyRlr8wF+f6WT9HFb?=
 =?us-ascii?Q?GbhBa+c/DLCMq5MMppsLhLOKF4AacXzumtA7yalGpxC0vFdahuiI/RX5vVIt?=
 =?us-ascii?Q?pBD2T7O0c8+eGbBZsC7WdST43o/XOqA9yHW8Zz87f6cQuPS12veqeAr65Qgy?=
 =?us-ascii?Q?+9qtrk95DEGKI0aU1MN6Thl7nodOHbixaxyWsi1v+McZeThTiEtDXCiX5Jcc?=
 =?us-ascii?Q?y88b+yKImBGMpFReYmVO9XCM5Xc8gTv4DDhPJCPv42pJQXtsJ5cjd0DJ96PO?=
 =?us-ascii?Q?OLtqIwcjJkD7Ll1+bw4Uu1Zdp4M=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b4a9c8-1eda-4689-60b9-08d9cfc27f25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 20:40:51.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttQyQ7MAND6AXkrdidyss1Bdzxm82z9LWqmCZlNRfYINrBN5avsZcYVUEoMFTyfLjGUiAu3qdVOj81tydjmq7rj/8j386SE13QiKir4SyAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1981
X-MDID: 1641328855-hS8RIXjoyPCD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 06:32:31AM -0800, Eric Dumazet wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 1/4/22 00:10, Lahav Schlesinger wrote:
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
> > devices to delete with a new IFLA_IFINDEX attribute. A single message
> > may contain multiple instances of this attribute).
> > This gives a more fine-grained control over which devices to delete,
> > while still resulting in rcu_barrier() being called only once.
> > Indeed, the timings of using this new API to delete 10K devices is
> > the same as using the existing "group" deletion.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > ---
> > v5 -> v6
> >   - Convert back to single IFLA_IFINDEX_LIST attribute instead of
> >     IFLA_IFINDEX
> >   - Added struct net_device::bulk_delete to avoid sorting ifindex list,
> >     in order to call ->dellink() only once per potentially duplicated ifindex
> >     (no increase in struct size)
> >   - Make sure IFLA_IFINDEX_LIST cannot be used in
> >     setlink()/newlink()/getlink()
> >
> > v4 -> v5
> >   - Don't call ->dellink() multiple times if device is duplicated.
> >
> > v3 -> v4
> >   - Change single IFLA_INDEX_LIST into multiple IFLA_IFINDEX
> >   - Fail if passing both IFLA_GROUP and at least one IFLA_IFNEX
> >
> > v2 -> v3
> >   - Rename 'ifindex_list' to 'ifindices', and pass it as int*
> >   - Clamp 'ops' variable in second loop.
> >
> > v1 -> v2
> >   - Unset 'len' of IFLA_IFINDEX_LIST in policy.
> >   - Use __dev_get_by_index() instead of n^2 loop.
> >   - Return -ENODEV if any ifindex is not present.
> >   - Saved devices in an array.
> >   - Fix formatting.
> >
> >   include/linux/netdevice.h    |  3 ++
> >   include/uapi/linux/if_link.h |  1 +
> >   net/core/rtnetlink.c         | 77 ++++++++++++++++++++++++++++++++++++
> >   3 files changed, 81 insertions(+)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index df049864661d..c3cfbfaf7f06 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1926,6 +1926,8 @@ enum netdev_ml_priv_type {
> >    *
> >    *  @threaded:      napi threaded mode is enabled
> >    *
> > + *   @bulk_delete:   Device is marked for of bulk deletion
> > + *
> >    *  @net_notifier_list:     List of per-net netdev notifier block
> >    *                          that follow this device when it is moved
> >    *                          to another network namespace.
> > @@ -2258,6 +2260,7 @@ struct net_device {
> >       bool                    proto_down;
> >       unsigned                wol_enabled:1;
> >       unsigned                threaded:1;
> > +     unsigned                bulk_delete:1;
> >
> >       struct list_head        net_notifier_list;
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
> >   };
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index fd030e02f16d..530371767565 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> >       [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > +     [IFLA_IFINDEX_LIST]     = { .type = NLA_BINARY },
> >   };
> >
> >   static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > @@ -3009,6 +3010,11 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >               goto errout;
> >       }
> >
> > +     if (tb[IFLA_IFINDEX_LIST]) {
> > +             NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in setlink");
> > +             goto errout;
> > +     }
> > +
> >       err = do_setlink(skb, dev, ifm, extack, tb, ifname, 0);
> >   errout:
> >       return err;
> > @@ -3050,6 +3056,57 @@ static int rtnl_group_dellink(const struct net *net, int group)
> >       return 0;
> >   }
> >
> > +static int rtnl_list_dellink(struct net *net, int *ifindices, int size,
> > +                          struct netlink_ext_ack *extack)
> > +{
> > +     const int num_devices = size / sizeof(int);
> > +     struct net_device *dev;
> > +     LIST_HEAD(list_kill);
> > +     int i, j, ret;
> > +
> > +     if (size <= 0 || size % sizeof(int))
> > +             return -EINVAL;
> > +
> > +     for (i = 0; i < num_devices; i++) {
> > +             const struct rtnl_link_ops *ops;
> > +
> > +             ret = -ENODEV;
> > +             dev = __dev_get_by_index(net, ifindices[i]);
>
>
> What happens if one device is present multiple times in ifindices[] ?
>
> This should be an error.

Right, I'll add a check.

>
>
> > +             if (!dev) {
> > +                     NL_SET_ERR_MSG(extack, "Unknown ifindex");
> > +                     goto cleanup;
> > +             }
> > +
> > +             ret = -EOPNOTSUPP;
> > +             ops = dev->rtnl_link_ops;
> > +             if (!ops || !ops->dellink) {
> > +                     NL_SET_ERR_MSG(extack, "Device cannot be deleted");
> > +                     goto cleanup;
> > +             }
> > +
> > +             dev->bulk_delete = 1;
> > +     }
> > +
> > +     for_each_netdev(net, dev) {
>
> This is going to be very expensive on hosts with 1 million netdev.
>
> You should remove this dev->bulk_delete and instead use a list.
>
> You already use @list_kill, you only need a second list and possibly
> reuse dev->unreg_list
>
> If you do not feel confortable about reusing dev->unreg_list, add a new
> anchor (like dev->bulk_kill_list)

I tried using dev->unreg_list but it doesn't work e.g. for veth pairs
where ->dellink() of a veth automatically adds the peer. Therefore if
@ifindices contains both peers then the first ->dellink() will remove
the next device from @list_kill. This caused a page fault when
@list_kill was further iterated on.

I opted to add a flag to struct net_device as David suggested in order
to avoid increasing sizeof(struct net_device), but perhaps it's not that
big of an issue.
If it's fine then I'll update it.

>
> > +             if (dev->bulk_delete) {
> > +                     dev->rtnl_link_ops->dellink(dev, &list_kill);
> > +                     dev->bulk_delete = 0;
> > +             }
> > +     }
> > +
> > +     unregister_netdevice_many(&list_kill);
> > +
> > +     return 0;
> > +
> > +cleanup:
> > +     for (j = 0; j < i; j++) {
> > +             dev = __dev_get_by_index(net, ifindices[j]);
> > +             dev->bulk_delete = 0;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> >   int rtnl_delete_link(struct net_device *dev)
> >   {
> >       const struct rtnl_link_ops *ops;
> > @@ -3093,6 +3150,11 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >                       return PTR_ERR(tgt_net);
> >       }
> >
> > +     if (tb[IFLA_GROUP] && tb[IFLA_IFINDEX_LIST]) {
> > +             NL_SET_ERR_MSG(extack, "Can't pass both IFLA_GROUP and IFLA_IFINDEX_LIST");
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> >       err = -EINVAL;
> >       ifm = nlmsg_data(nlh);
> >       if (ifm->ifi_index > 0)
> > @@ -3102,6 +3164,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >                                  tb[IFLA_ALT_IFNAME], NULL);
> >       else if (tb[IFLA_GROUP])
> >               err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> > +     else if (tb[IFLA_IFINDEX_LIST])
> > +             err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
> > +                                     nla_len(tb[IFLA_IFINDEX_LIST]), extack);
> >       else
> >               goto out;
> >
> > @@ -3285,6 +3350,12 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >       else
> >               ifname[0] = '\0';
> >
> > +     err = -EINVAL;
> > +     if (tb[IFLA_IFINDEX_LIST]) {
> > +             NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in newlink");
> > +             return err;
> > +     }
> > +
> >       ifm = nlmsg_data(nlh);
> >       if (ifm->ifi_index > 0)
> >               dev = __dev_get_by_index(net, ifm->ifi_index);
> > @@ -3577,6 +3648,12 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >       if (err < 0)
> >               return err;
> >
> > +     err = -EINVAL;
> > +     if (tb[IFLA_IFINDEX_LIST]) {
> > +             NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in getlink");
> > +             return err;
> > +     }
> > +
> >       if (tb[IFLA_TARGET_NETNSID]) {
> >               netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
> >               tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
