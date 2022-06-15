Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B068F54D01A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348055AbiFORhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348775AbiFORho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:37:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E318B37
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:37:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w17so8811656wrg.7
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8AnuB2xebLnxSE+q0Pj6QVF4mruyvUJwJ4a1GM+J/ko=;
        b=6fJ7XapYG5mbY7pQFD5NpJiwTAqZNkWKZnYIwuSG8Q3qbZzT5zkjDZRhYmRdCpQAnM
         jlLH+c4IvXfNu3SLrkCiv7QqCVyAFkp3UEft+On2zE/4mYjdA85zW8uqQzcX9utWsPzX
         XmVwEMgS5UNNnLuenUBbcFjj0M9ee0tDJByH/bj9oEDAQd+dsMvtKLOB6bKBfbyUbuLE
         2dF+LQ/iSZHy1B22McE/o/JldXULZ96ydBDGOnc5eqR5iBuFQQqgtsJlNpdd8qE1Ry1A
         d1B5ojLXdAZjhQ43N1eFmE2VMrv1usHTAQhm5xpdN0T/3oAFjwdzCXmqcavqzEcGkuuS
         4lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8AnuB2xebLnxSE+q0Pj6QVF4mruyvUJwJ4a1GM+J/ko=;
        b=TvaTShHl9WKgqqmnf5Aj7AeOPK0EoMhMWxrf1oFNqESkgOmMqYvfXRqnmXBaWYbhUq
         9GvEC9xFcjKWPYgBreSajLF53cbSVwscIeSFp6CuFA+AX238GlGmLCGVxx2OsX29pxQM
         iW1nBEResulk1hG2dxaj49Hb6g4qJj3+zj0VWtXVOPIeoXznqUypjlGobyLQ5cQcH1rZ
         Sr1MbSkIwaNEMoRNdEaMTafMoA4my7EPH2DadYZh1jtPs526C/z5TMEppZPYNjxPHnLq
         QEAqQA8vR1SZnZhp8xX0iWBu+q+Ptd18Kk/Whfx9lVBs62durXHqzhel7DzHYtbwn7oj
         GhUg==
X-Gm-Message-State: AJIora85gw0fb3mGs1/YnO5dVkfX7tplKbCTBEwHBOX9zsxFUcMBXkEm
        DwSFrfqJteV/4rBHvHT+MYmvlA==
X-Google-Smtp-Source: AGRyM1s7FBb6A3AwWYn28uu9xPybPHNkBD53ZadW4qTP5sJVwCNmEvdcNldCEfSmVZcVG9wzF9zDcw==
X-Received: by 2002:adf:fe52:0:b0:210:12ab:76e6 with SMTP id m18-20020adffe52000000b0021012ab76e6mr910773wrs.120.1655314658955;
        Wed, 15 Jun 2022 10:37:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w15-20020a1cf60f000000b0039747cf8354sm3113331wmc.39.2022.06.15.10.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 10:37:38 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:37:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 01/11] devlink: introduce nested devlink entity
 for line card
Message-ID: <YqoY4cFRk1OpInw+@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-2-jiri@resnulli.us>
 <YqnnGR7mbB8RCDnH@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqnnGR7mbB8RCDnH@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 15, 2022 at 04:05:13PM CEST, idosch@nvidia.com wrote:
>On Tue, Jun 14, 2022 at 02:33:16PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> For the purpose of exposing device info and allow flash updated which is
>
>s/updated/update/
>
>> going to be implemented in follow-up patches, introduce a possibility
>> for a line card to expose relation to nested devlink entity. The nested
>> devlink entity represents the line card.
>> 
>> Example:
>> 
>> $ devlink lc show pci/0000:01:00.0 lc 1
>> pci/0000:01:00.0:
>>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>>     supported_types:
>>        16x100G
>> $ devlink dev show auxiliary/mlxsw_core.lc.0
>> auxiliary/mlxsw_core.lc.0
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  include/net/devlink.h        |  2 ++
>>  include/uapi/linux/devlink.h |  2 ++
>>  net/core/devlink.c           | 42 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 46 insertions(+)
>> 
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 2a2a2a0c93f7..83e62943e1d4 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -1584,6 +1584,8 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
>>  void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
>>  void devlink_linecard_activate(struct devlink_linecard *linecard);
>>  void devlink_linecard_deactivate(struct devlink_linecard *linecard);
>> +void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
>> +				    struct devlink *nested_devlink);
>>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>>  			u32 size, u16 ingress_pools_count,
>>  			u16 egress_pools_count, u16 ingress_tc_count,
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index b3d40a5d72ff..541321695f52 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -576,6 +576,8 @@ enum devlink_attr {
>>  	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>>  	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>>  
>> +	DEVLINK_ATTR_NESTED_DEVLINK,		/* nested */
>> +
>>  	/* add new attributes above here, update the policy in devlink.c */
>>  
>>  	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index db61f3a341cb..a5953cfe1baa 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -87,6 +87,7 @@ struct devlink_linecard {
>>  	const char *type;
>>  	struct devlink_linecard_type *types;
>>  	unsigned int types_count;
>> +	struct devlink *nested_devlink;
>>  };
>>  
>>  /**
>> @@ -796,6 +797,24 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
>>  	return 0;
>>  }
>>  
>> +static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *devlink)
>> +{
>> +	struct nlattr *nested_attr;
>> +
>> +	nested_attr = nla_nest_start(msg, DEVLINK_ATTR_NESTED_DEVLINK);
>> +	if (!nested_attr)
>> +		return -EMSGSIZE;
>> +	if (devlink_nl_put_handle(msg, devlink))
>> +		goto nla_put_failure;
>> +
>> +	nla_nest_end(msg, nested_attr);
>> +	return 0;
>> +
>> +nla_put_failure:
>> +	nla_nest_cancel(msg, nested_attr);
>> +	return -EMSGSIZE;
>> +}
>> +
>>  struct devlink_reload_combination {
>>  	enum devlink_reload_action action;
>>  	enum devlink_reload_limit limit;
>> @@ -2100,6 +2119,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
>>  		nla_nest_end(msg, attr);
>>  	}
>>  
>> +	if (linecard->nested_devlink &&
>> +	    devlink_nl_put_nested_handle(msg, linecard->nested_devlink))
>> +		goto nla_put_failure;
>> +
>>  	genlmsg_end(msg, hdr);
>>  	return 0;
>>  
>> @@ -10335,6 +10358,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
>>  void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
>>  {
>>  	mutex_lock(&linecard->state_lock);
>> +	WARN_ON(linecard->nested_devlink);
>>  	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
>>  	linecard->type = NULL;
>>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> @@ -10353,6 +10377,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
>>  void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
>>  {
>>  	mutex_lock(&linecard->state_lock);
>> +	WARN_ON(linecard->nested_devlink);
>>  	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
>>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>>  	mutex_unlock(&linecard->state_lock);
>> @@ -10400,6 +10425,23 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
>>  }
>>  EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
>>  
>> +/**
>> + *	devlink_linecard_nested_dl_set - Attach/detach nested delink
>
>s/delink/devlink/
>
>> + *					 instance to linecard.
>> + *
>> + *	@linecard: devlink linecard
>> + *      @nested_devlink: devlink instance to attach or NULL to detach
>
>The alignment looks off

Will fix all in v2.

>
>> + */
>> +void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
>> +				    struct devlink *nested_devlink)
>> +{
>> +	mutex_lock(&linecard->state_lock);
>> +	linecard->nested_devlink = nested_devlink;
>> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> +	mutex_unlock(&linecard->state_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_linecard_nested_dl_set);
>> +
>>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>>  			u32 size, u16 ingress_pools_count,
>>  			u16 egress_pools_count, u16 ingress_tc_count,
>> -- 
>> 2.35.3
>> 
