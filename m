Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0860D4D2C71
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiCIJsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiCIJr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:47:59 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F938169230
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:46:59 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id q5so2187021ljb.11
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OIfAuT6YNE8NGkL8XN7GggHrn6CO/cybivtUIaLshhw=;
        b=O8UbKb5uabc61APjtD0gOoeCaZ5LM75A4APq2KQgRwxHp6RpbNUuBAysSRxq/K6UV2
         D5Vl/zGOaH+WiituOEZJOC9oNvccyTVa94CmDH4RsL/H1a9Z6bKrRFrJidU9hjiWGW7t
         E0vK07enAr/nRAobtKonD6z2G+csehx+oW6H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIfAuT6YNE8NGkL8XN7GggHrn6CO/cybivtUIaLshhw=;
        b=tPf+PFb1mTJqAfzulmES3u0NCX4qBDBmcPPLuS1wWpulGozxoij2yl3pAfvniczyWV
         jFsPrQLDY16AKg23HK5LF+/hbiB3+41fCe+dK4FRSVse3UBy3lfbq8NDnwyi3ZhYsXKb
         COloK4ceCVawPBPBUNKbPphym1wTeJ+WUEUZss6VHgBpngqOFQVotQ+ms0tLia+MiQsO
         ABX4kGL+ZyKGB5hlGKw1VgPcZ9foyt9AYg+pNtPYgNN9iWo4RvGghQ12sQSNrfWly0PL
         ploom8o0qsviKn0mrhwsaGWsWtNt440nxSx5VIMKwjUvs4IkWF8DSc93cnR6ux9tFA2N
         0bhA==
X-Gm-Message-State: AOAM531uONGITb0Hx/G0VbCsbQOgzZizQrhYxdQCK8qPX5sy9Veiwf7v
        XISrhcBoCoB7oR40Im/cU8aGdVQAYuWodCU6YwBDKtzDAMUYoA==
X-Google-Smtp-Source: ABdhPJzjr7prweZBZSj2ZIlp8wGBiqnXNLCwiLV9S0y24yW5kYAIAPdsSnRZm1oNr78+z1y6jp00mh36nGOGjPqgrJg=
X-Received: by 2002:a05:651c:19a4:b0:247:df0d:17f8 with SMTP id
 bx36-20020a05651c19a400b00247df0d17f8mr11362648ljb.100.1646819217559; Wed, 09
 Mar 2022 01:46:57 -0800 (PST)
MIME-Version: 1.0
References: <20220308045321.2843-1-dmichail@fungible.com> <20220308221407.5f26332b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308221407.5f26332b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 9 Mar 2022 01:46:44 -0800
Message-ID: <CAOkoqZ=mPesf-PYDW-Aoq=nMrdfY-RDdJGgWYk48oja_OVxoNw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/fungible: Fix local_memory_node error
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 10:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  7 Mar 2022 20:53:21 -0800 Dimitris Michailidis wrote:
> > Stephen Rothwell reported the following failure on powerpc:
> >
> > ERROR: modpost: ".local_memory_node"
> > [drivers/net/ethernet/fungible/funeth/funeth.ko] undefined!
> >
> > AFAICS this is because local_memory_node() is a non-inline non-exported
> > function when CONFIG_HAVE_MEMORYLESS_NODES=y. It is also the wrong API
> > to get a CPU's memory node. Use cpu_to_mem() in the two spots it's used.
>
> Can the ids actually not match? I'm asking because nobody else is doing
> the cpu -> mem node conversions.

They can differ if CONFIG_HAVE_MEMORYLESS_NODES=y and the machine has
memoryless nodes. That config is only offered by IA64 and powerpc so I
guess there are just a few machines where they can differ. It is true
that cpu_to_mem() calls aren't common but the related call
numa_mem_id(), the special case for the local CPU, is easier to find.
For example, page pools's default preferred node is numa_mem_id()
rather than numa_node_id().

> > Fixes: ee6373ddf3a9 ("net/funeth: probing and netdev ops")
> > Fixes: db37bc177dae ("net/funeth: add the data path")
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> > ---
> >  drivers/net/ethernet/fungible/funeth/funeth_main.c | 2 +-
> >  drivers/net/ethernet/fungible/funeth/funeth_txrx.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
> > index c58b10c216ef..67dd02ed1fa3 100644
> > --- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
> > +++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
> > @@ -253,7 +253,7 @@ static struct fun_irq *fun_alloc_qirq(struct funeth_priv *fp, unsigned int idx,
> >       int cpu, res;
> >
> >       cpu = cpumask_local_spread(idx, node);
> > -     node = local_memory_node(cpu_to_node(cpu));
> > +     node = cpu_to_mem(cpu);
> >
> >       irq = kzalloc_node(sizeof(*irq), GFP_KERNEL, node);
> >       if (!irq)
> > diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
> > index 7aed0561aeac..04c9f91b7489 100644
> > --- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
> > +++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
> > @@ -239,7 +239,7 @@ static inline void fun_txq_wr_db(const struct funeth_txq *q)
> >
> >  static inline int fun_irq_node(const struct fun_irq *p)
> >  {
> > -     return local_memory_node(cpu_to_node(cpumask_first(&p->affinity_mask)));
> > +     return cpu_to_mem(cpumask_first(&p->affinity_mask));
> >  }
> >
> >  int fun_rxq_napi_poll(struct napi_struct *napi, int budget);
>
