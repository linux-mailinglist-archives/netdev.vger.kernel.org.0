Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8647F5E5F99
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiIVKQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIVKP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6575D8E3E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663841753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IBlKeW71HMXuF+YzjFtnzV4lezEgDBlZ/o2Kj16/Nk=;
        b=bI8cuoTe/Y9mBn/fS2vp1ImclXoceA6Ax+Kz0YPiFAFeb1q6P1SKJfo8mCAXQ2TqvdpOi3
        F3X0HXI4KIQyDO46K10vzrPickAR9WXTeGenLINaa4FWX0UhP7WLWvAE1V5hntUhi645dC
        wRtuPvo+ZqROFQzCRcctZ/ammoqXc5Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-52-EU8FlPxaMmOT_9g8_ToF4Q-1; Thu, 22 Sep 2022 06:15:50 -0400
X-MC-Unique: EU8FlPxaMmOT_9g8_ToF4Q-1
Received: by mail-qv1-f71.google.com with SMTP id q5-20020a056214194500b004a03466c568so6118137qvk.19
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=0IBlKeW71HMXuF+YzjFtnzV4lezEgDBlZ/o2Kj16/Nk=;
        b=N5Fu115GTcn31sY82yRkyq4XGP6V/8m/D4HNqYEMJmlymFDPnmusFwv+gAVtHPAogu
         1JtK3OmLU3KduoNg6RLBjanVrKrQ3bNZ/+ULLnKQAcj1u9hyJOeFrl88dYrF/wAe5PX8
         RUOoU3koNSkv/3mPK2JQipbOAlP55WuTO1sh6swmbcoBXbxEfVqXd2jU+qhs2ePVWL3Z
         75kzzNpB4lmP3gZgjQcBwXMZluP86XIP6XaXhsdRlmDzfz+kQwHRlJ38WMVimUQkoOw/
         037ljq+KOU2c72nmn462YS6pBcmDqzc7326LWgePBfmSISap/4qo8gRih08k33QTr6G/
         F39Q==
X-Gm-Message-State: ACrzQf1Q2oihhonlRsid91v8CIeZ/8irG+Ps0kpyTeUzwhfE1uUgYo0d
        uvTTXuRE9ioqYqlHYwoRTQ1jP2DrGak56OYioRco4ytbODL4wh3sXOAg23Q3ctthx4TARczlCFi
        n2pikWpz+Gy2Ub8Cg
X-Received: by 2002:ac8:5895:0:b0:35c:bd1e:aed2 with SMTP id t21-20020ac85895000000b0035cbd1eaed2mr1995649qta.618.1663841749788;
        Thu, 22 Sep 2022 03:15:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM52Oz53vtzGd/Vzjg197H7upjHjrJaSUwH51Rbp+Rs47nfUJNiSpr/NtY/ELM28OiTN4HwqDg==
X-Received: by 2002:ac8:5895:0:b0:35c:bd1e:aed2 with SMTP id t21-20020ac85895000000b0035cbd1eaed2mr1995623qta.618.1663841749515;
        Thu, 22 Sep 2022 03:15:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id u15-20020a05620a0c4f00b006cf19068261sm3786530qki.116.2022.09.22.03.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 03:15:49 -0700 (PDT)
Message-ID: <9f972fe0364707e09732b086a8d31ef510cb7133.camel@redhat.com>
Subject: Re: [PATCH net-next v6 2/9] net: marvell: prestera: Add cleanup of
 allocated fib_nodes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>, netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Date:   Thu, 22 Sep 2022 12:15:45 +0200
In-Reply-To: <20220918194700.19905-3-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
         <20220918194700.19905-3-yevhen.orlov@plvision.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
On Sun, 2022-09-18 at 22:46 +0300, Yevhen Orlov wrote:
> Do explicity cleanup on router_hw_fini, to ensure, that all allocated
> objects cleaned. This will be used in cases,
> when upper layer (cache) is not mapped to router_hw layer.
> 
> Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
>  .../marvell/prestera/prestera_router_hw.c     | 23 +++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> index db9d2e9d9904..1b9feb396811 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> @@ -56,6 +56,7 @@ static int prestera_nexthop_group_set(struct prestera_switch *sw,
>  static bool
>  prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
>  				     struct prestera_nexthop_group *nh_grp);
> +static void prestera_fib_node_destroy_ht(struct prestera_switch *sw);
>  
>  /* TODO: move to router.h as macros */
>  static bool prestera_nh_neigh_key_is_valid(struct prestera_nh_neigh_key *key)
> @@ -97,6 +98,7 @@ int prestera_router_hw_init(struct prestera_switch *sw)
>  
>  void prestera_router_hw_fini(struct prestera_switch *sw)
>  {
> +	prestera_fib_node_destroy_ht(sw);
>  	WARN_ON(!list_empty(&sw->router->vr_list));
>  	WARN_ON(!list_empty(&sw->router->rif_entry_list));
>  	rhashtable_destroy(&sw->router->fib_ht);
> @@ -605,6 +607,27 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
>  	kfree(fib_node);
>  }
>  
> +static void prestera_fib_node_destroy_ht(struct prestera_switch *sw)
> +{
> +	struct prestera_fib_node *node;
> +	struct rhashtable_iter iter;
> +
> +	while (1) {
> +		rhashtable_walk_enter(&sw->router->fib_ht, &iter);
> +		rhashtable_walk_start(&iter);
> +		node = rhashtable_walk_next(&iter);
> +		rhashtable_walk_stop(&iter);
> +		rhashtable_walk_exit(&iter);
> +
> +		if (!node)
> +			break;
> +		else if (IS_ERR(node))
> +			continue;
> +		else if (node)
> +			prestera_fib_node_destroy(sw, node);
> +	}
> +}
> +
>  struct prestera_fib_node *
>  prestera_fib_node_create(struct prestera_switch *sw,
>  			 struct prestera_fib_key *key,

I commented on v5 due to PEBKAC here, but the comment applies here,
too:

You could use rhashtable_free_and_destroy() with a suitable callback
freeing the node without removing it from the hash table. The same in
the next patch.

Thanks!

Paolo

