Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E4022BE5F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgGXG5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgGXG5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 02:57:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875D520714;
        Fri, 24 Jul 2020 06:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595573865;
        bh=adW6TyA/SPwSkxmNhrl3jn0h03AFaHiMV+zf1Zarero=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aVCxZM/LaH60D7KBxpNKWQmpMxtoN+V+d3hy3Pc+GwgYUa3Rte5cUjjUueQtJ9Z9K
         HfqYiXKLnfXpxHfWySNj/Kez/LxKxpxF1uxkCoTRSF5nfhc+AQJv264RWPEWzI5txF
         2al36PdHWZYTIg61KP+TwjqY4l2HwV8F1nOPevBU=
Date:   Fri, 24 Jul 2020 08:57:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     David Miller <davem@davemloft.net>, isdn@linux-pingi.de,
        arnd@arndb.de, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrianov@ispras.ru,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] drivers: isdn: capi: Fix data-race bug
Message-ID: <20200724065747.GF3880088@kroah.com>
References: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
 <20200723.151158.2190104866687627036.davem@davemloft.net>
 <20200724044807.GA474@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724044807.GA474@madhuparna-HP-Notebook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 10:18:07AM +0530, Madhuparna Bhowmik wrote:
> On Thu, Jul 23, 2020 at 03:11:58PM -0700, David Miller wrote:
> > From: madhuparnabhowmik10@gmail.com
> > Date: Wed, 22 Jul 2020 22:53:29 +0530
> > 
> > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > 
> > > In capi_init(), after register_chrdev() the file operation callbacks
> > > can be called. However capinc_tty_init() is called later.
> > > Since capiminors and capinc_tty_driver are initialized in
> > > capinc_tty_init(), their initialization can race with their usage
> > > in various callbacks like in capi_release().
> > > 
> > > Therefore, call capinc_tty_init() before register_chrdev to avoid
> > > such race conditions.
> > > 
> > > Found by Linux Driver Verification project (linuxtesting.org).
> > > 
> > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > I agree with Arnd that this just exchanges one set of problems for
> > another.
> 
> Thanks Arnd and David, for reviewing the patch.
> Do you have any suggestions on how to fix this correctly?

Based on the installed base of ISDN systems, and the fact that no one
has ever actually hit this race and reported it ever, I wouldn't worry
about it :)

thanks,

greg k-h
