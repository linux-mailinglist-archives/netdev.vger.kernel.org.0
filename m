Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5555A280E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343852AbiHZMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343691AbiHZMwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:52:33 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C194C9253;
        Fri, 26 Aug 2022 05:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+24h4rGu2DZ8VVFIokNwDTbdI3oDKxPHRQ9+XLgoJ9v1xTnz9D42dYUbblehOrqo0rBA+DXPnmItL5OVx3lq04lVAgLCnfIcXHaMuslZ3eiMrebQQi1LPV48nCADm4y0YWA6M6h+5BoWbgQMUjNlW6uaVBo7nzRykUl9sGRrb+29LnTFuPUHUOvux8F4JSlPyFQkXs3UaNp2AwlqrQqk3vh1k6TQ7bDJmUuWNoreiOIQXePoT0JK6BAOrfC9CViK3FjszbECjcu3zgsoOXNqIYnc/+UynVky6L2YD7dNznHDjxoPhUMw+M6EWPaC2uaWGOarSyJkZGi4oEKm35rgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hA3q0Bz00qmh5WrTzTopqR52cUyHvgJnjEhMJyAxYi0=;
 b=e34FNV9pXYx0H/ZZdfcJ59WlmT1g619V2r4mKH9gVs6iWMu1yinAhGm8T0C4al0r/izwKnegWqZoyKARUjMhbsyLrnheF5RGGzGj82O0kuLcToJmfOTYPcJFSZXKv+Uix06XhnMlA8XlQtE/B3XsMHS5v18tWWs75SSsrv9zTtHwUWPgFDoJhECS9UhmZv4ed5w+b9chj7OT+ycDRnBKTMxCPmtVkAf8Wn4rZV/UdKQ9d/oQFFP/6IO/zmE9S4ljgHipmUSU+9gMm9JbF02gQl4LvNk/93wEmHIgPq5Kn26xhGKF3GazjP1DG921plQ/cLYcTJwGglklz1RknDdAyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA3q0Bz00qmh5WrTzTopqR52cUyHvgJnjEhMJyAxYi0=;
 b=DKnCBOFs85Vgd9xGX6eVCIO6op8yDSy+2StRwP4Gf+3R8q1lV+hmayUKlHoSMVGKbhkUePPBgbieaunGbrNi/L6ZOj6lo8oRvhbpzRj5a6k2tJ/V/KeYKGu5XQNIVI96zTKSVRPQaLbxrXsl82EIefgCqdvA774DKOEfeQzBc+3HASX1s347gD6B9kF+zCKjfiIzoL0HTE/Pu8pazKHaAe+FWEABa0jTVuWiU+TWg53XTs++JJxcFUymqoibelm8HxiscM4zYGjeQ1BD73LIkEWAgWQtqmnyMQTwLJuqx7XuQ0sH7Qc5GR/Q3RuZ0M233LJ5JRaqbaQrtmhYa/C5Iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6624.namprd12.prod.outlook.com (2603:10b6:930:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.23; Fri, 26 Aug
 2022 12:52:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 12:52:30 +0000
Date:   Fri, 26 Aug 2022 09:52:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <YwjCDSPVa0uNy6vX@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-6-yishaih@nvidia.com>
 <20220825144944.237eb78f.alex.williamson@redhat.com>
 <8342117f-87ab-d38e-6fcd-aaa947dbeaaf@oracle.com>
 <20220825164651.384bf099.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825164651.384bf099.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0296.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22ba39f8-e84c-4030-5eec-08da8761d624
X-MS-TrafficTypeDiagnostic: CY5PR12MB6624:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rRl34HxneJbQaEwWF10udixfbZ8S6S4F6MmyflrolIdD6L2VMcDJtRkZlwTDBaLZ21BXjV6UKMdDcOJm3JcYgdi4YaMeAeV7lKJ8dRjJdFe3piDoLlMSX3qL5xgsvGyvcwo6LMzMwNOwWZREwMrrLVfevRxbhq95x03TBxekbu2pzqBFip9XfeE2TmUYs1avTsVOHKCqs6ENm45OQtjEe/SWN1ZKsHPq38+aV1jXyvpAvw4P83usAP95rfpXmqcYFinU2M9Q6jKPH9b0AHw7beb9PM2SpDDHN83h2DTkmOBbt8zl00YdowJ3p4vnTglxpuToN3dSSVYw8/T1cc/LEzPeHmzZRfY0P24OpizpNffDJOIkXYWwif9q/i6zgf9TpGeAfGwmt1kiKX+s6K5GHdgWddV6qDftjKcWom8VZ2MRwWhvCULo1kfnGQ++goQo4eckwogMTDrESlZXVGBb9ii7vVbWA8DZdrnc++PVGs+gD076l6pcF2FY74Rrk6zoU5O0yv2FNayJJSFGu2039SyX9rMdJ1/huFNZVVsQbI+WC9cQ8Rpl9LYAHdj1Kv0GJ1cXNVLSnGVSdHhRllOkuwbg1X8lX4tFBzK0bq69k/wwi7lmIM0+zpUposjefErkREkUZ+VOvBwRSJFYgZCQWr0DMoZ8BuVnxVUj80iHNCaOEFzmuNKHRn7cKDPQZ7oDUYwfpf63AwiQ/5npjlWMfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(38100700002)(54906003)(6916009)(316002)(8936002)(5660300002)(66556008)(66946007)(8676002)(66476007)(186003)(478600001)(53546011)(6486002)(86362001)(2616005)(41300700001)(6506007)(2906002)(26005)(36756003)(4326008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uR7QeOY5ae2i2xWicL/UT6niMIN0ibmWyMtkC9rTF0VIruy0LLFVRwGnHT1p?=
 =?us-ascii?Q?GlG+G36GF5nq0dpkxsnyFlTsZgaXz5ovA621d477xPGBUyAXu4+HbsmC+ZV9?=
 =?us-ascii?Q?uoqj0f2ijSDpYEC6Z9zW5lLbrxgyskzb9MPpnm2ev6NAptxNdolai7BWCWwx?=
 =?us-ascii?Q?eDcoVfcUdpd1JuVKgtSjlLu0+DDKLyP+EQE7uLBdxYe8I+omXkkpTjx6KhGR?=
 =?us-ascii?Q?KKG1uZ4sW3qhxdrR7Dj2fzgwKwCpE8yswA0tqWTleuspK46yRGjoHrxgj4g/?=
 =?us-ascii?Q?H3K4/uRyhgDZPsFwM28sH3W4zGjWRIDwUk26DP5BB9FZzerZ+t7tu72c5G+m?=
 =?us-ascii?Q?v5Vg1muU4nJWO0OaP90BPnrCArpEd71c79VWKHOLFgsMfadQzDWNgEQMsb4p?=
 =?us-ascii?Q?vRoBm6bCnJ9UyUVYtLSUIpPvxANoExeI4MWT03LqBAao2/RP24LmYekErjAc?=
 =?us-ascii?Q?sFDVE2WHZla4AKF+wQHKOo6GMupg26C6S2wnNAZI2eResAo6ZaJmEQceZO66?=
 =?us-ascii?Q?gOLV3vKXcXnqBAs1TH7o/O7/hGqgaP4CW3JGbMOtDaJUL/mcNNGnaF9nPFiE?=
 =?us-ascii?Q?rsdrII7USqpYn9X+SDuUQr1VxL+1RrevQPn5IQ4zyNaZXaHOz1FaPcVO3FRx?=
 =?us-ascii?Q?ZhbXltF02bIWiYL9aG3Iz9PYOlKd0QCDfzZvL8wOU7r7nMWE8NjGhmZrNclV?=
 =?us-ascii?Q?6Ys/AWI3eR6+8wV8PplTIBOyvRLubrzU1XA43JyPDa9JywC1xH20jQZdaewE?=
 =?us-ascii?Q?hQwalNKFMvve8hTjfLeirre5tY6Ru6P8ntceyj8gCwrrl90T1PWsxU59gVf3?=
 =?us-ascii?Q?qgl/PHzJ4IKR9kitlJODoAsud+1xjJKcYJLfHtCQQA5N1Is+y/eddFop/p6T?=
 =?us-ascii?Q?NcKwmLGXwpGCbsx2GAx0lMw62xDkRal7mu8Nf1JI6Iq85w78v//v5I9E+ivo?=
 =?us-ascii?Q?IMC7hVmmxrEvOcZPBCJEgTb6y2Tavh9cE7GaH1Fb6kQ5yaFgvDqi15wDDUVP?=
 =?us-ascii?Q?UvNTEtg+uO7/AfT9aHkticXjWyEDEz8tzf57RBwxC08O82m9wDaIJaV4a/Cx?=
 =?us-ascii?Q?/QIXCIAI8W9P+SsNx6gF94n2QnZ2HiSNp6HbG6qlcSMBOhPQA9UPFtiVmNd0?=
 =?us-ascii?Q?VTG6OMYG2LuI22Kcr5f2S3B9nX7tHlqPXxBzt6/LoPJ5GVnPfsN4B44EiXfB?=
 =?us-ascii?Q?BIrdzSuTruSTAutV7tKomFXTS7HAmDC88NNzyuL3qHO/qq8q5Wj3/q+SBpG1?=
 =?us-ascii?Q?JLKfcrM1u36HYSyKgYUhjdykUVlfUw0LPoEw6JefNwhaJnJy8a1eCTk+FF9b?=
 =?us-ascii?Q?UDNO6ZUhwKOd1We9mYjNtRGAjf3F9kGB9O9g4VR5Aazd74roipub62e0qfci?=
 =?us-ascii?Q?acMaIt0WOFbV+jH0MXlfxNau1JyyJMPsrfKfY9xDHymb4aSStCsTc1yHK8mA?=
 =?us-ascii?Q?e7cU5dQSMRcef7owmKKaDfZhQHddDaxr8r30U1nemVuXDvOaY+QWD62cB9AW?=
 =?us-ascii?Q?KI9N1gFyyXfVPzqsqzDODbF2kKclRBGy8ihqFuR893XSCz4xqR8ObkuyuprY?=
 =?us-ascii?Q?pj88HvxAbrzTkPnwGjRBJ8mGEBBsykFGorAI8EJY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ba39f8-e84c-4030-5eec-08da8761d624
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 12:52:30.5006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsAgPEcSJuFl5BfT6TrH591EoH6g/r+Qjy6SMPe9rmRxynENjiFuWyV90IucJbed
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 04:46:51PM -0600, Alex Williamson wrote:
> On Thu, 25 Aug 2022 23:26:04 +0100
> Joao Martins <joao.m.martins@oracle.com> wrote:
> 
> > On 8/25/22 21:49, Alex Williamson wrote:
> > > On Mon, 15 Aug 2022 18:11:04 +0300
> > > Yishai Hadas <yishaih@nvidia.com> wrote:  
> > >> +static int
> > >> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
> > >> +					 u32 flags, void __user *arg,
> > >> +					 size_t argsz)
> > >> +{
> > >> +	size_t minsz =
> > >> +		offsetofend(struct vfio_device_feature_dma_logging_report,
> > >> +			    bitmap);
> > >> +	struct vfio_device_feature_dma_logging_report report;
> > >> +	struct iova_bitmap_iter iter;
> > >> +	int ret;
> > >> +
> > >> +	if (!device->log_ops)
> > >> +		return -ENOTTY;
> > >> +
> > >> +	ret = vfio_check_feature(flags, argsz,
> > >> +				 VFIO_DEVICE_FEATURE_GET,
> > >> +				 sizeof(report));
> > >> +	if (ret != 1)
> > >> +		return ret;
> > >> +
> > >> +	if (copy_from_user(&report, arg, minsz))
> > >> +		return -EFAULT;
> > >> +
> > >> +	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))  
> > > 
> > > Why is PAGE_SIZE a factor here?  I'm under the impression that
> > > iova_bitmap is intended to handle arbitrary page sizes.  Thanks,  
> > 
> > Arbritary page sizes ... which are powers of 2. We use page shift in iova bitmap.
> > While it's not hard to lose this restriction (trading a shift over a slower mul)
> > ... I am not sure it is worth supporting said use considering that there aren't
> > non-powers of 2 page sizes right now?
> > 
> > The PAGE_SIZE restriction might be that it's supposed to be the lowest possible page_size.
> 
> Sorry, I was unclear.  Size relative to PAGE_SIZE was my only question,
> not that we shouldn't require power of 2 sizes.  We're adding device
> level dirty tracking, where the device page size granularity might be
> 4K on a host with a CPU 64K page size.  Maybe there's a use case for
> that.  Given the flexibility claimed by the iova_bitmap support,
> requiring reported page size less than system PAGE_SIZE seems
> unjustified.  Thanks,

+1

Jason
