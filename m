Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034E11E9120
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgE3MVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 08:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgE3MVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 08:21:11 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB099C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 05:21:10 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e16so4229180qtg.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 05:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m8R71ySftzsLgshtWPzTAzLCjcMrMUXKRP3LftveCFo=;
        b=K6t2cRvl4qq68hbhMK1Aj2nWCJviIIvtZk1l1nvHn1jRtkdfxc6kl0SOwzNCmhSZ3i
         KYfkM3kAE+q4DbV+iLY3rCBV0Ia5P+QYfDuHN6DWft/4+g6q1aqOvWE021pG8JMm9ZXA
         ETNnzCRINM8blKXZUvEbHj+wM7L/S2m6TbQ8mbKxvNF9A2X9qfBqxkMXhat1fqPeeU3A
         Ushcj1dxjp5SjkrDiYhRcDPENaNa1EVjz+aFieMdkBezIyt80Cv+RXDg2y7EGGkTegsS
         49BYMzVEZl/vPxgrYIRm6uAItu4Og7LpyavIz3ZnEccNyrCEVTtQN3d+RCmbnTXk1gv2
         y93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m8R71ySftzsLgshtWPzTAzLCjcMrMUXKRP3LftveCFo=;
        b=OAw2wsEjFJh9l8BVDyhRmKOmUDjKg6+gkkfobuZFoZY5CHnb6zuxqklDrKhkwheNgG
         RFvu5BHQF+j2Pkj0wxFVaGRK5nq0fmVZKY8v1Z8dwYwIR0tWGiocGnZXlc4VzK3rHTcJ
         KVdy8hh55QmSWUX1oVUUyAJ8WqIp6y3YyKxWsTb8GZtzylKPO8b6J5ZgItF3hDlowC/5
         yx9e+LBZJg+IlLIUhQddwv4hR4FAvL9HjQBYEAVzM1V+xowyE2am8T/HuNsECJ7WoD3z
         RM1MzJC3VaMvHYvmHt5xXy3HwgO+/uRwGl6aAJIH5zZpNvRR0WAvyVy2SXSVDPmBGW16
         9prg==
X-Gm-Message-State: AOAM532iNc8njxS2i/f5k27K/JZ6fKNuO6j5d/S6TvldJzj2H3x2PJVs
        HUkUJj5ayoU82KEE2XPVQR9bpUVqEIE=
X-Google-Smtp-Source: ABdhPJxus+hc9mSGblqG4UcP90KvbmPajE6REizzOH/fhqyM1mW/7Se2glzyv3ptzcZ9wrNF87syHw==
X-Received: by 2002:ac8:312e:: with SMTP id g43mr13471302qtb.308.1590841268692;
        Sat, 30 May 2020 05:21:08 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:516d:2604:bfa5:7157:afa1])
        by smtp.gmail.com with ESMTPSA id j90sm10143664qte.33.2020.05.30.05.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 05:21:07 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4BE84C1B84; Sat, 30 May 2020 09:21:05 -0300 (-03)
Date:   Sat, 30 May 2020 09:21:05 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net/sched: act_ct: add nat mangle action only for
 NAT-conntrack
Message-ID: <20200530122105.GM2491@localhost.localdomain>
References: <1590818091-3548-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590818091-3548-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 01:54:51PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently add nat mangle action with comparing invert and ori tuple.
                                                Nit, "orig" ---^

> It is better to check IPS_NAT_MASK flags first to avoid non necessary
> memcmp for non-NAT conntrack.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sched/act_ct.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 1a76639..2057735 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -199,6 +199,9 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
>  	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
>  	struct nf_conntrack_tuple target;
>  
> +	if (!(ct->status & IPS_NAT_MASK))
> +		return 0;
> +
>  	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
>  
>  	switch (tuple->src.l3num) {
> -- 
> 1.8.3.1
> 
