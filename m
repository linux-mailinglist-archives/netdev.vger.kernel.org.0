Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D16C61BE
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjCWIdC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Mar 2023 04:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjCWIct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:32:49 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFCD26C36;
        Thu, 23 Mar 2023 01:32:41 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id a5so4077646qto.6;
        Thu, 23 Mar 2023 01:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679560359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVucm+Nx3T4AGOjFjk/QXSCmjrP9EM7XnrrzqizG/YY=;
        b=YdokFKFBXgLmRCM17c94y0OLoa2//ObLiC137v/Ig6FCq5EYcwG7F2KybttQpGoLRm
         Tl1M1Sa6VfpOFlIP1zHi1kiB6CAY2p9syCyqZioiwUH1REBUQYVM+wwjXmKGqpYO8VfT
         39heEmUmMVGxY7Wyn/WWus0hOiEB+F4flwfgjmr9rqKGd+BWeabEH8sfgknERQ4bWMTG
         aGz6ztqVvmKrIq+7NFnxrcgzvVUCykDZzolsi5iu8RYncJ9fK7KDgs0Vc8njmtkXrzQJ
         p1D6CttkujQBIkc0OKpEowzuJqFYoH2h22wcvL1KXuF2iozbFEnan0crC3LMAXH4qlHB
         R08w==
X-Gm-Message-State: AO0yUKXyKCnadxzu0YozXFz3z9mu/pwNw7F5LmZOyF7d2A8jIWudhQpb
        5sYAM5GLhsS2RNwOcoty1W0M3H6ZBXw0fQ==
X-Google-Smtp-Source: AK7set+fqEIWnxqtgeRaBDrWadheJvQIwfqnf++vo3MwDkekb7F6ZsCe4ydy0/A7KLeuPJk4KczfZg==
X-Received: by 2002:a05:622a:650:b0:3d7:b045:d39 with SMTP id a16-20020a05622a065000b003d7b0450d39mr9607697qtb.62.1679560359641;
        Thu, 23 Mar 2023 01:32:39 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id t2-20020a374602000000b00746ac14e29asm2803176qka.5.2023.03.23.01.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 01:32:39 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5416698e889so382978597b3.2;
        Thu, 23 Mar 2023 01:32:39 -0700 (PDT)
X-Received: by 2002:a81:4312:0:b0:544:5fc7:f01f with SMTP id
 q18-20020a814312000000b005445fc7f01fmr1360520ywa.4.1679560358713; Thu, 23 Mar
 2023 01:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com> <79d945a4-e105-4bc4-3e73-64971731660e@omp.ru>
In-Reply-To: <79d945a4-e105-4bc4-3e73-64971731660e@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 23 Mar 2023 09:32:27 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
Message-ID: <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Wed, Mar 22, 2023 at 9:54 PM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> On 3/21/23 9:58 AM, Wolfram Sang wrote:
> > It had a purpose back in the days, but today we have a handy helper.
>
>    Well, the is_opened flag doesn't get set/cleared at the same time as
> __LINK_STATE_START. I'm not sure they are interchangeable...
>
> > Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

> > --- a/drivers/net/ethernet/renesas/sh_eth.c
> > +++ b/drivers/net/ethernet/renesas/sh_eth.c
> > @@ -2441,8 +2441,6 @@ static int sh_eth_open(struct net_device *ndev)
> >
> >       netif_start_queue(ndev);
> >
> > -     mdp->is_opened = 1;
> > -
>
>    __LINK_STATE_START gets set before the ndo_open() method call, so
> before the RPM call that enbales the clocks...
>
> >       return ret;
> >
> >  out_free_irq:
> > @@ -2565,7 +2563,7 @@ static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev)
> >       if (mdp->cd->no_tx_cntrs)
> >               return &ndev->stats;
> >
> > -     if (!mdp->is_opened)
> > +     if (!netif_running(ndev))
> >               return &ndev->stats;
>
>    I guess mdp->is_opened is checked here to avoid reading the counter
> regs when RPM hasn't been called yet to enable the clocks...

Exactly, cfr. commit 7fa2955ff70ce453 ("sh_eth: Fix sleeping function
called from invalid context").

So you mean sh_eth_get_stats() can now be called after setting
__LINK_STATE_START, but before RPM has enabled the clocks?
Is there some protection against parallel execution of ndo_open()
and get_stats()?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
