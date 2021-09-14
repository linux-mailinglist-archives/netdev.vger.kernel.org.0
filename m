Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6554240A22D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 02:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhINAvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 20:51:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhINAvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 20:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9NA9VYfHVNcQWnB9VDYoxKrbM3NRkH7ApspuZEf1OhI=; b=Xu/vURJegK1rqjsjEfNV1QzFqf
        tjgyO2hmKYYHAKYvYw4YerAhKWIFoDnMLs41rFdG6J/ZnoAHu0evJ64frnnZVo7IEEddw3OcD6b0Y
        /JVUiCd9Vbx9xguGlWO/jbm5NyYOj+SopqLPaOujQPu+Hr572kgOOumtxRyxNpun8Ufc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPweX-006US1-2z; Tue, 14 Sep 2021 02:50:25 +0200
Date:   Tue, 14 Sep 2021 02:50:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH net-next] net: wwan: iosm: firmware flashing and coredump
 collection
Message-ID: <YT/x0XpavbOIrW3N@lunn.ch>
References: <20210913130412.898895-1-m.chetan.kumar@linux.intel.com>
 <20210913092554.21bdbb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913092554.21bdbb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 09:25:54AM -0700, Jakub Kicinski wrote:
> On Mon, 13 Sep 2021 18:34:12 +0530 M Chetan Kumar wrote:
> > This patch brings-in support for M.2 7560 Device firmware flashing &
> > coredump collection using devlink.
> > - Driver Registers with Devlink framework.
> > - Register devlink params callback for configuring device params
> >   required in flashing or coredump flow.
> > - Implements devlink ops flash_update callback that programs modem
> >   firmware.
> > - Creates region & snapshot required for device coredump log collection.
> > 
> > On early detection of device in boot rom stage. Driver registers with
> > Devlink framework and establish transport channel for PSI (Primary Signed
> > Image) injection. Once PSI is injected to device, the device execution
> > stage details are read to determine whether device is in flash or
> > exception mode.
> 
> Is this normal operation flow for the device? After each boot device
> boots from the rom image and then user has to "inject" the full FW
> image with devlink?

If it is, then this sounds like to the wrong interface for
firmware. The driver should be using request_firmware().

	  Andrew
