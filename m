Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA11A230C9F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 16:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgG1Omy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 10:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbgG1Omx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 10:42:53 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64E7C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 07:42:53 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d27so14974579qtg.4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 07:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7YXrW6xlu/YLnX7CP0zyk8YRXkA9rF1jcVRuZgIpjcM=;
        b=KSfxVp0i7oqe3cw/gxthxJA77v4C9XGrOubNBzE3zEGb8z+EGOSvFdmM60wEht1BAr
         vWEZkfj+d8UbjTuulEb4wz1tpNbMJeV1etWlBoEZ6pT9t6rP0zbJk7nwIwVX6pGTZU7X
         2BKgtyxMhKkdO3oqXYEPXbXpCirtLbm/mFxxb068FrjVrhPKV2K4nTBGk8kOQ2r/VJYS
         y+7RCrcFyTXXa+4ArTW5KlKXOSRrTaCl9zg2HV3mjuEzcxRP4za+ZvRKrBUgLWMZZdbk
         ES+/f2jUyRZecu5J7rutzarOBt+HtHoqm2K1XFGUzPPhOhbKaXXm43O9GsuMEZQwik4E
         aSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7YXrW6xlu/YLnX7CP0zyk8YRXkA9rF1jcVRuZgIpjcM=;
        b=PyvqhXr/9SZ5NBDHA7jP+XE058krH4B3y4fsiv7NRDAkTSSfLKzdwvlY5n86uaAS1I
         DqNLaqdoeDnrejxuLmRs9+nJhhVbWXLRxUf3iFQxJeCLz3wPfUP+wSW4cLslph/xlzVb
         vCQL7WKoo5bBnbA4HQ5Y7V1BIroINBLoZhsYZ2mAPVofFJr0556sujkpi3bojtZfr6ia
         B2lQJ3ofwUBgF9ZtAs2XWmPOBqyfl/SU+udYF57NdeVt07DOwRL0NFlfBaKEgeQPDzHR
         VFlQS1YRFUaqF5jOopsfsxjcZ2SS/tjc5j34u1K5c0xOEE4cBaiFa0aE3XO4pBldLO0W
         BtAg==
X-Gm-Message-State: AOAM531plx56ZyKsD+QRXSPn78Q28NJrGXMg5wKHy6XlxEtURiOEDtfc
        WbDogBPyO3b7LaA2SPYAoOs=
X-Google-Smtp-Source: ABdhPJxXKfUjVQryQj8trbVvhXam4Dl66ifxytdvKb+rIjyU3p69Jdeat2UFOBMz59yZOOgP7bPFDQ==
X-Received: by 2002:ac8:2a4a:: with SMTP id l10mr27797123qtl.136.1595947372944;
        Tue, 28 Jul 2020 07:42:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:ca23:d22f:1490:8577:8486])
        by smtp.gmail.com with ESMTPSA id n85sm7745141qkn.80.2020.07.28.07.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 07:42:52 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9AF26C0EB8; Tue, 28 Jul 2020 11:42:49 -0300 (-03)
Date:   Tue, 28 Jul 2020 11:42:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net 2/2] net/sched: act_ct: Set offload timeout when
 setting the offload bit
Message-ID: <20200728144249.GC3398@localhost.localdomain>
References: <20200728115759.426667-1-roid@mellanox.com>
 <20200728115759.426667-3-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728115759.426667-3-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 02:57:59PM +0300, Roi Dayan wrote:
> On heavily loaded systems the GC can take time to go over all existing
> conns and reset their timeout. At that time other calls like from
> nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
> expired. To fix this when we set the offload bit we should also reset
> the timeout instead of counting on GC to finish first iteration over
> all conns before the initial timeout.
> 
> Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> ---
>  net/sched/act_ct.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index e9f3576cbf71..650c2d78a346 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -366,6 +366,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,

Extra context line:
	err = flow_offload_add(&ct_ft->nf_ft, entry);
>  	if (err)
>  		goto err_add;
>  
> +	nf_ct_offload_timeout(ct);
> +

What about adding this to flow_offload_add() instead?
It is already adjusting the flow_offload timeout there and then it
also effective for nft.

>  	return;
>  
>  err_add:
> -- 
> 2.8.4
> 
