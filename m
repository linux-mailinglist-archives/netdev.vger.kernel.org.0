Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56B9DA260
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391488AbfJPXhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:37:04 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36046 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbfJPXhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:37:04 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so523798ljj.3
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 16:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tLUZSgXbqOUuhFVQiMgZKVhpYys1gWWINbtrup0/G/o=;
        b=KAul3z8SPDvCmuRkShkwSAYyncl8n+Y8aF+R69/LSWJORXiqxJXT0yejzm+NEQDkLE
         t6XMWvR26sTdnxbfjDMBtb8TD3M1tVyKNaQ2W9aPUmkPj6+SZiSE4NbSGhwPW1MsiY4r
         qskod5yEvO3JHidMr0WUgvubmk0Tk0qFJzgxRFB094V1pqXpwKhV0axOytPe36EIf98T
         UR94D3FH3FBfXHll3IqhbONiV/s4cDUuRD++lew9Ac9nn4rlwkUWmrQmRRbtoT3bgKtW
         s14S18ehsANo8w05iW5AciznWDMGOPZD+KELx7M/nMZtxQlt5QnXlRGrRdWS2wuq/7GU
         iEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tLUZSgXbqOUuhFVQiMgZKVhpYys1gWWINbtrup0/G/o=;
        b=aQuHxPjS4QOA6AxDY4dgOfBfdU8DO7UwPqTXhCxm47JiMmfiFVGCEB/X08ykA2ye/j
         VcpTg0E8Yz7ifewnJB9Ziftjn9ncLH6DEByY71L9SU1vEgetZCKGIBEA0OZhPY2wCY+E
         tWq2BiWUu9gQblWu1w3oivR/m4+CL9PcDrBxGbBiEmxitZAQXuKoYarHVvmxXA3ryA4U
         O2RajF1UuxYZRCKWUOq1E4JjkMgbNSZ04BJkJMJv/2XfAnD4A10yGZlXzSiZV9R4ECGZ
         d1bnS+weLS3G0kAdAlEvqEdIv5h3W0iVe2DnDkAfiliC6LuPduES9UO40UV6Y9CwFGxG
         h1WA==
X-Gm-Message-State: APjAAAUz/Q3QcN8Etni3nbdcMclDeGkJyGQfiwnDpoxQTV8ZwkovmxQJ
        RyiaVBN42l6D1m87KZYS9VVfig==
X-Google-Smtp-Source: APXvYqx1eJ/oNU1f1SOytjZP3t4GhF3y1jfLon93bB37cyU25ZBXtB09S/H+4dsvD91pOlp1C3LXLw==
X-Received: by 2002:a2e:b4ee:: with SMTP id s14mr440548ljm.88.1571269021542;
        Wed, 16 Oct 2019 16:37:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n17sm142943ljc.44.2019.10.16.16.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 16:37:01 -0700 (PDT)
Date:   Wed, 16 Oct 2019 16:36:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, saeedm@mellanox.com,
        vishal@chelsio.com, vladbu@mellanox.com, ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at
 byte level
Message-ID: <20191016163651.230b60e1@cakuba.netronome.com>
In-Reply-To: <20191014221051.8084-4-pablo@netfilter.org>
References: <20191014221051.8084-1-pablo@netfilter.org>
        <20191014221051.8084-4-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 00:10:50 +0200, Pablo Neira Ayuso wrote:
> The flow mangle action is originally modeled after the tc pedit action,
> this has a number of shortcomings:
> 
> 1) The tc pedit offset must be set on the 32-bits boundaries. Many
>    protocol header field offsets are not aligned to 32-bits, eg. port
>    destination, port source and ethernet destination. This patch adjusts
>    the offset accordingly and trim off length in these case, so drivers get
>    an exact offset and length to the header fields.
> 
> 2) The maximum mangle length is one word of 32-bits, hence you need to
>    up to four actions to mangle an IPv6 address. This patch coalesces
>    consecutive tc pedit actions into one single action so drivers can
>    configure the IPv6 mangling in one go. Ethernet address fields now
>    require one single action instead of two too.
> 
> This patch finds the header field from the 32-bit offset and mask. If
> there is no matching header field, fall back to passing the original
> list of mangle actions to the driver.
> 
> The following drivers have been updated accordingly to use this new
> mangle action layout:
> 
> 1) The cxgb4 driver does not need to split protocol field matching
>    larger than one 32-bit words into multiple definitions. Instead one
>    single definition per protocol field is enough. Checking for
>    transport protocol ports is also simplified.
> 
> 2) The mlx5 driver logic to disallow IPv4 ttl and IPv6 hoplimit fields
>    becomes more simple too.
> 
> 3) The nfp driver uses the nfp_fl_set_helper() function to configure the
>    payload mangling. The memchr_inv() function is used to check for
>    proper initialization of the value and mask. The driver has been
>    updated to refer to the exact protocol header offsets too.
> 
> As a result, this patch reduces code complexity on the driver side at
> the cost of adding code to the core to perform offset and length
> adjustment; and to coalesce consecutive actions.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v5: add header field definitions to calculate header field from offset
>     and mask.

Let's see if I can recount the facts:
 (1) this is a "improvement" to simplify driver work but driver
     developers (Ed and I) don't like it;
 (2) it's supposed to simplify things yet it makes the code longer;
 (3) it causes loss of functionality (looks like a single u32 changing
     both sport and dport is rejected by the IR since it wouldn't
     match fields); 
 (4) at v5 it still is buggy (see below).

The motivation for this patch remains unclear.

You are posting new versions at a slow pace which makes it hard to
keep re-reviewing it (v1 on Aug 30th).

With that I'd like to one more time ask you to please stop reposting
this patch and post patches 1 and 2 as separate improvements.

>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts, bool rtnl_held)
>  {
>  	const struct tc_action *act;
> -	int i, j, k, err = 0;
> +	int i, j, err = 0;
>  
>  	if (!exts)
>  		return 0;
> @@ -3396,25 +3612,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  		} else if (is_tcf_tunnel_release(act)) {
>  			entry->id = FLOW_ACTION_TUNNEL_DECAP;
>  		} else if (is_tcf_pedit(act)) {
> -			for (k = 0; k < tcf_pedit_nkeys(act); k++) {
> -				switch (tcf_pedit_cmd(act, k)) {
> -				case TCA_PEDIT_KEY_EX_CMD_SET:
> -					entry->id = FLOW_ACTION_MANGLE;
> -					break;
> -				case TCA_PEDIT_KEY_EX_CMD_ADD:
> -					entry->id = FLOW_ACTION_ADD;
> -					break;
> -				default:
> -					err = -EOPNOTSUPP;
> -					goto err_out;
> -				}
> -				entry->mangle.htype = tcf_pedit_htype(act, k);
> -				entry->mangle.mask = ~tcf_pedit_mask(act, k);
> -				entry->mangle.val = tcf_pedit_val(act, k) &
> -							entry->mangle.mask;
> -				entry->mangle.offset = tcf_pedit_offset(act, k);
> -				entry = &flow_action->entries[++j];
> -			}
> +			j = flow_action_mangle(flow_action, act, j);
> +			if (j < 0)
> +				goto err_out;

Here we goto out without setting err, so return success even though the
actions didn't really get translated?

Any error from flow_action_mangle() seems to get effectively ignored?

>  		} else if (is_tcf_csum(act)) {
>  			entry->id = FLOW_ACTION_CSUM;
>  			entry->csum_flags = tcf_csum_update_flags(act);
> @@ -3468,9 +3668,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  			goto err_out;
>  		}
>  
> -		if (!is_tcf_pedit(act))
> -			j++;
> +		j++;
>  	}
> +	flow_action->num_entries = j;
>  
>  err_out:
>  	if (!rtnl_held)
