Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9853D23E
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348872AbiFCTMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348866AbiFCTL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:11:59 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EEF286FC
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 12:11:55 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ef5380669cso91646027b3.9
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5fDvBQ9pqnOyeFIGsW6/UXw+F1U5aWM1AabDKQN3DYA=;
        b=sbHxZFWtLPJzqSmFanseJeEPL/ALu0sQSxEJQocSQIsAYQUBcFJXhscWQcNSmfW230
         9rGYlKRGdc8+NCOtXd2QYQ2XQvkPWGrUdp03vXdekmYY9e2qdJp1uNuzLW9Jd7qinut+
         Ucgv06zsk3X2VyQCWX4Jb6t/PfpbW+yc+9vdGhOzMheX7HMUapqW3A1s2XfR5HIv0Agq
         elgZuBluPxPTAsSlHtoZErhKO59lkdTlBMQiKjoovrnNUk+VrG2hHbUT/6BCtCQF7T0s
         l4pxZlAX/b52GuTokRfKfbVxdKCQqSp0ZEXlF2RRTj0w4dQuw3jptgt+I1RJdICqXtZI
         HuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5fDvBQ9pqnOyeFIGsW6/UXw+F1U5aWM1AabDKQN3DYA=;
        b=SB7MKYhGOip2/ZJQUNZdUg+6V/MuXd+bkCH5bopir6BS1/EVBixccoOTcffISqFULM
         VCacz1mH0kUdMKbAxbv1y/M2HcZmbEcbQa2Va33AS4BdSVdpx+C9e8nWS6W9llIonrNq
         zuZLjq+0E5w1hTQV7vVQTTfZychflradtAGiTokElhGzKCncHwpDfguKRJv9I0X+eE+D
         gizZLWV+b3pXRUBqkHF6upCGvGrAriD5LmqDi7jk5o+nL+lB0XK313jaZsA/ZqsyCHmS
         N4ocmUqr2f59NUT7oW7vDvUT67G59etgO33oexyqAHy7/DQG1zSB4qZb/5Jrjg+HzhDx
         6Edw==
X-Gm-Message-State: AOAM530QBs9rkASG5OcRIqu79QmleqIkdl+L3z2vT1B0ZbXNruLuTS5t
        KQKuVsYwYOHnSMwPaTw9AC8jmVT2KRmEjW9zBVcI+w==
X-Google-Smtp-Source: ABdhPJy51STo1wv/NPeMQzs5HJJXun6eDnFOS3demyDMpHxmfb2j2pVRLASUIT3YfUHydKoFN9BCWC8eCqX08kRNFjI=
X-Received: by 2002:a81:b401:0:b0:300:2e86:e7e5 with SMTP id
 h1-20020a81b401000000b003002e86e7e5mr12645707ywi.467.1654283514691; Fri, 03
 Jun 2022 12:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
 <1654245968-8067-1-git-send-email-chen45464546@163.com> <CANn89iKiyh36ULH4PCXF4c8sBdh9WLksMoMcmQwipZYWCzBkMA@mail.gmail.com>
 <20220603115956.6ad82a53@kernel.org>
In-Reply-To: <20220603115956.6ad82a53@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Jun 2022 12:11:43 -0700
Message-ID: <CANn89i+dW+paaybeDkkC0XxYM+Mv_AOnbi6GSLtTgAv9L=TX7Q@mail.gmail.com>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chen Lin <chen45464546@163.com>, Felix Fietkau <nbd@nbd.name>,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 11:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 3 Jun 2022 10:25:16 -0700 Eric Dumazet wrote:
> > >                         goto release_desc;
> > > @@ -1914,7 +1923,16 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
> > >                 return -ENOMEM;
> > >
> > >         for (i = 0; i < rx_dma_size; i++) {
> > > -               ring->data[i] = netdev_alloc_frag(ring->frag_size);
> >
> > Note aside, calling netdev_alloc_frag() in a loop like that is adding
> > GFP_ATOMIC pressure.
> >
> > mtk_rx_alloc() being in process context, using GFP_KERNEL allocations
> > would be less aggressive and
> > have more chances to succeed.
> >
> > We probably should offer a generic helper. This could be used from
> > driver/net/tun.c and others.
>
> Do cases where netdev_alloc_frag() is not run from a process context
> from to your mind? My feeling is that the prevailing pattern is what
> this driver does, which is netdev_alloc_frag() at startup / open and
> napi_alloc_frag() from the datapath. So maybe we can even spare the
> detail in the API and have napi_alloc_frag() assume GFP_KERNEL by
> default?

Yes, we only have to review callers and change the documentation and
implementation.

The confusion/overhead/generalization came with :

commit 7ba7aeabbaba484347cc98fbe9045769ca0d118d
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Fri Jun 7 21:20:34 2019 +0200

    net: Don't disable interrupts in napi_alloc_frag()

    netdev_alloc_frag() can be used from any context and is used by NAPI
    and non-NAPI drivers. Non-NAPI drivers use it in interrupt context
    and NAPI drivers use it during initial allocation (->ndo_open() or
    ->ndo_change_mtu()). Some NAPI drivers share the same function for the
    initial allocation and the allocation in their NAPI callback.

    The interrupts are disabled in order to ensure locked access from every
    context to `netdev_alloc_cache'.

    Let netdev_alloc_frag() check if interrupts are disabled. If they are,
    use `netdev_alloc_cache' otherwise disable BH and invoke
    __napi_alloc_frag() for the allocation. The IRQ check is cheaper
    compared to disabling & enabling interrupts and memory allocation with
    disabled interrupts does not work on -RT.

    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>
