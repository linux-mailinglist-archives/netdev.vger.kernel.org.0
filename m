Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C6D2E19A7
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgLWIJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727396AbgLWIJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 03:09:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34D9207D0;
        Wed, 23 Dec 2020 08:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608710953;
        bh=J6kqcsEQ81XygXB0ywB1eT/zGzb+piaMy92Q6gb+uHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAh3GZlUGSZgvf7GPACtF31xHjjf3snVP8mRBuA2SkcEP7jH0QBg7K9kHYfsdcwua
         gxXrB+7OxQKakmE3oS0dIBaB6ebNnhJOu6cO3mraHT60VPUXpTmdicnpydwtf5l2tL
         END9bkupuxwDPEHSXNaG8Xgkd2vnjLV3OzcQyZTM=
Date:   Wed, 23 Dec 2020 09:09:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Message-ID: <X+L7JmeL086SGFum@kroah.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
 <87lfdp98rw.fsf@codeaurora.org>
 <X+IQRct0Zsm87H4+@kroah.com>
 <5567602.MhkbZ0Pkbq@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5567602.MhkbZ0Pkbq@pc-42>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 09:01:33AM +0100, Jérôme Pouiller wrote:
> On Tuesday 22 December 2020 16:27:01 CET Greg Kroah-Hartman wrote:
> > On Tue, Dec 22, 2020 at 05:10:11PM +0200, Kalle Valo wrote:
> > > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > >
> > > > +/*
> > > > + * Internal helpers.
> > > > + *
> > > > + * About CONFIG_VMAP_STACK:
> > > > + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA on stack
> > > > + * allocated data. Functions below that work with registers (aka functions
> > > > + * ending with "32") automatically reallocate buffers with kmalloc. However,
> > > > + * functions that work with arbitrary length buffers let's caller to handle
> > > > + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly located
> > > > + * buffer.
> > > > + */
> > >
> > > This sounds very hacky to me, I have understood that you should never
> > > use stack with DMA.
> > 
> > You should never do that because some platforms do not support it, so no
> > driver should ever try to do that as they do not know what platform they
> > are running on.
> 
> Just to be curious, why these platforms don't support DMA in a stack
> allocated area?

Hardware is odd :(

> If the memory is contiguous (= not vmalloced), correctly
> aligned and in the first 4GB of physical memory, it should be sufficient,
> shouldn't?

Nope, sorry, this just does not work at all on many platforms.

thanks,

greg k-h
