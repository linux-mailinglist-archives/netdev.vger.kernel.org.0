Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5C2498860
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244936AbiAXScV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:32:21 -0500
Received: from mail-mw2nam08on2081.outbound.protection.outlook.com ([40.107.101.81]:60928
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235727AbiAXScU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 13:32:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlwjIzllatmugRrZjiZvqXfV6X7j5qIUUxKtkoBFAvAhSm10lkYGBOzF9ee2XZmoMbVw+/qc4y8V8TflsGnqPdbJ8nEzw3McGa0S0U736gLUOivbQQwnM1f5Aa3gXKrdb/cNeOBj6GXbNZjNFCWqj3nR1y2G0zAiYZ20JT8PSTdoqfZniEPeDySA5W4bJYaTsjeR1YJyexZOrmt46yTH6ESAEq+wme5gZUm3TZgZ587xb4NP8T3zZ3X2je406Zty5ixcveLgqx/PD8/OhN7aLxr9kd0ZN608nSGPshDKxBVwLh/5/99845mQMizUqbxYNqXQJYm3X38XHxNYs27mxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaIz4dN1qqJZGXaZyyfwm3q+Sb5Jv/NhPdrcc6N6N3c=;
 b=IrddujEHEjvnZhqfGU11Zvw3nm27+OkDJeglad0mYg0DmlzzurbWPuE5Vhn9t7AHGvpLqkQy2pIlCFFCYqEuU+2FuewZh3Mgpn+Wd9Wj6hXUH/Yu/N0b0ice+FsQPzs3Y1KOI7WmCEuA/DiJD0QL5QuazB+345QGNqLQ/wQrvVCBXgCngxIHzmZ6MYSMjptvup65+3nsprFMslkhQ8Vvmn6RLevubs8iMT6VP4q4VluQCfc/v+Loa/vTkkOS/GPqHYUC3oPuBkMnW+oBP0/pAA8VbLlmlwb2XyotxW3IHMjzgYeQElqGhZ61isI6vxwKv2Lsxf+v5yJWhoT0dFzWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaIz4dN1qqJZGXaZyyfwm3q+Sb5Jv/NhPdrcc6N6N3c=;
 b=PjWcA5VqD48nww06FZgtRMJ1SXrvPqvBmyhoBwzPjD00eIqh8rP68zsu9sPjUifosMblnAVtIHNrldGLd1c3APcqo7bJ61dfs3QVbIaERyUgScnlGm1svXWyQ0byFGmWMKWIGVBq1FU/Xlr3Yt1II/IkrGAzZPz3xXEqQlib58gmwST/cTBD3nm2k5z2Kzpa2ABtKjQS/UyC/tH/AAlI6We9GUzzwYU/0CprYXW0b6m7e54DEhRge1q85oFNJiCs/qhjZju/5sqFa1XCIuKQITJGAJFuNQmjXv4Mp5EU/uzrug2Nduj6grsj38RCi3pFiKtBU4iV1+6PK1ZQtW2hjg==
Received: from DM6PR07CA0095.namprd07.prod.outlook.com (2603:10b6:5:337::28)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Mon, 24 Jan
 2022 18:32:18 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::e1) by DM6PR07CA0095.outlook.office365.com
 (2603:10b6:5:337::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Mon, 24 Jan 2022 18:32:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:32:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 24 Jan
 2022 18:32:17 +0000
Received: from [172.27.24.67] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 24 Jan 2022
 10:32:11 -0800
Message-ID: <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
Date:   Mon, 24 Jan 2022 20:32:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <lorenzo.bianconi@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <dsahern@kernel.org>, <komachi.yoshiki@gmail.com>,
        <brouer@redhat.com>, <toke@redhat.com>, <memxor@gmail.com>,
        <andrii.nakryiko@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84a911c7-40a6-43c0-325b-08d9df67da04
X-MS-TrafficTypeDiagnostic: MN2PR12MB4111:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4111A0968EA1E141BCE6F748DF5E9@MN2PR12MB4111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aR7NsrGFVQgkCEmp3Dy53usSshBMfr3S4GoPujRaKWDaWb9qOJszdkGsF4mb1MehtmRgJtoKBTTLjUMLMVXdNqLXclh9wWD9FfePKbPF1v59zskzaA4vsXXi+i0R/Q8RBnPXdwA7uG6/WzUXqaF0v3MQeywIwerGa9JeRbBEi0HK+KKbwmvGwJnkE9XFm3ehFD4RVk5jLlpqWEzOI0sY3u4RnhneLt5xUh8YH15bcPSF3tubNgZJBesSxBmwoj2SZ6TTfm2RY9r2YrWBjJQUGt2ZIg7++RkUx5DRvnPGJthVDZrOAcKVPJ4VomkoZyaYuYqNohq6DWOafIiShsM53N5ZAZR8deSBhqaPfnZZsCN4BL+XyFe9oU6823jc5gWwsXPbpvlgCYWheJTRP7WirftYDEHmMWKpAlXVqLQWAKZwN46HYERetjF1aMtFSF5WfUQX36B2m2EmOxPY9zqu1g1CR74POvnqBG7WfaUgtd6Vhws4I/FJO2bNtAQQhED4K5z7YEhMA6luycOroXPgfygYscNI1uPhp95qUSNfdif1LV0GZ3MpJOb1HIJtZw64Xi5a4IEOL8pwGiFdDVTei4nL7NEscSwh+lj89csFX+Xlnd4w4KjxsH0aRWX59phBQYFp6pk8948UUtBuU7qEW5RaF19recTHuamY+ZoX3LfyYq1fdU02Uyc1Qj2kg0YapNfsp3wW3J7mE0MCOGb+fWBPrCjDyG6PMd9HTSdO3rvx/rehcgmhz4S3hQujTnVn0BMcjGtQMxfHSUFA9zIvAyYcdSLEjln8fnEwDmvKb7vatPLuF3pisf6r1ALRKNjtZX7f968DFzCkfQQDtuhvQw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700004)(36840700001)(26005)(2906002)(356005)(81166007)(2616005)(5660300002)(82310400004)(6666004)(31696002)(186003)(47076005)(8936002)(70586007)(508600001)(70206006)(36860700001)(40460700003)(316002)(36756003)(336012)(426003)(110136005)(86362001)(53546011)(8676002)(83380400001)(16576012)(7416002)(16526019)(31686004)(4326008)(54906003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:32:18.0719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a911c7-40a6-43c0-325b-08d9df67da04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/01/2022 19:20, Lorenzo Bianconi wrote:
> Similar to bpf_xdp_ct_lookup routine, introduce
> br_fdb_find_port_from_ifindex unstable helper in order to accelerate
> linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
> lookup in the associated bridge fdb table and it will return the
> output ifindex if the destination address is associated to a bridge
> port or -ENODEV for BOM traffic or if lookup fails.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/bridge/br.c         | 21 +++++++++++++
>  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
>  net/bridge/br_private.h | 12 ++++++++
>  3 files changed, 91 insertions(+), 9 deletions(-)
> 

Hi Lorenzo,
Please CC bridge maintainers for bridge-related patches, I've added Roopa and the
bridge mailing list as well. Aside from that, the change is certainly interesting, I've been
thinking about a similar helper for some time now, few comments below.

Have you thought about the egress path and if by the current bridge state the packet would
be allowed to egress through the found port from the lookup? I'd guess you have to keep updating
the active ports list based on netlink events, but there's a lot of egress bridge logic that
either have to be duplicated or somehow synced. Check should_deliver() (br_forward.c) and later
egress stages, but I see how this is a good first step and perhaps we can build upon it.
There are a few possible solutions, but I haven't tried anything yet, most obvious being
yet another helper. :)

> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 1fac72cc617f..d2d1c2341d9c 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -16,6 +16,8 @@
>  #include <net/llc.h>
>  #include <net/stp.h>
>  #include <net/switchdev.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
>  
>  #include "br_private.h"
>  
> @@ -365,6 +367,17 @@ static const struct stp_proto br_stp_proto = {
>  	.rcv	= br_stp_rcv,
>  };
>  
> +#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> +BTF_SET_START(br_xdp_fdb_check_kfunc_ids)
> +BTF_ID(func, br_fdb_find_port_from_ifindex)
> +BTF_SET_END(br_xdp_fdb_check_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set br_xdp_fdb_kfunc_set = {
> +	.owner     = THIS_MODULE,
> +	.check_set = &br_xdp_fdb_check_kfunc_ids,
> +};
> +#endif
> +
>  static int __init br_init(void)
>  {
>  	int err;
> @@ -417,6 +430,14 @@ static int __init br_init(void)
>  		"need this.\n");
>  #endif
>  
> +#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &br_xdp_fdb_kfunc_set);
> +	if (err < 0) {
> +		br_netlink_fini();
> +		goto err_out6;

Add err_out7 and handle it there please. Let's keep it consistent.
Also I cannot find register_btf_kfunc_id_set() in net-next or Linus' master, but
should it be paired with an unregister on unload (br_deinit) ?

> +	}
> +#endif
> +
>  	return 0;
>  
>  err_out6:
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6ccda68bd473..cd3afa240298 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -235,30 +235,79 @@ static struct net_bridge_fdb_entry *br_fdb_find(struct net_bridge *br,
>  	return fdb;
>  }
>  
> -struct net_device *br_fdb_find_port(const struct net_device *br_dev,
> -				    const unsigned char *addr,
> -				    __u16 vid)
> +static struct net_device *
> +__br_fdb_find_port(const struct net_device *br_dev,
> +		   const unsigned char *addr,
> +		   __u16 vid, bool ts_update)
>  {
>  	struct net_bridge_fdb_entry *f;
> -	struct net_device *dev = NULL;
>  	struct net_bridge *br;
>  
> -	ASSERT_RTNL();
> -
>  	if (!netif_is_bridge_master(br_dev))
>  		return NULL;
>  
>  	br = netdev_priv(br_dev);
> -	rcu_read_lock();
>  	f = br_fdb_find_rcu(br, addr, vid);
> -	if (f && f->dst)
> -		dev = f->dst->dev;
> +
> +	if (f && f->dst) {
> +		f->updated = jiffies;
> +		f->used = f->updated;

This is wrong, f->updated should be set only if anything changed for the fdb.
Also you can optimize f->used a little bit if you check if jiffies != current value
before setting, you can have millions of packets per sec dirtying that cache line.

Aside from the above, it will change expected behaviour for br_fdb_find_port users
(mlxsw, added Ido to CC as well) because it will mark the fdb as active and refresh it
which should be done only for the ebpf helper, or might be exported through another helper
so ebpf users can decide if they want it updated. There are 2 different use cases and it is
not ok for both as we'll start refreshing fdbs that have been inactive for a while
and would've expired otherwise.

> +		return f->dst->dev;

This is wrong as well, f->dst can become NULL (fdb switched to point to the bridge itself).
You should make sure to read f->dst only once and work with the result. I know it's
been like that, but it was ok when accessed with rtnl held.

> +	}
> +	return NULL;
> +}
> +
> +struct net_device *br_fdb_find_port(const struct net_device *br_dev,
> +				    const unsigned char *addr,
> +				    __u16 vid)
> +{
> +	struct net_device *dev;
> +
> +	ASSERT_RTNL();
> +
> +	rcu_read_lock();
> +	dev = __br_fdb_find_port(br_dev, addr, vid, false);
>  	rcu_read_unlock();
>  
>  	return dev;
>  }
>  EXPORT_SYMBOL_GPL(br_fdb_find_port);
>  
> +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> +				  struct bpf_fdb_lookup *opt,
> +				  u32 opt__sz)
> +{
> +	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
> +	struct net_bridge_port *port;
> +	struct net_device *dev;
> +	int ret = -ENODEV;
> +
> +	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
> +	if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
> +		return -ENODEV;
> +
> +	rcu_read_lock();
> +
> +	dev = dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
> +	if (!dev)
> +		goto out;
> +
> +	if (unlikely(!netif_is_bridge_port(dev)))
> +		goto out;

This check shouldn't be needed if the port checks below succeed.

> +
> +	port = br_port_get_check_rcu(dev);
> +	if (unlikely(!port || !port->br))
> +		goto out;
> +
> +	dev = __br_fdb_find_port(port->br->dev, opt->addr, opt->vid, true);
> +	if (dev)
> +		ret = dev->ifindex;
> +out:
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
>  					     const unsigned char *addr,
>  					     __u16 vid)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2661dda1a92b..64d4f1727da2 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -18,6 +18,7 @@
>  #include <linux/if_vlan.h>
>  #include <linux/rhashtable.h>
>  #include <linux/refcount.h>
> +#include <linux/bpf.h>
>  
>  #define BR_HASH_BITS 8
>  #define BR_HASH_SIZE (1 << BR_HASH_BITS)
> @@ -2094,4 +2095,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
>  void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
>  		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
>  struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *m);
> +
> +#define NF_BPF_FDB_OPTS_SZ	12
> +struct bpf_fdb_lookup {
> +	u8	addr[ETH_ALEN]; /* ETH_ALEN */
> +	u16	vid;
> +	u32	ifindex;
> +};
> +
> +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> +				  struct bpf_fdb_lookup *opt,
> +				  u32 opt__sz);
>  #endif

Thanks,
 Nik
