Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5985A27B9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343996AbiHZMXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiHZMWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:22:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8D026554
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 05:20:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTJmTvi/6MhgkhmfUZ6uVN5HmLQfevx8rMOj7d0kWv1WOr3bg5LNrdy3L/sj62seTeVZxOT32JrMU23Bn1C2acp4v0Q+SlQ8jphfkWLPFMgo8ryZMr+ePsEpXYhDKNX+cA7Ab9/ypbzIgxsEllpul9P10H8XXym1rKQF407WItaU3I40zYNGif/oS8NF8ezvwTZzZJBLXwGzh2QxfAbpyxzhBJUMiB0Tl5OgIOCjzYwsyTAl7Tgo/HXvF7gB5xj23rNOXOr1sanHP0JHNRCOlfs6Sj3vKsiMocbwBxsASU5eCt5PSCr6/rLV4QQq05SGaQd564D/TyjvMlyK9s8EOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/ZiSZvx7xWeLKUztvJfUmNvIgimfOe3ioxcYovUZMQ=;
 b=UdjsBIS0k/R5NKQbYBg7ShcXBpqMybuU8rKphrL+JUuzBvkM1gSCEixRCNgKrOohUDuKLa9GYWUbogdc6tRg79dJs2UJna8c3yrbWbwf2ETTWMOizZB+qecgjpflF/SY1v8W9/y6H4cPmU+jZCwJJ17guzmvhdP8hrsJJ2ebYgS+TAO696XW49Iay7sof7fjdsJzTBNuvVqkg9YRRFsPFNTMPQhOQjma/qUCJRF5oH6ZxHZeyHkqYtTGUjPJFzrtXbuBSVgExSNZ9fkEYGdcSTUXFRMkaGmpMV9BlpTi2BcAzlYNsmCTEPToKlngtfQ0XFxrCm1Li0Wvl8ymSdNOJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/ZiSZvx7xWeLKUztvJfUmNvIgimfOe3ioxcYovUZMQ=;
 b=oULpn2cgpRYu6wTfMjE62XZPQeK4C4BZfAVgB4/5NRSm8xDBm2fhe+3dgMLWk7I2nag9Vu3M/JcToAHyDIEzrWYWgMSfO1xRXa6r34mWX3bqFl1gJ0kuci5Kw/b7qR1yG+UoNAsbcGBfieg7Lla9oVyKKM7Rbzoj885nTKBVplJWjrS97SYNPMI7bELmUMFJeYN3unE6NDJbpz27JDUe1qoQlGdcKxXMkj3ukPE9Hokle5U60JfnqlgnTEvTTMu91KQSwv4srrKnBmastfsHM7JKPxI1iAsn3ytVpx63jyo/7NPtRlNnvizQk8lhqNUaUlzWdHeUpkNRz0NfGae5mg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0140.namprd12.prod.outlook.com (2603:10b6:4:57::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 12:20:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 12:20:57 +0000
Date:   Fri, 26 Aug 2022 09:20:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Ywi6qA7EsBJwEa5x@nvidia.com>
References: <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
 <YwNEUguW7aTXC2Vs@unreal>
 <20220822093304.7ddc5d35@kernel.org>
 <20220822212716.yji3ugbppse7snfy@sx1>
 <YwRcJaythk/kM5Kf@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwRcJaythk/kM5Kf@unreal>
X-ClientProxiedBy: BLAPR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:32b::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02b63c7e-a7d2-41bf-337c-08da875d6dbe
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYRCNB0sJ27yNGCReniBpeCF2hv8HKObmtMOco2dzGK7n1py72gRdNm29mm356auiQxApUQ64EkopyhvWGTLOXGx6ZYQPGG6vc7OmlvqAxZER9NsubdsFIjXVgW3whLCWR9aQgXAbEpJ9ggvEMTiXP3YdIpVQE/zxCKKRhjFJXVXUC3RBEZjhiOfeRyW4B7LIRLLbxrBl+2WME2r205mE2rXysUeUx+P84E6dstNKT+8KDhixwXw6oEB2dg4onecIqvwWM1ZeaoWh5vOAiO3jskZXKxLPHcXA5JGzeoFCBVJZOWdLBVlsYM5Zcefi/Z/5TUdeSOgeReJEx/4ZwaIPlqiIhoVeC58QlfoGEz2BcKfT6YKgDqXd+dYz9CgolfpC3RxzU4a1dSwcjRrwZoqx83FC0ni3Jd/VVG005pudmoyGMHjQlfopLAiYQCMmoZnOMYQxAle5YDnSgFICoFQx9KRo7GsTyVLosdjsUfm87oUSevRm7vybuBfVa3EQd6eITjSw98NhFeyA0kfsEuBq3xXp1YcSzkHXucluTSI/ghzRqIUGw0mSsDoDzjn7aq87c9HyhlcnoyPWPZ0KPJxi+w0RKtDuych7hJXombMTqyX1eVgeAGhfSdvhGs7lD/Z2RwL04uWXwUdgTixwUoRIpllBps6f8cwIqijq29E/LL73EEAXDIztvoygpSzUjvNdyiodeJlHRQUqTOkgB7xiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(2906002)(2616005)(6486002)(478600001)(8936002)(36756003)(5660300002)(86362001)(66476007)(186003)(38100700002)(54906003)(6916009)(66946007)(4326008)(316002)(8676002)(26005)(6512007)(41300700001)(66556008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nGyJNhQVUC+z569syUkm/khivXvZF5sZEaQcBkJBfPd6WnT+dkzafDQp1D48?=
 =?us-ascii?Q?SVXI32P9V+YiAQaPzSrIYD2MBWp2aVh5hwHbIZS5BgbLJUv8MK/FivjgUYek?=
 =?us-ascii?Q?BNXyKIPmf1lLZSLEIlqhiIvNFpH8mqXXteHS+1CwtSPyAmQrnkZxE7WvkUgu?=
 =?us-ascii?Q?S7k67VYHJVT2lqL3Tw1s7KJDWZhmFsxx87xWYIfTH5q+Udicy7rsd/HXLpkK?=
 =?us-ascii?Q?0E0efPUs0qeDzLBzqz2Sd37azA5H+pdZ6ub1A48ZqEGL+WutZsI9/yLYYgM2?=
 =?us-ascii?Q?JVu+rKPi0iGjDl5jlXR9iZu/T3xpWxJqcleoOpoup/efxNX0gxAaK2El2ZUK?=
 =?us-ascii?Q?fUY1hXWfWFYM4xnkENPHZESmS4V7q9Q53YumZTdWf1pup05iGZj6ZsfaQWLi?=
 =?us-ascii?Q?y93jnpXhh6sYKM1M6xk8FBH5Thb8zdwUGO+vm/GsQX5KXlVL2Mqzx8voDzs5?=
 =?us-ascii?Q?0zgX3WYimLP79d5xcAf8bFuJekyYN1QSslMiZYFyJNjzMMbUtFu8KwDnsCQr?=
 =?us-ascii?Q?D7IWVmaQ1MGKUKxVELT9Zx7NAkf6NmM+fgP12BfiFZpLzaop2rvmQwbah497?=
 =?us-ascii?Q?cT056PYxOVq2VB7J2L5XTQgWDo2/JsQIFynB4j+ILRG3T1urs6pxrSHkRNsy?=
 =?us-ascii?Q?9AvHFJTt/GYQR5K6vulwWrFVn02MjjuH0TOXR9P4uwqWYJlKaM3svdSf0nLN?=
 =?us-ascii?Q?BBFhrMP2K4xXgw7C/07jzvMiLaONklf25ATvgDAQyuODxMtSx0i+f/lD+XUt?=
 =?us-ascii?Q?2iaH+Yf1C2mbWLEs65mcnovvXho0KgolqxswCinpGMpZhbz3ET9ah0TT9l5B?=
 =?us-ascii?Q?Rj8skMYWDvVOhcJ3PhNblFt3io2QzyotepuLufIgO+Zx+Y6ocOAFSg54mGqs?=
 =?us-ascii?Q?3h3rX6iKszfMcBwmebxZpeVML4mpVwyV+mvsFMB0V8c71es7HhL8Yw82X6A+?=
 =?us-ascii?Q?0eAeP51ERpMhjmubENyj3RORsB9cxFQeZX8Au9zL431ol6YruL0SsCUv26OX?=
 =?us-ascii?Q?TFmeo3FGF9QMwq117R7SQt3yGIxZ2P2TkkAKSkBxffxNLm9+UgIT9bEKGm55?=
 =?us-ascii?Q?9G9L8kda5qPrB04+0Nb5QGpzpSnMJxghS+y0gJ5QvHDrL+towSx+b5nc+GhL?=
 =?us-ascii?Q?ehSJ/14OvSq3xRXXFquw3cbXW0Y19HCxL4InUVSHk6MorzCz/cFlykYG94ZY?=
 =?us-ascii?Q?H9w10VdbZS7CzO0neP/vGcPwZgeDWiHfl8JGxJspKYIlMDZPioL7jC/0kUrn?=
 =?us-ascii?Q?Ky0IUv3lAnglec4kIpBfSbP+4FoeEssNVQYYaI9jDTEv3f3tODJk4gLvWe21?=
 =?us-ascii?Q?iFhv41p0Z22Yzc+wcH9kv2YJ6cLMv0/2Y2O8MmdWknfifXACfqkcH692NwU2?=
 =?us-ascii?Q?sF4DBz/FXr9Zn8D4wAJj0su5eSAyjZ7yKrPVISi2wA3Jpm3KY2XzyUlR/EoU?=
 =?us-ascii?Q?KLAiGHdUlZqTBytStAarvY0jn6yAZE4LPeDnmr9Z6N5XUmtKEcVWgCtdcCNz?=
 =?us-ascii?Q?o5a3Myt7pjGVZrNyRZanodoEpJyfHPFRLdJLYiWEvDVjMbJnTnITxYSX+a8K?=
 =?us-ascii?Q?+Ga5TzPwZaocI2ypnYQxyC/ppiy3XdybV7txzXIs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b63c7e-a7d2-41bf-337c-08da875d6dbe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 12:20:57.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvKbXiE2SaOkZ2VfE0n64vT0N8oyFHzpXh0ZdaSqYlVXS83/HOPeGZUCVd95LUkO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0140
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 07:48:37AM +0300, Leon Romanovsky wrote:
> On Mon, Aug 22, 2022 at 02:27:16PM -0700, Saeed Mahameed wrote:
> > On 22 Aug 09:33, Jakub Kicinski wrote:
> > > On Mon, 22 Aug 2022 11:54:42 +0300 Leon Romanovsky wrote:
> > > > On Mon, Aug 22, 2022 at 10:41:05AM +0200, Steffen Klassert wrote:
> > > > > On Fri, Aug 19, 2022 at 10:53:56AM -0700, Jakub Kicinski wrote:
> > > > > > Yup, that's what I thought you'd say. Can't argue with that use case
> > > > > > if Steffen is satisfied with the technical aspects.
> > > > >
> > > > > Yes, everything that can help to overcome the performance problems
> > > > > can help and I'm interested in this type of offload. But we need to
> > > > > make sure the API is usable by the whole community, so I don't
> > > > > want an API for some special case one of the NIC vendors is
> > > > > interested in.
> > > > 
> > > > BTW, we have a performance data, I planned to send it as part of cover
> > > > letter for v3, but it is worth to share it now.
> > > > 
> > > >  ================================================================================
> > > >  Performance results:
> > > > 
> > > >  TCP multi-stream, using iperf3 instance per-CPU.
> > > >  +----------------------+--------+--------+--------+--------+---------+---------+
> > > >  |                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
> > > >  |                      +--------+--------+--------+--------+---------+---------+
> > > >  |                      |                   BW (Gbps)                           |
> > > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > > >  | Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
> > > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > > >  | Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
> > > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > > >  | IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
> > > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > > >  | IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
> > > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > > > 
> > > >  IPsec full offload mode behaves as baseline and reaches linerate with same amount
> > > >  of CPUs.
> > > > 
> > 
> > Just making sure: Baseline == "Clear text TCP" ?
> 
> Yes, baseline is plain TCP without any encryption.
> 
> We can get higher numbers with Tariq's improvements, but it was not
> important to achieve maximum as we are interested to see differences
> between various modes.

BW is only part of the goal here, a significant metric is how much
hypervisor CPU power is consumed by the ESP operation.

It is not any different than vlan or other encapsulating offloads
where the ideal is to not interrupt the hypervisor CPU at all.

Jason
