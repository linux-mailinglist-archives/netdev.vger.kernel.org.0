Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0284B4199E6
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 19:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhI0RFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 13:05:01 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:16452
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235688AbhI0RE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 13:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJG4IHGySPw9piCFp0KmcoiQwj8MKkcdlYqZv2pKixvxDoEcYmXpe6UWV2ygjUwMGARq2OE2KcPrsD/rFooi7hu6NZU1Gwub4QsTcpzEZiMOLXw/CrqE2YMdnsFjhCRhkviREWP/WbWo5esYcp6cIc4++WqKVNTDBumpvveyYdH0RAQWgC/9op5JApQq0VU8gw5jvGTsYK3rSJiuk8q9PYQmoQ4u0ptPhQgYWcZne1kdAz3UevaW4NUL0sc9HrZ8A7aUlQJnTcxZW9iudTMhue7P7EQzi5/+RRSf0yJhW17zEbgqX6up9QngWxpY0T2304KFwXZmA92mB+lP1Z8Gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wTtEg/dSj7Cj+Tk7he84FbB238tLPIEgL4jTh5L2hC0=;
 b=IOtgPDj6AHD3TkwnI0TWUPurlTeB9KxcO8hyCKpWFmqaMh9OGC7zlME3V475zeZT7KmpvWNBe0VX4bC7LVEQHOEVf4gjyMwNtsvV/de2K+PNhkfXz+E8WAOWifpzxBSBxc9JLrdMXNqLbGtcaFjKtQWbgOMwIFydKSHaWVU43VylawfukZ38mDn3SQKf0ygDXkpul85jcWCMCPfquhREXObEaMUwLs3gFas65OiqXoiHLIPNasKRhhYZEWJEqIGCg5xskyfl1F+REFtu3IVOUR/sdqwYze3cYnzAOdoBNSYDeA8zA8Hku/XDe3z/jZKv2I5EYLs/gTih/MXIQKqe7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTtEg/dSj7Cj+Tk7he84FbB238tLPIEgL4jTh5L2hC0=;
 b=hWz+VhlAw9R/8mWQFBNrIyQ8h2nLTjzgFGhs1tcbdOyvtXPip6kAovfrCgIVeQq6pxBR4TBZHH4abKR8xZ5+Sn4iHUJIoTUHlg6lhDw+ukWdEPWcZCjtzunHHFml7wFJYUn9TCYE6xUbFJn9cIicRdUXWJrEINadlsIfOHXojB9OfYxS0WEHpUf5fCf9564q43LMjeM+eBPM17iDTbBspYUGbs3z2749A/PL0OLd+EliIiNsoR5TEvByPMCNDQXdNh+D5LybALwuU/q2PYO/rQWF0qbi3WnHZOwWleHDdBRCkZJXL8bYmhRRGE+Pxn1nBGV5twCSibqtYz2KqULjWA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 17:03:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 17:03:19 +0000
Date:   Mon, 27 Sep 2021 14:03:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v1 05/11] RDMA/counter: Add optional counter
 support
Message-ID: <20210927170318.GB1529966@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <04bd7354c6a375e684712d79915f7eb816efee92.1631660727.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04bd7354c6a375e684712d79915f7eb816efee92.1631660727.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0321.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0321.namprd13.prod.outlook.com (2603:10b6:208:2c1::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Mon, 27 Sep 2021 17:03:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUu2A-006QQB-Ig; Mon, 27 Sep 2021 14:03:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 273fcc1f-36e3-4c40-5d57-08d981d8b4bf
X-MS-TrafficTypeDiagnostic: BL1PR12MB5190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51901CC763B97FA8373B6D57C2A79@BL1PR12MB5190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEbdFSo00MDSIdsU/Em/8nPTRQYuDlDpOt6Y/EtCMS7zeOoA/nze7cQOH1iHM32fqPMtGMK/Td3ccYMHQTS6GLjz/uJkDXQE518D0QRcwiVDVMHXDsS2o73mIXwHkVnHmyM9EhJRGh+0g3arv9yIxyYHQfDzaGaGHt6ej07PoAZ7aatGata+I43VIoT0/b/uL/7djh13xfZNEU2lR4CED1Vx3zAcmcEcEceg+qf2+dmzkEj1XGXoVH4NMrAVYh9LRPZx9vMi7LA2OwktMhPX+XzsDi+Pt5Nzr824kBsdgFdQ4uoaDMugY3e6a6GAf2n/NXL2PgfHXSjCKEi0V9JYOFTrnD3Fxc3lJ5najwqxYbK7kCYNgNrwGDqRwTmrJdAnB5uICG8N9sJZ1KBGxCHlckcqgvIxEaIILciTp05GnKY9zi1BSBHYmb/FfvOQmG6qGiuLyQ7xDNZfyQH2HXNT3h9JvYmsbsYf4XwShdcrITa/4HYYK6/TIexa5ji2xAlpkmOLd0J01kd+LF34f/CRZLXduAqYWk60F/gz998DWnMCeqiU6Mi88yPv3JxHtd4ExjRRH/Y68P4awtYfE4XVwYpcEaTln//LRFOXAYFsuKrUmm9JYvB25V/FAuIV8/H5fy9elK56hFlLKp4W9+96pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(2616005)(508600001)(316002)(5660300002)(6916009)(2906002)(7416002)(33656002)(36756003)(66476007)(66556008)(38100700002)(4326008)(8936002)(9746002)(8676002)(9786002)(83380400001)(1076003)(86362001)(54906003)(426003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ddw8yK4GiIj1G7MIMym42biCWbAnnQNPb8IXs7uXQFs3Bv8Yd6heJtd1XZiE?=
 =?us-ascii?Q?kbvEXJVxWk43urrxYuqPz0wVevzHFKahfJCmPix8EKDo4vctqExjlz66nOrY?=
 =?us-ascii?Q?uaoYryukktzpfEeHUEefC8E3XfRHMWtZUIpR2qLQdwga27sWBrbSCZTzdU1P?=
 =?us-ascii?Q?2wkGWoCmkBGXXr2vUmzYmUnzwZOaTwu7KSu56NHLwE30A6jMFqX2nhr/wjVG?=
 =?us-ascii?Q?pvAP09yJh430bh6za3tmzAA/0hFGa6fjute1XIyPZjTT+0F25Ddx2ZDOOyGN?=
 =?us-ascii?Q?pwSae3sXOFAHE80kSieNV48x9vRy8eOdGHX6OtGnwwGMa5aQQKDiQBSf7SK+?=
 =?us-ascii?Q?+8GZYjEE4pmWVKKduevUaYF9SIxmggvgGQ6XuoSs0jLiVk6/KvLmHI3EA42j?=
 =?us-ascii?Q?2+QrxFVoseC1cWAApK32ycFEdrx7nNDGYFSs+MOCPlMwRP46oc17dPsvC5aJ?=
 =?us-ascii?Q?9Uh0PZZgVX7oul8TJgWCzssDfDNCBeSQ5+xkeSUyTo3T57mTNZuoz0y3cmHY?=
 =?us-ascii?Q?RDqnOMeO5ofQbZVnjuzOvp1H/PWdG+Niyaak+Im3gu6ryCuXyFFSVrgXgaA4?=
 =?us-ascii?Q?Pyldd9sKJxESLRhHj9sWxdqkKqjTy3Xi/M6Nteogls8F7K7jCun5wajJGPDM?=
 =?us-ascii?Q?ZeQNAX2cWptUIFKX6/LyQaRythsOcMkSSYhIl7X2N1h//GnZvNjWmeq/LUwc?=
 =?us-ascii?Q?UzFkvZlpNu51Psak/KI768ZCxAerfb9AenNvSOl8UKDFhiX2xXpHhRygDcja?=
 =?us-ascii?Q?r4g1AJo6EK5CyrmG0iXbNV742WLpGJ8DrrOyau9oXlu/ugV5sASc8nz5n/+U?=
 =?us-ascii?Q?3SSo6R7GDc+w4fZiFf6KV2VYy6iqqBrSiW5f58AEzQfyf9U+zZeijJ0PIHwZ?=
 =?us-ascii?Q?I1338/H6nCMhJ+eyJHjdFkYWviFL2gkw/rmV7hviFmsJQd3UzOjcptIBN/WX?=
 =?us-ascii?Q?h7OL+1R/h5+08Pce6BEeq+kxSp6gc7QG2JYqQnxe3RnW3FG37gOd+sfZChCv?=
 =?us-ascii?Q?Jc0YdLdYIM6M/fqe/VF0d/QvRh0CFbrUUymWQ2D4xtYIQB44HAqFHl1uTSdx?=
 =?us-ascii?Q?9wtpdx7Vf+xnqjxD4uHl3W3DW30QxZWqHyXlNqMDqsbNLdgG5krZKxgt7qWy?=
 =?us-ascii?Q?I+kNi7eHeipOzBtJtCk/kSTPF4IyxmjwJpXWyD6uVev04X0Z0nx2ZKXhzG56?=
 =?us-ascii?Q?8yL9/DMLqbPQcIAM8esksvsL4TFe7FFyQc9cqbSUqRHHlj4JrVhbLPhIcXN2?=
 =?us-ascii?Q?xfy2ezNvvpRbuPHzCm53o4tNjfDxdkvB0nBcz96EG5hun7e1ICMm7G3y5hu5?=
 =?us-ascii?Q?j/+JFLmv9mUqXbgs7Dxf3JqH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 273fcc1f-36e3-4c40-5d57-08d981d8b4bf
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 17:03:19.7046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWz65cvNr4i02r/M6MoryG2IRabuhcT84J37xBhjbLdP2HAAG4ZR7JWR1NicE2Cf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 02:07:24AM +0300, Leon Romanovsky wrote:
>  
> +int rdma_counter_modify(struct ib_device *dev, u32 port, int index, bool enable)
> +{
> +	struct rdma_hw_stats *stats;
> +	int ret;
> +
> +	if (!dev->ops.modify_hw_stat)
> +		return -EOPNOTSUPP;
> +
> +	stats = ib_get_hw_stats_port(dev, port);
> +	if (!stats)
> +		return -EINVAL;
> +
> +	mutex_lock(&stats->lock);
> +	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
> +	if (!ret)
> +		enable ? clear_bit(index, stats->is_disabled) :
> +			set_bit(index, stats->is_disabled);

This is not a kernel coding style write out the if, use success
oriented flow

Also, shouldn't this logic protect the driver from being called on
non-optional counters?

>  	for (i = 0; i < data->stats->num_counters; i++) {
> -		attr = &data->attrs[i];
> +		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL)
> +			continue;
> +		attr = &data->attrs[pos];
>  		sysfs_attr_init(&attr->attr.attr);
>  		attr->attr.attr.name = data->stats->descs[i].name;
>  		attr->attr.attr.mode = 0444;
>  		attr->attr.show = hw_stat_device_show;
>  		attr->show = show_hw_stats;
> -		data->group.attrs[i] = &attr->attr.attr;
> +		data->group.attrs[pos] = &attr->attr.attr;
> +		pos++;
>  	}

This isn't OK, the hw_stat_device_show() computes the stat index like
this:

	return stat_attr->show(ibdev, ibdev->hw_stats_data->stats,
			       stat_attr - ibdev->hw_stats_data->attrs, 0, buf);

Which assumes the stats are packed contiguously. This only works
because mlx5 is always putting the optional stats at the end.

>  /**
>   * struct rdma_stat_desc
>   * @name - The name of the counter
> - *
> + * @flags - Flags of the counter; For example, IB_STAT_FLAG_OPTIONAL
>   */

The previous patch shouldn't have had the extra blank line then?

  
> +int rdma_counter_modify(struct ib_device *dev, u32 port, int index,
> +			bool is_add);

index should be unsigned int

The bool is called 'is_add' here but the implementation is 'enable' ?

Jason
