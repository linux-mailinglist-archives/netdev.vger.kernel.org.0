Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74A12D3442
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgLHUe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgLHUe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:34:26 -0500
Date:   Tue, 8 Dec 2020 21:16:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607454968;
        bh=4YSWBy4Ze2XZ3O8tBftNKde9EUBuyuIjWyN2ZrpIxvM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=nVhOppfF7il/vCHcMJCm1p+Lwcwkzojx2RGNhEPtG1Dv+YTRJ9vEAXICqnFy8m/7l
         LczP4xd8OmolrTxvA4gv1axoL84PJcFJTd+onQ5SPme9rVbXItlpxzqx9I5AS6bBpp
         o/mwtf7F3RUk4qEJdpqfyF/zgb23zfEHFOArRlYM4g9XygiZ3iVKm0dM+4QiR1tQDY
         WqnO+lsDOfT4jkJl7dQFu3aqsF0XEUg6K2V8+0BV1L8iN4st3b7HlAa0xmzKjIen+A
         7NirlgEudHRNsUeIXfl+9ta6Kl5XgiNWnlVBYgFmM01AcncsTQMbWvOuRPDcyERUEx
         ezwxmXxjQUxCg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jeffrey Hugo <jhugo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
Message-ID: <20201208191603.GJ4430@unreal>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
 <20201201120302.474d4c9b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <817a4346-efb7-cfe5-0678-d1b60d06627d@codeaurora.org>
 <20201201185506.77c4b3df@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <f22eaead-fd25-8b20-7ca1-ae3f535347d4@codeaurora.org>
 <20201206083302.GA691268@unreal>
 <20201208165927.GE9925@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208165927.GE9925@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:29:27PM +0530, Manivannan Sadhasivam wrote:
> On Sun, Dec 06, 2020 at 10:33:02AM +0200, Leon Romanovsky wrote:
> > On Tue, Dec 01, 2020 at 09:59:53PM -0700, Jeffrey Hugo wrote:
> > > On 12/1/2020 7:55 PM, Jakub Kicinski wrote:
> > > > On Tue, 1 Dec 2020 13:48:36 -0700 Jeffrey Hugo wrote:
> > > > > On 12/1/2020 1:03 PM, Jakub Kicinski wrote:
> > > > > > On Tue, 1 Dec 2020 12:40:50 -0700 Jeffrey Hugo wrote:
> > > > > > > On 12/1/2020 12:29 PM, Jakub Kicinski wrote:
> > > > > > > > On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:
> > > > > > > > > This patch series adds support for UCI driver. UCI driver enables userspace
> > > > > > > > > clients to communicate to external MHI devices like modem and WLAN. UCI driver
> > > > > > > > > probe creates standard character device file nodes for userspace clients to
> > > > > > > > > perform open, read, write, poll and release file operations. These file
> > > > > > > > > operations call MHI core layer APIs to perform data transfer using MHI bus
> > > > > > > > > to communicate with MHI device. Patch is tested using arm64 based platform.
> > > > > > > >
> > > > > > > > Wait, I thought this was for modems.
> > > > > > > >
>
> [...]
>
> > Like it or not, but Jakub is absolutely right with his claim that
> > providing user-visible interfaces without any standardization is proven
> > as wrong.
> >
>
> Everybody agrees with standardizing things but the problem is, the
> standardization will only happen when more than one person implements the
> same functionality.

From my experience in RDMA and netdev, I can't agree with both of your
statements. There are a lot of people who see standardization as a bad
thing. Also we are pushing even one person to make user visible interfaces
right from the beginning without relation to how wide it will be adopted
later.

Thanks
