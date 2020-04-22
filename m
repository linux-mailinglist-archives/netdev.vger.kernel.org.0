Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC941B45D4
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgDVNGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:06:34 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:13383
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbgDVNGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 09:06:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A90/NZHO/R3MhKJGn3/+4unUbsV9j//LVHXoVIinpF16SjfeO3/wjHt+T1FISTWlPmtNFZgPRR1X/zP6g91DhLZRrHp/1XlJMT8qonmui1XouZ1udpeUUQqiNkFVjibjnxObRkUm5QioIROpXHos8ueSvNps4I0WzEHF5qExw9B1WYB2sEH/c403hnKYP+Rq1mUYcyIWARBGGbJov6IGFIXRwm/eliIGPVe1lxM9NAmMiFuzcJhPkXb1bYOHlJfnqSfCRSoSTS/lq6OCLe0kiPEZ8fjhmado/gvYKZuWBoa8mXSDlGAW+wUImlC52TcM1uLfUhJD1KDpvURzt93poQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDl2Eqom5WsY1dhxDBW1n0MPunP6oc7zBSo0ILMATXY=;
 b=NQpHh8I0x9b6tPYq6+Y9DyQrUkao5yCAhS9Li2PkAq6dYX9SdCEWc69OIlLipvOq4xHPOKDI4HtnNcDGWU/uBHw+vw9VzhCfRs4vYQ3vOJXd6ywhohRRI9jQtmiSGh5bkvv+cUBb/Xx3xpapwOu7wdW9XeYhNzMeIOKH3aB+w3nTAv4JysGVWr37x34Ow+TkTHfmX0Rzao557oD/QFnAnEi/fhA2hxFK+Bim8O0h24lfv4wkMN6+P/QmXR6cN6U22qgg9YfUDJP4v9JXB0WEo2nfTLKpWjMIyZjsdGH0MUt6y3VGFi2EthwxSs8BysYN0K/P6M0Sb0XwsMgb2Z3YRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDl2Eqom5WsY1dhxDBW1n0MPunP6oc7zBSo0ILMATXY=;
 b=eoPer2tW7PdrkOYDB71/t4bHVGFViXX0Wg3Ywjcpfbi4nn1AuRsyu9cZLLsG6VoPSO4pibQ/2+UJHXti8GjlNRh3km34/3ow+W7aJC2CyqxRnNUHh4WohmcEeGIkKdcgo2gXPAFPEvnoVnxU9tx30VucZC02hXFPJzE9lyUUPiQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB4386.eurprd05.prod.outlook.com (2603:10a6:208:59::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 13:06:28 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 13:06:28 +0000
Subject: Re: [PATCH V4 mlx5-next 10/15] RDMA/core: Add LAG functionality
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-11-maorg@mellanox.com>
 <20200422125026.GS11945@mellanox.com>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <1cb93f17-a9cd-125a-d05f-c8185f74c544@mellanox.com>
Date:   Wed, 22 Apr 2020 16:06:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200422125026.GS11945@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0701CA0032.eurprd07.prod.outlook.com
 (2603:10a6:200:42::42) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by AM4PR0701CA0032.eurprd07.prod.outlook.com (2603:10a6:200:42::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Wed, 22 Apr 2020 13:06:26 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c07a8ff-b16c-49e1-7180-08d7e6bdf850
X-MS-TrafficTypeDiagnostic: AM0PR05MB4386:|AM0PR05MB4386:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB43862BEDEF9817FD4CEB30B1D3D20@AM0PR05MB4386.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(31686004)(66556008)(66476007)(6486002)(66946007)(16576012)(86362001)(37006003)(16526019)(186003)(2906002)(478600001)(107886003)(52116002)(5660300002)(53546011)(36756003)(6636002)(81156014)(8676002)(8936002)(4326008)(316002)(31696002)(26005)(6862004)(2616005)(956004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SqXmLTrdXcTU+Z6blvH17b0s/3T4O3MwlfGgfaLt+48itz72u7oq9qpwz9NhbPUr1TBtGao0bpzuPYR3HFrrJ6G+SVEE5Q6CfkNwkuVEMGe6dlqIQeRj+iSxXTTrAcrCoR9VMW8WoQF5nICIJHybajcQrNnOKZnm8P8P/v9R8JAIIt2hWPDzqZd5IY9BneV8ysG403UKLdudA/HatUF3H9JD1i3aGMYW5GAYMfzxIMlZ16uyPqCDEsOp8flWLk0xCN3PhsyblaKLi9xovqXHKJNlnhdeucS9BuDBJbdMbg8Nj/lqIqVVYSDAfBWqD3OxBeKaRnOLkQf0zHFxA8Mgf5eIyzKJqMVVXB7lXUvrbqylGOLd60cMAPMZRA/uA3RRX+q4+A5YCrdP03A/vASWa/8FLNbYKxwQpMqsQPFNyC41a5CM6ZDcNkZUt6hTuL9
X-MS-Exchange-AntiSpam-MessageData: uMXFk8e7dzcEiTLkEuzCzvK+inpM53uoqmQyc0J8cLf+lFATaco9R5RHOXbaikGJ3BRKl3dgLxo98FtMoRPZHhEcY+82qDn7Qwjhu/JWWgg8XKg5oJtBPfZaVXuJyHEcUXVSfFpW4TmLisPAZH3kqg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c07a8ff-b16c-49e1-7180-08d7e6bdf850
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 13:06:28.6752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjQL/+S4+v4fxKTeTVgELBj/vAvAUmocH13GaGRDqLGl1Z85qeKxpuhCVmt9XOxdxfD/HmeRN0sB/K+Yr3/xWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4386
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/22/2020 3:50 PM, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2020 at 11:39:46AM +0300, Maor Gottlieb wrote:
>> Add support to get the RoCE LAG xmit slave by building skb
>> of the RoCE packet and call to master_get_xmit_slave.
>> If driver wants to get the slave assume all slaves are available,
>> then need to set RDMA_LAG_FLAGS_HASH_ALL_SLAVES in flags.
>>
>> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>>   drivers/infiniband/core/Makefile |   2 +-
>>   drivers/infiniband/core/lag.c    | 138 +++++++++++++++++++++++++++++++
>>   include/rdma/ib_verbs.h          |   2 +
>>   include/rdma/lag.h               |  22 +++++
>>   4 files changed, 163 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/infiniband/core/lag.c
>>   create mode 100644 include/rdma/lag.h
>>
>> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
>> index d1b14887960e..870f0fcd54d5 100644
>> +++ b/drivers/infiniband/core/Makefile
>> @@ -12,7 +12,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
>>   				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
>>   				multicast.o mad.o smi.o agent.o mad_rmpp.o \
>>   				nldev.o restrack.o counters.o ib_core_uverbs.o \
>> -				trace.o
>> +				trace.o lag.o
>>   
>>   ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
>>   ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
>> diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
>> new file mode 100644
>> index 000000000000..3036fb3dc43a
>> +++ b/drivers/infiniband/core/lag.c
>> @@ -0,0 +1,138 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/*
>> + * Copyright (c) 2020 Mellanox Technologies. All rights reserved.
>> + */
>> +
>> +#include <rdma/ib_verbs.h>
>> +#include <rdma/ib_cache.h>
>> +#include <rdma/lag.h>
>> +
>> +static struct sk_buff *rdma_build_skb(struct ib_device *device,
>> +				      struct net_device *netdev,
>> +				      struct rdma_ah_attr *ah_attr)
>> +{
>> +	struct ipv6hdr *ip6h;
>> +	struct sk_buff *skb;
>> +	struct ethhdr *eth;
>> +	struct iphdr *iph;
>> +	struct udphdr *uh;
>> +	u8 smac[ETH_ALEN];
>> +	bool is_ipv4;
>> +	int hdr_len;
>> +
>> +	is_ipv4 = ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw);
>> +	hdr_len = ETH_HLEN + sizeof(struct udphdr) + LL_RESERVED_SPACE(netdev);
>> +	hdr_len += is_ipv4 ? sizeof(struct iphdr) : sizeof(struct ipv6hdr);
>> +
>> +	skb = alloc_skb(hdr_len, GFP_ATOMIC);
>> +	if (!skb)
>> +		return NULL;
>> +
>> +	skb->dev = netdev;
>> +	skb_reserve(skb, hdr_len);
>> +	skb_push(skb, sizeof(struct udphdr));
>> +	skb_reset_transport_header(skb);
>> +	uh = udp_hdr(skb);
>> +	uh->source = htons(0xC000);
>> +	uh->dest = htons(ROCE_V2_UDP_DPORT);
>> +	uh->len = htons(sizeof(struct udphdr));
>> +
>> +	if (is_ipv4) {
>> +		skb_push(skb, sizeof(struct iphdr));
>> +		skb_reset_network_header(skb);
>> +		iph = ip_hdr(skb);
>> +		iph->frag_off = 0;
>> +		iph->version = 4;
>> +		iph->protocol = IPPROTO_UDP;
>> +		iph->ihl = 0x5;
>> +		iph->tot_len = htons(sizeof(struct udphdr) + sizeof(struct
>> +								    iphdr));
>> +		memcpy(&iph->saddr, ah_attr->grh.sgid_attr->gid.raw + 12,
>> +		       sizeof(struct in_addr));
>> +		memcpy(&iph->daddr, ah_attr->grh.dgid.raw + 12,
>> +		       sizeof(struct in_addr));
>> +	} else {
>> +		skb_push(skb, sizeof(struct ipv6hdr));
>> +		skb_reset_network_header(skb);
>> +		ip6h = ipv6_hdr(skb);
>> +		ip6h->version = 6;
>> +		ip6h->nexthdr = IPPROTO_UDP;
>> +		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
>> +		       sizeof(*ip6h->flow_lbl));
>> +		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
>> +		       sizeof(struct in6_addr));
>> +		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
>> +		       sizeof(struct in6_addr));
>> +	}
> What about setting up the UDP header? It looks like this needs to be
> before the sport patch and the sport patch needs to modify here too.

Yeah, we will need to set the udp source port by calling 
rdma_flow_label_to_udp_sport (Introduced in the UDP source port series).
>> +void rdma_lag_put_ah_roce_slave(struct rdma_ah_attr *ah_attr)
>> +{
>> +	if (ah_attr->roce.xmit_slave)
>> +		dev_put(ah_attr->roce.xmit_slave);
>> +}
>> +
>> +int rdma_lag_get_ah_roce_slave(struct ib_device *device,
>> +			       struct rdma_ah_attr *ah_attr)
>> +{
>> +	struct net_device *master;
>> +	struct net_device *slave;
>> +
>> +	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
>> +	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
>> +		return 0;
>> +
>> +	rcu_read_lock();
>> +	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
>> +	if (IS_ERR(master)) {
>> +		rcu_read_unlock();
>> +		return PTR_ERR(master);
>> +	}
>> +	dev_hold(master);
>> +	rcu_read_unlock();
>> +
>> +	if (!netif_is_bond_master(master)) {
>> +		dev_put(master);
>> +		return 0;
>> +	}
>> +
>> +	slave = rdma_get_xmit_slave_udp(device, master, ah_attr);
>> +
>> +	dev_put(master);
>> +	if (!slave) {
>> +		ibdev_warn(device, "Failed to get lag xmit slave\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ah_attr->roce.xmit_slave = slave;
> Is xmit_slave is reliably NULL in the other return 0 cases?


It's hard to follow. Maybe it will be better to have this initialization 
anyway.

>
> Jason
