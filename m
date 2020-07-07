Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704AF216A93
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgGGKkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:40:37 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:1935
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbgGGKkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 06:40:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx904Ge25ErxfSb78PKZkXpTFn0/qh5q9XVZLVvLtCV8BLEoRS7+GNholG6cXhqPVC1lu55xO0e1FaNqS9nNKeYszNtyuv9PDL6CqXUX9JvUPT7cmRdQ1ST9EA7ttjL7wwKUksTq39Hy+sKPO8EqrOuy4TVuR0EJw7cIGl9DGiRN/rmNsb/lyzCrDd1kVtJd9w8GcUjGvRdXgpog+V3kocVB8WJpmE2hs04HuOK4CAqRKIhA+bf+5nisiwruVYBTu/TjR3wIiGdA2S3T92Tb4Mqv0tNfTinkSDdxsvyRtb91/Zb94/mNNlUooInafU5cbi/pyer5ErE7CfJRk8XQqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifrJfh4u2Gj25bYqDdTOveFdAP5aO8rUp2V8dQxkXGo=;
 b=Oc+tw6CIbJwiFylMycsZspezQLwKVPkWM+mjMX0v4QoIV23qenQSlVJe8khLiVuFMVpgUi8DNKdGvea2znQ/TQuuG+IMpykGbdT7G6MZO8P7tWoJWnYOuh7tb5WJnJYsSVQztn18usuLIeAbXAuq9Sk/JV60ed7vQctmWZjqEvLDYGB1yeyqunT/iAbFjZOsLE78N5RaCAvTaVTumTAE0R5DpCFtch7aEe9OGvzsK/T1QEbuunI+7ayc6G/AtBuFLpp7/rfZpxwcvr+m8pCxnfHQLPikSNCXa068Qhls9SCANKA3/R+Qpgg2tSqv1atx6QT8vgBt7B6KHkVxn9mDvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifrJfh4u2Gj25bYqDdTOveFdAP5aO8rUp2V8dQxkXGo=;
 b=lhcJelWBV7T8xNUCiNGVFYKzf9iU9Jjtu4KH2tyshNBNFQDcjhEVANQffk9JJK63IrBai6EC5ODAsG4bEqABlAlb3RFVdMCabcAvFPRWB5CQDPEq4Qfxb2s0ZIQBcmvCKy/9vtGu3V99oDS2pkCQbBk1ckwA2pN95gNw9K4Fbjs=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB6437.eurprd05.prod.outlook.com (2603:10a6:20b:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Tue, 7 Jul
 2020 10:40:27 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 10:40:27 +0000
Subject: Re: [RFC PATCH] sch_htb: Hierarchical QoS hardware offload
To:     netdev@vger.kernel.org
Cc:     Yossi Kuperman <yossiku@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Dave Taht <dave.taht@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
References: <20200626104610.21185-1-maximmi@mellanox.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <6ae323f1-648b-0849-4e03-839c61f71818@mellanox.com>
Date:   Tue, 7 Jul 2020 13:40:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200626104610.21185-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0035.eurprd03.prod.outlook.com
 (2603:10a6:208:14::48) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.44.1.235] (37.57.128.233) by AM0PR03CA0035.eurprd03.prod.outlook.com (2603:10a6:208:14::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Tue, 7 Jul 2020 10:40:26 +0000
X-Originating-IP: [37.57.128.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 070f9ec1-5789-46e9-cfe5-08d822622982
X-MS-TrafficTypeDiagnostic: AM6PR05MB6437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6437791ED2A0B36C9E86E1F4D1660@AM6PR05MB6437.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BfLvBZjolVbAWqcG8wXGR8kspvy8/Y2QzG3icU7YGuY84zAZTZZcU7a3grnJ9pSftRxqwZRSp2qozC8tLHHs3SdPQg4DkGkI6zabJ5lL7MoZo4kXE5JHGoh3s467F8neTwnbxMvY1KeOpMPGVN/f7HQXlg4HCBhMClPnEMeMRLl0bwYDVLRH2lEY80PQkPPaoozAViZJbMrYdVYdrJaZIL4DPYenXqjqneH+bSYPyra+LntyAuA601MU91OMbKPzuqASKCVVRw3k4jZCwuvY9Hovu5+lP0Ls9F+M2LYoCTuCFQtmPg3LBeJf6Dl/YabpXx0efIOvoaje9/P51NjSXE4ygNTTOlxD4B95F3EGFbk8By6W7R76eg1gc77CUsNnNPdauTCloqHjwKE3lF8AhgoDurOQhYEJhmipiQ5oFikXR4Wt0I39m4U2E+0MfMTKN7nDjQ9FI6oWbbc00QQt/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(4326008)(66946007)(6916009)(956004)(66476007)(66556008)(2616005)(966005)(107886003)(30864003)(31696002)(83380400001)(316002)(36756003)(86362001)(478600001)(8936002)(8676002)(16576012)(54906003)(2906002)(55236004)(6486002)(52116002)(31686004)(26005)(5660300002)(16526019)(186003)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IlQk8qxVtS3vQFxOcKPAHrLcMhWNFEJobPTyrY8uNiaCy8Dn+u7DV+J46YCXlfTZW/CUj+UuCY3RzaD0lSHwdKoHwHaDf0noC8L+j4PbIlvxueu1zO3JtUVd7sIehG2duXhiJME+wC53+xz8/kcpYMZ9ZsUUl3OlpOZQA/tfqA4yeUsT6a+rQbGZhMGXEwDaWX2+K6D7M7Y9SvAEVL5mNR7bwN5b9JV4inV6CJ5tUhMjfc4wpFAxlb4gVVgG+OQz3hlgQLstvRNvkoVN7YaxodgSCKSX4riDjeAo9blHeNKXDJ5DccUITBY3RtbLxqREPht5IrQfnWYnPJPVeUK9Pi9AGcg1QEUevZZI7cUB5ZcrI6TYT8vzwQtwYC6qlxDaXZDqcxylW7gzA2S63+VgVjhGDWttmi8Bmrq5rR+heEE2QucVeyC9i8ve9078Y0CRUkusLAO4Gtr64AUNH8sgdyvgntQg8NeX3OLwZWe6LU/nq9jpOw3OtgDl1oMjWpoq
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070f9ec1-5789-46e9-cfe5-08d822622982
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 10:40:27.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0ZEBFw8Pr2Kt1BaEoHSzGs69vfXXUcUzIQQSF7iBUJs3MFAoYW6bB8RBqN5Z4s+UOiid7d5AF8+eZ6fS6uMCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6437
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comments are very welcome before I move to the full implementation.

On 2020-06-26 13:46, Maxim Mikityanskiy wrote:
> This patch is a follow-up for the RFC posted earlier [1]. You can find a
> detailed description of the motivation there, and this patch is RFC code
> that shows possible implementation. The main changes are in
> net/sched/sch_htb.c file, and this patch also contains stubs for mlx5
> that show the driver API.
> 
> HTB doesn't scale well because of contention on a single lock, and it
> also consumes CPU. Mellanox hardware supports hierarchical rate limiting
> that can be leveraged by offloading the functionality of HTB.
> 
> Our solution addresses two problems of HTB:
> 
> 1. Contention by flow classification. Currently the filters are attached
> to the HTB instance as follows:
> 
>      # tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80
>      classid 1:10
> 
> It's possible to move classification to clsact egress hook, which is
> thread-safe and lock-free:
> 
>      # tc filter add dev eth0 egress protocol ip flower dst_port 80
>      action skbedit priority 1:10
> 
> This way classification still happens in software, but the lock
> contention is eliminated, and it happens before selecting the TX queue,
> allowing the driver to translate the class to the corresponding hardware
> queue.
> 
> Note that this is already compatible with non-offloaded HTB and doesn't
> require changes to the kernel nor iproute2.
> 
> 2. Contention by handling packets. HTB is not multi-queue, it attaches
> to a whole net device, and handling of all packets takes the same lock.
> Our solution offloads the logic of HTB to the hardware and registers HTB
> as a multi-queue qdisc, similarly to how mq qdisc does, i.e. HTB is
> attached to the netdev, and each queue has its own qdisc. The control
> flow is performed by HTB, it replicates the hierarchy of classes in
> hardware by calling callbacks of the driver. Leaf classes are presented
> by hardware queues. The data path works as follows: a packet is
> classified by clsact, the driver selectes the hardware queue according
> to its class, and the packet is enqueued into this queue's qdisc.
> 
> I'm looking forward to hearing feedback on such implementation. All
> feedback will be much appreciated.
> 
> Thanks,
> Max
> 
> [1]: https://www.spinics.net/lists/netdev/msg628422.html
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  38 ++-
>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  12 +
>   include/linux/netdevice.h                     |   1 +
>   include/net/pkt_cls.h                         |  12 +
>   include/net/sch_generic.h                     |  14 +-
>   include/uapi/linux/pkt_sched.h                |   1 +
>   net/sched/sch_htb.c                           | 262 +++++++++++++++++-
>   tools/include/uapi/linux/pkt_sched.h          |   1 +
>   9 files changed, 320 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 3dad3fe03e7e..23841f6682f6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -70,6 +70,7 @@ struct page_pool;
>   #define MLX5E_SW2HW_MTU(params, swmtu) ((swmtu) + ((params)->hard_mtu))
>   
>   #define MLX5E_MAX_NUM_TC	8
> +#define MLX5E_MAX_NUM_HTB_QUEUES 1024
>   
>   #define MLX5_RX_HEADROOM NET_SKB_PAD
>   #define MLX5_SKB_FRAG_SZ(len)	(SKB_DATA_ALIGN(len) +	\
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 88ae81ba03fc..56803833643d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3562,6 +3562,26 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
>   	return err;
>   }
>   
> +static int mlx5e_setup_tc_htb(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
> +{
> +	switch (htb->command) {
> +	case TC_HTB_CREATE:
> +		pr_info("%s: create\n", __func__);
> +		return 0;
> +	case TC_HTB_DESTROY:
> +		pr_info("%s: destroy\n", __func__);
> +		return 0;
> +	case TC_HTB_NEW_LEAF:
> +		pr_info("%s: new leaf %lx\n", __func__, htb->classid);
> +		return 0;
> +	case TC_HTB_DEL_LEAF:
> +		pr_info("%s: del leaf %lx\n", __func__, htb->classid);
> +		return 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>   static LIST_HEAD(mlx5e_block_cb_list);
>   
>   static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
> @@ -3581,6 +3601,8 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
>   	}
>   	case TC_SETUP_QDISC_MQPRIO:
>   		return mlx5e_setup_tc_mqprio(priv, type_data);
> +	case TC_SETUP_QDISC_HTB:
> +		return mlx5e_setup_tc_htb(priv, type_data);
>   	default:
>   		return -EOPNOTSUPP;
>   	}
> @@ -3751,20 +3773,22 @@ static int set_feature_cvlan_filter(struct net_device *netdev, bool enable)
>   	return 0;
>   }
>   
> -#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
> -static int set_feature_tc_num_filters(struct net_device *netdev, bool enable)
> +static int set_feature_hw_tc(struct net_device *netdev, bool enable)
>   {
>   	struct mlx5e_priv *priv = netdev_priv(netdev);
>   
> +#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
>   	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
>   		netdev_err(netdev,
>   			   "Active offloaded tc filters, can't turn hw_tc_offload off\n");
>   		return -EINVAL;
>   	}
> +#endif
> +
> +	// TODO: HTB offload.
>   
>   	return 0;
>   }
> -#endif
>   
>   static int set_feature_rx_all(struct net_device *netdev, bool enable)
>   {
> @@ -3862,9 +3886,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
>   	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
>   	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
>   				    set_feature_cvlan_filter);
> -#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
> -	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_tc_num_filters);
> -#endif
> +	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_hw_tc);
>   	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL, set_feature_rx_all);
>   	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXFCS, set_feature_rx_fcs);
>   	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_RX, set_feature_rx_vlan);
> @@ -5018,6 +5040,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>   		netdev->hw_features	 |= NETIF_F_NTUPLE;
>   #endif
>   	}
> +	// TODO: HTB offload.
> +	netdev->features |= NETIF_F_HW_TC;
>   
>   	netdev->features         |= NETIF_F_HIGHDMA;
>   	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
> @@ -5353,7 +5377,7 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
>   	int err;
>   
>   	netdev = alloc_etherdev_mqs(sizeof(struct mlx5e_priv),
> -				    nch * profile->max_tc,
> +				    nch * profile->max_tc + MLX5E_MAX_NUM_HTB_QUEUES,
>   				    nch * profile->rq_groups);
>   	if (!netdev) {
>   		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 320946195687..434b482a3dd3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -74,6 +74,18 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
>   	int up = 0;
>   	int ch_ix;
>   
> +	// TODO: Map unset priority to the standard algorithm.
> +	// TODO: Map priority (==class) to queue and select it.
> +	if (skb->priority) {
> +		// TODO: Check that TC_H_MAJ corresponds to the HTB offloaded qdisc.
> +		unsigned long class = TC_H_MIN(skb->priority);
> +
> +		// TODO: Map to queue and return it.
> +		// TODO: False positives with MQ.
> +		netdev_info(dev, "TX from class %lu\n", class);
> +		return 0;
> +	}
> +
>   	if (!netdev_get_num_tc(dev))
>   		return txq_ix;
>   
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6fc613ed8eae..7227d988576d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -859,6 +859,7 @@ enum tc_setup_type {
>   	TC_SETUP_QDISC_ETS,
>   	TC_SETUP_QDISC_TBF,
>   	TC_SETUP_QDISC_FIFO,
> +	TC_SETUP_QDISC_HTB,
>   };
>   
>   /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index ff017e5b3ea2..97523ca54c6b 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -734,6 +734,18 @@ struct tc_mq_qopt_offload {
>   	};
>   };
>   
> +enum tc_htb_command {
> +	TC_HTB_CREATE,
> +	TC_HTB_DESTROY,
> +	TC_HTB_NEW_LEAF,
> +	TC_HTB_DEL_LEAF,
> +};
> +
> +struct tc_htb_qopt_offload {
> +	enum tc_htb_command command;
> +	unsigned long classid;
> +};
> +
>   enum tc_red_command {
>   	TC_RED_REPLACE,
>   	TC_RED_DESTROY,
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index c510b03b9751..73162736dcfe 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -559,14 +559,20 @@ static inline struct net_device *qdisc_dev(const struct Qdisc *qdisc)
>   	return qdisc->dev_queue->dev;
>   }
>   
> -static inline void sch_tree_lock(const struct Qdisc *q)
> +static inline void sch_tree_lock(struct Qdisc *q)
>   {
> -	spin_lock_bh(qdisc_root_sleeping_lock(q));
> +	if (q->flags & TCQ_F_MQROOT)
> +		spin_lock_bh(qdisc_lock(q));
> +	else
> +		spin_lock_bh(qdisc_root_sleeping_lock(q));
>   }
>   
> -static inline void sch_tree_unlock(const struct Qdisc *q)
> +static inline void sch_tree_unlock(struct Qdisc *q)
>   {
> -	spin_unlock_bh(qdisc_root_sleeping_lock(q));
> +	if (q->flags & TCQ_F_MQROOT)
> +		spin_unlock_bh(qdisc_lock(q));
> +	else
> +		spin_unlock_bh(qdisc_root_sleeping_lock(q));
>   }
>   
>   extern struct Qdisc noop_qdisc;
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index a95f3ae7ab37..906e19ed2d53 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -432,6 +432,7 @@ enum {
>   	TCA_HTB_RATE64,
>   	TCA_HTB_CEIL64,
>   	TCA_HTB_PAD,
> +	TCA_HTB_OFFLOAD,
>   	__TCA_HTB_MAX,
>   };
>   
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 8184c87da8be..1d82afe96f8e 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -174,6 +174,10 @@ struct htb_sched {
>   	int			row_mask[TC_HTB_MAXDEPTH];
>   
>   	struct htb_level	hlevel[TC_HTB_MAXDEPTH];
> +
> +	struct Qdisc		**direct_qdiscs;
> +
> +	bool			offload;
>   };
>   
>   /* find class in global hash table using given handle */
> @@ -980,6 +984,7 @@ static const struct nla_policy htb_policy[TCA_HTB_MAX + 1] = {
>   	[TCA_HTB_DIRECT_QLEN] = { .type = NLA_U32 },
>   	[TCA_HTB_RATE64] = { .type = NLA_U64 },
>   	[TCA_HTB_CEIL64] = { .type = NLA_U64 },
> +	[TCA_HTB_OFFLOAD] = { .type = NLA_FLAG },
>   };
>   
>   static void htb_work_func(struct work_struct *work)
> @@ -992,13 +997,23 @@ static void htb_work_func(struct work_struct *work)
>   	rcu_read_unlock();
>   }
>   
> +static void htb_set_lockdep_class_child(struct Qdisc *q)
> +{
> +	static struct lock_class_key child_key;
> +
> +	lockdep_set_class(qdisc_lock(q), &child_key);
> +}
> +
>   static int htb_init(struct Qdisc *sch, struct nlattr *opt,
>   		    struct netlink_ext_ack *extack)
>   {
> +	struct net_device *dev = qdisc_dev(sch);
>   	struct htb_sched *q = qdisc_priv(sch);
>   	struct nlattr *tb[TCA_HTB_MAX + 1];
>   	struct tc_htb_glob *gopt;
> +	unsigned int ntx;
>   	int err;
> +	struct tc_htb_qopt_offload htb_offload;
>   
>   	qdisc_watchdog_init(&q->watchdog, sch);
>   	INIT_WORK(&q->work, htb_work_func);
> @@ -1022,9 +1037,22 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
>   	if (gopt->version != HTB_VER >> 16)
>   		return -EINVAL;
>   
> +	q->offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
> +	q->offload = true;
> +
> +	if (q->offload) {
> +		if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
> +			return -EOPNOTSUPP;
> +
> +		q->direct_qdiscs = kcalloc(dev->real_num_tx_queues,
> +					   sizeof(*q->direct_qdiscs), GFP_KERNEL);
> +		if (!q->direct_qdiscs)
> +			return -ENOMEM;
> +	}
> +
>   	err = qdisc_class_hash_init(&q->clhash);
>   	if (err < 0)
> -		return err;
> +		goto err_free_direct_qdiscs;
>   
>   	qdisc_skb_head_init(&q->direct_queue);
>   
> @@ -1037,7 +1065,92 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
>   		q->rate2quantum = 1;
>   	q->defcls = gopt->defcls;
>   
> +	if (!q->offload)
> +		return 0;
> +
> +	for (ntx = 0; ntx < dev->real_num_tx_queues; ntx++) {
> +		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
> +		struct Qdisc *qdisc = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
> +							TC_H_MAKE(sch->handle, ntx + 1),
> +							extack);
> +
> +		if (!qdisc) {
> +			err = -ENOMEM;
> +			goto err_free_qdiscs;
> +		}
> +
> +		htb_set_lockdep_class_child(qdisc);
> +		q->direct_qdiscs[ntx] = qdisc;
> +		qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> +	}
> +
> +	sch->flags |= TCQ_F_MQROOT;
> +
> +	htb_offload.command = TC_HTB_CREATE;
> +	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_HTB, &htb_offload);
> +
>   	return 0;
> +
> +err_free_qdiscs:
> +	for (ntx = 0; ntx < dev->real_num_tx_queues && q->direct_qdiscs[ntx]; ntx++)
> +		qdisc_put(q->direct_qdiscs[ntx]);
> +
> +	qdisc_class_hash_destroy(&q->clhash);
> +
> +err_free_direct_qdiscs:
> +	kfree(q->direct_qdiscs);
> +	return err;
> +}
> +
> +static void htb_attach_offload(struct Qdisc *sch)
> +{
> +	struct net_device *dev = qdisc_dev(sch);
> +	struct htb_sched *q = qdisc_priv(sch);
> +	unsigned int ntx;
> +
> +	// TODO: real_num_tx_queues might have changed.
> +	for (ntx = 0; ntx < dev->real_num_tx_queues; ntx++) {
> +		struct Qdisc *qdisc = q->direct_qdiscs[ntx];
> +		struct Qdisc *old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
> +
> +		qdisc_put(old);
> +		qdisc_hash_add(qdisc, false);
> +	}
> +	for (ntx = dev->real_num_tx_queues; ntx < dev->num_tx_queues; ntx++) {
> +		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
> +		struct Qdisc *old = dev_graft_qdisc(dev_queue, NULL);
> +
> +		qdisc_put(old);
> +	}
> +
> +	kfree(q->direct_qdiscs);
> +	q->direct_qdiscs = NULL;
> +}
> +
> +static void htb_attach_software(struct Qdisc *sch)
> +{
> +	struct net_device *dev = qdisc_dev(sch);
> +	unsigned int ntx;
> +
> +	/* Resemble qdisc_graft behavior. */
> +	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
> +		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
> +		struct Qdisc *old = dev_graft_qdisc(dev_queue, sch);
> +
> +		qdisc_refcount_inc(sch);
> +
> +		qdisc_put(old);
> +	}
> +}
> +
> +static void htb_attach(struct Qdisc *sch)
> +{
> +	struct htb_sched *q = qdisc_priv(sch);
> +
> +	if (q->offload)
> +		htb_attach_offload(sch);
> +	else
> +		htb_attach_software(sch);
>   }
>   
>   static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
> @@ -1144,19 +1257,56 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
>   	return gnet_stats_copy_app(d, &cl->xstats, sizeof(cl->xstats));
>   }
>   
> +static struct netdev_queue *htb_offload_class_to_queue(struct Qdisc *sch, unsigned long classid)
> +{
> +	struct net_device *dev = qdisc_dev(sch);
> +	unsigned long ntx = TC_H_MIN(classid) - 1;
> +
> +	if (ntx >= dev->num_tx_queues)
> +		return NULL;
> +	return netdev_get_tx_queue(dev, ntx);
> +}
> +
> +static struct netdev_queue *htb_select_queue(struct Qdisc *sch, struct tcmsg *tcm)
> +{
> +	return htb_offload_class_to_queue(sch, tcm->tcm_parent);
> +}
> +
>   static int htb_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
>   		     struct Qdisc **old, struct netlink_ext_ack *extack)
>   {
>   	struct htb_class *cl = (struct htb_class *)arg;
> +	struct netdev_queue *dev_queue = sch->dev_queue;
> +	struct htb_sched *q = qdisc_priv(sch);
> +	struct Qdisc *old_q;
>   
>   	if (cl->level)
>   		return -EINVAL;
> -	if (new == NULL &&
> -	    (new = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
> -				     cl->common.classid, extack)) == NULL)
> +
> +	if (q->offload)
> +		dev_queue = htb_offload_class_to_queue(sch, cl->common.classid);
> +
> +	if (!new)
> +		new = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
> +					cl->common.classid, extack);
> +
> +	if (!new)
>   		return -ENOBUFS;
>   
> +	if (q->offload) {
> +		htb_set_lockdep_class_child(new);
> +		/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
> +		qdisc_refcount_inc(new);
> +		old_q = dev_graft_qdisc(dev_queue, new);
> +	}
> +
>   	*old = qdisc_replace(sch, new, &cl->leaf.q);
> +
> +	if (q->offload) {
> +		WARN_ON(old_q != *old);
> +		qdisc_put(old_q);
> +	}
> +
>   	return 0;
>   }
>   
> @@ -1184,10 +1334,14 @@ static inline int htb_parent_last_child(struct htb_class *cl)
>   	return 1;
>   }
>   
> -static void htb_parent_to_leaf(struct htb_sched *q, struct htb_class *cl,
> +static void htb_parent_to_leaf(struct Qdisc *sch, struct htb_class *cl,
>   			       struct Qdisc *new_q)
>   {
> +	struct htb_sched *q = qdisc_priv(sch);
>   	struct htb_class *parent = cl->parent;
> +	struct netdev_queue *dev_queue;
> +	struct Qdisc *old_q;
> +	struct tc_htb_qopt_offload htb_offload;
>   
>   	WARN_ON(cl->level || !cl->leaf.q || cl->prio_activity);
>   
> @@ -1202,13 +1356,47 @@ static void htb_parent_to_leaf(struct htb_sched *q, struct htb_class *cl,
>   	parent->ctokens = parent->cbuffer;
>   	parent->t_c = ktime_get_ns();
>   	parent->cmode = HTB_CAN_SEND;
> +
> +	if (!q->offload)
> +		return;
> +
> +	dev_queue = htb_offload_class_to_queue(sch, parent->common.classid);
> +	/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
> +	qdisc_refcount_inc(new_q);
> +	old_q = dev_graft_qdisc(dev_queue, new_q);
> +	WARN_ON(!(old_q->flags & TCQ_F_BUILTIN));
> +	htb_offload.command = TC_HTB_NEW_LEAF;
> +	htb_offload.classid = parent->common.classid;
> +	// TODO: extack
> +	qdisc_offload_graft_helper(qdisc_dev(sch), sch, new_q, old_q,
> +				   TC_SETUP_QDISC_HTB, &htb_offload, NULL);
>   }
>   
>   static void htb_destroy_class(struct Qdisc *sch, struct htb_class *cl)
>   {
>   	if (!cl->level) {
> -		WARN_ON(!cl->leaf.q);
> -		qdisc_put(cl->leaf.q);
> +		struct htb_sched *priv = qdisc_priv(sch);
> +		struct Qdisc *q = cl->leaf.q;
> +		struct Qdisc *old;
> +		struct tc_htb_qopt_offload htb_offload;
> +
> +		WARN_ON(!q);
> +		if (priv->offload) {
> +			old = dev_graft_qdisc(q->dev_queue, NULL);
> +			/* On destroy of HTB, dev_queue qdiscs are destroyed
> +			 * first, and old is noop_qdisc.
> +			 */
> +			WARN_ON(old != q && !(old->flags & TCQ_F_BUILTIN));
> +
> +			htb_offload.command = TC_HTB_DEL_LEAF;
> +			htb_offload.classid = cl->common.classid;
> +			// TODO: extack
> +			qdisc_offload_graft_helper(qdisc_dev(sch), sch, NULL, q,
> +						   TC_SETUP_QDISC_HTB, &htb_offload, NULL);
> +
> +			qdisc_put(old);
> +		}
> +		qdisc_put(q);
>   	}
>   	gen_kill_estimator(&cl->rate_est);
>   	tcf_block_put(cl->block);
> @@ -1217,10 +1405,12 @@ static void htb_destroy_class(struct Qdisc *sch, struct htb_class *cl)
>   
>   static void htb_destroy(struct Qdisc *sch)
>   {
> +	struct net_device *dev = qdisc_dev(sch);
>   	struct htb_sched *q = qdisc_priv(sch);
>   	struct hlist_node *next;
>   	struct htb_class *cl;
>   	unsigned int i;
> +	struct tc_htb_qopt_offload htb_offload;
>   
>   	cancel_work_sync(&q->work);
>   	qdisc_watchdog_cancel(&q->watchdog);
> @@ -1244,6 +1434,21 @@ static void htb_destroy(struct Qdisc *sch)
>   	}
>   	qdisc_class_hash_destroy(&q->clhash);
>   	__qdisc_reset_queue(&q->direct_queue);
> +
> +	if (!q->offload)
> +		return;
> +
> +	if (tc_can_offload(dev) && dev->netdev_ops->ndo_setup_tc) {
> +		htb_offload.command = TC_HTB_DESTROY;
> +		dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_HTB, &htb_offload);
> +	}
> +
> +	if (!q->direct_qdiscs)
> +		return;
> +	// TODO: real_num_tx_queues might have changed.
> +	for (i = 0; i < dev->real_num_tx_queues && q->direct_qdiscs[i]; i++)
> +		qdisc_put(q->direct_qdiscs[i]);
> +	kfree(q->direct_qdiscs);
>   }
>   
>   static int htb_delete(struct Qdisc *sch, unsigned long arg)
> @@ -1265,6 +1470,8 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg)
>   					  cl->parent->common.classid,
>   					  NULL);
>   		last_child = 1;
> +		if (q->offload)
> +			htb_set_lockdep_class_child(new_q);
>   	}
>   
>   	sch_tree_lock(sch);
> @@ -1285,7 +1492,7 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg)
>   				  &q->hlevel[cl->level].wait_pq);
>   
>   	if (last_child)
> -		htb_parent_to_leaf(q, cl, new_q);
> +		htb_parent_to_leaf(sch, cl, new_q);
>   
>   	sch_tree_unlock(sch);
>   
> @@ -1306,6 +1513,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>   	struct tc_htb_opt *hopt;
>   	u64 rate64, ceil64;
>   	int warn = 0;
> +	struct netdev_queue *dev_queue;
> +	struct tc_htb_qopt_offload htb_offload;
>   
>   	/* extract all subattrs from opt attr */
>   	if (!opt)
> @@ -1336,7 +1545,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>   					      NULL));
>   
>   	if (!cl) {		/* new class */
> -		struct Qdisc *new_q;
> +		struct Qdisc *new_q, *old_q;
>   		int prio;
>   		struct {
>   			struct nlattr		nla;
> @@ -1392,13 +1601,29 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>   		for (prio = 0; prio < TC_HTB_NUMPRIO; prio++)
>   			RB_CLEAR_NODE(&cl->node[prio]);
>   
> +		cl->common.classid = classid;
> +
>   		/* create leaf qdisc early because it uses kmalloc(GFP_KERNEL)
>   		 * so that can't be used inside of sch_tree_lock
>   		 * -- thanks to Karlis Peisenieks
>   		 */
> -		new_q = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
> +		dev_queue = q->offload ? htb_offload_class_to_queue(sch, cl->common.classid) :
> +					 sch->dev_queue;
> +		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
>   					  classid, NULL);
>   		sch_tree_lock(sch);
> +		if (q->offload) {
> +			htb_set_lockdep_class_child(new_q);
> +			/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
> +			qdisc_refcount_inc(new_q);
> +			old_q = dev_graft_qdisc(dev_queue, new_q);
> +			WARN_ON(!(old_q->flags & TCQ_F_BUILTIN));
> +			htb_offload.command = TC_HTB_NEW_LEAF;
> +			htb_offload.classid = cl->common.classid;
> +			qdisc_offload_graft_helper(qdisc_dev(sch), sch, new_q, old_q,
> +						   TC_SETUP_QDISC_HTB, &htb_offload, extack);
> +			qdisc_put(old_q);
> +		}
>   		if (parent && !parent->level) {
>   			/* turn parent into inner node */
>   			qdisc_purge_queue(parent->leaf.q);
> @@ -1414,11 +1639,24 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>   			parent->level = (parent->parent ? parent->parent->level
>   					 : TC_HTB_MAXDEPTH) - 1;
>   			memset(&parent->inner, 0, sizeof(parent->inner));
> +
> +			if (q->offload) {
> +				struct netdev_queue *parent_queue =
> +					htb_offload_class_to_queue(sch, parent->common.classid);
> +				old_q = dev_graft_qdisc(parent_queue, NULL);
> +				WARN_ON(old_q != parent_qdisc);
> +				htb_offload.command = TC_HTB_DEL_LEAF;
> +				htb_offload.classid = parent->common.classid;
> +				qdisc_offload_graft_helper(qdisc_dev(sch), sch, NULL,
> +							   parent_qdisc, TC_SETUP_QDISC_HTB,
> +							   &htb_offload, extack);
> +				qdisc_put(old_q);
> +			}
>   		}
> +
>   		/* leaf (we) needs elementary qdisc */
>   		cl->leaf.q = new_q ? new_q : &noop_qdisc;
>   
> -		cl->common.classid = classid;
>   		cl->parent = parent;
>   
>   		/* set class to be in HTB_CAN_SEND state */
> @@ -1557,6 +1795,7 @@ static void htb_walk(struct Qdisc *sch, struct qdisc_walker *arg)
>   }
>   
>   static const struct Qdisc_class_ops htb_class_ops = {
> +	.select_queue	=	htb_select_queue,
>   	.graft		=	htb_graft,
>   	.leaf		=	htb_leaf,
>   	.qlen_notify	=	htb_qlen_notify,
> @@ -1579,6 +1818,7 @@ static struct Qdisc_ops htb_qdisc_ops __read_mostly = {
>   	.dequeue	=	htb_dequeue,
>   	.peek		=	qdisc_peek_dequeued,
>   	.init		=	htb_init,
> +	.attach		=	htb_attach,
>   	.reset		=	htb_reset,
>   	.destroy	=	htb_destroy,
>   	.dump		=	htb_dump,
> diff --git a/tools/include/uapi/linux/pkt_sched.h b/tools/include/uapi/linux/pkt_sched.h
> index 0d18b1d1fbbc..5c903abc9fa5 100644
> --- a/tools/include/uapi/linux/pkt_sched.h
> +++ b/tools/include/uapi/linux/pkt_sched.h
> @@ -414,6 +414,7 @@ enum {
>   	TCA_HTB_RATE64,
>   	TCA_HTB_CEIL64,
>   	TCA_HTB_PAD,
> +	TCA_HTB_OFFLOAD,
>   	__TCA_HTB_MAX,
>   };
>   
> 

