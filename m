Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3398C17CC93
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 08:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgCGG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:59:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46604 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgCGG7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:59:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id n15so4831842wrw.13
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 22:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d1bQGX7SgFQbdhDhkWqLNJ1ISsK91fLwSPoqMk087SU=;
        b=o1HSBrqXi9TtRL/6MHIz+TkZNbweDucZzgY6eRtpStxz+LiEI3HHIp/zAULg8NDT71
         6zyAG/D58CTRHhxKYTBr/SCN7fZR6H//WT5NoYNid06saH6OQVAbhAEuZxplSmJ8DEpP
         Z6JxiH7B4UU2QZ62owpqnW8F6OFtzVBXGuaJQXDzfon5ecnm/SAlqm5GW2Jh78ysAY/b
         8/xxP0dQjI8iEvQwRGVGQF7v0oHopYvWZDVFrk6Im+tJbya23NZn6OMtwZrcwU0IobOi
         Jc0We1PGXlz0Kzv8pf8uaL/Bm/FlvAr0DQ1MWk7v4eyxrrbwRq1UqXnwXOdiCM/NxpF7
         k03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d1bQGX7SgFQbdhDhkWqLNJ1ISsK91fLwSPoqMk087SU=;
        b=eO9fBldLppCXTP4uNZLlFg9Pv1XIwGRhUjGfIHPNHqL83YEv1rOIaArPIVPiwdFpsr
         DOpW2RhHFkjRrNXk2MHuLD99D9sk1yFydhRlxojG3dOWg/2D06sSsYU+NmnLG6Ata5oI
         KkPwmEuLGQiUFe3Mi2etvDcY2xG7bInjda/a5LQk2/boDPvYhhSfRmOklMPTIWDrqK7Y
         iFJIcgLuLlNo1TaLsbDnAVF5GxOMkbn/4iBgpZwS9T+RLqU7CDOTrGgP2Scn74VsxvqW
         qK79U7D3W7PoVeBOfIugmFhbl0/kttcDoZ0zbWss1a8le3YBAWNpxiIcaSSVWEamScZ2
         UOhQ==
X-Gm-Message-State: ANhLgQ0xtcngcPbgDJzN6nDjYJJr7/kzYZxshoojnORe1TXNzYgs99fY
        st9rYjqidPeQtCZ42wRngHQDGA==
X-Google-Smtp-Source: ADFU+vvkVOBe9d8zvthkUGiwahNCGpmZ4sM2TaVPAhkQSvujhiLgiujROBJacMEmjs5BDszY7wh1jw==
X-Received: by 2002:a5d:658c:: with SMTP id q12mr8717879wru.57.1583564389206;
        Fri, 06 Mar 2020 22:59:49 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c72sm10771103wme.35.2020.03.06.22.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 22:59:48 -0800 (PST)
Date:   Sat, 7 Mar 2020 07:59:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 03/10] flow_offload: check for basic action
 hw stats type
Message-ID: <20200307065948.GB2210@nanopsycho.orion>
References: <20200306132856.6041-1-jiri@resnulli.us>
 <20200306132856.6041-4-jiri@resnulli.us>
 <20200306112851.2dc630e7@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306112851.2dc630e7@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 06, 2020 at 08:28:51PM CET, kuba@kernel.org wrote:
>On Fri,  6 Mar 2020 14:28:49 +0100 Jiri Pirko wrote:
>> @@ -251,6 +252,66 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
>>  	return action->num_entries == 1;
>>  }
>>  
>> +static inline bool
>> +flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>> +				       struct netlink_ext_ack *extack)
>> +{
>> +	const struct flow_action_entry *action_entry;
>> +	u8 uninitialized_var(last_hw_stats_type);
>
>Perhaps just initialize before the loop to action 0 and start loop 
>from 1?

Hmm, will check.


>
>> +	int i;
>> +
>> +	if (flow_offload_has_one_action(action))
>> +		return true;
>> +
>> +	for (i = 0; i < action->num_entries; i++) {
>> +		action_entry = &action->entries[0];
>
>s/0/i/ ?

Right, missed this.


>
>> +		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
>> +			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
>> +			return false;
>> +		}
>> +		last_hw_stats_type = action_entry->hw_stats_type;
>> +	}
>> +	return true;
>> +}
>> +
>> +static inline const struct flow_action_entry *
>> +flow_action_first_entry_get(const struct flow_action *action)
>> +{
>> +	WARN_ON(!flow_action_has_entries(action));
>> +	return &action->entries[0];
>> +}
>> +
>> +static inline bool
>> +flow_action_hw_stats_types_check(const struct flow_action *action,
>> +				 struct netlink_ext_ack *extack,
>> +				 u8 allowed_hw_stats_type)
>> +{
>> +	const struct flow_action_entry *action_entry;
>> +
>> +	if (!flow_action_has_entries(action))
>> +		return true;
>> +	if (!flow_action_mixed_hw_stats_types_check(action, extack))
>> +		return false;
>> +	action_entry = flow_action_first_entry_get(action);
>> +	if (!allowed_hw_stats_type &&
>> +	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
>> +		return false;
>> +	} else if (allowed_hw_stats_type &&
>> +		   action_entry->hw_stats_type != allowed_hw_stats_type) {
>
>Should this be an logical 'and' if we're doing it the bitfield way?

No. I driver passes allowed_hw_stats_type != 0, means that allowed_hw_stats_type
should be checked against action_entry->hw_stats_type.
With bitfield, this is a bit awkward, I didn't figure out to do it
better though.

>
>> +		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
>> +		return false;
>> +	}
>> +	return true;
>> +}
>
