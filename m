Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E396946DDD4
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239703AbhLHVu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:50:56 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:53936 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231757AbhLHVuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:50:55 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 162CC6C0067;
        Wed,  8 Dec 2021 21:47:21 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iuve/pCduZgIQTleODRs+iqeLd+44UCnCoPGzuugguqAurAUAHQyWFHqTgFmNxnZac3Ms+YY5547qwXL34L+b162xGbv1jCkArmaO9bxK2X5MgRkg2oHqiGfpivMz3d1sjWtii/sGnumAqZSSfXinrkOILmot8BJM6Z8gnDuYhngU46ByjDscpO8pXMgK5qM3jlR5qzzGESY6PFB3snn3MndANyk3FxJwGy/IZpeFQDupfRsULPbF6hH7tgcmgm3yT4/FVA86RDmBE243VFQm0XFO5OFKLcbWnDQ5QiNReMtz0/Cux4uA6NBdN4L4jzWwhQ2j0qlZOV9EhNEf+qLyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIudnsMWSQt41jw0Zc5JHGgKZHnNHWIj9KauojDnKpg=;
 b=CgoSoCRiEwB5mWRgbfzZwqRVl4ilM0imgn6bp7++wGEHzVNb6z3W8YjE8DNHqH6cpJTsgxVvpora8qSq757LtqYGsH4NlJcADLk17miVHXajxfqf5uJIPB9lz04xiHxYMRaSamRlEj8p8OYg3kdQVFajCayeAesqxWyadC+0QQjmewBQnEX2g7MgN+drZ0oJ0iY1mdUWU0M9ihBdP0vzJi5Vz5KsIoZohErUeZIJpe562LkZSb192Eb5liGiKOqtbe785QMdUhHz75/NhVkcaCjnteeIziYqjtS2Wil1WGPJeTAIl4CPzI2P97Cu/qH/jOmS2A/3rF2WqfCOPGCl8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIudnsMWSQt41jw0Zc5JHGgKZHnNHWIj9KauojDnKpg=;
 b=onIPremtjBtNq64y++LhmAAK7aCBF2Gpt1upUgUmxjsyzTuUXrRzt3Z389zhRW1lgTlP5UBJmqNrdYJK4SQ9OVZtfGuCDNsp60gJ84jo8OziQRnv+B+9piIQdWReFEmrpLiwtWBZ6MYJcRAZyHz7P4OQJxmbh+kBvUxyXuIIl7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0801MB1983.eurprd08.prod.outlook.com (2603:10a6:800:86::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 21:47:18 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 21:47:18 +0000
Date:   Wed, 8 Dec 2021 23:47:12 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: LO4P123CA0393.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::20) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by LO4P123CA0393.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 21:47:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1fd806a-2e1f-428d-75d1-08d9ba944e3f
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1983:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0801MB1983F2EB2EBCB631EC8AE3F9CC6F9@VI1PR0801MB1983.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gAZh5GHgyACEMgVX6Js1l6AHbw7uScoeP4UdADCMAiNhM3Dj0Gz027nZV2rtLYfQXw//fOhHrz8sL7XzUHe4es33Dht5jlydq5OhN33dJduk8xah05GgQJNz9aN6IEt4dcBYIjw0jk2b25/eNQML+IlRCpgzFj/ij8ZioXJw/lFjAPfNlHGE1x/YorZKG3dhu+VUSgVJu/JdFwzGJruKqYqnAKGUYylKiQISxnBzoboZSZd51dtpcdBeBaZrKiR6cdfFJN18yxVc0aE9MjdXLqiuwV/PKewxUoNFCL8YCyaAWYSwFEZvRTKAxMEiETILmHtp2O0zYVzgmMjlfRJni76SO5ZTlDJYwZIZRGD2eaGfkW4k/L9K8lzWvAJZM3jcjZF0UeNnfKnsRhw+pX2DhdM2o7oq4dHG5CkxJdqpoD9yD3HAwVQSNl/gNvpLCHwnFBWDfrPv1Tc1qh3xG9zNmFU3X47BahwW9Ks6xfUqXMSwW1PKvHbUI5jtgRwxCaz8gnFHmF9hc71+sgHxxBsj5Tq54u+rXNN2Xbvp3nVdkAmJlsvyPCmAJ0ptBToK63/Yq1M7whFGJwqTF8zFMQB6/yI3YZzPJFHXJ1Uxp8ypjLoSIMRbA5wTahxFrd3ejmz11PYjY6LQMzot3ZhOw7Gl4pu3xLleKqOxABoBfUtFVgFFaUNhCfNu+C95mGEbr0JwXq49flTf2i862iDEu+rzeiTmUv+60WMNMi/8kIyXG5c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33716001)(1076003)(8936002)(316002)(66946007)(83380400001)(6916009)(8676002)(66556008)(66476007)(956004)(6496006)(2906002)(53546011)(26005)(508600001)(6666004)(52116002)(9686003)(186003)(5660300002)(55016003)(4326008)(38100700002)(38350700002)(86362001)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tPB3mEsxB6/gtEydpIlbvPkOLHEvDrw8VjmzIvvBicN272vJxsxpxh1ngBXN?=
 =?us-ascii?Q?IRUgdBdyCtSdTwl15oSVjZ7lmUM6Nu0bXKNU/487WcUx9GvlCFThKgUu4lQw?=
 =?us-ascii?Q?2Rsv75SsJJ/XPkYOJoQNzcKTWkUXnkiEYFOnJTCwfgv7NSGsTmGXh185fxCy?=
 =?us-ascii?Q?E3mGmrXWlQV5KkPWtZoqkBQnHyFlaFpNTlb2SyQyKlPdQrCoDz6MLjMDGOh9?=
 =?us-ascii?Q?GYEw7Oj4fEEu0IThuSfLa1JWEUBsg623K1B8RYJuB8VXsQWiIral0Yw+tuUb?=
 =?us-ascii?Q?1x57L90p7/S8wCu7bsJE+VbyJ7sC19tX0xMagLgmmPGLCRHL25VqtHEnVXyC?=
 =?us-ascii?Q?WrUeNtDjH0Fzxyie3t32swjUGwDSrxqq2RrdvLI3yteMOfOicU8PjZnc17Zo?=
 =?us-ascii?Q?0PGlJuyniay90LH+LJcHw4oYNZukwZB88ew4xQs4fy43d7X6PrGxrpJBUbzS?=
 =?us-ascii?Q?Oeorpvg2rGs4wItHtai5BlkUoSJuXCDE8gKVR/HLbB8ALPNe1jzG+wwRgcF2?=
 =?us-ascii?Q?8wt7aR7YNaUMnrqQVfqk2v7eYAgvZohPkOY68n1pinJia01BfNWEUNOEuK77?=
 =?us-ascii?Q?S7FyAr7YDMr0ghdKUTFhoVu9P0PYFCuXMBAeyu2eoGbI3xU7TMEsFSYQpNdi?=
 =?us-ascii?Q?oKRZ4uyKaZdsQlorYTUUib2hqELMSkgJYhL7NkH57R/LewuTHhnKElND9iBy?=
 =?us-ascii?Q?IXP1JGdrk2qFWm9sQw137GzqlwTUFk+av7VpXIdBMUI1qKA7W7pazge2vk96?=
 =?us-ascii?Q?OUPEJiw57TwQWoOJOZn8aXkMs0UDgXWveXW5Cea2s2gzy05EL0UjYG6WCES9?=
 =?us-ascii?Q?NTDauJXypqc9eyNhjS4fUKxVodOEa1LvqfAWdMgXYm+oNWDe2N74doW5PCUn?=
 =?us-ascii?Q?kQsa+kNYeN/IjiigNw0/t1fB4ErPVhQhXiB7zcyDmHMJsKc9hXvU8+6aqj9j?=
 =?us-ascii?Q?+C7hRmxXqp9idALQ1rbIn0MKzwMrYC313pinMgyHgF0dBZKY8H7tp39qstmN?=
 =?us-ascii?Q?MZd9iEfISupYSG0l5oJlaiC4J8pXeMtMTR6+FXdXYobxezUapPUwqMsjj7Fb?=
 =?us-ascii?Q?qTNaFLPoHRhZfGyrmvNrCujMDSgetTZQuggZHUvxH4PuFMnRxXcQ/IareMeH?=
 =?us-ascii?Q?Bel1J68mpnJzXUi3uxoh6mu1p3Y34plFolesWAtC5v5HmHbhmjs+RiKf4DdJ?=
 =?us-ascii?Q?8+qIRmzehkKbkrwX0JRaqT5w6jpcvNia+gMvClsdDlAJglNFmNVjWbjtDUhr?=
 =?us-ascii?Q?0YfE0JRiSbTORY7i9D2zMM6/a4bceoIv3MLJ1pwbQnia86/WY7b5Uz15l7lr?=
 =?us-ascii?Q?Olhe9MR+YgTS3lNg6c7jbhl+LWVb0kC2b4i49IayMAxoY5n7kTNejuBhM5Nr?=
 =?us-ascii?Q?pybnohcT+7/ZvabCYdmsMi1YS5S6NShcR3phW8mCVmsbrrWY+NPgy5lsVKyA?=
 =?us-ascii?Q?u5Dn/98vGW2QvDi6JoCBOYJPNXWGf6dFJNjTpqkmPJX39r018ykc6G3RXu0z?=
 =?us-ascii?Q?D9ZZ6ZnjihETPDT7HGyVfZ7gnRurT27HWGAt+V/rhv+WoX3p3LnIXEBQr8Ut?=
 =?us-ascii?Q?fPg4Ht8Dp/lEucp0sVnU6m3SqUfePow1yxdayyApMy6AsA7Erk+7JMbU2MWD?=
 =?us-ascii?Q?8rS9nEhRsQCCbSacoZfzAPO+Yy8JmbmXUGPvtJBye3EhbO1TBBnaBjI+A3od?=
 =?us-ascii?Q?NbJeS3dK5Okok2QDGj9gURkgPvI=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fd806a-2e1f-428d-75d1-08d9ba944e3f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 21:47:18.1982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FI9UqkgHV/Vsy6PYKiE01UyjjdNBQl9CZp0Zs6uxS3D8jdt2Kce6tfVk4+IPgI2IhhW8BYLBAEMA62WbohchC2c7afDnDkw/84ZuFxExjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1983
X-MDID: 1639000041-LBpXdH56sETT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:12:33PM -0700, David Ahern wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 12/5/21 2:36 AM, Lahav Schlesinger wrote:
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index fd030e02f16d..5165cc699d97 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/etherdevice.h>
> >  #include <linux/bpf.h>
> > +#include <linux/sort.h>
> >
> >  #include <linux/uaccess.h>
> >
> > @@ -1880,6 +1881,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> >       [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > +     [IFLA_IFINDEX]          = { .type = NLA_S32 },
>
> you need to make sure this new attribute can not be used in setlink
> requests or getlink.

Right, I'll add it.

>
> >  };
> >
> >  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > @@ -3050,6 +3052,78 @@ static int rtnl_group_dellink(const struct net *net, int group)
> >       return 0;
> >  }
> >
> > +static int dev_ifindex_cmp(const void *a, const void *b)
> > +{
> > +     struct net_device * const *dev1 = a, * const *dev2 = b;
>
> const struct net_device *dev1 = 1, *dev2 = b;

The array stores 'struct net_device *', and 'a' and 'b' are pointers to
elements in this array (so 'struct net_device **', ignoring constness)

>
> > +
> > +     return (*dev1)->ifindex - (*dev2)->ifindex;
> > +}
> > +
> > +static int rtnl_ifindex_dellink(struct net *net, struct nlattr *head, int len,
> > +                             struct netlink_ext_ack *extack)
> > +{
> > +     int i = 0, num_devices = 0, rem;
> > +     struct net_device **dev_list;
> > +     const struct nlattr *nla;
> > +     LIST_HEAD(list_kill);
> > +     int ret;
> > +
> > +     nla_for_each_attr(nla, head, len, rem) {
> > +             if (nla_type(nla) == IFLA_IFINDEX)
> > +                     num_devices++;
> > +     }
>
>
> The need to walk the list twice (3 really with the sort) to means the
> array solution is better.
>
> > +
> > +     dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> > +     if (!dev_list)
> > +             return -ENOMEM;
> > +
> > +     nla_for_each_attr(nla, head, len, rem) {
> > +             const struct rtnl_link_ops *ops;
> > +             struct net_device *dev;
> > +             int ifindex;
> > +
> > +             if (nla_type(nla) != IFLA_IFINDEX)
> > +                     continue;
>
> and this business too. We have arrays in other places
> (net/ipv4/nexthop.c), so this is not the first.
>
>
> > +
> > +             ifindex = nla_get_s32(nla);
> > +             ret = -ENODEV;
> > +             dev = __dev_get_by_index(net, ifindex);
> > +             if (!dev) {
> > +                     NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
> > +                     goto out_free;
> > +             }
> > +
> > +             ret = -EOPNOTSUPP;
> > +             ops = dev->rtnl_link_ops;
> > +             if (!ops || !ops->dellink) {
> > +                     NL_SET_ERR_MSG_ATTR(extack, nla, "Device cannot be deleted");
> > +                     goto out_free;
> > +             }
> > +
> > +             dev_list[i++] = dev;
> > +     }
> > +
> > +     /* Sort devices, so we could skip duplicates */
> > +     sort(dev_list, num_devices, sizeof(*dev_list), dev_ifindex_cmp, NULL);
>
> how did this sort change the results? 10k compares and re-order has to
> add some overhead.

No visible changes from what I saw, this API is as fast as group
deletion. Maybe a few tens of milliseconds slower, but it's lost in the
noise.
I'll run more thorough benchmarks to get to a more conclusive conclusion.

Also just pointing out that the sort will be needed even if we pass an
array (IFLA_IFINDEX_LIST) instead.
Feels like CS 101, but do you have a better approach for detecting
duplicates in an array? I imagine a hash table will be slower as it will
need to allocate a node object for each device (assuming we don't want
to add a new hlist_node to 'struct net_device' just for this)

>
> > +
> > +     for (i = 0; i < num_devices; i++) {
> > +             struct net_device *dev = dev_list[i];
> > +
> > +             if (i != 0 && dev_list[i - 1]->ifindex == dev->ifindex)
>
>                 if (i && ...)
>
>
> I liked the array variant better. Jakub?
