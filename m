Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68D81E85F6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgE2R4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2R4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:56:54 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2D5C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:56:54 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c12so2607033qtq.11
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fj/kQx45CgM35F5XJBtYkK1oM2Athmr6N7olbXmuUr4=;
        b=BokQQbDUA4t5HSJpFH1KIgXouLgbBhEdDHOyHwM52pAHcTfWICRFk+4k+TWhJh5FhJ
         utTX9x/6iXl7npt0ymSBPhM9gxDD3h6SuFO/TMoUXQ2XICG8/bNfFvFjXRr1QMUQpROc
         MnOofkxot08ONtPYLQbUO2OfoQ2gLQZUxlwSORthKuLXkb2j0NnOnyXL4XI6Xzzo2grC
         olGKy5IX3Y23f/pXwFQj3Kvh+eZ8OnI/CYND2ns1jdiJmeVuctBRhc7wD2lRQ+oY6obC
         qUuQbiokZpPHSIC0h0q1VaKyde9Mp82CctluM8mUQStXw8bjPQ+beJSvqeWj7+4cyytr
         GYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fj/kQx45CgM35F5XJBtYkK1oM2Athmr6N7olbXmuUr4=;
        b=MaDUx9Y/niMpEso1U07tr0KI3ZpC9gQ9mF5s6rhOzOZd4+9EhRPl9FH1e2L5EmW40U
         DXxpGjoKAbL5dfIBHTo3CyHHx5ccr9nluL1uZOoHiXtcXLHky+a0Ohee3PovkHArxQbo
         M85GE3OCP/q90QuzJBFaNCl9aXP4jcLSFMZ40EI0fgQJfUuO9TQqFkFU52WM63vBMjuj
         tB2CFe+4cdoA4kJ4EKVqcU9Rft4j+RsWdUHLbxCWc3cbA1hYxO9oCJfAXLxKkLEBKEAY
         T/aCuLm3lOPbT8jLMRxed6JPPkW5SHThVoEsbEdGN62LFsIzkwr47DhgYvjGDx+sjDUh
         lt+A==
X-Gm-Message-State: AOAM531f4P/T8neW5Pfyw03shlt8S1tnxG3Wa1S3/Sd7bSIMljxhuqU8
        73+5pXVSRwL5i4vRQrToAfU=
X-Google-Smtp-Source: ABdhPJyraWT0eTAlezNbtN+8+JE7tkt2FJx+VA6frf7d/S31Kg7/T3YVD/aJwnusJURNC3mCftuN8w==
X-Received: by 2002:ac8:bc4:: with SMTP id p4mr10198352qti.72.1590775013617;
        Fri, 29 May 2020 10:56:53 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id r13sm3910280qtp.38.2020.05.29.10.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 10:56:52 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 57AACC1B84; Fri, 29 May 2020 14:56:50 -0300 (-03)
Date:   Fri, 29 May 2020 14:56:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     paulb@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net/sched: act_ct: add nat mangle action only for
 NAT-conntrack
Message-ID: <20200529175650.GF74252@localhost.localdomain>
References: <1590725265-17136-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590725265-17136-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:07:45PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently add nat mangle action with comparing invert and ori tuple.
> It is better to check IPS_NAT_MASK flags first to avoid non necessary
> memcmp for non-NAT conntrack.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/sched/act_ct.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index c50a86a..d621152 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -198,18 +198,21 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
>  					    struct flow_action *action)
>  {
>  	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
> +	bool nat = ct->status & IPS_NAT_MASK;
>  	struct nf_conntrack_tuple target;

[A]

>  
>  	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
>  
>  	switch (tuple->src.l3num) {
>  	case NFPROTO_IPV4:
> -		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
> -						      action);
> +		if (nat)

Why do the same check multiple times, on all actions? As no other
action is performed if not doing a nat, seems at [A] above, it could
just:

if (!nat)
	return 0;

> +			tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
> +							      action);
>  		break;
>  	case NFPROTO_IPV6:
> -		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
> -						      action);
> +		if (nat)
> +			tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
> +							      action);
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> @@ -217,10 +220,14 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
>  
>  	switch (nf_ct_protonum(ct)) {
>  	case IPPROTO_TCP:
> -		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action);
> +		if (nat)
> +			tcf_ct_flow_table_add_action_nat_tcp(tuple, target,
> +							     action);
>  		break;
>  	case IPPROTO_UDP:
> -		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
> +		if (nat)
> +			tcf_ct_flow_table_add_action_nat_udp(tuple, target,
> +							     action);
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> -- 
> 1.8.3.1
> 
