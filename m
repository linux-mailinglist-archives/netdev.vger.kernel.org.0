Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE31BD082
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgD1XPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:15:35 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:43504
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbgD1XPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 19:15:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1gYQoyFSSpy7s635P+uPhU2yJbyKpT2MnVDWEFqgqb3fozXPrqCoBle48yiTy1kkMKuPxFn3ZvCVibPf0eQb3KH9xIZ689z7jbh0zcSoWcjJIW2SYWA7PxmYpL7tGQaAWvSoZnMqx6JCmFuDEGeM35oSeRtT1Cw9KBOpwoVoKx9zmwmoTPxLVy/D7ll4Run6VjIIIU9dFYxL//D3XBIsiuORi64V0aEOnM4H3XcKPR4xqLn0px9HiyxO05MKHU2P5eDeGdFIaAT26N56Gl9JVy28qa7y7bf/pxPPKeKsU5gV7d9xyGtBYgEMri1AySJZOUjer8xn4tF8aiwzyvP2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFOmUkA+gvkJqGCihlolfWrund+8c3syQ9xeXXNftmM=;
 b=hXvVRhH5BIp4MRM/b/IPg6O0Kq07no71p8pusa76xJoYcAlMVS9ezCgmBdPWQMcZroszwMtuYgU/9GcJhcgQlN7M//Ylfyy8+JIAnuWfJ+YBB88LkpfTNMsxSA68zH/Q/tUW1PoUnnTQ+rd2lttDSBW4JZs2tck336kZ+9gwRmhNd1qd8Mp6GKKZ4VcOeIq/TP5An3o2nvsTCG01/Uj8I8/6t9MUAWdbSDZN92ncGqtCpniDazwq53Iy0qUBIY20ELDVyZP6dMZ4YMP+QniNpMqC/fcY8nNS/qIzCAzwSxDA7DA4gTOHdHqXPLx/3DXMeIyCodgi93PaTPx+DmEXNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFOmUkA+gvkJqGCihlolfWrund+8c3syQ9xeXXNftmM=;
 b=AyBnaW4DcSULJ5GSxemOFerx0qy/HOql0Mhsq02fjKlRfKfJkoSifMbRvzvjzsyK/xvgcgHEC9OPXMDiI68ft3TbZNoFMo1mxnfiixy9poHfL2ki4Qk8EQENjD3bUGuBQmzFd59zKtVNnrrN2nW0zztB3eaM5zNpdTSiK4aj+sM=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6829.eurprd05.prod.outlook.com (2603:10a6:800:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 23:15:29 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 23:15:28 +0000
Date:   Tue, 28 Apr 2020 20:15:25 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V6 mlx5-next 11/16] RDMA/core: Add LAG functionality
Message-ID: <20200428231525.GY13640@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-12-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426071717.17088-12-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:208:c0::49) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR05CA0036.namprd05.prod.outlook.com (2603:10b6:208:c0::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.9 via Frontend Transport; Tue, 28 Apr 2020 23:15:28 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jTZRl-0007w3-1F; Tue, 28 Apr 2020 20:15:25 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 397e5fce-f0e7-4bad-214e-08d7ebca0a51
X-MS-TrafficTypeDiagnostic: VI1PR05MB6829:|VI1PR05MB6829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6829A9D23D8D144DAFC45C1BCFAC0@VI1PR05MB6829.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39840400004)(366004)(396003)(37006003)(478600001)(2616005)(4326008)(186003)(66556008)(6862004)(66476007)(316002)(107886003)(1076003)(66946007)(5660300002)(8676002)(9746002)(9786002)(8936002)(52116002)(6636002)(36756003)(86362001)(26005)(2906002)(33656002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1hJwnn08kySg6xZdGoHNE7WJUXtTyNJRXv6rfQbyVyRA0sQiIWuShC0byKCBvNTVsg8/oTwxqE0GDnYqcJkIAENSkYej85N7Z+Oey527yVW8Ko1sq0lrcLNuZDj/PacqrTuG035qh9CO5ky3AtBC8Q2IE853mr3UOlQEpqMol4usapOcyFYFXiz3BR48a60L3W/jIqsGM8yHjF5aaeOC/f8YH/UTjeKdwIx425zUIoYUMkLTxxzKVIIu6+dZtSC9LtWzfWqaYw89Z7GWpTlmqRs2ws3UU775mN46j435W2oM4B5a2XTwXnUyyQ5dD3nnnIBW8u30pEJ0stxeTjseVRQA58cxQJ8A6nVBFjmKc74pOh6FHXV/xff27Ehpoe2KK6vwIqeFEgLAo2TLwnzLl9mk1YZ6u2DUrvcfvs1xBzK/vaLpKJ+ip4NrjzJiyxA5hOanjF/TSNJ7HsPQEx8f8fYjBPDFRxiA3452n9qlVa/GCmh3X7Afn1ija/HTakh
X-MS-Exchange-AntiSpam-MessageData: EXbRoawG2dGTYqIQ9bGmtQmq2P0pJ80Fl0Ryeylv9rjVsPEP8yB7lJZahtFUKFzT9CKBpO+BapUYWo9PxwZHKQ1PamoKfbzagktYffnhowuLzTw4gfZTCKPXnzlp3ul0kru68Qhr6bn8GQlYYS5mCwYbyHtj9xnnuTbKtN4pibpLaojcgShyF42wzO1XBdHGPRIhVh4NGVnGGU8JOlnudMf2nWgmH7UqUHXDjn4w89TAac2Pz4QpfYsXsgGIDS52ty/H8r/ESClDcwnkQW9gnyFO2cm4RsqOQey5pUbksoRy5fFTtYyAlhrkJFkXohdgzbPiB/z/723QVjPsRkcFdQYnXXelpkh/YTXrruRzChYt+dzn9QZoK/4oT5kDSKY5ao6WW14DtObYLagO9xHxjEwGP7TuN8ODQ2gaJ7M44k9yPPNIWha9EfuNkhZCRHRGxBOGZT7CPXjvp57IcpU1xDH4mxP7Q4riuyqCF62VmmGBilSQVRPjGYo2aJVodec/4vX/EDLR1LwwpfbKVFCv3gE/NC4WKzUooVwO3FLIoFeA8pTWlizTlKX9tX2xSv4k0IVA6923bxKA3yoxuSUCXTDZrM6kgkso8Dcdtad94T5NAj6Chp+VQVKMh7g/EmdgwpzaxJybQXfYGxTDZKIhw7ScuaySPZOUwoC4ikDk2dPE63kkFjnv/F7En6ePFNTmDLui1XAJg9o6bSVc3hkQPWOo3IWRgs+bgL8RbID7nX5cK7eMCqBDUYvkZF1hR+Fzlxe/cMxzmUTkfF3HMRXHxL5mLPJeTWj+ci1INYAWGJk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397e5fce-f0e7-4bad-214e-08d7ebca0a51
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 23:15:28.8422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWtctIeJW5TFowsJW/8wCz2sPZUKAl2cICR0VbQMsIHjdzGmAulnLJvmknbkoU+uvlj6t5tkISFYZpf+katsqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:17:12AM +0300, Maor Gottlieb wrote:
> +int rdma_lag_get_ah_roce_slave(struct ib_device *device,
> +			       struct rdma_ah_attr *ah_attr,
> +			       struct net_device **xmit_slave)

Please do not use ** and also return int. The function should return
net_device directly and use ERR_PTR() 

> +{
> +	struct net_device *master;
> +	struct net_device *slave;
> +	int err = 0;
> +
> +	*xmit_slave = NULL;
> +	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
> +	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
> +		return 0;
> +
> +	rcu_read_lock();
> +	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
> +	if (IS_ERR(master)) {
> +		err = PTR_ERR(master);
> +		goto unlock;
> +	}
> +	dev_hold(master);

What is the point of this dev_hold? This whole thing is under
rcu_read_lock()

> +
> +	if (!netif_is_bond_master(master))
> +		goto put;
> +
> +	slave = rdma_get_xmit_slave_udp(device, master, ah_attr);

IMHO it is probably better to keep with the dev_hold and drop the RCU
while doing rdma_build_skb so that the allocation in here doesn't have
to be atomic. This isn't performance sensitive so the extra atomic for
the dev_hold is better than the unnecessary GFP_ATOMIC allocation

> +	if (!slave) {
> +		ibdev_warn(device, "Failed to get lag xmit slave\n");
> +		err =  -EINVAL;
> +		goto put;
> +	}
> +
> +	dev_hold(slave);

And I think the dev_hold should be in the rdma_get_xmit_slave_udp() as
things called 'get' really ought to return with references.

Jason
