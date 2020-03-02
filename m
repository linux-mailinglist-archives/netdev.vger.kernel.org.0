Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BFF175C7C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgCBN7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:59:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35886 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCBN7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 08:59:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id j16so12755112wrt.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 05:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gjZVjTSS3QUQ5LdHgBSc1YTJHsMYTrYVqGuFLLZK90o=;
        b=MV9qSAy26S+Oi1OzsoFmBd9gj8pi8BJK4QphLuxRbC8TglRhXUGvLT9Qp/Rg3Sregd
         PzNp7yEk8HybQ87vjt0oXh3y876ZbUU8rr1Crk677IAJL4EoD6E9OYVvW9vWouCqW9sD
         o+Z1YGSUrpG505BuRvcgd64Qn15vzlCLoDMwtrpkS1HC2iC0NMPbkGEIEOd70TzVRzs1
         JeGNXA9cmxs8t8MvJHFsYGrif3T9DKNvDFb5fwaLXYocxo+gyqU2NSoC2zEl0aae+Hn6
         gxVKd2prHW0W+yv8cVbFM25MYsBo4l9Um0VbDpNX5Y8khCaVlXeVHaVDA2B3ube9tjSy
         mMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gjZVjTSS3QUQ5LdHgBSc1YTJHsMYTrYVqGuFLLZK90o=;
        b=iB2HsXftgAb1lS910QCm2BOFvL2xH1s29n8+MekkFneeZtEEK81HR5bUsKuS1usCt4
         xSm3c32rDaV/tpPqO/pGEfsrj7CTB/N5tNpwIy7z2lBPjTDllm+R+un90qPcjJGm6qDB
         4aMle7F7Aef1rZY3KnzQF/pwTboODjyHvfa01IJLuGd5xrt5qY5VsPlWp40GAN74zzM1
         PR8Xi6CyjXyquD//24CN9mEajLD9qsR9hbcMmcPJylod9NU0XnN5XJJsahUHXoXYLJ/s
         7Miu3CJgcsbaG4szehKW6ZlLSmxXNQ+eHQrKLKrPnm6iGXI4RDFt1huS0m9iHwIxLzwP
         TDmA==
X-Gm-Message-State: APjAAAV7m9GmQSE/r/pc+ADi5pWEH3wreRm/EK8MpCBcT0mPC8RzsBVt
        iAPBJGe//q79lp188rLJzZ1yLA==
X-Google-Smtp-Source: APXvYqziWrlpvc2VKWGdzfaWTQPKZTxeIzR8Ise78be1zpYaAPQwuAO4+PhNxuzF8vGoTbwZukiYtA==
X-Received: by 2002:a5d:6604:: with SMTP id n4mr21509335wru.136.1583157569197;
        Mon, 02 Mar 2020 05:59:29 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n8sm26984581wrm.46.2020.03.02.05.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 05:59:28 -0800 (PST)
Date:   Mon, 2 Mar 2020 14:59:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 08/12] flow_offload: introduce "immediate" HW
 stats type and allow it in mlxsw
Message-ID: <20200302135928.GB6497@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-9-jiri@resnulli.us>
 <20200229193217.ejk3gbwhjcnxlk3c@salvia>
 <20200301084716.GR26061@nanopsycho>
 <20200302132338.inwkbnkbytjsrikw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302132338.inwkbnkbytjsrikw@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 02:23:42PM CET, pablo@netfilter.org wrote:
>On Sun, Mar 01, 2020 at 09:47:16AM +0100, Jiri Pirko wrote:
>> Sat, Feb 29, 2020 at 08:32:18PM CET, pablo@netfilter.org wrote:
>> >On Fri, Feb 28, 2020 at 06:25:01PM +0100, Jiri Pirko wrote:
>> >[...]
>> >> @@ -31,7 +31,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
>> >>  
>> >>  	act = flow_action_first_entry_get(flow_action);
>> >>  	switch (act->hw_stats_type) {
>> >> -	case FLOW_ACTION_HW_STATS_TYPE_ANY:
>> >> +	case FLOW_ACTION_HW_STATS_TYPE_ANY: /* fall-through */
>> >> +	case FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE:
>> >
>> >This TYPE_ANY mean that driver picks the counter type for you?
>> 
>> Driver pick any counter, yes.
>> 
>> >Otherwise, users will not have a way to know how to interpret what
>> >kind of counter this is.
>> 
>> User does not care in this case.
>
>OK.
>
>When listing back the counters, will the user get what counter type
>the driver has selected?

User will get back exactly what he passed.
