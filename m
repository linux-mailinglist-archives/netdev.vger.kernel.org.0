Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC5408747
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbhIMIpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238126AbhIMIpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B8360F5B;
        Mon, 13 Sep 2021 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631522639;
        bh=LXUxLd87uLqHw6KTkQAAPRMwWhykDO/zu8ngz08HWA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ag+uXb04sfWp+fEgNxuuHMwEbTDrjy5sY+q/TE3HTsRVL0dOGzTKI7n8oywE+PYo+
         /kLwcCODNwO/E2X0M0dIvHnz1VuVxpyDv7+3UTZP4FoCrOjKCGdHmghBodgc7eT7Pf
         9ZTocEnJk75pr5J1xqoKdjAUyRvbsoO0OoiYMNfs=
Date:   Mon, 13 Sep 2021 10:42:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux-Net <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Message-ID: <YT8PBf0FiniWR0zm@kroah.com>
References: <7F058034-8A2B-4C19-A39E-12B0DB117328@oracle.com>
 <YToMf8zUVNVDCAKX@kroah.com>
 <756E20E4-399D-45ED-AA9A-BB351C865C65@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756E20E4-399D-45ED-AA9A-BB351C865C65@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 02:22:32PM +0000, Haakon Bugge wrote:
> 
> 
> > On 9 Sep 2021, at 15:30, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Thu, Sep 09, 2021 at 01:10:05PM +0000, Haakon Bugge wrote:
> >> Hi Greg & Sasha,
> >> 
> >> 
> >> tl;dr: Please add 2dce224f469f ("netns: protect netns ID lookups with
> >> RCU") to the stable releases from v5.4 and older. It fixes a
> >> spin_unlock_bh() in peernet2id() called with IRQs off. I think this
> >> neat side-effect of commit 2dce224f469f was quite un-intentional,
> >> hence no Fixes: tag or CC: stable.
> > 
> > Please provide a working backport for all of the relevant kernel
> > verisons, as it does not apply cleanly on it's own.
> 
> I've done the backports. 4.9 is actually not needed, because it uses spin_{lock,unlock}_irqsave() in peernet2id(). Hence, we have an "offending" commit which this one fixes:
> 
> fba143c66abb ("netns: avoid disabling irq for netns id")
> 
> Will get'm out during the weekend.

All now queued up, thanks.

greg k-h
