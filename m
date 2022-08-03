Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D729588B26
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiHCL1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiHCL1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:27:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E25FB27B14
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 04:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659526060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXCHkKJ3NiqFVPxxjTWcCdeUI1hi1Vc6RuS+UWOjl2A=;
        b=IKKB6OZsQA1NNKLXpTk4sheuCbO69Z9pu42/195oCnfdHXyA/WCUlMs+GMIK0x8pFhQeWK
        Zd8dtr41P1ph96P/pZdPC8V0JMh34D9sm4k60s87tqEdOj3kfX04CQ/XW8dJSclqNi7wgq
        Is6UN2cXS/VHws+7I+wMAyidqE2uUBI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-tezRQx39Ow2KU7_AhNYovg-1; Wed, 03 Aug 2022 07:27:39 -0400
X-MC-Unique: tezRQx39Ow2KU7_AhNYovg-1
Received: by mail-qt1-f198.google.com with SMTP id f1-20020ac84641000000b0031ecb35e4d1so10677875qto.2
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 04:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WXCHkKJ3NiqFVPxxjTWcCdeUI1hi1Vc6RuS+UWOjl2A=;
        b=bXctJxBMD3pFdNmKcUI33EHglNCVAznF6f6Nmi4N+6JpYq9ufDgGw8VvKtzd6yH5GR
         zUxXZQ/81OA3PzLJ6XaVJOsjMLADrC9UwL3otQObkUk0Cy4O8h5lnXEVJWfeI9dK5o3i
         Douq4rLc+a+CV08YHECF05WY7hOHXQLsfjIH5QzCeeuNgS4GqeBihxAhT1LM6EQrytn0
         DKR4QrXjjCfFHnDlktsay+AUbvkWO/pktArcyX522XUsUNpfEmCnW6SQt7TEUMVs2R9E
         W2leyJRhUNo+gdAHFUOScsh2r926G3KRi38F/UM0I80TUMdaoRMfgmyYf9glDcMOnRC6
         /GSg==
X-Gm-Message-State: AJIora+7lz8HQoA50pbeeAjLZUmT0IaYspuWFuagtuQMa6H4UHBGLrnV
        HjAEgQlfoVQbLZnVEGyUK9HHOgozN5vD6SsV8rqU319EmR+29neap3xzmCV99B9fcpmYzlTDnNy
        6gF8eu/6GnOedmjC5
X-Received: by 2002:a05:620a:29d6:b0:6b5:be51:fcf0 with SMTP id s22-20020a05620a29d600b006b5be51fcf0mr18064242qkp.705.1659526058539;
        Wed, 03 Aug 2022 04:27:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uy36sdA7Sh8aasUy+6BxrbC/DrMuE16xQziCA4OiQcdH+TqUbY9dg+IdQ3r5/Ko0Cx+GqURg==
X-Received: by 2002:a05:620a:29d6:b0:6b5:be51:fcf0 with SMTP id s22-20020a05620a29d600b006b5be51fcf0mr18064224qkp.705.1659526058324;
        Wed, 03 Aug 2022 04:27:38 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id fd9-20020a05622a4d0900b00304fe5247bfsm10712589qtb.36.2022.08.03.04.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 04:27:37 -0700 (PDT)
Date:   Wed, 3 Aug 2022 13:27:32 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        maord@nvidia.com, lariel@nvidia.com, vladbu@nvidia.com,
        cmi@nvidia.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-rdma@vger.kernel.org, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, jesse@nicira.com, linville@tuxdriver.com,
        daniel@iogearbox.net, hadarh@mellanox.com, ogerlitz@mellanox.com,
        willemb@google.com, martin.varghese@nokia.com
Subject: Re: [PATCH v2 net 0/4] Do not use RT_TOS for IPv6 flowlabel
Message-ID: <20220803112732.GB29408@pc-4.home>
References: <20220802120935.1363001-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802120935.1363001-1-matthias.may@westermo.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 02:09:31PM +0200, Matthias May wrote:
> According to Guillaume Nault RT_TOS should never be used for IPv6.
> 
> Quote:
> RT_TOS() is an old macro used to interprete IPv4 TOS as described in
> the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
> code, although, given the current state of the code, most of the
> existing calls have no consequence.
> 
> But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
> field to be interpreted the RFC 1349 way. There's no historical
> compatibility to worry about.

Apart from the not so informative commit messages, I'm fine with this
series. Please keep my acked-by on all patches if you send a v3.

Thanks again for fixing this.

Acked-by: Guillaume Nault <gnault@redhat.com>

> ---
> v1 -> v2:
>  - Fix spacing of "Fixes" tag.
>  - Add missing CCs
> 
> Matthias May (4):
>   geneve: do not use RT_TOS for IPv6 flowlabel
>   vxlan: do not use RT_TOS for IPv6 flowlabel
>   mlx5: do not use RT_TOS for IPv6 flowlabel
>   ipv6: do not use RT_TOS for IPv6 flowlabel
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 4 ++--
>  drivers/net/geneve.c                                | 3 +--
>  drivers/net/vxlan/vxlan_core.c                      | 2 +-
>  net/ipv6/ip6_output.c                               | 3 +--
>  4 files changed, 5 insertions(+), 7 deletions(-)
> 
> -- 
> 2.35.1
> 

