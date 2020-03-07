Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD8317CC92
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 08:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgCGG4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:56:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41130 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgCGG4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:56:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id v4so4864922wrs.8
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 22:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3DPRZEU/M18W8ymnxavBJWuDucrwMmNN1ExodqsppNE=;
        b=MDW1Nb5zEXJF0uqkjw1d9oJ7ybvduVyhkZVOR4stP4rlGUoGlmtO/JAMx9C56Rzeew
         A/Pnx7ttWFZ3PbQ4VEdHpJOXkDgRXbyUwEty8tUkKZoZ2MjOEyfTkdbROV3GcpKywBai
         dncYmLrhogEG6CzkQeMGFR5v///nVAnD4YmQ3a1oaOupGXjXcmvz62HyDLfA16+Z2SC4
         l24iGBAptLObrR91sSjDluZMZnU1i0NuurdX25Y2o3KQjDMKwWYZ+0wHIPOLgOsmFEia
         wyv95S4ULbsuXeWJVJXCW/CTdHmm8IhTlzsrkOkNk29gqX6Gh5ap9D/1jZEzKgGjsseb
         4vnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3DPRZEU/M18W8ymnxavBJWuDucrwMmNN1ExodqsppNE=;
        b=YhuUgpnE4CaY3a8OTipqheAzELZbvm323j8tL8y2Toy0wK4ll8E2H86O0Vv/qvtJMB
         qEVYiN9t56mSprZ0OROXX5y2hO6Fc4+WoRd+MfIrhZm/4W94J3nHrBIQgEgB2XKj90Xw
         divP5EOsWfbPA19m0CtOy4GaVNVZQ20vdOZ533EPH+K8hfb2nfbVlaghtvMLT6kvki4o
         iYo+tLRyKJh/0L+A5Bn+6uMQZrsWXQN9ThMFTneYW3QDmuYU6/Dz4ZHtrIKrqHBM7FfP
         PCEGuDFGyo0nSEx9X5bMub9YW3VQoT622W3vkVRFg3VZ7+uKRnqcV/0989aSFXdo1o5e
         E+Uw==
X-Gm-Message-State: ANhLgQ2SlTRTAfMtWBhJevL2Gf7OD5gY4KICiN/jnme0po1a85E4qF1y
        eOAGNMZa4Y2OeFicdD1jxURCIA==
X-Google-Smtp-Source: ADFU+vtUEDmA5oK5kspwk+jlYZY0mKq1lJNjr28970CPUJZd7v6Eb9FjTYh2Qsv5QOUjSPaNmeqXFg==
X-Received: by 2002:a5d:5224:: with SMTP id i4mr7640171wra.285.1583564199327;
        Fri, 06 Mar 2020 22:56:39 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j205sm16455468wma.42.2020.03.06.22.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 22:56:38 -0800 (PST)
Date:   Sat, 7 Mar 2020 07:56:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 09/10] flow_offload: introduce "disabled" HW
 stats type and allow it in mlxsw
Message-ID: <20200307065637.GA2210@nanopsycho.orion>
References: <20200306132856.6041-1-jiri@resnulli.us>
 <20200306132856.6041-10-jiri@resnulli.us>
 <20200306113116.1d7b0955@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306113116.1d7b0955@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 06, 2020 at 08:31:16PM CET, kuba@kernel.org wrote:
>On Fri,  6 Mar 2020 14:28:55 +0100 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Introduce new type for disabled HW stats and allow the value in
>> mlxsw offload.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v2->v3:
>> - moved to bitfield
>> v1->v2:
>> - moved to action
>> ---
>>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 +-
>>  include/net/flow_offload.h                            | 1 +
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> index 4bf3ac1cb20d..88aa554415df 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> @@ -36,7 +36,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
>>  		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
>>  		if (err)
>>  			return err;
>> -	} else {
>> +	} else if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_DISABLED) {
>>  		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
>>  		return -EOPNOTSUPP;
>>  	}
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index d597d500a5df..b700c570f7f1 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -159,6 +159,7 @@ enum flow_action_mangle_base {
>>  #define FLOW_ACTION_HW_STATS_TYPE_DELAYED BIT(1)
>>  #define FLOW_ACTION_HW_STATS_TYPE_ANY (FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE | \
>>  				       FLOW_ACTION_HW_STATS_TYPE_DELAYED)
>> +#define FLOW_ACTION_HW_STATS_TYPE_DISABLED 0
>
>Would it fit better for the bitfield if disabled internally is 
>BIT(last type + 1)? 

I don't see why. Anyway, if needed, this can be always tweaked.
