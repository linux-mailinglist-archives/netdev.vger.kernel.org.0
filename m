Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6506534BAB
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344364AbiEZIWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiEZIWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:22:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D5AB1ADAB
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653553352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+5UPzucSEh/21RXIqYpPNxN/JQMCW1p/LRCquflxKQ=;
        b=SZIdvg9UbXMke+Tt3tJp8n9/KIzU2wr5G4inbTYQqdh1fe5ruxcF5ihADwAOrzW3XpjmJG
        +kV1uL4osRloOd6HEsoX4tJH+cUVy0uofw5LvqXbN2CUxMlB497IgOvQc+9a805T5030UK
        Vnbbn+hOc3VQwaDLBY/gbcMC08AfBlk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-TFGlaP99PpaWwkUhRWPJIQ-1; Thu, 26 May 2022 04:22:30 -0400
X-MC-Unique: TFGlaP99PpaWwkUhRWPJIQ-1
Received: by mail-qt1-f199.google.com with SMTP id w21-20020a05622a135500b002f3b801f51eso950237qtk.23
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=b+5UPzucSEh/21RXIqYpPNxN/JQMCW1p/LRCquflxKQ=;
        b=3SqolI4YvoEVYIK6SnGyVq0rhgtupVphzxEr6p/nzU11DOn+/FvgpcWMLg7zgMd/WP
         lFU0y6Ucty/P/kpHdRQUWfsrZHbltRHMgzL6TalDyJ/CoWfzphwwBKns7TzXDmTbIrsI
         VgjnQEs6sSxS+QujmzJBQt+JIAsaV3LuBvMK+GybCiebBj2NcM9sdYHYZA/qLeFvDB8e
         leVXsnM4VQ/2BwLGBYUAy2CI7NeJ1GNrV2F0slXBJhmjLwM867upZxEd62WSZi6ay4dZ
         IOloS8LvfPfxH7j4JlINJwc+r2xC9nWR7+RjR2YfM0udw2+R4WUDukiKZMOsEXU544Jc
         xSeA==
X-Gm-Message-State: AOAM533cEE1Xh6N2RjZpJ+IRSvLSPz7jgep7MyW5OprzD9aTRxo7G2Mg
        o64U3iqU/zetMs69xPm6cEvFp8cXf/7QvohhF+J89NU1UWdbt330vbrPxZpH7ktj31X1Y1l4v9H
        J6prmPW2wA0qRP+fR
X-Received: by 2002:ac8:7c56:0:b0:2fb:8075:4755 with SMTP id o22-20020ac87c56000000b002fb80754755mr4274502qtv.403.1653553350124;
        Thu, 26 May 2022 01:22:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9jSmBONOb3KHjKM+0LnLvaHsPE2gME7E6aCg23ihbyWwIWtR6dIaQyTcI5r0cln3CZr27qw==
X-Received: by 2002:ac8:7c56:0:b0:2fb:8075:4755 with SMTP id o22-20020ac87c56000000b002fb80754755mr4274492qtv.403.1653553349882;
        Thu, 26 May 2022 01:22:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id 195-20020a370acc000000b006a33f89bb00sm829991qkk.81.2022.05.26.01.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 01:22:29 -0700 (PDT)
Message-ID: <184f66e5839a765571547f490988f25c5290856b.camel@redhat.com>
Subject: Re: [PATCH] net: ipv4: Avoid bounds check warning
From:   Paolo Abeni <pabeni@redhat.com>
To:     Genjian Zhang <zhanggenjian123@gmail.com>, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huhai@kylinos.cn
Date:   Thu, 26 May 2022 10:22:25 +0200
In-Reply-To: <20220524072326.3484768-1-zhanggenjian@kylinos.cn>
References: <20220524072326.3484768-1-zhanggenjian@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-24 at 15:23 +0800, Genjian Zhang wrote:
> From: huhai <huhai@kylinos.cn>
> 
> Fix the following build warning when CONFIG_IPV6 is not set:
> 
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘tcp_md5_do_add’ at net/ipv4/tcp_ipv4.c:1211:2:
> ./include/linux/fortify-string.h:328:4: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   328 |    __write_overflow_field(p_size_field, size);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: huhai <huhai@kylinos.cn>
> ---
>  net/ipv4/tcp_ipv4.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 457f5b5d5d4a..ed03b8c48443 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1207,9 +1207,14 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>  	key->prefixlen = prefixlen;
>  	key->l3index = l3index;
>  	key->flags = flags;
> +#if IS_ENABLED(CONFIG_IPV6)
>  	memcpy(&key->addr, addr,
>  	       (family == AF_INET6) ? sizeof(struct in6_addr) :
>  				      sizeof(struct in_addr));

I'm wondering if you could avoid the extra compiler conditional with
something alike:

 	memcpy(&key->addr, addr,
  	       (IS_ENABLED(CONFIG_IPV6) && family == AF_INET6) ? sizeof(struct in6_addr) :
								 sizeof(struct in_addr));

Thanks!

Paolo

