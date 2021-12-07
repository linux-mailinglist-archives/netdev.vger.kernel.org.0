Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B846BBBD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhLGMwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:52:41 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:52018 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhLGMwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:52:40 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 105904C006F;
        Tue,  7 Dec 2021 12:49:08 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cg91vRd5U3WfzZF3qTu7J73dEtlspnHy8ABkx6EhKhIz3IRTRSr1TLNrNW3G1DR8hnj8udL/VPU9+tyS6tzDeqzTft9fHJ7BefptU5KaIbH39srCb3b+mHJ4RGKnE8HoLkSjSHix+O/NcRCMyTlRZptCnrbwk1DWBsQ8HgAOcFqweWlcjnZvalE2T754GDJ8/1vsR8/wHTxmJ9QTDvrmP9UnOyk8RSDwppoZ8Hu8l+/vuhBdzVg81spZb1RZYN3C/IxVUsncJwY4PnhCdc3Bk4MNDg2hgUxByXh+znHGz8dVOdtzStUoVHskVkuHBJ9TByo5MkZQFRnOjgWD7N7TwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8Adv1bSYs4VxxJoD7e00VZ7iq59G0NJkHx7c+o9vqU=;
 b=TC6hmw8Dowi3tIYPWGHJjEjVUrw2V1bx6dMIZ3+6pcTMoCh9vb8NqHhxug4NpS2vq1g5qSWe6KORZg2Dzjd9MqKsvamku2Jp1ZnVHrj6zSsa3yz0gUYO5uFZ/ACMJIszjo6BHG4K+tY8faMN1kyopfdBSXpw9WaehCqukvQ5+FYwCGnOWUUAfkmQC6L4wFUeZee21jsimsAY7fvvkR5cWbKE+bSViz7pLWivT4kcX1Q3eyVlxHSQ7zpSHzuwyxnTHRdtz0hZsSwnCalKbGX54yBtLBwHaKAq5DQOVEML8CB1fss9Z3hC6ETwExLrmwlQLmsX8Wpl+GzpJgdQXfXXwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8Adv1bSYs4VxxJoD7e00VZ7iq59G0NJkHx7c+o9vqU=;
 b=YilVteHr+AwqS4f/l2kF8u4eAk/rZAdQA0H7oYseADSkyjhntVBiFqyL/EHsoSh6Xi8bN4SgytPdi7x+LD1Q9DQblRFpfV/GZIF04S6Cs5jg7wlFOyXhzknk9pYQMKgWZH2ulVdB7okSAr+HPEZa/dIRRmHx7Gj52zG34AvNT14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0802MB2224.eurprd08.prod.outlook.com (2603:10a6:800:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 12:49:05 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 12:49:05 +0000
Date:   Tue, 7 Dec 2021 14:48:59 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211207124858.3tpsojcamyxldjb4@kgollan-pc>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM9P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::31) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by AM9P195CA0026.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 12:49:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f40600d6-2d68-4431-88e1-08d9b97ff3dc
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2224:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0802MB222490081E202B176FEF1CF3CC6E9@VI1PR0802MB2224.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3HxMqqUQD1eDopyRjZluaeOLF5ZheAulFtAE0BVUvAHoJwSwN9vwiad7cGVm/vSJerlCgFg3Wanw2ZXeUwgr/JyCZMkqGvO4VFRbRmDymWW3oXmYQoGKsS6l7PVbvdOoCdn4YI2aRL1nrjQf/d4gEcxLlOTIFCR/FUx9AQt8zcPO+zXYt/U6lShXS//TDCHNsv1Edfcl0wWQk1ZUk0BQwTI1L+dT+ongcRwW/scu4+kbmjWb3sTZwRj10JzlgNSD6IQHjd/AALYbrVDNXNU3Hc6Vkdj8VUxl3QAVeTEYSwPA9UwrAGZQ++5RNsGt7BS0sKopUlwro9tgUpOXYSxnGJpVVFzBuyM2a6tWpMzlumljd1ae58xGocHjFExGE8NMjr+17Qm7WSztW6roYbx9pwgmBIFMgGvXps6tVPh72hPzaJ5Nb4TRh+z3eLj8uumww/N7l5l1IQBjdlBrcfzHHl+FiBYu5Q5+LyhWnPeCmjhYMzPaozknAbxLKRIN4qd6Mdlt4Au7fCaKdYdPo82IpoJr1DITX7ClhshAv2nt44UTQC9eAbFX9vJMssZ0vl5ThwLfny3wIcEW8ahRXXakRg11JpakjKQae9HrELTTff4BGIKXxN5ALdTwjFIXb9CUX1cQmsealXyn1A/+Z6VF9O/htZQHisrT6sAtUECarjJCSdX/sLFbSwc/ZOkUN3NDgjjdxzcLqk1HRJMG21C17nrT24U8P993DFHhWL4ltKL0ZEen9zMNOH65RyRDdij95wzyxrEFQhVWXkkpldfgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(5660300002)(9686003)(6916009)(55016003)(508600001)(1076003)(26005)(66556008)(6496006)(66476007)(8936002)(66946007)(8676002)(52116002)(38100700002)(38350700002)(33716001)(316002)(86362001)(4326008)(6666004)(956004)(66574015)(2906002)(83380400001)(21314003)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?W83dpS6VAWwDcHEuQM2437Ighnt4jzyUqypuj2UBGNuzng1aUcN+LZiPEz?=
 =?iso-8859-1?Q?/DNRJKJ/KKyLids8GZYJ1MmnIXfUx8NfK784XPHr/xu41ggfx54KQ5YXtk?=
 =?iso-8859-1?Q?jf13/cgiB2MhG/zlXnO9byNSU9PJqGnNOnn2o2aVbn8bBcMr3vxve1LZKn?=
 =?iso-8859-1?Q?3Uy6bstoUuF30KQHdUzKfWqUVP6ksjTKXUwHHMQenJxXkbF3CNvSEYVsC/?=
 =?iso-8859-1?Q?RlXaQ28cH292o4+wW5w/2A63JJ2lV/sLmptiHGnyBmvoXdNqWL1NtKfxjW?=
 =?iso-8859-1?Q?WA4ikK30Qfk58ZV3YGgK1Fp8yXNc8o0D56fTxZUOWY2jc5CGshOP7UWcLo?=
 =?iso-8859-1?Q?b+wNUgbLdxs7WtmlTGUj4D/1rLsOh+6ZwGdGvY+T6QIg6caDWnL/6KRnNR?=
 =?iso-8859-1?Q?2DT5zvDpSNGSNg4q5z4OTlZ2cmE+NVKgUZPKc0BCu8VaQeSlFT0X1Ae4dY?=
 =?iso-8859-1?Q?0/3ZIseyWU3h9MUYwuPoqdrVO+XiftZemRhkPr/jJCjhW+FrtZA8MHQAFh?=
 =?iso-8859-1?Q?QT5gvwZEdiB1YeEWGi8HasVtox0qg22XtOFnQ3Jm/a9U34cHlv+sOsbWwD?=
 =?iso-8859-1?Q?V1+5ZNbGkfWfqHac4Nkra/k5rbeWInF+UKVI7nX7On14FZVz3+BtTUpqqP?=
 =?iso-8859-1?Q?944FihJEq2lLhsnyA58MXwOmwuxZ3fM6ekzpq/5LX4sVAl7n7VSq4QXcus?=
 =?iso-8859-1?Q?6VogFZlqBh7wZZtxVdRDtHjjXWqxw9MpZjpn05C1RjTq3rP1RYgZEzjh21?=
 =?iso-8859-1?Q?u/n43eAVhYeOpZt8O2KPGf+8KTHploNW9Ky5a9IExLpf/Csc++amxGb30D?=
 =?iso-8859-1?Q?DqvuWGeMSyBm0QAiGuB91sRwSTdjCbD0VCIoyuAsVDJwcjnsZMxF1SJGDe?=
 =?iso-8859-1?Q?KDaZZtid8ekMYyu7WBKgauFXkll0P93pvZG7rLyQsv4Ch8nM09Mqx/DjPm?=
 =?iso-8859-1?Q?th+t4SKOOZ/fyyE262nK4PUlVKEw2jiwjQKAHrAE4MRffEeVdfWebfBEIy?=
 =?iso-8859-1?Q?NRrah+UY62EEBZrUns2S3oGdj3gODWvFI5R1osJ6nSE0xcGRwTfoNmzcoP?=
 =?iso-8859-1?Q?EhSQ57KUUJCIPU+fSM8NpjCNxiZN0z90xSWp+SR4YUmDjxV8/+7fcrVqPY?=
 =?iso-8859-1?Q?X/SPersz48u+psDp72Hn5Qokw/UnWffRsgtSZ1Q0SypQPBS+ZmGAInI7l+?=
 =?iso-8859-1?Q?7/dvO5z+QHBtcmArd3c1UeSbMBvridaC8FghjsVctE71NTUxEYNJa6jyQ/?=
 =?iso-8859-1?Q?ItEvgSIMYWDUQsAvildtLy2zWns3FhMF9zOtakF5Zm2UPMr0Swdy93t5BU?=
 =?iso-8859-1?Q?63UtlmX2wsQ5KNyJ96S0j5AxCYmMH9RqInEVkd5j8jhs0XqaK4e0w+ThmJ?=
 =?iso-8859-1?Q?ZTJXi2xCvMlneREeJCshpvzcMjIJHA0Z2eG9eTodnjRsjwbB4VnN59sH2v?=
 =?iso-8859-1?Q?GXprgHtdtlA9AyLv4TUomD7nQKcMTu9A9Q+9GVAqUSuxubLqZJLLVJz8I3?=
 =?iso-8859-1?Q?8l/h+cljlIxi8g1/0LUlJpmW1FmUkT5LBIT1hkiMvaGelj+0reCLTnKXKS?=
 =?iso-8859-1?Q?wY65KbxrMhFT9BtjO+pXRHtuRIkNGVyDCvE+2u23FSawyuh5eW9AZc17XP?=
 =?iso-8859-1?Q?9BPG5pAYfkMEJAkXZ30nTE24ufbKXl+kIM1NYzdDfW3ZCGbY3qTDaI5MW5?=
 =?iso-8859-1?Q?ZNDP3rIEvfMRTxcLpCBMNIhsplwMrtmkNvV+pwLU2iNmXonL+qVHGe8JZt?=
 =?iso-8859-1?Q?uQ6eujfRZsSJvFHHrTixjnx8k=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40600d6-2d68-4431-88e1-08d9b97ff3dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:49:05.5136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBNFvZJtMp1Sq7gZVIzRKk9PyUrP3oR3Ak2pMYcxoP6O1XMVGltHAcAGzKGbUFhzBsvicRBu3ulDgJfMOTI3suxkBmiz3CvaE/pBbtr+gc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2224
X-MDID: 1638881348-mjmivClU_O1t
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:25:17AM +0100, Nicolas Dichtel wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> Le 05/12/2021 à 10:36, Lahav Schlesinger a écrit :
> Some comments below, but please, keep the people who replied to previous
> versions of this patch in cc.
>
> [snip]
>
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index eebd3894fe89..68fcde9c0c5e 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -348,6 +348,7 @@ enum {
> >       IFLA_PARENT_DEV_NAME,
> >       IFLA_PARENT_DEV_BUS_NAME,
> >
> > +     IFLA_IFINDEX,
> nit: maybe the previous blank line sit better after this new attribute (and
> before __IFLA_MAX)?

Due to the comment above the previous 2 attributes, I think that by
removing this empty line it can be accidentally thought as if the new
attribute is part of this "block".
As for adding a new line before __IFLA_MAX, I wanted to preserve the
appearance we had before the IFLA_PARENT_DEV_xxx attributes where added,
where there was no empty line before __IFLA_MAX.

I don't mind either way though, whatever looks better to you.

>
> >       __IFLA_MAX
> >  };
> >
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
> Same policy than IFLA_NEW_IFINDEX to refuse negative ifindex.

Right, thanks

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
> > +
> > +             ifindex = nla_get_s32(nla);
> > +             ret = -ENODEV;
> > +             dev = __dev_get_by_index(net, ifindex);
> > +             if (!dev) {
> > +                     NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
> It would be nice to have the ifindex in the error message. This message does not
> give more information than "ENODEV".
>
> > +                     goto out_free;
> > +             }
> > +
> > +             ret = -EOPNOTSUPP;
> > +             ops = dev->rtnl_link_ops;
> > +             if (!ops || !ops->dellink) {
> > +                     NL_SET_ERR_MSG_ATTR(extack, nla, "Device cannot be deleted");
> Same here.
>
>
> Thank you,
> Nicolas
