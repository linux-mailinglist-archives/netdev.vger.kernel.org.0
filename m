Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1F01B89D5
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 00:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgDYWkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 18:40:51 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:62599
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbgDYWku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 18:40:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDZehdk1zSH7UvM/V3XyNTxB/73NsbJNRpWvqVD+MmL9+gcntlcju17aYh7jyG2SK/UVd/ZIwKR7EQq4K866uVo35KLMfqiTlde4ppR6TcgNKqLNgjk+C1NDsWLTY3P0KJ2oe4WBgfm1Uh8K75r1xOWQ5n10SMhBdOFVeLKz3G/YzFB3in8qHBGEd9GBg2fHQCyLCB8Xvtn0Aq0MIxZHfj/OLNHfBQP0r1IaiRbAI8DWG2PuGS8AN6c3v7btKVfKUyY9YIjc0LS9I/lMvtUDa4AtbuyFSrSXXw0F+dozLGdWH2bYZfvUpRrEssPhCB55jnaQcaGS+mJc9Y7oWyMgzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0V3T/7NTxei3HHG2abiAhOnIT5uKdyhDB6aObY4w2o=;
 b=eCmj3C2j/Wcl88mQD21aMkFMYRPElr2+fWzQh2StUlRbmLW+S+3oFs9rcbzmrmVwQhjcJLDKfYaLpDCByvAsqm1dih+P4lzK7KA95y7ZSsFunbEw8PgTWkSVLTsJCMHAjy8bGOYBa34cDB9RuvwIFcCc96ZO8ptvebfw8C5KnBcv/h5GdBoHMOiAqpguo4TJlruGVPh6IDVoGJOQK7UF+QOOYRYNqDO3dNV3F6XphyYyhRDW2J5Ex/dFm303BSMeurdAPhQBHr+Zhr83MezxSvTbejnROy0ZvkzyEo4o+zURTkNSu92lj9qs0XRMCsJ+/CIQ4npdQYWv1jEMWfLzog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0V3T/7NTxei3HHG2abiAhOnIT5uKdyhDB6aObY4w2o=;
 b=LRYBvidIwPJ3ru3jNzKjGtdHbx3VqHMeai3oD2kvS/FrplYOGZL0XntJtNBJWCBfSi+0HSncDsQl4H340uTp8zG7AvIlVHexXaxP2ozcbpOKyvr9mL2z0FVqXrkI1WHS9+87X5op0VBdVIaEAT6ME+rfEaVrJKeRkiTiemt+yg4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sat, 25 Apr
 2020 22:40:47 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Sat, 25 Apr 2020
 22:40:46 +0000
Date:   Sat, 25 Apr 2020 19:40:43 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V5 mlx5-next 10/16] RDMA: Group create AH arguments in
 struct
Message-ID: <20200425224043.GY13640@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
 <20200423125555.21759-11-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423125555.21759-11-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR19CA0017.namprd19.prod.outlook.com (2603:10b6:208:178::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Sat, 25 Apr 2020 22:40:46 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jSTTX-0005np-Ci; Sat, 25 Apr 2020 19:40:43 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c123e9a9-95bc-4260-c97a-08d7e969b211
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:|VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4544C3EFB051C3B04A48E10ECFD10@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0384275935
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(346002)(366004)(376002)(9786002)(186003)(2616005)(8936002)(9746002)(478600001)(81156014)(8676002)(5660300002)(1076003)(37006003)(6636002)(4744005)(86362001)(66946007)(107886003)(6862004)(33656002)(316002)(52116002)(4326008)(26005)(36756003)(66556008)(66476007)(2906002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3tOpungQRg3QoL2URP4Rtsq+bLrerFvoOFtSMbowJ4RRXHjVWQgcvAEQnKB36WP79xxS/FGmXrihB/Zb2FOHm5DiTs3sXcLXgBdHKb3gTYStJ2hCvAGaNIB7MRBWNX4BM3B3c+Tnw4ujVuxtuuq/PP5OMsbKMvL8p+kfKV0J6zLIrCFv5pvst7sVOdoDdfuQRxynH6GCwPM6J3sc0u2bp8JbGqtgLDSvwCyD9iuEedGjxf9dT9nsknRjk3numChUla3omX+wwhtKMFtFhUVFQUSBqO1gjhX2GTTvBF1/Y3nVUHGpU3uErSH5yJzDmfzDmsMy0kvM1W5JfKPD9a5JTJ+9UT8CPS6FUdW8tAkwqpl/AsBZHgHaqi2qRKghi9ikMyox1d3DCNdwMLQZ1hF0DOm4sA1v6NMFIpw5aX5dElwTaUZomcbLf2zWZGcKs9k/K5Ztx6RnjyxqzL3bVzF4UtFUK/ysVBZOEBrF0WZznJ9ldAdzYHGDlFFWI8Z+lcB1
X-MS-Exchange-AntiSpam-MessageData: ulpoiAlW7Qxni8lv6AQ3Wh5XRxZqYc8qA/N241Xqp5H1yQ4+aJn0CWY1IYuZUQdFu9x3DFhhzrh3N0eh+XywPFTxsz9lDBjO8Sw6lSzuk3Ny5WjzMHzbuW3D1uxZysCY+pR7w4sYRHplMYe2HnP+As9p065AmBeqKtL1EpgAb0VMjw9BO6n9y1OTyuKPD0YSxitdOC9QGaN5/xY3sXpmfDgQ6qYEAwzCBBDB48VinxHkuJLbhToHqWfUVzSa5xeDcFb+56YBk+Yo+yacFrst2dG8O3Pru85DYTyPHT2jr1H/+HU9hcBX5cDEHsk0ZlObIa7So8v1sLYRcurI5I/4pEpU4GgkxNQp2pzB7KK8ZPWtoFQddRUDfeLQ0oJ6G9/gOaqFy9P5PlW9Teihd0CiavI+zRZY3aVvN0MJw8PduqMEX/JkLMhPlnwsnbpa5TomHQL+T3aoyPXwB2CfyxuOfr9Hz0yg9/lXP8Xtfc5uNfGUs8OVIR16+2R4RLjE3/M1mdKT73PHxy3tTh9UGktOPbJDSLiCXa+YqZDG3qzhcnIerKQfkVc+KdhjqXNYrvM+mnhW16eFn9xDTrth2FnzPEaUcEqnOv0v/gCodw9/2HvLrqeGugcU+KlVK8+f/sqigAQ3lPewkDOCAZwSSlzl2ot5M11wsL3i58TFBRcbH8FQyD/aMoKigoyqo2gDwArOMNqPmDcICUtKUN+AauLMQLbNuA6K5CaT5/A35gK4uoKQKXjH5wlvpMC36NUCIoJ8RVGnQY1ieZ2XGoDCYRbeHwJX5a7CsKRB9cNWC/QRN+0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c123e9a9-95bc-4260-c97a-08d7e969b211
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2020 22:40:46.7880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tI+VMQqdnR5ftNf5/XZMXK3r8dnKOT+X8pzOjR5YK7qbiJvaqrKD533DWpcqDJL58BorJ/5FaH5N0eIRoakNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 03:55:49PM +0300, Maor Gottlieb wrote:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index bbc5cfb57cd2..c49e4d9ead66 100644
> +++ b/include/rdma/ib_verbs.h
> @@ -880,6 +880,12 @@ struct ib_mr_status {
>   */
>  __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
>  
> +struct rdma_ah_init_attr {
> +	struct rdma_ah_attr *ah_attr;
> +	u32 flags;
> +	struct ib_udata *udata;

I prefer to keep the udata as a function argument

Jason
