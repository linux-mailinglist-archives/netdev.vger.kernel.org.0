Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D6F4459B0
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhKDS1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:27:35 -0400
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:29024
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232058AbhKDS1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 14:27:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyPERRHc4/WVYIx8jn/sudxCOJbRiCI4nLsEveiHnaTaPjhOMmRrWdnjea2fkegtq5sZEK450yEnRWx/K+60XBJGJjfUdqFIQ/1RKi84pw5lRhYkA0OxY7HGf4EKlQvs+74Yrvhj7jTeLd58Oe188BDWJ0erAdYLj7/d10qf+lJfCPe/qedtEpGuHPt+PFgBRFSkNHqoQAoPHFVfmodh2dor/pzNVTBxLkwqqGSiyv2U3fvvW1tKJj4p1dJP0XMOdyFNuNFe/EU52ZkyQI2Zel8QL0X7ss181Uz8V/tAmKCReucMH28NyS9vV5hZCoZpyfF3BKIy98mbKrzdB3uxQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TaHId3S0y2eFNuc+vb7PXazTn/VCFoQYMQsNmP7sEg=;
 b=U2dlmbIMJTpnmjI/3XwFbkBmnnQznoEQr0N6Nz7yYm1UMTV0+xcpq29yLgFdQ2Avcqzeq1RC3LgsnxPZZ2y14WVj5J7xL2jPVU7mWHXFUkDJ6XURlKMtNFFlmfHLHE4XzCTnLdgolRjxN+kOkHIgPw0+rZfw6CD5Dcnx9LCvuc5Men+W9T9yq14fkBbFAt1BoH9BfWqFUhHUwmIXCovF1tqAXAt9eAgO8whGgicjOJBB1ohWj61O1REU1mxPt5e+CFbnG9XauDfpEKK/VbNGKUR5OXyO5EvcE2c2O+gpYFZnPCgKLtbbd8PCHX1mw0c7FuxTyxMXVUX7l2kiYtu06g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TaHId3S0y2eFNuc+vb7PXazTn/VCFoQYMQsNmP7sEg=;
 b=fCaw2FEb+vfhy6ua+5rMq2EHFGQ1STCkEVG5qQDdtDUoMcWngltpiy5YeSqFIoRIxfVGmDEHC6W33/z1jZXbqa1xhvYlAdbsCTzOYNLMVJCPQTxNwVY41phRsqxmheqz/FOLf4I6Arscft/Hp1hsiy5fz6PhT6s4UOP1cUgzifKSm4vQB3Be/2Pq5PWlt1SZR27bhQKFWmtDayl+CehPEKyhplB9zuqIXc5YhsOHOyHp623uVSdCpNwE9PwXPXBOViX6RQbM+cII7dyuPxG57CuZ+6espY5tatG9+YNSWkJLZiqn4l3PG+sEDOZ5LuiloYVOezNIPdai+w2VgXO0qw==
Received: from MW4PR03CA0042.namprd03.prod.outlook.com (2603:10b6:303:8e::17)
 by CH0PR12MB5092.namprd12.prod.outlook.com (2603:10b6:610:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 18:24:53 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::51) by MW4PR03CA0042.outlook.office365.com
 (2603:10b6:303:8e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend
 Transport; Thu, 4 Nov 2021 18:24:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 18:24:53 +0000
Received: from [10.2.52.133] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 4 Nov
 2021 18:24:52 +0000
Subject: Re: [PATCH net-next 4/6] rtnetlink: Add support for SyncE recovered
 clock configuration
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <richardcochran@gmail.com>, <abyagowi@fb.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <idosch@idosch.org>, <mkubecek@suse.cz>, <saeed@kernel.org>,
        <michael.chan@broadcom.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
 <20211104081231.1982753-5-maciej.machnikowski@intel.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <2d379392-a381-e60a-7658-5ac695c30df1@nvidia.com>
Date:   Thu, 4 Nov 2021 11:24:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211104081231.1982753-5-maciej.machnikowski@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2ff0abd-f2cb-4251-1f2c-08d99fc06585
X-MS-TrafficTypeDiagnostic: CH0PR12MB5092:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5092B7944A0240BD8D375428CB8D9@CH0PR12MB5092.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umDRsgKw+OcBVuySjs/tOhRyy9094m4T7hP58F07z8lUMYVGUQuXqmXuPrRUzt6DAkxUZTBGi3SBJWT2bb5l5waMp8zWnHs5zRO4YEanDWsMe1OlYpBNcUDZDdx7No1cOmq5Si4sixEfwXpOpEqg6apWiMCdyqCoOuNATwzx8xUtVxYedGhjXMJjojMKcS3PIombOswEBzDDwX2gkf2VzSWcfgZDhHr39R4Zpa/5+H66JxxdvFdhSm3VIb7OKp7cciaF/bWxTFllmnDkWs8on5vdJXYmlDBdN4X5lPjNg2kIJ98WgxmhDN511lrjtSzdM+mUIJOUQqDHq5ORrHiWO0MHNCA+2olJgQIBTQezoy6bGmAhucaKf6z0Ag9By7IIP/O8qoj0CArvA90oD/+Z4QC4MfYonce1pUCH3N5cFAvZAzUGVE7b1I6kmQD+/x6Wk+ygjovzBmqs/Y9rV0iULnTMhlOuoPvxPsL0I/lQ8lAehTKPHpIzYvhkfa7x+NFxO+TC60o2QEZHg5pSqT7E1Y/WtOB/RdfqL2xxyVXBAq/go9Mi2X5IqE9LGX+BEpL1p4yHewwW0HsgfkTTx7fJZHswW3mUaGI2kHJmaix8AcRo/AkmVLZx5CHiJY5zLCUPL9ru4L1c3o66S3ZWbMpGfETe19lNPeDWU8axCZjbtoz85SxZs9VgBxdINYw+nah4ljmggS+NfulbqykNUFJ6nJ3uk+2wwd87qBpX1ixBCvU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(31696002)(36906005)(70206006)(7636003)(356005)(36756003)(86362001)(186003)(26005)(70586007)(336012)(6666004)(82310400003)(4326008)(31686004)(16526019)(54906003)(8676002)(508600001)(2906002)(83380400001)(53546011)(7416002)(36860700001)(8936002)(47076005)(2616005)(16576012)(110136005)(316002)(5660300002)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 18:24:53.3966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ff0abd-f2cb-4251-1f2c-08d99fc06585
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/4/21 1:12 AM, Maciej Machnikowski wrote:
> Add support for RTNL messages for reading/configuring SyncE recovered
> clocks.
> The messages are:
> RTM_GETRCLKRANGE: Reads the allowed pin index range for the recovered
> 		  clock outputs. This can be aligned to PHY outputs or
> 		  to EEC inputs, whichever is better for a given
> 		  application
>
> RTM_GETRCLKSTATE: Read the state of recovered pins that output recovered
> 		  clock from a given port. The message will contain the
> 		  number of assigned clocks (IFLA_RCLK_STATE_COUNT) and
> 		  a N pin inexes in IFLA_RCLK_STATE_OUT_IDX
>
> RTM_SETRCLKSTATE: Sets the redirection of the recovered clock for
> 		  a given pin
>
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
> ---


Can't we just use a single RTM msg with nested attributes ?

With separate RTM msgtype for each syncE attribute we will end up 
bloating the RTM msg namespace.

(these api's could also be in ethtool given its directly querying the 
drivers)


>   include/linux/netdevice.h      |   9 ++
>   include/uapi/linux/if_link.h   |  26 +++++
>   include/uapi/linux/rtnetlink.h |   7 ++
>   net/core/rtnetlink.c           | 174 +++++++++++++++++++++++++++++++++
>   security/selinux/nlmsgtab.c    |   3 +
>   5 files changed, 219 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ef2b381dae0c..708bd8336155 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1576,6 +1576,15 @@ struct net_device_ops {
>   	int			(*ndo_get_eec_src)(struct net_device *dev,
>   						   u32 *src,
>   						   struct netlink_ext_ack *extack);
> +	int			(*ndo_get_rclk_range)(struct net_device *dev,
> +						      u32 *min_idx, u32 *max_idx,
> +						      struct netlink_ext_ack *extack);
> +	int			(*ndo_set_rclk_out)(struct net_device *dev,
> +						    u32 out_idx, bool ena,
> +						    struct netlink_ext_ack *extack);
> +	int			(*ndo_get_rclk_state)(struct net_device *dev,
> +						      u32 out_idx, bool *ena,
> +						      struct netlink_ext_ack *extack);
>   };
>   
>   /**
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 8eae80f287e9..e27c153cfba3 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -1304,4 +1304,30 @@ enum {
>   
>   #define IFLA_EEC_MAX (__IFLA_EEC_MAX - 1)
>   
> +struct if_rclk_range_msg {
> +	__u32 ifindex;
> +};
> +
> +enum {
> +	IFLA_RCLK_RANGE_UNSPEC,
> +	IFLA_RCLK_RANGE_MIN_PIN,
> +	IFLA_RCLK_RANGE_MAX_PIN,
> +	__IFLA_RCLK_RANGE_MAX,
> +};
> +
> +struct if_set_rclk_msg {
> +	__u32 ifindex;
> +	__u32 out_idx;
> +	__u32 flags;
> +};
> +
> +#define SET_RCLK_FLAGS_ENA	(1U << 0)
> +
> +enum {
> +	IFLA_RCLK_STATE_UNSPEC,
> +	IFLA_RCLK_STATE_OUT_IDX,
> +	IFLA_RCLK_STATE_COUNT,
> +	__IFLA_RCLK_STATE_MAX,
> +};
> +
>   #endif /* _UAPI_LINUX_IF_LINK_H */
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 1d8662afd6bd..6c0d96d56ec7 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -185,6 +185,13 @@ enum {
>   	RTM_GETNEXTHOPBUCKET,
>   #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
>   
> +	RTM_GETRCLKRANGE = 120,
> +#define RTM_GETRCLKRANGE	RTM_GETRCLKRANGE
> +	RTM_GETRCLKSTATE = 121,
> +#define RTM_GETRCLKSTATE	RTM_GETRCLKSTATE
> +	RTM_SETRCLKSTATE = 122,
> +#define RTM_SETRCLKSTATE	RTM_SETRCLKSTATE
> +
>   	RTM_GETEECSTATE = 124,
>   #define RTM_GETEECSTATE	RTM_GETEECSTATE
>   
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 03bc773d0e69..bc1e050f6d38 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -5544,6 +5544,176 @@ static int rtnl_eec_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	return err;
>   }
>   
> +static int rtnl_fill_rclk_range(struct sk_buff *skb, struct net_device *dev,
> +				u32 portid, u32 seq,
> +				struct netlink_callback *cb, int flags,
> +				struct netlink_ext_ack *extack)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct if_rclk_range_msg *state_msg;
> +	struct nlmsghdr *nlh;
> +	u32 min_idx, max_idx;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (!ops->ndo_get_rclk_range)
> +		return -EOPNOTSUPP;
> +
> +	err = ops->ndo_get_rclk_range(dev, &min_idx, &max_idx, extack);
> +	if (err)
> +		return err;
> +
> +	nlh = nlmsg_put(skb, portid, seq, RTM_GETRCLKRANGE, sizeof(*state_msg),
> +			flags);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +
> +	state_msg = nlmsg_data(nlh);
> +	state_msg->ifindex = dev->ifindex;
> +
> +	if (nla_put_u32(skb, IFLA_RCLK_RANGE_MIN_PIN, min_idx) ||
> +	    nla_put_u32(skb, IFLA_RCLK_RANGE_MAX_PIN, max_idx))
> +		return -EMSGSIZE;
> +
> +	nlmsg_end(skb, nlh);
> +	return 0;
> +}
> +
> +static int rtnl_rclk_range_get(struct sk_buff *skb, struct nlmsghdr *nlh,
> +			       struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct if_eec_state_msg *state;
> +	struct net_device *dev;
> +	struct sk_buff *nskb;
> +	int err;
> +
> +	state = nlmsg_data(nlh);
> +	dev = __dev_get_by_index(net, state->ifindex);
> +	if (!dev) {
> +		NL_SET_ERR_MSG(extack, "unknown ifindex");
> +		return -ENODEV;
> +	}
> +
> +	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!nskb)
> +		return -ENOBUFS;
> +
> +	err = rtnl_fill_rclk_range(nskb, dev, NETLINK_CB(skb).portid,
> +				   nlh->nlmsg_seq, NULL, nlh->nlmsg_flags,
> +				   extack);
> +	if (err < 0)
> +		kfree_skb(nskb);
> +	else
> +		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
> +
> +	return err;
> +}
> +
> +static int rtnl_fill_rclk_state(struct sk_buff *skb, struct net_device *dev,
> +				u32 portid, u32 seq,
> +				struct netlink_callback *cb, int flags,
> +				struct netlink_ext_ack *extack)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	u32 min_idx, max_idx, src_idx, count = 0;
> +	struct if_eec_state_msg *state_msg;
> +	struct nlmsghdr *nlh;
> +	bool ena;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (!ops->ndo_get_rclk_state || !ops->ndo_get_rclk_range)
> +		return -EOPNOTSUPP;
> +
> +	err = ops->ndo_get_rclk_range(dev, &min_idx, &max_idx, extack);
> +	if (err)
> +		return err;
> +
> +	nlh = nlmsg_put(skb, portid, seq, RTM_GETRCLKSTATE, sizeof(*state_msg),
> +			flags);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +
> +	state_msg = nlmsg_data(nlh);
> +	state_msg->ifindex = dev->ifindex;
> +
> +	for (src_idx = min_idx; src_idx <= max_idx; src_idx++) {
> +		ops->ndo_get_rclk_state(dev, src_idx, &ena, extack);
> +		if (!ena)
> +			continue;
> +
> +		if (nla_put_u32(skb, IFLA_RCLK_STATE_OUT_IDX, src_idx))
> +			return -EMSGSIZE;
> +		count++;
> +	}
> +
> +	if (nla_put_u32(skb, IFLA_RCLK_STATE_COUNT, count))
> +		return -EMSGSIZE;
> +
> +	nlmsg_end(skb, nlh);
> +	return 0;
> +}
> +
> +static int rtnl_rclk_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
> +			       struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct if_eec_state_msg *state;
> +	struct net_device *dev;
> +	struct sk_buff *nskb;
> +	int err;
> +
> +	state = nlmsg_data(nlh);
> +	dev = __dev_get_by_index(net, state->ifindex);
> +	if (!dev) {
> +		NL_SET_ERR_MSG(extack, "unknown ifindex");
> +		return -ENODEV;
> +	}
> +
> +	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!nskb)
> +		return -ENOBUFS;
> +
> +	err = rtnl_fill_rclk_state(nskb, dev, NETLINK_CB(skb).portid,
> +				   nlh->nlmsg_seq, NULL, nlh->nlmsg_flags,
> +				   extack);
> +	if (err < 0)
> +		kfree_skb(nskb);
> +	else
> +		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
> +
> +	return err;
> +}
> +
> +static int rtnl_rclk_set(struct sk_buff *skb, struct nlmsghdr *nlh,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct if_set_rclk_msg *state;
> +	struct net_device *dev;
> +	bool ena;
> +	int err;
> +
> +	state = nlmsg_data(nlh);
> +	dev = __dev_get_by_index(net, state->ifindex);
> +	if (!dev) {
> +		NL_SET_ERR_MSG(extack, "unknown ifindex");
> +		return -ENODEV;
> +	}
> +
> +	if (!dev->netdev_ops->ndo_set_rclk_out)
> +		return -EOPNOTSUPP;
> +
> +	ena = !!(state->flags & SET_RCLK_FLAGS_ENA);
> +	err = dev->netdev_ops->ndo_set_rclk_out(dev, state->out_idx, ena,
> +						extack);
> +
> +	return err;
> +}
> +
>   /* Process one rtnetlink message. */
>   
>   static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
> @@ -5770,5 +5940,9 @@ void __init rtnetlink_init(void)
>   	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
>   		      0);
>   
> +	rtnl_register(PF_UNSPEC, RTM_GETRCLKRANGE, rtnl_rclk_range_get, NULL, 0);
> +	rtnl_register(PF_UNSPEC, RTM_GETRCLKSTATE, rtnl_rclk_state_get, NULL, 0);
> +	rtnl_register(PF_UNSPEC, RTM_SETRCLKSTATE, rtnl_rclk_set, NULL, 0);
> +
>   	rtnl_register(PF_UNSPEC, RTM_GETEECSTATE, rtnl_eec_state_get, NULL, 0);
>   }
> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> index 2c66e722ea9c..57c7c85edd4d 100644
> --- a/security/selinux/nlmsgtab.c
> +++ b/security/selinux/nlmsgtab.c
> @@ -91,6 +91,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
>   	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>   	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>   	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
> +	{ RTM_GETRCLKRANGE,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
> +	{ RTM_GETRCLKSTATE,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
> +	{ RTM_SETRCLKSTATE,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>   	{ RTM_GETEECSTATE,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
>   };
>   
