Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176D15D6AB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfGBTO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:14:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41142 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:14:57 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so19836104qtj.8;
        Tue, 02 Jul 2019 12:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e5unW9lLl9uq+mR99M6ARNOqSRJfUUEv53dLr0zCGJY=;
        b=p214pIWQyhKnHj/PInRopNuCY8kGdEkzC+v8uT18rbmQyW/a3VSBFvkQh87xeFQIZV
         tDe9GuS83REUmZX05GXPaZIFN+rfTKnnfenta5n1o5iE+/5C+A+NwS8YJ8LEGREeteTz
         RM7Cr1r8SbOUBjM5kaoxnZzdm3YnxwrpWNdxTbz587RL1uMpaGkaHz7oA3CaZTZH1DrN
         epUWjHsedUTvjX4uyz9HiZWH6CKI/Cj2FVHCzPZ8khMxGgPoTEaHvYDnlzbnG/TmLLNm
         6dX/odzZDOx+9ErO9cKeJs9A04LlOo2I3pQgF4ko3VzWMhSpvmuTHKWsCEzMwoA1mJc8
         QRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e5unW9lLl9uq+mR99M6ARNOqSRJfUUEv53dLr0zCGJY=;
        b=piQ60fK5gP7Pbc6A4tgdh6PcoAvaR0krUEzWSauo6Gp+yRUaq2aefYeObhRaBFgsjE
         kS2lxN1FaY3Fmnm5w+v3CeMIaeZ7ZL0bRPqTE6yThZ1sFrHs1nIzLfem/yWi3BIJMzAX
         4JyHzYzGiM7811GxuC+Pd1T6/gW8nmmSZdIAuWQ0rluqa3uAQEYkd5obDEe7ZSJoGxch
         wmAHvq4WH2dUV2eyTfN98a/juwGyENlziRjxHszchxXG7tA4AUr3pakMCxJfGbukYgmg
         a2bgvwW03xpCf2pKyCWFatuZQFdiNwB+tVpe5iTNje4nnTfdWnkajGirU8Di1Sh/d4Wa
         Ykow==
X-Gm-Message-State: APjAAAVmjwUFdVlmUsiWhXinue6VHiv0Fiqq1ME82XPMcB++vmMyG3O7
        zw55EM+6nca61NlXFQFU4J4=
X-Google-Smtp-Source: APXvYqznhmtQAfiMQarM6DIB+CMh0+0qU3V2pBXMntAtT8j8TsyTuycoit/tEsXb8tu1rciYgEudug==
X-Received: by 2002:a0c:983b:: with SMTP id c56mr28567273qvd.131.1562094895965;
        Tue, 02 Jul 2019 12:14:55 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.139])
        by smtp.gmail.com with ESMTPSA id a19sm7411636qka.103.2019.07.02.12.14.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:14:55 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7B21BC0D87; Tue,  2 Jul 2019 16:14:52 -0300 (-03)
Date:   Tue, 2 Jul 2019 16:14:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, cphealy@gmail.com
Subject: Re: [PATCH net-next 02/12] net: sched: add tcf_block_cb_alloc()
Message-ID: <20190702191452.GB2746@localhost.localdomain>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-3-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 09:49:07PM +0200, Pablo Neira Ayuso wrote:
> Add a new helper function to allocate tcf_block_cb objects.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/pkt_cls.h |  8 ++++++++
>  net/sched/cls_api.c   | 23 +++++++++++++++++++----
>  2 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 720f2b32fc2f..276a17a3547b 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -72,6 +72,8 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
>  	return block->q;
>  }
>  
> +struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
> +					void *cb_ident, void *cb_priv);
>  void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
>  struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
>  					 tc_setup_cb_t *cb, void *cb_ident);
> @@ -150,6 +152,12 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
>  {
>  }
>  
> +static inline struct tcf_block_cb *
> +tcf_block_cb_alloc(tc_setup_cb_t *cb, void *cb_ident, void *cb_priv)
> +{
> +	return NULL;

[A] This...

> +}
> +
>  static inline
>  void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
>  {
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index b2417fda26ec..c01d825edab5 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -746,6 +746,23 @@ unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
>  }
>  EXPORT_SYMBOL(tcf_block_cb_decref);
>  
> +struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
> +					void *cb_ident, void *cb_priv)
> +{
> +	struct tcf_block_cb *block_cb;
> +
> +	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
> +	if (!block_cb)
> +		return NULL;
> +
> +	block_cb->cb = cb;
> +	block_cb->cb_ident = cb_ident;
> +	block_cb->cb_priv = cb_priv;
> +
> +	return block_cb;
> +}
> +EXPORT_SYMBOL(tcf_block_cb_alloc);
> +
>  struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
>  					     tc_setup_cb_t *cb, void *cb_ident,
>  					     void *cb_priv,
> @@ -761,12 +778,10 @@ struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
>  	if (err)
>  		return ERR_PTR(err);
>  
> -	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
> +	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv);
>  	if (!block_cb)
>  		return ERR_PTR(-ENOMEM);

... will be translated into -ENOMEM here.
Would be nice to in [A] return ERR_PTR(-EOPNOTSUPP) instead and adjust
the actual implementation as well.
With patch 11, this will be visible to the user then.

> -	block_cb->cb = cb;
> -	block_cb->cb_ident = cb_ident;
> -	block_cb->cb_priv = cb_priv;
> +
>  	list_add(&block_cb->list, &block->cb_list);
>  	return block_cb;
>  }
> -- 
> 2.11.0
> 
