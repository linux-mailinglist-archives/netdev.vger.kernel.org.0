Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F4341AE2B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhI1LxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:53:21 -0400
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:50848
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240349AbhI1LxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 07:53:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFXIIrsBvXYR9elrqRtCoyLy8+WmXSiwFgxEkISgx1mGbbz2xJ69XUbDflF2x7sPLyl/E2oSH1+RvQQrsSCGCYX6bYwyLSGeXKBGhV5xxgI53o+Swl4ZhXtmsY2puSJnoSGjZFQJnGAPDEu5JAj1d1Fj1IUR3DxaeJUeeziMFYuJ2ciCkfJb0SR44nJyGq2dqwjaHZ1OivcRlmx33e92azATCauoHyHVX+/44nm64LKwPwTKJ35rokEhxBsUMSD2CJ2NtdYtikRLjRVLw7vvvrgMBK4rBAT1boWuqDh3PkBGWagptcyDNBWaQT3UIdnBpzSkjxj7E+tNaOA4btVi9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ADiYFjMc+8SIrCARwKHolwgIjsbnASIdOt2M1AV/d/I=;
 b=NvBogdL+q3ZdAHnIveuzjw529W0DyT3f0Io7CrW+cWVi1D60HXFXxz1ZOLk7OdgKc7FrZLo7f0LiQDUIegYkI1zsf+3C2MyaeqjWH+76joXlrqe0WzbBJbvLKqd/uDyPDMp/eUSFoQd/SzIZuDKvB63RDqD0OMnjEmZoRZFGnCWTnL5Bt+UYkxrUi95P/LtS2vHTTv0XAEjdjOP+W4knwMmSIvwaT7SbzrQC4Z7N2CfpWObVbSsUeRuKjVbc4VC6j0pM0Og9Tw/+RJb+fkw7o2MXkMvQWXA5tjuL7kLyfszwV3YxtFHc9EoXRDyHxeGWBlQsH4g97SatTZC3Y4Idxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADiYFjMc+8SIrCARwKHolwgIjsbnASIdOt2M1AV/d/I=;
 b=QFJCMhHvCcWUcsmRQKMufIsxWxzP/k90Ll+qdx16UWSjoKTQA4S80l1AHP5Gl4rbqe8C1kFufnv/2PnhEdYM96NLANnsP3CZpSQRd+Vz6AYkpkZR00kw4qbpO5xtQIgZULfuqddFrn/y5atgjMi3c3TzBbaiip+h+9I8sjDyL6sKYgomoq6SmsPP5CuJgBHXgxnJC7a++UqNuHeo1wwvT9yZnj8cxAobHQj/1W3s0pAwf3k7xjpPOEtuweWhyMI3vrNTgxCxJQsNnMwYUHno4+hJ3JyZcBLLBOoJOd74m71GIalSkLRT7zdb5rFcTSOGGHub3stSGmd+552928rD3Q==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5507.namprd12.prod.outlook.com (2603:10b6:208:1c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 11:51:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 11:51:36 +0000
Date:   Tue, 28 Sep 2021 08:51:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
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
Message-ID: <20210928115135.GG964074@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <04bd7354c6a375e684712d79915f7eb816efee92.1631660727.git.leonro@nvidia.com>
 <20210927170318.GB1529966@nvidia.com>
 <d9cd401a-b5fe-65ea-21c4-6d4c037fd641@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9cd401a-b5fe-65ea-21c4-6d4c037fd641@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0062.namprd20.prod.outlook.com
 (2603:10b6:208:235::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0062.namprd20.prod.outlook.com (2603:10b6:208:235::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Tue, 28 Sep 2021 11:51:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVBe3-006wtR-Eb; Tue, 28 Sep 2021 08:51:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca8d6d16-7858-4dc1-bc99-08d98276533f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55078423D8FC42E8DDAF1F2FC2A89@BL0PR12MB5507.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLLp5CFSD5U0eHFseZ2EN2CqFAjGUFvA/qR4s+efCeJElkXbI9cZvpbyMzZEc/JyJN879s0cc3XXkz0m2QTUipksCEGAs3rMEvgXKpl7yYjF0+gpKNDgR/zLlAAqK01J/Au+Kh+DIzJSfzQbRwT+KDuj9FlQGj+mi0/ECGn7sZPxms+PtvMQTgQIuT5G8ArVkfdINUM4MJ2iQ6glHjtCJO9lgnj+lQI3jSO03Qwmy2poVjZITReflUNTkAyJxG4KnFvAJw0q97ZbdwcRF+QtxIjh/dnjVlwMJetlT78NTI9dSyJE1+6/mMkIWIbMWOa7uFah/VW6xJ3Rw7BK7WtqdPYi5wsc306tRHZ219S4LUsDR4p1aK0tD9kC11odFic/3kJvbTL2aSb0HfuTCf1/ifvXpx60NMLKwb+0EPY0t4bchrvXYFSdnYrrSeq08Vqg3WCybv57n2BchtimloiCBQSHL5wgOqjZUVBOzMhx8fGd6Pwrr43DhNyMDSb4TUvfBC0Yt/ZEw3mXRoxA7rHbgOhDKCyY+8IRlIWsNyfY4G7I5MvEzpdDiwl8W4ZXvF3dfnC2SpKQuPZKL3qPSWmQPuPPfR66m0jWYAYQYqtOi3gpiM0OQLGjeQ40JAQ/+m12IVWOa1QieNDbF6zZE2aixvJAqYKz4gx0/VuQw+9xw0MXewzN6C64tJleg5vhIZQ/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4326008)(9746002)(8936002)(9786002)(38100700002)(54906003)(86362001)(83380400001)(186003)(26005)(426003)(6862004)(53546011)(8676002)(37006003)(5660300002)(2906002)(7416002)(66946007)(316002)(508600001)(2616005)(36756003)(66476007)(66556008)(6636002)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E5XXczwjvIU9WM2iRVEK8v9maIrGDhKSZToYpW6sLANcYEWAC1P1LOoT5kia?=
 =?us-ascii?Q?A4Ua1P1uBRj5/2MCXk10TMt/5Sr4BoK8ZZ/HLIYnfga0JM8vKZMCqE+bwRzu?=
 =?us-ascii?Q?nl9JqV4vfkV9V8zhRlTr4ArknrMiWub3Hy64S5lD2LYx9Mzkj8yyb/EvvsWJ?=
 =?us-ascii?Q?QxpxADtSiM7++XC611XEymPcv/lmzpPyRTvcDH7ef/MOHgr3yfY+s9ge7j3s?=
 =?us-ascii?Q?KU3G8Nl0q8DvG0Pg6+49W4Zl5b3sjy5GRARQ1H2ZHlnK6e0eOaiVwLLGo0kz?=
 =?us-ascii?Q?Vacy0qKfQZhS0el4KdmDZmwKdf3whEGzLpUyXV+K8b3cytxhetll9ylwKjTo?=
 =?us-ascii?Q?Crt8kMCpXH40gKMF+xE7c8gerFgmyDCg7/EZd9qOpkWXz5V/qrCjmCu33HOc?=
 =?us-ascii?Q?hObl4ResRG3j+Pt3Yi8oWPX5m7+ucJgWHu0n9o53D+Q6qD2vIqoLtThnLdbx?=
 =?us-ascii?Q?b2lW4FrbCY/nqCklbJEh7zzH6tTvUlgVDQB6XxxKmq7HtJpX52Hc68oANU5T?=
 =?us-ascii?Q?je544CmgQNCjyGaDeVyA/EHl5g4CLd2d/jR4Qlr00GJStbhQY7nEL5867KHN?=
 =?us-ascii?Q?xrg8X4bt0Fx7E4BmTomHar1NeQ1EBG0aP1zVyAnKvbIOtVwBZeUDqvtYN/0R?=
 =?us-ascii?Q?95UMB51sWFvmSwz/GvCbleMKtJ52YqhsnB6Asw6+Uj2tpxq92rNXP9kMN6XW?=
 =?us-ascii?Q?UDt1WmJucEPk82WKi9fp4ZefD1Vdp/eUiiTawKenwjhwvQzZy6J0b8+OI5NN?=
 =?us-ascii?Q?kn1OMFnDV2IiB715ql0HrlSKT1GrtBgJlfaB9qYVaUyw8cbepgCTXsFZRzWG?=
 =?us-ascii?Q?52Sq3JEsRPHBogs82eQJDcXWgJZNURuloBhu2YlaxV0vdxJsDcoujokqf8j2?=
 =?us-ascii?Q?FbzwO2I4fB1r0Kusy11v4bhRmpGB4V3tLEqAkz5a8ql7S+3JxfTBm+IOjPfh?=
 =?us-ascii?Q?0o9nXF0np+1yJaqNpuY33l88Nf9P3Oka/ELxXPCbMF71cri1QobrCmaAwCy9?=
 =?us-ascii?Q?MaZ1Z9/dIXtFN1C7Q+moFrNF77n4ITzZDL2pSJuc7a7W4U6JUvgEh/URxo/J?=
 =?us-ascii?Q?pzsQDVhY7RtA8wcm6Ef8LOlWyD2hwdvE45V04CgjUJPo/WlvSCPDD+R7qbK5?=
 =?us-ascii?Q?/LTdbclNFEBKez9ci3t4VTsX5p/Bo1LQrsJWKhH69DIRk0rDyuPlKTiHaqUh?=
 =?us-ascii?Q?3ACQxcmE/7azE/WLfpZkL8zSAVIkR8qcwKJKrRkNDnuAPygmOhgUUfV8Tt1/?=
 =?us-ascii?Q?lasm84pqeNJZ0piV/hwJgEgMEdhL1GVyxVWmH+E0ALCqxcE9GWaUmRiBD4Ea?=
 =?us-ascii?Q?sxsqQXzpfUt++EsKBUz6tnbU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8d6d16-7858-4dc1-bc99-08d98276533f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:51:36.7757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VYQu6YLj0tD7a4tLORAjOn42lXtxDeeSLQ8l8wSZDfJ0KLxjgcJ9kZpipn6J35x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 05:03:24PM +0800, Mark Zhang wrote:
> On 9/28/2021 1:03 AM, Jason Gunthorpe wrote:
> > On Wed, Sep 15, 2021 at 02:07:24AM +0300, Leon Romanovsky wrote:
> > > +int rdma_counter_modify(struct ib_device *dev, u32 port, int index, bool enable)
> > > +{
> > > +	struct rdma_hw_stats *stats;
> > > +	int ret;
> > > +
> > > +	if (!dev->ops.modify_hw_stat)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	stats = ib_get_hw_stats_port(dev, port);
> > > +	if (!stats)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&stats->lock);
> > > +	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
> > > +	if (!ret)
> > > +		enable ? clear_bit(index, stats->is_disabled) :
> > > +			set_bit(index, stats->is_disabled);
> > 
> > This is not a kernel coding style write out the if, use success
> > oriented flow
> > 
> > Also, shouldn't this logic protect the driver from being called on
> > non-optional counters?
> 
> We leave it to driver, driver would return failure if modify is not
> supported. Is it good?

I think the core code should do it

> > >   	for (i = 0; i < data->stats->num_counters; i++) {
> > > -		attr = &data->attrs[i];
> > > +		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL)
> > > +			continue;
> > > +		attr = &data->attrs[pos];
> > >   		sysfs_attr_init(&attr->attr.attr);
> > >   		attr->attr.attr.name = data->stats->descs[i].name;
> > >   		attr->attr.attr.mode = 0444;
> > >   		attr->attr.show = hw_stat_device_show;
> > >   		attr->show = show_hw_stats;
> > > -		data->group.attrs[i] = &attr->attr.attr;
> > > +		data->group.attrs[pos] = &attr->attr.attr;
> > > +		pos++;
> > >   	}
> > 
> > This isn't OK, the hw_stat_device_show() computes the stat index like
> > this:
> > 
> > 	return stat_attr->show(ibdev, ibdev->hw_stats_data->stats,
> > 			       stat_attr - ibdev->hw_stats_data->attrs, 0, buf);
> > 
> > Which assumes the stats are packed contiguously. This only works
> > because mlx5 is always putting the optional stats at the end.
> 
> Yes you are right, thanks. Maybe we can add an "index" field in struct
> hw_stats_device/port_attribute, then set it in setup and use it in show.

You could just add a WARN_ON check that optional stats are at the end
I suppose

Jason
