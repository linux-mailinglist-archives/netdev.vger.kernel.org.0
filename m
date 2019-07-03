Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82555E296
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGCLIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCLIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 07:08:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 425E721882;
        Wed,  3 Jul 2019 11:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562152093;
        bh=eUAofhSVMslURLsFFrIei9Cjn3qD2rxuwcSKgkuaHB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xo5f1QcvJZiCFHf6wkH3yfSpiAGhvudzsCoWPukPJnDsBvYgzqXtIMxertwJ6h1oL
         Y0KMp3H0VbNylkO2G7KjYQztVxjIKyBM9w+p/b9JPGiuHeP7RjWSaj7/G0/+z3xvP0
         nrsm9li85lEptjkCEMXrDnRgYh6kOrVDvT8RFVjA=
Date:   Wed, 3 Jul 2019 13:08:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rt2x00: no need to check return value of debugfs_create
 functions
Message-ID: <20190703110810.GA18323@kroah.com>
References: <20190703065631.GA28822@kroah.com>
 <20190703105759.GB30509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703105759.GB30509@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:58:00PM +0200, Stanislaw Gruszka wrote:
> On Wed, Jul 03, 2019 at 08:56:31AM +0200, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Because we don't need to save the individual debugfs files and
> > directories, remove the local storage of them and just remove the entire
> > debugfs directory in a single call, making things a lot simpler.
> > 
> > Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> > Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  .../net/wireless/ralink/rt2x00/rt2x00debug.c  | 100 ++++--------------
> >  1 file changed, 23 insertions(+), 77 deletions(-)
> 
> This patch will not apply on wireless-drivers-next due to my recent
> change which add new debugfs file:
> 
> commit e7f15d58dfe43f18199251f430d7713b0b8fad34
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Thu May 2 11:07:00 2019 +0200
> 
>     rt2x00: add restart hw
> 
> Could you please rebase the patch ? (I can do this as well
> if you want me to).

No problem, I can rebase and redo it, I'll go suck down the
wireless-drivers-next tree and resend it, thanks for leting me know.

greg k-h
