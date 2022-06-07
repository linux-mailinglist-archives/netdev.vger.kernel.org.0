Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8326553F4C2
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 05:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbiFGD4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 23:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbiFGD4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 23:56:17 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4990CC9ED3
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 20:56:16 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-30ec2aa3b6cso162119607b3.11
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 20:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6W+Eu5u0Y2TVLVC3Z3gxvXA75csS9fj4QfnmD8nAwo=;
        b=Xmp2jUxg/6CW8CBqHPgwq9NZJ4s0us1G0eU99OQC2GjN0qPysqB5bVl4TFxyvqJ1eN
         dBeSmTJ+w0gBEk80CVEaGgO1qr2vCm3P7qWckKOLjx/ZSTOui6LM6T3YqaIzV6SRBeVB
         gfmFToylzWBKMi/FQr0OXMQCYu3eUxiFfCGBR6UiladWI1mKEsmGiRGd/ZF6WWiJoKTk
         +10TqBBiKotkjw06hp/DYxlrwwe/rQAieGdHPSPTcpomtZJe6yu2DaUjuMqhqrvgbVtW
         Z+WjWrnTjxTKK8ZyMJj6M3Um5mIIsEcaDPIUyVekq+W6a/C9XwSPZuYjrCXXyy7bLTSF
         jBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6W+Eu5u0Y2TVLVC3Z3gxvXA75csS9fj4QfnmD8nAwo=;
        b=h7X4mzoSNtsuT8IU7gjYhxUk0Xhh0I9dNb3HdM1Aht73QCJZpWA5hmSV9sR+edZ2Ba
         UGkHWFXvPs6Dc9ABuga27EZKF6wgOGdJoFrGHE/sGzfbGomhme8ph1e803ww4C6eIPvZ
         eql21sz50N9TzlYECIUKSr9ncWMuz9jDrMLUJf4lT37mWf+xhQGp4m7ss1xrtvXncNvM
         T3zJbinH9Ve74OVam7R4Wfx1BJhLIVI6yLKgKxj4RfzotXQKijoT42vorkSYdVonkET4
         XELVOzcr0f9RcWwfe6dccwrdAtPTk+nL9ATnBVknSy3vYg3sBsvqeoEz7Yuv02Y8DB2d
         ANcg==
X-Gm-Message-State: AOAM533hThA1M2EN5cOVhq13iQ/vlrtIIFP3pir72iHXNdpThk+5t+dQ
        ZpPx7BOBGo+Ol1wJ3EEsWwfKtv4K7MTQ8O9HdQF26JGdchdG5zRp
X-Google-Smtp-Source: ABdhPJzd5Gl7ldKwC+EMio35IPYKFhnOupIU1l2Ytn1ajSJrvw7ViB88P4Su3zvvAb/vdwvoGlsx1ouF1ctpUDBm7VA=
X-Received: by 2002:a81:a1d3:0:b0:30f:c7f0:7b62 with SMTP id
 y202-20020a81a1d3000000b0030fc7f07b62mr27517115ywg.458.1654574175597; Mon, 06
 Jun 2022 20:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220606070804.40268-1-songmuchun@bytedance.com>
 <CANn89iJwuW6PykKE03wB24KATtk88tS4eSHH42i+dBFtaK8zsg@mail.gmail.com> <CANn89iKeOfDNmy0zPWHctuUQMb4UTiGxza9j3QVMsjuXFmeuhQ@mail.gmail.com>
In-Reply-To: <CANn89iKeOfDNmy0zPWHctuUQMb4UTiGxza9j3QVMsjuXFmeuhQ@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 7 Jun 2022 11:55:39 +0800
Message-ID: <CAMZfGtXqjzrQFWB8JaiTk4z8kpEjEwNNC8MO9dxUB5hrFwn0JQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: use kvmalloc_array() to allocate table_perturb
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 12:13 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jun 6, 2022 at 9:05 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Jun 6, 2022 at 12:08 AM Muchun Song <songmuchun@bytedance.com> wrote:
> > >
> > > In our server, there may be no high order (>= 6) memory since we reserve
> > > lots of HugeTLB pages when booting.  Then the system panic.  So use
> > > kvmalloc_array() to allocate table_perturb.
> > >
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >
> > Please add a Fixes: tag and CC original author ?
> >

Will do.

> > Thanks.
>
> Also using alloc_large_system_hash() might be a better option anyway,
> spreading pages on multiple nodes on NUMA hosts.

Using alloc_large_system_hash() LGTM, but
I didn't see where the memory is allocated on multi-node
in alloc_large_system_hash() or vmalloc_huge(), what I
missed here?

Thanks.
