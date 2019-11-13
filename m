Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACFFBAA6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 22:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfKMV0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 16:26:20 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46928 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMV0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 16:26:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id l4so1591453plt.13;
        Wed, 13 Nov 2019 13:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kUPGjuMAO+elLx2tx2jBnDowMVSrPNVOZ3A3hy8rwgw=;
        b=tMtWOa/Tu9MUDO8ylY3mvZT82GSoYCFZMaUDAIpjmjXqfcp+gjRX5adP+crRv+4hS7
         6zTWWJ98DoSl2uZvmSJ4CrlQFAT8xGmzEHJ50IOOfqUCP968wm+0CiSHs3ra2aiHi/8x
         cKdoRPgUIKnZV4U9JN79z7IQmVHTn7qqNv92tCgZteMU+/bwfi4YEDxQjy8PaRES0V89
         Ht9Ro1TTZdvIbbTPHyg99bHZDiN6uPFDEc3GCVcTUY1imbMM0UKkr22TA4ezVS0f9wr/
         unn8iYzQO3ouDI5COAaHAGjuk1wnlmH/LkwEIw/uvkbf8pO4igxb6lSf3iW7zNncCM1O
         VLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kUPGjuMAO+elLx2tx2jBnDowMVSrPNVOZ3A3hy8rwgw=;
        b=MiMcuTCJAysOmd0JUH7pQ8nfX/bUO64SydBvBRMuYMbKWs1dQj1a4SQSHvRiA+giW9
         DPmwyhP4HtiY9d4qu9jlkEHW+QtKf+6APIPXVOqtviAUZsB940JU8hVyYvp2E72GQBoy
         smlYjpSSlcxGcCCDIl8V7u2znN2OYyFTG3Lzw1Z3kkw8zCTZXZJfyuJ0UfScqGyDAj2m
         ykrpjqki/ng0KmdSFZm2mK1hK24NwaF+kbDbITWhyINE9zM2pUko4EKwFcBW10I/s/3g
         W3WIEJTsKSCU3w7ILB/UZnhxTE7PAMMvUVEvw3hoZgl7eFI3BCWFxOlq4pr9lnZX3k6r
         GCmw==
X-Gm-Message-State: APjAAAUq1EHsrmFCqg3EC3o76WwPnJEJMtYWteo6epcPLcORcGBHIjCd
        Wx+fWxolRSNiokxMhjOWsPtSPOVx
X-Google-Smtp-Source: APXvYqwJy0pbLjIQeTHRotm4oI+p1es1FG6qBeLb2MnXJLGhHgCfshAN/Crx0ke8xDG4xfD8GnmuFg==
X-Received: by 2002:a17:902:9b85:: with SMTP id y5mr5998531plp.334.1573680377188;
        Wed, 13 Nov 2019 13:26:17 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id a6sm3996969pja.30.2019.11.13.13.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 13:26:16 -0800 (PST)
Date:   Wed, 13 Nov 2019 13:26:14 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux@armlinux.org.uk, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
Message-ID: <20191113212614.GS13374@dtor-ws>
References: <20191105004016.GT57214@dtor-ws>
 <20191105005541.GP25745@shell.armlinux.org.uk>
 <CAKdAkRQNWXjMdJ9F1Lu=8+rHWFJwoyWu6Lcc+LFesaSTz3wspg@mail.gmail.com>
 <20191105.100423.1742603284030008698.davem@davemloft.net>
 <20191105182022.GV57214@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105182022.GV57214@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 10:20:22AM -0800, Dmitry Torokhov wrote:
> On Tue, Nov 05, 2019 at 10:04:23AM -0800, David Miller wrote:
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Date: Tue, 5 Nov 2019 09:27:51 -0800
> > 
> > > On Mon, Nov 4, 2019 at 4:55 PM Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > >>
> > >> On Mon, Nov 04, 2019 at 04:40:16PM -0800, Dmitry Torokhov wrote:
> > >> > Hi Linus,
> > >> >
> > >> > On Mon, Oct 14, 2019 at 10:40:19AM -0700, Dmitry Torokhov wrote:
> > >> > > This series switches phy drivers form using fwnode_get_named_gpiod() and
> > >> > > gpiod_get_from_of_node() that are scheduled to be removed in favor
> > >> > > of fwnode_gpiod_get_index() that behaves more like standard
> > >> > > gpiod_get_index() and will potentially handle secondary software
> > >> > > nodes in cases we need to augment platform firmware.
> > >> > >
> > >> > > Linus, as David would prefer not to pull in the immutable branch but
> > >> > > rather route the patches through the tree that has the new API, could
> > >> > > you please take them with his ACKs?
> > >> >
> > >> > Gentle ping on the series...
> > >>
> > >> Given that kbuild found a build issue with patch 1, aren't we waiting
> > >> for you to produce an updated patch 1?
> > > 
> > > No: kbuild is unable to parse instructions such as "please pull an
> > > immutable branch" before applying the series. Linus' tree already has
> > > needed changes.
> > 
> > This is targetting the networking tree so it doesn't matter what is in
> > Linus's tree, it has to build against MY tree and that's what Kbuild
> > tests against.
> > 
> > Resubmit if it builds against my tree, and no sooner.
> 
> I am confused. You were OK with merging through Linus' Walleij tree, and
> you acked all 3 patches earlier...
> 
> https://lore.kernel.org/netdev/20191011.140540.2027562826793118009.davem@davemloft.net/
> 
> "So submit this into the tree that will have the dependencies."

So what is the final verdict? Merge through Linus Walleij's tree, wait
until after 5.5 merge window?

Thanks.

-- 
Dmitry
