Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAE462D727
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiKQJic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiKQJib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:38:31 -0500
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FFD12AB3;
        Thu, 17 Nov 2022 01:38:30 -0800 (PST)
Received: by mail-qk1-f169.google.com with SMTP id x18so781329qki.4;
        Thu, 17 Nov 2022 01:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Y9u3yKQBInKED+z7xkcGsxdCUk6KV1imL+4jmN3ryw=;
        b=ONXF1fSjafdA5D1UVZ+8PMPffJC5GsfIeZluW3U/m+SDkO1toylR6cgJ5sOaZ6EvLb
         DuBg240erHCBsOepDW7RrnHQSPUMnGFJBCPHUSV73AgHA/D42dN6Htpkr5sP0cU8tVtA
         2qSDqrXAYI4rLqX0+EP8ys4bFVpwsyONoPxoWIR0T7nIEK8jHDHryazf9m5cHeBE1vv+
         372u/cNa2YSLE4Q9gZeoP3bDGvkpJUiSW7U+ufIywO8CbpPV3Z76los4gPLGscYewfJG
         SPXgtBOctEqMK8kr27AMqw2hyz9WSoXALwngx0CGO5FBTVt9UydB/YCwNKArt0wCdm2n
         +TgA==
X-Gm-Message-State: ANoB5pnMlfuMBUQufRot/nRMeOCG7YqeuUGUl2uTTYKGGo32yomL0QmI
        AVzb3ofF61meBzounbVTk4gQz611lDBxyQ==
X-Google-Smtp-Source: AA0mqf4QktA318NxXVAZ4DlHQ3NiME6pPjvcmrs2Uqzyv3REz3jTkD38h9HyrCHTsLadFRsLeMuzVQ==
X-Received: by 2002:ae9:dc06:0:b0:6fa:93b1:a061 with SMTP id q6-20020ae9dc06000000b006fa93b1a061mr900700qkf.446.1668677909417;
        Thu, 17 Nov 2022 01:38:29 -0800 (PST)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id x13-20020a05620a448d00b006fa4ac86bfbsm145347qkp.55.2022.11.17.01.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 01:38:28 -0800 (PST)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-36cbcda2157so13240957b3.11;
        Thu, 17 Nov 2022 01:38:28 -0800 (PST)
X-Received: by 2002:a05:690c:b81:b0:37e:6806:a5f9 with SMTP id
 ck1-20020a05690c0b8100b0037e6806a5f9mr1281543ywb.47.1668677907929; Thu, 17
 Nov 2022 01:38:27 -0800 (PST)
MIME-Version: 1.0
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3XQBYdEG5EQFgQ+@unreal> <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com> <Y3X7gWCP3h6OQb47@unreal>
In-Reply-To: <Y3X7gWCP3h6OQb47@unreal>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 17 Nov 2022 10:38:16 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV2feBGX1tjrGu-gzq_MwfVRS5OHY9V+=wOe_q-E2VkTg@mail.gmail.com>
Message-ID: <CAMuHMdV2feBGX1tjrGu-gzq_MwfVRS5OHY9V+=wOe_q-E2VkTg@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
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

Hi Leon,

On Thu, Nov 17, 2022 at 10:14 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Thu, Nov 17, 2022 at 09:59:55AM +0100, Geert Uytterhoeven wrote:
> > On Thu, Nov 17, 2022 at 9:58 AM Yoshihiro Shimoda
> > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > > From: Leon Romanovsky, Sent: Thursday, November 17, 2022 3:09 PM
> > > > > --- a/drivers/net/ethernet/renesas/rswitch.c
> > > > > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > > > > @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
> > > > >     }
> > > > >
> > > > >     for (i = 0; i < RSWITCH_NUM_PORTS; i++)
> > > > > -           netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
> > > > > +           netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
> > > >
> > > > You can safely drop '\n' from here. It is not needed while printing one
> > > > line.
> > >
> > > Oh, I didn't know that. I'll remove '\n' from here on v2 patch.
> >
> > Please don't remove it.  The convention is to have the newlines.
>
> Can you please explain why?

I'm quite sure this was discussed in the context of commits
5fd29d6ccbc98884 ("printk: clean up handling of log-levels and
newlines") and 4bcc595ccd80decb ("printk: reinstate KERN_CONT for
printing continuation lines"), but I couldn't find a pointer to an
official statement.

I did find[1], which states:

    The printk subsystem will, for every printk, check
    if the last printk has a newline termination and if
    it doesn't and the current printk does not start with
    KERN_CONT will insert a newline.

    The negative to this approach is the last printk,
    if it does not have a newline, is buffered and not
    emitted until another printk occurs.

    There is also the (now small) possibility that
    multiple concurrent kernel threads or processes
    could interleave printks without a terminating
    newline and a different process could emit a
    printk that starts with KERN_CONT and the emitted
    message could be garbled.

[1] https://lore.kernel.org/all/b867ee8a02043ec6b18c9330bfe3a091d66c816c.camel@perches.com

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
