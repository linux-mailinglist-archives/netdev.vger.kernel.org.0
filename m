Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98CC18D575
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCTROy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCTROx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 13:14:53 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E602F20709;
        Fri, 20 Mar 2020 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584724493;
        bh=wsQ9ZIqce6T8WDfwtxBoI75BeEpfI73B6LCZCTrvm/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IGgZO4Tp0PQoYjFdDoTxzR4cUBZnGSxq3ZW8acBlBIdX/EFaIjI06SirfpHAr3wv3
         Y6mToxghV0maF4ICA5FRQDH19eR0yYxGv08XRyQL0nEQMP3dMipKQtZjgo0LZcmX3D
         1pvps0uPSBRlpuFfG19YqwGGQXnLGSRwSBQnyIrg=
Date:   Fri, 20 Mar 2020 10:14:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 net-next 4/8] octeontx2-vf: Ethtool support
Message-ID: <20200320101451.0036a8cc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CA+sq2Cf_enB_wKmoFtiHVFuT+eLeP07GRnzbioxfa=ND9n+_ig@mail.gmail.com>
References: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
        <1584623248-27508-5-git-send-email-sunil.kovvuri@gmail.com>
        <20200319155631.GC27807@lunn.ch>
        <20200319154211.4bf7cf01@kicinski-fedora-PC1C0HJN>
        <CA+sq2Cf_enB_wKmoFtiHVFuT+eLeP07GRnzbioxfa=ND9n+_ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 12:35:15 +0530 Sunil Kovvuri wrote:
> On Fri, Mar 20, 2020 at 4:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 19 Mar 2020 16:56:31 +0100 Andrew Lunn wrote:  
> > > On Thu, Mar 19, 2020 at 06:37:24PM +0530, sunil.kovvuri@gmail.com wrote:  
> > > > From: Tomasz Duszynski <tduszynski@marvell.com>
> > > >
> > > > Added ethtool support for VF devices for
> > > >  - Driver stats, Tx/Rx perqueue stats
> > > >  - Set/show Rx/Tx queue count
> > > >  - Set/show Rx/Tx ring sizes
> > > >  - Set/show IRQ coalescing parameters
> > > >  - RSS configuration etc
> > > >
> > > > It's the PF which owns the interface, hence VF
> > > > cannot display underlying CGX interface stats.
> > > > Except for this rest ethtool support reuses PF's
> > > > APIs.
> > > >
> > > > Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> > > > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>  
> > >
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>  
> >
> > But they didn't add static inlines, no? Don't the dependencies
> > look strange?
> >
> > VF depends on PF code, but ethtool code (part of PF) also needs
> > symbols from the VF..
> >  
> 
> ethtool code has no dependency on symbols from the VF driver.
> PF driver compiles and module loads fine without enabling VF driver.
> While getting rid of __weak fn()s i forgot to remove EXPORT symbols
> from VF driver.
> I will remove and resubmit.

I see. I saw the exports and assumed it gets called. Thanks.
