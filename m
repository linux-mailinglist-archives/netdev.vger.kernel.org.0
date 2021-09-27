Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA991419CED
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 19:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhI0Rf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 13:35:58 -0400
Received: from mail-bn8nam08on2043.outbound.protection.outlook.com ([40.107.100.43]:46688
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238093AbhI0Rbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 13:31:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJ6ouy7eHadHlLgZ43ZpAw1j19SWuhkKJvmeSL2x/n6k2SPtjwPbI+8/P0g17g1E7bnUWw7g/1uUuCMZnKYozLzR3VQIK8G9baED4NewNFjcotXznZt5LY0FVj5dIvFKZHUgVFRv1OrHiyRbw8BQJf2bYvkLNQ5RWiRuZ4ol4N5MSasd4SUVrIImjoFLLAbAdgroyu66infYjlKkgLUA79qPruVAqPqa27qpjiMgZ6+vJcT/rYmL7gVME59qgewwDpvmTKMmE5mgDrdAYGW+WqlPTHgOKI/vGCoos3i9/N+nPhQtvxlMANFjXOrpgA6XEK5nziSk82SE8gxciJyYjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8I4VCr26WWgYL//OjyD5sFPnKfMEHs3v5tuGRdbGOzI=;
 b=hFueC1bfZVcOT7F2V0XW5v9JHIOcIsmSmprHI/8U3CyCx8r8f5S5HPu+F2ypKuGWSrfh0ESs9iacCXcXGoIxgpKKG8A0CMNX3Du6MCo67WuZIicy8Dg9/KQfzfiafdLazG9/1sXV8CnyilO12J1Vru8cGBg9G3GgkPqsSwcfLEcJRRh/kQR5eQcJrrl9RqWKkCCY0EY7tLTs2ObUMwiRm6GBFqcAti00wOxOLxhZ58glgWCTzcrUbABwP7tdhZ+SHEcPDlBn7NUbQSyuT+iCXjJ12HKjPcgME7ZHBrmSmgrZKzDjmT4/zm9c+3e9B/vgFEZohaELTZFOFqu0BHT2iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8I4VCr26WWgYL//OjyD5sFPnKfMEHs3v5tuGRdbGOzI=;
 b=E9I9NVdfgPpy2OaUO5pMvH68bnkC1eD1iladfy/o0umYAtCUXEBYHG6HzOtXCRv0JMOXSBgGL6BIO4ifMwi7F/b9W6RUaeVd43f3E4sMkQFfEW2GDntQFAlCCUR4fVOY1p6VWahBDUwKqlH2z7eMkATT51xumfLP7oXQK438RxgYuECVw6X1TYzmNsgd/HGowkV8Q8DOuxLL2kfrvXdq7oY7rlWB76jAXl+nt05Z6DNj1cpwvnmodXsITF3KfTlGWfqm5d8gLPsPiTs/pmxHKpSZCVp4pCPCsJLWFxFpcBvV3RMNMzz0AYurdj9mr2TlenC7QYbZZvJjTWZ4AbbIjQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 17:30:03 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 17:30:03 +0000
Date:   Mon, 27 Sep 2021 14:30:01 -0300
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
Subject: Re: [PATCH rdma-next v1 06/11] RDMA/nldev: Add support to get status
 of all counters
Message-ID: <20210927173001.GD1529966@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:208:329::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0086.namprd03.prod.outlook.com (2603:10b6:208:329::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Mon, 27 Sep 2021 17:30:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUuS1-006QtU-Lv; Mon, 27 Sep 2021 14:30:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78f542da-83ad-4b1f-5ce0-08d981dc7046
X-MS-TrafficTypeDiagnostic: BL1PR12MB5144:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB514465D5CD48380E6FE88BBEC2A79@BL1PR12MB5144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N16YpaTRzvPJKEqHZ3xk8BqYriH6CCxp7b9s+wwNv4dudYUY79kPWWhDwM2Xav8VRLRUmawzDmHanO9D9xeg3QFGkyhMhdP1PzfrCcydREtTMkdM/HVRBGPKwhY2ZXpeb6n8LGZlDQwokQafUM59lZG0hTs2vV2cBzsGtJST/4XmfPx2HTD7i/jn1s5u97BFrRYcTSWCpkegTImH/2Ef2SJbpNKqp8syOlDL1BYJdqUsctNqPxMU7PUKn+ATlC0UpsyJIiy0mU8Z8Fb1gJsN25xwdtjqn63TzVrRNOaGKp3cBjMU8Sdv251jYJVCVncsB08NO5weKEYFVzA3eeKzf0gUsK5NJXG8DRDYsTSFFM71ILGpIsrsY1EDTaLo+u+md0NLrZ2B9CWCnAuzI9aIYf24Ni1mDHYDZoKArJYSdLtONTI/oZbKY1sgeSKPAPEVU9S3ZoPkgNMln93yVg4gbD3BzTTsqczomsNVqlWosFOutQYM5CxXDV8CwuAZtZFJbUFNcR9TF76+dsAYi/bO6N4GX1YChy8mDPfwESC7WEEymznGzfdJMgg44stIauMyEAX0sjqnYhBNj8NyuZYZeABo3RuiA9R3S81P4uigrdZXKa2jd+PHFgh8pUYt5xP3T+hu7vO4rtPU+byeQFs9Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(6916009)(316002)(1076003)(86362001)(9746002)(9786002)(2906002)(7416002)(186003)(4326008)(26005)(33656002)(38100700002)(8676002)(426003)(5660300002)(508600001)(2616005)(36756003)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H6FIcy5phxSRaMMK9E8tGYNMGWaxivxyOksRk1NyAL5QTpqAVeB392raURdo?=
 =?us-ascii?Q?7Q0LHRX2sEbZVxGIrmCsfuqGsm32hLhVHd5XBhfL9I13Y60o5krZPpzfWhH9?=
 =?us-ascii?Q?6VAjLBb8/dQ9nP1R3B1rVoG2w6GdVdkGP7EP7tcT74HEzgC3v2Uql5XyG226?=
 =?us-ascii?Q?keWXnNNwfbB8wqj+cfm4sI2pkOyIATLY2igHD8Oa8CEGmGrn+2U5ts3jz/YH?=
 =?us-ascii?Q?KLDisoUAp1YIGITMqVIJnMhmlhBM7dLxmd1w6FsYL9W2pcZ3agBz5kKKMGsj?=
 =?us-ascii?Q?nJVa5gPDiSv+49x1kNKo0+VcP8wdVELa+dsiQqpGZtpaikLqdSPn6nKB4/U7?=
 =?us-ascii?Q?cG7hLQjq86br6i4oA/dIwwGqHtbuRSpG6G3NnmH4CaoadgShF5hBR/SXfnwp?=
 =?us-ascii?Q?ycvs0SOqfvyPG4LpkSHBck0Yp/PPEMoyoMSJwNflrBsiqI+KQFdZRXUVQI5B?=
 =?us-ascii?Q?nbPgxZ2ao5dsWNJQfwx1LxTaP4IveBKHnnFxbBuSZVEXgc44flTOZPZYUvDn?=
 =?us-ascii?Q?kIHoUQCrqGFF7qrS7Q8HsHUF7MLKpzmgA8fOwn2nJdosW1magM4P1xFKnH3Z?=
 =?us-ascii?Q?Qt+zi2OSwS8R7NCm3xYKJdTkA4jflldMv9KJNmKqYhfhAvYPrL7sXZEiuvWB?=
 =?us-ascii?Q?IBF9b4UaD1IXrQvi8VLg/rn/1C015AztACufGu0oimJTMd6FmQd/2SiHRANT?=
 =?us-ascii?Q?but4xBLF3psWG8B7NFNKh6FQXU8jAyWCJmgzxglWbFc9ywf5hr92W0DWclLf?=
 =?us-ascii?Q?GeVViDYa1D6rVOb1gW4eL6v7fU4A8DbVcUKs2exAid3YLHy6AhoXBK9blaUQ?=
 =?us-ascii?Q?48mzTRlelzHYees6s7zbmPHazpmgannaDXa+4yhiP8tolyoJhByx0EEvRx46?=
 =?us-ascii?Q?8mr63QBqPvpnmEZqoqnadloCJM4W5OB0i/YuOFUq5Ga/2O8VuKFYPcYyzV9/?=
 =?us-ascii?Q?3JepXoh88VFA5f7lIsYB3dL8f7cYvQmOSmAj27uM7+hJYTyVU1sPp8Qp2mTw?=
 =?us-ascii?Q?PlXdua+VBOcHxzNXMlZzOz+RynGPRjbs4Z5bsbc1wXhwLFnzrgM9OQCPpMws?=
 =?us-ascii?Q?cJzzRDRoI+I9L3Jzcdi7LmUWdrneHLlOlF1zOxRR1OFe8593g//Zx+bi8vQ1?=
 =?us-ascii?Q?PkIzjJFmh7Ug3+mXHKb5V6Vgfuf2ycwQXv4ZHM93pTpjxM/3CvBONYFDC3M8?=
 =?us-ascii?Q?JZrOct2G2lWTXCv6T0gGeCxTFueiurpZ4Ymr4XKwKTtrm/frsPFxOrn8kJbk?=
 =?us-ascii?Q?o72L6tIXeUz+0q5S8ATpLwYog3ejy1So/5Dzgb0l7aCanrskkJKxC3UG1bsh?=
 =?us-ascii?Q?O2FPOSUGplwnDcBFlKumAw8F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f542da-83ad-4b1f-5ce0-08d981dc7046
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 17:30:02.9438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fObAo0aN5h/BsqdWO4eIm+X4QfoFd4a0DVMps/zyw67ptWTdSj+A4rAT1omHY9Z6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 02:07:25AM +0300, Leon Romanovsky wrote:
> +static int stat_get_doit_default_counter(struct sk_buff *skb,
> +					 struct nlmsghdr *nlh,
> +					 struct netlink_ext_ack *extack,
> +					 struct nlattr *tb[])
> +{
> +	struct rdma_hw_stats *stats;
> +	struct ib_device *device;
> +	u32 index, port;
> +	int ret;
> +
> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> +		return -EINVAL;
> +
> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +	if (!rdma_is_port_valid(device, port)) {
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	stats = ib_get_hw_stats_port(device, port);
> +	if (!stats) {
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
> +					       device, port, stats);
> +	else
> +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
> +						 port, stats);

This seems strange, why is the output of a get contingent on a ignored
input attribute? Shouldn't the HWCOUNTER_DYNAMIC just always be
emitted?

Jason
