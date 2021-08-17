Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84FE3EEBD7
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbhHQLkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:40:01 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:30852
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239777AbhHQLj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 07:39:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvzvYDcPniI80YSegOWEkmOlFShhCtBLk9dsww2t+3c7UC5GzHPwN2SJ54OyDBWRX8+R9IUsgxPSLZHcqjkxTkzomkN0h1P5fJvvFowtWqjmLxGUBROwoby5rFH6xoBmBD6ZBh3xKohdHnxjthvgYw7pXcD4ZMZ1u7/df3xbB2VQUXxne9dx9tnnYF4rjvH3koFLb8K99dnVq4YVDljgzy1I6/QTZ1o90UF1QvLEtgcR34H5yJTjjgk+UdmiwGDKFm515c5D/RK7TSKZ4M7Esup4HB5g2Yuy+qyGXjHgyJ0VjDxqf0GiQZAjnhsVNZCJvsCi8puaWnKBjmfGUxBKTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zSuQWioYMxMbmZQw1sKBaUnSJIiTirrmgKob024TPQ=;
 b=Mv4Hg/ijV8Bpq0BPCfXCYQlF9JzOnwM6CpNfbucCjFXbwahE1PFNXcOxvwvu2R/I0HFtSIRN7T2hrcTbroRmZHevZrYEYro6f4BUsVSBV8GqcUu03aGO3m7HimCaUUGg2Ml+q3100JRbAb2PnSuNHR0U3mQvRdAUhmGsD1VAvDmI4mY19fdbYRCBqMWpKonDjf5NhMOTD6v9/7W3BKlXrXQTwLyM2g1v2yT8d9GG65HXTL6dh0YbmERJxpmHSoeyDh6GnIbLIuh7vMNgeTNXTwFM76wIYLc9IKQKrZ+uqPZWPoUl+99dicbYVGZoBiz4rFbkbfjC8sHe5QNyQznxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zSuQWioYMxMbmZQw1sKBaUnSJIiTirrmgKob024TPQ=;
 b=E+uKljBCNQTrbi/ZzWZdiLhUSzlGW4hQyAQ4C9KVAYeTLNH7fkb6ShJO6QHirpePYPzxSG+fs4OUfjFkWIWTjDh5VG4JPRj3o1etNHM1p6KSHcuLcy+BWLOwJYQpSzUn2C5Y+hucVJRJJzi4GHn4VNX0wr7PPYEgkdKr95fHFCpLnpX/LqDaXaYRnf/n8AeGd1G2g8sOwd9aKJk3LvgB7GGPo89/ZNlgA5ZxFu24oZ86+6omMY3g5C1SR5bL3D4AZQt5d20d+d/KTmV9yuOgwE1F+Iecex1Lb5LZiMF2O8yvzZH14SvsDsI7Jp2aC4o24sgotUG+Y5N3299k4I04xw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5551.namprd12.prod.outlook.com (2603:10b6:5:1bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 11:39:22 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 11:39:22 +0000
Subject: Re: [PATCH] net: Improve perf of bond/vlans modification
To:     Gilad Naaman <gnaaman@drivenets.com>, davem@davemloft.net,
        kuba@kernel.org, luwei32@huawei.com, wangxiongfeng2@huawei.com,
        ap420073@gmail.com
Cc:     netdev@vger.kernel.org
References: <20210817110447.267678-1-gnaaman@drivenets.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <84c0c733-193a-97c7-1a68-c34f44cf2f61@nvidia.com>
Date:   Tue, 17 Aug 2021 14:39:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210817110447.267678-1-gnaaman@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::14) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.22] (213.179.129.39) by ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18 via Frontend Transport; Tue, 17 Aug 2021 11:39:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab8a4a00-57cf-4671-00eb-08d96173a859
X-MS-TrafficTypeDiagnostic: DM6PR12MB5551:
X-Microsoft-Antispam-PRVS: <DM6PR12MB555173A331823F7A44A64C3BDFFE9@DM6PR12MB5551.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +wO8RxjZAaiftRt3Awy0drduOVlhTRKBPGXnStb0ubAsInMligg6uqbYVoBejdsmw0d6lyEH60Iz9nvTwWfBb8tqlPw5Ey9ezaQ3UVbBjZrPRaPPf+y9VZu7WD2fT3U+i08ijG9n6dOJdJvIKxXuGhEqtkeN7+nBS1//6SZ1VtonOep2O04QiBrr50c1Qevvp6QLEgNpgqTZy34QR6HiqMR42hcl+z1FXVn2G+yGUoWtyboxCTLTVFglxt/1VPSjr8QcFkCfB7Kz3Frkvvy0/stZ0umbPZF6BIEbuFFEZRvwR5i4Ev2ey1mjlVzhd5GjOTWBSrDw10FyTgd1YQys2o+qSlzMyuFZLTE31Ih+6M4umkBLdv2l702r5Xe+O6SHoLFKOQsN/5p4QH6C8a4g753RFur88NXyeH7SZmfqr/Xa5jcyKBPZ9+2nOTVXxAoI9js0p/CLi+Qx6ylD8yZbGDXYxbQBCxxur3GNf9uZsD81eB7O+/SvuGVzn7rQetFoweK/bMYlUGqL8jdCk4oREPELuxSpiyrZy+9+SrNNJp+BYj7mrx/mBMzpae5d/WqF8pr3gzESpF148xknVFivuwkcPgfVmPS3EDbhzhxJEff1JBww8RU3JiQ9Zdg7vdUfoDt0GTUuIdRMXS1mvLw8D6kMmr3PSGax6TqJope8HYGsF7wNPLRAR9sADG/tuZQjSfaOZuWLAxWCnN7laSWXqGL6FyhRnn1rRjyFnFXQNRMLdfk5IH8kGPDiYp/EO0cs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(2906002)(83380400001)(6486002)(478600001)(8676002)(956004)(8936002)(5660300002)(26005)(53546011)(6666004)(38100700002)(86362001)(31696002)(66556008)(66476007)(66946007)(4326008)(2616005)(16576012)(36756003)(31686004)(186003)(316002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkJ1YVdkbEpvQXFaL3E3aDk1SVpNcWtsTXhQdi80YXAyWjJLay9KL1QwVDJX?=
 =?utf-8?B?dkUvdnhnL2d0KzRJTkp6YkQ3dFNCenZKQVJUUWN1S0V6bWEwQTJNa3grZG5l?=
 =?utf-8?B?L0tBVkU1cUZOVlVzbjlRL016VVpoVzlFcFJxY0tWM3V6Uzl3UFNkK2ViRFlu?=
 =?utf-8?B?S1doMWdQTkJFaXZqbUY5bnlQTXhFT096VEZoVXVXRGNnM0EyQVVHNU1ZQmJW?=
 =?utf-8?B?S1prVFlWbHJkSkR5OGU4TmZSZXY3Y0c1NkhMVC9uSTIrL3RIb3BaL1AraDJO?=
 =?utf-8?B?VkFtajMrN1lhMkNsbUpERlIwRnJGK1NybDRDQUdRZjJQT2RSVUVCVURPWUkx?=
 =?utf-8?B?cEZlSUpwWHk5SEt0Q1UwYXhKTVZVbUpPSk5mL1ZtdExwdkdVc25nYTgzMnh5?=
 =?utf-8?B?ZXlkeSs2aGVTRzFHZ0pCWnN6ckp3UnEyNzhJaGtMcGw1bHZJb255VC9Pb1ZJ?=
 =?utf-8?B?NFQyQTRwdjJ2YWlUY2ptTFh6bVhlWWJGem9NUDVUYk9SY0owanZoWjlxUGww?=
 =?utf-8?B?dzQ4L21VbnV1T2lWMzhhNjQ4R2tFZWFNSCtFYzZXRHhDaHorNktPa21FRnBD?=
 =?utf-8?B?M2dGSzBUUFpmd0l6ZUhxWitNTFZkQnB5ZWc0b2ZYcGZ1UUxlNG1yS3MzWkpC?=
 =?utf-8?B?SkIrTlVhVXQyMHEwMjd4YW41bkQrRkUxK2tqeXlTRjJPMmRnakdQbGVxbERQ?=
 =?utf-8?B?cHQyL01nY0RIcE91NFVRaUNQSmxDdTNuWGloQ3h3bzYwSXN5ZjdCblY0MGlW?=
 =?utf-8?B?SzhOdXk4WnlQZmp6TnN4NEgyTlBBNWdhWi8xWEsyaGtOV05CTnpncDRmMlZD?=
 =?utf-8?B?c1hJR0VDb0ZnQ3l0VUJ5QmQzUnIrb1phWW84R0xwVC9pdWh5Q05JS01lbTdp?=
 =?utf-8?B?ekdSNjZ5bmo1QVV2S0Q3aEtIeWRQdlE1UVlScGVDaU5LM1BNQzZSV2JaZTVD?=
 =?utf-8?B?Z3paNThCbk4wQU1SN0I4Y25JL1BPd2hHZitTNGNCZ0VjZGhZN2pDSFVLYnhN?=
 =?utf-8?B?ZE9hb2Q2d2JXeHVYQnNWRnRBMWtRMHdiSlJBY0VaaGNKTm4yQTh0Sk5WcUFv?=
 =?utf-8?B?ZkxUbDNSRXRsNG4wUUxPZ1FqdWU2Z2l0UVo2Z3NQL2RLTWNmcDA3cnBWcDBQ?=
 =?utf-8?B?dHhEVUFLYTBxMTVMd3BZcWFoZCs3U0poaERja1FNNHkwN2hpbXJCT21odER5?=
 =?utf-8?B?TFMxRFZ6ck8zRE91d1A3Tng3Yk5UeHR0U2syMW9nNTgvdWpURUVwTXA3akly?=
 =?utf-8?B?NGpSODRPZ1pPWEljYk5NUGM5dEgzTWxrQklJcmRaeG53Y0dIUlVwM3ZtbzFK?=
 =?utf-8?B?TG9SekxxYWNSa083ZWhOV0U0bEdKSTlRQ3RCMUNwVHdvRDdORWZaTjVMNW55?=
 =?utf-8?B?cGNOdGQ5dVphN3lYWVk4bWUwdlIxeEViTXduM2hxdkFFQUttRDVwLzQxMURr?=
 =?utf-8?B?aTdZUW1EUUdzWU43QllPYzExOFZEYmZiMllvYTZyYXhpTngzOXV6eU0vWDlt?=
 =?utf-8?B?dXMySUdaQ3l1MFNCUUxnQ2VQZUVIa1Z5RnZ3TjJBTVF2cTc1TVRuWXFEN09C?=
 =?utf-8?B?Vml0ejZuZzZhZ21vNjdIMm12ZzVmaHpPNXVUZnBlU2xDQ3FiUzgrUk82b1Vh?=
 =?utf-8?B?T1FCdHVVdlk2YzZ0czhUYzhnRjJzR25BZnZVN3QyUnRhZ1lyWVp3dmIwUisx?=
 =?utf-8?B?RWRaRURmQ2picUl0YVN5NFg2RFZFZ2g2Z0h1OEVxTC9DWEFMQnRON3Vmbktr?=
 =?utf-8?Q?srkuScbwg4K2hRBfo1HTgMR2GF8Zsj2CPXT6kdA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8a4a00-57cf-4671-00eb-08d96173a859
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 11:39:22.4876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qqh5KkX2iiCFPWn9gAeCl7x2J49wY2gLT9n1xziHc0Dfh059gi96o6rZWJ2x0f45HJX2zBu+xWbF79jCkTzKyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2021 14:04, Gilad Naaman wrote:
> When a bond have a massive amount of VLANs with IPv6 addresses,
> performance of changing link state, attaching a VRF, changing an IPv6
> address, etc. go down dramtically.
> 
> The source of most of the slow down is the `dev_addr_lists.c` module,
> which mainatins a linked list of HW addresses.
> When using IPv6, this list grows for each IPv6 address added on a
> VLAN, since each IPv6 address has a multicast HW address associated with
> it.
> 
> When performing any modification to the involved links, this list is
> traversed many times, often for nothing, all while holding the RTNL
> lock.
> 
> Instead, this patch adds an auxilliary rbtree which cuts down
> traversal time significantly.
> 
[snip]
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Lu Wei <luwei32@huawei.com>
> Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
> ---

Hi Gilad,
Generally I like the idea, I have a similar hacky patch for the same reason but related to bridge
static entries which in some cases get added to lower device addr lists causing soft lockups due
to the list traversals.

The patch should be targeted at net-next, more comments below...

>  include/linux/netdevice.h |   5 ++
>  net/core/dev_addr_lists.c | 163 ++++++++++++++++++++++++++++----------
>  2 files changed, 126 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eaf5bb008aa9..dc343be9a845 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -47,6 +47,7 @@
>  #include <uapi/linux/if_bonding.h>
>  #include <uapi/linux/pkt_cls.h>
>  #include <linux/hashtable.h>
> +#include <linux/rbtree.h>
>  
>  struct netpoll_info;
>  struct device;
> @@ -218,12 +219,16 @@ struct netdev_hw_addr {
>  	int			sync_cnt;
>  	int			refcount;
>  	int			synced;
> +	struct rb_node		node;
>  	struct rcu_head		rcu_head;
>  };
>  
>  struct netdev_hw_addr_list {
>  	struct list_head	list;
>  	int			count;
> +
> +	/* Auxiliary tree for faster lookup when modifying the structure */
> +	struct rb_root		tree_root;

Why keep the list when now we have the rbtree ?

>  };
>  
>  #define netdev_hw_addr_list_count(l) ((l)->count)
> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 45ae6eeb2964..2473d0f401aa 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c
> @@ -12,6 +12,72 @@
>  #include <linux/export.h>
>  #include <linux/list.h>
>  
> +/* Lookup for an address in the list using the rbtree.
> + * The return value is always a valid pointer.
> + * If the address exists, `*ret` is non-null and the address can be retrieved using
> + *
> + *     container_of(*ret, struct netdev_hw_addr, node)
> + *
> + * Otherwise, `ret` can be used with `parent` as an insertion point
> + * when calling `insert_address_to_tree`.
> + *
> + * Must only be called when holding the netdevice's spinlock.
> + *
> + * @ignore_zero_addr_type if true and `addr_type` is zero,
> + *                        disregard addr_type when matching;
> + */
> +static struct rb_node **tree_address_lookup(struct netdev_hw_addr_list *list,

The function name prefixes in the file follow the __hw_addr_xxx and dev_addr patterns,
please conform to that.

> +					  const unsigned char *addr,
> +					  int addr_len,
> +					  unsigned char addr_type,
> +					  bool ignore_zero_addr_type,
> +					  struct rb_node **parent)
> +{
> +	struct rb_node **node = &list->tree_root.rb_node, *_parent;
> +
> +	while (*node)
> +	{
> +		struct netdev_hw_addr *data = container_of(*node, struct netdev_hw_addr, node);
> +		int result;
> +
> +		result = memcmp(addr, data->addr, addr_len);
> +		if (!result && (ignore_zero_addr_type && !addr_type))
> +			result = memcmp(&addr_type, &data->type, sizeof(addr_type));
> +
> +		_parent = *node;
> +		if (result < 0)
> +			node = &(*node)->rb_left;
> +		else if (result > 0)
> +			node = &(*node)->rb_right;
> +		else
> +			break;
> +	}
> +
> +	if (parent)
> +		*parent = _parent;
> +	return node;
> +}
> +
> +
> +static int insert_address_to_tree(struct netdev_hw_addr_list *list,

+1 fn name pattern

> +				  struct netdev_hw_addr *ha,
> +				  int addr_len,
> +				  struct rb_node **insertion_point,
> +				  struct rb_node *parent)
> +{
> +	/* Figure out where to put new node */
> +	if (!insertion_point || !parent)
> +	{

Kernel code-style says you should place the curly bracket on the same row as the statement.
Also you don't need brackets for single statement rows.

> +		insertion_point = tree_address_lookup(list, ha->addr, addr_len, ha->type, false, &parent);
> +	}
> +
> +	/* Add new node and rebalance tree. */
> +	rb_link_node(&ha->node, parent, insertion_point);
> +	rb_insert_color(&ha->node, &list->tree_root);
> +
> +	return true;
> +}
> +
>  /*
>   * General list handling functions
>   */
> @@ -19,7 +85,9 @@
>  static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
>  			       const unsigned char *addr, int addr_len,
>  			       unsigned char addr_type, bool global,
> -			       bool sync)
> +			       bool sync,
> +			       struct rb_node **insertion_point,
> +			       struct rb_node *parent)
>  {
>  	struct netdev_hw_addr *ha;
>  	int alloc_size;
> @@ -36,6 +104,10 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
>  	ha->global_use = global;
>  	ha->synced = sync ? 1 : 0;
>  	ha->sync_cnt = 0;
> +
> +	/* Insert node to hash table for quicker lookups during modification */

hash table?

> +	insert_address_to_tree(list, ha, addr_len, insertion_point, parent);
> +
>  	list_add_tail_rcu(&ha->list, &list->list);
>  	list->count++;
>  
> @@ -47,34 +119,36 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
>  			    unsigned char addr_type, bool global, bool sync,
>  			    int sync_count)
>  {
> +	struct rb_node **ha_node;
> +	struct rb_node *insert_parent = NULL;

please order these in reverese xmas tree, longest to shortest

>  	struct netdev_hw_addr *ha;
>  
>  	if (addr_len > MAX_ADDR_LEN)
>  		return -EINVAL;
>  
> -	list_for_each_entry(ha, &list->list, list) {
> -		if (ha->type == addr_type &&
> -		    !memcmp(ha->addr, addr, addr_len)) {
> -			if (global) {
> -				/* check if addr is already used as global */
> -				if (ha->global_use)
> -					return 0;
> -				else
> -					ha->global_use = true;
> -			}
> -			if (sync) {
> -				if (ha->synced && sync_count)
> -					return -EEXIST;
> -				else
> -					ha->synced++;
> -			}
> -			ha->refcount++;
> -			return 0;
> +	ha_node = tree_address_lookup(list, addr, addr_len, addr_type, false, &insert_parent);
> +	if (*ha_node)
> +	{

+1 curly bracket style

> +		ha = container_of(*ha_node, struct netdev_hw_addr, node);
> +		if (global) {
> +			/* check if addr is already used as global */
> +			if (ha->global_use)
> +				return 0;
> +			else
> +				ha->global_use = true;
>  		}
> +		if (sync) {
> +			if (ha->synced && sync_count)
> +				return -EEXIST;
> +			else
> +				ha->synced++;
> +		}
> +		ha->refcount++;
> +		return 0;
>  	}
>  
>  	return __hw_addr_create_ex(list, addr, addr_len, addr_type, global,
> -				   sync);
> +				   sync, ha_node, insert_parent);
>  }
>  
>  static int __hw_addr_add(struct netdev_hw_addr_list *list,
> @@ -103,6 +177,8 @@ static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
>  
>  	if (--ha->refcount)
>  		return 0;
> +
> +	rb_erase(&ha->node, &list->tree_root);
>  	list_del_rcu(&ha->list);
>  	kfree_rcu(ha, rcu_head);
>  	list->count--;
> @@ -113,14 +189,15 @@ static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
>  			    const unsigned char *addr, int addr_len,
>  			    unsigned char addr_type, bool global, bool sync)
>  {
> +	struct rb_node **ha_node;
>  	struct netdev_hw_addr *ha;

reverse xmas tree

>  
> -	list_for_each_entry(ha, &list->list, list) {
> -		if (!memcmp(ha->addr, addr, addr_len) &&
> -		    (ha->type == addr_type || !addr_type))
> -			return __hw_addr_del_entry(list, ha, global, sync);
> -	}
> -	return -ENOENT;
> +	ha_node = tree_address_lookup(list, addr, addr_len, addr_type, true, NULL);
> +	if (*ha_node == NULL)
> +		return -ENOENT;
> +
> +	ha = container_of(*ha_node, struct netdev_hw_addr, node);
> +	return __hw_addr_del_entry(list, ha, global, sync);
>  }
>  
>  static int __hw_addr_del(struct netdev_hw_addr_list *list,
> @@ -418,6 +495,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list)
>  {
>  	INIT_LIST_HEAD(&list->list);
>  	list->count = 0;
> +	list->tree_root = RB_ROOT;
>  }
>  EXPORT_SYMBOL(__hw_addr_init);
>  
> @@ -552,19 +630,20 @@ EXPORT_SYMBOL(dev_addr_del);
>   */
>  int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
>  {
> -	struct netdev_hw_addr *ha;
> +	struct rb_node *insert_parent = NULL;
> +	struct rb_node **ha_node = NULL;
>  	int err;
>  
>  	netif_addr_lock_bh(dev);
> -	list_for_each_entry(ha, &dev->uc.list, list) {
> -		if (!memcmp(ha->addr, addr, dev->addr_len) &&
> -		    ha->type == NETDEV_HW_ADDR_T_UNICAST) {
> -			err = -EEXIST;
> -			goto out;
> -		}
> +	ha_node = tree_address_lookup(&dev->uc, addr, dev->addr_len, NETDEV_HW_ADDR_T_UNICAST, false, &insert_parent);
> +	if (*ha_node)
> +	{

+1 curly bracket style

> +		err = -EEXIST;
> +		goto out;
>  	}
> +
>  	err = __hw_addr_create_ex(&dev->uc, addr, dev->addr_len,
> -				  NETDEV_HW_ADDR_T_UNICAST, true, false);
> +				  NETDEV_HW_ADDR_T_UNICAST, true, false, ha_node, insert_parent);
>  	if (!err)
>  		__dev_set_rx_mode(dev);
>  out:
> @@ -745,19 +824,19 @@ EXPORT_SYMBOL(dev_uc_init);
>   */
>  int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
>  {
> -	struct netdev_hw_addr *ha;
> +	struct rb_node **ha_node;
> +	struct rb_node *insert_parent = NULL;

reverse xmas tree

>  	int err;
>  
>  	netif_addr_lock_bh(dev);
> -	list_for_each_entry(ha, &dev->mc.list, list) {
> -		if (!memcmp(ha->addr, addr, dev->addr_len) &&
> -		    ha->type == NETDEV_HW_ADDR_T_MULTICAST) {
> -			err = -EEXIST;
> -			goto out;
> -		}
> +	ha_node = tree_address_lookup(&dev->mc, addr, dev->addr_len, NETDEV_HW_ADDR_T_MULTICAST, false, &insert_parent);
> +	if (*ha_node)
> +	{

+1 curly bracket style

> +		err = -EEXIST;
> +		goto out;
>  	}
>  	err = __hw_addr_create_ex(&dev->mc, addr, dev->addr_len,
> -				  NETDEV_HW_ADDR_T_MULTICAST, true, false);
> +				  NETDEV_HW_ADDR_T_MULTICAST, true, false, ha_node, insert_parent);
>  	if (!err)
>  		__dev_set_rx_mode(dev);
>  out:
> 

