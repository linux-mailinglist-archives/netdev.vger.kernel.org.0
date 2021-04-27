Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149D536C44D
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhD0Kmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:42:54 -0400
Received: from mail-bn8nam08on2089.outbound.protection.outlook.com ([40.107.100.89]:13249
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235133AbhD0Kmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 06:42:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcdgNny5k1KEtB1TrBvNZMYFdqP7Ie2J6H2YtORRgseDGVBGWp2p+XDKYi1oJM0V860AUwYlWESczRrV3TNhdK3wQA1yr3q15f9b2FRNqoRFCd8pOFdReoFM1p2sAc1ue064yVHZILW7HbhJffaAxxCTHOE4wV2z0CCa7GmLBvVFnUF5jJ5xPoPv36lW4V+wHoP72t76l5TbIhYa/iFmGLvhtNZTGTZnqSXEfCIyvlp0RVNwEMQC+uBV2tBl6jbYETR6vU3M1rP0FfBrH6lc0nIRRGZ8cpe/YvLTNuYddtAKPbL053wyjSzvXJsBIvq7wbP46rs9ts5JrnwKE0QneQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxngR24Xun8w7PYnV9RV909Yu9fnBY0je9+WfuAMWEY=;
 b=T4UPq8xc8jTGy9V68GILV1j+gTF12NM0m89HGlMEsZ03EVQ7IUIECXRIoa8wTU0T/T7I6TDjScrV4fWkhiydyrvBYjSMd+z4KHgijcT8wS7AWbpwLoHd7ZrnY+cfcf1G/DhrW+MJToPuk2ZzMxtz4GxdWlbQ83nMHnqCkEdM0oF79EJw/WIevvQugRd87uI6yenPLcODXKWvTHGA8l8Jvpp5xPYDqE3XAXSKnHOEnbEoh/HUx9N4x4gszQ3ywFWX9bCCPhvAQz/hLHB5yQJ2mSLQZXxzaMTm2ilEunS2Cblfn9pgIScUN0k1JLLnBpJKiY5wLf8QsiO7SQcWjoAvpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxngR24Xun8w7PYnV9RV909Yu9fnBY0je9+WfuAMWEY=;
 b=E7zmfQA2PKRZXXASn4OD1rLunWt8lZ44x21Prm03ipI50ZGlIGq/dsJpD3+jwKKqU11O82jp8SPv7isZ1yTOlP8A71vr4f3WJUX8OKs7Xx19bgyK/KqysD+OiaxyeylWOZQoPhQBxWN4vSsDt73EidMtS//MkCC8OlrtIa4jCVIHrBPy8wQSYrrgDWSpiUR/a/URlk8gdfsetmhKY5wz9lZMHCiWgmFCX4GOEZ8W0ubbAYk8HureY+soFXPz8aZjOuA3xl7dAKzTVedLY9dPVVGRmaD+lT7bDqpr1teh3IMjk+gOspyIlquxH2EcEJIKV2jdI7cW/tsKuQs7SIrQsA==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5296.namprd12.prod.outlook.com (2603:10b6:5:39d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Tue, 27 Apr
 2021 10:42:08 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 10:42:08 +0000
Subject: Re: [RFC net-next 3/9] net: bridge: switchdev: Recycle unused hwdoms
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-4-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <26e631b0-f5d0-343e-194d-c15b4a8dc7aa@nvidia.com>
Date:   Tue, 27 Apr 2021 13:42:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210426170411.1789186-4-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.78] (213.179.129.39) by ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Tue, 27 Apr 2021 10:42:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fead0975-db59-4939-8e78-08d909691b08
X-MS-TrafficTypeDiagnostic: DM4PR12MB5296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5296A836E59CEE2B6644BDCDDF419@DM4PR12MB5296.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbKc9BNgueeqi//ELt3SC6yN34YLYLsJMSr1vAEhcM54BY+Iyt8lO1xSzYjXAvwE9KTisJ64d5Uvsy+uLlk8MSRBa9Pqda+QF1yTFLT+gJJ2qm5LvyYhlsxEg0V7q6kMmUvgGnobZwZRbBsGzc0z6rbhkNqbt3Y0SfkVwVA+ZNsnh3hDh4KUQszufyoPqJ4HFBHgVW8LR8WNvnqSYTpu6xstqctQkyl9XbESbPVcugn8cm7EgiwA04MAuYrerDaZ2O6MOMV20VX1QH7/FFsU9KMu2r7Ahac6bT/293tj4h/heZTuF7mtZMFZdHgKWudoOh0jy4jM5atjKarCDdedxIzt8JB4yfk0WI69H6sCiFDVzmbVByWqgLW1oXm/rROIWudfG+M5bMSccB3UN3467/0VRtofYI/OoCnUIqbUb/gV2HV1yutkgHpMaKf7NQvgAPIEdo3Ao7XKXnVBnBVwC9zDCHHn276WsnMP6oeOe5e0W1mgKyHT8y0L3UiU/ubdVc0adkfGbtGUjxWyNLhem0TP/YJpJ6k+r5czXuBf6JTsVPapkUfvxkB38gJVeLl3g96ejiINuqe5d2VnQisF0pj5c5TNcyGlhrRC7syQXMWDukHI8//0G2dph5y7Bl/Jka6/YbxaTqnqf0f57zvAcHKmX+0WGJxH+rfTfR/+kwob4rL6cWOiIuR6vnKfsOJE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(66476007)(36756003)(66556008)(26005)(7416002)(2616005)(6666004)(16576012)(86362001)(31686004)(956004)(66946007)(8676002)(53546011)(83380400001)(5660300002)(4326008)(2906002)(38100700002)(8936002)(6486002)(478600001)(16526019)(31696002)(316002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UU1YNjlDR2kvZnYyaGU4WXJuajdwMlE2OFN0RFFuS0EzNVRyOTdpMWlxWXVE?=
 =?utf-8?B?TFhrNW9SNzRTTUVvOVpubkNBWnVONDVOOTFxNUpkKzU3VzBCQWlIR2JuT2Zy?=
 =?utf-8?B?SGVIWG9pRWlhTHRWZkxMTW85d3JWVUxKY2tUWXhPZTlLekZHZ0wxbDU0VWkx?=
 =?utf-8?B?Qm11aVcxNWZVVjhaWnhPZ2ZrRWlCNnRtUmpsR3Z4dUszUDFvVEtlVFZXZ1hW?=
 =?utf-8?B?a0hDUUptOUtac1ZRamh3VGI5cXd6bGtEbWdrcjQ2dDlVSmRVejl6ODhSZVA1?=
 =?utf-8?B?REhDaXZxT0ExRmN2ZWlBUWUwc1diNjUwVURrWlh6bnFpeFNGUXZURXg5bkJZ?=
 =?utf-8?B?NTFpN3JNaXJxRlpQNDZ0c2tNRHowUC9aanZXcDNFVnRNTFY4TndJalhjZFdD?=
 =?utf-8?B?OXVrdVd5dXAycXhlOE01VWNwMnBkWmFCaDVTWkJlclpDNnpiUVBpR2ZSNUlP?=
 =?utf-8?B?YjVmcXVObVN5bitSSE0vb2p2TUxhR3ZQSjRJaEYrbkpwWFNUMzRPQkZCL01h?=
 =?utf-8?B?SXkwdGwzbnlEYTl4NFJlYjFzdHc1TzhxOVY0L3gvLzZXR3VtNCtoVWhKU0d0?=
 =?utf-8?B?UDE2TWNkWWIzYWNpUVhvM1BLUWhlekwzOTYrZFBJWVl4cWx3QjR2U1FFZmd2?=
 =?utf-8?B?cTZwa3E1d1FrdHpiL1dmM1dBTG9ISjhLMFMzSENBU29DQTlaRGNmMlk1K2oz?=
 =?utf-8?B?dzllRmhPTkhzQjN1dHNFbGZtWW4wY1FiNG1nVGVGUkFBcFkvZ1I2NVlCZjBB?=
 =?utf-8?B?ZjYzWHhyVDlJd28wUjJhMmtNbTEwdXdHNmEyQ3FOY2lKSnYvTGdUZk80QWtL?=
 =?utf-8?B?OGZUbG8yaXQ3cEZyOGNockZleUVxVXY5dkNUOStVS2tDZnFCMFQvdnpqVjJ1?=
 =?utf-8?B?NlZtTk43QWVZUksyaitjNktYVW95amtIaHprNE1kTnp2MWlmU0V0STFRU25w?=
 =?utf-8?B?MG5OUklieUFTeHBEMjVkdWgrZGdXbTQ4TEhDMzQ5ZVYzbU0wd1loaStJendL?=
 =?utf-8?B?WS9wUmdGcERRd3ErNE9USTdBd2pPWFk5TkNiWHZ5WE1KQkNZWU5vMk9UWi9H?=
 =?utf-8?B?cXI2K00xZVI5YlQ1R0ZlanhMUHRpNzJyb0EwT1hNcG5aYmMvQ04zWkpWWnFx?=
 =?utf-8?B?VFZ3a1d1aFlCeGdYM3k5WUNVaVRhLzVEN3VCYTFLcjhZcmZqbVljbDZTWU9E?=
 =?utf-8?B?ZHYvQ3IycFo2V0JNZXN2U3dhSWNzbFNVSzg3eVNLWUJwVFFadVlpVDQyQWZJ?=
 =?utf-8?B?Z2RzMEtLVHFoNy80bG95MURhY1pBMnFsYmlqN0hiVVNRTVZYVERvVWx2Qlkv?=
 =?utf-8?B?anhRa1luVlhrUXR3NTBMWFJ0VytSczFHZjlNSndXUlpqZ0xHclVMUC9jaFQr?=
 =?utf-8?B?YTNXRTBCSTZwWHB3UmhYKzlXbDhZRitYdVF4ZUxOaXVIVVJnMEZJZ3Y1Q2Zi?=
 =?utf-8?B?c0RUQ2hoczJKemhaZE9BdnRjamVrbExzQzBETGpDQmczRFJHUWh5OW81QkdH?=
 =?utf-8?B?ZVFHeUN3U0U3U2tQTkZ5aHcvb2FiT2g4WnczN3prVjEyNy9pZFh3Um5RdkQx?=
 =?utf-8?B?NjZGbGswWmsvUDg1TTNFOUJPQkhRVnNHQmpubzRLRkIyck80bzYrZ2VPVWdR?=
 =?utf-8?B?N0I4cjdObjdhRUhla3RNV2VzWkR4eXRjQjhRZkwwVmlVQ0NvMDJGSXQrSTcz?=
 =?utf-8?B?WHJlZkZiZzl5cEJ3M2tQL1F5aisvV0tZR29QMkJ3aCttbk9DM2hnSnBPN1Iv?=
 =?utf-8?Q?4vunCJXBAgoj/SMHgf1Kg135oZlRCkf0JHuXsym?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fead0975-db59-4939-8e78-08d909691b08
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 10:42:08.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FerSFqNibZNSPKbiC4FXixqddvcY0pJ+blSf8ufp8E3UuOt52YYNHN7/H7kU/YpuVAmIMt7oWDq9ikuudhDfdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2021 20:04, Tobias Waldekranz wrote:
> Since hwdoms has thus far only been used for equality comparisons, the
> bridge has used the simplest possible assignment policy; using a
> counter to keep track of the last value handed out.
> 
> With the upcoming transmit offloading, we need to perform set
> operations efficiently based on hwdoms, e.g. we want to answer
> questions like "has this skb been forwarded to any port within this
> hwdom?"
> 
> Move to a bitmap-based allocation scheme that recycles hwdoms once all
> members leaves the bridge. This means that we can use a single
> unsigned long to keep track of the hwdoms that have received an skb.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/bridge/br_if.c        |  4 +-
>  net/bridge/br_private.h   | 29 +++++++++---
>  net/bridge/br_switchdev.c | 94 ++++++++++++++++++++++++++-------------
>  3 files changed, 87 insertions(+), 40 deletions(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index 73fa703f8df5..adaf78e45c23 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -349,6 +349,7 @@ static void del_nbp(struct net_bridge_port *p)
>  	nbp_backup_clear(p);
>  
>  	nbp_update_port_count(br);
> +	nbp_switchdev_del(p);
>  
>  	netdev_upper_dev_unlink(dev, br->dev);
>  
> @@ -643,7 +644,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>  	if (err)
>  		goto err5;
>  
> -	err = nbp_switchdev_hwdom_set(p);
> +	err = nbp_switchdev_add(p);
>  	if (err)
>  		goto err6;
>  
> @@ -704,6 +705,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>  	list_del_rcu(&p->list);
>  	br_fdb_delete_by_port(br, p, 0, 1);
>  	nbp_update_port_count(br);
> +	nbp_switchdev_del(p);
>  err6:
>  	netdev_upper_dev_unlink(dev, br->dev);
>  err5:
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 53248715f631..aba92864d285 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -29,6 +29,8 @@
>  
>  #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
>  
> +#define BR_HWDOM_MAX BITS_PER_LONG
> +
>  #define BR_VERSION	"2.3"
>  
>  /* Control of forwarding link local multicast */
> @@ -54,6 +56,8 @@ typedef struct bridge_id bridge_id;
>  typedef struct mac_addr mac_addr;
>  typedef __u16 port_id;
>  
> +typedef DECLARE_BITMAP(br_hwdom_map_t, BR_HWDOM_MAX);
> +

You can avoid the typedef and DECLARE_BITMAP() and just use an
unsigned long below. In general avoiding new typedefs is a good thing. :)

>  struct bridge_id {
>  	unsigned char	prio[2];
>  	unsigned char	addr[ETH_ALEN];
> @@ -472,7 +476,7 @@ struct net_bridge {
>  	u32				auto_cnt;
>  
>  #ifdef CONFIG_NET_SWITCHDEV
> -	int last_hwdom;
> +	br_hwdom_map_t			busy_hwdoms;
>  #endif
>  	struct hlist_head		fdb_list;
>  
> @@ -1593,7 +1597,6 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
>  
>  /* br_switchdev.c */
>  #ifdef CONFIG_NET_SWITCHDEV
> -int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  			      struct sk_buff *skb);
>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> @@ -1607,17 +1610,15 @@ void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
>  int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
>  			       struct netlink_ext_ack *extack);
>  int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
> +int nbp_switchdev_add(struct net_bridge_port *p);
> +void nbp_switchdev_del(struct net_bridge_port *p);
> +void br_switchdev_init(struct net_bridge *br);
>  
>  static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
>  {
>  	skb->offload_fwd_mark = 0;
>  }
>  #else
> -static inline int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
> -{
> -	return 0;
> -}
> -
>  static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  					    struct sk_buff *skb)
>  {
> @@ -1657,6 +1658,20 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
>  static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
>  {
>  }
> +
> +static inline int nbp_switchdev_add(struct net_bridge_port *p)
> +{
> +	return 0;
> +}
> +
> +static inline void nbp_switchdev_del(struct net_bridge_port *p)
> +{
> +}
> +
> +static inline void br_switchdev_init(struct net_bridge *br)
> +{
> +}
> +
>  #endif /* CONFIG_NET_SWITCHDEV */
>  
>  /* br_arp_nd_proxy.c */
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index bc085077ae71..54bd7205bfb5 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -8,38 +8,6 @@
>  
>  #include "br_private.h"
>  
> -static int br_switchdev_hwdom_get(struct net_bridge *br, struct net_device *dev)
> -{
> -	struct net_bridge_port *p;
> -
> -	/* dev is yet to be added to the port list. */
> -	list_for_each_entry(p, &br->port_list, list) {
> -		if (netdev_port_same_parent_id(dev, p->dev))
> -			return p->hwdom;
> -	}
> -
> -	return ++br->last_hwdom;
> -}
> -
> -int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
> -{
> -	struct netdev_phys_item_id ppid = { };
> -	int err;
> -
> -	ASSERT_RTNL();
> -
> -	err = dev_get_port_parent_id(p->dev, &ppid, true);
> -	if (err) {
> -		if (err == -EOPNOTSUPP)
> -			return 0;
> -		return err;
> -	}
> -
> -	p->hwdom = br_switchdev_hwdom_get(p->br, p->dev);
> -
> -	return 0;
> -}
> -
>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
>  			      struct sk_buff *skb)
>  {
> @@ -156,3 +124,65 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
>  
>  	return switchdev_port_obj_del(dev, &v.obj);
>  }
> +
> +static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
> +{
> +	struct net_bridge *br = joining->br;
> +	struct net_bridge_port *p;
> +	int hwdom;
> +
> +	/* joining is yet to be added to the port list. */
> +	list_for_each_entry(p, &br->port_list, list) {
> +		if (netdev_port_same_parent_id(joining->dev, p->dev)) {
> +			joining->hwdom = p->hwdom;
> +			return 0;
> +		}
> +	}
> +
> +	hwdom = find_next_zero_bit(br->busy_hwdoms, BR_HWDOM_MAX, 1);
> +	if (hwdom >= BR_HWDOM_MAX)
> +		return -EBUSY;
> +
> +	set_bit(hwdom, br->busy_hwdoms);
> +	joining->hwdom = hwdom;
> +	return 0;
> +}
> +
> +static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
> +{
> +	struct net_bridge *br = leaving->br;
> +	struct net_bridge_port *p;
> +
> +	/* leaving is no longer in the port list. */
> +	list_for_each_entry(p, &br->port_list, list) {
> +		if (p->hwdom == leaving->hwdom)
> +			return;
> +	}
> +
> +	clear_bit(leaving->hwdom, br->busy_hwdoms);
> +}
> +
> +int nbp_switchdev_add(struct net_bridge_port *p)
> +{
> +	struct netdev_phys_item_id ppid = { };
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	err = dev_get_port_parent_id(p->dev, &ppid, true);
> +	if (err) {
> +		if (err == -EOPNOTSUPP)
> +			return 0;
> +		return err;
> +	}
> +
> +	return nbp_switchdev_hwdom_set(p);
> +}
> +
> +void nbp_switchdev_del(struct net_bridge_port *p)
> +{
> +	ASSERT_RTNL();
> +
> +	if (p->hwdom)
> +		nbp_switchdev_hwdom_put(p);
> +}
> 

