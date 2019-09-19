Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46EAB7F48
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbfISQkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 12:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbfISQkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 12:40:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66A5D2067B;
        Thu, 19 Sep 2019 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568911231;
        bh=qCz7XbvXfrl9oabTRXwqcnH8N8PB63x5aI3wL4H34mU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZS/pDHFPv7jIulCXvFILgjD0pN463LF2IKbKGWNOcgpedvny3d7f7t1aMMsvDlDkn
         f2bRxD5Te6IezM3nDftV8Jyp17HG2IDX2re+xEVryEr+jESSbktbbAi3RDaz1Teb4y
         36k5XpWwueJSOnnv/xhdqWf3Zms2VEfb83LrWp34=
Date:   Thu, 19 Sep 2019 18:40:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Le Goff <David.Legoff@silabs.com>
Subject: Re: [PATCH 02/20] staging: wfx: add support for I/O access
Message-ID: <20190919164029.GA4045207@kroah.com>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
 <20190919105153.15285-3-Jerome.Pouiller@silabs.com>
 <20190919163429.GB27277@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919163429.GB27277@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 06:34:29PM +0200, Andrew Lunn wrote:
> On Thu, Sep 19, 2019 at 10:52:35AM +0000, Jerome Pouiller wrote:
> > +static int wfx_sdio_copy_from_io(void *priv, unsigned int reg_id,
> > +				 void *dst, size_t count)
> > +{
> > +	struct wfx_sdio_priv *bus = priv;
> > +	unsigned int sdio_addr = reg_id << 2;
> > +	int ret;
> > +
> > +	BUG_ON(reg_id > 7);
> 
> Hi Jerome
> 
> BUG_ON should only be used when the system is corrupted, and there is
> no alternative than to stop the machine, so it does not further
> corrupt itself. Accessing a register which does not exist is not a
> reason the kill the machine. A WARN() and a return of -EINVAL would be
> better.

dev_warn() is even better.

But that's one reason this is going into staging I guess :)

thanks,

greg k-h
