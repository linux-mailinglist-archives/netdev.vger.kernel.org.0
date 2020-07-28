Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C813E2311A5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbgG1S0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728401AbgG1S0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C9F20714;
        Tue, 28 Jul 2020 18:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595960795;
        bh=aXTVVd/PUq8HmC+vBJeiVp8AV7G5PpSGCFiIIoApAkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=odHdzjzuQYx+MPDxNKNSDwptoi/CNSJvKhnXrdaeAXof1G5zuITqzK2dsq1SBzzOv
         oNzXdSyOscyi5V7fyLbWH6BgNmjw89ChZAgq2RqDY1f8SjVL3kb/qWVAHqFgFwynyP
         V4UjLdDbXA6jJwR/bw5sw3KDSpZ6c+c5JsYAfqAE=
Date:   Tue, 28 Jul 2020 20:26:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 11/21] core/skbuff: add page recycling logic for
 netgpu pages
Message-ID: <20200728182628.GB328787@kroah.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-12-jonathan.lemon@gmail.com>
 <20200728162825.GC4181352@kroah.com>
 <20200728180040.az3xgwzmuz6grv32@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728180040.az3xgwzmuz6grv32@bsd-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:00:40AM -0700, Jonathan Lemon wrote:
> On Tue, Jul 28, 2020 at 06:28:25PM +0200, Greg KH wrote:
> > On Mon, Jul 27, 2020 at 03:44:34PM -0700, Jonathan Lemon wrote:
> > > From: Jonathan Lemon <bsd@fb.com>
> > > 
> > > netgpu pages will always have a refcount of at least one (held by
> > > the netgpu module).  If the skb is marked as containing netgpu ZC
> > > pages, recycle them back to netgpu.
> > 
> > What???
> 
> Yes, this is page refcount elevation.  ZONE_DEVICE pages do this also,
> which is hidden in put_devmap_managed_page().  I would really like to
> find a generic solution for this, as it has come up in other cases as
> well (page recycling for page_pool, for example).  Some way to say "this
> page is different", and a separate routine to release refcounts.
> 
> Can we have a discussion on this possibility?

Then propose a generic solution, not a "solution" like this.

greg k-h
