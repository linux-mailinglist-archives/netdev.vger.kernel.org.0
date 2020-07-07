Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE1E216E77
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgGGOQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgGGOQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 10:16:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD3B206E2;
        Tue,  7 Jul 2020 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594131376;
        bh=ysSKE2uB/6vITWzGT/RAPH4Pi6/54GSo2L77diI9b8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wWZpKJDp3qP4kv081Iums/NwSMEB3F3WcU0qhNoZpScVwyxHC4ykicwjmZbg1kYe0
         G00WOEHsoSu+fMkNMqk++5Gyrl+cDQ2X9A8P5M2OOv/j3szFmpsJACEgM4D24zhDBf
         ebS469uKP+ZaAiMj6lWqx9GhRxXO5iyDOO1BjKCM=
Date:   Tue, 7 Jul 2020 16:16:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200707141614.GC54123@kroah.com>
References: <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
 <20200701065915.GF2044019@kroah.com>
 <8b88749c197f07c7c70273614dd6ee8840b2b14d.camel@linux.intel.com>
 <CAPcyv4g9xCMh5cQF0qbObpHX5ckMK_SWPO12BcXF2ijn8MnckA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g9xCMh5cQF0qbObpHX5ckMK_SWPO12BcXF2ijn8MnckA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 04:02:57PM -0700, Dan Williams wrote:
> On Thu, Jul 2, 2020 at 6:44 AM Ranjani Sridharan
> <ranjani.sridharan@linux.intel.com> wrote:
> [..]
> > > > Hi Jason,
> > > >
> > > > We're addressing the naming in the next version as well. We've had
> > > > several people reject the name virtual bus and we've narrowed in on
> > > > "ancillary bus" for the new name suggesting that we have the core
> > > > device that is attached to the primary bus and one or more sub-
> > > > devices
> > > > that are attached to the ancillary bus. Please let us know what you
> > > > think of it.
> > >
> > > I'm thinking that the primary person who keeps asking you to create
> > > this
> > > "virtual bus" was not upset about that name, nor consulted, so why
> > > are
> > > you changing this?  :(
> > >
> > > Right now this feels like the old technique of "keep throwing crap at
> > > a
> > > maintainer until they get so sick of it that they do the work
> > > themselves..."
> >
> > Hi Greg,
> >
> > It wasnt our intention to frustrate you with the name change but in the
> > last exchange you had specifically asked for signed-off-by's from other
> > Intel developers. In that process, one of the recent feedback from some
> > of them was about the name being misleading and confusing.
> >
> > If you feel strongly about the keeping name "virtual bus", please let
> > us know and we can circle back with them again.
> 
> Hey Greg,
> 
> Feel free to blame me for the naming thrash it was part of my internal
> review feedback trying to crispen the definition of this facility. I
> was expecting the next revision to come with the internal reviewed-by
> and an explanation of all the items that were changed during that
> review.

That would have been nice to see, instead of it "leaking" like this :(

thanks,

greg k-h
