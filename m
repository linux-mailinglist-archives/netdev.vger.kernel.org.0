Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BFB1B4564
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDVMuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:50:37 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:6087
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbgDVMug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:50:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl4EBT9KnaZkiLrpL4s2zD9NC2ZwrTejOIKwTCIMiciytZpOeinhWDo5EHKDyVSSf/ME8sgXdrMWdfGzlHqh50QFX+sDcRsGpmytzGo2ISVqJAerImmpuKJAKIGHyqoMVZ2DvTsT26mk5PGRwEl/b88JW8phuwMZ0Ln7/TNIygsalEIDU/v2aiB3l5q0OW+M7uXQNCB9fM8I3kd+2sXurXHi0sMkGq1nj12n0N0qA29M184zyOnJcOta9Ew+yk00xASPQEDuszJU5Y3WSxPyrORLCSeTZkC+HMld/6iOe3doQjUjtqWNPgbkpix+0650neMYS1Ka+p4XMXf6ksDnBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahYDRYNrF4QWsSk4By4So8UDtlhWW1uXWgcAFNUUe3c=;
 b=ILSmA4gAEl5JUVaoKTM3OKJpQI7l9wlY49k5+mT6OXo40CFj9j6zzXr9fY9s+oi97m7dp8IZN8vrqWA9DmeOY/fxhGWzga48JZ91sVg25AZfrcWW22w9ml16cE5W5ozaVpOY7tbMap9QFFhOGWgsEtH7+m4qf0qA1j0kcr11+7q0ZzTmjlQpgSJGW3xlc1pcBA5dcIvG0i8SFn4KJtJHRip7nQ+BEQKrPyxiSfJd1u+2dortoaGCSZLQpnQBS/V15I8QsITqGvfHAr/phXTAjYs0sif9BS5Hwp/gqql22UaTUuEO9cNBw+Uvh3ETYomaYH27441adTfZdps6aQXfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahYDRYNrF4QWsSk4By4So8UDtlhWW1uXWgcAFNUUe3c=;
 b=DnSHfmis6hR4iUfNZrsxHOkZNmjTNVikoIiXEn3c4SUngG8ZaBsWvdj73dNwZcf5tXmJJe2bjuUaeQ1TELkRsQfJif0zz6iB+Z49LCS3EHb5L9gBGhQrEZ+YpH1ozS01vP0DKrjBnWLSGbSTaFRxyy9TGsdAjacyDHQTrFRaYXc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5983.eurprd05.prod.outlook.com (2603:10a6:803:df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 22 Apr
 2020 12:50:31 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 12:50:31 +0000
Date:   Wed, 22 Apr 2020 09:50:26 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V4 mlx5-next 10/15] RDMA/core: Add LAG functionality
Message-ID: <20200422125026.GS11945@mellanox.com>
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-11-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083951.17424-11-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:208:23d::6) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR06CA0001.namprd06.prod.outlook.com (2603:10b6:208:23d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 12:50:30 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jREpe-0006JC-TM; Wed, 22 Apr 2020 09:50:26 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb932188-e0fb-444e-34f5-08d7e6bbbd7d
X-MS-TrafficTypeDiagnostic: VI1PR05MB5983:|VI1PR05MB5983:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB59831D26D8FEFA0839E7E815CFD20@VI1PR05MB5983.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(478600001)(86362001)(6636002)(33656002)(107886003)(36756003)(8936002)(52116002)(66556008)(66946007)(37006003)(66476007)(2906002)(26005)(316002)(186003)(1076003)(9746002)(8676002)(4326008)(6862004)(81156014)(5660300002)(2616005)(9786002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDAdo9Eu4Xh42Bjy3douORpxmxy427PaUg4NpTUBPeX6OJX45f9/xUCrb8Gh3PQr4TDMtAcs2pwDOCwRw2dkhESXNu/6aHOLHUlF9Ee4EPYsNq9rMmHglpHRGN6vn2O0xLY9DBdJQ8nDUA/Hae6rTlbUvli7v0RmK8wvOe+61tUmCaMl/LlDHZCTE7EwAzXw/MzLPIiHRvhmDapbfprdubSM6CgkbaCREvnDznNNE52k78fewEOe/kotH3K4Gg8GMIUzELcNA330Kd9l+KBSEFq/SbARaq49dJtJqpf3Emq3ny0c1j1qKcl0onQcZb+wq/QlEdr+26rior7pmAtR31xMvBD1swFjUKDcmA+FtfwwDcbX05TmJc9HDRumnxHbLV0lEj1QP74N9usLe8F8IK6lSltQj37ICYXT+QYT4Gwyro+Bq+A/1C1YVS2ZMnbN/20BrWZLfmsswTTd+GcbGNLs8QT3W3bSeizb+XM7b6Vo/Gt9o+d9kmnP+8UkNHhD
X-MS-Exchange-AntiSpam-MessageData: 25y6Q/D0IKZh1BYbQNV7dY0Ikk38jvDALWeTgAS5CB9GUDK4aWaAZ4kVPUGzWKMkUwZaSIGOYOJeEt9HMDWclC0RTWcVmxe1gnixrFpDJM8ylzChDCICE6xM/kuC4EYsULn8ncJ1M5z9BsCin/GAGQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb932188-e0fb-444e-34f5-08d7e6bbbd7d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 12:50:31.0795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgG6CN9nT+l0WsKvPXdSIHo3L8431ckOfn0hY7XijQIjNLNX5aDa3+t6J6ioi8RIYafuvPpPiyVp/syxRz/unA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5983
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:39:46AM +0300, Maor Gottlieb wrote:
> Add support to get the RoCE LAG xmit slave by building skb
> of the RoCE packet and call to master_get_xmit_slave.
> If driver wants to get the slave assume all slaves are available,
> then need to set RDMA_LAG_FLAGS_HASH_ALL_SLAVES in flags.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/Makefile |   2 +-
>  drivers/infiniband/core/lag.c    | 138 +++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h          |   2 +
>  include/rdma/lag.h               |  22 +++++
>  4 files changed, 163 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/core/lag.c
>  create mode 100644 include/rdma/lag.h
> 
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
> index d1b14887960e..870f0fcd54d5 100644
> +++ b/drivers/infiniband/core/Makefile
> @@ -12,7 +12,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
>  				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
>  				multicast.o mad.o smi.o agent.o mad_rmpp.o \
>  				nldev.o restrack.o counters.o ib_core_uverbs.o \
> -				trace.o
> +				trace.o lag.o
>  
>  ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
>  ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
> diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
> new file mode 100644
> index 000000000000..3036fb3dc43a
> +++ b/drivers/infiniband/core/lag.c
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2020 Mellanox Technologies. All rights reserved.
> + */
> +
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_cache.h>
> +#include <rdma/lag.h>
> +
> +static struct sk_buff *rdma_build_skb(struct ib_device *device,
> +				      struct net_device *netdev,
> +				      struct rdma_ah_attr *ah_attr)
> +{
> +	struct ipv6hdr *ip6h;
> +	struct sk_buff *skb;
> +	struct ethhdr *eth;
> +	struct iphdr *iph;
> +	struct udphdr *uh;
> +	u8 smac[ETH_ALEN];
> +	bool is_ipv4;
> +	int hdr_len;
> +
> +	is_ipv4 = ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw);
> +	hdr_len = ETH_HLEN + sizeof(struct udphdr) + LL_RESERVED_SPACE(netdev);
> +	hdr_len += is_ipv4 ? sizeof(struct iphdr) : sizeof(struct ipv6hdr);
> +
> +	skb = alloc_skb(hdr_len, GFP_ATOMIC);
> +	if (!skb)
> +		return NULL;
> +
> +	skb->dev = netdev;
> +	skb_reserve(skb, hdr_len);
> +	skb_push(skb, sizeof(struct udphdr));
> +	skb_reset_transport_header(skb);
> +	uh = udp_hdr(skb);
> +	uh->source = htons(0xC000);
> +	uh->dest = htons(ROCE_V2_UDP_DPORT);
> +	uh->len = htons(sizeof(struct udphdr));
> +
> +	if (is_ipv4) {
> +		skb_push(skb, sizeof(struct iphdr));
> +		skb_reset_network_header(skb);
> +		iph = ip_hdr(skb);
> +		iph->frag_off = 0;
> +		iph->version = 4;
> +		iph->protocol = IPPROTO_UDP;
> +		iph->ihl = 0x5;
> +		iph->tot_len = htons(sizeof(struct udphdr) + sizeof(struct
> +								    iphdr));
> +		memcpy(&iph->saddr, ah_attr->grh.sgid_attr->gid.raw + 12,
> +		       sizeof(struct in_addr));
> +		memcpy(&iph->daddr, ah_attr->grh.dgid.raw + 12,
> +		       sizeof(struct in_addr));
> +	} else {
> +		skb_push(skb, sizeof(struct ipv6hdr));
> +		skb_reset_network_header(skb);
> +		ip6h = ipv6_hdr(skb);
> +		ip6h->version = 6;
> +		ip6h->nexthdr = IPPROTO_UDP;
> +		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
> +		       sizeof(*ip6h->flow_lbl));
> +		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
> +		       sizeof(struct in6_addr));
> +		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
> +		       sizeof(struct in6_addr));
> +	}

What about setting up the UDP header? It looks like this needs to be
before the sport patch and the sport patch needs to modify here too.

> +void rdma_lag_put_ah_roce_slave(struct rdma_ah_attr *ah_attr)
> +{
> +	if (ah_attr->roce.xmit_slave)
> +		dev_put(ah_attr->roce.xmit_slave);
> +}
> +
> +int rdma_lag_get_ah_roce_slave(struct ib_device *device,
> +			       struct rdma_ah_attr *ah_attr)
> +{
> +	struct net_device *master;
> +	struct net_device *slave;
> +
> +	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
> +	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
> +		return 0;
> +
> +	rcu_read_lock();
> +	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
> +	if (IS_ERR(master)) {
> +		rcu_read_unlock();
> +		return PTR_ERR(master);
> +	}
> +	dev_hold(master);
> +	rcu_read_unlock();
> +
> +	if (!netif_is_bond_master(master)) {
> +		dev_put(master);
> +		return 0;
> +	}
> +
> +	slave = rdma_get_xmit_slave_udp(device, master, ah_attr);
> +
> +	dev_put(master);
> +	if (!slave) {
> +		ibdev_warn(device, "Failed to get lag xmit slave\n");
> +		return -EINVAL;
> +	}
> +
> +	ah_attr->roce.xmit_slave = slave;

Is xmit_slave is reliably NULL in the other return 0 cases?

Jason
