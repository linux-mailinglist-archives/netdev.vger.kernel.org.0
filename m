Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6E71B1053
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgDTPgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgDTPgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:36:46 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D27C061A0C;
        Mon, 20 Apr 2020 08:36:46 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id n10so11433732iom.3;
        Mon, 20 Apr 2020 08:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xpyyjOah+SNmSyAdLM/sULwsGots46QSaLyc9pMiVp8=;
        b=SMpcvUKPCrnBP/1D1GILH+9dJhg3Ew+RFSzyapFmYW5cNEKpZ2Gq9D1Ls3qJFdS+F/
         dsoSz4CRHqHUey9tvUldedqHmIvVS9GwpbShans2Dh7YTN433ROdaTpMMqa6eD1ZJ+P/
         zM3oSGEWDajMTh9xHdxEPfz8UGDx4g4QcBtpYts/lUdhpFI7jzPEdyrlfH2FDBWaEXWU
         9amNNkxhIUo4zzP3IUEa1qs+7+10qWl0J6MhVCoYOkYFy+yT8f3AVfycLupVQZSssu8U
         Mc6hh7H8mPQCn0yo1XbB0E/UvlzUBN0rK3VsE+TVfA8YMml0Je0E1WF8xR6kBLCPmuip
         crOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xpyyjOah+SNmSyAdLM/sULwsGots46QSaLyc9pMiVp8=;
        b=tZvdWgpVEz0ukKw+XHHg2t33vULiavMndsXeKdEAVmsctc+E+WXIRJMwfZN6dh/ru4
         /WiuPTDoCU73vzSMI169zm5qdLkwlz0zN51aVEYABgUjCYr8zBXrVGNVvkrXCGi/mDQ4
         8ZRAZxh3SFkyM7AmYQIBsZHXAHmQij8lGg3FDpnSqfHxqCjQKKOGey5i1nFv2N66l1ve
         pbFqYRoXcJTXaY2jymJHKc+NmwUE4NcYWDhnpQjeE7LjfW7GmfhdgnrxBGoBhXZEY3b8
         TiIPic5n3Kgb3H0F+s0M0VOD4EVg7LbMisRocaF5mBHrw92cNbNpdqpTRsxEH6jo206z
         +wCQ==
X-Gm-Message-State: AGi0Pubd24cK429OOOqZxepuqwlnau5NfO8w5AUPMgzxvALNAXEF8xEB
        FXqzmbT8wK/p9eXcDs6Xj6s=
X-Google-Smtp-Source: APiQypI+awmNegG6xdj0dsgCCfaJbp6HXicBBTWHS3T8N9PqMnXTpfvQAh9tsadBsceYudkqYa2peQ==
X-Received: by 2002:a6b:6c01:: with SMTP id a1mr16165914ioh.196.1587397005739;
        Mon, 20 Apr 2020 08:36:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id k24sm377646ior.49.2020.04.20.08.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 08:36:45 -0700 (PDT)
Subject: Re: [PATCH V2 mlx5-next 04/10] bonding: Implement ndo_xmit_slave_get
To:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-5-maorg@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d01c874f-419e-36b1-5ddd-72daabcc0b83@gmail.com>
Date:   Mon, 20 Apr 2020 09:36:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420075426.31462-5-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 1:54 AM, Maor Gottlieb wrote:
> Add implementation of ndo_xmit_slave_get.
> When user sets the LAG_FLAGS_HASH_ALL_SLAVES bit and the xmit slave
> result is based on the hash, then the slave will be selected from the
> array of all the slaves.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> ---
>  drivers/net/bonding/bond_main.c | 123 +++++++++++++++++++++++++++-----
>  include/net/bonding.h           |   1 +
>  2 files changed, 105 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 7e04be86fda8..320bcb1394fd 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4137,6 +4137,40 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
>  	}
>  }
>  
> +static void bond_set_slave_arr(struct bonding *bond,
> +			       struct bond_up_slave *usable_slaves,
> +			       struct bond_up_slave *all_slaves)
> +{
> +	struct bond_up_slave *usable, *all;
> +
> +	usable = rtnl_dereference(bond->usable_slaves);
> +	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
> +	if (usable)
> +		kfree_rcu(usable, rcu);
> +
> +	all = rtnl_dereference(bond->all_slaves);
> +	rcu_assign_pointer(bond->all_slaves, all_slaves);
> +	if (all)
> +		kfree_rcu(all, rcu);
> +}
> +
> +static void bond_reset_slave_arr(struct bonding *bond)
> +{
> +	struct bond_up_slave *usable, *all;
> +
> +	usable = rtnl_dereference(bond->usable_slaves);
> +	if (usable) {
> +		RCU_INIT_POINTER(bond->usable_slaves, NULL);
> +		kfree_rcu(usable, rcu);
> +	}
> +
> +	all = rtnl_dereference(bond->all_slaves);
> +	if (all) {
> +		RCU_INIT_POINTER(bond->all_slaves, NULL);
> +		kfree_rcu(all, rcu);
> +	}
> +}
> +
>  /* Build the usable slaves array in control path for modes that use xmit-hash
>   * to determine the slave interface -
>   * (a) BOND_MODE_8023AD
> @@ -4147,7 +4181,7 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
>   */
>  int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>  {
> -	struct bond_up_slave *usable_slaves, *old_usable_slaves;
> +	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
>  	struct slave *slave;
>  	struct list_head *iter;
>  	int agg_id = 0;
> @@ -4159,7 +4193,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>  
>  	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
>  					    bond->slave_cnt), GFP_KERNEL);
> -	if (!usable_slaves) {
> +	all_slaves = kzalloc(struct_size(all_slaves, arr,
> +					 bond->slave_cnt), GFP_KERNEL);
> +	if (!usable_slaves || !all_slaves) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> @@ -4168,20 +4204,19 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>  
>  		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
>  			pr_debug("bond_3ad_get_active_agg_info failed\n");
> -			kfree_rcu(usable_slaves, rcu);
>  			/* No active aggragator means it's not safe to use
>  			 * the previous array.
>  			 */
> -			old_usable_slaves = rtnl_dereference(bond->usable_slaves);
> -			if (old_usable_slaves) {
> -				RCU_INIT_POINTER(bond->usable_slaves, NULL);
> -				kfree_rcu(old_usable_slaves, rcu);
> -			}
> +			bond_reset_slave_arr(bond);
>  			goto out;
>  		}
>  		agg_id = ad_info.aggregator_id;
>  	}
>  	bond_for_each_slave(bond, slave, iter) {
> +		if (skipslave == slave)
> +			continue;
> +
> +		all_slaves->arr[all_slaves->count++] = slave;
>  		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
>  			struct aggregator *agg;
>  
> @@ -4191,8 +4226,6 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>  		}
>  		if (!bond_slave_can_tx(slave))
>  			continue;
> -		if (skipslave == slave)
> -			continue;
>  
>  		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
>  			  usable_slaves->count);
> @@ -4200,14 +4233,17 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>  		usable_slaves->arr[usable_slaves->count++] = slave;
>  	}
>  
> -	old_usable_slaves = rtnl_dereference(bond->usable_slaves);
> -	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
> -	if (old_usable_slaves)
> -		kfree_rcu(old_usable_slaves, rcu);
> +	bond_set_slave_arr(bond, usable_slaves, all_slaves);
> +	return ret;
>  out:
> -	if (ret != 0 && skipslave)
> +	if (ret != 0 && skipslave) {
> +		bond_skip_slave(rtnl_dereference(bond->all_slaves),
> +				skipslave);
>  		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
>  				skipslave);
> +	}
> +	kfree_rcu(all_slaves, rcu);
> +	kfree_rcu(usable_slaves, rcu);
>  
>  	return ret;
>  }

none of the above code has anything to do directly with looking up the
bond slave in bond_xmit_get_slave; all of that and the bond_uninit
changes should be done in refactoring patch(es) that prepare existing
code to be called from the new ndo.
