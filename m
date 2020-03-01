Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C765A174C4E
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgCAIor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:44:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45072 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgCAIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:44:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id v2so8519705wrp.12
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OhCnyvX4fMCwKA/4hedL0ChmXZc2TNAFj454NJr/ZJ8=;
        b=HCeQHqzMQbn9Y/6/K0Mdgv7eWulaUA7ppEUyqnou5TpHMD/rmBXDgPyMcDMx72+MQ/
         YOmI5bPxqe2LYjHw+q5ahpY0TgBkqT4B78H6AQWLx6S9jm1ZrPF4RBkLji/faarcdKBa
         v8mzpo3/UQ7BczLfHoGfr4tL0+zMYQ51/aLBM3r3a0tVziGTutk6/FZBFuk/b6n3PCXe
         Ppkd/IwCM4uF3h87w6vYdDeqjxwuqDkAPSVGAHw3w3Di4yOyfETRvhFqZPXUHZbs9SJX
         rBJvscXoxgpS/23RCyTpuQPX4jZJEo85MbdPXrE+BwP0g5qHliYqi+JdvOXKk9w2vSLu
         oVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OhCnyvX4fMCwKA/4hedL0ChmXZc2TNAFj454NJr/ZJ8=;
        b=pgt078QfTCeICn1prkfWvVLoUvnXJK0iNfKTSabW4vYrU5J1TlsrQzgoq66cEdRpac
         kS9zrX4I9YlhHUhGgKhddeuH28EIl4IPK99qLbrxFEgKZB616tL83Ic6OYce2S5p4eU/
         KqpMzJWb3DONoZLCEJgDfNfl5aNG01OR7/UUCfz9iPYdQQM+gxCGzh2xoD49M61ps0Qd
         nZZL/YJ+njWHLEbYfdNRHkx+T0gCDHimKYOsJDqtxkkiYlXlzNIC5Iig4+t3mTTU0hYW
         wOxcZ7zjoZU6P7yR8puM1I69U7gNhDnKO8iD+0klghvH3HSe3Z8eBrTzt2i5cf8zGW53
         y2Ag==
X-Gm-Message-State: APjAAAVHmxpt8WYfZWGZhhKGK8FKuQ0MRIahnBZtIOrC9TpacSXKR/Sl
        Efmz4wF78xKEwzQDTZnt3y7qHA==
X-Google-Smtp-Source: APXvYqyvP7eP1XCbyeCOfac57ekrIJtE2aETPYTBL5BLEfQkXaEA1VPfhsOmJ50MUvccJlChytEo8g==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr16170884wru.220.1583052285344;
        Sun, 01 Mar 2020 00:44:45 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id y185sm10196832wmg.2.2020.03.01.00.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 00:44:44 -0800 (PST)
Date:   Sun, 1 Mar 2020 09:44:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200301084443.GQ26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229192947.oaclokcpn4fjbhzr@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 29, 2020 at 08:29:47PM CET, pablo@netfilter.org wrote:
>On Fri, Feb 28, 2020 at 06:24:54PM +0100, Jiri Pirko wrote:
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
>
>Why do you want to place this built-in into the struct flow_action as
>a boolean?

Because it is convenient for the driver to know if multiple hw_stats_type
values are used for multiple actions.


>
>You can express the same thing through a new FLOW_ACTION_COUNTER.

I don't see how.


>I know tc has implicit counters in actions, in that case tc can just
>generate the counter right after the action.

I don't follow. Each action has a separate stats.


>
>Please, explain me why it would be a problem from the driver side to
>provide a separated counter action.

I don't see any point in doing that. The action itself implies that has
stats, you don't need a separate action for that for the flow_offload
abstraction layer. What you would end up with is:
counter_action1, actual_action1, counter_action2, actual_action2,...

What is the point of that?

