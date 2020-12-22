Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C442E0CAF
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgLVP03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgLVP02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 10:26:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8438C22B2B;
        Tue, 22 Dec 2020 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608650748;
        bh=5u1OMPazxna6SdFx9055/ZLyzwNHmLasEDnc+ZdsHKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VT5ufNfTQ9zHVf2sog5IbNLe33dKHyraVdbhAhDioiIFia5wjW/bGXXyPHFCSh5kY
         CGvdJjggR7bAXGtx/LtjFgzceZ44NAnL7We7BHtHSDOQxw4BlABUrK76l5G+CtkItm
         HWi0t5/T0yE6kbm7VVDd2ByOjkbBvXlEZtFpjKlc=
Date:   Tue, 22 Dec 2020 16:27:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Message-ID: <X+IQRct0Zsm87H4+@kroah.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
 <20201104155207.128076-10-Jerome.Pouiller@silabs.com>
 <87lfdp98rw.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfdp98rw.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 05:10:11PM +0200, Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> 
> > +/*
> > + * Internal helpers.
> > + *
> > + * About CONFIG_VMAP_STACK:
> > + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA on stack
> > + * allocated data. Functions below that work with registers (aka functions
> > + * ending with "32") automatically reallocate buffers with kmalloc. However,
> > + * functions that work with arbitrary length buffers let's caller to handle
> > + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly located
> > + * buffer.
> > + */
> 
> This sounds very hacky to me, I have understood that you should never
> use stack with DMA.

You should never do that because some platforms do not support it, so no
driver should ever try to do that as they do not know what platform they
are running on.

thanks,

greg k-h
