Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132EC62D8A0
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiKQK5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiKQK4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:56:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2DE6A68A;
        Thu, 17 Nov 2022 02:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA72AB81FF5;
        Thu, 17 Nov 2022 10:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CFEC433D6;
        Thu, 17 Nov 2022 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668682466;
        bh=PpUwSG6EJfUx+3lr00+P9CiKhzjv0oxS1bfWue4gXfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THntkVF0fEDvt/kZ/rTuuQwggzpzYgmBDDnGZWBhF3kDHGPihuC3Ku/7xuv863eu4
         5IX5BRC9WsyHzOKKrZTSBNllUuH3lEv7a+2zUVehOPoAXkRiN2tuqUzt3VQHC31HA2
         DUFkSp7PsGa1kyAf4tJHi+vvssnl8tEsM4qUL6zz2LGLm4ONiYelcOn1vWD3w90xRd
         3dvwXaeb2E8AGEnB2aHFTUVi5ov2/L5Ny9+iyKK2YOuHePFWAv3+iUo1E8YFb4tcGi
         ZNhxl2lNmdlHQ+HeV1OhosXrS1iTco307jgrqKxsU5IPydK0sVGihePoa2CRrJbynR
         dqexf3+XnHdzg==
Date:   Thu, 17 Nov 2022 12:54:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <Y3YS3Q8WqtWalsAf@unreal>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3XQBYdEG5EQFgQ+@unreal>
 <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com>
 <Y3X7gWCP3h6OQb47@unreal>
 <CAMuHMdV2feBGX1tjrGu-gzq_MwfVRS5OHY9V+=wOe_q-E2VkTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV2feBGX1tjrGu-gzq_MwfVRS5OHY9V+=wOe_q-E2VkTg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 10:38:16AM +0100, Geert Uytterhoeven wrote:
> Hi Leon,
> 
> On Thu, Nov 17, 2022 at 10:14 AM Leon Romanovsky <leon@kernel.org> wrote:
> > On Thu, Nov 17, 2022 at 09:59:55AM +0100, Geert Uytterhoeven wrote:
> > > On Thu, Nov 17, 2022 at 9:58 AM Yoshihiro Shimoda
> > > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > > > From: Leon Romanovsky, Sent: Thursday, November 17, 2022 3:09 PM
> > > > > > --- a/drivers/net/ethernet/renesas/rswitch.c
> > > > > > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > > > > > @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
> > > > > >     }
> > > > > >
> > > > > >     for (i = 0; i < RSWITCH_NUM_PORTS; i++)
> > > > > > -           netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
> > > > > > +           netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
> > > > >
> > > > > You can safely drop '\n' from here. It is not needed while printing one
> > > > > line.
> > > >
> > > > Oh, I didn't know that. I'll remove '\n' from here on v2 patch.
> > >
> > > Please don't remove it.  The convention is to have the newlines.
> >
> > Can you please explain why?
> 
> I'm quite sure this was discussed in the context of commits
> 5fd29d6ccbc98884 ("printk: clean up handling of log-levels and
> newlines") and 4bcc595ccd80decb ("printk: reinstate KERN_CONT for
> printing continuation lines"), but I couldn't find a pointer to an
> official statement.

Not a printk expert, but in first commit, Linus removed need of "\n"
together with KERN_CONT, and in second commit he returned KERN_CONT,
but didn't return need of "\n".

> 
> I did find[1], which states:
> 
>     The printk subsystem will, for every printk, check
>     if the last printk has a newline termination and if
>     it doesn't and the current printk does not start with
>     KERN_CONT will insert a newline.
> 
>     The negative to this approach is the last printk,
>     if it does not have a newline, is buffered and not
>     emitted until another printk occurs.

I have no idea if it is continue to be true in 2022.

> 
>     There is also the (now small) possibility that
>     multiple concurrent kernel threads or processes
>     could interleave printks without a terminating
>     newline and a different process could emit a
>     printk that starts with KERN_CONT and the emitted
>     message could be garbled.
> 
> [1] https://lore.kernel.org/all/b867ee8a02043ec6b18c9330bfe3a091d66c816c.camel@perches.com
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
