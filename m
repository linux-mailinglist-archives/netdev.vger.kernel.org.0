Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5BA366D56
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243069AbhDUN5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242991AbhDUN5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 09:57:11 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA832C06138A;
        Wed, 21 Apr 2021 06:56:37 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 4157A727A; Wed, 21 Apr 2021 09:56:37 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 4157A727A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1619013397;
        bh=pFaksgY5nGLdb69g+ixg9Bb3UoF3khtrHn1VSbgP31I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bN7X3LZtf5iiYZn/6WMbdzo8NWHQU7ppTf114jUaabwFtVtE4XWfkbiE3cKdnJQuI
         FsF0oK32SDnsekt4EAdRooSwp/24XIizy8xX04QvYwsxBbDe9CibFFDuPSGi1MVjnu
         SZxHazMNIyVXZ1Hhi5bDV1W0n/IADBQkwncN8dZ4=
Date:   Wed, 21 Apr 2021 09:56:37 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Shelat, Abhi" <a.shelat@northeastern.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <20210421135637.GB27929@fieldses.org>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIAta3cRl8mk/RkH@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 04:49:31PM +0300, Leon Romanovsky wrote:
> On Wed, Apr 21, 2021 at 09:37:27AM -0400, J. Bruce Fields wrote:
> > On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> > > Academic research should NOT waste the time of a community.
> > > 
> > > If you believe this behavior deserves an escalation, you can contact
> > > the Institutional Review Board (irb@umn.edu) at UMN to investigate
> > > whether this behavior was harmful; in particular, whether the research
> > > activity had an appropriate IRB review, and what safeguards prevent
> > > repeats in other communities.
> > 
> > For what it's worth, they do address security, IRB, and maintainer-time
> > questions in "Ethical Considerations", starting on p. 8:
> > 
> > 	https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf
> > 
> > (Summary: in that experiment, they claim actual fixes were sent before
> > the original (incorrect) patches had a chance to be committed; that
> > their IRB reviewed the plan and determined it was not human research;
> > and that patches were all small and (after correction) fixed real (if
> > minor) bugs.)
> > 
> > This effort doesn't appear to be following similar protocols, if Leon
> > Romanvosky and Aditya Pakki are correct that security holes have already
> > reached stable.
> 
> Aditya Pakki is the one who is sending those patches.

Argh, sorry, I I meant Sudip Mukherjee, who reported their reaching
stable.  Apologies.

> If you want to see another accepted patch that is already part of
> stable@, you are invited to take a look on this patch that has "built-in bug":
> 8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")

Interesting, thanks.

--b.
