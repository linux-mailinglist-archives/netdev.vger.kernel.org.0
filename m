Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C946756C548
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbiGHX1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbiGHX1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:27:31 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E834D4FF
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:27:30 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id r9so144093ljp.9
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 16:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Oi60uoXzvamvc3/SFoRIFUoo3eDrzVvDd6TkmxROEc=;
        b=eLIcA0wmLBrkZp3xFCD89JHRf3MzzY1K5ZOseLf2l7FsxyK5DEZYcIVMeX/d+KpKER
         RcLpKuJrJQMfTz4LDBMDQMCuZYLw6nfsRCZXgoLtqZn8EoYFiOnEzOEiPe34RdsugaC9
         DVLlB6vSXVef+DVhAEhpFaI4XSiAeLpIjhibeOYxJdGfRQP3u//Y5/7iw8E3MDi/jZTB
         HTWyHH0EVqtHdHaJt8xzJXzKX7nonEXKDdbPuT+SFp1c4j12HMZd23G5PLZ6t0nRQvS1
         dNIdWHL94B6lAEg8zgHC8S+f9q0NxYcNpbjlFQqSMYhWf8jHQdQEHsmMtXIrlLbEeVE4
         VLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Oi60uoXzvamvc3/SFoRIFUoo3eDrzVvDd6TkmxROEc=;
        b=jYlGNUoBcgKBkO2a7k/PpI/G0Dk/0AGrnRmXq2Jm5HjBov6FzxsLxySdnveuirOraf
         7HnF5R+XF5pZzz8Dylnq+Zcpcce/yKo52NUE44L9ZJoWKvt1yT9CcY0T6AbBADmfI8x4
         Bkk1MoJYWjF9fh6e5wO6gkexo5p2MRGAIFQESj+GX7gfdYDtw5RtgWkz6zdu/0K+4fjU
         tcJB4t//BWwXl/c5zsrSzkt2SIXP7oxQreIg92z8S0Y3JG46hvgPA+Q9GD9MfsBPFvUf
         BKQABI11PGDi6CPNqzsm2QLuRgoYpHYya3iMCaugum/7FcRc+u95H3WJQIdJxH7VtHA+
         wo3A==
X-Gm-Message-State: AJIora9XWD4kjMtf2LfqY1xfplCvhYnozVLtNYWN8yUqEjy3Qyn3QeVA
        mOql92UGa6T17wUyGr0b4sK16XF0IF9PCMzXkjPawA==
X-Google-Smtp-Source: AGRyM1sbMd0h5mqMlOe3r5zsM/tg9DtuIaGzYY2PpvqrczlMjK3CvvTTNq4tPC2fb+KpnIF626wm3H/eHrl36HdX56k=
X-Received: by 2002:a05:651c:2104:b0:25b:f4ed:db93 with SMTP id
 a4-20020a05651c210400b0025bf4eddb93mr3316572ljq.295.1657322848370; Fri, 08
 Jul 2022 16:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220707181532.762452-1-justinstitt@google.com>
In-Reply-To: <20220707181532.762452-1-justinstitt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 8 Jul 2022 16:27:16 -0700
Message-ID: <CAKwvOd=YiLPPyXq3Xvwh8+hMfSL1Ak_HE14No5YncbMMyM60Rg@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: esp4: fix clang -Wformat warning
To:     Justin Stitt <justinstitt@google.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 11:15 AM Justin Stitt <justinstitt@google.com> wrote:
>
> This is the exact same issue (and fix) as:
> https://lore.kernel.org/all/20220707173040.704116-1-justinstitt@google.com/
>
> This really should have been a 2-patch series but I've been going
> through warnings and systematically fixing them whilst submitting
> patches as I go.

In that case, since Joe had feedback on that patch, perhaps you can
fold this into that patch, and apply Joe's suggestions (sending a v2)?
-- 
Thanks,
~Nick Desaulniers
