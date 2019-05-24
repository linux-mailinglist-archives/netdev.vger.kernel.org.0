Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9779D29284
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389449AbfEXILO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:11:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55674 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389142AbfEXILN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:11:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id x64so8339598wmb.5
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 01:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PxwcQQHVfEpm2IX36NDrm2MqjnVD0e3VF0P30FyOcG8=;
        b=dFOuHZuNtobDm00Uoo45sI2V15vIsMNxboRYkqEPJnJ0Hr4d/IR608yP2mlWv0vRCI
         z7MbeF8tuaQ4QV41l67nOd4q472Bdlv3Ql1UAmkJa+Y7JqWbDdBpYSdu9JVM5c8UK5vc
         I+tBNgp30GKWafVh2qV5HDNWB00OGZNsrJNjK22c2fspZxOKtqanTqm4Cf4H9aSstdJP
         coE4KiXZzefG/SRVPJtqfXXDYhcv7GsHQuGT9nmS3LosARygYQdNlJyxI18m++yruz2H
         wfMCIk+3AlsxJHC7kehwJq2AkAi8+qltUbRMdZ8Ud7n0wpaQI9pnqI6QImN692q+tkEN
         hJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PxwcQQHVfEpm2IX36NDrm2MqjnVD0e3VF0P30FyOcG8=;
        b=uZUborJxLGNOTcMWDETYl/TIVj4XlmsrKeu+egHXgNms5EgNMDv2R6Qp6nSrdhjKzo
         IC/noBhdeOpvzwZNk7GpNKr1l4VZDmFHwTuTDYlAz6/pJiPS5cMEQNlAlJTEa1Dy3OIP
         5Eda8jsWTxPeIcnrlWVNaONdky6i72twIyVFIoyrfrqxamTD3trHku6jMTsd6Q5s3Nxo
         Z9bkvajiYypicpW26K/XUt1yt0IoX4x/b1v52nK3+mUP3rdUKV8xW2lLtAHlNN1dYYP2
         8wHbtEIeMVnz1CS44FCUByYILaB/ofOvytRrBFC0wt66tjDsMCQncx5XSmqs4z+Z9J3G
         1O2Q==
X-Gm-Message-State: APjAAAVl8QlcOtKEz/9eONudsS6tBDYCJX4rN9Wl7yuFuBt+zzsY4Q0Y
        zq7aFw9chuh113F73Fc2sVtTyQ==
X-Google-Smtp-Source: APXvYqw8KeuvReFFp7pYCCqikeWXOl9nDkFb7YFBj0dtD2TAayHDKtRATC2e2+PFoBd4YnaIl6vc6w==
X-Received: by 2002:a1c:4045:: with SMTP id n66mr14953324wma.142.1558685471271;
        Fri, 24 May 2019 01:11:11 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id z202sm3384549wmc.18.2019.05.24.01.11.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 01:11:10 -0700 (PDT)
Date:   Fri, 24 May 2019 10:11:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Message-ID: <20190524081110.GB2904@nanopsycho>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <20190523094510.2317-4-jiri@resnulli.us>
 <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 23, 2019 at 05:19:46PM CEST, dsahern@gmail.com wrote:
>On 5/23/19 3:45 AM, Jiri Pirko wrote:
>> @@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>>  	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
>>  		pr_err("Firmware flash failed: %s\n",
>>  		       mlxfw_fsm_state_err_str[fsm_state_err]);
>> +		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
>>  		return -EINVAL;
>>  	}
>>  	if (curr_fsm_state != fsm_state) {
>>  		if (--times == 0) {
>>  			pr_err("Timeout reached on FSM state change");
>> +			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");
>
>FSM? Is the meaning obvious to users?

It is specific to mlx drivers. But I think it is valuable to have
driver-specific terms in driver speficic extack messages.


>
>>  			return -ETIMEDOUT;
>>  		}
>>  		msleep(MLXFW_FSM_STATE_WAIT_CYCLE_MS);
>> @@ -76,7 +79,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>>  
>>  static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
>>  				 u32 fwhandle,
>> -				 struct mlxfw_mfa2_component *comp)
>> +				 struct mlxfw_mfa2_component *comp,
>> +				 struct netlink_ext_ack *extack)
>>  {
>>  	u16 comp_max_write_size;
>>  	u8 comp_align_bits;
>> @@ -96,6 +100,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
>>  	if (comp->data_size > comp_max_size) {
>>  		pr_err("Component %d is of size %d which is bigger than limit %d\n",
>>  		       comp->index, comp->data_size, comp_max_size);
>> +		NL_SET_ERR_MSG_MOD(extack, "Component is which is bigger than limit");
>
>Need to drop 'is which'.

Will do.

>
>
>...
>
>> @@ -156,6 +163,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>>  					      &component_count);
>>  	if (err) {
>>  		pr_err("Could not find device PSID in MFA2 file\n");
>> +		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
>
>same here, is PSID understood by user?

PSID is actually exposed in "devlink dev info" for mlxsw.

>
