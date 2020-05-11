Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABDC1CE0E5
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgEKQsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbgEKQsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 12:48:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F07320722;
        Mon, 11 May 2020 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589215702;
        bh=YjBc3GcTYhjNZB9dWGMJ7JWRWBG0gsn+sx7uezZ15Jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEtOD+Gcwt/5t8fzFDccXhPnuw1ERXnwA50+CixMFE88goAJEX3QUqybY/CwE6TUk
         oOG/zNO2XbaryuwbQjF4uH/AyYpn7VP1nso+xEcP3iIDs8zhPNU2PpSwtunzAVTR+6
         NkVstniSfELe0NDHh8tVvOFlj1Ck4sNeMEhUGn1c=
Date:   Mon, 11 May 2020 09:48:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] checkpatch: warn about uses of ENOTSUPP
Message-ID: <20200511094819.08f22e84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <19cc4fe7238358988950970a6f8af68a31b2e4bd.camel@perches.com>
References: <20200510185148.2230767-1-kuba@kernel.org>
        <19cc4fe7238358988950970a6f8af68a31b2e4bd.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 12:56:53 -0700 Joe Perches wrote:
> On Sun, 2020-05-10 at 11:51 -0700, Jakub Kicinski wrote:
> > Hi Joe, I feel like I already talked to you about this, but I lost
> > my email archive, so appologies if you already said no.  
> 
> Not so far as I can tell.
> 
> This seems OK to me, but using checkpatch -f should probably
> not show this error.
> 
> You might include a link to where Andrew Lunn suggested it
> in the commit message.  I didn't find it with a trivial search.

Will do.

> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl  
> []
> > @@ -4199,6 +4199,14 @@ sub process {
> >  			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
> >  		}
> >  
> > +# ENOTSUPP is not a standard error code and should be avoided.
> > +# Folks usually mean EOPNOTSUPP (also called ENOTSUP), when they type ENOTSUPP.
> > +# Similarly to ENOSYS warning a small number of false positives is expected.
> > +		if ($line =~ /\bENOTSUPP\b/) {  
> 
> So to avoid having newbies and others trying to convert
> existing uses in files using checkpatch.pl -f, maybe:

Sounds good, thanks!
