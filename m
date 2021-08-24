Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7783F5EC8
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhHXNPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:15:38 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:56257
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233952AbhHXNPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 09:15:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZkBMO1FJVFW2qZke8hcxwPGTEe0O/0RlzBMm+gvvOdGdUkIncib/Cv5u1uFFsW9cS6bQc/CCpLcgGq89iYQj/jKMsb2NGGRPtj8+yLTCUCLCzvf5Z5VYBX8N9DI30H4UXx4zUN6DIs+mWrDM6iU+k44wAkYSWysT3onrG4axrupgaWqGVY0+7CL3Mf0sxJYWG+S1wTF3FucrroZSAS8KTPTfetOviSCCUTTAO/YaQKKD9VREFaaIescJCCTFwrAbzJUOn88wHhB8hJvb0qKuN8ze72xOI6E0BwN88rs48HzOWnOf+G1NDsA3hyh001aX/OUaWToqvadw05b958yJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcKs5IYFcvsvjdaJ+IjegdKHdcYJlxLu6hQ2sIHMPlU=;
 b=E4aj3FTYR2KLDdytcA6pBFOvJ6Fa1E+K7tNh8A7vXj4cspi8fFLgplqwBcAel6gOcQLc7YO5L9mkKHZ8YK3Gv+xalf2XclngCBi1e0niJB6WcA/vEfxCtU3Wb4z2/TwmBLggk3CwTgmSfBhlhRLoXCkjh/LHBcT8GHdOgpYTM4SR3n9Y+Og7T9g1BvfmQGAcnq4SwsqdUk2LGwjZAPJQVO7RCa5qxq0pXCwsNbY3wIr/GLxWXkwrsecFva2Wtaeich+2DjGwNsQQ04a6IZrdGD6FKxzonG5oUIfzvLi4fd+YWtOjNdMm93pWnaFRT5Ei9CziMyybbiwyVajf+H8mIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcKs5IYFcvsvjdaJ+IjegdKHdcYJlxLu6hQ2sIHMPlU=;
 b=ZQ+ACz7p0bwZx5bfkrhMUFiibDkDrrsPQcTfyD0BPloOG0z60mPbLUYBKEQUJ3HasuuWHjXKqsh3LD1uv7i7DGNfRvFEqGk/FlUUvrPX7YfCft9F+L5ejaOh1DcblfExQHzfKKPwOZ616pnhApQvuZElkiXveLRsZBamzkkrL45Gnpgzq7OorfGKrzxs8xoQ3bV95q+SenvkXkzMEny6ad6uVvLbs2fs+0YZFrM8xJxTr4OTogwkJoQbYPX8P0aXPxI2zszGCLhLdEh2iqAiLMfCqz96FcOOiEXML9xNRtkb33AUirilHvXyREfF/oNkg577ZuhSHt2adCZ9qtwqJw==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5555.namprd12.prod.outlook.com (2603:10b6:208:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 24 Aug
 2021 13:14:51 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 13:14:51 +0000
Date:   Tue, 24 Aug 2021 10:14:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 03/10] RDMA/counters: Support to allocate
 per-port optional counter statistics
Message-ID: <20210824131450.GW1721383@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-4-markzhang@nvidia.com>
 <20210823193020.GA1002624@nvidia.com>
 <736545a9-c5a8-5f0c-8051-9f519c8bad89@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <736545a9-c5a8-5f0c-8051-9f519c8bad89@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:236::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0044.namprd05.prod.outlook.com (2603:10b6:208:236::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 13:14:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIWGQ-004SM2-T3; Tue, 24 Aug 2021 10:14:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ced05f8-fa87-4607-df66-08d96701281b
X-MS-TrafficTypeDiagnostic: BL0PR12MB5555:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55553B84C2615DA345B6E266C2C59@BL0PR12MB5555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ww+HlZ7O6Lj2ULLLGUkYjhhGwf3tavSAeVaBgAV1rgJGs28tG/vyZZMlFNgzvkj33WaZaZoIcT2uA9/RFU/WxgSI8dZbKYcqzapH7wclxMh69z65YdSD4DaoS6yX8KWRcqkzPb6fOSCfy7tET1h2z39eZjn9xG6jV1EHJvyaI/t7AFKl0JLHyUv+MEUY1EC678+fAKppXPCkNrQgjlDGNYCtp/A97Mqw5Xd5icruNKHTRxws6T4MeldvaHw2iX+Oc8n+YbNTFH818IO4Im3DnVLCzMRo4UP9P9I+mtgbnjLkPdD+tz/toquQXTCzDRzauj76479spP9lonwGUwIH+HZM6jpu7a/KqpNYC7XX7VelPx9ugUBynlGqj9+r18PVLpdxK39hMS8z2LqVyUfFImPelS7wc4nSr83XV3ml3CDCQTCEWFsEenIdcwBj2Y656ipFiTm7/FxemW55plUxxUqfrU4ZKt6MLspmPkDkZHeBAR2mnJ1K6+2Gbv55Fk58ioRFWrgbJBmNXP+qkk+N6Se/L5qAjVYe14ZP1q/OXzmjfBT4N35UmgYMtVpGT4KOZpDRwD+nbjtEYbnYhRSRoMDfdVMlETw3Ps025fEePnZsAjI++ywprNQgOmUSQC62gU/xMdrbN0r1e9Hu6KHHJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(107886003)(66556008)(8676002)(66476007)(8936002)(53546011)(26005)(86362001)(38100700002)(426003)(316002)(66946007)(37006003)(9786002)(9746002)(2906002)(186003)(5660300002)(83380400001)(36756003)(4326008)(478600001)(6862004)(1076003)(6636002)(2616005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?csVX0h8rY8InKPzYBlwOmCl19GvKpOVitapyIbbWbHjX+mmOMly7D0yMaaQS?=
 =?us-ascii?Q?+pYravraETAJf752k7O9RPbTMQ1hMov1bOOyHsqJu596W77r+JQMlh4tPJcQ?=
 =?us-ascii?Q?c8r9Dap2UpYaM7bmdNIV6UrQizp/pHTDm5e0AEz/X5wAOtUs4Jg+KeB273n1?=
 =?us-ascii?Q?+9QFZmCyDwTEFSmFHb8ALbTkqvyoak88lWRtfW61RCZ/8ABKF/Qlh7kHG/tN?=
 =?us-ascii?Q?rjKJCERBDM+9xNWvkuga5VMDVfXbSje7R5lMZqCtuI4cFsdkb717ZBObvhgk?=
 =?us-ascii?Q?Lh5KbAAlCzmWt06wc7dLu5Gp/NYpz4JkhrS+Pnhkos1TCEq03ZtrOQxQ7ZA8?=
 =?us-ascii?Q?iyVP2g3+YyPnWcJuch618WV1zGAPdBwlLyQ7gbYPZ2ydKs7WYaSZQ5CXiOLi?=
 =?us-ascii?Q?dwjjkxPNvrJewChPHprPfFb32i0llaLm6Z2eADJVj+xcKY4/8de/wHe8twT3?=
 =?us-ascii?Q?HUkE2sj5Hk8hrS0OLCotjMzOqmCdGk5/W4T/NcmXeY/Q0+BlDKKUIXwOBBWf?=
 =?us-ascii?Q?L6Cv6PKLKsyO+yxDz1Uk92t2rBpHg3kqWjaagjMOWgxFemptmqte1ytOAuW3?=
 =?us-ascii?Q?uzfVGhir6cFUIWaQYoiVWF1qnjEGX7Beh6msafNVY1PgQ7+vM0behN7ggxP+?=
 =?us-ascii?Q?RVi2+AC/5kZHNjuPnRiep4HtrAyJWQM0wcELA6T1n9Lx7d2qgCYH5IJ9wWGb?=
 =?us-ascii?Q?/d9Mj03KVV+K+paEIGEIY76d0GvyxShY08e3HeGJZqG98joURYrirsQmYw2I?=
 =?us-ascii?Q?yxRuvRm1s1mnBGF1JScvxk/yonyGIuB/RWipu0r+5S8m2g18/m9hUrDUrEqi?=
 =?us-ascii?Q?d9r689nqz5lV1ZVk0zXMiARIzixEQwGtw4P2cusvkB57FWqp8Of2xdAul+vU?=
 =?us-ascii?Q?4uCv0RPWNM3Qk8gwef6q9v1PbK0g84bf1VMqwFF10lh4QagX33b/6rxdybDF?=
 =?us-ascii?Q?7rxNefgmwzFEfbjJRA//L1K3JcNtD4/OW8hIoJdz5yPIjnUew86YP2lTbPc0?=
 =?us-ascii?Q?7fS2faDqgAxuGR5kr4fR+vESaIh0T8hu5TmB4nq63+hW5YdZ6dMMWj8pxCPN?=
 =?us-ascii?Q?Moqo0fB+wWCOpAvpE3og5SOtqo/XUiR9zfdqdXot/DsUH1XqrCJVdvRE6zqU?=
 =?us-ascii?Q?bM01CtYfTYMDBE+wBrOoM7/KZZtHz9cubZ0rMW4F8EaRRlYT5jk8/OdRuW1L?=
 =?us-ascii?Q?3CD7a/DNUDOP2nCLxjGxBLOdv4Svi2Z0cT3pCK4by8Y4lhLoPF+v5JNpElam?=
 =?us-ascii?Q?rx62iCdVojR71dZYAUx7+QGZaroSiBmZMkTAMfL01M3ZATBawEIWH4Ft8/S2?=
 =?us-ascii?Q?Oik2EzmQtWZ7KghsGfP/1Zix?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ced05f8-fa87-4607-df66-08d96701281b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 13:14:51.6981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1SOoj/lugssGCUFxB6dQjHiX99VdUwJvb0vYSage0UW4jPqzpXMFgBU7yFQtfhn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5555
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 02:22:52PM +0800, Mark Zhang wrote:
> On 8/24/2021 3:30 AM, Jason Gunthorpe wrote:
> > On Wed, Aug 18, 2021 at 02:24:21PM +0300, Mark Zhang wrote:
> > > From: Aharon Landau <aharonl@nvidia.com>
> > > 
> > > Add an alloc_op_port_stats() API, as well as related structures, to support
> > > per-port op_stats allocation during counter module initialization.
> > > 
> > > Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> > > Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
> > > Signed-off-by: Mark Zhang <markzhang@nvidia.com>
> > >   drivers/infiniband/core/counters.c | 18 ++++++++++++++++++
> > >   drivers/infiniband/core/device.c   |  1 +
> > >   include/rdma/ib_verbs.h            | 24 ++++++++++++++++++++++++
> > >   include/rdma/rdma_counter.h        |  1 +
> > >   4 files changed, 44 insertions(+)
> > > 
> > > diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> > > index df9e6c5e4ddf..b8b6db98bfdf 100644
> > > +++ b/drivers/infiniband/core/counters.c
> > > @@ -611,6 +611,15 @@ void rdma_counter_init(struct ib_device *dev)
> > >   		port_counter->hstats = dev->ops.alloc_hw_port_stats(dev, port);
> > >   		if (!port_counter->hstats)
> > >   			goto fail;
> > > +
> > > +		if (dev->ops.alloc_op_port_stats) {
> > > +			port_counter->opstats =
> > > +				dev->ops.alloc_op_port_stats(dev, port);
> > > +			if (!port_counter->opstats)
> > > +				goto fail;
> > 
> > It would be nicer to change the normal stats to have more detailed
> > meta information instead of adding an entire parallel interface like
> > this.
> > 
> > struct rdma_hw_stats {
> > 	struct mutex	lock;
> > 	unsigned long	timestamp;
> > 	unsigned long	lifespan;
> > 	const char * const *names;
> > 
> > Change the names to a struct
> > 
> >   const struct rdma_hw_stat_desc *descs;
> > 
> > struct rdma_hw_stat_desc {
> >     const char *name;
> >     unsigned int flags;
> >     unsigned int private;
> > }
> > 
> > and then define a FLAG_OPTIONAL.
> > 
> > Then alot of this oddness goes away.
> > 
> > You might also need a small allocated bitmap to store the
> > enabled/disabled state
> > 
> > Then the series basically boils down to adding some 'modify counter'
> > driver op that flips the enable/disable flag
> > 
> > And the netlink patches to expose the additional information.
> 
> Maybe it can be defined like this:
> 
> struct rdma_stat_desc {
>         bool enabled;

This isn't quite a nice because the definition array can't be setup as
a static const inside the driver code. You'd have to memory copy to
set it up.

> What does the "private" field mean? Driver-specific? Aren't all counters
> driver-specific?

The other patch had used it to identify the counter

Jason
