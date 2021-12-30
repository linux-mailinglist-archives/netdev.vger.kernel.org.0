Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7040C48204F
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbhL3UnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242114AbhL3UnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:43:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE181C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63845B81D0C
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF13C36AE7;
        Thu, 30 Dec 2021 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640896998;
        bh=53lSGvgRbme+o+QISuMCFyk5145OgcNTKTJlIrRhbI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F7a4/bbF6Y5YHv/Jjz3qHQyJ0xLOYPqQQM18kDOi4rL8VzKe/gL217j2mZmiZreOn
         9Ye17/snyRKQXjGUvsM4c2dMwpX92zbGMpapgFRdEvhHOngHX8CyHpHQp0pH3BM1iT
         Xkv+tgpPbZEMnqIwiUw8LSS8Ja0nxW+r0lHzj8KJk7ATKpXI5clu8j6y1mACcF4tmc
         hrWZeNfCT51JFEVTQfN5bXYVJu7u/ZCWkKhbnxonhxyEhPcO3KHXSBdu1lu4Rc5vYx
         MDysOwqltZbFyHa9PrgdhF2Rj+qldpRwB8hRSz+k/k82E/zpIfWsQkAJCVsPW3DCv4
         fN7aCV9wGrgVw==
Date:   Thu, 30 Dec 2021 12:43:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
Message-ID: <20211230124316.0a6f5fe6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAOkoqZm2uA--rd1JwaR7hD4mc4Mevbu=H+eFK=+A1btmpzB7iA@mail.gmail.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
        <20211230163909.160269-5-dmichail@fungible.com>
        <Yc30mG7tPQIT2HZK@lunn.ch>
        <20211230122227.6ca6bfb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAOkoqZm2uA--rd1JwaR7hD4mc4Mevbu=H+eFK=+A1btmpzB7iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 12:30:34 -0800 Dimitris Michailidis wrote:
> On Thu, Dec 30, 2021 at 12:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 30 Dec 2021 19:04:08 +0100 Andrew Lunn wrote:
> > > > +static void fun_get_drvinfo(struct net_device *netdev,
> > > > +                       struct ethtool_drvinfo *info)
> > > > +{
> > > > +   const struct funeth_priv *fp = netdev_priv(netdev);
> > > > +
> > > > +   strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> > > > +   strcpy(info->fw_version, "N/A");
> > >
> > > Don't set it, if you have nothing useful to put in it.
> >
> > Also, if user has no way of reading the firmware version how do they
> > know when to update the FW in the flash? FW flashing seems pointless
> > without knowing the current FW version.  
> 
> It will be available, but FW hasn't settled on the API for it yet.
> There are several FW images on the devices, one will be reported here but
> will rely on devlink for the full set.

Can we defer the FW flashing to that point as well, then?
It's always a bit risky to add support for subset of functionality
upstream given the strict backward compat requirements.
