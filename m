Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14413F5148
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhHWTbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:31:09 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:59713
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230192AbhHWTbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:31:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfdrBDuWNJomKgHUGZq9GEFfrfpBFvnQDLltDdfN9hQER88YkaK1pZxt1Ma1efp0Ytp2wCrrn1LoVVZrI/qh+PoZoxUDXbnRwGx9JKdXWTEjgs9GyDsMivF7S8SXmYMF7qxxh8SDsWId7nQoDaWarbbmsR3EnPM9OVx26l2r7M6277vEmvvRipCQxcApEnImmcY0YOnkukNy4ihGwkljWshwzGoqwYbgrzAau84Zk+DXq4FxfmQRyolgmKbFgS3bpbTPAe+neRCKNT3wtvBubEzNGQ4w8mZQvd9vQOiFFRjnapOyUEqgsAYAJxjlX9bkAVEtXi8Kcyc6q1OsrGV7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+D8GO9PWrqPVVueR0PhUgmStBBXojT8qus9bzV9a58=;
 b=V7JsOJmrSkwSLlSj1wsHC6GbvcQ98wk0va4fLI/7ixlpbWxOXc6V9vlkTai9TtyXek1bCcYI1oI4ViJFajiTC3uIGPNEczoh7/812A68UvVZk2LBjjxrCVOvFGlY+XK5jMu/txOXdXv2mvlFVkreFABKxSnXXa7ZQnOSmuBNNt3H042hzHTyyskdEAA317QPWVeB60wc+wfo1lr2MArO+VGYZh5iirDw0nT0Q+O2aIL8trzft3++d794pJKUH4g1z4Prd3yKbG9eYGfw2uvCyHDgqhbZ5lHpDlTKr4teAVwK3Lv2gujq3E7wziFMgaxYDyWKUj3PgBNm3b4sIIw2uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+D8GO9PWrqPVVueR0PhUgmStBBXojT8qus9bzV9a58=;
 b=Q0o5ta2EBwbTUK/sQEaEJiMZcWNMU15aZBKZf9Aub0FLj4gY/Jqoiaz6/5gN0Sn0qLMX8LEEnQWirl2rF79ubsHZ+ve6Nt2X5gv6iiSG+ovB4fSawJUVH7PIbjTAz3hAFQgwAZeVxPwpaEWVX8cIYBDrRoZuEUgaVdzP5cZwKZBDI1iacs3oyZdssO2E69OO0lFkUOaGxOVBm+dgz8OxMENL7LVq0DwxlpfZZ1feE3jL9+687pgOPWDTtgjsWMmw2/lITYhNSMwgVpRf/xWceFITTosNihXjwRGXqvpt0LYq1WbIRoNSu2KJmw+T9DYCplmSdKzwACNbfvcQRXB2xA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Mon, 23 Aug
 2021 19:30:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 19:30:21 +0000
Date:   Mon, 23 Aug 2021 16:30:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 03/10] RDMA/counters: Support to allocate
 per-port optional counter statistics
Message-ID: <20210823193020.GA1002624@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-4-markzhang@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818112428.209111-4-markzhang@nvidia.com>
X-ClientProxiedBy: MN2PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:208:fc::41) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0028.namprd02.prod.outlook.com (2603:10b6:208:fc::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 19:30:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIFeG-004DiQ-FL; Mon, 23 Aug 2021 16:30:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbed2727-4640-4548-d62a-08d9666c7294
X-MS-TrafficTypeDiagnostic: BL1PR12MB5269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5269BF6667986C3F3AF29CA1C2C49@BL1PR12MB5269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yw1gsBlCd2Rt1xXdy52KNGFQXvQ/7PYUtW2SHumzilClMzDrhKqNiJN8a1CRFHj9oDG8ZzrxDV4yornNk5Ehkoj0eb348T8LOC30yIMIQ5X9xh/2KYTwP6fgGccL98SNSx2eDWcttRHxwTrU9fbOqI0pMbhpaMx5AaujmwJuehsFub9dVDn7TKnpYTvRLbEMq2NKFAle21U+oMYlPeJYt2Gsb5Vsz/NHfhrvRJuMQowAuqqlTw59bMvdz4Qg2k9vH4ui/GX/au+tpPBIsheBVP5iYqBtG0DtaPzl9FcO53+GExtHh545crlXgspaPqZHltbt6+xkQSs4ulass266rdMIaqlROMl5esOhHxF1CHCLdX6S4ShoBy7vvWzZhyzd8i/fGmd/qIoPdVz6bZKcw8zmHGdSwlZgTprviWxbLCvaAMm3cKVKBkkS38DgetD0Hx7zM34F0nk2sbEOzVK+SftzlFSxthoVFE0PPP967gRBM+5zLd+5swT+ZBuymKsTQPPXAa+o2LjkKBMMEyTNAqWQ3hPzi2Xr1cfVRuoDfZDzx1nYMTVsjl/vnmSWDU5LrNxROcjYwzLNzSwIn6we0i6dVUygsjWrOK8OehEmLTe1dfuH8ar0c2H/5yjRhATQAKDXoei559BsX2znBLnVuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(426003)(6862004)(8676002)(316002)(33656002)(4326008)(6636002)(186003)(2616005)(107886003)(8936002)(478600001)(5660300002)(9786002)(66946007)(83380400001)(26005)(86362001)(37006003)(1076003)(36756003)(9746002)(38100700002)(66476007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ri5yAcfATYxElBrHvtz5S/IYeJVJd60nR0TbmK9YGBUT76QKk6sG9VdUXLb4?=
 =?us-ascii?Q?WorE1Xw8pvUxeaSvV1m3ep0cxZQzAcoH8U7g74ayCCHVHMeHTzlVRWHl3RsB?=
 =?us-ascii?Q?KA2NMY10w4N6YeCWvHy9jD445DgURI6P0DQ5SPhyVKIBci63DBbJx0CsDz9B?=
 =?us-ascii?Q?KuGttSUMvden7993llSHCLWtjYV4oy5c76EN//fznB+gIgkPgR/MD7APo2FL?=
 =?us-ascii?Q?zXX7P0C09/J3e19iLkJRbRIaMRZsFF7Sa8758tSOSjHVinjCbFtWZWDPplkV?=
 =?us-ascii?Q?ewLaC7u0ofHN65+HYkrRnzTZryklyhwajLLQs/UlZRwruF3ELmRriPhwCUCZ?=
 =?us-ascii?Q?Co1Yh9Ue3J1XOrvLOCPQJ0fPwATyBWwzRC6u+VPUPRqz/KjMK/UtRwEKSu/h?=
 =?us-ascii?Q?H+6NocDvlZCALUqkm22iobP6uamWYxUQMoo0RfKSH0E0Sg57F8OqMcOObS/c?=
 =?us-ascii?Q?7Rk1WdsJ9l001PZsm2fatwDZ+/tMVqs6jb9zB6e3Ug9gOLlUEJKxfRkLi42H?=
 =?us-ascii?Q?mgL2wcuO/b+Ua7hkAd9V9EV0l/E8NuiwSRmiQ68S3zCPueKh4bTi4GoVfHMG?=
 =?us-ascii?Q?BMuvf56nWFJlOymSLSZgbi/pTgQrrTIkYO3BZ+pBDyQR6XaOfkak+v1cifWc?=
 =?us-ascii?Q?MDsmqc21ucPvsSb3F8gGJfa8kQi8mfDnQdcCBAcZ//HMXQg2DII8eRKECwi6?=
 =?us-ascii?Q?E+wsuIWdBSXSHtcYIIQNPgIEDWldFTlnd7EjyoDVM8CHrwkb/VfWjln6BM+k?=
 =?us-ascii?Q?4DrfU77NI5FfK6L54H6/lAMqWJMWM92spk/V0H8vMY+CA5h0Bukr8A5rlWY1?=
 =?us-ascii?Q?nibwZGM8ByfWqonr09TRspdZCTlkYLY76QCw7oJ18O3SAvRkUpC9ctNmRpni?=
 =?us-ascii?Q?SVkBQ3HFBkhQOwdjbYLGV81wWYdFPpzvOwjIim21iKpraPHLgOdREz7wvk2J?=
 =?us-ascii?Q?awuA3HYjNJPURmG7V6Vk/Asn18gAYRdczg0T4n+DaDvoFK3+ltFXfW4UKC7J?=
 =?us-ascii?Q?qVM/LYyY7Pk6dKSRnSV/vWxoR5Gs0NzsDa/tVYPswdz0CYn7r9G+VTuDQVqY?=
 =?us-ascii?Q?pjDeWcIS3Puk/Xk7acDk/43J8t5lJyGAatsFZsqh9+QwfYR19OgCHg6fufL4?=
 =?us-ascii?Q?p+Gd4f0FEgLkQ+MBMCBPCVDTNqK8AjZctX0sFndM/RxqKklvA7yvPsbZH+9k?=
 =?us-ascii?Q?xSnvt5tUSQGc1mL6jAPw6iVulp+RtNx/Cv0TUuS1O6DGof/oXATxEQiYypb6?=
 =?us-ascii?Q?qS6c6MTfnnq/Ir0MTWMONYFw0UkZWceRyMgYActQ3uLgIdjCNhEXdfZbLuDN?=
 =?us-ascii?Q?U8BvD2IBrEa9ETxz68xCowqd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbed2727-4640-4548-d62a-08d9666c7294
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 19:30:21.6674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJ9aM2oehK1QYEaAaYPMLWos8qX/14gG2GMCknvmBDey3B2/wPKyasGpRvv6u2yW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:24:21PM +0300, Mark Zhang wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> Add an alloc_op_port_stats() API, as well as related structures, to support
> per-port op_stats allocation during counter module initialization.
> 
> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
> Signed-off-by: Mark Zhang <markzhang@nvidia.com>
>  drivers/infiniband/core/counters.c | 18 ++++++++++++++++++
>  drivers/infiniband/core/device.c   |  1 +
>  include/rdma/ib_verbs.h            | 24 ++++++++++++++++++++++++
>  include/rdma/rdma_counter.h        |  1 +
>  4 files changed, 44 insertions(+)
> 
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> index df9e6c5e4ddf..b8b6db98bfdf 100644
> +++ b/drivers/infiniband/core/counters.c
> @@ -611,6 +611,15 @@ void rdma_counter_init(struct ib_device *dev)
>  		port_counter->hstats = dev->ops.alloc_hw_port_stats(dev, port);
>  		if (!port_counter->hstats)
>  			goto fail;
> +
> +		if (dev->ops.alloc_op_port_stats) {
> +			port_counter->opstats =
> +				dev->ops.alloc_op_port_stats(dev, port);
> +			if (!port_counter->opstats)
> +				goto fail;

It would be nicer to change the normal stats to have more detailed
meta information instead of adding an entire parallel interface like
this.

struct rdma_hw_stats {
	struct mutex	lock;
	unsigned long	timestamp;
	unsigned long	lifespan;
	const char * const *names;

Change the names to a struct

 const struct rdma_hw_stat_desc *descs;

struct rdma_hw_stat_desc {
   const char *name;
   unsigned int flags;
   unsigned int private;
}

and then define a FLAG_OPTIONAL.

Then alot of this oddness goes away.

You might also need a small allocated bitmap to store the
enabled/disabled state

Then the series basically boils down to adding some 'modify counter'
driver op that flips the enable/disable flag

And the netlink patches to expose the additional information.

Jason
