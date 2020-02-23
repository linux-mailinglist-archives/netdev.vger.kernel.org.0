Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B691696DD
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 09:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgBWIxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 03:53:24 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54996 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgBWIxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 03:53:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so2796638wmi.4
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 00:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cX3xXKs6dY9rUympwY4HzO2/TpWowjrtyd5pjkodUoI=;
        b=RWJiPGInW1/Dv2zvRqKplP9cHxC7wJsl9b/aWZxzv6K89vwV7++KLqiJgTz2yiYRey
         wmwvtW3A1mVnXPpRYbvkGNTsozI+FElvQmk3rNGcKFCM2/Zl+IrDNzuZIV2Vlm3W7+n/
         aNeZr6R35DzE3HhdOBHKXYkGH9q7N85W5td19k4xgUfMDDxl+YS6KKgGlvfW1BQlIPmp
         fbfHtYMPZojHe45YbTfnUSJ25dpf43cxtLeYTTRMFQkUXGYu18+1qXiz4dhyjrBIDENh
         BkGWiSNVaizPjisCwTGIbbrzLmY1CwPqeEGhN97F8skbPGi6pvINU1yjyziIxuoq7+54
         zv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cX3xXKs6dY9rUympwY4HzO2/TpWowjrtyd5pjkodUoI=;
        b=C8Y3V6Lx3Cy1PdUaW7UFwSnGa9gTBAkHyPHR90O89LbPYAZgciBFXqo/pSsO/Y9j/6
         y5IROuHsDhSkacjzmmZzF1PLErYgtTor/9TLBxntqQtDkVruoRGpp58P2DA1wulPe/Lo
         U1R38HoewrEXkjk41sx/MD0zaPpbEyYLZIiOKHv3qK2c/sSJynpLM3s1+wS0CqTZEDuW
         lA6dql0TRblsM6GA6wnfC2ih05PszreLDm5vwKx2IQVfSMRxkq8gX5tnVTRv13mTskqA
         OaXwjtQt20F94t+JpIWrZnU0CtU+9nDZyb+ApNup7T/nvKPHZrrebUME7KM1/tkk+N/b
         jI0g==
X-Gm-Message-State: APjAAAVEG6xrqqvYu1zGwZXoz+XusUrdolhwEXY81dO9+mBLfTkaCUfT
        Yb1ZFt538uq83do+Zn9mk2lURg==
X-Google-Smtp-Source: APXvYqyuK9whaXRg8EzSbdC1U1jucBQ/F4J6gF7ZD3MW7MxMdRMbvdts4rfOip0j4g0PEdgQEQ5ysw==
X-Received: by 2002:a05:600c:10d2:: with SMTP id l18mr14885575wmd.122.1582447999741;
        Sun, 23 Feb 2020 00:53:19 -0800 (PST)
Received: from [10.80.2.221] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id d204sm12144409wmd.30.2020.02.23.00.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 00:53:19 -0800 (PST)
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Expose raw packet pacing APIs
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Alex Rosenbaum <rosenbaumalex@gmail.com>
References: <20200219190518.200912-1-leon@kernel.org>
 <20200219190518.200912-2-leon@kernel.org>
 <ea7589ad4d3f847f49e4b4f230cdc130ed4b83a8.camel@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <449186ce-c66f-a762-24c3-139c4ced3b1c@dev.mellanox.co.il>
Date:   Sun, 23 Feb 2020 10:53:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <ea7589ad4d3f847f49e4b4f230cdc130ed4b83a8.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/2020 9:04 PM, Saeed Mahameed wrote:
> On Wed, 2020-02-19 at 21:05 +0200, Leon Romanovsky wrote:
>> From: Yishai Hadas <yishaih@mellanox.com>
>>
>> Expose raw packet pacing APIs to be used by DEVX based applications.
>> The existing code was refactored to have a single flow with the new
>> raw
>> APIs.
>>
>> The new raw APIs considered the input of 'pp_rate_limit_context',
>> uid,
>> 'dedicated', upon looking for an existing entry.
>>
>> This raw mode enables future device specification data in the raw
>> context without changing the existing logic and code.
>>
>> The ability to ask for a dedicated entry gives control for
>> application
>> to allocate entries according to its needs.
>>
>> A dedicated entry may not be used by some other process and it also
>> enables the process spreading its resources to some different entries
>> for use different hardware resources as part of enforcing the rate.
>>
> 
> It sounds like the dedicated means "no sharing" which means you don't
> need to use the mlx5_core API and you can go directly to FW.. The
> problem is that the entry indices are managed by driver, and i guess
> this is the reason why you had to expand the mlx5_core API..
> 

The main reason for introducing the new mlx5_core APIs was the need to 
support the "shared mode" in a "raw data" format to prevent future 
touching the kernel once PRM will support extra fields.
As the RL indices are managed by the driver (mlx5_core) including the 
sharing, we couldn’t go directly to FW, the legacy API was refactored 
inside the core to have one flow with the new raw APIs.
So we may need those APIs regardless the dedicated mode.


> I would like to suggest some alternatives to simplify the approach and
> allow using RAW PRM for DEVX properly.
> 
> 1. preserve RL entries for DEVX and let DEVX access FW directly with
> PRM commands.
> 2. keep mlx5_core API simple and instead of adding this raw/non raw api
> and complicating the RL API with this dedicated bit:
> 
> just add mlx5_rl_{alloc/free}_index(), this will dedicate for you the
> RL index form the end of the RL indices database and you are free to
> access the FW with this index the way you like via direct PRM commands.
> 
As mentioned above, we may still need the new mlx5_core raw APIs for the 
shared mode which is the main usage of the API, we found it reasonable 
to have the dedicate flag in the new raw alloc API instead of exposing 
more two new APIs only for that.

Please note that even if we'll go with those 2 extra APIs for the 
dedicated mode, we may still need to maintain in the core this 
information to prevent returning this entry for other cases.

Also the idea to preserve some entries at the end might be wasteful as 
there is no guarantee that DEVX will really be used, and even so it may 
not ask for entries in a dedicated mode.

Presering them for this optional use case might prevent using them for 
all other cases.


>> The counter per entry mas changed to be u64 to prevent any option to
>                     typo ^^^ was

Sure, thanks.

> 
>> overflow.
>>
>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/rl.c | 130 ++++++++++++++---
>> --
>>   include/linux/mlx5/driver.h                  |  11 +-
>>   include/linux/mlx5/mlx5_ifc.h                |  26 ++--
>>   3 files changed, 122 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
>> index 01c380425f9d..f3b29d9ade1f 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
>> @@ -101,22 +101,39 @@ int mlx5_destroy_scheduling_element_cmd(struct
>> mlx5_core_dev *dev, u8 hierarchy,
>>   	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
>>   }
>>   
>> +static bool mlx5_rl_are_equal_raw(struct mlx5_rl_entry *entry, void
>> *rl_in,
>> +				  u16 uid)
>> +{
>> +	return (!memcmp(entry->rl_raw, rl_in, sizeof(entry->rl_raw)) &&
>> +		entry->uid == uid);
>> +}
>> +
>>   /* Finds an entry where we can register the given rate
>>    * If the rate already exists, return the entry where it is
>> registered,
>>    * otherwise return the first available entry.
>>    * If the table is full, return NULL
>>    */
>>   static struct mlx5_rl_entry *find_rl_entry(struct mlx5_rl_table
>> *table,
>> -					   struct mlx5_rate_limit *rl)
>> +					   void *rl_in, u16 uid, bool
>> dedicated)
>>   {
>>   	struct mlx5_rl_entry *ret_entry = NULL;
>>   	bool empty_found = false;
>>   	int i;
>>   
>>   	for (i = 0; i < table->max_size; i++) {
>> -		if (mlx5_rl_are_equal(&table->rl_entry[i].rl, rl))
>> -			return &table->rl_entry[i];
>> -		if (!empty_found && !table->rl_entry[i].rl.rate) {
>> +		if (dedicated) {
>> +			if (!table->rl_entry[i].refcount)
>> +				return &table->rl_entry[i];
>> +			continue;
>> +		}
>> +
>> +		if (table->rl_entry[i].refcount) {
>> +			if (table->rl_entry[i].dedicated)
>> +				continue;
>> +			if (mlx5_rl_are_equal_raw(&table->rl_entry[i],
>> rl_in,
>> +						  uid))
>> +				return &table->rl_entry[i];
>> +		} else if (!empty_found) {
>>   			empty_found = true;
>>   			ret_entry = &table->rl_entry[i];
>>   		}
>> @@ -126,18 +143,19 @@ static struct mlx5_rl_entry
>> *find_rl_entry(struct mlx5_rl_table *table,
>>   }
>>   
>>   static int mlx5_set_pp_rate_limit_cmd(struct mlx5_core_dev *dev,
>> -				      u16 index,
>> -				      struct mlx5_rate_limit *rl)
>> +				      struct mlx5_rl_entry *entry, bool
>> set)
>>   {
>> -	u32 in[MLX5_ST_SZ_DW(set_pp_rate_limit_in)]   = {0};
>> -	u32 out[MLX5_ST_SZ_DW(set_pp_rate_limit_out)] = {0};
>> +	u32 in[MLX5_ST_SZ_DW(set_pp_rate_limit_in)]   = {};
>> +	u32 out[MLX5_ST_SZ_DW(set_pp_rate_limit_out)] = {};
>> +	void *pp_context;
>>   
>> +	pp_context = MLX5_ADDR_OF(set_pp_rate_limit_in, in, ctx);
>>   	MLX5_SET(set_pp_rate_limit_in, in, opcode,
>>   		 MLX5_CMD_OP_SET_PP_RATE_LIMIT);
>> -	MLX5_SET(set_pp_rate_limit_in, in, rate_limit_index, index);
>> -	MLX5_SET(set_pp_rate_limit_in, in, rate_limit, rl->rate);
>> -	MLX5_SET(set_pp_rate_limit_in, in, burst_upper_bound, rl-
>>> max_burst_sz);
>> -	MLX5_SET(set_pp_rate_limit_in, in, typical_packet_size, rl-
>>> typical_pkt_sz);
>> +	MLX5_SET(set_pp_rate_limit_in, in, uid, entry->uid);
>> +	MLX5_SET(set_pp_rate_limit_in, in, rate_limit_index, entry-
>>> index);
>> +	if (set)
>> +		memcpy(pp_context, entry->rl_raw, sizeof(entry-
>>> rl_raw));
>>   	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
>>   }
>>   
>> @@ -158,23 +176,25 @@ bool mlx5_rl_are_equal(struct mlx5_rate_limit
>> *rl_0,
>>   }
>>   EXPORT_SYMBOL(mlx5_rl_are_equal);
>>   
>> -int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
>> -		     struct mlx5_rate_limit *rl)
>> +int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16
>> uid,
>> +			 bool dedicated_entry, u16 *index)
>>   {
>>   	struct mlx5_rl_table *table = &dev->priv.rl_table;
>>   	struct mlx5_rl_entry *entry;
>>   	int err = 0;
>> +	u32 rate;
>>   
>> +	rate = MLX5_GET(set_pp_rate_limit_context, rl_in, rate_limit);
>>   	mutex_lock(&table->rl_lock);
>>   
>> -	if (!rl->rate || !mlx5_rl_is_in_range(dev, rl->rate)) {
>> +	if (!rate || !mlx5_rl_is_in_range(dev, rate)) {
>>   		mlx5_core_err(dev, "Invalid rate: %u, should be %u to
>> %u\n",
>> -			      rl->rate, table->min_rate, table-
>>> max_rate);
>> +			      rate, table->min_rate, table->max_rate);
>>   		err = -EINVAL;
>>   		goto out;
>>   	}
>>   
>> -	entry = find_rl_entry(table, rl);
>> +	entry = find_rl_entry(table, rl_in, uid, dedicated_entry);
>>   	if (!entry) {
>>   		mlx5_core_err(dev, "Max number of %u rates reached\n",
>>   			      table->max_size);
>> @@ -185,16 +205,24 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev,
>> u16 *index,
>>   		/* rate already configured */
>>   		entry->refcount++;
>>   	} else {
>> +		memcpy(entry->rl_raw, rl_in, sizeof(entry->rl_raw));
>> +		entry->uid = uid;
>>   		/* new rate limit */
>> -		err = mlx5_set_pp_rate_limit_cmd(dev, entry->index,
>> rl);
>> +		err = mlx5_set_pp_rate_limit_cmd(dev, entry, true);
>>   		if (err) {
>> -			mlx5_core_err(dev, "Failed configuring rate
>> limit(err %d): rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
>> -				      err, rl->rate, rl->max_burst_sz,
>> -				      rl->typical_pkt_sz);
>> +			mlx5_core_err(
>> +				dev,
>> +				"Failed configuring rate limit(err %d):
>> rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
>> +				err, rate,
>> +				MLX5_GET(set_pp_rate_limit_context,
>> rl_in,
>> +					 burst_upper_bound),
>> +				MLX5_GET(set_pp_rate_limit_context,
>> rl_in,
>> +					 typical_packet_size));
>>   			goto out;
>>   		}
>> -		entry->rl = *rl;
>> +
>>   		entry->refcount = 1;
>> +		entry->dedicated = dedicated_entry;
>>   	}
>>   	*index = entry->index;
>>   
>> @@ -202,20 +230,61 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev,
>> u16 *index,
>>   	mutex_unlock(&table->rl_lock);
>>   	return err;
>>   }
>> +EXPORT_SYMBOL(mlx5_rl_add_rate_raw);
>> +
>> +void mlx5_rl_remove_rate_raw(struct mlx5_core_dev *dev, u16 index)
>> +{
>> +	struct mlx5_rl_table *table = &dev->priv.rl_table;
>> +	struct mlx5_rl_entry *entry;
>> +
>> +	mutex_lock(&table->rl_lock);
>> +	entry = &table->rl_entry[index - 1];
>> +	entry->refcount--;
>> +	if (!entry->refcount)
>> +		/* need to remove rate */
>> +		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
>> +	mutex_unlock(&table->rl_lock);
>> +}
>> +EXPORT_SYMBOL(mlx5_rl_remove_rate_raw);
>> +
>> +int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
>> +		     struct mlx5_rate_limit *rl)
>> +{
>> +	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
>> +
>> +	MLX5_SET(set_pp_rate_limit_context, rl_raw, rate_limit, rl-
>>> rate);
>> +	MLX5_SET(set_pp_rate_limit_context, rl_raw, burst_upper_bound,
>> +		 rl->max_burst_sz);
>> +	MLX5_SET(set_pp_rate_limit_context, rl_raw,
>> typical_packet_size,
>> +		 rl->typical_pkt_sz);
>> +
>> +	return mlx5_rl_add_rate_raw(dev, rl_raw,
>> +				    MLX5_CAP_QOS(dev,
>> packet_pacing_uid) ?
>> +					MLX5_SHARED_RESOURCE_UID : 0,
>> +				    false, index);
>> +}
>>   EXPORT_SYMBOL(mlx5_rl_add_rate);
>>   
>>   void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct
>> mlx5_rate_limit *rl)
>>   {
>> +	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
>>   	struct mlx5_rl_table *table = &dev->priv.rl_table;
>>   	struct mlx5_rl_entry *entry = NULL;
>> -	struct mlx5_rate_limit reset_rl = {0};
>>   
>>   	/* 0 is a reserved value for unlimited rate */
>>   	if (rl->rate == 0)
>>   		return;
>>   
>> +	MLX5_SET(set_pp_rate_limit_context, rl_raw, rate_limit, rl-
>>> rate);
>> +	MLX5_SET(set_pp_rate_limit_context, rl_raw, burst_upper_bound,
>> +		 rl->max_burst_sz);
>> +	MLX5_SET(set_pp_rate_limit_context, rl_raw,
>> typical_packet_size,
>> +		 rl->typical_pkt_sz);
>> +
>>   	mutex_lock(&table->rl_lock);
>> -	entry = find_rl_entry(table, rl);
>> +	entry = find_rl_entry(table, rl_raw,
>> +			      MLX5_CAP_QOS(dev, packet_pacing_uid) ?
>> +				MLX5_SHARED_RESOURCE_UID : 0, false);
>>   	if (!entry || !entry->refcount) {
>>   		mlx5_core_warn(dev, "Rate %u, max_burst_sz %u
>> typical_pkt_sz %u are not configured\n",
>>   			       rl->rate, rl->max_burst_sz, rl-
>>> typical_pkt_sz);
>> @@ -223,11 +292,9 @@ void mlx5_rl_remove_rate(struct mlx5_core_dev
>> *dev, struct mlx5_rate_limit *rl)
>>   	}
>>   
>>   	entry->refcount--;
>> -	if (!entry->refcount) {
>> +	if (!entry->refcount)
>>   		/* need to remove rate */
>> -		mlx5_set_pp_rate_limit_cmd(dev, entry->index,
>> &reset_rl);
>> -		entry->rl = reset_rl;
>> -	}
>> +		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
>>   
>>   out:
>>   	mutex_unlock(&table->rl_lock);
>> @@ -273,14 +340,13 @@ int mlx5_init_rl_table(struct mlx5_core_dev
>> *dev)
>>   void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev)
>>   {
>>   	struct mlx5_rl_table *table = &dev->priv.rl_table;
>> -	struct mlx5_rate_limit rl = {0};
>>   	int i;
>>   
>>   	/* Clear all configured rates */
>>   	for (i = 0; i < table->max_size; i++)
>> -		if (table->rl_entry[i].rl.rate)
>> -			mlx5_set_pp_rate_limit_cmd(dev, table-
>>> rl_entry[i].index,
>> -						   &rl);
>> +		if (table->rl_entry[i].refcount)
>> +			mlx5_set_pp_rate_limit_cmd(dev, &table-
>>> rl_entry[i],
>> +						   false);
>>   
>>   	kfree(dev->priv.rl_table.rl_entry);
>>   }
>> diff --git a/include/linux/mlx5/driver.h
>> b/include/linux/mlx5/driver.h
>> index 277a51d3ec40..f2b4225ed650 100644
>> --- a/include/linux/mlx5/driver.h
>> +++ b/include/linux/mlx5/driver.h
>> @@ -518,9 +518,11 @@ struct mlx5_rate_limit {
>>   };
>>   
>>   struct mlx5_rl_entry {
>> -	struct mlx5_rate_limit	rl;
>> -	u16                     index;
>> -	u16                     refcount;
>> +	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)];
>> +	u16 index;
>> +	u64 refcount;
>> +	u16 uid;
>> +	u8 dedicated : 1;
>>   };
>>   
>>   struct mlx5_rl_table {
>> @@ -1007,6 +1009,9 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev,
>> u16 *index,
>>   		     struct mlx5_rate_limit *rl);
>>   void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct
>> mlx5_rate_limit *rl);
>>   bool mlx5_rl_is_in_range(struct mlx5_core_dev *dev, u32 rate);
>> +int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16
>> uid,
>> +			 bool dedicated_entry, u16 *index);
>> +void mlx5_rl_remove_rate_raw(struct mlx5_core_dev *dev, u16 index);
>>   bool mlx5_rl_are_equal(struct mlx5_rate_limit *rl_0,
>>   		       struct mlx5_rate_limit *rl_1);
>>   int mlx5_alloc_bfreg(struct mlx5_core_dev *mdev, struct
>> mlx5_sq_bfreg *bfreg,
>> diff --git a/include/linux/mlx5/mlx5_ifc.h
>> b/include/linux/mlx5/mlx5_ifc.h
>> index ff8c9d527bb4..7d89ab64b372 100644
>> --- a/include/linux/mlx5/mlx5_ifc.h
>> +++ b/include/linux/mlx5/mlx5_ifc.h
>> @@ -810,7 +810,9 @@ struct mlx5_ifc_qos_cap_bits {
>>   	u8         reserved_at_4[0x1];
>>   	u8         packet_pacing_burst_bound[0x1];
>>   	u8         packet_pacing_typical_size[0x1];
>> -	u8         reserved_at_7[0x19];
>> +	u8         reserved_at_7[0x4];
>> +	u8         packet_pacing_uid[0x1];
>> +	u8         reserved_at_c[0x14];
>>   
>>   	u8         reserved_at_20[0x20];
>>   
>> @@ -8262,9 +8264,20 @@ struct mlx5_ifc_set_pp_rate_limit_out_bits {
>>   	u8         reserved_at_40[0x40];
>>   };
>>   
>> +struct mlx5_ifc_set_pp_rate_limit_context_bits {
>> +	u8         rate_limit[0x20];
>> +
>> +	u8	   burst_upper_bound[0x20];
>> +
>> +	u8         reserved_at_40[0x10];
>> +	u8	   typical_packet_size[0x10];
>> +
>> +	u8         reserved_at_60[0x120];
>> +};
>> +
>>   struct mlx5_ifc_set_pp_rate_limit_in_bits {
>>   	u8         opcode[0x10];
>> -	u8         reserved_at_10[0x10];
>> +	u8         uid[0x10];
>>   
>>   	u8         reserved_at_20[0x10];
>>   	u8         op_mod[0x10];
>> @@ -8274,14 +8287,7 @@ struct mlx5_ifc_set_pp_rate_limit_in_bits {
>>   
>>   	u8         reserved_at_60[0x20];
>>   
>> -	u8         rate_limit[0x20];
>> -
>> -	u8	   burst_upper_bound[0x20];
>> -
>> -	u8         reserved_at_c0[0x10];
>> -	u8	   typical_packet_size[0x10];
>> -
>> -	u8         reserved_at_e0[0x120];
>> +	struct mlx5_ifc_set_pp_rate_limit_context_bits ctx;
>>   };
>>   
>>   struct mlx5_ifc_access_register_out_bits {

