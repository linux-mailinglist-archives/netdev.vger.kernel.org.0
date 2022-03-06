Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147434CE7F5
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 01:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiCFAkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 19:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFAkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 19:40:12 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC4366ACD
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:39:20 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id r7so4648890lfc.4
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 16:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8en4x3D3Rsg/390DQsGf7zpMFnrPA9uIThUqXWbX5VQ=;
        b=bKrr0ECQzIOFX5TyirNazif8P09OceAONKiQyW/yEi8g9MJT21Cz/7WbPo9YULkY15
         RWKU8stQUs/9OEoYQyxn4raJjyEdTMZNn9qJelnfy+TgJ0AlDwb3U22Oi7+srHOTkVBm
         KvKfPdjVTlKgnJjBgR6RBRkBgmRovRxx8C86o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8en4x3D3Rsg/390DQsGf7zpMFnrPA9uIThUqXWbX5VQ=;
        b=ywWqxkDZbJj8jK61kAkxsx/MfQvejkuc04qUHY2LQ6CBs7bE7eqIu5KAWD/kWcL75G
         TXQ95F4vY9/RW7jzesgr8+o8o75gOzBM578qdwaD1sp85SXm+HwuIS4LCm54/CM9qaz3
         YrRyQU/nqog28mQF3pYO+j6HdK66LwNYfbazkW9S5DGQ3NzpB7Q+P14iwraSr4NK1ow9
         OYUMvxy/rz/dR8RTlYjs0WV/fb4BmHaSHePTjOM911WmjnwdMzV+zUILITjP3eVIFn5A
         hMF6z7G0cxG6XivCii1LWllCOV6KGdt1aaB5OU5cVDjPJVT9uuWFioN6QqyVqC5bGn/I
         /Jng==
X-Gm-Message-State: AOAM530eaSqW5rdczNo00GJBLK7uBg1q+lp1ea0KYsHXCcg4jNQ5EMB6
        XSOnzp+iAK5+TA50x82r/hgyVgjCTm5KinNT0SYQ+g==
X-Google-Smtp-Source: ABdhPJzI8E5L4Sw1o6+sYE7Ff0ogW6PSxC3oH6Scun8+7F+IjtPXm1jvlSPm5HPLk2Zhz3yhRKXTyEYoYBwPhub/FdA=
X-Received: by 2002:ac2:4c4f:0:b0:448:1d8d:292c with SMTP id
 o15-20020ac24c4f000000b004481d8d292cmr3647686lfk.51.1646527158595; Sat, 05
 Mar 2022 16:39:18 -0800 (PST)
MIME-Version: 1.0
References: <20220304211524.10706-1-rdunlap@infradead.org> <CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
 <20220304194116.613d2fd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220304194116.613d2fd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Sat, 5 Mar 2022 16:39:04 -0800
Message-ID: <CAOkoqZniH-7jc3gMtVSP0Htn4DOQ51QE_DjDW1JmY2dm-ekDHQ@mail.gmail.com>
Subject: Re: [PATCH net-next?] net: fungible: fix multiple build problems
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        patches@lists.linux.dev,
        Dimitris Michailidis <dmichail@fungible.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 4 Mar 2022 16:39:49 -0800 Dimitris Michailidis wrote:
> > > Also, gcc 7.5 does not handle the "C language" vs. #ifdef preprocessor
> > > usage of IS_ENABLED() very well -- it is causing compile errors.
> >
> > I believe this is the source of the errors you see but it's not the compiler's
> > fault or something specific to 7.5.0. The errors are because when
> > IS_ENABLED() is false some of the symbols in the "if" are undefined and the
> > compiler checks them regardless.
>
> The compiler will need at least a declaration, right? tls_driver_ctx()
> is pretty stupidly hidden under an ifdef, for reasons which I cannot
> recall. Maybe we can take it out?
>
> Same thing could work for fun_tls_tx():
>
>         return skb;
>  }
> +#else
> +struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
> +                          unsigned int *tls_len);
>  #endif
>
> no?

Yes, including net/tls.h and funeth_ktls.h unconditionally along with
providing dummy definitions for the symbols involved in these errors when
CONFIG_TLS_DEVICE=n would also solve the problem. I'd prefer this over
adding #ifdef to have the compiler check the code regardless of configuration.
