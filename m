Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB294BC73C
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 10:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241863AbiBSJrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 04:47:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiBSJrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 04:47:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7171EED3;
        Sat, 19 Feb 2022 01:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft1LRpv4qOWneqOCzQLGvuhKc9ih6jXakU3W8zyOHZCIGqBOfV+9VxYx8TK1uqyhd/ytOT69c78DU1mza+YX+Pn2yPUAz3QvuIM+ZYdB6xm77hmBRR51H5aEyWNWMnTz1wGwqH1d9mXYL4fFxLhNrYqPzhBlfrhxdFPYvOdzrvaELvBG5TDLVIDrdROjQF7jP8tJe8OYYUyJTVYBkzAuxdYLv3EiT+ho915O5E2Ws0oEMHVob4QMOTIDft5/rIXz7CEXQ5DZy0Dcw1juMJtfL9b0BRl4zCsb5xU6mx9RG5QPE6qitfoxRA8xeoKZb+BB/WGFwVyFlCxTw/+I8wI3xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWidAe/8A4gdk6Kl8311PrlfqqyC1xvATabjBn6pkyk=;
 b=jNelv/T/Z338WPbhzV4kBD16Xp98BUphuglCs262EFkiyxInLkAFKJc9IF2qgu/ERIRVH2tWqX64ccG3FfJ0jw01f4/OkOfZK17C2WAKGjCPYZFGLpklqAyMYF4ZRYOktwXQvbk7tjWkMJrjrlXFK5At3gcXJSW4Z/hPlPNRYqjG1fzF7SZuZ6fvC1ztJ4fwiX7bbWcwke4Wp40wSlSnr8zPYxdRrMphA3zVo8PY38TB6+iZDiKUvJwMuCkcK3JjklQsB9gt7flJKrhDco4WNziL2jDh/KZpwHWFQ26p7F98fr8hEgnT4x4e1peHxOHuL6phjS+czDxETX1zSZ851w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWidAe/8A4gdk6Kl8311PrlfqqyC1xvATabjBn6pkyk=;
 b=Ej2Ge6n2InAqQomc87fweyXLr+eFIn43jiZsyuDzU/L1myrc+vf5R+ZxgZC2SPTuGiFUSoda5ouO8paHZRZzbfg6ZOfAqrBba2RF1bFymlBhh/HbLc2vHsCJPBnteuUGVmul/4xvjxRkCXT730UrMnjhwFI8wwgpWhr51+9VjIro6wwLpnkO9levH+VHhapypNGY7aAuWXIj3u/vo4X7vvtErMMPithjtaLpw/BVeVQ0UvjHhh7/QdG2XiAMBFFR5Cfy7MSt9OuJEiAQDDhYS8UWix4p53C5L5Vif0/BPGZJIoP3QBggtzfULBw8kFAEzyylE6vX+rMhHM9fbwO78Q==
Received: from DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23)
 by BN6PR12MB1938.namprd12.prod.outlook.com (2603:10b6:404:fe::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 09:46:57 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::78) by DM6PR18CA0010.outlook.office365.com
 (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Sat, 19 Feb 2022 09:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sat, 19 Feb 2022 09:46:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 19 Feb
 2022 09:46:51 +0000
Received: from [172.27.1.59] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sat, 19 Feb 2022
 01:46:41 -0800
Message-ID: <60f020b7-53b8-4f3c-ead2-8077aad8e5bb@nvidia.com>
Date:   Sat, 19 Feb 2022 11:46:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3 1/5] net: bridge: Add support for bridge port
 in locked mode
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        "Stephen Suryaputra" <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <linux-kselftest@vger.kernel.org>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-2-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220218155148.2329797-2-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6301791a-21f0-41c3-3d7f-08d9f38cc469
X-MS-TrafficTypeDiagnostic: BN6PR12MB1938:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB19389D36AF7BDBBFFB5E923CDF389@BN6PR12MB1938.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VwR+2IcBfbczkGrVi3hzF3M2Fj826fmUSL6hmApXj1IqeFPqx+9lrOH/PBjfWsm1GbiCswN/qn4laqdpaG9E61J4PlM0SqY6x/pk+uLXM3SA0notpLV5ZJHURQWBZIbuV5KH0IalHrnMAZmDeIZc2U9PhoCyBE0zmcB7VvnCFLnst67CXNnxjzGj2yMeE2DxzeQTTD+hNkIB2T6g4EljhF6Es3buQ9XyvvWD99pXHc9opDvDRlOCyS4JWsK0TnhvMEkgerUDgnm6apf3wZoJbyycSUBMi/keZHQppIp8J0hAy3J2a2C3a8gz9XyTIGGr0jMIyNc2lJGFYaLt+xmRqtqjmhaPvHSJJgw8Y5POwccF5VmSML/blLKw9UKMpUBcZ8ZxyQxkX+Y9D09lt4efbomWbfWtzkh2vAxRBGd1ZPnL3kD6lkADsdHOXpbLgI0JoZNjEljRQMc/wvWjIqR25xzIB5/RidTUQ+4widpye5BFivels6ZmSepYvaUHZ5CZtv5oYG+HoaD4rsnXTnVDqsTMS7Zhj1cce5sWzj8368zUm/l+WF64MeIfQqy+TzXG8gMDQ1vOBBBYzAqDL6LD0tNxj8b9kqwr5IihLNWufiyjxiy+x3uLTHWrjuNnDmffZjB2tTeWwfEFLcoAzvPZWH+gHvvx40BrCNncf7IbPM8v8yzF1VWGtFFbcVKO5QFD7ZJhi0JvN4+jwWugFAZa9YEXoKGdAySZmnY/O0dmlRcRYRnLgrvx8FZW7BJyYn/h
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(4326008)(31696002)(8936002)(31686004)(7416002)(36860700001)(70586007)(16526019)(82310400004)(8676002)(2906002)(26005)(186003)(70206006)(86362001)(53546011)(36756003)(83380400001)(81166007)(508600001)(2616005)(356005)(6666004)(40460700003)(110136005)(316002)(47076005)(54906003)(336012)(16576012)(426003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 09:46:56.4744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6301791a-21f0-41c3-3d7f-08d9f38cc469
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1938
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

On 18/02/2022 17:51, Hans Schultz wrote:
> In a 802.1X scenario, clients connected to a bridge port shall not
> be allowed to have traffic forwarded until fully authenticated.
> A static fdb entry of the clients MAC address for the bridge port
> unlocks the client and allows bidirectional communication.
> 
> This scenario is facilitated with setting the bridge port in locked
> mode, which is also supported by various switchcore chipsets.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  include/linux/if_bridge.h    |  1 +
>  include/uapi/linux/if_link.h |  1 +
>  net/bridge/br_input.c        | 10 +++++++++-
>  net/bridge/br_netlink.c      |  6 +++++-
>  4 files changed, 16 insertions(+), 2 deletions(-)
> 

Hi Hans,
The patch looks good overall, I have one minor cosmetic comment below.

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 509e18c7e740..3aae023a9353 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -58,6 +58,7 @@ struct br_ip_list {
>  #define BR_MRP_LOST_CONT	BIT(18)
>  #define BR_MRP_LOST_IN_CONT	BIT(19)
>  #define BR_TX_FWD_OFFLOAD	BIT(20)
> +#define BR_PORT_LOCKED		BIT(21)
>  
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
>  
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 6218f93f5c1a..a45cc0a1f415 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -537,6 +537,7 @@ enum {
>  	IFLA_BRPORT_MRP_IN_OPEN,
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
> +	IFLA_BRPORT_LOCKED,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index b50382f957c1..e99f635ff727 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -81,6 +81,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	if (!p || p->state == BR_STATE_DISABLED)
>  		goto drop;
>  
> +	br = p->br;
>  	brmctx = &p->br->multicast_ctx;
>  	pmctx = &p->multicast_ctx;
>  	state = p->state;
> @@ -88,10 +89,17 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  				&state, &vlan))
>  		goto out;
>  
> +	if (p->flags & BR_PORT_LOCKED) {
> +		struct net_bridge_fdb_entry *fdb_src =
> +			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);

Please leave an empty line between variable declaration and the code.

> +		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> +			goto drop;
> +	}
> +

With the above change you can add my Acked-by tag.

Thanks,
 Nik
