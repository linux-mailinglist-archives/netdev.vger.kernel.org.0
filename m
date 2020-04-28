Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBB1BD098
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgD1XaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:30:18 -0400
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:28829
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbgD1XaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 19:30:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOwNs4XHFCdu9bUWcr9RbbATRrrStXNhvsJGzsEc7EMWu532SmezGZU+rtyvtezE8AGzPJ5pv1c/JDt6PHn+3xIVF1ntJqxZdh0cavBbOWfGVB/VYcZaA06fseOmUgwnzrCtkswXVevzRR6GnfUYnu28GKEVxjxG0kqI6aJXsmYEdbsRQOhRyRxywmEfP1KFuPpPmIciLdVnBlPlI3bgIB7vbXBvSr98GSzUjqBYKkeHcRgh3iMdAv4Xhb3vuCFsIeY7asvdoPpltDeVcXZ6zyqAoWIQDTcva3A70Y79SaceEVuykEBWAMSiZICYYC7vPGMuFD05v7g8SHkYwHd5UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiVeCTbmaeRzSTqGMHwA1Q/ZBmRANef1Cg8orJitG6U=;
 b=DthDEM7P69KZDUbh81FzFsYH1gxapEZH/dxhjoq8it56Blp7jOzVocbYSBTjRo6IVDpmzXe6qnDkveQSXZWXEt48t/6V1mAZfDfOc4TEesrQ2pKGVuEMBQyYWcj6BdUjlRi+LI0Knz3J2aAnZ0U4OlYefqcHe4Y+XAYc1moC0Qvt4e60dgZOFMbsmyExgvgul5CLE4RLrAl1ixsUTygfjL/LXXKJo4FzE/PS54DTHugHconWOSenbqtP/c2hz6uNNTuSPTLsFzyN90rMQ9C4WKvb03ovQ+eIeVuJIr4c51XPijDxyT7EG+OsKGJ/6zSsBz7Cz81Gteu0iqbbZX+hDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiVeCTbmaeRzSTqGMHwA1Q/ZBmRANef1Cg8orJitG6U=;
 b=JjB1wfi1j8dwk0HDUZFA/OEXPrzqq9YPy1QC69uKEPNoVk+kyURFqkTalToBE60l3PexqWWMDvzblrBj8SK+VI7ZTudasJQVTRhFjtVYIrZNawcDdpoGRFBdV0n9hEZUomDvXciVF6dX51kzBbcjbmloKK2JvNiUyb2RhBy1u00=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4576.eurprd05.prod.outlook.com (2603:10a6:802:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 23:30:13 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 23:30:13 +0000
Date:   Tue, 28 Apr 2020 20:30:09 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V6 mlx5-next 11/16] RDMA/core: Add LAG functionality
Message-ID: <20200428233009.GA31451@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-12-maorg@mellanox.com>
 <20200428231525.GY13640@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428231525.GY13640@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:207:3c::48) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0035.namprd02.prod.outlook.com (2603:10b6:207:3c::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 23:30:13 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jTZg1-0008Cq-Rd; Tue, 28 Apr 2020 20:30:09 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8456662-edd2-45f6-98b1-08d7ebcc19b4
X-MS-TrafficTypeDiagnostic: VI1PR05MB4576:|VI1PR05MB4576:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4576C1EBDC31631FF7B28741CFAC0@VI1PR05MB4576.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39850400004)(136003)(346002)(376002)(66476007)(66946007)(33656002)(9746002)(6636002)(5660300002)(2906002)(107886003)(4326008)(6862004)(86362001)(9786002)(1076003)(2616005)(66556008)(8676002)(8936002)(478600001)(52116002)(36756003)(37006003)(26005)(316002)(186003)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Pr3fcAU4WqAPbBql+kKKFz6LAtawbW9l7I+u7sebzdoFTHiJSdLA9EReMesjun6WOGEvPQYQl6vrNofBtettr9yAKuGx1ALpv2VFvIBvJhB2NOqU97YvUfephIA55lUAu5L59rDojIk0nPBC/nAzd/JBp5eMYtu3ubJAv1IctPZiPLSORCrS7MnUIEWGCHPGsKjRSfEL+1VF8KRL6uSy/+aPy2UtH8Wcc18BH0LiZ1gthkjWkhuBVyAMUcZ1LLXQV8te62Qo+M+BciF9m/alcTvCsp7rOFeE+CsY85Ij+G/mlGZB9Bws58Gk+ldONZQ6Bw9I3QIuIOcJ+2GL0gXb7DaWOmPk1qXmHaZ0d0R9tCXA+mzewE9f3KrD4fIthOYYPvbmgaVTeU1cI62IkaqlzCfv2k1Wf68mkc0xqBmNMIb0j7ZY6w8MO63jp+leX0u2wDS7dVxa+ALT6XCzpnMPNgbLIJx9OIkhhgk+oECenkSTIk3OVXNGhI6mK/ip/qz
X-MS-Exchange-AntiSpam-MessageData: pfG5UdngE92R29vWewplGwU5ULmkvkE69oN6B27arzrkY3LAADwsAfUldMO6SFlHb6YSDznW2M2P/S+Y7ehOAJgGM0y7Jz2FoQBVxWAGqduJxpH0Yp3dpp2UgQIcOBwi64qCUpp1wG9p9JGRlZ9OWxTuwWSP97WefteYwdIU8svYtCW+bGDnzXi21yBl3r7hoyAClGZ1zucVWRPQFzcjBXqdd7HNfx/TFV1CYyyURadqhlpXX0skZLXyuMmGzeME83ZFdC9sslDbOJ3irTF44rkCU/cXuDqm5E5ETeptCYlzDm92NALtGvFevz8Ps5CKk2AMB/dwleHqrDZ8fm7IRkvKAoFArACN+hZ598odoKlcW1tpDCNpg0vgCvFCt5VyWuZ+2GXYIlN8Nsqq/dODSIyyahJlfV4egRqMAN8XrC9LAqe/IM4FPmn/AzAt/lBDSACrMybRvzii1pi16mdRvlsLwi3B0m+b2UhLixkhpAvXqUV1ZTvL8zFJkICKY3jLswru8auaIXxwJKz//508wj7qDTkjOYwiZlIsJgd9HEfYgTlR+apChWHG7h1gTTnjdsD4K5I1NUdGVxsWn4ExYjGT1v5IrTyw0kdPJe2ixhsAJ8x62v1RCO/3GrXtlgJwXTSzDUk2VxFSk9hiCBxJQLcNv0qwTcuwLE1nZGureSUJYTvMQh1sqlAzrKlOGOjWfcu3vcnvJna/LJ2IxfOkyytPTMrY3By0b+rTrvLxzAng0cKaIB+3V4NyMVW+ZywnKJAiFP3T7MaH8uZEEncn1y9l32fbOhZtP5RxcrIT/tU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8456662-edd2-45f6-98b1-08d7ebcc19b4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 23:30:13.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rogu9AZ4NGq7I9wuOaucxkXCAMSwOl4pu3G1xoX8/HNh09btHR+SiSo8hSYuUz4lcY1O+W1yyWVv5pYZH/T5/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 08:15:25PM -0300, Jason Gunthorpe wrote:
> On Sun, Apr 26, 2020 at 10:17:12AM +0300, Maor Gottlieb wrote:
> > +int rdma_lag_get_ah_roce_slave(struct ib_device *device,
> > +			       struct rdma_ah_attr *ah_attr,
> > +			       struct net_device **xmit_slave)
> 
> Please do not use ** and also return int. The function should return
> net_device directly and use ERR_PTR() 
> 
> > +{
> > +	struct net_device *master;
> > +	struct net_device *slave;
> > +	int err = 0;
> > +
> > +	*xmit_slave = NULL;
> > +	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
> > +	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
> > +		return 0;
> > +
> > +	rcu_read_lock();
> > +	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
> > +	if (IS_ERR(master)) {
> > +		err = PTR_ERR(master);
> > +		goto unlock;
> > +	}
> > +	dev_hold(master);
> 
> What is the point of this dev_hold? This whole thing is under
> rcu_read_lock()
> 
> > +
> > +	if (!netif_is_bond_master(master))
> > +		goto put;
> > +
> > +	slave = rdma_get_xmit_slave_udp(device, master, ah_attr);
> 
> IMHO it is probably better to keep with the dev_hold and drop the RCU
> while doing rdma_build_skb so that the allocation in here doesn't have
> to be atomic. This isn't performance sensitive so the extra atomic for
> the dev_hold is better than the unnecessary GFP_ATOMIC allocation

Though if you do this be mindful that the create_ah call site is
conditionally non-sleeping, the best thing to do would be to make the
GFP_ATOMIC conditional on !RDMA_CREATE_AH_SLEEPABLE - ie pass in a gfp
flags argument.

Jason
