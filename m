Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C446F43FC16
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhJ2MP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:15:57 -0400
Received: from mail-bn8nam08on2052.outbound.protection.outlook.com ([40.107.100.52]:1185
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230273AbhJ2MP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:15:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cg+v6TUZLoRIH3yuusQoYc6tflq2njWAcfgJqbd8iutbPwF2UK/0CvnhG5xSHMutO1ALY1T8Vqh0PzsU+tHLhj+9SV9maBZtrIvWSJCGu9B/GOUq+8Y/4jBGqVXVvR7ps+QI7bphh1YTVqaMpmjZam4nW5FUoofaJ91/bgEuEryroXOLYDqhxsJyc3hzVbIzFhJ4g8OClVFO7adqd/ojMdxx3rxoTIk5BjxLz3WKttHxJuP6+beyCPGy35BD+YbAObLWhvNmR3iLOjzbAaZqFYNEiqoDpbMUyzZnbMNxL99geGu5ElIdvb367uF6+kX9g9LnK2HLyk1/xEL63PXMXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJYT5LyRN/HBKlTw1Xzuzg53hHXMaQ0vq8AyEjtVyNM=;
 b=byhjK2vl3bZS9MhTRS8B5OYYEpxb5pl/TkraBEp7o4vT+HtleGNn/oiZc/tJ21mWuGS0iyhotChyhcYba6JLjhDQChzc9P1zfacDQpUTbKyC5VHFoBCV1PsPTtTyf6vm3FXkDUGmyqdh5fBtx44RUHeZ2TwPwtTf5kvwpjjQLm1yK9Vw5XL1VXhJtuAfmPPkq05zWtpfenFhr3eoy19j6fB6nnZZFLlekYNSpg3t7NQ3uH7VX57/6jEaUvnuiAG60jL+g/9tKlNSDS1rf2VNthgVrTG1TbVet7BHBsMlxI4wfKPAcOWp+O2TSLMJCwtAubT+2OQ+CVzfs0bWsIR51w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJYT5LyRN/HBKlTw1Xzuzg53hHXMaQ0vq8AyEjtVyNM=;
 b=b/z2GVoNYYUGchT6got4tRAQBdsszuyqHr7nmIPXRZ/MhBFv26hNhZD4we0W1EKKNSXg8EtGshUa6jZBzTtsZVKgpexKDqbtQgv9Ki6lU3RRVjbBebPp5jV6c4ELBSRywPkzqNup0wGSS26oI+kD9yasb22ysrfuQvE2dinKfZJlziegZu/NEYIlpjcPkbQHVOYvLVE4tNA9xQ0MUU57vQ0qZSTYztesrG08S/4U06SwtFosYf4cP4SEKVvANZ4wy8yPfc4xkGb+T1mcam7sZEWt3B6ivBUzVmwko2KIg5Y79uuEOJnLUDtkAeFAN/gh2umXEFDngyK3dP2GltxfgQ==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 12:13:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 12:13:26 +0000
Date:   Fri, 29 Oct 2021 09:13:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211029121324.GT2744544@nvidia.com>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
 <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211028114503.GM2744544@nvidia.com>
 <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b573b01c-2cc9-4722-6289-f7b9e0a43e19@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b573b01c-2cc9-4722-6289-f7b9e0a43e19@huawei.com>
X-ClientProxiedBy: CH0PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:610:119::11) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0370.namprd03.prod.outlook.com (2603:10b6:610:119::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 12:13:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mgQlA-003RYB-Ik; Fri, 29 Oct 2021 09:13:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74122e6-5926-4dea-a41f-08d99ad5829f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5320208DE276A8551223B0F4C2879@BL1PR12MB5320.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R74D2OfQiUgvvRh4OO6/RvxA7OQYoWB0byQk9E/rcxRGsklLpdIBtXvfJ8mRnSts3c4QH4ds+YRXQF6S21cPepY5ZkxGNKmThAxfjwu559sUjL3FZBpuxjgUiShfwBchssrly49WYMvxrA53h/s0RoCI7xXkdu6PxFa7h1lSQnmfskYsrCu5nDN4nMCpC77kso1PbtCbC1y+Cc305jENdlRJF4n9A9uy2ikhUn3ye+2CITwpITFWxDiGIXdLt3EWyuq0vlGGae+USP6kzGuaX6A088kimHvb9mnjHZ8lhrFFHCYJTo90wVmv6MvV4xK+rCSdMxnebOjuMacOfgFevU5D5i01LsWdfFL8NualkZaL5aEsQDzAKuRxnPdMquxA2y/VwqMtONhiZuoQIzcUExi+jE4SZuiyJL1RVCb62XV5itnK9hl/UDsAfvZ81nTY5GJSqPVvu4t22p2jF3I0AnJy1ZTezcgJ8kSRaOOA1B+Pq3CqRaVXFjLIf8ZLlqV+nRJg+DxcPrF7dLFQK/mg8jOk0s5MrJgveUiU/XbJsnLnaXWya3ECjzpI0BEB2kCgGvym1mjU3t6Lxu6CfOUfgb2K5aeL3kRteomAgKfOdOvi9oqgX5iwNS1M3jskNzww3cljYZNCr3WUOLBCTSkRjE1+uH8SGaK1k16WUUt11n09As/csDNo+gXqTElzm0t7K97H0S5lXmNAMv3e91aRPkcPbH9L9kNdu3hgNWeSL60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(66476007)(508600001)(9786002)(966005)(66556008)(2616005)(86362001)(9746002)(8936002)(4326008)(8676002)(186003)(66946007)(426003)(36756003)(38100700002)(83380400001)(2906002)(33656002)(5660300002)(1076003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+bg2Ii36b9VA3ocraODrdJjWnlLK7MgA8OMDaEz3oxSaUlB1Rg3TF8k/Jn6?=
 =?us-ascii?Q?8EhBUN0xoHu3bj30+lLxUdWgGCo/9jywItHE/9HKmJPvBMUtJaxjhwpNELV6?=
 =?us-ascii?Q?/83O+U3SeLEXcIjNmvJggPnE/HIRikIHAYHd9H4VUPwYBhZJGOAIMvCWE8s4?=
 =?us-ascii?Q?gpUMarGowfti++Qu5T25uCykltfZk3kusnGXRitcT1VlOtqznAXWR9KHBVSC?=
 =?us-ascii?Q?Xb0op/7ngE+13osHcKuDe8J2SVce+/d4z/6EuFXzf0vnI+Qn92K8aB8BEfun?=
 =?us-ascii?Q?+GGnJrz3OLipltPq4o9Ml6ZgDlQm7hiprH0Gvyc4JeVDO0Xa6E1SsiF6dGUR?=
 =?us-ascii?Q?5K73088Lvi5PTv4p+0gHtm0wXql70jOqc9aCRwCm1IqXesosKtzjRguCfHkj?=
 =?us-ascii?Q?zNPDaXmax9Mg/wtQ9z1K6azU2onaw9ZoQIt9sYeMazVwCC115HmkWmDU7zGe?=
 =?us-ascii?Q?eaG+zS9ITWdgDgWqJD8Ad9K00so2a/OoOGDFtaT3nfBpQYExOn676yTcvNHh?=
 =?us-ascii?Q?DLigTpUpIzMlpgXurZOYKb8F9Cclx9C0NCxhxbx00+/ol5II3dh6Qt1HYdQQ?=
 =?us-ascii?Q?0W73/yQaDlPQWU5+Z31zU6Aw0s8O9k56GfC8ANkn5f0cWfnMry4MWqc7po+K?=
 =?us-ascii?Q?H18V46CNWvMsuQb7DlBj62Ph191v6BR3MkiIIrCoTjUuyx6dTqcY65jELNEs?=
 =?us-ascii?Q?idSK4uC0bvgmLnENS13rJQtpC7JHrHBdlb3ldcImS8TEXCIejs4/lueemqPc?=
 =?us-ascii?Q?P7uDkgK7VTh8tmCkx/+Yj7+/Vee1HOu19Fm390OE09Do8wjD9YCXAc1KtYhI?=
 =?us-ascii?Q?Q84UD1Z7g2+M8BkswY6pgZaHfpVD++XwDkoqRfmgCJiUDhRHD+TMAewn0yUQ?=
 =?us-ascii?Q?UnIeA0IykTys5Mr5J8UyJGZ7JUY5TA6BCw8sZ38eB7hG/dqYkrA9lj12sVru?=
 =?us-ascii?Q?RepUqcFbxZt6DQnxGefz4ezJhrHwIj6igOyZXitrpaQquHXUIN5ZDIJsDLeA?=
 =?us-ascii?Q?TuMEv7hrokmhix+PmU9qCtsbg1B7E//iMJwj4FkQ8wFX0PcKoeQpZznQcxz/?=
 =?us-ascii?Q?jE7pVCgc0emy4bCXPzyhbbnMUN0B+5c4jpmiLHGvIgsWg+PB8ZXJL+FLiBVm?=
 =?us-ascii?Q?LKOJylWS2CmxQ9qMy+H8Nnymila57GqRzBuLpf2kJyRzIVbiPDTkT6r95MJr?=
 =?us-ascii?Q?NSmBESFhAAo/M/kkpMuga1YHT66GzGJbxI4pG62DcyF2Xw/EoHY9SuVR8Lrk?=
 =?us-ascii?Q?8KR2o81Xvux9r4vHKHNeS7rI5PCCIqC0UDssQsyTiriKGZwlvmM2fFdzStuy?=
 =?us-ascii?Q?Dx0mW7/k0GGNki8KQGuah4ULflqFZMeZAwFWa/noQ4uedg88Nw0E1tn5lEDq?=
 =?us-ascii?Q?QYmkt2vtZoNhl7WgtEC67eE4XKjR27eFjHTs9A1a9eDN+3RLy5qK1opiNUkV?=
 =?us-ascii?Q?ZaM40Oa/Wso6sod/uUl3RVY2bc0FzBVkafBBnTuHeyqhEqHnsKectJ2iTgS1?=
 =?us-ascii?Q?5pPTwhXl4khPjEJe6sIhOLj+S/m/PJpXAFd+vNwtIrv8d1WKIcA0rud1pUN6?=
 =?us-ascii?Q?T3x1Nc+oxba40Be2gvc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74122e6-5926-4dea-a41f-08d99ad5829f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 12:13:26.2018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1qCpV7wVjNhJbOcCJQbOWyC7GKlXpiYdtL6kwhJkSdWR/pKzTxIJfHs6Nlij8LFD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 03:04:35PM +0800, Ziyang Xuan (William) wrote:
> > On Thu, 28 Oct 2021 08:45:03 -0300 Jason Gunthorpe wrote:
> >>> But will make all the callers of vlan_dev_real_dev() feel like they
> >>> should NULL-check the result, which is not necessary.  
> >>
> >> Isn't it better to reliably return NULL instead of a silent UAF in
> >> this edge case? 
> > 
> > I don't know what the best practice is for maintaining sanity of
> > unregistered objects.
> > 
> > If there really is a requirement for the real_dev pointer to be sane we
> > may want to move the put_device(real_dev) to vlan_dev_free(). There
> > should not be any risk of circular dependency but I'm not 100% sure.
> > 
> >>> RDMA must be calling this helper on a vlan which was already
> >>> unregistered, can we fix RDMA instead?  
> >>
> >> RDMA holds a get on the netdev which prevents unregistration, however
> >> unregister_vlan_dev() does:
> >>
> >>         unregister_netdevice_queue(dev, head);
> >>         dev_put(real_dev);
> >>
> >> Which corrupts the still registered vlan device while it is sitting in
> >> the queue waiting to unregister. So, it is not true that a registered
> >> vlan device always has working vlan_dev_real_dev().
> > 
> > That's not my reading, unless we have a different definition of
> > "registered". The RDMA code in question runs from a workqueue, at the
> > time the UNREGISTER notification is generated all objects are still
> > alive and no UAF can happen. Past UNREGISTER extra care is needed when
> > accessing the object.
> > 
> > Note that unregister_vlan_dev() may queue the unregistration, without
> > running it. If it clears real_dev the UNREGISTER notification will no
> > longer be able to access real_dev, which used to be completely legal.
> > .
> > 
> 
> I am sorry. I have made a misunderstanding and given a wrong conclusion
> that unregister_vlan_dev() just move the vlan_ndev to a list to unregister
> later and it is possible the real_dev has been freed when we access in
> netdevice_queue_work().
> 
> real_ndev UNREGISTE trigger NETDEV_UNREGISTER notification in
> vlan_device_event(), unregister_vlan_dev() and unregister_netdevice_many()
> are within real_ndev UNREGISTE process. real_dev and vlan_ndev are all
> alive before real_ndev UNREGISTE finished.
> 
> Above is the correction for my previous misunderstanding. But the real
> scenario of the problem is as following:
> 
> __rtnl_newlink
> vlan_newlink
> register_vlan_dev(vlan_ndev, ...)
> register_netdevice(vlan_ndev)
> netdevice_queue_work(..., vlan_ndev) [dev_hold(vlan_ndev)]
> queue_work(gid_cache_wq, ...)

This is exactly what I'm saying, the rdma code saw a registered device
and captured a ref on it, passing it to a work queue.

> rtnl_configure_link(vlan_ndev, ...) [failed]
> ops->dellink(vlan_ndev, &list_kill) [unregister_vlan_dev]
	/* Get rid of the vlan's reference to real_dev */
	dev_put(real_dev);
> unregister_netdevice_many(&list_kill)

Then it released the real_dev reference, leaving a dangled pointer and
goes into unregister_netdevice_many which does:

		dev->reg_state = NETREG_UNREGISTERING;
and eventually

		net_set_todo(dev);

then unlocks RTNL. The get prevents it from progressing past
NETREG_UNREGISTERING

Now later we touch the vlan dev, it is reg_state UNREGISTERED and it's
memory is corrupted because it dropped the ref it was holding on the
pointer it returns, which has now since been freed.

The only reason the dangled pointer doesn't cause larger problems, is
because rtnl saves it - but continuing to reference a pointer that no
longer has a valid ref is certainly a bad practice.

> So my first solution as following for the problem is correct.
> https://lore.kernel.org/linux-rdma/20211025163941.GA393143@nvidia.com/T/#m44abbf1ea5e4b5237610c1b389c3340d92a03b8d

No, it still isn't.

Jakub's path would be to test vlan_dev->reg_state != NETREG_REGISTERED
in the work queue, but that feels pretty hacky to me as the main point
of the UNREGISTERING state is to keep the object alive enough that
those with outstanding gets can compelte their work and release the
get. Leaving a wrecked object in UNREGISTERING is a bad design.

Jason
