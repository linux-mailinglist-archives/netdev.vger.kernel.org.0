Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172D243A56
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfFMPUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:20:24 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46566 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732110AbfFMMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:55:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id x18so627954qkn.13
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 05:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VjHyje3i+R9V4YmkpxZlCxUKXkf8n178O2ZkudSTUw4=;
        b=hstNXNe7KaQuh3GlfK43iZJi99SpuTltsIxRa5oe8oFZXMEgXbxFY6A+68Q1gIwxzx
         RAimge30JYT/Z3ynC/3vQRkAnDg9fj4ppj8LBNZ5NtJpxqc0IxAov/imD50b8//6Si56
         ExL0pVpX7FoJqzZAAh3FybsRD7iwk4TH+5/FP89Y8PVhPH9aDPz55HyJNVcNzoDxanNJ
         NbrERv+aTZVXQpcap3l1S6afweQtLv1RtKas+bJkqIBtA9kCFqRdZZJvvpgRBrGvBqCY
         enyPTWl0+l5QLmzOATrasAohUMiGYtqv28NLnqu8iq+dL9VBSKblWhKY9AkoqAoVIlwZ
         3RnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VjHyje3i+R9V4YmkpxZlCxUKXkf8n178O2ZkudSTUw4=;
        b=azYJj9MnY7V9EpcuDSOwtDaLOBvGPnswYI/+hucpmmtlpPeL2wbKmNqd7HovhSG14V
         tZpBFr/Ou42wJFGLp8YxwIWSC+ZXvvgq+q/zhCHKiHDam6yaGzlvNvUPBcoxJpG5l5QO
         omRWiy3ZoIabt0n9DldT0f5fXL6DkeeXbTouaBxEcDf9d/F5j2yXsO6+dfRwd37YM26b
         T56JUW5D7qLEfF2umF1gKkLhwYsmyviGYVXfX3rxAuRnfwiKOjXaM1o2taB5SA6auSEW
         +Q5anoGeB/S6jSDqWwtF56tkMMhJpHdD0FwlfwZ3qL5bsOeIoocaoD/ncHtuvz+JRvjG
         5qQg==
X-Gm-Message-State: APjAAAXCohpy/YyC+e3ajtOmvrJH8wazPl2cGBEhcSHq9rGRU/mumDnM
        GevPO/bV2F37/s3JxbxkygTy2oLFkMBltA==
X-Google-Smtp-Source: APXvYqyfb0ZYcbbXnaUSEs/gKyxgPyl0TY7xHH8qyByKdVeLuGcY+Msf9kDZpv0LPFnVkBiJw9PtjQ==
X-Received: by 2002:a37:d16:: with SMTP id 22mr52066690qkn.232.1560430527120;
        Thu, 13 Jun 2019 05:55:27 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:278e:68eb:7f4f:8f57:4b3a])
        by smtp.gmail.com with ESMTPSA id s125sm1329900qkc.43.2019.06.13.05.55.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 05:55:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0E58AC1BC7; Thu, 13 Jun 2019 09:55:24 -0300 (-03)
Date:   Thu, 13 Jun 2019 09:55:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     mkubecek@suse.cz, dcaratti@redhat.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, johannes@sipsolutions.net,
        john.hurley@netronome.com, netdev@vger.kernel.org,
        paulb@mellanox.com, toke@redhat.com
Subject: Re: [RFC PATCH net-next] sched: act_ctinfo: use extack error
 reporting
Message-ID: <20190613125523.GG3436@localhost.localdomain>
References: <20190612191859.GJ31797@unicorn.suse.cz>
 <20190613111851.55795-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613111851.55795-1-ldir@darbyshire-bryant.me.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 01:18:52PM +0200, Kevin Darbyshire-Bryant wrote:
> Use extack error reporting mechanism in addition to returning -EINVAL
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Nice. LGTM!

> ---
>  net/sched/act_ctinfo.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
> index e78b60e47c0f..a7d3679d7e2e 100644
> --- a/net/sched/act_ctinfo.c
> +++ b/net/sched/act_ctinfo.c
> @@ -165,15 +165,20 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>  	u8 dscpmaskshift;
>  	int ret = 0, err;
>  
> -	if (!nla)
> +	if (!nla) {
> +		NL_SET_ERR_MSG_MOD(extack, "ctinfo requires attributes to be passed");
>  		return -EINVAL;
> +	}
>  
> -	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
> +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, extack);
>  	if (err < 0)
>  		return err;
>  
> -	if (!tb[TCA_CTINFO_ACT])
> +	if (!tb[TCA_CTINFO_ACT]) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Missing required TCA_CTINFO_ACT attribute");
>  		return -EINVAL;
> +	}
>  	actparm = nla_data(tb[TCA_CTINFO_ACT]);
>  
>  	/* do some basic validation here before dynamically allocating things */
> @@ -182,13 +187,21 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>  		dscpmask = nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_MASK]);
>  		/* need contiguous 6 bit mask */
>  		dscpmaskshift = dscpmask ? __ffs(dscpmask) : 0;
> -		if ((~0 & (dscpmask >> dscpmaskshift)) != 0x3f)
> +		if ((~0 & (dscpmask >> dscpmaskshift)) != 0x3f) {
> +			NL_SET_ERR_MSG_ATTR(extack,
> +					    tb[TCA_CTINFO_PARMS_DSCP_MASK],
> +					    "dscp mask must be 6 contiguous bits");
>  			return -EINVAL;
> +		}
>  		dscpstatemask = tb[TCA_CTINFO_PARMS_DSCP_STATEMASK] ?
>  			nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) : 0;
>  		/* mask & statemask must not overlap */
> -		if (dscpmask & dscpstatemask)
> +		if (dscpmask & dscpstatemask) {
> +			NL_SET_ERR_MSG_ATTR(extack,
> +					    tb[TCA_CTINFO_PARMS_DSCP_STATEMASK],
> +					    "dscp statemask must not overlap dscp mask");
>  			return -EINVAL;
> +		}
>  	}
>  
>  	/* done the validation:now to the actual action allocation */
> -- 
> 2.20.1 (Apple Git-117)
> 
