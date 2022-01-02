Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65839482C6C
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 18:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiABRi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 12:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiABRiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 12:38:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703F2C061761;
        Sun,  2 Jan 2022 09:38:55 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s1so65817270wra.6;
        Sun, 02 Jan 2022 09:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wWLcKGVB1L+M/AiUcBrGPhY5Q0k7V6b5eY3DoUOJMD8=;
        b=csZHGY26pjatP+CDAnS2WMlOd0K0PgW1V0FMFl7ejbepqwQz/MGKn+eRen/1UweBeu
         GGi0g8PdQ87eLfPzL1mDNUcGf3cF70JSGhz3D4AYURckPR/vcZ3y5hpw1fP40aIJgfTn
         Fne7LZ7shhqEYP3gT8cXawpvhAYyPbm5mBHWnTKcaEag+ms7hlf3U+q9D+b3NiF3paUS
         eRwVJxbpHMBEPdatzAl7z648n5OBTRNH16Ll703ovq0c/3RGCxYPje9jcq+QIMe1Olj+
         +FpO7R98DAJZnP+/fbvUbBUNQrivxylkP2iIcUBAk16cbT7oMhGBtvfiq1+SlNZg2Xnp
         yj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wWLcKGVB1L+M/AiUcBrGPhY5Q0k7V6b5eY3DoUOJMD8=;
        b=m014omXsg8GeKq/Pt2hX6kS0XRchoKDXq5hrZRKVcSBlXWX9x+QxCT08/4vHD5E/do
         B1hbGegeSXI4/kf3GR6XcDNq6TLEH5meaVsZd/ppK07OgdFMgnzW9OKo/xFQ2i3zUt7u
         Ii4pk/R70TOcQFMLMxvmHwojmw9RXrZJFbhN5HCZbv+T+hKmnjK0G4BOuaj50HGViyGk
         lVnfcTB0ra8K7cKqtIg3hUZO8LNKKEfwGtPS1qE4VIUgYJQJMQ2NDXil+HtxZ9heITHs
         BThGuAS1VlXdHaUNu2vR93YtNFHnYH+VkgpkNcoHKOTbrPYCtjaEaW0nZfoe7SSW/GG0
         J5AA==
X-Gm-Message-State: AOAM530Tg6CiiHYFuUxd6gTGwObsPJ5gCz3mQGE+PVmE1AiJumjT6MS8
        k6x+/nSLkqBbw+RHX95WzdZCM8meI2Q=
X-Google-Smtp-Source: ABdhPJx3omdWEPyY14zY26ZL/okoE6UgJ7jwIZfMCKhDBqivpngpgjI4u0TAz3uLzlOh77rjr6U7+A==
X-Received: by 2002:a5d:4ac1:: with SMTP id y1mr24447262wrs.588.1641145134005;
        Sun, 02 Jan 2022 09:38:54 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b16sm35872809wmq.41.2022.01.02.09.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 09:38:53 -0800 (PST)
Date:   Sun, 2 Jan 2022 18:38:51 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, jernej.skrabec@gmail.com
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
Message-ID: <YdHjK+/SzaeI/V2Q@Red>
References: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
 <Yc7e6V9/oioEpx8c@Red>
 <tencent_57960DDC83F43DA3E0A2F47DEBAD69A4A005@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_57960DDC83F43DA3E0A2F47DEBAD69A4A005@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sat, Jan 01, 2022 at 03:09:01PM +0800, Conley Lee a écrit :
> On 12/31/21 at 11:43上午, Corentin Labbe wrote:
> > Date: Fri, 31 Dec 2021 11:43:53 +0100
> > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > To: conleylee@foxmail.com
> > Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
> >  wens@csie.org, netdev@vger.kernel.org,
> >  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
> > 
> > Le Wed, Dec 29, 2021 at 09:43:51AM +0800, conleylee@foxmail.com a écrit :
> > > From: Conley Lee <conleylee@foxmail.com>
> > > 
> > > Thanks for your review. Here is the new version for this patch.
> > > 
> > > This patch adds support for the emac rx dma present on sun4i. The emac
> > > is able to move packets from rx fifo to RAM by using dma.
> > > 
> > > Change since v4.
> > >   - rename sbk field to skb
> > >   - rename alloc_emac_dma_req to emac_alloc_dma_req
> > >   - using kzalloc(..., GPF_ATOMIC) in interrupt context to avoid
> > >     sleeping
> > >   - retry by using emac_inblk_32bit when emac_dma_inblk_32bit fails
> > >   - fix some code style issues 
> > > 
> > > Change since v5.
> > >   - fix some code style issue
> > > 
> > 
> > Hello
> > 
> > I just tested this on a sun4i-a10-olinuxino-lime
> > 
> > I got:
> > [    2.922812] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): get io resource from device: 0x1c0b000, size = 4096
> > [    2.934512] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): failed to request dma channel. dma is disabled
> > [    2.945740] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): configure dma failed. disable dma.
> > [    2.957887] sun4i-emac 1c0b000.ethernet: eth0: at (ptrval), IRQ 19 MAC: 02:49:09:40:ab:3d
> > 
> > On which board did you test it and how ?
> > 
> > Regards
> 
> Sorry. I sent the email with text/html format. This email is an clean version.
> 
> In order to enable dma rx channel. `dmas` and `dma-names` properties
> should be added to emac section in dts:
> 
> emac: ethernet@1c0b000 {
> 	...
> 	dmas = <&dma SUN4I_DMA_DEDICATED 7>;
> 	dma-names = "rx";
> 	...
> }

Helo

Yes I figured that out. But you should have done a patch serie adding this.
Your patch is now applied but it is a useless change without the dtb change.
You should also probably update the driver binding (Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml) since you add new members to DT node.

Furthermore, why did you add RX only and not TX dma also ?

Probably it is too late since patch is applied but it is:
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun4i-a10-olinuxino-lime

Regards
