Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8157C3D4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 07:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiGUFpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 01:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiGUFpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 01:45:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E323B941
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:45:04 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z13so652946wro.13
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JgC6TnVmaVyI+8cNV6BTelWP6VUulyVDgSI1A3lEhvM=;
        b=bcIWEWouhzkskODa8wRiL7xvL1r79wLwlf1fz/Nm89m4DF3cIkQMsxm7OVl1lufKyn
         xFt14taAd0rDPNUTsCyTswPWaEE7rffWMHaw/FVUYyTXZSXPN1SQg02VhMOpe/H3/we4
         seTvZXBBlNp7R88Ish2mfTKc8dGLPe8VWjlQjrE+4QwKR1CU38eQQmdKo5OpGnFCR/Qy
         yCYIyMtbGRQl4LKbgPvf5Xyz19k/mcFoThZ4Ue7VWy8Gij8WFcqpv2kRNLkXwonBAzKZ
         ZPM8HHCwLQdMrOkSFdAQO+h1kHDdDGtQ5ZRYgY3SrjVzjUqTJmNusJRV/zc0ljDBJUBU
         HYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JgC6TnVmaVyI+8cNV6BTelWP6VUulyVDgSI1A3lEhvM=;
        b=f+iOPRR9Ad7Fa4xLvFSWZYR9IFRQIEjdT6c2bKZFEZhlCYYJMQm9aC2yWkV6ssHkgN
         2v/lVl4m6T88idO0U5nyUyHnc85A8PP4BN82EZLXXHAE5O7UiNmdfpbIYxVPNAjNlGDs
         YBklFYe5YEEfqpoEyly45JqYnJ9pDsYkJeXvHcSL1Md3a6oA69SF5XLosxlwjXHOHRsr
         pr/ALIQzyrB7nDqun5meK5WXitTyvFFUGr7+KKgzTH46hK1z/WWQqerzgbx3ZTPFVF6S
         pVMi5yC+u1lgm0f9ENC+TmywzrIv+oEIkYLcrjCR8Fq2sVwz65kIdp2tvK2vjjknC1RB
         0o4w==
X-Gm-Message-State: AJIora9886oAIjQ9D+7+m1/RtV/WwPn+sfGzqPFs4vETDWEN9mhvLMF0
        2acfsC4a54LTwLYZU+qQrxAHhg==
X-Google-Smtp-Source: AGRyM1tqYpmf0B/oFbVsJztpOjrJgt7GFnzhrGiImn2RER1ankHXRh5pCsEKbosK4R0IJ1qy1DYKFg==
X-Received: by 2002:adf:f588:0:b0:21e:5515:7703 with SMTP id f8-20020adff588000000b0021e55157703mr781289wro.569.1658382302851;
        Wed, 20 Jul 2022 22:45:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b4-20020a05600c150400b003a2fb1224d9sm677130wmg.19.2022.07.20.22.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 22:45:02 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:45:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "snelson@pensando.io" <snelson@pensando.io>
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <Ytjn3H9JsxLsPQ0Z@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <SA2PR11MB510087EB439262BA6DE1E62AD68E9@SA2PR11MB5100.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA2PR11MB510087EB439262BA6DE1E62AD68E9@SA2PR11MB5100.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 12:25:54AM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Wednesday, July 20, 2022 8:12 AM
>> To: netdev@vger.kernel.org
>> Cc: davem@davemloft.net; kuba@kernel.org; idosch@nvidia.com;
>> petrm@nvidia.com; pabeni@redhat.com; edumazet@google.com;
>> mlxsw@nvidia.com; saeedm@nvidia.com; snelson@pensando.io
>> Subject: [patch net-next v3 01/11] net: devlink: make sure that devlink_try_get()
>> works with valid pointer during xarray iteration
>> 
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Remove dependency on devlink_mutex during devlinks xarray iteration.
>> 
>> The reason is that devlink_register/unregister() functions taking
>> devlink_mutex would deadlock during devlink reload operation of devlink
>> instance which registers/unregisters nested devlink instances.
>> 
>> The devlinks xarray consistency is ensured internally by xarray.
>> There is a reference taken when working with devlink using
>> devlink_try_get(). But there is no guarantee that devlink pointer
>> picked during xarray iteration is not freed before devlink_try_get()
>> is called.
>> 
>> Make sure that devlink_try_get() works with valid pointer.
>> Achieve it by:
>> 1) Splitting devlink_put() so the completion is sent only
>>    after grace period. Completion unblocks the devlink_unregister()
>>    routine, which is followed-up by devlink_free()
>> 2) Iterate the devlink xarray holding RCU read lock.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>
>This makes sense as long as its ok to drop the rcu_read_lock while in the body of the xa loops. That feels a bit odd to me...

Yes, it is okay. See my comment below.


>
>> ---
>> v2->v3:
>> - s/enf/end/ in devlink_put() comment
>> - added missing rcu_read_lock() call to info_get_dumpit()
>> - extended patch description by motivation
>> - removed an extra "by" from patch description
>> v1->v2:
>> - new patch (originally part of different patchset)
>> ---
>>  net/core/devlink.c | 114 ++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 96 insertions(+), 18 deletions(-)
>> 
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 98d79feeb3dc..6a3931a8e338 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -70,6 +70,7 @@ struct devlink {
>>  	u8 reload_failed:1;
>>  	refcount_t refcount;
>>  	struct completion comp;
>> +	struct rcu_head rcu;
>>  	char priv[] __aligned(NETDEV_ALIGN);
>>  };
>> 
>> @@ -221,8 +222,6 @@ static DEFINE_XARRAY_FLAGS(devlinks,
>> XA_FLAGS_ALLOC);
>>  /* devlink_mutex
>>   *
>>   * An overall lock guarding every operation coming from userspace.
>> - * It also guards devlink devices list and it is taken when
>> - * driver registers/unregisters it.
>>   */
>>  static DEFINE_MUTEX(devlink_mutex);
>> 
>> @@ -232,10 +231,21 @@ struct net *devlink_net(const struct devlink *devlink)
>>  }
>>  EXPORT_SYMBOL_GPL(devlink_net);
>> 
>> +static void __devlink_put_rcu(struct rcu_head *head)
>> +{
>> +	struct devlink *devlink = container_of(head, struct devlink, rcu);
>> +
>> +	complete(&devlink->comp);
>> +}
>> +
>>  void devlink_put(struct devlink *devlink)
>>  {
>>  	if (refcount_dec_and_test(&devlink->refcount))
>> -		complete(&devlink->comp);
>> +		/* Make sure unregister operation that may await the completion
>> +		 * is unblocked only after all users are after the end of
>> +		 * RCU grace period.
>> +		 */
>> +		call_rcu(&devlink->rcu, __devlink_put_rcu);
>>  }
>> 
>>  struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>> @@ -295,6 +305,7 @@ static struct devlink *devlink_get_from_attrs(struct net
>> *net,
>> 
>>  	lockdep_assert_held(&devlink_mutex);
>> 
>> +	rcu_read_lock();
>>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>>  		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
>>  		    strcmp(dev_name(devlink->dev), devname) == 0 &&
>> @@ -306,6 +317,7 @@ static struct devlink *devlink_get_from_attrs(struct net
>> *net,
>> 
>>  	if (!found || !devlink_try_get(devlink))
>>  		devlink = ERR_PTR(-ENODEV);
>> +	rcu_read_unlock();
>> 
>>  	return devlink;
>>  }
>> @@ -1329,9 +1341,11 @@ static int devlink_nl_cmd_rate_get_dumpit(struct
>> sk_buff *msg,
>>  	int err = 0;
>> 
>>  	mutex_lock(&devlink_mutex);
>> +	rcu_read_lock();
>>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>>  		if (!devlink_try_get(devlink))
>>  			continue;
>> +		rcu_read_unlock();
>> 
>>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>>  			goto retry;
>> @@ -1358,7 +1372,9 @@ static int devlink_nl_cmd_rate_get_dumpit(struct
>> sk_buff *msg,
>>  		devl_unlock(devlink);
>>  retry:
>>  		devlink_put(devlink);
>> +		rcu_read_lock();
>>  	}
>> +	rcu_read_unlock();
>>  out:
>>  	mutex_unlock(&devlink_mutex);
>>  	if (err != -EMSGSIZE)
>> @@ -1432,29 +1448,32 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff
>> *msg,
>>  	int err;
>> 
>>  	mutex_lock(&devlink_mutex);
>> +	rcu_read_lock();
>>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>>  		if (!devlink_try_get(devlink))
>>  			continue;
>> +		rcu_read_unlock();
>> 
>
>Is it safe to rcu_read_unlock here while we're still in the middle of the array processing? What happens if something else updates the xarray? is the for_each_marked safe?

Sure, you don't need to hold rcu_read_lock during call to xa_for_each_marked.
The consistency of xarray is itself guaranteed. The only reason to take
rcu_read_lock outside is that the devlink pointer which is
rcu_dereference_check()'ed inside xa_for_each_marked() is still valid
once we devlink_try_get() it.


>
>> -		if (!net_eq(devlink_net(devlink), sock_net(msg->sk))) {
>> -			devlink_put(devlink);
>> -			continue;
>> -		}
>> +		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>> +			goto retry;
>> 
>
>Ahh retry is at the end of the loop, so we'll just skip this one and move to the next one without needing to duplicate both devlink_put and rcu_read_lock.. ok.

Yep.


>
>> -		if (idx < start) {
>> -			idx++;
>> -			devlink_put(devlink);
>> -			continue;
>> -		}
>> +		if (idx < start)
>> +			goto inc;
>> 
>>  		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
>>  				      NETLINK_CB(cb->skb).portid,
>>  				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
>> -		devlink_put(devlink);
>> -		if (err)
>> +		if (err) {
>> +			devlink_put(devlink);
>>  			goto out;
>> +		}
>> +inc:
>>  		idx++;
>> +retry:
>> +		devlink_put(devlink);
>> +		rcu_read_lock();
>>  	}
>> +	rcu_read_unlock();
>>  out:
>>  	mutex_unlock(&devlink_mutex);
>> 

[...]
