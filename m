Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B076438CDB8
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbhEUSp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhEUSp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 14:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD96B61175;
        Fri, 21 May 2021 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621622673;
        bh=rogtdmYs9DKusvh+ciLKdiZ1+ttLoM5pHfLA67Ozc9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dy38Gr36usmMnfpYJPzMBAylWa32LFN5dCDbZSJ26dUMeDBZQ+CsEEAtf3Z8Io+Pl
         CbQGY9qm2zfEIgfS8N1DnlRhHxQM1ekwPAQkqMaGZH77CwtmneH8jkn/WQnw5xeQs0
         NSR40HSOkovFKQv7l3q/OQuisvKsLQ4C1XhNVVgw=
Date:   Fri, 21 May 2021 20:44:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] b43legacy: don't save dentries for debugfs
Message-ID: <YKf/jw59Zd5xswij@kroah.com>
References: <20210518163309.3702100-1-gregkh@linuxfoundation.org>
 <87zgwsgcg8.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgwsgcg8.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 08:48:39PM +0300, Kalle Valo wrote:
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
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: b43-dev@lists.infradead.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  .../net/wireless/broadcom/b43legacy/debugfs.c | 29 ++++---------------
> >  .../net/wireless/broadcom/b43legacy/debugfs.h |  3 --
> >  2 files changed, 5 insertions(+), 27 deletions(-)
> >
> > Note, I can take this through my debugfs tree if wanted, that way I can
> > clean up the debugfs_create_bool() api at the same time.  Otherwise it's
> > fine, I can wait until next -rc1 for that to happen.
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Thanks for the ack!
