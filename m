Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB41697885
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjBOIyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjBOIyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:54:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8099767
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676451239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SyBuUqXlZcBaZaijkEqokIYnj9DamrBdZIQVMjfpTJ0=;
        b=T4Ljqtik783rUI1gj85lHY3dzeffzVIDCKtJvMPEFbtdqWQgP6L54zghXO93FF1AhFCZmU
        KULhDVuY5dsYw/2XWMJ2HkvI4MlBYLuH5pRnAvrT0a+mbExYuiiDdUekKI4HHvFJdlRXgZ
        utoddizugBQv9O5rwCXqN9JYyn3J4kc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-2MSYeo1FPTuKjYTKGsjPrQ-1; Wed, 15 Feb 2023 03:53:58 -0500
X-MC-Unique: 2MSYeo1FPTuKjYTKGsjPrQ-1
Received: by mail-qt1-f198.google.com with SMTP id p6-20020a05622a048600b003b9a3ab9153so10715492qtx.8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:53:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SyBuUqXlZcBaZaijkEqokIYnj9DamrBdZIQVMjfpTJ0=;
        b=nn1bY3DFRz+VX8s1DllkxgAS+unXsuzHeiC4U7VTC2ecsCtbOmTMlHE4eVMNbTnwcj
         ZmAUTl3thaas5g5rzKmHp49Owig53maa33c/kwuic4Lgb5waOvFB6aIT8eT2pbFFz3ew
         PB/OMlOV2UYvWWHFfnbIjutgYhUpCMtu09REXQXdgo/Nw85KvGK2g/jn+X2lrpDBCMx7
         /9ZhuqKv+6+HIB5b7iK0Sgk2MuK+U+5z6sWh6VN4fyw6QEhF9ssENXNaZ7yCD7gjLre/
         n4kKXghhYei8h8KKrduVgm3p4wG09nOxPLMPMupMMyUhPbaaoEm0zRNFy9lGpl5ed6uz
         Q/Sw==
X-Gm-Message-State: AO0yUKVzDrUKPIVVHjOAi13t1M9wuv6fOds9jCjbJHpZWwUxD2tpTkki
        U14P0zS7VtUKJgMMRk2n+c7UYo/l78Oc2t1sD0EM/BB108z/kM7Meas7asxJDFBr7Q1FY+HBThq
        LqgSvoxmvowcFNYF0
X-Received: by 2002:a05:622a:304:b0:3b8:6d44:ca7e with SMTP id q4-20020a05622a030400b003b86d44ca7emr2424319qtw.4.1676451237823;
        Wed, 15 Feb 2023 00:53:57 -0800 (PST)
X-Google-Smtp-Source: AK7set+k/cr2FBHZbVKepUqQ0jRwhn12qW7c2ZLK4bYw416vYYMlYvA6+0lm/SxPqAskMl+VOuOjqQ==
X-Received: by 2002:a05:622a:304:b0:3b8:6d44:ca7e with SMTP id q4-20020a05622a030400b003b86d44ca7emr2424299qtw.4.1676451237462;
        Wed, 15 Feb 2023 00:53:57 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id u128-20020a372e86000000b0073b27323c6dsm8283098qkh.136.2023.02.15.00.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 00:53:57 -0800 (PST)
Message-ID: <c4cea30465ff621681090fff69d5ccc97f53e85a.camel@redhat.com>
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        fw@strlen.de
Date:   Wed, 15 Feb 2023 09:53:54 +0100
In-Reply-To: <20230215034444.482178-1-kuba@kernel.org>
References: <20230215034444.482178-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-14 at 19:44 -0800, Jakub Kicinski wrote:
> This is a bit more crazy than the previous patch. For drivers
> which already use build_skb() it's relatively easy to add more
> space to the shinfo. Use this approach to place skb_ext inside
> the head. No allocation needed.
>=20
> This approach is a bit slower in trivial benchmarks than the recycling
> because it requires extra cache line accesses (12.1% loss, ->18.6Gbps).
>=20
> In-place skb_ext may be shorter than a full skb_ext object.
> The driver only reserves space for exts it may use.
> Any later addition will reallocate the space via CoW,
> abandoning the in-place skb_ext and copying the data to
> a full slab object.

I personally like the other option (the non RFC series) more. It looks
like this requires a quite larger code churn that could be error-prone
and even non interested parties/callers/code-paths may end-up paying
some extra overhead/additional cycles.

Still, if you are willing to experiment more this idea, I think you
could save the extra cacheline miss encoding the 'alloc_mode' into the
lower bits of skb->extensions (alike what _skb_refdst is doing with the
SKB_DST_NOREF flag).


Cheers,

Paolo

