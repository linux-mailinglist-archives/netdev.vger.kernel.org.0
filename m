Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496C83F5EBF
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbhHXNMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:12:34 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:57147
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233952AbhHXNMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 09:12:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBmvFrwT++ED9giZOIfMfuAfLPvCyNCDMbD4cgutaZ/gEdKFmUNVhnjSy3nyIzqY1BCjkkbDnF0adWWgLAXaarjQjj01XTY5ip5mMemKjmqwgoijasHYYaCgqsa1DozmeayP9jIpkwjMLbH5v6sXXbVPM0mrDmo2vyhto9RhD8WhDXM4RujZ0IgqOXwpNi0RRuEbhjxiaogYGFKi6VavTwfTZ+TerCOkOIzyHpBIqOhxJbKD0kX4K7rtxGD5AzFwwRgV1cm7vapnngKbrD5n1NlYWvYmix0UnMia0Iv1w4/rp+wEVAEEELl3zcmpoX+oyCey0VCz1OmB4MUofQ/JRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHJgialJn5xrWIFZ8ArAMG4iLKCdb/rYXs7sk4Sqlxw=;
 b=aYidBK7EckAjIuQFsBnvC5Fna0sd6TXbicoEneruW1wNrrT+pkgVFGD8B/u+kQyUxHH6748TLX8FqSdFlex7rElYqz7RjK5HIb1IY2saTITmeh0p0TL/jGTmGKfsZKsDJMWFfGrO11gDMBC91A+E4b96V8LAOJzWU9AOlcODOtescaE5CqCbmFcbstH8AYK10+4xLAsfRFw3P2RbgqVGtUHCpjjKYOU3yqz0THZBcnmgGtZFR8CTv3phjl+QPCg1Ybm9+A771NDi28p8W2VomBoGikVdX6HU4WCfz6MGBw/ifx1fEelLzSRqTpCzGhhPE3v0RxpA7C6ukaEg46vWmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHJgialJn5xrWIFZ8ArAMG4iLKCdb/rYXs7sk4Sqlxw=;
 b=Xtc58COk5GNhQHZklDkC6B5f5u5EnWEUchxK3Z69BI/d6YtTYr09TQteypxIz9o6Bf1gHTRnEB5JVy+qrV+FvLqDHFYf3LT8OmqfeEHraQcz4JXMuJby9gjvB0UI+14Qgsc7RuxWbq/EO827TAte0DHCJko5TFoBx1WI4+tG+hTZv6Okhwb8YtsyPRguAh21fJCgKw7+FpVp0e4gabpl466NU5XwQSi+ZfzWgzmWo51xL6726MhxJI4bkL/lZIaf7hviH+sfprpzXwEq4dyIE2AzGvMeNAzxVtVJOnvfFYcBMxbi4cPPu1e0T5A24lB1hMGfvDfK/eSGxYZkU5156g==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 13:11:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 13:11:47 +0000
Date:   Tue, 24 Aug 2021 10:11:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 00/10] Optional counter statistics support
Message-ID: <20210824131146.GU1721383@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210823193307.GA1006065@nvidia.com>
 <36e3e090-2568-4c7e-868f-673ac6eca7f9@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36e3e090-2568-4c7e-868f-673ac6eca7f9@nvidia.com>
X-ClientProxiedBy: BL0PR1501CA0022.namprd15.prod.outlook.com
 (2603:10b6:207:17::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0022.namprd15.prod.outlook.com (2603:10b6:207:17::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 13:11:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIWDS-004SJA-2b; Tue, 24 Aug 2021 10:11:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fb817cd-eae2-4451-2249-08d96700ba14
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5303F0C9F401B7FB7C8F8EE9C2C59@BL1PR12MB5303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEOwEh3750b1yaiCzt3RvVCnv34OowP1TDAPD6NNht7Dyay9jfhOrRko6KH0e2NQkVJlO7zX8hwPm60bXze/XAw8cifglf7Cc74i97prpRnQDDBq+flMmqHPktpHksSbPncTqMs9f2lK34ZiUzGLZoKKo0L8cFMyl8Ij0Cc5SU9DynJIjJkj6+DddM3tBy+KXvxH/KHK7bFLxKo9JfRPywvK7bv3afROMyT0+76W3J1Gl4iY19C3QIBG174jmcDK6DwWv2MvJA2yS9a7HcC5wuxnoExJtdu31AMX7jPzcw2nqX+MfiDxUToG4W28UugwXimlrQCxCFux5WlovKS+sKrE0z8jH10SoBAhjvQNXg2TIp9eL+nW7BhncDcJL1fIa5GGWqymu8/QZfwENDAZT3VjYv2S/L0V90EWR2PeOux5sgkURYIs0xHhOZXoGy1BYcF1O9j3234cjFYQ6SS7zZxBq8b0dkysStbwSAKU+qVH1LMID6MqmJokiF0GoODJAewCp9ba0BB69WfHSHvOCK8uAZsGgf8FZDwKNhNotF3SOoCOdciWM8DVKknV24IXcNWHvbz1FhcfdcrCSs1ax64Pd+xLF45s0JntSoV9uxvzvJmkt/V2YwlEjOm3prT2iu5wq+pdS1ShGUh+x9S+IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(86362001)(38100700002)(1076003)(6862004)(426003)(36756003)(8936002)(8676002)(66476007)(186003)(26005)(53546011)(66556008)(9786002)(6636002)(2906002)(9746002)(107886003)(37006003)(4326008)(5660300002)(316002)(66946007)(33656002)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eKWMenfI8LVx8sEU0vqLSZz4lclJSgyQIQQGpO4T6jDlYyBldE+MXNVRjFpB?=
 =?us-ascii?Q?+rcdySkTT1rkiggErqPCvd7DO04nyIS3118bIAhtNCrqKY774pczmD6DX6ok?=
 =?us-ascii?Q?7S83sE1Km10nvdbBzl04Wa7yN2vnI5NVSLaM9o8aoGVdCPq2JHlx5Ckd6g01?=
 =?us-ascii?Q?zlUEWN01IUJA3JOdpajGFC3sR+6MEWTzbQHlYX76TFQOAVlggiTGpY6oYpwh?=
 =?us-ascii?Q?48ybatM84+xB1QBrlR5oq1eJRc/VJiVEHT6dlY7jt5SBttw5f5srkDBFr7Tn?=
 =?us-ascii?Q?6EZEAJLQKBYsvs8MUKalCu/ZPH/NoWuH++W6ezj+jP0ILj5R4Va7+qisuayY?=
 =?us-ascii?Q?9TPbII74ZRba0nA6hYE0uEdLekXjwzr7//GQt51dU8k6X/fRRjkGv+oiZ/mG?=
 =?us-ascii?Q?fkUMKyHnY2jRWNlp19DTQWFyS+rtNoJbNH5gsyJH+pgMKVLzK8adRGsI8H5E?=
 =?us-ascii?Q?KkB5+CgwjEOUv57sv5OPa1zUl93VFNnQNaxYX1cKaBCIolp9XLblw9Mn0x22?=
 =?us-ascii?Q?AydBEzK+1/uqivJaS/U1J/a5Z8fyo+sQwwMx4jq7tThNNdCgRhowPRU9WvF2?=
 =?us-ascii?Q?baX4BLcJbcAVGwL+/XiJ8QAfygLXsfm2U9H1s0dnheKlndsozsmgJfK7ryBa?=
 =?us-ascii?Q?1qV/S3LdY7VuK+yKQ98UMnp1awPLHpOH8fmrYYTeeWsnK0tAgHE69Pw3IopT?=
 =?us-ascii?Q?UvEo/OlW3N87kodA+MHdESxrZLMDmGHucRJyB9r2H7A2t0ooHoIusBD3hiMz?=
 =?us-ascii?Q?wexWbgi7EnqGMviKwbeTdBxYq2oQMxynX9nFdL3369VU1Jcx3JMfQc0rlfiZ?=
 =?us-ascii?Q?/eqexOFqwnE8ZTdQmxAyq9cRxcVSTOQzV74kDzlIWjFXOaxd9Iug15Q6Hzs1?=
 =?us-ascii?Q?QspNvaWATWEZpxJwBj/k6JLZsUQVhCtwgv6Kc9g7miJ8uJOK03SMEbwF3Xhg?=
 =?us-ascii?Q?/4crMCqfOOblu5RNjyG9kKATlAAVOX8LDMpiO816mNQ40l7BSJWQCGJmA1J1?=
 =?us-ascii?Q?uq70sdBvqh+eGhcxxw0SbBoEk0/amJJPGDxa5sUgU3JJnUkrnwKwAnJ9Ry/I?=
 =?us-ascii?Q?rWh7xgnjoVSvUglBZp05PmngQJQOqHTW2HYvdYkXerhjGcdjIt0FHirMOouZ?=
 =?us-ascii?Q?6W+wNGLG/FkpzfKvDLwKLeInMrS6H2G0unbgCGpj3NTFE5FkOAelW5UjZULr?=
 =?us-ascii?Q?DP5xn7odnJBOxnEzk8KndBceoXSr5XFRcR0Q1vulFI6QjRz7zJrZakGHiBVf?=
 =?us-ascii?Q?cFWWN/hTJ1DrmHd+VjAdvREaKC9g8zxYSb1F0Pn5Pe6CBijSE0MHQV955Pvj?=
 =?us-ascii?Q?fHctGHhJ68hEGHmqDmE84C8t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb817cd-eae2-4451-2249-08d96700ba14
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 13:11:47.1050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ei4Rtr2sAf2muuBzRIOWMM8H9rjfSv9+Elpu/3ZYfsZzrSd3Fo7Dfm//jseezhoA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 09:44:26AM +0800, Mark Zhang wrote:
> On 8/24/2021 3:33 AM, Jason Gunthorpe wrote:
> > On Wed, Aug 18, 2021 at 02:24:18PM +0300, Mark Zhang wrote:
> > > Hi,
> > > 
> > > This series from Aharon and Neta provides an extension to the rdma
> > > statistics tool that allows to add and remove optional counters
> > > dynamically, using new netlink commands.
> > > 
> > > The idea of having optional counters is to provide to the users the
> > > ability to get statistics of counters that hurts performance.
> > > 
> > > Once an optional counter was added, its statistics will be presented
> > > along with all the counters, using the show command.
> > > 
> > > Binding objects to the optional counters is currently not supported,
> > > neither in auto mode nor in manual mode.
> > > 
> > > To get the list of optional counters that are supported on this device,
> > > use "rdma statistic mode supported". To see which counters are currently
> > > enabled, use "rdma statistic mode".
> > > 
> > > $ rdma statistic mode supported
> > > link rocep8s0f0/1
> > >      Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
> > > link rocep8s0f1/1
> > >      Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
> > > 
> > > $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
> > > $ rdma statistic mode
> > > link rocep8s0f0/1
> > >      Optional-set: cc_rx_ce_pkts
> > > $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_tx_cnp_pkts
> > > $ rdma statistic mode
> > > link rocep8s0f0/1
> > >      Optional-set: cc_rx_ce_pkts cc_tx_cnp_pkts
> > 
> > This doesn't look like the right output to iproute to me, the two
> > command should not be using the same tag and the output of iproute
> > should always be formed to be valid input to iproute
> 
> So it should be like this:
> 
> $ rdma statistic mode supported
> link rocep8s0f0/1 optional-set cc_rx_ce_pkts cc_rx_cnp_pkts  cc_tx_cnp_pkts
> link rocep8s0f1/1 optional-set cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts

Each netlink tag in the protocol should have a unique string in the
output. So you need strings that mean "optional set supported" and
"optional set currently enabled"

Jason
