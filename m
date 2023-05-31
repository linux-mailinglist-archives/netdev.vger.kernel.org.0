Return-Path: <netdev+bounces-6685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BEA97176E1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADA551C20D87
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2D163CB;
	Wed, 31 May 2023 06:33:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105C07E8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:33:57 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF82599
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:33:55 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f6d7abe934so39628335e9.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685514834; x=1688106834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv0cOBS2rrqg82Y5chViFAt9ygm67dZ/0Cz4UjuZyYg=;
        b=ezsaIyenqEWEwol9DOVaeL7yxHmDWEhu2yt/0rMrzpfmn130OWFBhJarEFSv0MYe26
         q8YFl8yCu8vWRn/P+HvMFQBATzVBnQBzQUUGbATJZtZ7pCbfpsJ5q6QdRvQcAEE3X2Rj
         is7wzlocOneOP8cllxcz0LVWKU6QdtpluK3iFGDTqT1uWPaZ4hiqqN9UeLGr4+tSrm/N
         GG3Wkliy72D+i8u/dnLGhyplQwFex9VSu1LPzU4ZiRWMYdVIgvfFDDwMm7MZ3Us/BY/j
         stX0DHX91GqRfprt6Y7A+8d5lES/vR6YBkC9+0nXsI78czfkLeA+hNrIy8mB+SL4LME1
         gxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685514834; x=1688106834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fv0cOBS2rrqg82Y5chViFAt9ygm67dZ/0Cz4UjuZyYg=;
        b=gW6AAhE/Dc32ApQ5tLaLIBaRqwyRk/ZyVcmOEh8vuVJOjKD+kqDhd/oU6o7Vr8Ibrl
         7csNBAmdy24JZs5UwSDMYGCErIdsImSN9JoWZ3NhEMRZK9s+MWL3DNMvuZ4fzmyN1wpI
         r/4lKLVA6ukOUXJ3kv6pN6sKtsc/ydCLeDk+x+1qAbfGjj1dBjgNc/LhLqObW149MgR3
         G3EO/vEoiX9hzM/9flipEHRA2wHdTsSLA1iyccjtDrQTcKVmEZXX4PQpV8s3FA4V123Y
         L5G+Oxs5j2zL6A5w+ZTd7VLu+HbLIcxD8ZyJp2Ap/3rh/1Z3dhX4sNilaSe+39lX8rZ4
         RUpg==
X-Gm-Message-State: AC+VfDzdRwHvj3XbIv5pNyWS+vUIvJ6uCINMA7+noNEV7AWJOgmVC/5w
	nNpW+0Jirro5uSePxAVBMOvc3g==
X-Google-Smtp-Source: ACHHUZ7LArnkjyHk5plp4299+4MReYatiQC+s8v53FYyWH0Y+/SinKHh2ibTMBkMvf08bzYTprZX9g==
X-Received: by 2002:a7b:ce87:0:b0:3f6:8ef:a213 with SMTP id q7-20020a7bce87000000b003f608efa213mr3333437wmj.28.1685514834139;
        Tue, 30 May 2023 23:33:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e21-20020a05600c219500b003f4fffccd73sm19642304wme.9.2023.05.30.23.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:33:53 -0700 (PDT)
Date: Wed, 31 May 2023 08:33:52 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <ZHbqUHYHO3D8Nf/d@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-15-jiri@resnulli.us>
 <20230526211008.7b06ac3e@kernel.org>
 <ZHG0dSuA7s0ggN0o@nanopsycho>
 <20230528233334.77dc191d@kernel.org>
 <ZHRi0qZD/Hsjn0Fq@nanopsycho>
 <20230529184119.414d62f3@kernel.org>
 <ZHWep0dU9gCGJW0d@nanopsycho>
 <20230530103400.3d0be965@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530103400.3d0be965@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 30, 2023 at 07:34:00PM CEST, kuba@kernel.org wrote:
>On Tue, 30 May 2023 08:58:47 +0200 Jiri Pirko wrote:
>> >>  	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>> >>  	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>> >>  	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,  
>> >
>> >Is it okay if we deferred the port_del() patch until there's some
>> >clear benefit?  
>> 
>> Well actually, there is a clear benefit even in this patchset:
>> 
>> We have 2 flavours of ports each with different ops in mlx5:
>> VF:
>> static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
>>         .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>         .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>         .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>>         .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
>>         .port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
>>         .port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
>> };
>> 
>> SF:
>> static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
>>         .port_del = mlx5_devlink_sf_port_del,
>>         .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>         .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>         .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>>         .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
>>         .port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
>>         .port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
>> };
>> 
>> You can see that the port_del() op is supported only on the SF flavour.
>> VF does not support it and therefore port_del() is not defined on it.
>
>This is what I started thinking as well yesterday. Is there any reason
>to delete a port which isn't an SF? Similarly - is there any reason to
>delete a port which wasn't allocated via port_new?

Good question. Not possible atm. For SR-IOV VFs it probably does not make
sense as there are PCI sysfs knobs to do that. Not sure about SIOV.


>
>> Without this patch, I would have to have a helper
>> mlx5_devlink_port_del() that would check if the port is SF and call
>> mlx5_devlink_sf_port_del() in that case. This patch reduces the
>> boilerplate.
>
>... Because if port_del can only happen on port_new'd ports, we should
>try to move that check into the core. It'd prevent misuse of the API.

Okay, that is fair. Will make this change now. If the future brings
different needs, easy to change.


>
>> Btw if you look at the cmd line api, it also aligns:
>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 101
>> pci/0000:08:00.0/32768: type eth netdev eth4 flavour pcisf controller 0 pfnum 0 sfnum 101 splittable false
>>   function:
>>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
>> $ devlink port del pci/0000:08:00.0/32768
>> 
>> You use pci/0000:08:00.0/32768 as a delete handle.
>> 
>> port_del() is basically an object destructor. Would it perhaps help to
>> rename is to .port_destructor()? That would somehow ease the asymmetry
>> :) IDK. I would leave the name as it is a and move to port_ops.
>
>Meh.

Yeah :)


