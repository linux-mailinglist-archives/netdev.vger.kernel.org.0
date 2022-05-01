Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9651614D
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 05:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbiEADft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 23:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiEADfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 23:35:48 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12788252AE;
        Sat, 30 Apr 2022 20:32:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id be20so13159561edb.12;
        Sat, 30 Apr 2022 20:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OENTR2QOatT+0Z3dje0owqcIRPezkrqzSM60aXydfxI=;
        b=KB+80xYYc4EsuavQ9ngvLp1pyKwe98vY8yxCm8igoFarABrU8CY1kMpUdr6Q/bqSaB
         5atmXtmFtcAzVInIiSzs7gQBmM0PwzoALUoRRfFfBmdIbhn1bNQeqnRyLVQNOyMQ0K7s
         KafBcFPpqSIgmNxYTsQz/QDBtvaEtBCnj657iCbPkV9vgBwjDAmpY2UbhS60ka4YI1rd
         YaYUYZYI+0HJp+MsmAlg6PlUZdtffmoXWhceZc2W0OZ4nqITTUWzDqHco9m/PRZVC0Au
         FU2DygUKJhmvJ40vnwuuxgIuXmon+h7jXsbACh+CEU8OftKR0M0fOEFovN2NFmVNEulj
         xofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OENTR2QOatT+0Z3dje0owqcIRPezkrqzSM60aXydfxI=;
        b=ACej9X2CGexC6/21olIGJfF7VEZs2/cl3IkONsxOhXMgXIKD+E+n2W12ZItSvYQ9Wq
         F4G7esusrdsJ7sM9NQhh1LNOIWoydESrSUflxhjdbln/2Of85MF+XFMgLcDxaQirTwO8
         6b1mrma7DAilBSD0915MtS1RpHn4wMv7Tw8UbD/j8ocWXCZGHI82xBN7pakuw9+eoEo7
         gzVfUcBpenYkZEZXmKmCWXrxxXhtCtDMAWOAvnfMRIYqEgzWtHHPz9wBVt+eXQt2zTq9
         VTnKb2QHUq0KPFh9ITiiblDx1l6wOYvqFgVqHcmgF8aqKTyI3ZaRm3IuaFbzyjW3NPrq
         43lA==
X-Gm-Message-State: AOAM533bh8arWRn/lTSQfkZ7DGACLxVquxE8v+jnG75n0OkkwYeJl9zY
        z0vFcdaSKomL50jlmEvwo1tj32M1/GqcNdeoS0o=
X-Google-Smtp-Source: ABdhPJx0EdDGCcEk4iZC4RMVGpTMfOiHtrOAyL3cTD5psyznMBBmlmOIhXOIP+loqArW8l0MA3ngZKUw2A5ND5bXrmc=
X-Received: by 2002:a05:6402:1941:b0:413:2b80:b245 with SMTP id
 f1-20020a056402194100b004132b80b245mr7133241edz.252.1651375943585; Sat, 30
 Apr 2022 20:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
 <20220422070141.39397-4-xiangxia.m.yue@gmail.com> <20220425125828.06cc0b51@kernel.org>
In-Reply-To: <20220425125828.06cc0b51@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sun, 1 May 2022 11:31:47 +0800
Message-ID: <CAMDZJNV69HeaBmy1uY7g7R=GKunoV3=bgNd5yfEMKUg_jMPuUg@mail.gmail.com>
Subject: Re: [net-next v4 3/3] selftests/sysctl: add sysctl macro test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 3:58 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 22 Apr 2022 15:01:41 +0800 xiangxia.m.yue@gmail.com wrote:
> >  static int __init test_sysctl_init(void)
> >  {
> > +     test_data.match_int[0] = *(int *)SYSCTL_ZERO,
> > +     test_data.match_int[1] = *(int *)SYSCTL_ONE,
> > +     test_data.match_int[2] = *(int *)SYSCTL_TWO,
> > +     test_data.match_int[3] = *(int *)SYSCTL_THREE,
> > +     test_data.match_int[4] = *(int *)SYSCTL_FOUR,
> > +     test_data.match_int[5] = *(int *)SYSCTL_ONE_HUNDRED,
> > +     test_data.match_int[6] = *(int *)SYSCTL_TWO_HUNDRED,
> > +     test_data.match_int[7] = *(int *)SYSCTL_ONE_THOUSAND,
> > +     test_data.match_int[8] = *(int *)SYSCTL_THREE_THOUSAND,
> > +     test_data.match_int[9] = *(int *)SYSCTL_INT_MAX,
> > +     test_data.match_int[10] = *(int *)SYSCTL_MAXOLDUID,
> > +     test_data.match_int[11] = *(int *)SYSCTL_NEG_ONE,
>
> > +     local VALUES=(0 1 2 3 4 100 200 1000 3000 $INT_MAX 65535 -1)
>
> How does this test work? Am I reading it right that it checks if this
> bash array is in sync with the kernel code?
This patch tries to avoid SYSCTL_XXX not mapping the values we hoped,
when introducing the new SYSCTL_YYY.
for example:
SYSCTL_TWO, we hope it is 2, so we check it in userspace.
> I'd be better if we were checking the values of the constants against
> literals / defines.
Hi Jakub, I think this patch checks the values of the constants
against defines. But I should make the codes more readable

 static int __init test_sysctl_init(void)
 {
+       int i;
+
+       struct {
+               int defined;
+               int wanted;
+       } match_int[] = {
+               {.defined = *(int *)SYSCTL_ZERO,        .wanted = 0},
+               {.defined = *(int *)SYSCTL_ONE,         .wanted = 1},
+               {.defined = *(int *)SYSCTL_TWO,         .wanted = 2},
+               {.defined = *(int *)SYSCTL_THREE,       .wanted = 3},
+               {.defined = *(int *)SYSCTL_FOUR,        .wanted = 4},
+               {.defined = *(int *)SYSCTL_ONE_HUNDRED, .wanted = 100},
+               {.defined = *(int *)SYSCTL_TWO_HUNDRED, .wanted = 200},
+               {.defined = *(int *)SYSCTL_ONE_THOUSAND, .wanted = 1000},
+               {.defined = *(int *)SYSCTL_THREE_THOUSAND, .wanted = 3000},
+               {.defined = *(int *)SYSCTL_INT_MAX,     .wanted = INT_MAX},
+               {.defined = *(int *)SYSCTL_MAXOLDUID,   .wanted = 65535},
+               {.defined = *(int *)SYSCTL_NEG_ONE,     .wanted = -1},
+       };
+
+       for (i = 0; i < ARRAY_SIZE(match_int); i++)
+               if (match_int[i].defined != match_int[i].wanted)
+                       match_int_ok = 0;
+




--
Best regards, Tonghao
