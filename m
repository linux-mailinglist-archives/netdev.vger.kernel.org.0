Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7335816DE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiGZP6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGZP6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:58:05 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A1B2C12F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:58:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p5so7245070edi.12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9za1md9n7GmnbS9IQi5Nu2LQq3whK37aNJoOw4ZDqyg=;
        b=J2pIU+9zzS1iAivMh/2fHmXyg3/0zxUsfLGRX6kv4xgjbQh1RrTXwbDG0HFGKZxaql
         vRDMV31WNy02u7Vm/kmCksiL0HYwAne/gMH0n64Qjha3hj2BPnDCe0W29hlAxu3yCLfN
         X+HFX6ylKGftU/AcFgbUCkRbfPlzQWtI9hztCiJrfNfBxitRURD67o0mueCyLYNNXt2d
         fviui1MOqd/EW0o8pi8WWNRUs2Jrsgt/7MylFO++0dB6q3OysFFXeKR9yUuwFkJ01mbe
         o5sdgPCpfdrvYFiQfRyEB0Unp0Z7ppRp2YWkGRDX01dFBhuXwpInOs8Smt4TGXyouzyT
         UAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9za1md9n7GmnbS9IQi5Nu2LQq3whK37aNJoOw4ZDqyg=;
        b=RBLBl+qoUvCyEVdvp0SS4TPX9nU5RJwGCvF/9YZSe3Btec/TfL787zSVXNy45kEiU8
         CmGUOL+n4A746gV5N76elm1iqMF6gAAJcUZTcmV2SvWIC91rq9txL/S4awxc+QKIwsqh
         hZHvIUL6lRrlPCMJKLWvo64fFrDw2IgM100USGeHwWBZsYfT8xfhp8bjryZyE6x2VjeR
         9PbqMQhH6PV5p6dVHFolm/qNO1Pyog2rVfj9Q3vCbAxJuLWhdFVWj/qarxld//+qQgSN
         MHcO9ALMP3q9txYSeNWULJJR/GsO4sb8R3ExL0p2QpsbdxdDJhXV3WvZK53UwCck4Rpd
         MToQ==
X-Gm-Message-State: AJIora+CfyeH01yo1AZ8I3IAfj3pTe5XvzkVaYYptevfWaSfVhcTjSX+
        IuW8ACt0Ofc5qwP33jF0l0gUD3rXUIVnWR57mk0=
X-Google-Smtp-Source: AGRyM1t0HkNAYcA+bwLOYyQljuyW0rbwdtsN4J7UI5WkZKSzEKoLwno/pTeU27FrLRSHXoIX4iv3VQ==
X-Received: by 2002:a05:6402:ea9:b0:43b:b88f:62fe with SMTP id h41-20020a0564020ea900b0043bb88f62femr18306527eda.85.1658851081114;
        Tue, 26 Jul 2022 08:58:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id sd22-20020a170906ce3600b006fe8b456672sm6440746ejb.3.2022.07.26.08.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 08:58:00 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:57:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <YuAPBwaOjjQBTc6V@nanopsycho>
References: <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <20220726152059.bls6gn7ludfutamy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726152059.bls6gn7ludfutamy@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 26, 2022 at 05:20:59PM CEST, olteanv@gmail.com wrote:
>On Tue, Jul 26, 2022 at 04:45:44PM +0200, Jiri Pirko wrote:
>> Oh yes, could you please try together with following patch? (nevermind
>> chicken-egg problem you may spot now)
>
>Duly ignoring ;)
>
>> Subject: [patch net-next RFC] net: devlink: convert region creation/destroy()
>>  to be forbidden on registered devlink/port
>> 
>> No need to create or destroy region when devlink or devlink ports are
>> registered. Limit the possibility to call the region create/destroy()
>> only for non-registered devlink or devlink port. Benefit from that and
>> avoid need to take devl_lock.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  drivers/net/netdevsim/dev.c |  8 ++--
>>  include/net/devlink.h       |  5 ---
>>  net/core/devlink.c          | 78 ++++++++-----------------------------
>>  3 files changed, 20 insertions(+), 71 deletions(-)
>> 
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index 925dc8a5254d..3f0c19e30650 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -557,15 +557,15 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
>>  				      struct devlink *devlink)
>>  {
>>  	nsim_dev->dummy_region =
>> -		devl_region_create(devlink, &dummy_region_ops,
>> -				   NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
>> -				   NSIM_DEV_DUMMY_REGION_SIZE);
>> +		devlink_region_create(devlink, &dummy_region_ops,
>> +				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
>> +				      NSIM_DEV_DUMMY_REGION_SIZE);
>>  	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
>>  }
>>  
>>  static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
>>  {
>> -	devl_region_destroy(nsim_dev->dummy_region);
>> +	devlink_region_destroy(nsim_dev->dummy_region);
>>  }
>>  
>>  static int
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 9edb4a28cf30..2416750e050d 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -1666,10 +1666,6 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
>>  int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
>>  				       union devlink_param_value init_val);
>>  void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
>> -struct devlink_region *devl_region_create(struct devlink *devlink,
>> -					  const struct devlink_region_ops *ops,
>> -					  u32 region_max_snapshots,
>> -					  u64 region_size);
>>  struct devlink_region *
>>  devlink_region_create(struct devlink *devlink,
>>  		      const struct devlink_region_ops *ops,
>> @@ -1678,7 +1674,6 @@ struct devlink_region *
>>  devlink_port_region_create(struct devlink_port *port,
>>  			   const struct devlink_port_region_ops *ops,
>>  			   u32 region_max_snapshots, u64 region_size);
>> -void devl_region_destroy(struct devlink_region *region);
>>  void devlink_region_destroy(struct devlink_region *region);
>>  void devlink_port_region_destroy(struct devlink_region *region);
>>  
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 4e0c4f9265e8..15d28aba69fc 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -5701,8 +5701,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
>>  	struct sk_buff *msg;
>>  
>>  	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
>> -	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
>> -		return;
>> +	ASSERT_DEVLINK_REGISTERED(devlink);
>>  
>>  	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
>>  	if (IS_ERR(msg))
>> @@ -11131,21 +11130,22 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
>>  EXPORT_SYMBOL_GPL(devlink_param_value_changed);
>>  
>>  /**
>> - * devl_region_create - create a new address region
>> + * devlink_region_create - create a new address region
>>   *
>>   * @devlink: devlink
>>   * @ops: region operations and name
>>   * @region_max_snapshots: Maximum supported number of snapshots for region
>>   * @region_size: size of region
>>   */
>> -struct devlink_region *devl_region_create(struct devlink *devlink,
>> -					  const struct devlink_region_ops *ops,
>> -					  u32 region_max_snapshots,
>> -					  u64 region_size)
>> +struct devlink_region *
>> +devlink_region_create(struct devlink *devlink,
>> +		      const struct devlink_region_ops *ops,
>> +		      u32 region_max_snapshots,
>> +		      u64 region_size)
>>  {
>>  	struct devlink_region *region;
>>  
>> -	devl_assert_locked(devlink);
>> +	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
>>  
>>  	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
>>  		return ERR_PTR(-EINVAL);
>> @@ -11164,35 +11164,9 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
>>  	INIT_LIST_HEAD(&region->snapshot_list);
>>  	mutex_init(&region->snapshot_lock);
>>  	list_add_tail(&region->list, &devlink->region_list);
>> -	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
>>  
>>  	return region;
>>  }
>> -EXPORT_SYMBOL_GPL(devl_region_create);
>> -
>> -/**
>> - *	devlink_region_create - create a new address region
>> - *
>> - *	@devlink: devlink
>> - *	@ops: region operations and name
>> - *	@region_max_snapshots: Maximum supported number of snapshots for region
>> - *	@region_size: size of region
>> - *
>> - *	Context: Takes and release devlink->lock <mutex>.
>> - */
>> -struct devlink_region *
>> -devlink_region_create(struct devlink *devlink,
>> -		      const struct devlink_region_ops *ops,
>> -		      u32 region_max_snapshots, u64 region_size)
>> -{
>> -	struct devlink_region *region;
>> -
>> -	devl_lock(devlink);
>> -	region = devl_region_create(devlink, ops, region_max_snapshots,
>> -				    region_size);
>> -	devl_unlock(devlink);
>> -	return region;
>> -}
>>  EXPORT_SYMBOL_GPL(devlink_region_create);
>>  
>>  /**
>
>Were you on net-next when you generated this patch? Here's what I have
>at 11164:
>
>devlink_port_region_create:
>	if (devlink_port_region_get_by_name(port, ops->name)) {
>		err = -EEXIST;
>		goto unlock;
>	}
>
>	region = kzalloc(sizeof(*region), GFP_KERNEL);
>	if (!region) {
>
>My end of devl_region_create() and start of devlink_region_create() are
>at 11106, but notice how I lack the mutex_init(&region->snapshot_lock)
>that you have in your context:
>
>	INIT_LIST_HEAD(&region->snapshot_list);
>	list_add_tail(&region->list, &devlink->region_list);
>	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
>
>	return region;
>}
>EXPORT_SYMBOL_GPL(devl_region_create);
>
>Would you mind regenerating this patch rather than letting me bodge it?

Darn, wait. I will fixup a squash for you. Sorry.

