Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9EBF04F3
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390732AbfKESU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:20:27 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38048 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfKESU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:20:26 -0500
Received: by mail-pl1-f196.google.com with SMTP id w8so9868279plq.5;
        Tue, 05 Nov 2019 10:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G798+rxIu2QN6FqJb04h4OJuDPvHyjobYVKJMNxneU0=;
        b=byLiDtY/ShuYkCBK+KozCIGb5mSqybKvVaqF/xhjYX0dKDwHWxvgfaJgFEEFq7b3E5
         PbGqJTQDLzFtakvz1+hT+jAiMMPDfBq34yKeQNWO5vKz0r1f1v0lCRuVZit8xx7h77Rb
         D6HXDtShVl00CcUxzYkmUqsHYwwcOYxGKi5BbYrsw6zkhmjzRp8cZFZMNl8uTscw7Z+9
         VugOKWRHobuf551d0yV8sH3tJJeO/+r0S6ApYEAz1hUQuT6qoCpgu6zX8t3wdBNkr9W8
         HlyxQuopfjyeBzjzXO0kFPRhrzMPb77W4Pmal49qAd+g495FHhx9C9eyT/sC82gAHeuk
         XoqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G798+rxIu2QN6FqJb04h4OJuDPvHyjobYVKJMNxneU0=;
        b=p4BQFvXIr28i43yZjqC1RSrHAUV7f4s0qEvkaF+zGS9hKFH1v0jOyPQinMViNo/xdJ
         koGfPh1+zhOm/OijGv+OaXW2WEnpxH26iUZUBcXmAOIu17XZHtdysjpn7/JUFZJ5S00L
         xaO+IiSltbZWQtt99xhOmVX2rDFdb9rTgC8w3XMjXMvbSkI79XtNKnGdi4xjMpJVeuNf
         raAm35ecERkxpDvdBBxzV+0Q61s7WmFxxtTKUXiqUzTYoEQ5d/YkHThJ5JVlsJD3cKy3
         MaFqCr/YAdNozFZw/FwOanKjdOBaZUPwghsrtJYs7i1FzpfiTBpNBIMwBE4io4XvOPEt
         I6ww==
X-Gm-Message-State: APjAAAVd8FYEqyNps+gcpB2B1cTm2ALUDarGrsJ6FfMXi3gYM/XGfOFX
        Grx5gdJtp4VIRCfVFAn+sek=
X-Google-Smtp-Source: APXvYqwG7dzg8rslRt9a1tXpf6S0ZGUAB2tdjIng7nus6Drl9e32e2Mn+EJwtwgMZpFajuPLR0P1Gg==
X-Received: by 2002:a17:902:6b8a:: with SMTP id p10mr35105330plk.192.1572978025810;
        Tue, 05 Nov 2019 10:20:25 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id a16sm1453729pfc.56.2019.11.05.10.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 10:20:25 -0800 (PST)
Date:   Tue, 5 Nov 2019 10:20:22 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux@armlinux.org.uk, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
Message-ID: <20191105182022.GV57214@dtor-ws>
References: <20191105004016.GT57214@dtor-ws>
 <20191105005541.GP25745@shell.armlinux.org.uk>
 <CAKdAkRQNWXjMdJ9F1Lu=8+rHWFJwoyWu6Lcc+LFesaSTz3wspg@mail.gmail.com>
 <20191105.100423.1742603284030008698.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105.100423.1742603284030008698.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 10:04:23AM -0800, David Miller wrote:
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date: Tue, 5 Nov 2019 09:27:51 -0800
> 
> > On Mon, Nov 4, 2019 at 4:55 PM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> >>
> >> On Mon, Nov 04, 2019 at 04:40:16PM -0800, Dmitry Torokhov wrote:
> >> > Hi Linus,
> >> >
> >> > On Mon, Oct 14, 2019 at 10:40:19AM -0700, Dmitry Torokhov wrote:
> >> > > This series switches phy drivers form using fwnode_get_named_gpiod() and
> >> > > gpiod_get_from_of_node() that are scheduled to be removed in favor
> >> > > of fwnode_gpiod_get_index() that behaves more like standard
> >> > > gpiod_get_index() and will potentially handle secondary software
> >> > > nodes in cases we need to augment platform firmware.
> >> > >
> >> > > Linus, as David would prefer not to pull in the immutable branch but
> >> > > rather route the patches through the tree that has the new API, could
> >> > > you please take them with his ACKs?
> >> >
> >> > Gentle ping on the series...
> >>
> >> Given that kbuild found a build issue with patch 1, aren't we waiting
> >> for you to produce an updated patch 1?
> > 
> > No: kbuild is unable to parse instructions such as "please pull an
> > immutable branch" before applying the series. Linus' tree already has
> > needed changes.
> 
> This is targetting the networking tree so it doesn't matter what is in
> Linus's tree, it has to build against MY tree and that's what Kbuild
> tests against.
> 
> Resubmit if it builds against my tree, and no sooner.

I am confused. You were OK with merging through Linus' Walleij tree, and
you acked all 3 patches earlier...

https://lore.kernel.org/netdev/20191011.140540.2027562826793118009.davem@davemloft.net/

"So submit this into the tree that will have the dependencies."

Thanks.

-- 
Dmitry
