Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96132DEADA
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgLRVRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:17:32 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:11590 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgLRVRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:17:32 -0500
Received: (qmail 93109 invoked by uid 89); 18 Dec 2020 21:16:50 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 18 Dec 2020 21:16:50 -0000
Date:   Fri, 18 Dec 2020 13:16:48 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 0/9 v1 RFC] Generic zcopy_* functions
Message-ID: <20201218211648.rh5ktnkm333sw4hf@bsd-mbp.dhcp.thefacebook.com>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 03:49:44PM -0500, Willem de Bruijn wrote:
> On Fri, Dec 18, 2020 at 3:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > This is set of cleanup patches for zerocopy which are intended
> > to allow a introduction of a different zerocopy implementation.
> 
> Can you describe in more detail what exactly is lacking in the current
> zerocopy interface for this this different implementation? Or point to
> a github tree with the feature patches attached, perhaps.

I'll get the zctap features up into a github tree.

Essentially, I need different behavior from ubuf_info:
  - no refcounts on RX packets (static ubuf)
  - access to the skb on RX skb free (for page handling)
  - no page pinning on TX/tx completion
  - marking the skb data as inaccessible so skb_condense()
    and skb_zeroocopy_clone() leave it alone.

> I think it's good to split into multiple smaller patchsets, starting
> with core stack support. But find it hard to understand which of these
> changes are truly needed to support a new use case.

Agree - kind of hard to see why this is done without a use case.
These patches are purely restructuring, and don't introduce any
new features.


> If anything, eating up the last 8 bits in skb_shared_info should be last resort.

I would like to add 2 more bits in the future, which is why I
moved them.  Is there a compelling reason to leave the bits alone?
--
Jonathan

