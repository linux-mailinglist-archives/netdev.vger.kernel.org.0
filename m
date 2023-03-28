Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9EF6CB91E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjC1IOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjC1IOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:14:05 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45585A2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:14:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i5so46351360eda.0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679991242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdI7wx9n/RqOuCwicWLNyZaYr9uM1xIYll/4/2mTjTY=;
        b=25ZPENnuKHPwXy4Ubxa5aPXgvvyTX5fAAxLoi0WnY7fmdhy4vcAtQQDVhfY1w1c0xk
         0ZEnm7CUaFPsYz4Q7RV3D/g7OP1owkCYq/9MY4hi4Zn94Z7NgKowHulFCn3Q0NdXyKbT
         mAsNq4e1gLwhqJkR+1aqgRT7Y++d2u19/776GozoRVWYGJqL5kACpAAwuaECzwDcEcQi
         UZgUAB7hXkbmo+sRqekZSiL4ViwSwLmKBw/lUnxaBlCTATiWjoQ8xIkRWvmhMzmRjeK6
         7nSiOMXC8N7JTSwlcKuvyKPTUrujetOHIGOiImdFF3I8Z7TMcisoak803v79pOO4UHty
         hz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679991242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdI7wx9n/RqOuCwicWLNyZaYr9uM1xIYll/4/2mTjTY=;
        b=U74GB4PlI8/k5bg5xSIPntAMj32Ltb5fBzAcPbqpjIVnZCYZNfgPRBagGLUdjFxpkT
         cIbSSHC9BMtzOuxqm5sLoFeQLlsnBqn14kB1ZCgl9RYRUL+vRwuPo1DlANZZsqHWIFO3
         3Toi4/mo1iXKzw/m4Tq2AFriHw8OqyXxoq4pv9bh+2yYJH7XnekcdvC7e9NrxJYA8QVK
         5UQW0/cj5WMNqO2TYhBeBStHn6PaYz11+dXAXvX0XZQ25x+ZiWvmt7nkwwYSYkWKDUD8
         TQ4OYdek5NN4OKpBv+WkNN8YHmNhaSglmTnML1M7c8Z8fUDG89SckanoC1r9V3Wk8BBg
         VgtA==
X-Gm-Message-State: AAQBX9exKdmbOswUfqeXqoRfo+12ZneX6TkXcOmYCu5xUwOq54wusFya
        afejxRK4IrYR0zjQI9C603AZ1Q==
X-Google-Smtp-Source: AKy350YFTmqqeRvEA0C5EY5CL4BisrXLAhMemHT46Ct82/K0IBUZHkf62Tvp5w1QS9YncqkBgd8SeA==
X-Received: by 2002:a17:906:b16:b0:92a:3709:e872 with SMTP id u22-20020a1709060b1600b0092a3709e872mr14916112ejg.19.1679991241567;
        Tue, 28 Mar 2023 01:14:01 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id a25-20020a50c319000000b004bc15a440f1sm15699044edb.78.2023.03.28.01.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 01:14:01 -0700 (PDT)
Message-ID: <6d92a9bb-f8ce-3d89-9048-039426480416@blackwall.org>
Date:   Tue, 28 Mar 2023 11:14:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: bonding: avoid use-after-free with
 tx_hashtbl/rx_hashtbl
Content-Language: en-US
To:     sujing <sujing@kylinos.cn>, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andy@greyhouse.net, j.vosburgh@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230328034037.2076930-1-sujing@kylinos.cn>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230328034037.2076930-1-sujing@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 06:40, sujing wrote:
> In bonding mode 6 (Balance-alb),
> there are some potential race conditions between the 'bond_close' process
> and the tx/rx processes that use tx_hashtbl/rx_hashtbl,
> which may lead to use-after-free.

Potential and may? Have you seen it happen and have a trace?

> 
> For instance, when the bond6 device is in the 'bond_close' process
> while some backlogged packets from upper level are transmitted

How exactly would that happen? Queues get properly disabled before ndo_stop
is called.

> to 'bond_start_xmit', there is a spinlock contention between
> 'tlb_deinitialize' and 'tlb_choose_channel'.
> 
> If 'tlb_deinitialize' preempts the lock before 'tlb_choose_channel',
> a NULL pointer kernel panic will be triggered.
> 
> Here's the timeline:
> 
> bond_close  ------------------  bond_start_xmit
> bond_alb_deinitialize  -------  __bond_start_xmit
> tlb_deinitialize  ------------  bond_alb_xmit
> spin_lock_bh  ----------------  bond_xmit_alb_slave_get
> tx_hashtbl = NULL  -----------  tlb_choose_channel
> spin_unlock_bh  --------------  //wait for spin_lock_bh
> ------------------------------  spin_lock_bh
> ------------------------------  __tlb_choose_channel
> causing kernel panic ========>  tx_hashtbl[hash_index].tx_slave
> ------------------------------  spin_unlock_bh

I don't see how bond_close() can be called in parallel with bond_start_xmit.
Tx queues are disabled and there's a synchronize_rcu() before the device's
ndo_stop is called.

> 
> Signed-off-by: sujing <sujing@kylinos.cn>
> ---
>  drivers/net/bonding/bond_alb.c  | 32 +++++++++------------------
>  drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++++++++------
>  include/net/bond_alb.h          |  5 ++++-
>  3 files changed, 46 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index b9dbad3a8af8..f6ff5ea835c4 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -71,7 +71,7 @@ static inline u8 _simple_hash(const u8 *hash_start, int hash_size)
>  
>  /*********************** tlb specific functions ***************************/
>  
> -static inline void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
> +void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
>  {
>  	if (save_load) {
>  		entry->load_history = 1 + entry->tx_bytes /
> @@ -269,8 +269,8 @@ static void rlb_update_entry_from_arp(struct bonding *bond, struct arp_pkt *arp)
>  	spin_unlock_bh(&bond->mode_lock);
>  }
>  
> -static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
> -			struct slave *slave)
> +int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
> +		 struct slave *slave)
>  {
>  	struct arp_pkt *arp, _arp;
>  
> @@ -756,7 +756,7 @@ static void rlb_init_table_entry_src(struct rlb_client_info *entry)
>  	entry->src_next = RLB_NULL_INDEX;
>  }
>  
> -static void rlb_init_table_entry(struct rlb_client_info *entry)
> +void rlb_init_table_entry(struct rlb_client_info *entry)
>  {
>  	memset(entry, 0, sizeof(struct rlb_client_info));
>  	rlb_init_table_entry_dst(entry);
> @@ -874,9 +874,6 @@ static int rlb_initialize(struct bonding *bond)
>  
>  	spin_unlock_bh(&bond->mode_lock);
>  
> -	/* register to receive ARPs */
> -	bond->recv_probe = rlb_arp_recv;
> -
>  	return 0;
>  }
>  
> @@ -888,7 +885,6 @@ static void rlb_deinitialize(struct bonding *bond)
>  
>  	kfree(bond_info->rx_hashtbl);
>  	bond_info->rx_hashtbl = NULL;
> -	bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
>  
>  	spin_unlock_bh(&bond->mode_lock);
>  }
> @@ -1303,7 +1299,7 @@ static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
>  
>  /************************ exported alb functions ************************/
>  
> -int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
> +int bond_alb_initialize(struct bonding *bond)
>  {
>  	int res;
>  
> @@ -1311,15 +1307,10 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>  	if (res)
>  		return res;
>  
> -	if (rlb_enabled) {
> -		res = rlb_initialize(bond);
> -		if (res) {
> -			tlb_deinitialize(bond);
> -			return res;
> -		}
> -		bond->alb_info.rlb_enabled = 1;
> -	} else {
> -		bond->alb_info.rlb_enabled = 0;
> +	res = rlb_initialize(bond);
> +	if (res) {
> +		tlb_deinitialize(bond);
> +		return res;
>  	}
>  
>  	return 0;
> @@ -1327,12 +1318,9 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>  
>  void bond_alb_deinitialize(struct bonding *bond)
>  {
> -	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
> -
>  	tlb_deinitialize(bond);
>  
> -	if (bond_info->rlb_enabled)
> -		rlb_deinitialize(bond);
> +	rlb_deinitialize(bond);
>  }
>  
>  static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 236e5219c811..8fcb5d3ac0a2 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4217,6 +4217,7 @@ static int bond_open(struct net_device *bond_dev)
>  	struct bonding *bond = netdev_priv(bond_dev);
>  	struct list_head *iter;
>  	struct slave *slave;
> +	int i;
>  
>  	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter) {
>  		bond->rr_tx_counter = alloc_percpu(u32);
> @@ -4239,11 +4240,29 @@ static int bond_open(struct net_device *bond_dev)
>  	}
>  
>  	if (bond_is_lb(bond)) {
> -		/* bond_alb_initialize must be called before the timer
> -		 * is started.
> -		 */
> -		if (bond_alb_initialize(bond, (BOND_MODE(bond) == BOND_MODE_ALB)))
> -			return -ENOMEM;
> +		struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
> +
> +		spin_lock_bh(&bond->mode_lock);
> +
> +		for (i = 0; i < TLB_HASH_TABLE_SIZE; i++)
> +			tlb_init_table_entry(&bond_info->tx_hashtbl[i], 0);
> +
> +		spin_unlock_bh(&bond->mode_lock);
> +
> +		if (BOND_MODE(bond) == BOND_MODE_ALB) {
> +			bond->alb_info.rlb_enabled = 1;
> +			spin_lock_bh(&bond->mode_lock);
> +
> +			bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
> +			for (i = 0; i < RLB_HASH_TABLE_SIZE; i++)
> +				rlb_init_table_entry(bond_info->rx_hashtbl + i);
> +
> +			spin_unlock_bh(&bond->mode_lock);
> +			bond->recv_probe = rlb_arp_recv;
> +		} else {
> +			bond->alb_info.rlb_enabled = 0;
> +		}
> +
>  		if (bond->params.tlb_dynamic_lb || BOND_MODE(bond) == BOND_MODE_ALB)
>  			queue_delayed_work(bond->wq, &bond->alb_work, 0);
>  	}
> @@ -4279,8 +4298,6 @@ static int bond_close(struct net_device *bond_dev)
>  
>  	bond_work_cancel_all(bond);
>  	bond->send_peer_notif = 0;
> -	if (bond_is_lb(bond))
> -		bond_alb_deinitialize(bond);
>  	bond->recv_probe = NULL;
>  
>  	if (bond_uses_primary(bond)) {
> @@ -5854,6 +5871,8 @@ static void bond_uninit(struct net_device *bond_dev)
>  	struct list_head *iter;
>  	struct slave *slave;
>  
> +	bond_alb_deinitialize(bond);
> +
>  	bond_netpoll_cleanup(bond_dev);
>  
>  	/* Release the bonded slaves */
> @@ -6295,6 +6314,12 @@ static int bond_init(struct net_device *bond_dev)
>  	    bond_dev->addr_assign_type == NET_ADDR_PERM)
>  		eth_hw_addr_random(bond_dev);
>  
> +	/* bond_alb_initialize must be called before the timer
> +	 * is started.
> +	 */
> +	if (bond_alb_initialize(bond))
> +		return -ENOMEM;
> +
>  	return 0;
>  }
>  
> diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
> index 9dc082b2d543..9fd16e20ef82 100644
> --- a/include/net/bond_alb.h
> +++ b/include/net/bond_alb.h
> @@ -150,7 +150,7 @@ struct alb_bond_info {
>  						 */
>  };
>  
> -int bond_alb_initialize(struct bonding *bond, int rlb_enabled);
> +int bond_alb_initialize(struct bonding *bond);
>  void bond_alb_deinitialize(struct bonding *bond);
>  int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
>  void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
> @@ -165,5 +165,8 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>  void bond_alb_monitor(struct work_struct *);
>  int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
>  void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
> +int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
> +void tlb_init_table_entry(struct tlb_client_info *entry, int save_load);
> +void rlb_init_table_entry(struct rlb_client_info *entry);
>  #endif /* _NET_BOND_ALB_H */
>  

