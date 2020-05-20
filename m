Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B0C1DB3B0
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgETMhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:37:36 -0400
Received: from mail-am6eur05on2059.outbound.protection.outlook.com ([40.107.22.59]:64224
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgETMhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 08:37:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECmlOBzdmcAmJtxWQQZ8fkFTSDU3MHxxJcS+K0vNee8S2i9yyZWcUvDhxBJ1EBobrdTO4EgAgvsdWU/Pbwu4hE1qhXJLNDXDAMWuQdO3mPxYrR7gUk8tFSS9jdYDHqm5+F2s2Xl3YbOoKe42psyZ5tWjSNRO2U0cI/P0se9SfDL8F4kua+hE7/KFQmkBNwCYIBwEUARgSHbC8qGtBSoTdFCqHTd0iaPkwAlQH0g9znt9V7cEg/6I3iuRVXEciHj/7L8vwLBnIoKCeoPsjAIX8sAifG61E2KQ7+jd+3qneNamBfODs9uKdYP+DFt8IHpv+5jBn7qrl0SqX6i36soZ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMCb91jfio1s4snBJWA8lNBqXU9myTBhHPqDJkaLqpY=;
 b=LvgwlaYcZf94OywIYlOzwyZnUdU7fgqjXFTK9txfPVbVODF2SQZZ2mJG/X3XP5Bs7GrriRcF9JSpaD/PAQUlP8zteCgJ2yNSZAFASyivEJIesIB84f723tNGCgXfxWVrIopMduk1UKmz7Dm8d2iEpDghhAmPemdq6RSZSAOF7y9IdqQ1DyjxQ5p1jF9tq4l0dY3eDdCNnR6vJgIuzEwofH2mTgw2/hAZ8DlCUKyFhbSZRZuub3DVFsz/V2LwFqMYQjBpYFROVMcE+t7EyHKKVHYs5/x96R25qYpQ0sGTRgyyWwn0OZHiHrhfxUxdH0/qI0nzPSUvYBNl3bfJKFLfxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMCb91jfio1s4snBJWA8lNBqXU9myTBhHPqDJkaLqpY=;
 b=RXfb/ICE1oRDM7KwnUiwSXzPX32254AeQ5e1ZcG9m0WGsJ6+4SWO9P3VnY4/NiXag8ZOy8XejWZtyxuQY1eCwaoJBXDj5Q/8WIY0Uzt+Exs85soBY+dRC177pZwIEkkJlyh2tK89GKycw2mzLJBjR/S/foWvftxziPmxtIlEY2Q=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4862.eurprd05.prod.outlook.com (2603:10a6:803:61::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Wed, 20 May
 2020 12:37:30 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 12:37:30 +0000
Date:   Wed, 20 May 2020 09:37:26 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        dledford@redhat.com, davem@davemloft.net,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
Message-ID: <20200520123726.GD24561@mellanox.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-15-jeffrey.t.kirsher@intel.com>
 <34ea2c1d-538c-bcb7-b312-62524f31a8dd@amazon.com>
 <20200520085228.GF2837844@kroah.com>
 <a0240054-7a5c-5698-d213-b2070756c846@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0240054-7a5c-5698-d213-b2070756c846@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:208:23c::34) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR18CA0029.namprd18.prod.outlook.com (2603:10b6:208:23c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26 via Frontend Transport; Wed, 20 May 2020 12:37:29 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jbNyQ-0005pp-HJ; Wed, 20 May 2020 09:37:26 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1b510e8-b200-481d-aca3-08d7fcba8f87
X-MS-TrafficTypeDiagnostic: VI1PR05MB4862:
X-Microsoft-Antispam-PRVS: <VI1PR05MB4862C8B405BE6424B9CDBEC1CFB60@VI1PR05MB4862.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0mOIo+lvROjB4lqEa3xefgJtOZWqmVJdm1Qa2qN7mbdKjFPahKSyNE84Y+LWZzqJl1/EBjnYBbsU+o2adN1Y3XJccf45ZUObT1dt4C3+BLD8fH+ply7pcUBZwVff4wnGl3ZWVCCSYNFVNPeETK9Wm0GUkZKBDiQJgMY7jNXjc9gp1uyvOZxnV4qZwR37e8V04E3t9F6IpfI14ykjiWIky+LFOcmiY9SQnxzxO4MZ57s9pIJ9HwTQdFuI9jQDBNFsxSiUC3er4eANmgygEI8CNE9mQ7BySmnQv7QZ1d153FH37V45upmugqZ+ob2pT9KwrIT3IGGeZqiGaUl9UR0rZyKPLqD1QyVp1zR6SddQi32CXqx5YV1sSqf1UP2PWOo5dlEFgJbMVYA9+IrGS919TlpuhvVrd1xktZf+dvpc1vPu/ZOIT2yRRtUyldnpr0t/mnyYJJ7vJ1e1KDMyJmvcC6efKT0qxNRo+tZagOHbcEsQ2GWVYRimZGLSBqaoT0u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(9786002)(66476007)(66556008)(9746002)(66946007)(316002)(2616005)(8676002)(478600001)(52116002)(86362001)(6916009)(4326008)(33656002)(53546011)(5660300002)(7416002)(36756003)(8936002)(1076003)(2906002)(54906003)(186003)(26005)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aseLHBwZX41P2WQtwRjfglwn+BRuI9tI9XxzGq9w1rFUcXKjJIwYlb62K3eUYThhJaW7KAFu/luWzAL4VdI1u3FMGVFw+ATowePTAHl7ppyXH7Cuk2TUZhxZpJnSe2ADZQPPWMzLA3hECTaX9ZzHtNL6BE8qtV6zmrloGAEPGct1E1/5YRzlj+40F6Rj40LLhI8N2ndGVa0it3T8QCBpGTqKWuh9XzYqnsdpGsTXaoGjGm8QYwJH5sS0oKCZ+NH8XLIrw6zlYRpBF5AH4KvCtQuFo1tgosEGx6wlWGJ6N1wH+ccdeOPC7jjeOQA/SToJ7LyqIl+60rTrX+3FJFE5y2nkLrIr7wYTFtFkrmgojlPyK2UJrltG5qWaZLegWTElx9cT0WuQHev/Yt2jXqvHbH4rI9ky3L8Wg0bMdNYuWZ2CqahFGYb24KMr/EbVlo0apD/cvANlwhaJCvQPm7cGvi8uPmdIKGV3+HMSfclPTzs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b510e8-b200-481d-aca3-08d7fcba8f87
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 12:37:30.0683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: go4OKJrB57a08WbhKXsMfJeaD2P8uGuGgw+0N2w34JrY2zGOiOpeH0+kuol7xbFlOrM/OFiEfX3K+hhbtnqqjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4862
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:02:35PM +0300, Gal Pressman wrote:
> On 20/05/2020 11:52, Greg KH wrote:
> > On Wed, May 20, 2020 at 10:54:25AM +0300, Gal Pressman wrote:
> >> On 20/05/2020 10:04, Jeff Kirsher wrote:
> >>> +struct i40iw_create_qp_resp {
> >>> +   __u32 qp_id;
> >>> +   __u32 actual_sq_size;
> >>> +   __u32 actual_rq_size;
> >>> +   __u32 i40iw_drv_opt;
> >>> +   __u16 push_idx;
> >>> +   __u8 lsmm;
> >>> +   __u8 rsvd;
> >>> +};
> >>
> >> This struct size should be 8 bytes aligned.
> > 
> > Aligned in what way?  Seems sane to me, what would you want it to look
> > like instead?
> 
> The uverbs ABI structs sizes are assumed to be padded to 8 bytes alignment, I
> would expect the reserved field to be an array of 5 bytes as done in other
> structs in this file (irdma_modify_qp_req for example).
> Jason could correct me if I'm wrong?

"it is complicated"

The udata structs must have alignment that is compatible with the core
struct that prefixes them. Of course we have a mess here, and nothing
is uniform.. 

In this case struct ib_uverbs_create_qp_resp has a '__u32
driver_data[0]' aligned to 8 bytes thus the alignment of this struct
can be 4 or 8.

I generally don't recommend relying on this weird side effect, and
encourage explicit padding when possible, but since the intent of this
new driver is to be ABI compatible with the old driver, it should be
kept the same.

The userspace has a number of static_asserts which are designed to
automatically check these various cases. I assume Intel has revised
the userspace to use the new struct names and tested it..

Jason

