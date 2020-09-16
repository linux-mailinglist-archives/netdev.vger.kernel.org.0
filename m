Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5217826BCEC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgIPGZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgIPGZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:25:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A6E920684;
        Wed, 16 Sep 2020 06:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237540;
        bh=EQvU7dWi7voY9jawweC8AYpjkgUXrmGDJ3AzYRtOUM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jp0ivcc38pTfJZObDbE4McF/zDi+SuH7SEUn1ItXiPU8JsXD/mmdOot/LFQWevy60
         1WAagkeK5Qi/My9syGTN1EbQZxz4kN6278e84wftIBqZucn3PS1Dvx+uF/AQ9zJbO5
         uq4sIa65JzuR8GuEKXgiAgU1SH5GjzEMwN7C61M0=
Date:   Wed, 16 Sep 2020 08:26:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200916062614.GF142621@kroah.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Oded Gabbay <oded.gabbay@gmail.com>
> > Date: Tue, 15 Sep 2020 20:10:08 +0300
> >
> > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > into the habanalabs driver.
> > >
> > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > are in that patch's commit message.
> > >
> > > Link to v2 cover letter:
> > > https://lkml.org/lkml/2020/9/12/201
> >
> > I agree with Jakub, this driver definitely can't go-in as it is currently
> > structured and designed.
> Why is that ?
> Can you please point to the things that bother you or not working correctly?
> I can't really fix the driver if I don't know what's wrong.
> 
> In addition, please read my reply to Jakub with the explanation of why
> we designed this driver as is.
> 
> And because of the RDMA'ness of it, the RDMA
> > folks have to be CC:'d and have a chance to review this.
> As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> the kernel and we can't connect to it due to the lack of H/W support
> we have
> Therefore, I don't see why we need to CC linux-rdma.
> I understood why Greg asked me to CC you because we do connect to the
> netdev and standard eth infrastructure, but regarding the RDMA, it's
> not really the same.

Ok, to do this "right" it needs to be split up into separate drivers,
hopefully using the "virtual bus" code that some day Intel will resubmit
again that will solve this issue.

That will allow you to put the network driver portion in drivers/net/
and split the code up into the proper different pieces easier.

I recommend grabbing the virtual bus code from the archives and looking
at that for how this can be done.  Now that you are part of Intel, I'm
sure that the internal-Intel-Linux-kernel-review-process can kick in and
those developers can help you out.  If not, let me know, so I can go
kick them :)

As for the RDMA stuff, yeah, you should look at the current RDMA
interfaces and verify that those really do not work for you here, and
then document why that is in your patch submission.

thanks,

greg k-h
