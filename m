Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1DC312DFB
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhBHJwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231891AbhBHJtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 04:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B44964E8F;
        Mon,  8 Feb 2021 09:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612777723;
        bh=PqjmFA18oNIVTBrl89NjKcEdBGtrMd1vwbKocOeM78c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGo7Ue3wRD/4ZRaOJnnaunO2vEAOK1uTPQXdIJcc3H57MUtTjLAKzKksEEQLlBKZc
         6ly33vXWzMyw0dU/QnMP09myxLW/SalgrCzg8TNVhdy8mnl+GW2EgvfSN+n+IfHVD4
         DjuEDPAc+xaR6UuSpI2Djnq2n7H9Tg9vo3J4aAXs=
Date:   Mon, 8 Feb 2021 10:48:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "weiwan@google.com" <weiwan@google.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "jesse@mbuki-mvuki.org" <jesse@mbuki-mvuki.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Where is this patch buried?
Message-ID: <YCEI+GYwWLhKQURS@kroah.com>
References: <7953a4158fd14aabbcfbad8365231961@SVR-IES-MBX-03.mgc.mentorg.com>
 <YCD6/OByXFRyuR71@kroah.com>
 <1612776251858.30522@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612776251858.30522@mentor.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 09:24:11AM +0000, Schmid, Carsten wrote:
> >> Hi Greg,
> >>
> >> in kernel 4.14 i have seen a NULL pointer deref in
> >> [65064.613465] RIP: 0010:ip_route_output_key_hash_rcu+0x755/0x850
> >> (i have a core dump and detailed analysis)
> >>
> >> That looks like this patch could have prevented it:
> >>
> >> https://www.spinics.net/lists/stable-commits/msg133055.html
> >>
> >> this one was queued for 4.14, but i can't find it in git tree?
> >> Any idea who/what buried this one?
> >>
> >> In 4.19 it is present.
> >>
> >> Because our customer uses 4.14 (going to 4.14.212 in a few days) i kindly want to
> >> ask why this patch hasn't entered 4.14.
> >
> > Because it breaks the build?  Try it yourself and see what happens :)
> 
> yep. rt_add_uncached_list is implemented _after_ the call :-(
> 
> >
> > I will gladly take a working backport if you can submit it.
> >
> Please find it attached - i needed to move rt_add_uncached_list before
> the rt_cache_route, nothing else changed.
> This is for 4.14 only, as other kernels do have this patch.
> 
> I can't reproduce the crash at will, but at least i could compile and flash it on my target.
> And the target comes up .. hopefully the testing in other/newer kernels
> done by the developers of the patch is also valid for 4.14.

Thanks, now queued up.

greg k-h
