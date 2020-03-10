Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8E17F4AB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJKNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:13:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55789 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgCJKNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:13:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id 6so647067wmi.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 03:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SDmbIbJ4INNvxXkw25Ip8mIAcgJfptxQdMYlOXLmuu0=;
        b=KEIrpYI1GcvL59fvqlNaf9HioyfFuC/XLN1QmrIdSo9VAeIFZ8Te5FNcKiRSKU18a+
         WFRRlyD2lTBpa4wCK6mMwjKF6fQoUU1n9J6W05+K/VHjyzVdL6G7lQwEvQcit50Aq9aB
         BfFfNuacGXAbgewDzVnHCsP00drnzEju69VRpcCt0Y/AElxS0tV3XA77fQwdbRExkuz8
         PuiloO/+gKzWVG0GDTNqA3L15A9Gt5lWrtYbr0HfOmHfwox8vVwHrzft6iUcMogmEJcc
         cqt72b+13VrTdOQc/Zq9I/b/CzUolBqA5pc4BySdTrvfN4+2k/kPnZzaxVjSwrxKkNtQ
         Fnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SDmbIbJ4INNvxXkw25Ip8mIAcgJfptxQdMYlOXLmuu0=;
        b=aOutMTIjOzen7cJc99333vUnIiulIV46vKSdkZSJRKv4iSrCfCuci6NOsLFUJMAEpo
         pFn3QP4hUdtomD1frts4bxxE0DSpy79PTjdC2Uic+PsjguaU5+F4iMD50OJpkW58aeHT
         fBrbGfkODV6iR3x6dvxDS/5/VFUcigGFOXoUVUGjTYVT/3tRlzEFVJky1xh8MwQE4pQh
         yBrN5sELdUaNSZhmCTSeXwsQHYNaPI9YIFBAALEg69TcvrwjJbm0KnOty62zNMUC4EBW
         mrOWXiY4AtoLGuzhyZcuyP1k8ATKvo1lhptZixAxsqeVWwQz9RvPaIU2UqdxVYKS5/tu
         e4uw==
X-Gm-Message-State: ANhLgQ2Mh1AJFeleWhiSwlfVobHxpt3M4Tc48OPFtlST4mhYiv8GagWo
        miyNNHXNyGe98gceEcG/GlQisw==
X-Google-Smtp-Source: ADFU+vt97dAOJKTIky8HU2Kyse5fUq/N8NtjQYVB3V5J0rO+1zuVc2N7Yh/ZvnX2+z98tKIwb9aikQ==
X-Received: by 2002:a05:600c:20c9:: with SMTP id y9mr1479654wmm.83.1583835216093;
        Tue, 10 Mar 2020 03:13:36 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id 19sm3604824wma.3.2020.03.10.03.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 03:13:35 -0700 (PDT)
Date:   Tue, 10 Mar 2020 11:13:34 +0100
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
Message-ID: <20200310101334.GB2211@nanopsycho>
References: <20200306132856.6041-1-jiri@resnulli.us>
 <20200306132856.6041-4-jiri@resnulli.us>
 <20200306112851.2dc630e7@kicinski-fedora-PC1C0HJN>
 <20200307065948.GB2210@nanopsycho.orion>
 <20200309121722.6f536941@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309121722.6f536941@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 08:17:22PM CET, kuba@kernel.org wrote:
>On Sat, 7 Mar 2020 07:59:48 +0100 Jiri Pirko wrote:
>> >> +static inline bool
>> >> +flow_action_hw_stats_types_check(const struct flow_action *action,
>> >> +				 struct netlink_ext_ack *extack,
>> >> +				 u8 allowed_hw_stats_type)
>> >> +{
>> >> +	const struct flow_action_entry *action_entry;
>> >> +
>> >> +	if (!flow_action_has_entries(action))
>> >> +		return true;
>> >> +	if (!flow_action_mixed_hw_stats_types_check(action, extack))
>> >> +		return false;
>> >> +	action_entry = flow_action_first_entry_get(action);
>> >> +	if (!allowed_hw_stats_type &&
>> >> +	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
>> >> +		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
>> >> +		return false;
>> >> +	} else if (allowed_hw_stats_type &&
>> >> +		   action_entry->hw_stats_type != allowed_hw_stats_type) {  
>> >
>> >Should this be an logical 'and' if we're doing it the bitfield way?  
>> 
>> No. I driver passes allowed_hw_stats_type != 0, means that allowed_hw_stats_type
>> should be checked against action_entry->hw_stats_type.
>
>Right, the "allowed_hw_stats_type &&" is fine.
>
>> With bitfield, this is a bit awkward, I didn't figure out to do it
>> better though.
>
>The bitfield passed from user space means any of the set bits, right?
>
>Condition would be better as:
>
>allowed_hw_stats_type && (allowed_hw_stats_type & entry->hw_stats_type)
>
>Otherwise passing more than one bit will not work well, no?
>
>Driver can pass IMMEDIATE | DELAYED, action has IMMEDIATE, your

Yeah, this is something that made more sense for non-bitfield. Basically
this is for simple driver which supports only one type. If the driver
supports more types (like mlxsw), it should not call this function.


>condition would reject it.. Same if driver has only one type and user
>space asks for any of a few.
>
>Drivers can't do a straight comparisons either, but:
>
>if (act->stats & TYPE1) {
>   /* preferred stats type*/
>} else if (act->stats & TYPE2) {
>   /* also supported, lower prio */
>} else if (act->Stats & TYPE3) {
>   /* lowest prio */
>}
