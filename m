Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7181CB23E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 01:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfJCXRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 19:17:38 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36625 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfJCXRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 19:17:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id y189so4146210qkc.3
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9ZVLY2HvhTlLb0xV1IdoghTmpYsvGhnKq7pTUJcXu04=;
        b=GFeEA6dN1Id3Q9DRIFb9v/QiQqba5SgqhPiQjcbMV6xmklR0U/frPk9r1RQV+CpIpi
         bmmaIuPen9+oxKBl84KaUqqZDtSz+HHBG8jeK8t+hYINugoYpC/EhqX9ceuSFvNP63m0
         /jYtqGOsgmoO4O2HBQ+NIEZ0sJInoo1YtDgRPEZdjX8wbPzfZJ/5lwwiTMS38e7XgkrH
         jgXiUe5qnFTFqbi4bO+Zbavq5XWlnL8L9TF08TYMO84Ly7oQ1MSNlSX7BMn5zD4WhC0t
         fi72f7O56DXwI056bnJGif1rfSVhgAiuu6sGgFzN/MNZ+O96H21rOHqvp80Qtazuc9rO
         Jp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9ZVLY2HvhTlLb0xV1IdoghTmpYsvGhnKq7pTUJcXu04=;
        b=GwpaMx3mM/0BlsnLtyb8PQ/ulC/ilM+nxUOavgcny3FkRiCONY5Zebli8O+bVyMx2d
         unTE4gT1J47k59ipx/d1s/WEQ2HpCv5ElM5gnqPLFJp9KqFKxVHu9DkpodoydgHVGbdi
         duOfm1tD9sWqQtJCVJc17CfgbPl52oqN2saaiQF51eBCnH7pki4FUXw7yUYfyBpFXSyW
         hNWMWLLBa80fP6DZjj1FPrlGxM6BPNkwM/vs9ywibrz8xbBKhPof6005OV94RBWNyaGL
         E4HbumHrq33qeAIJCD9hb6+sXRbHCK26G8cqiTxzEgRVzATNrCYHo6XEGZK1Z3l5qr8r
         VFtQ==
X-Gm-Message-State: APjAAAWWxA/JZVfZzAUpXxAeoC8gzP64rfODaLv7iw3kNaxIrSXMoWtV
        EUb3COBsKkfJ1pqSPqhwHORXyg==
X-Google-Smtp-Source: APXvYqxSd6RDC7DQLWbfAfhnwt5n/H1hZMDXSCfgGUJ8m87fvnDFuX5GZp0ImOOxuJA/G2FsRH1fuQ==
X-Received: by 2002:a37:a704:: with SMTP id q4mr6773822qke.385.1570144657343;
        Thu, 03 Oct 2019 16:17:37 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j80sm2124320qke.94.2019.10.03.16.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 16:17:37 -0700 (PDT)
Date:   Thu, 3 Oct 2019 16:17:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 11/15] netdevsim: implement proper devlink
 reload
Message-ID: <20191003161730.6c61b48c@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003094940.9797-12-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-12-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 11:49:36 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> During devlink reload, all driver objects should be reinstantiated with
> the exception of devlink instance and devlink resources and params.
> Move existing devlink_resource_size_get() calls into fib_create() just
> before fib notifier is registered. Also, make sure that extack is
> propagated down to fib_notifier_register() call.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

> diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
> index d2aeac0f4c2c..fdc682f3a09a 100644
> --- a/drivers/net/netdevsim/fib.c
> +++ b/drivers/net/netdevsim/fib.c
> @@ -63,12 +63,10 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
>  	return max ? entry->max : entry->num;
>  }
>  
> -int nsim_fib_set_max(struct nsim_fib_data *fib_data,
> -		     enum nsim_resource_id res_id, u64 val,
> -		     struct netlink_ext_ack *extack)
> +static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
> +			     enum nsim_resource_id res_id, u64 val)
>  {
>  	struct nsim_fib_entry *entry;
> -	int err = 0;
>  
>  	switch (res_id) {
>  	case NSIM_RESOURCE_IPV4_FIB:
> @@ -84,20 +82,10 @@ int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>  		entry = &fib_data->ipv6.rules;
>  		break;
>  	default:
> -		return 0;
> -	}
> -
> -	/* not allowing a new max to be less than curren occupancy
> -	 * --> no means of evicting entries
> -	 */
> -	if (val < entry->num) {
> -		NL_SET_ERR_MSG_MOD(extack, "New size is less than current occupancy");
> -		err = -EINVAL;

This change in behaviour should perhaps be mentioned in the commit
message. The reload will no longer fail if the resources are
insufficient. 

Since we want to test reload more widely than just for the FIB limits
that does make sense to me. Is that the thinking?

> -	} else {
> -		entry->max = val;
> +		WARN_ON(1);
> +		return;
>  	}
> -
> -	return err;
> +	entry->max = val;
>  }
>  
>  static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
