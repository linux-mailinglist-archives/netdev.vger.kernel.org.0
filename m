Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75581B1541
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgDTS7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:59:47 -0400
Received: from mail-eopbgr10056.outbound.protection.outlook.com ([40.107.1.56]:8368
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgDTS7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:59:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnHHZXDoEkJ9Tqf2KYjLmwUHKKSS/mrvY0aTTwCYU7sAwvxa5cTUkZ3Kwt7aKKXl7o+JcBrbtdP8IS/BBfsCzEWOt1dHbCv5MBfjRJHEX2D2ysUhKBfNPH9eEosv2O1OMdtQENvJXxeBXK9spanhme302oPxk0TViakS4HVW2YaE0n+ZuB289hdQ7/kpF1DdWykOcXSzbnZ8xn14PZ2uFk1hxEjZXtSwY4wcUdoaKvKMb2xfl4DngfvjgpgNUAfzHrYnI8pAt73Ef2B1BA+mLSd/PF/pXZdJX3G1cSII0cDppl9j0C2W0WgHCndyMg0KA82jlJxAexxyo1dZVTJSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ogz5icVpkosK93N7hoOs2UDaewzeS9pclhSLNQkayc=;
 b=EXnFzMtnE9j0sBiYvNDGt51BIRPB6/8mZBNZ8X7cp+AZxGVCPTwX9O/1wBvS6o0HrYvWUt12956LhGgq2RZsCJHD4owU5qwFhhddDvvGBj50jeXwnq8uuFYuJ9UjQa5oGmayHD4EnZyTi/Sk4sX+jkbpueMi6WtYlXRP+UcT4ZfYmFdPtmVpz+vr/DSdQKRYheZa5gqXFWUSbQmBEjtMEvfD0arlLiB/nGpysHgQbH/hXQuZyboXFaEAJPLKsg43y9uB1X3RAAq+gLFnmiIggCoMr1Hs2DM3HgmCLQi2G2TNpSPYqs5kN905uMvEpe5zByuRgofdFcEtVwwg/tsnRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ogz5icVpkosK93N7hoOs2UDaewzeS9pclhSLNQkayc=;
 b=c2qZQCDBFMOQynLWJZpGuoBaPSMrnE9eubST+Q+WFZZvCV/2Oij+FfIONlxb77BSQZY54Z5rQmMLu6ZykbHBO6jLZkHEwQtWy3EOTqlvX0YBIvhN639/GpspNVx2F8dJYW43oaVG1l8wE9OiHqMIsngyYIVsrSArpEXTEG5Vxtc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB4211.eurprd05.prod.outlook.com (2603:10a6:208:67::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Mon, 20 Apr
 2020 18:59:40 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 18:59:40 +0000
Subject: Re: [PATCH V2 mlx5-next 03/10] bonding: Add helpers to get xmit slave
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-4-maorg@mellanox.com>
 <20200420142726.GM6581@nanopsycho.orion> <1202.1587408405@famine>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <3956d6ae-8030-725d-1342-237c6eac860d@mellanox.com>
Date:   Mon, 20 Apr 2020 21:59:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1202.1587408405@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::23) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 18:59:38 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c84d160-d3a8-4914-0029-08d7e55cfaef
X-MS-TrafficTypeDiagnostic: AM0PR05MB4211:|AM0PR05MB4211:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB421130B5BF47E207276C5261D3D40@AM0PR05MB4211.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(107886003)(110136005)(36756003)(316002)(16576012)(53546011)(26005)(30864003)(2906002)(31696002)(86362001)(5660300002)(6486002)(52116002)(8676002)(81156014)(186003)(16526019)(4326008)(31686004)(8936002)(478600001)(66476007)(956004)(66946007)(66556008)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mOzaLY8mYW/90crxi3Mtl7rE+lDOQOVtOvoWkDTIfmv2poenRRST5vib8qAC5z+Th4Yi0FKeH0rbPWCBoxPcNfif40dmqyTAMSW0J47Xiu7u2RSvzTPcT3kL7sL4Df6qOC3t50VvSnL/wnx5sVJHOiqCsCRDmsU2FrKJR8wvJmGPd+IHhfbaulrMZhzQSE+8EgwyjjJn4xrSfo2RGN7yBB3YGpZtqirE2GLW3Vzxle1QpoC5q2nP6V1uM3i9fQkvEu7xUFV6666rRdmy6NAij15+2GdBIRxYXAVAdRiXdmJ1H1Pfq2Ny7j6vf5KDMhLf2rjnR43D66aVs1JI/wLSxqcQ2+go9yGpUEkGJoeoI2oIyzNPM4iH5tIv/bxPPCt33Z8UKlfyjbPQkn3hbyCX0ESefvI2xW9jDDWQLugAA33SGW6/seTNBM6+Mk77GfQa
X-MS-Exchange-AntiSpam-MessageData: 9T8k60MmmX9OdN7mvcY/O7NfptI+01bBneaDz5UinEZ23nL0P3LNmVUtgGF2qU33DjKwPAt27Bb78QVLdhliN02Jb74kOwsnacMUzafodpMLGMoZg78uxA+OpN3JnLEtRFcdnAz06hBPWTcg1cxlwA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c84d160-d3a8-4914-0029-08d7e55cfaef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 18:59:40.7212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqZJO53lHByxc+A8CNXjQmwM3E69b8xJBDZF6fsyZzmT0fmd7g+riisfJtM0nmwptQns2g6lML+Q8P77Wgq7iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4211
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/20/2020 9:46 PM, Jay Vosburgh wrote:
> Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Mon, Apr 20, 2020 at 09:54:19AM CEST, maorg@mellanox.com wrote:
>>> This helpers will be used by both the xmit function
>>> and the get xmit slave ndo.
>> Be more verbose about what you are doing please. From this I have no
>> clue what is going on.
> 	Agreed, and also with Jiri's comment further down to split this
> into multiple patches.  The current series is difficult to follow.
>
> 	-J

Agree, I am splitting this series to more patches so it will be easier 
to follow.
>>> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>>> ---
>>> drivers/net/bonding/bond_alb.c  | 35 ++++++++----
>>> drivers/net/bonding/bond_main.c | 94 +++++++++++++++++++++------------
>>> include/net/bond_alb.h          |  4 ++
>>> 3 files changed, 89 insertions(+), 44 deletions(-)
>>>
>>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>>> index 7bb49b049dcc..e863c694c309 100644
>>> --- a/drivers/net/bonding/bond_alb.c
>>> +++ b/drivers/net/bonding/bond_alb.c
>>> @@ -1334,11 +1334,11 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
>>> 	return NETDEV_TX_OK;
>>> }
>>>
>>> -netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>>> +struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>>> +				      struct sk_buff *skb)
>>> {
>>> -	struct bonding *bond = netdev_priv(bond_dev);
>>> -	struct ethhdr *eth_data;
>>> 	struct slave *tx_slave = NULL;
>>> +	struct ethhdr *eth_data;
>>> 	u32 hash_index;
>>>
>>> 	skb_reset_mac_header(skb);
>>> @@ -1369,20 +1369,29 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>>> 			break;
>>> 		}
>>> 	}
>>> -	return bond_do_alb_xmit(skb, bond, tx_slave);
>>> +	return tx_slave;
>>> }
>>>
>>> -netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>>> +netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>>> {
>>> 	struct bonding *bond = netdev_priv(bond_dev);
>>> -	struct ethhdr *eth_data;
>>> +	struct slave *tx_slave;
>>> +
>>> +	tx_slave = bond_xmit_tlb_slave_get(bond, skb);
>>> +	return bond_do_alb_xmit(skb, bond, tx_slave);
>>> +}
>>> +
>>> +struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>>> +				      struct sk_buff *skb)
>>> +{
>>> 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
>>> -	struct slave *tx_slave = NULL;
>>> 	static const __be32 ip_bcast = htonl(0xffffffff);
>>> -	int hash_size = 0;
>>> +	struct slave *tx_slave = NULL;
>>> +	const u8 *hash_start = NULL;
>>> 	bool do_tx_balance = true;
>>> +	struct ethhdr *eth_data;
>>> 	u32 hash_index = 0;
>>> -	const u8 *hash_start = NULL;
>>> +	int hash_size = 0;
>>>
>>> 	skb_reset_mac_header(skb);
>>> 	eth_data = eth_hdr(skb);
>>> @@ -1501,7 +1510,15 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>>> 						       count];
>>> 		}
>>> 	}
>>> +	return tx_slave;
>>> +}
>>> +
>>> +netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>>> +{
>>> +	struct bonding *bond = netdev_priv(bond_dev);
>>> +	struct slave *tx_slave = NULL;
>>>
>>> +	tx_slave = bond_xmit_alb_slave_get(bond, skb);
>>> 	return bond_do_alb_xmit(skb, bond, tx_slave);
>>> }
>>>
>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>> index 2cb41d480ae2..7e04be86fda8 100644
>>> --- a/drivers/net/bonding/bond_main.c
>>> +++ b/drivers/net/bonding/bond_main.c
>>> @@ -82,6 +82,7 @@
>>> #include <net/bonding.h>
>>> #include <net/bond_3ad.h>
>>> #include <net/bond_alb.h>
>>> +#include <net/lag.h>
>>>
>>> #include "bonding_priv.h"
>>>
>>> @@ -3406,10 +3407,26 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
>>> 		(__force u32)flow_get_u32_src(&flow);
>>> 	hash ^= (hash >> 16);
>>> 	hash ^= (hash >> 8);
>>> -
>> Please avoid changes like this one.
>>
>>
>>> 	return hash >> 1;
>>> }
>>>
>>> +static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
>>> +						 struct sk_buff *skb,
>>> +						 struct bond_up_slave *slaves)
>>> +{
>>> +	struct slave *slave;
>>> +	unsigned int count;
>>> +	u32 hash;
>>> +
>>> +	hash = bond_xmit_hash(bond, skb);
>>> +	count = slaves ? READ_ONCE(slaves->count) : 0;
>>> +	if (unlikely(!count))
>>> +		return NULL;
>>> +
>>> +	slave = slaves->arr[hash % count];
>>> +	return slave;
>>> +}
>> Why don't you have this helper near bond_3ad_xor_xmit() as you have for
>> round robin for example?

No good reason, will move it near.
>>
>> I think it would make this patch much easier to review if you split to
>> multiple patches, per-mode.
>>
>>
>>> +
>>> /*-------------------------- Device entry points ----------------------------*/
>>>
>>> void bond_work_init_all(struct bonding *bond)
>>> @@ -3923,16 +3940,15 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
>>> }
>>>
>>> /**
>>> - * bond_xmit_slave_id - transmit skb through slave with slave_id
>>> + * bond_get_slave_by_id - get xmit slave with slave_id
>>>   * @bond: bonding device that is transmitting
>>> - * @skb: buffer to transmit
>>>   * @slave_id: slave id up to slave_cnt-1 through which to transmit
>>>   *
>>> - * This function tries to transmit through slave with slave_id but in case
>>> + * This function tries to get slave with slave_id but in case
>>>   * it fails, it tries to find the first available slave for transmission.
>>> - * The skb is consumed in all cases, thus the function is void.
>>>   */
>>> -static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int slave_id)
>>> +static struct slave *bond_get_slave_by_id(struct bonding *bond,
>>> +					  int slave_id)
>>> {
>>> 	struct list_head *iter;
>>> 	struct slave *slave;
>>> @@ -3941,10 +3957,8 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
>>> 	/* Here we start from the slave with slave_id */
>>> 	bond_for_each_slave_rcu(bond, slave, iter) {
>>> 		if (--i < 0) {
>>> -			if (bond_slave_can_tx(slave)) {
>>> -				bond_dev_queue_xmit(bond, skb, slave->dev);
>>> -				return;
>>> -			}
>>> +			if (bond_slave_can_tx(slave))
>>> +				return slave;
>>> 		}
>>> 	}
>>>
>>> @@ -3953,13 +3967,11 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
>>> 	bond_for_each_slave_rcu(bond, slave, iter) {
>>> 		if (--i < 0)
>>> 			break;
>>> -		if (bond_slave_can_tx(slave)) {
>>> -			bond_dev_queue_xmit(bond, skb, slave->dev);
>>> -			return;
>>> -		}
>>> +		if (bond_slave_can_tx(slave))
>>> +			return slave;
>>> 	}
>>> -	/* no slave that can tx has been found */
>>> -	bond_tx_drop(bond->dev, skb);
>>> +
>>> +	return NULL;
>>> }
>>>
>>> /**
>>> @@ -3995,10 +4007,9 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
>>> 	return slave_id;
>>> }
>>>
>>> -static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
>>> -					struct net_device *bond_dev)
>>> +static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
>>> +						    struct sk_buff *skb)
>>> {
>>> -	struct bonding *bond = netdev_priv(bond_dev);
>>> 	struct slave *slave;
>>> 	int slave_cnt;
>>> 	u32 slave_id;
>>> @@ -4020,24 +4031,40 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
>>> 		if (iph->protocol == IPPROTO_IGMP) {
>>> 			slave = rcu_dereference(bond->curr_active_slave);
>>> 			if (slave)
>>> -				bond_dev_queue_xmit(bond, skb, slave->dev);
>>> -			else
>>> -				bond_xmit_slave_id(bond, skb, 0);
>>> -			return NETDEV_TX_OK;
>>> +				return slave;
>>> +			return bond_get_slave_by_id(bond, 0);
>>> 		}
>>> 	}
>>>
>>> non_igmp:
>>> 	slave_cnt = READ_ONCE(bond->slave_cnt);
>>> 	if (likely(slave_cnt)) {
>>> -		slave_id = bond_rr_gen_slave_id(bond);
>>> -		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
>>> -	} else {
>>> -		bond_tx_drop(bond_dev, skb);
>>> +		slave_id = bond_rr_gen_slave_id(bond) % slave_cnt;
>>> +		return bond_get_slave_by_id(bond, slave_id);
>>> 	}
>>> +	return NULL;
>>> +}
>>> +
>>> +static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
>>> +					struct net_device *bond_dev)
>>> +{
>>> +	struct bonding *bond = netdev_priv(bond_dev);
>>> +	struct slave *slave;
>>> +
>>> +	slave = bond_xmit_roundrobin_slave_get(bond, skb);
>>> +	if (slave)
>>> +		bond_dev_queue_xmit(bond, skb, slave->dev);
>>> +	else
>>> +		bond_tx_drop(bond_dev, skb);
>>> 	return NETDEV_TX_OK;
>>> }
>>>
>>> +static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
>>> +						      struct sk_buff *skb)
>>> +{
>>> +	return rcu_dereference(bond->curr_active_slave);
>>> +}
>>> +
>>> /* In active-backup mode, we know that bond->curr_active_slave is always valid if
>>>   * the bond has a usable interface.
>>>   */
>>> @@ -4047,7 +4074,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
>>> 	struct bonding *bond = netdev_priv(bond_dev);
>>> 	struct slave *slave;
>>>
>>> -	slave = rcu_dereference(bond->curr_active_slave);
>>> +	slave = bond_xmit_activebackup_slave_get(bond, skb);
>>> 	if (slave)
>>> 		bond_dev_queue_xmit(bond, skb, slave->dev);
>>> 	else
>>> @@ -4193,18 +4220,15 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
>>> 				     struct net_device *dev)
>>> {
>>> 	struct bonding *bond = netdev_priv(dev);
>>> -	struct slave *slave;
>>> 	struct bond_up_slave *slaves;
>>> -	unsigned int count;
>>> +	struct slave *slave;
>>>
>>> 	slaves = rcu_dereference(bond->usable_slaves);
>>> -	count = slaves ? READ_ONCE(slaves->count) : 0;
>>> -	if (likely(count)) {
>>> -		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
>>> +	slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
>>> +	if (likely(slave))
>>> 		bond_dev_queue_xmit(bond, skb, slave->dev);
>>> -	} else {
>>> +	else
>>> 		bond_tx_drop(dev, skb);
>>> -	}
>>>
>>> 	return NETDEV_TX_OK;
>>> }
>>> diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
>>> index b3504fcd773d..f6af76c87a6c 100644
>>> --- a/include/net/bond_alb.h
>>> +++ b/include/net/bond_alb.h
>>> @@ -158,6 +158,10 @@ void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char
>>> void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
>>> int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
>>> int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
>>> +struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>>> +				      struct sk_buff *skb);
>>> +struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>>> +				      struct sk_buff *skb);
>>> void bond_alb_monitor(struct work_struct *);
>>> int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
>>> void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
>>> -- 
>>> 2.17.2
>>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
