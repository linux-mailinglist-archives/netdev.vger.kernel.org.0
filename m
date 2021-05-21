Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D94338CDBB
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbhEUSqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239031AbhEUSqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 14:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A72061163;
        Fri, 21 May 2021 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621622685;
        bh=eBKsVhFM7t+531GuI2ga4K2E8LIKpSSLx53E4bHMCtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BbzUvGr25eQyJgqb7NjzhDZv0Uy8E9XNaa5fXPzFgxYwWTvKd1DwUKy61oNn+N4dI
         gtiId7QMFpC3pDGfMv4AHNf7rf2iyHkzu+ndN3Pll6UwE3KOzE1QUaCO3+hiva2jR+
         sB7wq3/+eJPqhTByc+VjYlJXaRRsdQtFR3W806cM=
Date:   Fri, 21 May 2021 20:44:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] b43: don't save dentries for debugfs
Message-ID: <YKf/m0DO66rPA0jb@kroah.com>
References: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
 <874kf0hr1t.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kf0hr1t.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 08:47:58PM +0300, Kalle Valo wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > There is no need to keep around the dentry pointers for the debugfs
> > files as they will all be automatically removed when the subdir is
> > removed.  So save the space and logic involved in keeping them around by
> > just getting rid of them entirely.
> >
> > By doing this change, we remove one of the last in-kernel user that was
> > storing the result of debugfs_create_bool(), so that api can be cleaned
> > up.
> >
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Chao Yu <chao@kernel.org>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: b43-dev@lists.infradead.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/wireless/broadcom/b43/debugfs.c | 34 +++------------------
> >  drivers/net/wireless/broadcom/b43/debugfs.h |  3 --
> >  2 files changed, 5 insertions(+), 32 deletions(-)
> >
> > Note, I can take this through my debugfs tree if wanted, that way I can
> > clean up the debugfs_create_bool() api at the same time.  Otherwise it's
> > fine, I can wait until next -rc1 for that to happen.
> 
> Yeah, it's best that you take this via your tree.
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Thanks, will do!

greg k-h
