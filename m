Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A1367C79
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhDVI14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhDVI1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 04:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D34DE613D1;
        Thu, 22 Apr 2021 08:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619080040;
        bh=LS/NEzSKx2GRkFlEEFV0SXW4rgTOUa82+jGpdMVITaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rKy5TDzRXqv52AOAOvC40y2CdPyHU6amaTWKJGwyhRZQBHNuZgGFbWfPWzPgyQAcq
         OqojzsPUX6IQQXYHwwkCmWD4sna3vtqvDGJshCfmFn092RUWyL4qhuWslWBhJ3RppK
         e67tD2+GNEuy9zmdU0lznaLePTVvUz3l2S22OWP4=
Date:   Thu, 22 Apr 2021 10:27:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIEzZQR0hTSxmpAz@kroah.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <CADVatmORofURmrLiV7GRW2ZchzL6zdQopwxAh2YSVT0y69KuHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmORofURmrLiV7GRW2ZchzL6zdQopwxAh2YSVT0y69KuHA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 09:10:53AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Apr 21, 2021 at 11:21 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Apr 21, 2021 at 11:07:11AM +0100, Sudip Mukherjee wrote:
> > > Hi Greg,
> > >
> > > On Wed, Apr 21, 2021 at 6:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Wed, Apr 21, 2021 at 08:10:25AM +0300, Leon Romanovsky wrote:
> > > > > On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > > > > > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > > > > > If you look at the code, this is impossible to have happen.
> > > > > > >
> > >
> > > <snip>
> > >
> > > > > They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> > > > > accepted patches from Aditya and 3 of them added various severity security
> > > > > "holes".
> > > >
> > > > All contributions by this group of people need to be reverted, if they
> > > > have not been done so already, as what they are doing is intentional
> > > > malicious behavior and is not acceptable and totally unethical.  I'll
> > > > look at it after lunch unless someone else wants to do it...
> > >
> > > A lot of these have already reached the stable trees. I can send you
> > > revert patches for stable by the end of today (if your scripts have
> > > not already done it).
> >
> > Yes, if you have a list of these that are already in the stable trees,
> > that would be great to have revert patches, it would save me the extra
> > effort these mess is causing us to have to do...
> 
> The patch series for all the stable branches should be with you now.
> 
> But for others:
> https://lore.kernel.org/stable/YIEVGXEoeizx6O1p@debian/  for v5.11.y
> and other branches are sent as a reply to that mail.

Thank you, I now have them.  I will be looking at them when I get the
chance, and comparing them to what I end up getting merged into
5.13-rc1.

greg k-h
