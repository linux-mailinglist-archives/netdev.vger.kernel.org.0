Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AF623112A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgG1SAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:00:44 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:29979 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgG1SAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:00:44 -0400
Received: (qmail 5607 invoked by uid 89); 28 Jul 2020 18:00:42 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 28 Jul 2020 18:00:42 -0000
Date:   Tue, 28 Jul 2020 11:00:40 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 11/21] core/skbuff: add page recycling logic for
 netgpu pages
Message-ID: <20200728180040.az3xgwzmuz6grv32@bsd-mbp.dhcp.thefacebook.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-12-jonathan.lemon@gmail.com>
 <20200728162825.GC4181352@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728162825.GC4181352@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 06:28:25PM +0200, Greg KH wrote:
> On Mon, Jul 27, 2020 at 03:44:34PM -0700, Jonathan Lemon wrote:
> > From: Jonathan Lemon <bsd@fb.com>
> > 
> > netgpu pages will always have a refcount of at least one (held by
> > the netgpu module).  If the skb is marked as containing netgpu ZC
> > pages, recycle them back to netgpu.
> 
> What???

Yes, this is page refcount elevation.  ZONE_DEVICE pages do this also,
which is hidden in put_devmap_managed_page().  I would really like to
find a generic solution for this, as it has come up in other cases as
well (page recycling for page_pool, for example).  Some way to say "this
page is different", and a separate routine to release refcounts.

Can we have a discussion on this possibility?
-- 
Jonathan
