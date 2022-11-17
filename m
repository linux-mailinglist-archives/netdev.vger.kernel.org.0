Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFFB62D5B6
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiKQJAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiKQJAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:00:09 -0500
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D9D1A07F;
        Thu, 17 Nov 2022 01:00:08 -0800 (PST)
Received: by mail-qk1-f176.google.com with SMTP id s20so736837qkg.5;
        Thu, 17 Nov 2022 01:00:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+Ko3dmESH9SV49ycFP4zKE53OIsYnH4ZILqYdwHg8s=;
        b=CHAH1N9US8QQfbpoF5ZykjtX09XQ78sPSnSnJPtdYaTT11M4fVHgZ+F7P+VyDhWNEg
         3qRu7t31ReIYzQv+j5/rXcTtL67uF31KNLH6dYF6ZoGhoOeR/ycmp03yO3s7+qISNiiX
         VRxHKt+iImOjRFzvyYyddXWB8O/fF0S+kIzVTR+pkwfJrlvdnctZYnEtASuwTW96alCQ
         VaeBG8r3aOqyebyOMGU/AOYCeTuAZ1j563RSbAUMRvyoL+tOoNiAQFLB8U8rlg24/Gso
         8FeehazP7Lcovdy1wxuEumJwHFlbYyywCilgu7t0bMnTL5q/K2LzSk8uMVpbEQadCrb2
         X8jg==
X-Gm-Message-State: ANoB5pkv36I6unr8tlxaWJ27sEPrD9cuTuDAE3S/MkwAiSreHn4iNGge
        0WNdRc6GcU3p8o2tWO7kthLNWEERQWARWw==
X-Google-Smtp-Source: AA0mqf6/kLKZ/hZYCFJbCxQi4Oc6rs7wlN1ByBJ74pfLiUCLnfgTwFOSaUeVZ50FowwsnyzltbphDg==
X-Received: by 2002:a05:620a:1345:b0:6f8:cdc2:b7a2 with SMTP id c5-20020a05620a134500b006f8cdc2b7a2mr869170qkl.132.1668675607611;
        Thu, 17 Nov 2022 01:00:07 -0800 (PST)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id bw6-20020a05622a098600b003988b3d5280sm69871qtb.70.2022.11.17.01.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 01:00:07 -0800 (PST)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-39115d17f3dso6420857b3.1;
        Thu, 17 Nov 2022 01:00:06 -0800 (PST)
X-Received: by 2002:a81:f80f:0:b0:38e:e541:d8ca with SMTP id
 z15-20020a81f80f000000b0038ee541d8camr1071666ywm.283.1668675606564; Thu, 17
 Nov 2022 01:00:06 -0800 (PST)
MIME-Version: 1.0
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3XQBYdEG5EQFgQ+@unreal> <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
In-Reply-To: <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 17 Nov 2022 09:59:55 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com>
Message-ID: <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shimoda-san,

On Thu, Nov 17, 2022 at 9:58 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Leon Romanovsky, Sent: Thursday, November 17, 2022 3:09 PM
> > On Wed, Nov 16, 2022 at 08:55:19AM +0900, Yoshihiro Shimoda wrote:
> > > Smatch detected the following warning.
> > >
> > >     drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> > >     '%pM' cannot be followed by 'n'
> > >
> > > The 'n' should be '\n'.
> > >
> > > Reported-by: Dan Carpenter <error27@gmail.com>
> > > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > ---
> > >  drivers/net/ethernet/renesas/rswitch.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> > > index f3d27aef1286..51ce5c26631b 100644
> > > --- a/drivers/net/ethernet/renesas/rswitch.c
> > > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > > @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
> > >     }
> > >
> > >     for (i = 0; i < RSWITCH_NUM_PORTS; i++)
> > > -           netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
> > > +           netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
> >
> > You can safely drop '\n' from here. It is not needed while printing one
> > line.
>
> Oh, I didn't know that. I'll remove '\n' from here on v2 patch.

Please don't remove it.  The convention is to have the newlines.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
