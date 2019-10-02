Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6813AC8EA2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfJBQmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfJBQmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 12:42:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA07A21848;
        Wed,  2 Oct 2019 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570034530;
        bh=+GvdqKLdJALo2p5Pa+6RnxgCWX4K+UJRXPkY+UvcGZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=meka3ZSLyUApfmBUEjF2hlHv1pXpzYI5TjezHJ+eg31mq+EwCxw0AjyGVn1nuGkBt
         RgYskIUgQLopV3062FLyyveDefdQLedC5NfQ68UDUDYZXiC0BLIG6MFhY+89nwr0Im
         OD2rb557Cysne+pX7fqMprPnmGR2V+Dy9ODqEZ6k=
Date:   Wed, 2 Oct 2019 18:42:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Le Goff <David.Legoff@silabs.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 02/20] staging: wfx: add support for I/O access
Message-ID: <20191002164207.GA1758310@kroah.com>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
 <20190919105153.15285-3-Jerome.Pouiller@silabs.com>
 <20190919163429.GB27277@lunn.ch>
 <4024590.nSQgSsaaFe@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4024590.nSQgSsaaFe@pc-42>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 04:29:09PM +0000, Jerome Pouiller wrote:
> On Thursday 19 September 2019 18:34:48 CEST Andrew Lunn wrote:
> > On Thu, Sep 19, 2019 at 10:52:35AM +0000, Jerome Pouiller wrote:
> > > +static int wfx_sdio_copy_from_io(void *priv, unsigned int reg_id,
> > > +                              void *dst, size_t count)
> > > +{
> > > +     struct wfx_sdio_priv *bus = priv;
> > > +     unsigned int sdio_addr = reg_id << 2;
> > > +     int ret;
> > > +
> > > +     BUG_ON(reg_id > 7);
> > 
> > Hi Jerome
> > 
> > BUG_ON should only be used when the system is corrupted, and there is
> > no alternative than to stop the machine, so it does not further
> > corrupt itself. Accessing a register which does not exist is not a
> > reason the kill the machine. A WARN() and a return of -EINVAL would be
> > better.
> 
> Hi Andrew,
> 
> I did not forget your suggestion. However, if everyone is agree with that, I'd 
> prefer to address it in a next pull request. Indeed, I'd prefer to keep this 
> version in sync with version 2.3.1 published on github.

Ugh, you aren't doing development outside of the kernel tree and
expecting things to stay in sync somehow are you?  That way lies madness
and a sure way to get me to just delete the staging driver.  Just work
on it in-tree please.

thanks,

greg k-h
