Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B449C9E4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241426AbiAZMjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:39:54 -0500
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:58080
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234178AbiAZMjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:39:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0L8cJTpKOjOCWzx+mpML8XZ2gZ1ANLHHNl+pGpZ4BNFa4zSoa2+dAhAODBE0+LIVjUveQli8BHTy421zIMwiH8NefG41J7jLSi8T5FLPGFNlUzbvZtw94bkFZnRcTeiyaDoqAJtWSYNeF/NczeDxKlE2w0tjjR/RejJDBQShhT2nZkevbjzpcq/H0zCf08rIToHC5v3LaWn61sPz/EZZn0Tz+o9BIwqWwIEpN0j8mX1U7KctuQKtEMobPeBTFo8RzuG4PeU7kdoG161pQN1aanHarmOXc5v/iFKly57BYZMZeyXZ271f/J/0U4ZV6AXi7Zyq6H6I0jaBLYgacI9fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPp14XIVYAgUDAZDl8SmIvOGlme1mCn9bJPoVGoEuhY=;
 b=bsSw4kR2lczQAr3e+mUhFOzc2cuISS1sREnYMMU/J+ZaONTvyTRmPbyPaLYfs3ksqd+htURXFNx4fhjYzaYOZWA5ywkMxj1eD3taSO3UO/vFu6jsRbgWNB+pAskqR2qu3ItsU+dMnUocGNjhBlKkL9QJBuUF2eq8mZ1IiTaAAkHm2qB3Pd4KhcA8ayZNNCIlgGmDPUoPTDpW2nkRICjU4xlWX0gMbaLdhYLJRps9XCx+iQusCK1pZYkOas68qKjbpY3Eb6zJNZDT/uIlJCq5qDYKgTfwPoik7S8QgMASquE5YQSm9aFDnDpE0fVAYu2erX3XmlI2BaycqLrmsH8R7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPp14XIVYAgUDAZDl8SmIvOGlme1mCn9bJPoVGoEuhY=;
 b=ITrQK3SOuTvKwGazvP7Qs4w7lP6YJ3+vQ2GDh0+90XsQDRbHTyhcH4JWdH+L+xGu4k9az5rn5qmQxOS4HNIcVtmxtzPxmaNppf7LY9uXqL2RFc6cbJ6JABkIQRgm+UTScKKATxKkdPnPRDehG9GYaWxAgrh0yWXfFjm3Y6/rKn4hO47Z+5ndoQU+pH3dOi8adUuXWLtbd7nZU0Ibs2r9B2JaP0sgWiFVc6gXjkrqPaE0pmyUufmq5M49p7lXiOnbuqenlaDKpWvn098BF6v8oA+t83ZxEHwdqSI97hxt1+Oe7ekiJcK+PVt6FNhKBqeHaqfg7ID9V/Y/+etr/yJCeg==
Received: from MWHPR1201CA0002.namprd12.prod.outlook.com
 (2603:10b6:301:4a::12) by CY4PR1201MB0102.namprd12.prod.outlook.com
 (2603:10b6:910:1b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 12:39:51 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4a:cafe::37) by MWHPR1201CA0002.outlook.office365.com
 (2603:10b6:301:4a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Wed, 26 Jan 2022 12:39:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 12:39:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 12:39:49 +0000
Received: from [172.27.15.168] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 26 Jan 2022
 04:39:40 -0800
Message-ID: <113d070a-6df1-66c2-1586-94591bc5aada@nvidia.com>
Date:   Wed, 26 Jan 2022 14:39:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <lorenzo.bianconi@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <dsahern@kernel.org>, <komachi.yoshiki@gmail.com>,
        <brouer@redhat.com>, <toke@redhat.com>, <memxor@gmail.com>,
        <andrii.nakryiko@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
 <YfEwLrB6JqNpdUc0@lore-desk>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YfEwLrB6JqNpdUc0@lore-desk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75daba7b-91c8-424e-bdd1-08d9e0c8f1b4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0102:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB010284CDA7662E59D761388CDF209@CY4PR1201MB0102.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQEdf6ZkH8HuaMMkqEjw8UyYeExFx2DVaHO9s+26QaKAnNx1vLrLxBbDcCNjQ1PpDo9/Q4MvV7ktO50kg04rrqwMGU34n0HAj25aXousz7g4qKMFo55vZbtieL0t9wg9jlQ5ea2a0k0BCmNT7uTE1gBIAVcw0QQeAuJMwrvdNRXAjnSnmstSnXz4JX7wabZ+Sg4A1mH0p6xV1a6l3uGPUGG/dHntV7xQ33sLOZ7zi53boQmv2cnud28BMI9ALITJyFpO2S5RaZItT3g+g1FSDQXcNd1p7/WO23gQ8/um2amXbADMVdzxy0ZAq0IzDl061wGgxKFnWFWELwm+B7F1HXazVYgKi0UtG3D+TvgriLLfzhv5UJIFvg0obD1c+Af/GsMlEybP1CIi+wPqK1O9KVmFFFbgdgswxMUS3jPQZVDMFoUbm0w2WuGzRxJSjkQiXCLgNtPdDcUoy4cysphteuTjPNj8s3AU5ZbJ/uV0bjtP9AdaSALvvbJj4s0sAhPxClbvkwaQ4ju6Gk1mgLhjcoAKCA3TXXFzCbhhV4v1cUocVghYyO1fCN1SrOOr96p70zJdtLmHrmO7Oc1jLKB3Sr5OrXUP0whgMGQZcLCoSlROgWDLo/QeMz9M0MVruHpnZ3zJzWL6fI4FhG6FJ/GbCxcJTA4AwQC85kY4eoOtI35KbUX8gdblaHabYRa0JhSAc+/0v99XGRNNPz0ijqjgB9TFKl0Y2SHXM1Tv/vACl7gWZ+Gi/ihj0dKGne1fTlX9rodYH3M7CycWYHt86zDjDvxlDu5TvQL4fpb+ubZGzj9AhYWOeJXujHL8AkOnKwQclUd79erlFHeqpng7ChV81Q==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(2906002)(54906003)(70206006)(36860700001)(70586007)(5660300002)(356005)(40460700003)(7416002)(36756003)(82310400004)(81166007)(2616005)(4326008)(31686004)(6916009)(508600001)(86362001)(426003)(6666004)(16576012)(8936002)(186003)(16526019)(53546011)(47076005)(336012)(8676002)(31696002)(316002)(83380400001)(26005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 12:39:50.1464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75daba7b-91c8-424e-bdd1-08d9e0c8f1b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 13:27, Lorenzo Bianconi wrote:
>> On 24/01/2022 19:20, Lorenzo Bianconi wrote:
>>> Similar to bpf_xdp_ct_lookup routine, introduce
>>> br_fdb_find_port_from_ifindex unstable helper in order to accelerate
>>> linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
>>> lookup in the associated bridge fdb table and it will return the
>>> output ifindex if the destination address is associated to a bridge
>>> port or -ENODEV for BOM traffic or if lookup fails.
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>  net/bridge/br.c         | 21 +++++++++++++
>>>  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
>>>  net/bridge/br_private.h | 12 ++++++++
>>>  3 files changed, 91 insertions(+), 9 deletions(-)
>>>
>>
>> Hi Lorenzo,
> 
> Hi Nikolay,
> 
> thx for the review.
> 
>> Please CC bridge maintainers for bridge-related patches, I've added Roopa and the
>> bridge mailing list as well. Aside from that, the change is certainly interesting, I've been
>> thinking about a similar helper for some time now, few comments below.
> 
> yes, sorry for that. I figured it out after sending the series out.
> 
>>
>> Have you thought about the egress path and if by the current bridge state the packet would
>> be allowed to egress through the found port from the lookup? I'd guess you have to keep updating
>> the active ports list based on netlink events, but there's a lot of egress bridge logic that
>> either have to be duplicated or somehow synced. Check should_deliver() (br_forward.c) and later
>> egress stages, but I see how this is a good first step and perhaps we can build upon it.
>> There are a few possible solutions, but I haven't tried anything yet, most obvious being
>> yet another helper. :)
> 
> ack, right but I am bit worried about adding too much logic and slow down xdp
> performances. I guess we can investigate first the approach proposed by Alexei
> and then revaluate. Agree?
> 

Sure, that approach sounds very interesting, but my point was that bypassing the ingress
and egress logic defeats most of the bridge features. You just get an fdb hash table which
you can build today with ebpf without any changes to the kernel. :) You have multiple states,
flags and options for each port and each vlan which can change dynamically based on external
events (e.g. STP, config changes etc) and they can affect forwarding even if the fdbs remain
in the table.
One (untested, potential) way is to speedup full flows that have successfully passed from ingress to
egress for some period of time and flush them based on related events that might have affected
them, but that is very different. Another way would be to replicate some of that logic in ebpf
which would hit performance, and would probably also require more helpers. It would be interesting
to see how this problem would be solved.

>>
>>> diff --git a/net/bridge/br.c b/net/bridge/br.c
>>> index 1fac72cc617f..d2d1c2341d9c 100644
>>> --- a/net/bridge/br.c
>>> +++ b/net/bridge/br.c
>>> @@ -16,6 +16,8 @@
>>>  #include <net/llc.h>
>>>  #include <net/stp.h>
>>>  #include <net/switchdev.h>
>>> +#include <linux/btf.h>
>>> +#include <linux/btf_ids.h>
>>>  
>>>  #include "br_private.h"
>>>  
>>> @@ -365,6 +367,17 @@ static const struct stp_proto br_stp_proto = {
>>>  	.rcv	= br_stp_rcv,
>>>  };
>>>  
>>> +#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
>>> +BTF_SET_START(br_xdp_fdb_check_kfunc_ids)
>>> +BTF_ID(func, br_fdb_find_port_from_ifindex)
>>> +BTF_SET_END(br_xdp_fdb_check_kfunc_ids)
>>> +
>>> +static const struct btf_kfunc_id_set br_xdp_fdb_kfunc_set = {
>>> +	.owner     = THIS_MODULE,
>>> +	.check_set = &br_xdp_fdb_check_kfunc_ids,
>>> +};
>>> +#endif
>>> +
>>>  static int __init br_init(void)
>>>  {
>>>  	int err;
>>> @@ -417,6 +430,14 @@ static int __init br_init(void)
>>>  		"need this.\n");
>>>  #endif
>>>  
>>> +#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
>>> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &br_xdp_fdb_kfunc_set);
>>> +	if (err < 0) {
>>> +		br_netlink_fini();
>>> +		goto err_out6;
>>
>> Add err_out7 and handle it there please. Let's keep it consistent.
>> Also I cannot find register_btf_kfunc_id_set() in net-next or Linus' master, but
>> should it be paired with an unregister on unload (br_deinit) ?
> 
> I guess at the time I sent the series it was just in bpf-next but now it should
> be in net-next too.
> I do not think we need a unregister here.
> @Kumar: agree?
> 

Oh, my bad. I obviously should've looked at the bpf tree. :)

>>
>>> +	}
>>> +#endif
>>> +
>>>  	return 0;
>>>  
>>>  err_out6:
>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>> index 6ccda68bd473..cd3afa240298 100644
>>> --- a/net/bridge/br_fdb.c
>>> +++ b/net/bridge/br_fdb.c
>>> @@ -235,30 +235,79 @@ static struct net_bridge_fdb_entry *br_fdb_find(struct net_bridge *br,
>>>  	return fdb;
>>>  }
>>>  
>>> -struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>>> -				    const unsigned char *addr,
>>> -				    __u16 vid)
>>> +static struct net_device *
>>> +__br_fdb_find_port(const struct net_device *br_dev,
>>> +		   const unsigned char *addr,
>>> +		   __u16 vid, bool ts_update)
>>>  {
>>>  	struct net_bridge_fdb_entry *f;
>>> -	struct net_device *dev = NULL;
>>>  	struct net_bridge *br;
>>>  
>>> -	ASSERT_RTNL();
>>> -
>>>  	if (!netif_is_bridge_master(br_dev))
>>>  		return NULL;
>>>  
>>>  	br = netdev_priv(br_dev);
>>> -	rcu_read_lock();
>>>  	f = br_fdb_find_rcu(br, addr, vid);
>>> -	if (f && f->dst)
>>> -		dev = f->dst->dev;
>>> +
>>> +	if (f && f->dst) {
>>> +		f->updated = jiffies;
>>> +		f->used = f->updated;
>>
>> This is wrong, f->updated should be set only if anything changed for the fdb.
>> Also you can optimize f->used a little bit if you check if jiffies != current value
>> before setting, you can have millions of packets per sec dirtying that cache line.
> 
> ack, right. I will fix it.
> 
>>
>> Aside from the above, it will change expected behaviour for br_fdb_find_port users
>> (mlxsw, added Ido to CC as well) because it will mark the fdb as active and refresh it
>> which should be done only for the ebpf helper, or might be exported through another helper
>> so ebpf users can decide if they want it updated. There are 2 different use cases and it is
>> not ok for both as we'll start refreshing fdbs that have been inactive for a while
>> and would've expired otherwise.
> 
> This is a bug actually. I forgot to check ts_update in the if condition,
> something like:
> 
> if (f && f->dst && ts_update) {
>  ...
>  }
> 
>>
>>> +		return f->dst->dev;
>>
>> This is wrong as well, f->dst can become NULL (fdb switched to point to the bridge itself).
>> You should make sure to read f->dst only once and work with the result. I know it's
>> been like that, but it was ok when accessed with rtnl held.
> 
> uhm, right. I will fix it.
> 
>>
>>> +	}
>>> +	return NULL;
>>> +}
>>> +
>>> +struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>>> +				    const unsigned char *addr,
>>> +				    __u16 vid)
>>> +{
>>> +	struct net_device *dev;
>>> +
>>> +	ASSERT_RTNL();
>>> +
>>> +	rcu_read_lock();
>>> +	dev = __br_fdb_find_port(br_dev, addr, vid, false);
>>>  	rcu_read_unlock();
>>>  
>>>  	return dev;
>>>  }
>>>  EXPORT_SYMBOL_GPL(br_fdb_find_port);
>>>  
>>> +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
>>> +				  struct bpf_fdb_lookup *opt,
>>> +				  u32 opt__sz)
>>> +{
>>> +	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
>>> +	struct net_bridge_port *port;
>>> +	struct net_device *dev;
>>> +	int ret = -ENODEV;
>>> +
>>> +	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
>>> +	if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
>>> +		return -ENODEV;
>>> +
>>> +	rcu_read_lock();
>>> +
>>> +	dev = dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
>>> +	if (!dev)
>>> +		goto out;
>>> +
>>> +	if (unlikely(!netif_is_bridge_port(dev)))
>>> +		goto out;
>>
>> This check shouldn't be needed if the port checks below succeed.
> 
> ack, I will fix it.
> 
> Regards,
> Lorenzo
> 
>>
>>> +
>>> +	port = br_port_get_check_rcu(dev);
>>> +	if (unlikely(!port || !port->br))
>>> +		goto out;
>>> +
>>> +	dev = __br_fdb_find_port(port->br->dev, opt->addr, opt->vid, true);
>>> +	if (dev)
>>> +		ret = dev->ifindex;
>>> +out:
>>> +	rcu_read_unlock();
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>  struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
>>>  					     const unsigned char *addr,
>>>  					     __u16 vid)
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index 2661dda1a92b..64d4f1727da2 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -18,6 +18,7 @@
>>>  #include <linux/if_vlan.h>
>>>  #include <linux/rhashtable.h>
>>>  #include <linux/refcount.h>
>>> +#include <linux/bpf.h>
>>>  
>>>  #define BR_HASH_BITS 8
>>>  #define BR_HASH_SIZE (1 << BR_HASH_BITS)
>>> @@ -2094,4 +2095,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
>>>  void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
>>>  		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
>>>  struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *m);
>>> +
>>> +#define NF_BPF_FDB_OPTS_SZ	12
>>> +struct bpf_fdb_lookup {
>>> +	u8	addr[ETH_ALEN]; /* ETH_ALEN */
>>> +	u16	vid;
>>> +	u32	ifindex;
>>> +};
>>> +
>>> +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
>>> +				  struct bpf_fdb_lookup *opt,
>>> +				  u32 opt__sz);
>>>  #endif
>>
>> Thanks,
>>  Nik

