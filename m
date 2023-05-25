Return-Path: <netdev+bounces-5235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6157C710591
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4E7E1C20E76
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3A78836;
	Thu, 25 May 2023 06:07:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07ED8828
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:07:13 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBA3D3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:07:12 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51403554f1dso3069198a12.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684994830; x=1687586830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QN3sYSmeNFCMy8t8YWT5wjf0R54qG7mHYYNg6nh0AG4=;
        b=JTHyRXZOujmn2hL5Y2CSCisGf0wXIltY22SrCJADIeSPBNJXR19rOIxUMYL5O8U7VW
         SufroHCdH03S3mZQQ8PaSPiPC/2ayisybroMuwRIH3sB3VPHP5FzvsQULqomPN+oSTRL
         AyDi0VmriROsWZP65r44v7eROqvz37UU+iTVrgZ4ETj/5Wsfcjkg0YL4RglgGVu8qc0I
         6dK4HQvquaarfI9w1B945LFkmfvbvB1lcFTCPep8HVTuItOrntLjrdLCZWh2bUxW16VD
         IXyc90pCEthAjK5uI8GivyLyybMQ2tQ2mqK3gB9lqxiBAvYq/CI6hrR8V9oTyYNs/7/M
         HfqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684994830; x=1687586830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QN3sYSmeNFCMy8t8YWT5wjf0R54qG7mHYYNg6nh0AG4=;
        b=kW6suLZOC/KBq8DIiZF31jM//xDcazikwLXeiTqd9ghH9Z4pwb4uF5OsYCXMsy8YRv
         4cJZEmK6pls8mY4LEVbM4eo9z6vN30BJHZPPE6VwraWTlKmjNxa6VxHxZRTs8rJ3kCPM
         yD0ZG6EBxMObGNPSvRGLfWuQeTRwcukVUUYNirdF9qWeHpklkqyfjfUW7KA8j8NSng3B
         tj1S/JX5lESwuogCKlrr13ngNiMLnxOHHKpE6X7ByVwrRBScanGG0TTmr34dcVquvxcP
         9lwHKwEA+PccoMkzafn6uiG+BNoso7BMSMeFhtqzAj9fjgnw9HQUl4CvdKhrBEwbWAI4
         41gQ==
X-Gm-Message-State: AC+VfDxmxB3pnNO0q1Q4bCCl0pfcKPuKRNwSDRB3U+N7tHDWYjhEtuoI
	yz4B9jjvP81tyh4fkLE1B0eFlw==
X-Google-Smtp-Source: ACHHUZ4UeBwe/NYd+mltArz3+Jk86dtY+I1+8MmtM4ur2mzcISsBhnt/8JKkYJ4zAhI5KZ7wRhRrLA==
X-Received: by 2002:a17:907:7f9e:b0:96f:7b4a:2904 with SMTP id qk30-20020a1709077f9e00b0096f7b4a2904mr689297ejc.3.1684994830457;
        Wed, 24 May 2023 23:07:10 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id lf4-20020a170907174400b0096f7500502csm356085ejc.199.2023.05.24.23.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 23:07:09 -0700 (PDT)
Date: Thu, 25 May 2023 08:07:08 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next 01/15] devlink: introduce port ops placeholder
Message-ID: <ZG77DAskJxpDYbdi@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-2-jiri@resnulli.us>
 <20230524214811.0fb25930@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524214811.0fb25930@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 06:48:11AM CEST, kuba@kernel.org wrote:
>On Wed, 24 May 2023 14:18:22 +0200 Jiri Pirko wrote:
>> @@ -6799,6 +6799,7 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
>>   * @devlink: devlink
>>   * @devlink_port: devlink port
>>   * @port_index: driver-specific numerical identifier of the port
>> + * @ops: port ops
>>   *
>>   * Register devlink port with provided port index. User can use
>>   * any indexing, even hw-related one. devlink_port structure
>> @@ -6806,9 +6807,10 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
>>   * Note that the caller should take care of zeroing the devlink_port
>>   * structure.
>>   */
>> -int devl_port_register(struct devlink *devlink,
>> -		       struct devlink_port *devlink_port,
>> -		       unsigned int port_index)
>> +int devl_port_register_with_ops(struct devlink *devlink,
>> +				struct devlink_port *devlink_port,
>> +				unsigned int port_index,
>> +				const struct devlink_port_ops *ops)
>>  {
>>  	int err;
>
>function name in kdoc needs an update

Ah, will fix.


>
>> @@ -6819,6 +6821,7 @@ int devl_port_register(struct devlink *devlink,
>>  	devlink_port_init(devlink, devlink_port);
>>  	devlink_port->registered = true;
>>  	devlink_port->index = port_index;
>> +	devlink_port->ops = ops;
>>  	spin_lock_init(&devlink_port->type_lock);
>>  	INIT_LIST_HEAD(&devlink_port->reporter_list);
>>  	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
>> @@ -6830,7 +6833,7 @@ int devl_port_register(struct devlink *devlink,
>>  	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
>>  	return 0;
>>  }
>> -EXPORT_SYMBOL_GPL(devl_port_register);
>> +EXPORT_SYMBOL_GPL(devl_port_register_with_ops);
>>  
>>  /**
>>   *	devlink_port_register - Register devlink port
>> @@ -6838,6 +6841,7 @@ EXPORT_SYMBOL_GPL(devl_port_register);
>>   *	@devlink: devlink
>>   *	@devlink_port: devlink port
>>   *	@port_index: driver-specific numerical identifier of the port
>> + *	@ops: port ops
>>   *
>>   *	Register devlink port with provided port index. User can use
>>   *	any indexing, even hw-related one. devlink_port structure
>> @@ -6847,18 +6851,20 @@ EXPORT_SYMBOL_GPL(devl_port_register);
>>   *
>>   *	Context: Takes and release devlink->lock <mutex>.
>>   */
>> -int devlink_port_register(struct devlink *devlink,
>> -			  struct devlink_port *devlink_port,
>> -			  unsigned int port_index)
>> +int devlink_port_register_with_ops(struct devlink *devlink,
>> +				   struct devlink_port *devlink_port,
>> +				   unsigned int port_index,
>> +				   const struct devlink_port_ops *ops)
>
>same here.

Yeah, will fix.

>
>BTW do we need to provide the "devlink_*" form of this API or can we
>use this as an opportunity to move everyone to devl_*. Even if the
>driver just wraps the call with devl_lock(), sooner or later people
>will coalesce the locking in the drivers, I hope.

It is on my list, stay tuned, will address in a follow-up.


>-- 
>pw-bot: cr

