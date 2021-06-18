Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2308B3AC079
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 03:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhFRBU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 21:20:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhFRBU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 21:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G2TbT6vZaY52J+Jfk/VAd2BbCLwYdAr/yuhd+MfL9Xk=; b=jC6Cc4AGyANpa+v03+mqqWKi4O
        yPnGxJD3xyas8WHH7Vfsfm/xjXsTt3a/e0Y7eNQMwcs2EDYupmOOU67jCL8Jx6X0I+OGpmDI0VGq7
        U65h8aw5Q4juoSYjHh87yH6f21A2mU9Yvn0ru1V2Dra82wLxGt/wQt/AWE3hCj1YaAEs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lu39E-009ztR-AN; Fri, 18 Jun 2021 03:18:16 +0200
Date:   Fri, 18 Jun 2021 03:18:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     linux-firmware@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v3.0 with policer support
Message-ID: <YMv0WEchRT25GC0Q@lunn.ch>
References: <20210617154206.GA17555@plvision.eu>
 <YMt8GvxSen6gB7y+@lunn.ch>
 <20210617165824.GA5220@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617165824.GA5220@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 07:58:24PM +0300, Vadym Kochan wrote:
> Hi Andrew,
> 
> On Thu, Jun 17, 2021 at 06:45:14PM +0200, Andrew Lunn wrote:
> > On Thu, Jun 17, 2021 at 06:42:06PM +0300, Vadym Kochan wrote:
> > > The following changes since commit 0f66b74b6267fce66395316308d88b0535aa3df2:
> > > 
> > >   cypress: update firmware for cyw54591 pcie (2021-06-09 07:12:02 -0400)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   https://github.com/PLVision/linux-firmware.git mrvl-prestera
> > > 
> > > for you to fetch changes up to a43d95a48b8e8167e21fb72429d860c7961c2e32:
> > > 
> > >   mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support (2021-06-17 18:22:57 +0300)
> > > 
> > > ----------------------------------------------------------------
> > > Vadym Kochan (1):
> > >       mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support
> > > 
> > >  mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 13721584 -> 13721676 bytes
> > >  1 file changed, 0 insertions(+), 0 deletions(-)
> > 
> > Hi Vadym
> > 
> > You keep the version the same, but add new features? So what does the
> > version number actually mean? How does the driver know if should not
> > use the policer if it cannot tell old version 3.0 from new version
> > 3.0?  How is a user supposed to know if they have old version 3.0
> > rather than new 3.0, when policer fails?
> > 
> >     Andrew
> 
> So the last 'sub' x.x.1 version will be showed in dmesg output and via:
> 
>     $ ethtool -i $PORT
> 
>     ...
>     firmware-version: 3.0.1

That is pretty unfriendly, the filename saying one thing, the kernel
another.

If you look back in the git history, are there other firmware blobs
which get updated while retaining the same version? If this is very
unusual, you probably should not be doing it. If it is common
practice, then i will be surprised, and it is probably acceptable.

I suppose you could consider another alternative: Make
mrvl/prestera/mvsw_prestera_fw-v3.0.img a symbolic link, and it would
point to mrvl/prestera/mvsw_prestera_fw-v3.0.1.img.

	  Andrew
