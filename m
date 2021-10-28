Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A8443E02F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhJ1Lrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:47:36 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:59808
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230180AbhJ1Lrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:47:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjvL//LxN+YZD4tRJCokXUTwpAWJz+rsjWsWmpyn3LBWIgzUy1vhfZm3Wa/kGcQhebj+EngvJXeOYAD8aodtk92OQ90/+NqsLhDXeMG59O6LV5wFOp/2lLUaDQhpudq4a4UlPItfh0bxNcjyMEUInGT4H+eVhvq/B5rIKeC7I2O6zTOQ9R7tnCTfUOAe1C3Kd6/jRawJobrgy0worOCxB3lzqVKzS7l/4vR7bKwiNsqvkWzEqBS62fpZAripTqSKAnqYy4EbP3U1OfuRSq/x+5+1zAKYhc22cjqZyB837sYQmyk7fNCddpxn2CPT4i2F3sLx9+5sBUcqUVKQ+YkXjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJFJ+hJKcaNr6J31G3ciwMz6CEEDr/QglD45r1poaW8=;
 b=XlwL+rz4JLch8p5ErSWaWvAlHb5duNFR5hObo19O3epE7qq+g0XQeEbjKl2QzK261XcMAixeAnTJ9PlBhGD+/0WZ0BJErPLcIaZ0/VZEOFxm/7/+z6RLMCm1NVRhcTGyh/HSEeMt4pASnIdnTY6/cRnlJgp3XbV9O80PHhC2dkPlgO9+IeCkyGM7G7PUwcmYKM19ADFZ8tOO2WlvrxWTV28sExbk3tTOYlgSVqm8RiM6at3svkdYURhNdDb/I1JS1ZFkgF8rPnOTWFvK9EYXIp9VR60rGIGiM3bmpXXQzdd8kP7w1hJiErO6mZwr5DeTbuwAv4TS6PkV7QW+oB+dAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJFJ+hJKcaNr6J31G3ciwMz6CEEDr/QglD45r1poaW8=;
 b=RQPkA9Ben5dik1bCJJIHBdsUVX9UhX5XYkAHDkTn1y7D5JZ9SmN+z1xh9oWVd7HPBJU83od/u99pkqzMQ2s5L/2Li9LdWQ+Vcfp3Pu9rC+GFyCyzzAW8juNG16qQYXwcZe/HbyjPXAEMMNf/L8A+nE7Quzk3tCNiIJFpW941wy36n/AFwm6rMJkT6QaeYO7vXrPRHnDSnntbQpLHlWcNMMvYqp6CMGEBq0IEAOGLH8z4LZJaxCXup+KwIO2XKW8UfbdHSY/c2PYh/E9rEoV1rKwlUIBBH9srNG8KXORTpbqVnDCMwqpUcNzfWq+nO1doWOtvxQb6LxzpKszhe9XtGA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5538.namprd12.prod.outlook.com (2603:10b6:208:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 11:45:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 11:45:04 +0000
Date:   Thu, 28 Oct 2021 08:45:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211028114503.GM2744544@nvidia.com>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
 <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: CH0PR03CA0261.namprd03.prod.outlook.com
 (2603:10b6:610:e5::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0261.namprd03.prod.outlook.com (2603:10b6:610:e5::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 11:45:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mg3qB-0031C6-2f; Thu, 28 Oct 2021 08:45:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24580696-3dbb-4a6f-712c-08d99a086202
X-MS-TrafficTypeDiagnostic: BL0PR12MB5538:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5538F363D6782AB187B5D068C2869@BL0PR12MB5538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o/hbO7OXFNi4v3nn4Vu1vkPpK7MgvZt5Oyb0OHh56rUx4OIbRTFJV+4sdxt7wD+bMBfQ5/2niWMLiYI5yBMsALi80zQBpvFep9OkZWUbq29L1C2jCBWURgBsXWTit4GjocIULWRWpqAoo5OvYLp6mXr42CDQ8tNUW9yS2wt7MlpWxfckE9Ag2lyIG8ttOGrJHuhfbwBxBk/97M05nvHbNyuj5C8uFyFe2AvhCx1Gxmld6xNliOfGwlkT+72nEIMpoOuyr/stGO/lY4Ak5skOdaNEu4a8tSXz2Mtl5ImocuL6SN4qUvi9rqGDZNeykefsseKxRlHg53S9u8dMJbytesrz2d7RcJCLmmS6C1mh/WtPBHjvfD5FRWQSE2NElrmU6FovXOzALduIRbHU8WE6vHawn6DJC6zPGv1eHE618BmRZJDmLZTthncZLpvOz/DI/DeuhjvqW+kMdHUBM2QTHEfY/I7hRaMd/v/bH4rpTrh5uzaD5/xYF0rMjAgPWjQKnEcwd+n4sTTPg1PsZh57i+CMmz13DmbB42Xbd8pbsitO20IVrsVsne0wi5/7jiEYqHZqS8pqxYCwMOIHTNRQSxlAPkx5KgCvdjIh428ATCwAWtZ7TrVJlFxohVyvTHiP2v4JefaBDYZksDHYxodIAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(1076003)(6916009)(33656002)(38100700002)(83380400001)(2616005)(316002)(66946007)(426003)(8936002)(5660300002)(36756003)(2906002)(508600001)(186003)(9786002)(8676002)(26005)(9746002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zuf6nyMS/khZPbOeh5p61ZcsDArUpnbZ/X6JQODiNlaCmWJqf5Y7PrKq+qUZ?=
 =?us-ascii?Q?P/l8D088WfTN2ROqQeheRU2ObHz63pQKQ/KcoD1fwAd3DUlJSbleiOZlPbDo?=
 =?us-ascii?Q?usQUsXLvLlLXDpNSo9z3UfJK+pf139o3olZIic26uW+M0gBGj5eR4nTtmEz6?=
 =?us-ascii?Q?+t1P3eKjLzwcqzTRUHQgXy+mXB/+c3bS7lfooSGiZw/IiBa7sRnBF5Ccbuot?=
 =?us-ascii?Q?q5LQD/07djJDmgLRzrmLSyL+kyh4kDJfMlFaEKG3xE3LrKYXjf0CRCA7rV/u?=
 =?us-ascii?Q?B1evbaP02Vhtm3WUUYx96thFtdV1Ugsjb5ZE6/bwqJX/figjbYAiNgFpiibb?=
 =?us-ascii?Q?tZUWzZkS1rtzduHgVFzAFtWEHWiOtT9pNq4EPsiOv6AAwrvYX99DHuct9t28?=
 =?us-ascii?Q?5bSHI9JcFma/KnIzdc3QK53vNODiUQbU9Ib0qCkgyfky95J39eXkZ8Nv4K/8?=
 =?us-ascii?Q?A2IX1+FdK0DGV1h+bne7FfaABYsZ4zAqUPC7qOP9/EuQxMK+JpA2Qt4MFxR1?=
 =?us-ascii?Q?yfybF34C9MhnuNzN9laL3WknrDKs67qWymJxqWxIXc8SOo3PtIZZZTR6UImk?=
 =?us-ascii?Q?Ivc57/AriTegmKTyZLoeb3agOEI0r1Kzfkd5S7i6GpslEXeyTtPc81Y1nxOC?=
 =?us-ascii?Q?xMcZCCMbI1gWpXu3wJjW/CIthDYeY42RCYkGMI9mcXKGBjDyvLoqs1eCwmJC?=
 =?us-ascii?Q?DjrRzM0KdFN9wFHgekzWhZ+oc9aHjBbpdDVmref2CVZIhAQqD8MF3vLzm6Nx?=
 =?us-ascii?Q?7y0bDLSv87Tt6GFQKZWF4wsbAa5suCrCtwV15wWyzYtUIDU1vnJQgWKTEIIW?=
 =?us-ascii?Q?DclatUtaAMao3G6ncQVcM5JAcsPZOhH57m0iWxEUlm1OXb9HRCrBfgt/gQZZ?=
 =?us-ascii?Q?+bPHZEx8ksGpRtD1wZcdSbUnd96UUXmmWkpREQ4Ozgq4RLPCpDC9jKHDuJOr?=
 =?us-ascii?Q?+ScE4ygHo2xQUnx2Tygfc05i/EBnRt8DHaW8hQSDcUCilP6jpg0eG0xyNO1f?=
 =?us-ascii?Q?9+Inde4ItpXXYU0HRGhS+oaP1FM2cv8haU+rakCgLC5uycT8zv1E0G9XSOMM?=
 =?us-ascii?Q?dg/hi1xiE/q9MLx37wIG5808KHW/qItPnErnxYfFeX30RDMOLq496yuyqBoM?=
 =?us-ascii?Q?jNDHZgrdgBJ2Mtu2Er7UBolSFph8ipBCHroYQnk2OC404yl0jlyStltPMSY7?=
 =?us-ascii?Q?G9M5sgNnEzvqvtYoIvbGW0mSf9neV5iALUp/ymoWoJtLTaLVqZLdo4T1p8tE?=
 =?us-ascii?Q?eRKmaQVMK1ctNYZOWolwrbK8SVUxPpBRheO47nOZQhZ7fg7bOuZ99a54ba2Q?=
 =?us-ascii?Q?Lqey0fkohRPk7DGVQKAoF4dBnGfH33W5naP0tAsNS7yeY1Vf4VENI752qtf7?=
 =?us-ascii?Q?YjNhN+U5fY6aIsTvrLppgNOpnABCUq0W5Lt5b0fevxhRRt2PgpDmUTbEP0zL?=
 =?us-ascii?Q?cY721VCwaLtN/DeGGNVpzskJSTiQdQ5oiBWfWJcocgnpR3op6fRMj3EMD4G6?=
 =?us-ascii?Q?rLwGmuMGaPzVg2kSxuZokBgkQI557bKQlhUVO0aEuo5wRHfZv1aaJNCA/iMQ?=
 =?us-ascii?Q?wJOBcRREigPsVI6kHQw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24580696-3dbb-4a6f-712c-08d99a086202
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:45:04.6459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /n+0FMKXFdoaEboCbKFDJsCSD3pVoROTFyrsoW0TtCPXK7q8243TOfB++aN9ytdY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 06:46:40PM -0700, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 20:16:06 +0800 Ziyang Xuan wrote:
> > The real_dev of a vlan net_device may be freed after
> > unregister_vlan_dev(). Access the real_dev continually by
> > vlan_dev_real_dev() will trigger the UAF problem for the
> > real_dev like following:
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
> > Call Trace:
> >  kasan_report.cold+0x83/0xdf
> >  vlan_dev_real_dev+0xf9/0x120
> >  is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
> >  is_eth_port_of_netdev_filter+0x28/0x40
> >  ib_enum_roce_netdev+0x1a3/0x300
> >  ib_enum_all_roce_netdevs+0xc7/0x140
> >  netdevice_event_work_handler+0x9d/0x210
> > ...
> > 
> > Freed by task 9288:
> >  kasan_save_stack+0x1b/0x40
> >  kasan_set_track+0x1c/0x30
> >  kasan_set_free_info+0x20/0x30
> >  __kasan_slab_free+0xfc/0x130
> >  slab_free_freelist_hook+0xdd/0x240
> >  kfree+0xe4/0x690
> >  kvfree+0x42/0x50
> >  device_release+0x9f/0x240
> >  kobject_put+0x1c8/0x530
> >  put_device+0x1b/0x30
> >  free_netdev+0x370/0x540
> >  ppp_destroy_interface+0x313/0x3d0
> > ...
> > 
> > Set vlan->real_dev to NULL after dev_put(real_dev) in
> > unregister_vlan_dev(). Check real_dev is not NULL before
> > access it in vlan_dev_real_dev().
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
> > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> >  net/8021q/vlan.c      | 1 +
> >  net/8021q/vlan_core.c | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> > index 55275ef9a31a..1106da84e725 100644
> > +++ b/net/8021q/vlan.c
> > @@ -126,6 +126,7 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
> >  
> >  	/* Get rid of the vlan's reference to real_dev */
> >  	dev_put(real_dev);
> > +	vlan->real_dev = NULL;
> >  }
> >  
> >  int vlan_check_real_dev(struct net_device *real_dev,
> > diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
> > index 59bc13b5f14f..343f34479d8b 100644
> > +++ b/net/8021q/vlan_core.c
> > @@ -103,7 +103,7 @@ struct net_device *vlan_dev_real_dev(const struct net_device *dev)
> >  {
> >  	struct net_device *ret = vlan_dev_priv(dev)->real_dev;
> >  
> > -	while (is_vlan_dev(ret))
> > +	while (ret && is_vlan_dev(ret))
> >  		ret = vlan_dev_priv(ret)->real_dev;
> >  
> >  	return ret;
> 
> But will make all the callers of vlan_dev_real_dev() feel like they
> should NULL-check the result, which is not necessary.

Isn't it better to reliably return NULL instead of a silent UAF in
this edge case? 

> RDMA must be calling this helper on a vlan which was already
> unregistered, can we fix RDMA instead?

RDMA holds a get on the netdev which prevents unregistration, however
unregister_vlan_dev() does:

        unregister_netdevice_queue(dev, head);
        dev_put(real_dev);

Which corrupts the still registered vlan device while it is sitting in
the queue waiting to unregister. So, it is not true that a registered
vlan device always has working vlan_dev_real_dev().

Jason
