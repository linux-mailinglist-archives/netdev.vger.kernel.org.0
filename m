Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88921693F0F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBMHos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 02:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjBMHor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 02:44:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C44E3B3
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 23:44:44 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qb15so27556740ejc.1
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 23:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6qKvOTH3CpP3hOVUmUrvZkZGyuqoJWDuTirGrS1O7sw=;
        b=xus+HaN8ZLVLaSRcyuq74MLpiP2UZXhhZUZQ0JV4Yyq1Zk0QdLnjywd8LsOl9hNMHH
         ZDKP/8IU5E3GwzIs0Dhwq+HM1rQyw9eJpcvdX+g/DajTFqAsY5IkgkMYm2yBXLmnTcwD
         7KHo13ECSWBqrpwbLbVLstPzQVi5StmvjSXa6R3M1IYh5XreC4TigvkZcF/cIEJyykw1
         V1Ea6EoqCw294uRzyEA4jgAxgGDwR0iF4nk16kcmtSjW0/xKF/X/B/fzpAospXAsbCOz
         wzEJh3Z9p2S+wYOePgi13Jfz8/1p6MknoEBuGbxJSuFor0cyNkhdnZ5elqSxTUn6KkEe
         t9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qKvOTH3CpP3hOVUmUrvZkZGyuqoJWDuTirGrS1O7sw=;
        b=LlW4YtDuhvoi1pv0da1ixEUrM/s1mqR2Y2nAJbGavhYuqx6GEuTr10UxF0zOcHYZ+T
         oxxIaz811vKg+GPYqjq5SRxH9Hol2H2rapunSbkZn9Qt2zjEmMhFyKpCfbuodlSQtzzV
         BRfxGz1h9V9EdO2Ng7KoYjIJ7LxlDg57/zKMKb7ox5zIiJPsZBfGpmyWFxmawDjnxhQW
         PUbJvD/cKIED0FrD6ciAmthS5qw/QF9l+3UFKp2rwsfxVHb3xUtpP2Qa02IptTpHstSi
         kcURJV09GCwEmjWfvkmSpJmMWv+/v8mvWDd0kOA6gLf+nDpoxukmaRfuhos7ZLE7S1zY
         Kfxw==
X-Gm-Message-State: AO0yUKWu6WpL0hvbhTfuJjyVe7A6WjkkRnYPvM6+e141Dt+oeE/fNitK
        bAfqhRS8zZ5mRattcoINRLCB0A==
X-Google-Smtp-Source: AK7set8xIVj+nzju80mhkjLYxMVSx0NpZ7cwhxYCJDoXwdYuOgoxuJhBzDsn/ZPL50FbyMsycBuCOA==
X-Received: by 2002:a17:906:f1c1:b0:7c1:458b:a947 with SMTP id gx1-20020a170906f1c100b007c1458ba947mr26417799ejb.26.1676274282628;
        Sun, 12 Feb 2023 23:44:42 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r14-20020a170906364e00b0088351ea808bsm6407757ejb.46.2023.02.12.23.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 23:44:41 -0800 (PST)
Date:   Mon, 13 Feb 2023 08:44:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: Re: [patch net-next v2 6/7] devlink: allow to call
 devl_param_driverinit_value_get() without holding instance lock
Message-ID: <Y+nqaCfvcbXy0AnN@nanopsycho>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-7-jiri@resnulli.us>
 <0a24ce1e-f918-338a-881f-fef2681b250c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a24ce1e-f918-338a-881f-fef2681b250c@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 10, 2023 at 08:41:27PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 2/10/2023 2:01 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> If the driver maintains following basic sane behavior, the
>> devl_param_driverinit_value_get() function could be called without
>> holding instance lock:
>> 
>> 1) Driver ensures a call to devl_param_driverinit_value_get() cannot
>>    race with registering/unregistering the parameter with
>>    the same parameter ID.
>> 2) Driver ensures a call to devl_param_driverinit_value_get() cannot
>>    race with devl_param_driverinit_value_set() call with
>>    the same parameter ID.
>> 3) Driver ensures a call to devl_param_driverinit_value_get() cannot
>>    race with reload operation.
>> 
>> By the nature of params usage, these requirements should be
>> trivially achievable. If the driver for some off reason
>> is not able to comply, it has to take the devlink->lock while
>> calling devl_param_driverinit_value_get().
>> 
>> Remove the lock assertion and add comment describing
>> the locking requirements.
>> 
>> This fixes a splat in mlx5 driver introduced by the commit
>> referenced in the "Fixes" tag.
>
>Just to clarify, is it possible for mlx5 to take the instance lock
>instead of these changes? I agree the improvements make sense here, but
>it seems like an alternative fix would be to grab the lock around the
>get function call in mlx5.

You are correct, yes.

>
>Either way, the assumptions here seem reasonable and the series makes sense.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>
>Thanks,
>Jake
>
>> 
>> Lore: https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/
>> Reported-by: Kim Phillips <kim.phillips@amd.com>
>> Fixes: 075935f0ae0f ("devlink: protect devlink param list by instance lock")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>>  net/devlink/leftover.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>> 
>> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>> index 6d3988f4e843..9f0256c2c323 100644
>> --- a/net/devlink/leftover.c
>> +++ b/net/devlink/leftover.c
>> @@ -9628,14 +9628,23 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
>>   *
>>   *	This function should be used by the driver to get driverinit
>>   *	configuration for initialization after reload command.
>> + *
>> + *	Note that lockless call of this function relies on the
>> + *	driver to maintain following basic sane behavior:
>> + *	1) Driver ensures a call to this function cannot race with
>> + *	   registering/unregistering the parameter with the same parameter ID.
>> + *	2) Driver ensures a call to this function cannot race with
>> + *	   devl_param_driverinit_value_set() call with the same parameter ID.
>> + *	3) Driver ensures a call to this function cannot race with
>> + *	   reload operation.
>> + *	If the driver is not able to comply, it has to take the devlink->lock
>> + *	while calling this.
>>   */
>>  int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
>>  				    union devlink_param_value *val)
>>  {
>>  	struct devlink_param_item *param_item;
>>  
>> -	lockdep_assert_held(&devlink->lock);
>> -
>>  	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
>>  		return -EOPNOTSUPP;
>>  
