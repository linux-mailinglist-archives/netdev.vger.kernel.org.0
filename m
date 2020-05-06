Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E41C6768
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgEFFWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgEFFWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:22:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9514CC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 22:22:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l18so572442wrn.6
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 22:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kh12ddWMPPjxzbUQh9yFibL/KncP4qVkRvXKfZG1YFs=;
        b=actWQjK3kBuUYr4g+cS1koVmgwLpZxnHKeQToZxrFZfBMHHM31kFJsDgFYGYWMSHHj
         V30EsLgehM7TnDyPTy4cskztczTlX5l63TigBWuj9BxGiJ3n5NRJzIk5zrTxfPWgcFpQ
         4fefupCL+imDpoevJQZ1EiXJleSFT8qvuNLqYDFmrZ+//uGClbcCSa2yfo/vl73cbO73
         VVs6P/glE4gqpOPi880JthWq14M+uyaJtxUOldR5V1QEZlE9t8NTngL0syKagBAOJ4zv
         Arwic6HmzMqcmvaYo3nLhH1a5eF46bmOozAWCa3ATng7zcvV9YIOBECtyJGRRBO3+ca8
         T/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kh12ddWMPPjxzbUQh9yFibL/KncP4qVkRvXKfZG1YFs=;
        b=jp+dmGAlLBc5+F+p+Iroe/rK0FXvpvOxEHcsEkTR5vUDT98hBEYQf9cA1qGqUOWwcA
         L2bK5q7JYQQbGkmzish6kGaOHpnofolTyva9r6KGRK6eIR5q2uxtIsAX/jeYUOSdwJPB
         hMkapx2DOZJhMQco187ZeI8JJ26bLQliggusJKHlY5ttH/ZU0ZCti6pL3cn6PU93ndmB
         jwMuxtUPSfbro5U/lw9LLZhs3TneTXiY9Ks5LJTjGjumLjlUv3dSTem78iISWvSphSS2
         9D8C/xTIkGo+rdyRuCvqYKsAZ36IMnbJkGOddFAZoTpLiBwqmp8T9Q9KizbRJXYZQEoe
         SA8g==
X-Gm-Message-State: AGi0PubjK9iOw8w8KZi+D5Pb7JTQSmg3nldmqoFrdJVTjoyShyn+FyMj
        iQfW9+hiv/RYkwB7XMFSA/XxjA==
X-Google-Smtp-Source: APiQypI+rpSMlMLCLgo0LHAB1jA9StdRgGHnnW6T98ROnU9jxru/NxrR43rzOtI7CIHvNHvaOGFDWQ==
X-Received: by 2002:adf:e7cb:: with SMTP id e11mr6974313wrn.145.1588742532268;
        Tue, 05 May 2020 22:22:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h1sm1158046wme.42.2020.05.05.22.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 22:22:11 -0700 (PDT)
Date:   Wed, 6 May 2020 07:22:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200506052210.GA2269@nanopsycho.orion>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505183643.GI14398@nanopsycho.orion>
 <20200505114616.221fc9af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505114616.221fc9af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 05, 2020 at 08:46:16PM CEST, kuba@kernel.org wrote:
>On Tue, 5 May 2020 20:36:43 +0200 Jiri Pirko wrote:
>> Tue, May 05, 2020 at 07:47:36PM CEST, pablo@netfilter.org wrote:
>> >This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
>> >that the frontend does not need counters, this hw stats type request
>> >never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
>> >the driver to disable the stats, however, if the driver cannot disable
>> >counters, it bails out.
>> >
>> >TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
>> >except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
>> >(this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
>> >TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
>> >
>> >Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
>> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>  
>> 
>> Looks great. Thanks!
>> 
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>
>Is this going to "just work" for mlxsw?
>
>        act = flow_action_first_entry_get(flow_action);                         
>        if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||                        
>            act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {                  
>                /* Count action is inserted first */                            
>                err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);    
>                if (err)                                                        
>                        return err;                                             
>        } else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {            
>                NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type"); 
>                return -EOPNOTSUPP;                                             
>        }
>
>if hw_stats is 0 we'll get into the else and bail.
>
>That doesn't deliver on the "don't care" promise, no?

Yeah, we need to handle dontcare there, you are right.
