Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D89F4253B0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbhJGNJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:09:46 -0400
Received: from mail-mw2nam08on2051.outbound.protection.outlook.com ([40.107.101.51]:9313
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241003AbhJGNJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:09:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdVgaTSxnDMDSWAcJgnRsKKcc+IqiUuukelsJ19W8WR7lvPX37BZB3XguJdRyjb8QasDSus/gWfp2+K8WQZahQU8Wsr6Mzk5lKzckYKBGdJghRKZLGg3MPmQY/EXataLCVfijtxS9WvAzPyAj2DeF7S8qEs+cJ0ZIO3Q6KGeDow+pF0eA4YawIxkkiuOaQd9m3Zf7sfjF8BAG7pKqzSrV/zMABn47Xmqlei+Bbkj5HyrFegprIpNyHRnwulUhwERNEeZL+/5eHBaTKl22yhNxA4leQwB9JKxnij3/wAkutkSn40W7OR/y7LaZ6KLl/4XAd8s43yv5sH8ToEvLidIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZU4F/D9psGWd7WUrXxGYUfU/U1R3PY/QC9pGKyRL6Q=;
 b=AsvoakZ3xN2DdhKCoxTntBATIngAWvJAdvuenVaiDP5y5VFhyGYYHitSFeNxSjPP8tnhEwX5qec18pZbsqPwmLAj5W99b1eYAXLEcxbxuC5XDpf8MJgiL3pzeiKvP/e5FR2vFyzzHn9ZQWWWdZzrsRrREYVII3B8uvKmFu0sZmqADEFaHSpzNJlMNYBxcHtiSiq/brfv3GnI62dUsYQMPZS1LuKtJzSKv1zVDconZYmceQVAYEmwjX8Bg/fX/vCUK8Y/a6lP7kSNth3mBiEmL2AZ6u9aEDaCR3etjAqCaKvSdDeaIh4AcVr3UH8jubc7eJLbKYd3ig2DeiCvWXEGkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZU4F/D9psGWd7WUrXxGYUfU/U1R3PY/QC9pGKyRL6Q=;
 b=EfGHc5D7EML+JdOk2haZVwwsE8cU0hoS9iU9EKP8KRrlfL879AfX7rUtrRHBwKyWFa1VMjMpv3FbtStkxPPILhy7MdunXZLmecOrYhi2+8woJ8b1ErXP0JPHoqHVpoKTF/1vLPW3Nw1VEpUj3YXABlyAWeYxF3d4A+IFbH1ILMKYptedTBz34IGJHhfD9lPeImZBIpj3s7LQxEdoiPMvwSCi9knKkTYzApYUdwqVD56jjmvGSfhAljI8Q2lXyz+slQzdfzt0eRQSH92wM4cQrpvDDoc8TYiKNd5sMvNJ1QkY6pjGkoDb2PJIbBaaFnwgzbqygZsd/u/oI1vSOpFEAg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5553.namprd12.prod.outlook.com (2603:10b6:208:1c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 7 Oct
 2021 13:07:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 13:07:49 +0000
Date:   Thu, 7 Oct 2021 10:07:48 -0300
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
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v3 09/13] RDMA/nldev: Allow optional-counter
 status configuration through RDMA netlink
Message-ID: <20211007130748.GA2834485@nvidia.com>
References: <cover.1633513239.git.leonro@nvidia.com>
 <aa5ae4340e68f1dab351a2b397d777396aff04a9.1633513239.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa5ae4340e68f1dab351a2b397d777396aff04a9.1633513239.git.leonro@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:207:3d::45) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0068.namprd02.prod.outlook.com (2603:10b6:207:3d::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Thu, 7 Oct 2021 13:07:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mYT7k-00BtQM-9Y; Thu, 07 Oct 2021 10:07:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f78c0ff9-a440-4ec1-f50d-08d989937692
X-MS-TrafficTypeDiagnostic: BL0PR12MB5553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55539020B41AEA939F21FC73C2B19@BL0PR12MB5553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HIpZW6zUK4zWA9yTAuiu7/t2W0QFzm6DCLwwUK56rAuFXftv93unF/33OY0PiiZfLDEjipLhrAMjXLDN0BqnuSzLAgrqcCQl6nTvTLf5DI/aS02lZpdnAFoybLppmmf33lP4q+z1s/9tJG+pV/AX9iocSj7ZhEvFqsQ3oIeK34b99LODAu9C+Vr0zeQCQieI+z/lEE/8iPfnCAqkxC7bekR0jkTlW39YJSFAySoYzUzt0zVysi1d/t0WjGw+MUk3VGTSZfna6zeivBP8BZcMVZpBSGT7o5TnDazx/Zwtr3qrm/CwRuHLG2W+mWBnYkAN9sbsAhmKaForTp5Zbr16cHd2KYNNR2EusRrJHUF4xqVb/9EqNyINH9lBwCzsa4KZPHD8NtJzlXYcVRq43tHVT6UUA3uoYviiHXgaoQKvh0B7R9VFkNBYMxNUapm6EFfVK/NT9eeIzOJpNCoxcX9jJBMLpsjG+INDNKyJ4Hx9qMIP4QXPzNWrL7rvFR2rSLDyEIlgA6o56udgh4n2hw51TEsKOl4hl099Q5KRvejrIxQwsMHluqv9D0g6Re2n1R63A6/a7trphHDeh3xVyKIeVCeFS3EQz3yhMgRCkv+k1IYHHUyx3ugBybk5bMNvUDwsO0eZvHNATz34V5aZ7XcyyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66946007)(33656002)(36756003)(66476007)(2906002)(38100700002)(8936002)(1076003)(4326008)(186003)(426003)(9786002)(508600001)(316002)(66556008)(26005)(7416002)(5660300002)(9746002)(8676002)(54906003)(2616005)(6916009)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Hd3kgAtnfPj60rtDCiZrs2PuQPn+abS7ZKPC2qbt7s3oU5A9MKnUouM29gJ?=
 =?us-ascii?Q?W4Msd0UywAjSgeVMZKcLaN2pTkUQPcifU/XZ9AyC9RTZYoqYq5PEz819CQ77?=
 =?us-ascii?Q?Jm7xsdvdPB7ZEIcAlLNQkAlyGIfZBIIl2UHi+6eX5sjeOYw9ZJEJO8NBFNzt?=
 =?us-ascii?Q?ZLExtH8X/I/Dwka3HPlzCE4BxI/9OiAVrcPPhJ+o/mGMQUkILnoB5zkclFNY?=
 =?us-ascii?Q?wGMEgT8QM/9QG7wiBtuXG102aSeHjbG8Y/Guu8W6QWpvMt8M03wge3b5SAo2?=
 =?us-ascii?Q?Jy/pdhzbqjPUW8PyKU2MyQdVsiowFFmNwGR98rXl71zVRD01/A9NgslSdws4?=
 =?us-ascii?Q?lqHAlAhaA4wOtaZHXJx9hd/gLA65LsrfrLsf9km3tgTYOyCJqAReLk/Iui1i?=
 =?us-ascii?Q?Aguh4yKw80BvyAK6HBFr4ybKP15MnwPPypgKYJaXv3UT0W7IoK4gNMIwVQp1?=
 =?us-ascii?Q?Bth3T1QgAsGrJlWd2SD7pWyN20rFjSXJXNkZWfwg96Zh24z7LJSwdZaFf+be?=
 =?us-ascii?Q?kbCDtx3LVBzYLLTLcbkHEQ4MbQyeeEq5XuqzLiymbFXHv6OeUMpy+IGdopNP?=
 =?us-ascii?Q?/b5Px2PU76NMP2kp4mhzpiT7fUXuGZc8DlCu00AqxthhFkyVasKe26A9qlPd?=
 =?us-ascii?Q?S3rtjgsaKsczXEztTUsh8dw8rZl8x5BOjjK8gzyHwGLMOMEYcGOcIQ+Gd4VV?=
 =?us-ascii?Q?waAVwuYuoEe85RFEnIdOb6th2pfVQL4jFjHSQqudPcSQDYS9G6Y9x1aS5U7D?=
 =?us-ascii?Q?RBeFC+r794Frs2tFh8QifH8Nld02Bw/+ZGjNLRAeNGD0mBejsPNM4sGQRPIC?=
 =?us-ascii?Q?9WTBoVMS98cV0LctzlWwW5y95SvBLjR41ExnYn4s0WTWSb38+a5fHwJtKIO+?=
 =?us-ascii?Q?uKbxNa9DvvFpxYUuXmVsWkgj7QyIqDLfzuZy+x6mnL+z33p8VcjBEQQIysmj?=
 =?us-ascii?Q?gXh81Ru9w/+kcqptGxVKyF2RuIOZUpui6evObmcJvk7VfseHDdwMIp1fxwz/?=
 =?us-ascii?Q?ZkuxFzhtjybjeVv+hQunPsQ9iXGisBD1YYjgw5naUrSIBX+6Ni6J3mYQ2aRX?=
 =?us-ascii?Q?CRa0PqOt0urS+1UbkyOO19+1BTTL2SyZ731HhqkogjHef0IHwx3Hrn8njrYA?=
 =?us-ascii?Q?Yt3Xgcp+8Xk0uSccCs3liaWhAz0DVn7Nnxv7WUek+7lOlMF96eF3nu3wTdGf?=
 =?us-ascii?Q?PI1t0gXa1i37/6NlTXJsW5YhwakLCXCA6icywq1DYNVg7Qj7Bd74Ug5f9qU+?=
 =?us-ascii?Q?P0Vf3idqj5QiPqGFH49TDrl8JO4nrTMs8GOt0IWzI7PJFO1M31mXlY6ox9/N?=
 =?us-ascii?Q?F7QYsB47AIbsmFgUsEiObqIS2uVp7a3XgFS8Xce6FIg1Vg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78c0ff9-a440-4ec1-f50d-08d989937692
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 13:07:49.6447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHQYN9axvUGw5m82fciku5ysJbKgrEugRLg9Y6wWutANsqSvkbcppI0EAtTDGGzk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 12:52:12PM +0300, Leon Romanovsky wrote:

> @@ -1986,11 +2030,13 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		goto end;
>  	}
>  
> -	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
> +	if (tb[RDMA_NLDEV_ATTR_STAT_MODE])
> +		ret = nldev_stat_set_mode_doit(skb, nlh, extack, tb, device,
> +					       port);
> +	else if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> +		ret = nldev_stat_set_counter_dynamic_doit(tb, device, port);
> +	else
>  		ret = -EINVAL;
> -		goto end;
> -	}

I missed this before.. Why is this exclusive?

If userspace sends both inputs then both should be set.

And shouldn't this reject NL attributes it doesn't support - eg
shouldn't this have a stat_set policy to check that?

Jason
