Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289E766722E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjALM1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjALM1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:27:35 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EAA46E
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:27:34 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m6so28169138lfj.11
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kVR6rvrnzsGnhGbpjpBnmpLeWbhPVO9c3j4pZ6WkFiY=;
        b=qP+pXPx/WplFKYA2b62plWJEtiAUkjD70KrFPhQuSn4RxR3E8XJPLUnej15zUzji46
         ID0EjL8oXgH2d5YRMShAn/TDkjhZojnq66g72EsM+FiN0r8qxkiRCn76L2AnbigYnUow
         5HATB8lrsHoY9RAC+w9sF01kTt+amR7OUP18cSYQYi8zRTGqM9R0cd9HW5DGNoi0Lj/a
         t6GMjkMga/E9mXRxssUqXhtDXby+ewQLqzgd+vebLaH1WdYZwxrMiblAYDDhmAWhNe9x
         EXTuSL4kdyInWx2Cl+ltVBDfa0K/CC7BCAGkFZHLxvifQJAxUwIRefxvPx8RLaS6h/4u
         tUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVR6rvrnzsGnhGbpjpBnmpLeWbhPVO9c3j4pZ6WkFiY=;
        b=ih2x6RwWN0/NamYl8Cy4tNm1q4bBdKd8qMACPscA5toyS1NgghQSlA22I2IJmMQMZf
         I+w6II3HTEY+YfWiyEPdrDCo+bPO6xlfQkglxEklyGo6KhedlvknWfKokzNBdrNa+5ZY
         F9Hs515NHeoGaPbHlLWujgO1Xw4Q0ZiFTnNn09McfIAGaw21tvJlaoAbOJjNJ0NZawc3
         aXYaD7CMUcHNCLUbCEb+A/ed82kNJIPSBfky28lCQWNYKqkgmV0sPRCs/4RahgLwEgXQ
         EQu7OSeVLLDWnYYBZDnX1408CWtlc+jLDMDZPeutvyqFkOHPn3gCdwSvgKD9ryXMv0wL
         y6Ig==
X-Gm-Message-State: AFqh2ko3y57aVyDgPMxtRFvUoX1uDaABgBqGivWLofUQLZMvY4MZMOAt
        RTMRI0N8xZidg0D1sbdrl5o=
X-Google-Smtp-Source: AMrXdXvoIqBMI1bEY4XH4c/0Vv4yc0dupIcg/AKTE8dK+WaS8vgEgs1SB/MplAz3xvVuh8arD4pVtw==
X-Received: by 2002:a05:6512:25e:b0:4b4:96ca:7280 with SMTP id b30-20020a056512025e00b004b496ca7280mr20026910lfo.37.1673526452516;
        Thu, 12 Jan 2023 04:27:32 -0800 (PST)
Received: from localhost (tor-project-exit3.dotsrc.org. [185.129.61.3])
        by smtp.gmail.com with ESMTPSA id u10-20020a19790a000000b004cb1135953fsm3218517lfc.240.2023.01.12.04.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 04:27:31 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:27:25 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v2] sch_htb: Avoid grafting on
 htb_destroy_class_offload when destroying htb
Message-ID: <Y7/8rXHmchlG2qqE@mail.gmail.com>
References: <20230111203732.51363-1-rrameshbabu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111203732.51363-1-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 12:37:33PM -0800, Rahul Rameshbabu wrote:
> When destroying the htb, the caller may already have grafted a new qdisc
> that is not part of the htb structure being destroyed.
> htb_destroy_class_offload should not peek at the qdisc of the netdev queue.
> Peek at old qdisc and graft only when deleting a leaf class in the htb,
> rather than when deleting the htb itself.
> 
> This fix resolves two use cases.
> 
>   1. Using tc to destroy the htb.
>   2. Using tc to replace the htb with another qdisc (which also leads to
>      the htb being destroyed).

Please elaborate in the commit message what exactly was broken in these
cases, i.e. premature dev_activate in both cases, and also accidental
overwriting of the qdisc in case 2.

> 
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---
>  net/sched/sch_htb.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 2238edece1a4..360ce8616fd2 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1557,14 +1557,13 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>  
>  	WARN_ON(!q);
>  	dev_queue = htb_offload_get_queue(cl);
> -	old = htb_graft_helper(dev_queue, NULL);
> -	if (destroying)
> -		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
> -		 * all queues.
> +	if (!destroying) {
> +		old = htb_graft_helper(dev_queue, NULL);
> +		/* Last qdisc grafted should be the same as cl->leaf.q when
> +		 * calling htb_destroy

Did you mean "when calling htb_delete"?

Worth also commenting that on destroying, graft is done by qdisc_graft,
and the latter also qdisc_puts the old one. Just to explain why we skip
steps on destroying.

>  		 */
> -		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
> -	else
>  		WARN_ON(old != q);
> +	}
>  
>  	if (cl->parent) {
>  		_bstats_update(&cl->parent->bstats_bias,
> @@ -1581,10 +1580,14 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>  	};
>  	err = htb_offload(qdisc_dev(sch), &offload_opt);
>  
> -	if (!err || destroying)
> -		qdisc_put(old);
> -	else
> -		htb_graft_helper(dev_queue, old);
> +	/* htb_offload related errors when destroying cannot be handled */
> +	WARN_ON(err && destroying);

Not sure whether we want to WARN on this error...

On destroying, we call htb_offload with TC_HTB_LEAF_DEL_LAST_FORCE,
which makes the mlx5e driver proceed with deleting the node even if it
failed to create a replacement node. Normally it cancels the deletion to
keep the integrity of hardware structures, but on htb_destroy it doesn't
matter, because everything is going to be torn down anyway. An error is
still returned by the driver, but it's safe to ignore it, not worth a
WARN at all.

Another error flow, when the firmware command to delete a node fails for
some reason, doesn't even lead to returning an error, because the worst
that happens is a leak of hardware resources, and we can't do anything
meaningful about it at that stage.

So, I don't think this WARN_ON is helpful, unless you also want to
change the way mlx5e returns errors.

> +	if (!destroying) {
> +		if (!err)
> +			qdisc_put(old);
> +		else
> +			htb_graft_helper(dev_queue, old);
> +	}

Looks good. I also suggest removing NULL-initialization of old to make
sure one will get a compiler warning about an uninitialized variable if
one changes the code in the future and accidentally uses old in the
destroying flow.

>  
>  	if (last_child)
>  		return err;
> -- 
> 2.36.2
> 
> Previous related discussions
> 
> [1] https://lore.kernel.org/netdev/20230110202003.25452-1-rrameshbabu@nvidia.com/
> [2] https://lore.kernel.org/netdev/20230104174744.22280-1-rrameshbabu@nvidia.com/
> [3] https://lore.kernel.org/all/CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com/
