Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385915E5EA6
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiIVJdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIVJdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:33:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D1ECC8C2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663839193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAzZ4b2xCwJUs3fed+WhbNmI9QSD0ajnVVgLX9sfbQQ=;
        b=az6gVCuC32VLv2e+pJ6IjBu7MSec5NRnJV0LFxrYBmS1bxWOm/qSIzFNl9JCbjFAZnY0uR
        HrzhC7jyUr5wvZ3UQ8nOoTNWwywy2VzI97gmWApGg5mDlRdXQLJ3mBnsCs+P9bBZgSEapO
        4s5eRO0iSsw5nh2uo7yW/ukVfwISwPA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-z_-GBv_sM1mA50tv_BYzsA-1; Thu, 22 Sep 2022 05:33:12 -0400
X-MC-Unique: z_-GBv_sM1mA50tv_BYzsA-1
Received: by mail-wm1-f70.google.com with SMTP id 14-20020a05600c228e00b003b4d065282dso534730wmf.8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=zAzZ4b2xCwJUs3fed+WhbNmI9QSD0ajnVVgLX9sfbQQ=;
        b=A3cGi7Df1zBSE26V7X9TeEPDrkHHLwyvin6s+zHlWFC3Hmdjs24XJ3FFvom/R7SCBX
         0N5t8Md9LUxfIyViNrKOQRe56uhUDt/44vHLFiNyMmguCBfITIluxXb+7MwNQ7xlilpM
         fBmPom00yktyLmB0W+aHAilccysWm86Ld7Us5aiO5ie+QlTGWjzECF0xnOX1X1cxFfrk
         +Pn44dA8lg1hnmlQ/+C0Q+9momp4eS6y+UweNQOxcz+u6biPJzy4OhnQIoZH+XxEEENk
         +8ngtCrxjCBBTJ13N5kSYloI5t/a+jonH6ikOxvSjptibSYgRLCG+LrTPjiujsA3jA7Q
         +jYw==
X-Gm-Message-State: ACrzQf3ycBUz14it9X1EFEXU3MRUCUuznrDBLmRfNkFUIcxlkDHYBWbO
        KCjrjuMJ5uBGC4c4GUMPPs0/IFVCRESYFFdW5s+ZcmZ8dgf/c9o/cirJNHlW6WQsPeHGWr6UDup
        S3gVNzoKBeAw1QmQP
X-Received: by 2002:a05:600c:3546:b0:3b4:b7da:d8e2 with SMTP id i6-20020a05600c354600b003b4b7dad8e2mr1706419wmq.188.1663839191127;
        Thu, 22 Sep 2022 02:33:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4H2AvKwfjzXmU575/WbPmpQEkzcirG3TvXmTVnoQD84Z4jeYRFidKb0Nb+O6oKjyJVoDUYzw==
X-Received: by 2002:a05:600c:3546:b0:3b4:b7da:d8e2 with SMTP id i6-20020a05600c354600b003b4b7dad8e2mr1706404wmq.188.1663839190908;
        Thu, 22 Sep 2022 02:33:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id l30-20020a05600c1d1e00b003a62400724bsm6330347wms.0.2022.09.22.02.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:33:10 -0700 (PDT)
Message-ID: <b9bbe03d801d6224c8cec9700d22cec19346cebf.camel@redhat.com>
Subject: Re: [PATCH net-next v5 2/9] net: marvell: prestera: Add cleanup of
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
Date:   Thu, 22 Sep 2022 11:33:09 +0200
In-Reply-To: <20220908225211.31482-3-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
         <20220908225211.31482-3-yevhen.orlov@plvision.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-09 at 01:52 +0300, Yevhen Orlov wrote:
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

You should use instead rhashtable_free_and_destroy(), providing a
callback which just frees the node, without removing it from the hash
table.

The same in the next patch

Cheers,

Paolo

