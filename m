Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBEE17E5BC
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCIRcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:32:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36415 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgCIRcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:32:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id s5so8395898wrg.3
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WxYmRRZdpw9v1+Q9NWUdyW6ICQYn82ZKemq9b2/7Xeo=;
        b=ri+IT8j9PdLQ9s6qx9m8Pw2Qbu5jPi5Qwbjlb2JDV+ThpahVCn/qcXXT2nD8PiIMwY
         snPayNDElyEVSFD886YHhzAXOtUbQ/8K6cKHGAuKcaIRjXj3lfRJRbG0B+MzVe3PEpab
         SJL5vkk6iptLPnELglIGBrk0aTVYGKnhx1kOBPYk3noyh3wqyXp521KHQtWf2lUEtW+l
         aF9VS4tYP+rycXjP9yUrEVbVhiUt8BkxXSDhXwD6rOludllfsAInrK+642NbXRA0Aql5
         y8vMJ5QV3V0xpfoDApxSvjNzjurVkCMS+hPEcFsdJ2XdB0EPe4cDyhfDlZNEcEIv0Kmc
         Prrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WxYmRRZdpw9v1+Q9NWUdyW6ICQYn82ZKemq9b2/7Xeo=;
        b=JjLNOE5HmSw1plc3TkuaI0r5o1Vl4QdS79Nrw7FoQEFs0Ua2xPltfiYBH8D+8cuwpU
         /mC2qmdAueRI9gbMRdXYRcQDM54FANmf5iLojX21pNyVQyqYdXOLErqVmAYBAVoLib14
         W/TpI1xyNajG7bwaDa2NxMdMlpst1zknmT/zsfcbNiH0OVoSQV3yEXRkLtklSlKvsZGp
         W7s8KsZJLtv3BsmnQdmdeuuM9Lakysk/KvotAMtXkg42ok/vpJh85gc1eRq6LxwjaVA+
         Px+B0lNOH9BXwmNdAO6E26GJ5zjoGT4HlzVyOWPUzLd+aKLdMXV5m8/5x1pbOVG13rUV
         KKuA==
X-Gm-Message-State: ANhLgQ2USOTwLe/yPT9ah4N3HkOgECVKKtUdG2mjypYzXD1uPXHBStOv
        IKhPTHF179LR9Fdgu0cRcf3mKQ==
X-Google-Smtp-Source: ADFU+vtbLjBCXX20WjuvtcuRm14WS90PUHl59cKVr+SLBLGH33UWbel2Yn9YlnH+esjhkHmHvls0MQ==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr21428078wrx.382.1583775143025;
        Mon, 09 Mar 2020 10:32:23 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i1sm43834066wrs.18.2020.03.09.10.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 10:32:22 -0700 (PDT)
Date:   Mon, 9 Mar 2020 18:32:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 03/10] flow_offload: check for basic action
 hw stats type
Message-ID: <20200309173221.GE13968@nanopsycho.orion>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-4-jiri@resnulli.us>
 <180ffa93-943c-95ba-437b-a9d15db2a955@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <180ffa93-943c-95ba-437b-a9d15db2a955@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 05:52:47PM CET, ecree@solarflare.com wrote:
>On 07/03/2020 11:40, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>>
>> Introduce flow_action_basic_hw_stats_types_check() helper and use it
>> in drivers. That sanitizes the drivers which do not have support
>> for action HW stats types.
>>
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v3->v4:
>> - fixed entries iteration in check (s/0/i/)
>> - compare allowed type explicitly to 0 to avoid confusion
>> v2->v3:
>> - added flow_action_hw_stats_types_check() to pass allowed types
>> - "mixed" bool got remove, iterate entries in check
>> - added mlx5 checking instead of separate patches (will be changed by
>>   later patch to flow_action_hw_stats_types_check()
>> v1->v2:
>> - new patch
>> ---
>> <snip>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 93d17f37e980..8b40f612a565 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -3,6 +3,7 @@
>>  
>>  #include <linux/kernel.h>
>>  #include <linux/list.h>
>> +#include <linux/netlink.h>
>>  #include <net/flow_dissector.h>
>>  #include <linux/rhashtable.h>
>>  
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
>> +	int i;
>> +
>> +	if (flow_offload_has_one_action(action))
>> +		return true;
>> +
>> +	for (i = 0; i < action->num_entries; i++) {
>Any reason you didn't use flow_action_for_each() here?

Nope. Will send a follow-up to change this.


>-ed
>
>> +		action_entry = &action->entries[i];
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
>> +	if (allowed_hw_stats_type == 0 &&
>> +	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
>> +		return false;
>> +	} else if (allowed_hw_stats_type != 0 &&
>> +		   action_entry->hw_stats_type != allowed_hw_stats_type) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
>> +		return false;
>> +	}
>> +	return true;
>> +}
>> +
>> +static inline bool
>> +flow_action_basic_hw_stats_types_check(const struct flow_action *action,
>> +				       struct netlink_ext_ack *extack)
>> +{
>> +	return flow_action_hw_stats_types_check(action, extack, 0);
>> +}
>> +
>>  #define flow_action_for_each(__i, __act, __actions)			\
>>          for (__i = 0, __act = &(__actions)->entries[0]; __i < (__actions)->num_entries; __act = &(__actions)->entries[++__i])
>>  
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 79d9b4384d7b..fca9bfa8437e 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -865,6 +865,10 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
>>  	if (!flow_offload_has_one_action(&cls->rule->action))
>>  		return err;
>>  
>> +	if (!flow_action_basic_hw_stats_types_check(&cls->rule->action,
>> +						    cls->common.extack))
>> +		return err;
>> +
>>  	act = &cls->rule->action.entries[0];
>>  
>>  	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
>
