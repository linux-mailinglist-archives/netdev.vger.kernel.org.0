Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D7B4B66B1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiBOIyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:54:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiBOIyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:54:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40A61160C1
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:54:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTos7rtoW8DE8m7dVIYcJNnMyb7tsNNd7Vzvij7IfbHX15lViPEJurBfgOU+QOfWsGTR95CR6apCxRnILYwjbYDDJrbLGlNqAOdVXP1rYw9JpgesFDSmlagLCWpINxqfMEbMbmvy9KSA6lsKGfCX7YE+B8SAFGnuLA+XkKKFZ84oqoEKLX7ggdI0TsrXMzhQCDlE0oH6rA63JZ0SnOpq2bvSl0I+otX+0EEC5rt9+b/fe1M9qbfBeCm6eBVF82W2xVZb/SaAez0BFUoxYPS/r2xqFs+C8MH+UVT55mKXaVggjiDv/8rHqGnLrTyeoYMHV0czfce3Ps2Vfl/zrxQQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9jeYRhBPpBINannyZ1dxd73AdAqCi6ckX7EmFRo0WA=;
 b=jyS5JAQUAswgD0YxkA7NqnGbH9veG7g4W2NLYnvQnEC1yGLukm2qvUrZch28sa9LQxK9sKwwohdflPjCK+0Kpvj9HyUUuVxeyX1OHH3J9/oczfbeWPs2JgYTvnbM1py12v+6tHOPncHLwbn7e8SSLLLv4kOyluSGj+5Vn+P0hmbmK5nGx9DHtqizHOqFP5z7E6UXDHjnXMkzQsWa88vJGMcCC1o0ARk0pn49KkcJ3AYVayMHz1UpmLdthZT3RywfEn+Xre/J1MJp6UwIr5ylKBHIEdXXM6bb7XDlnkL/53tIdBj0+MbTUsoAza4EOw/CZ7apGZugePm9UHTG4eHzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9jeYRhBPpBINannyZ1dxd73AdAqCi6ckX7EmFRo0WA=;
 b=dXE1qR76KgKvOIJ3srnHrc56SaM/3grbPGAERISIzbOpUjtypISM8PVCWDS8eLgSD3CTBkekTbIvYyb4+eJeMIzjW78PayNraVaMjpuHiZeUlpkZQqOw+eVc13qla9AxEfkUW+gi9RJzuo8AFtW4gIcGGzPsnORFcuorepPvza38jRVYp0Uig82dWI/XA4223+BnGIWFmWvYXKp7cJLHV/5y+LUEAyEn9erz72FQkc1CQs7M32DwrAWgJm3ro4sjkgc82VSagrvuJK8Zx3bN/KSBjP6kPfAFl2pCHEhEPtFlJN3EAdYWSyanFnmzeN2hIp3eYW7GGwBA/j6aJykPhQ==
Received: from BN6PR1201CA0013.namprd12.prod.outlook.com
 (2603:10b6:405:4c::23) by MN2PR12MB4064.namprd12.prod.outlook.com
 (2603:10b6:208:1d3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 08:54:37 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::cd) by BN6PR1201CA0013.outlook.office365.com
 (2603:10b6:405:4c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Tue, 15 Feb 2022 08:54:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 08:54:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 08:54:36 +0000
Received: from [172.27.13.89] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 00:54:30 -0800
Message-ID: <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
Date:   Tue, 15 Feb 2022 10:54:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220214233111.1586715-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9dd75fe-1d09-41b5-9852-08d9f060cbc0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4064:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB40646405CB344C42EE3FB844DF349@MN2PR12MB4064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MjMs1T/5IKavqJMG9tN8um/444Cd0A49VLTHZNOOkXfU24v8P7m7+EGjOubgXSfKItDblJu6u2wxRXr4SiVW/4nm5Jes+ZmCpSxp655jFuZ6NhmEyNf7heJjN1/MlBXR8gZZmHUdxVDVNo2Lej37Uwd12tbg80KMvRBIWCK1HC+03z0zwn1O0ZYoky/+iQcH49ZM1/4tViVDm6LhxZCIMTv8KoS8/qrjiJ6FmQo6ki7acHphOcf2mLQS7x8kdjLiRDyacbffQNfio8i/Bc0CKP1QAgwqrKc8+29rCvyqXDdw2e99meKJ7AqX9DBTlLeaPi/5LIJ+z+m1C3ywpzNC8gmVYyK9LRLOzzzT4lS7/XEXeLc+d3GgJPHc6dlb4II75nH4IS5Zhm3uSdnXzJQGck1pdnWwhB30FHnyNQzr274wuSPV2eLN3Tn+8Kc5kNCuwGqWh71RVzyqqZXZ5dA10YWL7/H2Pimkpd02fqhBQ4yvW3wBCUV4W5+M712++YvFP/e8fBuIGT36UZYcKK5Nb1zToBr9ziJB1XWdRBbrpyaREf3D18f9yRvkfKyvyUizrmF47ilBTGIhs7vxDpKGTvGmhf19s/w8SimOeAx3pMUjObDbGkki9YULd8ytyVYDV2IKww9a9Ap+3QGG5LFe8XOqYY+14/9HR0ibcBle8IWCPWsRsVxPMXz+4LSk2po/PxR4G6WJJPA844jzRfqcAY1YoJrSan17PvgVVRxepQf9e5rGaqlGi7EnsN9tu8SM
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2616005)(8676002)(70586007)(356005)(54906003)(70206006)(110136005)(81166007)(316002)(36756003)(4326008)(16576012)(40460700003)(47076005)(31686004)(2906002)(36860700001)(83380400001)(16526019)(8936002)(336012)(426003)(31696002)(86362001)(26005)(186003)(5660300002)(82310400004)(6666004)(508600001)(53546011)(7416002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 08:54:37.3684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9dd75fe-1d09-41b5-9852-08d9f060cbc0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 01:31, Vladimir Oltean wrote:
> Currently, when a VLAN entry is added multiple times in a row to a
> bridge port, nbp_vlan_add() calls br_switchdev_port_vlan_add() each
> time, even if the VLAN already exists and nothing about it has changed:
> 
> bridge vlan add dev lan12 vid 100 master static
> 
> Similarly, when a VLAN is added multiple times in a row to a bridge,
> br_vlan_add_existing() doesn't filter at all the calls to
> br_switchdev_port_vlan_add():
> 
> bridge vlan add dev br0 vid 100 self
> 
> This behavior makes driver-level accounting of VLANs impossible, since
> it is enough for a single deletion event to remove a VLAN, but the
> addition event can be emitted an unlimited number of times.
> 
> The cause for this can be identified as follows: we rely on
> __vlan_add_flags() to retroactively tell us whether it has changed
> anything about the VLAN flags or VLAN group pvid. So we'd first have to
> call __vlan_add_flags() before calling br_switchdev_port_vlan_add(), in
> order to have access to the "bool *changed" information. But we don't
> want to change the event ordering, because we'd have to revert the
> struct net_bridge_vlan changes we've made if switchdev returns an error.
> 
> So to solve this, we need another function that tells us whether any
> change is going to occur in the VLAN or VLAN group, _prior_ to calling
> __vlan_add_flags(). In fact, we even make __vlan_add_flags() return void.
> 
> With this lookahead function in place, we can avoid notifying switchdev
> if nothing changed for the VLAN and VLAN group.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: drop the br_vlan_restore_existing() approach, just figure out
>         ahead of time what will change.
> 
>  net/bridge/br_vlan.c | 71 ++++++++++++++++++++++++++++----------------
>  1 file changed, 46 insertions(+), 25 deletions(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 1402d5ca242d..c5355695c976 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -34,36 +34,29 @@ static struct net_bridge_vlan *br_vlan_lookup(struct rhashtable *tbl, u16 vid)
>  	return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
>  }
>  
> -static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
> +static void __vlan_add_pvid(struct net_bridge_vlan_group *vg,
>  			    const struct net_bridge_vlan *v)
>  {
>  	if (vg->pvid == v->vid)
> -		return false;
> +		return;
>  
>  	smp_wmb();
>  	br_vlan_set_pvid_state(vg, v->state);
>  	vg->pvid = v->vid;
> -
> -	return true;
>  }
>  
> -static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
> +static void __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
>  {
>  	if (vg->pvid != vid)
> -		return false;
> +		return;
>  
>  	smp_wmb();
>  	vg->pvid = 0;
> -
> -	return true;
>  }
>  
> -/* return true if anything changed, false otherwise */
> -static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
> +static void __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
>  {
>  	struct net_bridge_vlan_group *vg;
> -	u16 old_flags = v->flags;
> -	bool ret;
>  
>  	if (br_vlan_is_master(v))
>  		vg = br_vlan_group(v->br);
> @@ -71,16 +64,36 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
>  		vg = nbp_vlan_group(v->port);
>  
>  	if (flags & BRIDGE_VLAN_INFO_PVID)
> -		ret = __vlan_add_pvid(vg, v);
> +		__vlan_add_pvid(vg, v);
>  	else
> -		ret = __vlan_delete_pvid(vg, v->vid);
> +		__vlan_delete_pvid(vg, v->vid);
>  
>  	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
>  		v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
>  	else
>  		v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
> +}
> +
> +/* return true if anything will change as a result of __vlan_add_flags,
> + * false otherwise
> + */
> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	u16 old_flags = v->flags;
> +	bool pvid_changed;
>  
> -	return ret || !!(old_flags ^ v->flags);
> +	if (br_vlan_is_master(v))
> +		vg = br_vlan_group(v->br);
> +	else
> +		vg = nbp_vlan_group(v->port);
> +
> +	if (flags & BRIDGE_VLAN_INFO_PVID)
> +		pvid_changed = (vg->pvid == v->vid);
> +	else
> +		pvid_changed = (vg->pvid != v->vid);
> +
> +	return pvid_changed || !!(old_flags ^ v->flags);
>  }

These two have to depend on each other, otherwise it's error-prone and
surely in the future someone will forget to update both.
How about add a "commit" argument to __vlan_add_flags and possibly rename
it to __vlan_update_flags, then add 2 small helpers like __vlan_update_flags_precommit
with commit == false and __vlan_update_flags_commit with commit == true.
Or some other naming, the point is to always use the same flow and checks
when updating the flags to make sure people don't forget.

>  
>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
> @@ -672,9 +685,13 @@ static int br_vlan_add_existing(struct net_bridge *br,
>  {
>  	int err;
>  
> -	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
> -	if (err && err != -EOPNOTSUPP)
> -		return err;
> +	*changed = __vlan_flags_would_change(vlan, flags);
> +	if (*changed) {
> +		err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
> +						 extack);
> +		if (err && err != -EOPNOTSUPP)
> +			return err;
> +	}

You should revert *changed to false in the error path below,
otherwise we will emit a notification without anything changed
if the br_vlan_is_brentry(vlan)) { } block errors out.

>  
>  	if (!br_vlan_is_brentry(vlan)) {
>  		/* Trying to change flags of non-existent bridge vlan */
> @@ -696,8 +713,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
>  		br_multicast_toggle_one_vlan(vlan, true);
>  	}
>  
> -	if (__vlan_add_flags(vlan, flags))
> -		*changed = true;
> +	__vlan_add_flags(vlan, flags);
>  
>  	return 0;
>  
> @@ -1247,11 +1263,16 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
>  	*changed = false;
>  	vlan = br_vlan_find(nbp_vlan_group(port), vid);
>  	if (vlan) {
> -		/* Pass the flags to the hardware bridge */
> -		ret = br_switchdev_port_vlan_add(port->dev, vid, flags, extack);
> -		if (ret && ret != -EOPNOTSUPP)
> -			return ret;
> -		*changed = __vlan_add_flags(vlan, flags);
> +		*changed = __vlan_flags_would_change(vlan, flags);
> +		if (*changed) {
> +			/* Pass the flags to the hardware bridge */
> +			ret = br_switchdev_port_vlan_add(port->dev, vid,
> +							 flags, extack);
> +			if (ret && ret != -EOPNOTSUPP)
> +				return ret;
> +		}
> +
> +		__vlan_add_flags(vlan, flags);
>  
>  		return 0;
>  	}

