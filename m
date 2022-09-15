Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8865BA358
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 01:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIOXl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 19:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIOXl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 19:41:57 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B592C326CA;
        Thu, 15 Sep 2022 16:41:56 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id m9so15450632qvv.7;
        Thu, 15 Sep 2022 16:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=sHMR97DN2FQYRWVlG2zH0x9z7vHfZEf3PBRE1At7yLg=;
        b=bQdvfLd48/sT/hQnm27udtvEdZR5/FpluiY3Tv+g4vpPkKc6elu1J6GH5kd8xu3E3i
         fDDq3Xk8b6XrQBOgVGCObEuDiWGDoqO6EEYt348jmQ0n8iNU1QUX2uyX/77gVD4ZxfcA
         atRSK8ZviD/MPR5b/81xTOADewcrHGjoNcBgbdR0msmaLzoc6CNDvje6MTxrMub+0IFe
         kAhwBN5ekIot7M8alcWYbXWkgHUlvGOEOaJ9M5W2EbNDTb8GEalt7SA3Opu0JhsxD3dL
         8Y6wYHx8RF8rRDwTE47TG8hL4YikLlHK/o1kYz6LAJuviHnDwQHue5ZZhllFXusqHYoP
         L84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sHMR97DN2FQYRWVlG2zH0x9z7vHfZEf3PBRE1At7yLg=;
        b=hVXLq49jw0Sks07gbrj7MgKUtXElA1DdjlM4t59C+cLv9P/LbHJYpyPieDQUUziM+7
         Y7jiauWXH6VDZUenECgg0KPe0U37cL6x5ZVmXgbjaCBFO8eJPLl1w6BG4A6M5B6+RZnU
         oNTZjq5RMvIsgE6O7rMoEdbdNirX5QIovHnsO8WbyoEtYc8JmR4QZgVvAmrfx2UU5q+V
         wJhXjNpGjx4/nhFwORz7eZYr4Q+6kYNzHUmavbz+dXhDQFE6EuzcayStPx/3diPFhkiC
         EU9ityljJs1vSkumNuiZtHMo5SILHdD758yVhPTuTmgrweghTQ+cYyvufBkxRKAG3EkY
         YkKA==
X-Gm-Message-State: ACrzQf2z7h89PXmUsX5dgrpGCPNE5/t5aac47kuuIOlmV9r7B4kqUkoE
        WvzKjSLkw6J/zdmBnp7NF7A=
X-Google-Smtp-Source: AMsMyM79hdLjkPH/SfQZUJXn/UwmDJjg+YJzT3QOemoVr1K+bdstNMxfSfxsPjjBvFdMp76/yxfUMA==
X-Received: by 2002:a05:6214:301a:b0:4ac:a4ec:b8b1 with SMTP id ke26-20020a056214301a00b004aca4ecb8b1mr1743897qvb.122.1663285315814;
        Thu, 15 Sep 2022 16:41:55 -0700 (PDT)
Received: from riccipc ([31.187.109.46])
        by smtp.gmail.com with ESMTPSA id i18-20020a05620a405200b006bb9125363fsm4529300qko.121.2022.09.15.16.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 16:41:55 -0700 (PDT)
Date:   Fri, 16 Sep 2022 01:41:51 +0200
From:   Roberto Ricci <rroberto2r@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle page fault for address, with ipv6.disable=1
Message-ID: <YyO4P50YeI0wlGM2@riccipc>
References: <YyD0kMC7qIBNOE3j@riccipc>
 <YyH3gBoUNT9yqrUx@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyH3gBoUNT9yqrUx@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-14 Wed 18:47:12 +0300, Ido Schimmel wrote:
> This is most likely caused by commit 0daf07e52709 ("raw: convert raw
> sockets to RCU") which is being back ported to stable kernels.
> 
> It made the initialization of 'raw_v6_hashinfo' conditional on IPv6
> being enabled. Can you try the following patch (works on my end)?
> 
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 19732b5dce23..d40b7d60e00e 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -1072,13 +1072,13 @@ static int __init inet6_init(void)
>  	for (r = &inetsw6[0]; r < &inetsw6[SOCK_MAX]; ++r)
>  		INIT_LIST_HEAD(r);
>  
> +	raw_hashinfo_init(&raw_v6_hashinfo);
> +
>  	if (disable_ipv6_mod) {
>  		pr_info("Loaded, but administratively disabled, reboot required to enable\n");
>  		goto out;
>  	}
>  
> -	raw_hashinfo_init(&raw_v6_hashinfo);
> -
>  	err = proto_register(&tcpv6_prot, 1);
>  	if (err)
>  		goto out;
> 
> Another approach is the following, but I prefer the first:
> 
> diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
> index 999321834b94..4fbdd69a2be8 100644
> --- a/net/ipv4/raw_diag.c
> +++ b/net/ipv4/raw_diag.c
> @@ -20,7 +20,7 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
>  	if (r->sdiag_family == AF_INET) {
>  		return &raw_v4_hashinfo;
>  #if IS_ENABLED(CONFIG_IPV6)
> -	} else if (r->sdiag_family == AF_INET6) {
> +	} else if (r->sdiag_family == AF_INET6 && ipv6_mod_enabled()) {
>  		return &raw_v6_hashinfo;
>  #endif
>  	} else {

Both the solutions you proposed work for me. Thanks.
