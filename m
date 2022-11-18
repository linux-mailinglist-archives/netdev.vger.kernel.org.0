Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88962EB36
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 02:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiKRBp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 20:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbiKRBpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 20:45:55 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424BD73BB2;
        Thu, 17 Nov 2022 17:45:55 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-14286d5ebc3so1077190fac.3;
        Thu, 17 Nov 2022 17:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jGz5CwzNNbuB/RC9pHbIgkCDH8BnWyfE//DxFSperVc=;
        b=N4trUez3adNxMXNzmNPpzZfU4dBjX3+n4FXfDrZ4N7LfDYcT3KWKns2XgRsiZ9W7sd
         mnb2SgoCFYg8Oq/MofIJ7hNsvCauz6pBs4I5qnhuCKjXyK/eSGyxy8mONDUDaRG5R77Y
         +Ij9qzwr4BkPwmFCBKTZ1zIFCmNAPqXtUOokGO96TJi02NTf0dMN8Xk/J9fa/sJ1XO02
         GYFyeUAi48SzYl9UNYK/ErJgWS3d/TrqUeUBDDRxgewJocz/aCTHDuHc7FBXHERPJwz7
         kXyr3rShgI5RNvWtDcb6n0aeowDSqDF13FQlm/XCZ1bqAqsuWz28/0yqzbH7cAJt3WkD
         cm6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jGz5CwzNNbuB/RC9pHbIgkCDH8BnWyfE//DxFSperVc=;
        b=D5sRahtDxU90OCk1j+FNGAItrF0NJSUDFiJNw+tENkwvl6mNE8gNXiEhw3o6LlV2rP
         MyiEQ8K0lbBSZAVE+GnDoReNW4ZOEYC8jMf4bmSLrSgpuO+oTFpzPt2c2d4AJXPoEYCj
         NK6OYdNOCrSd8+KPupaAJLy76LJPnS33nYM2LgWUeDN3GG8vdlmFvmOwQ6v1bqpqDNRv
         4afG36AP0lMivo/Qafkcz4ac25m+0HdVJounahnMHNXXoMA4C8PtWedsQClMX2jhaBkk
         jNgSqht2QK+s/KjsaT1j02Lk86TU53OXdgRNWLmJztYQY7MTnUbE1jnTrCtUcYeoTyJ4
         MEJA==
X-Gm-Message-State: ANoB5pmXfVeKDN6cYwHgw9L/VsppzO/JgJ57plk6qIxuOoRhGPxwBWiZ
        aOUAeId482QPTbhSN0Prk+znnKvX7CZlGzAJ8pE=
X-Google-Smtp-Source: AA0mqf4YGgLhTeetvX6Lbir7KVRv4EieQLUqZjbW+gY5bDes/B5bOlUnMHgR7VtW1ntRaE8xpoLY2PckTxS94j6WVQg=
X-Received: by 2002:a05:6871:29c:b0:13b:9676:8aba with SMTP id
 i28-20020a056871029c00b0013b96768abamr2786232oae.88.1668735953742; Thu, 17
 Nov 2022 17:45:53 -0800 (PST)
MIME-Version: 1.0
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
 <20221116123115.6b49e1b8@kernel.org> <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
 <20221116141519.0ef42fa2@kernel.org>
In-Reply-To: <20221116141519.0ef42fa2@kernel.org>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Fri, 18 Nov 2022 11:45:42 +1000
Message-ID: <CAAvyFNjHp8-iq_A08O_H2VwEBLZRQe+=LzBm45ekgOZ4afnWqA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 at 08:15, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 17 Nov 2022 08:39:43 +1100 Jamie Bainbridge wrote:
> > >         if (v6) {
> > > #ifdef v6
> > >                 expensive_call6();
> > > #endif
> > >         } else {
> > >                 expensive_call6();
> > >         }
> >
> > These should work, but I expect they cause a comparison which can't be
> > optimised out at compile time. This is probably why the first style
> > exists.
> >
> > In this SYN flood codepath optimisation doesn't matter because we're
> > doing ratelimited logging anyway. But if we're breaking with existing
> > style, then wouldn't the others also have to change to this style? I
> > haven't reviewed all the other usage to tell if they're in an oft-used
> > fastpath where such a thing might matter.
>
> I think the word style already implies subjectivity.

You are right. Looking further, there are many other ways
IF_ENABLED(CONFIG_IPV6) is used, including similar to the ways you
have suggested.

I don't mind Geert's original patch, but if you want a different
style, I like your suggestion with v4 first:

        if (v4) {
                expensive_call4();
#ifdef v6
        } else {
                expensive_call6();
#endif
        }

Jamie
