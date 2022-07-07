Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF1456A9F7
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbiGGRro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiGGRrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:47:42 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA255C97A
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 10:47:40 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o25so33728843ejm.3
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 10:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w5UVqVYkA2liWKvF5AEz1NuihXTRBWSdPpoacsPExUk=;
        b=VnSWNkarZG9BtYbcTV2x/Y11CEBH4XIuymrgY4Vv27MqSHtZcbzE3N+SvKyyi1PXLp
         qsyNpEE83rNxQJu+mSR0YcoECw57pUzVzNZ3VPUwnf8BZLAHNsZo6E0Ke3kShCQNltoz
         citbH7pTYgo6Zc35r9M7xalt0nKGVVB6bwH1A6P4NchhbYKCz0GpsXV/rXfKDITpGBy+
         ZYxIbJ7OxTk6fqRprTzXpXrn6JAnK2FWWnl7SHklRSsk4Cv3vtKnKovUTVlfDXDUfPkC
         Shl8o9RHjCUA2jLq684EHRtlnOjpNFYHFGwQt/ulnZ1HdHkfFIBeMl/G/lFil1AicKXN
         zT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w5UVqVYkA2liWKvF5AEz1NuihXTRBWSdPpoacsPExUk=;
        b=ALSgTwojPFHu8F9kFeSHR89G0XaMSiid8rx4wr+8Oi6DO/zxKj/Lfk8t06uJ7769G6
         EAt9F5xMRxcUA85lHw4pRM8KDjrYM+NAyuidaEDvu/X49JxbnyooZ4CWFRQetRMYL3lW
         6JOdbISkzLp430c5jVGW9Xnsc+o8qxS6sUWdm+iZ+Bgjj8Ep2dQe5D+sSbmu0pKR1TKG
         5bT7YHZ1AgFrZ64IGcM2eDvwhpL3gDIIQJo60IZpS06CpU/2KKg1vv6EldguVmgA4XJv
         UPS6z2urVi9VN8KDg3dlYAKaFfIReMsdsb7koP0Qa2ZGu0xpKajLE7nxhhrXS+wtO3LH
         vkrA==
X-Gm-Message-State: AJIora+gp1bklaLQB1ooXc3UA0ucTR2jj+rPynGKe2WB9utv0VWfQySu
        zeunshq/RyG1HoXtUwAcVlvDTLGGW0lseyv1vcPMLA==
X-Google-Smtp-Source: AGRyM1vmJwqTFg1c1tCtPBghzrjs73hfYOtbJo0WpwlLvw0T29Eo5UgcY0rUroqmtCdxAXIWHXBAiIPtLMlbfDGk4c8=
X-Received: by 2002:a17:906:478e:b0:722:f84d:159f with SMTP id
 cw14-20020a170906478e00b00722f84d159fmr46497744ejc.182.1657216059214; Thu, 07
 Jul 2022 10:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220707173040.704116-1-justinstitt@google.com> <6f5a1c04746feb04add15107c70332ac603e4561.camel@perches.com>
In-Reply-To: <6f5a1c04746feb04add15107c70332ac603e4561.camel@perches.com>
From:   Justin Stitt <justinstitt@google.com>
Date:   Thu, 7 Jul 2022 10:47:28 -0700
Message-ID: <CAFhGd8oTybm0aQ_q60e+exf5eFO1kLiNKnmDZfVTyg=BbtgZsw@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: fix clang -Wformat warning
To:     Joe Perches <joe@perches.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 10:40 AM Joe Perches <joe@perches.com> wrote:
>
> On Thu, 2022-07-07 at 10:30 -0700, Justin Stitt wrote:
> > When building with Clang we encounter this warning:
> > > net/ipv4/ah4.c:513:4: error: format specifies type 'unsigned short' but
> > > the argument has type 'int' [-Werror,-Wformat]
> > > aalg_desc->uinfo.auth.icv_fullbits / 8);
> >
> > `aalg_desc->uinfo.auth.icv_fullbits` is a u16 but due to default
> > argument promotion becomes an int.
> >
> > Variadic functions (printf-like) undergo default argument promotion.
> > Documentation/core-api/printk-formats.rst specifically recommends using
> > the promoted-to-type's format flag.
> >
> > As per C11 6.3.1.1:
> > (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
> > can represent all values of the original type ..., the value is
> > converted to an int; otherwise, it is converted to an unsigned int.
> > These are called the integer promotions.` Thus it makes sense to change
> > %hu to %d not only to follow this standard but to suppress the warning
> > as well.
>
> I think it also makes sense to use %u and not %d
> as the original type is unsigned.
Yeah, that would also work. An integer (even a signed one) fully
encompasses a u16 so it's really a choice of style. Do you think the
change to %u warrants a v2 of this patch?
>
> > diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
> []
> > @@ -507,7 +507,7 @@ static int ah_init_state(struct xfrm_state *x)
> >
> >       if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
> >           crypto_ahash_digestsize(ahash)) {
> > -             pr_info("%s: %s digestsize %u != %hu\n",
> > +             pr_info("%s: %s digestsize %u != %d\n",
> >                       __func__, x->aalg->alg_name,
> >                       crypto_ahash_digestsize(ahash),
> >                       aalg_desc->uinfo.auth.icv_fullbits / 8);
>
