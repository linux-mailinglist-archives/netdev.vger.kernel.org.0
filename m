Return-Path: <netdev+bounces-5656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F12837125A3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E981C21019
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F0A742F7;
	Fri, 26 May 2023 11:35:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B120A742EB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:35:43 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4A9E59
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:35:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f6d38a140bso5495425e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685100919; x=1687692919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DpLztVCn+WjMgDo0CeJvIn2oKMfgxX/uP6QgVFcHVGg=;
        b=FeOaDdv4gg3f3wKgSD7Kj0nG2QU2orT4vRISPcorJsxX7ESno+ajAZv8gU4TmByLiz
         y1t4L0mlb1JjReINz9H5X4xmpt6pFLA5eaMOsE/805ylU6BT5QLK8XsnnCmIqes/kplp
         XJSO/KPFiHRJXHHLKIkyHr2hnaYky1p2A30vruPoPTKZi+WX4lHQItQKHu3RNWX5JwzO
         q6c2LibE5nUj4R6Y4q0tZbpL8Ev6yMbLvUwjho8a++HDvm3ihasRPE2QGKL1I3ndXoH+
         73sKRleH6qI4QbhpGh4vaTZWg9KtwOqxc53I8rMyv1K6jYF1Z+/Es3iBp33ykfwixC+U
         vMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685100919; x=1687692919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpLztVCn+WjMgDo0CeJvIn2oKMfgxX/uP6QgVFcHVGg=;
        b=U6qL5RAljDBkTEhIiPJ31RPwsVA8pV1XXHddI1QTBLkDS4S+rF2D7yTawBgjWHakqm
         9iPvs0R1sw0cyJ+fUb6biEGpo4ZWG4hyos3teqodskBzhsrYboBVdXplzUYz7Squk29R
         0gXNkutYdNdCkQjkI+91vx9hr9qrypbm/k/edfZ/kw0u2m/SbKnfgSnWgbQyyQ0iUFjN
         QZ7ysev9XUgmUkTc0bJzdsG7wLsPQ862RQj2qoqLkuyePlZk0Cf4D8uA5yQuTJ7qZddx
         lM71DHyFfzDf/JNXPIQ2A+5LaqdEZylAPFk8AHXQuIQEqAF319YIS81bgX5IoyQkcM+g
         uRPg==
X-Gm-Message-State: AC+VfDxQ5Rkw1bPAVaKXq6gBgIiMf5psc9k4cpeUJr0i5n9IIws5m0Gf
	Yz2tylf+9IapV0+fUbn4S8UXJA==
X-Google-Smtp-Source: ACHHUZ4ZhsQ13Lm3DdrO2yqvqqxAEVD1pNeDBIO46XBTuTS52BAHoWC6NbJI1AN6s0KMkV1CzMXxOQ==
X-Received: by 2002:a05:600c:b44:b0:3f4:2d85:bcda with SMTP id k4-20020a05600c0b4400b003f42d85bcdamr1123758wmr.19.1685100919101;
        Fri, 26 May 2023 04:35:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c021800b003f080b2f9f4sm8523185wmi.27.2023.05.26.04.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 04:35:18 -0700 (PDT)
Date: Fri, 26 May 2023 13:35:16 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 02/15] ice: register devlink port for PF with
 ops
Message-ID: <ZHCZdD/m29yr5hfc@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-3-jiri@resnulli.us>
 <4b8dcf1e-72df-48dc-b249-81d07323a632@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b8dcf1e-72df-48dc-b249-81d07323a632@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 12:52:21PM CEST, michal.wilczynski@intel.com wrote:
>
>
>On 5/26/2023 12:28 PM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> Use newly introduce devlink port registration function variant and
>> register devlink port passing ops.
>>
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> ---
>>  drivers/net/ethernet/intel/ice/ice_devlink.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
>> index bc44cc220818..6661d12772a3 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
>> @@ -1512,6 +1512,9 @@ ice_devlink_set_port_split_options(struct ice_pf *pf,
>>  	ice_active_port_option = active_idx;
>>  }
>>  
>> +static const struct devlink_port_ops ice_devlink_port_ops = {
>> +};
>
>I can see that you're doing this everywhere, but aren't those braces redundant ?
>This struct would be initialized to zero anyway.

Well, yeah, but 3 patches later, they are not going to be empty anymore.


>
>> +
>>  /**
>>   * ice_devlink_create_pf_port - Create a devlink port for this PF
>>   * @pf: the PF to create a devlink port for
>> @@ -1551,7 +1554,8 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
>>  	devlink_port_attrs_set(devlink_port, &attrs);
>>  	devlink = priv_to_devlink(pf);
>>  
>> -	err = devlink_port_register(devlink, devlink_port, vsi->idx);
>> +	err = devlink_port_register_with_ops(devlink, devlink_port, vsi->idx,
>> +					     &ice_devlink_port_ops);
>>  	if (err) {
>>  		dev_err(dev, "Failed to create devlink port for PF %d, error %d\n",
>>  			pf->hw.pf_id, err);
>
>Looks good to me,
>
>Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
>
>

