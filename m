Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76039179228
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 15:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgCDOSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 09:18:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37150 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgCDOSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 09:18:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id a141so2050368wme.2
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 06:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KAdy1Ce/bSm14uNtW0+72Oio7Hbe4nf1Z0kXSntMnNM=;
        b=vGI1rC6lPatO6K/fIDDa82Hqp+fuYCbhd+cAtazYmI4htMHDQw7KyzLnI5Ans5q/cQ
         i4nNC6ADBZENzKh6XHsXpKL4TfjQF38RWFJDCvrrMD5lYwzYvppGx1KUuL2f5Vgq3J4Y
         vEngfnjc04Q2//YI1Lr8F+VHjmX+ud0D43PvDVEX07Nn/kXLRtPSi0H24NpfYZzv7UTp
         jKGjneCbLj7qYMjFfrWA6leRD0SSodXfX6pyO4HN7y9WTsHPacggLE8Ds+/+uK3S6m/Z
         0IDdgJYP8yjpRR/shYd0pdmb317awuPZz9LvAmOLZPuMopvL6sCmb4yBIkOg4JxXN/2z
         q/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KAdy1Ce/bSm14uNtW0+72Oio7Hbe4nf1Z0kXSntMnNM=;
        b=Vs0yzoFNPmv2pfWj2cjSmPzP/LYnrsnn3ey4gmQ40N1ENHHmKWOoT9vVOEJ2tGzL2D
         /i6hQvc/1yHFbcLe+XujefpYIn0eNAujM8vrb053bS3qsI+qobSQuXerWWYqbCC/pRcQ
         4ORW2j8rVPoFlwakeSGkDm21Qu4S+asNXgg8Y9ldnPALB+OX/kMyDe4d4vfc6cQiIjYM
         RndXyecum1shauuQwSfBVgWHJZwR8o8bKX38yTP+VD+nri+BtRqIZCYWq0JfAyDuR8Qg
         Q2SMriT1RMwjIJw/O319aApnuP0iaOgZoa3Gbx7hj2B+3OJyLi4akBzB1JBpRJ2iebB1
         q+ig==
X-Gm-Message-State: ANhLgQ2AsNOcaP3ltjfQMn3ci38ZJVwfCZVFD8qGW2s1kKlRAvPYNpRa
        XeI+HSKA992V2ub+wPu6wlWNgQ==
X-Google-Smtp-Source: ADFU+vt1wHhDP026qaT7wxptoBhhsER/odh+/QzKrA1rr0MLl5u/7sZKHVaVbtPmndjfb08eJIBIJg==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr4129381wmj.54.1583331526699;
        Wed, 04 Mar 2020 06:18:46 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id l4sm4712706wmf.38.2020.03.04.06.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 06:18:41 -0800 (PST)
Date:   Wed, 4 Mar 2020 15:18:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200304141839.GD4558@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <ef1dd85e-dea3-6568-62c9-b363c8cac72b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef1dd85e-dea3-6568-62c9-b363c8cac72b@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 08:13:23PM CET, ecree@solarflare.com wrote:
>On 28/02/2020 17:24, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>>
>> Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
>> current implicit value coming down to flow_offload. Add a bool
>> indicating that entries have mixed HW stats type.
>>
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v1->v2:
>> - moved to actions
>> - add mixed bool
>> ---
>>  include/net/flow_offload.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 4e864c34a1b0..eee1cbc5db3c 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -154,6 +154,10 @@ enum flow_action_mangle_base {
>>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
>>  };
>>  
>> +enum flow_action_hw_stats_type {
>> +	FLOW_ACTION_HW_STATS_TYPE_ANY,
>> +};
>> +
>>  typedef void (*action_destr)(void *priv);
>>  
>>  struct flow_action_cookie {
>> @@ -168,6 +172,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>>  
>>  struct flow_action_entry {
>>  	enum flow_action_id		id;
>> +	enum flow_action_hw_stats_type	hw_stats_type;
>>  	action_destr			destructor;
>>  	void				*destructor_priv;
>>  	union {
>> @@ -228,6 +233,7 @@ struct flow_action_entry {
>>  };
>>  
>>  struct flow_action {
>> +	bool				mixed_hw_stats_types;
>Some sort of comment in the commit message the effect that this will
> be set in patch #12 would be nice (and would have saved me some
> reviewing time looking for it ;)
>Strictly speaking this violates SPOT; I know a helper to calculate
> this 'at runtime' in the driver would have to loop over actions,
> but it's control-plane so performance doesn't matter :grin:

That is what I wanted to avoid.


>I'd suggest something like adding an internal-use-only MIXED value to
> the enum, and then having a helper
> enum flow_action_hw_state_type flow_action_single_stats_type(struct flow_action *action);
> which could return FLOW_ACTION_HW_STATS_TYPE_MIXED or else whichever
> type all the actions have (except that the 'different' check might
> be further complicated to ignore DISABLED, since most
> flow_action_entries will be for TC actions with no .update_stats()
> which thus don't want stats and can use DISABLED to express that).
>That then avoids having to rely on the first entry having the stats
> type (so flow_action_first_entry_get() goes away).

No problem. I can call a helper that would go over the entries from
driver. As you say, it is a slow path.

Will do.


>
>-ed
>>  	unsigned int			num_entries;
>>  	struct flow_action_entry 	entries[0];
>>  };
