Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D352972A1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463306AbgJWPo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S463290AbgJWPo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 11:44:28 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A8120797;
        Fri, 23 Oct 2020 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603467867;
        bh=H8eXypMJmvED8c4AbWAZuLI6IlQyVnn99rD6pDfTxgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9MfPtIHp+Uz1Ui3DHvurgveBtfd/zcr5hNWhz18Kjys1DJcwHdl2+zvxNHscez/Q
         OaY5C2uXNiHuVmr98eaLO9pqHTmQdB7TbgN1ZrxjkzSYI1S7lH56rii2rs62fJ1xUl
         nHrKD8L4xfJO8h+q1n0aLWBICCP7mivsBYm8R4ng=
Date:   Fri, 23 Oct 2020 08:44:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        eric.dumazet@gmail.com, Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>
Subject: Re: [PATCH v6 1/2] bus: mhi: Add mhi_queue_is_full function
Message-ID: <20201023084425.22bbf069@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <8c384f6a-df21-1a39-f586-6077da373c04@codeaurora.org>
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
        <8c384f6a-df21-1a39-f586-6077da373c04@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 20:06:37 -0700 Hemant Kumar wrote:
> > @@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
> >   }
> >   EXPORT_SYMBOL_GPL(mhi_queue_buf);
> >   
> > +bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir)
> > +{
> > +	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
> > +	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
> > +					mhi_dev->ul_chan : mhi_dev->dl_chan;
> > +	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
> > +
> > +	return mhi_is_ring_full(mhi_cntrl, tre_ring);
> > +}
> > +EXPORT_SYMBOL_GPL(mhi_queue_is_full);
> >   
> i was wondering if you can make use of mhi_get_free_desc() API (pushed 
> as part of MHI UCI - User Control Interface driver) here?

Let me ask you one more time. Where is this MHI UCI code you're talking
about?

linux$ git remote show linux
* remote linux
  Fetch URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  Push  URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  HEAD branch: master
  Remote branch:
    master tracked
linux$ git fetch linux
linux$ git checkout linux/master
HEAD is now at f9893351acae Merge tag 'kconfig-v5.10' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild
linux$ git grep mhi_get_free_desc
linux$
