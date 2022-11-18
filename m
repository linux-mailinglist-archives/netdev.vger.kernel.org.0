Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FE462FBA2
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbiKRRaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiKRRaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:30:19 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183F5186EC;
        Fri, 18 Nov 2022 09:30:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x2so8119728edd.2;
        Fri, 18 Nov 2022 09:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0uivhCS3hrzrIPQvwJTsradHbw3Nzt6+m34AyTOhZQ0=;
        b=WX7zKRuKRu2BJakMMuR/zGmp9zUQNzAVK093+VPSLJcTwOpqrVjcxeYdvO4IOuD0n/
         DZdha0KAeGLVfXl5fj1sb+BWGMHu2hLV1oiKiw6FP+cVfQTuutwQlg8T5OA9P8e45CI+
         /x2xZG7PneaCh+aYjyFMWND/bJpKeHKVXexZBjp7CchfS42FcbOvPY8frPoKMLwz5wNp
         9IeWJZWlr4qCmPhOG1oPqWnVfreRmp6gyJOqPrQGDKOH07MNuywofJA9uDANhVzGqYWF
         vOnEpo2KsNZGi2XsBDtWJMbgg8CtzVcprw1+KpaWHkkWwC5ktDUZvjx/9rD5of1xIEY3
         yGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0uivhCS3hrzrIPQvwJTsradHbw3Nzt6+m34AyTOhZQ0=;
        b=QLLMbNcwJmOA/v53ibyzvf7ALZWghXJOFjh6eqrgd5SZcGT+hEssd8NmI25ISQpKxS
         68sCzhrhuxjvpqm/qn6Q7gGqXNlsFeki6l8rdHNWz7rrCSG0O8aFxBlh5DixKGahMJh3
         egbjxL+toV7P/6tMwsgreMDV12aEkz1GMi5Xl8vEeG59cg4gRpkAotP6xAAwYp3b00xX
         zAqyUy4xdFHNJtTjBM0a9HVBpknaR11UBaRy/UjkxKUZi7bMRIJPhhLXXG/YSd8jz5y3
         PRXeq/C7YNhi/ZUjjfI5My0LYrDllkmYwfeWwrGGITZfn5cFg5i2hyr9CerkZwDX8sDb
         S73Q==
X-Gm-Message-State: ANoB5plMHCkB269UzN8/4x1F1eVOfMuo9vZTvvEMlPt7ZLtf+Hjl+xWp
        S5+oNV59LVOGS9qt1ax6W3Y=
X-Google-Smtp-Source: AA0mqf4W6/CxKfx1yfXcZgmwCURxQtfhGb9oF9kd/Uh28WiW657srpHdzxcz69JITqkdaT01rwBfiA==
X-Received: by 2002:a05:6402:550b:b0:45f:9526:e35a with SMTP id fi11-20020a056402550b00b0045f9526e35amr7138693edb.256.1668792616538;
        Fri, 18 Nov 2022 09:30:16 -0800 (PST)
Received: from skbuf ([188.27.185.168])
        by smtp.gmail.com with ESMTPSA id mh23-20020a170906eb9700b007af105a87cbsm1920348ejb.152.2022.11.18.09.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:30:16 -0800 (PST)
Date:   Fri, 18 Nov 2022 19:30:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <20221118173014.4i7fccrgcqr6dkp4@skbuf>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
 <20221118164914.6k3gofemf5tu2gfn@skbuf>
 <1015dfec-542d-8222-6c4e-0cf9d5ee7e5a@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1015dfec-542d-8222-6c4e-0cf9d5ee7e5a@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 12:11:30PM -0500, Sean Anderson wrote:
> >> - We can check all the registers to ensure we are actually going to rate
> >>   adapt. If we aren't, we tell phylink we don't support it. This is the
> >>   least risky, but we can end up not bringing up the link even in
> >>   circumstances where we could if we configured things properly. And we
> >>   generally know the right way to configure things.
> > 
> > Like when?
> 
> Well, like whenever the phy says "Please do XFI/2" or some other mode we
> don't have a phy interface mode for. We will never be able to tell the MAC
> "Please do XFI/2" (until we add an interface mode for it), so that's
> obviously wrong.

Add an interface mode for it then... But note that I have absolutely no
clue what XFI/2 is. Apparently Aquantia doesn't want NXP to know....

> >> - Add a configuration option (devicetree? ethtool?) on which option
> >>   above to pick. This is probably what we will want to do in the long
> >>   term, but I feel like we have enough information to determine the
> >>   right thing to do most of the time (without needing manual
> >>   intervention).
> > 
> > Not sure I see the need, when long-term there is no volunteer to make
> > the Linux driver bring Aquantia PHYs to a known state regardless of
> > vendor provisioning. Until then, there is just no reason to even attempt
> > this.
> 
> I mean a config for option 1 vs 2 above.

How would this interact with Marek's proposal for phy-mode to be an
array, and some middle entity (phylink?) selects the SERDES protocol and
rate matching algorithm to use for each medium side link speed?
https://patchwork.kernel.org/project/netdevbpf/cover/20211123164027.15618-1-kabel@kernel.org/

> > Until you look at the procedure in the NXP SDK and see that things are a
> > bit more complicated to get right, like put the PHY in low power mode,
> > sleep for a while. I think a large part of that was determined experimentally,
> > out of laziness to change PHY firmware on some riser cards more than anything.
> > We still expect the production boards to have a good firmware, and Linux
> > to read what that does and adapt accordingly.
> 
> Alas, if only Marvell put stuff like this in a manual... All I have is a spec
> sheet and the register reference, and my company has an NDA...

Can't help with much more than providing this hint, sorry. All I can say
is that SERDES protocol override from Linux is possible with care, at
least on some systems. But it may be riddled with landmines.

> We aren't even using this phy on our board, so I am fine disabling rate adaptation
> for funky firmwares.

Disabling rate adaptation is one thing. But there's also the unresolved
XFI/2 issue?
