Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840EB11A52D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfLKHiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfLKHiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 02:38:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD0A5208C3;
        Wed, 11 Dec 2019 07:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576049893;
        bh=oWuub5EXQa2UcXV8h8dA9dFT2L0EsWY/1ZrBW4KAwxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TvuIY9ULFr22p6P34314qbKp8ZUQ5MvoYZu7OSrExa+lLeBO5WdvEzrDUqB8stwdT
         0N7G2neoqdAP7YRgljopkdgHNEzQyFjFB3Luf2sLJAza3z32mHNyedzf8w8TCkVup5
         k3deWoBevG+tC61VikgSNawVQr82f81LPK2AMW+s=
Date:   Wed, 11 Dec 2019 08:38:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>
Cc:     "Aviraj Cj (acj)" <acj@cisco.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>
Subject: Re: [PATCH 1/2] net: stmmac: use correct DMA buffer size in the RX
 descriptor
Message-ID: <20191211073810.GA398293@kroah.com>
References: <20191210170659.61829-1-acj@cisco.com>
 <20191210205542.GB4080658@kroah.com>
 <20191210214014.GV20426@zorba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210214014.GV20426@zorba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:40:17PM +0000, Daniel Walker (danielwa) wrote:
> On Tue, Dec 10, 2019 at 09:55:42PM +0100, Greg KH wrote:
> > On Tue, Dec 10, 2019 at 09:06:58AM -0800, Aviraj CJ wrote:
> > > We always program the maximum DMA buffer size into the receive descriptor,
> > > although the allocated size may be less. E.g. with the default MTU size
> > > we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> > > memory may get corrupted.
> > > 
> > > Program DMA using exact buffer sizes.
> > > 
> > > [Adopted based on upstream commit c13a936f46e3321ad2426443296571fab2feda44
> > > ("net: stmmac: use correct DMA buffer size in the RX descriptor")
> > > by Aaro Koskinen <aaro.koskinen@nokia.com> ]
> > 
> > Adopted to what?
> > 
> > What is this patch for, it looks just like the commit you reference
> > here.
> > 
> > totally confused,
> 
> 
> We're using the patches on the v4.4 -stable branch. It doesn't have these patches and
> the backport had rejects.

Ok, but commit "c13a936f46e3321ad2426443296571fab2feda44" is not in
Linus's tree, and so I think you really mean 583e63614149 ("net: stmmac:
use correct DMA buffer size in the RX descriptor") which is only
included in 4.19 and newer kernels.

So why would this need to go to 4.4.y?

And if so, it needs to be explicitly stated as such, you all have read
the stable kernel rules file, right?

Please fix up and resend properly, as well as providing a version for
newer kernels also if you really want this in a 4.4.y release.

As David said, to not do so just causes a total waste of developer time
trying to figure out what you all are wanting to do here...

thanks,

greg k-h
