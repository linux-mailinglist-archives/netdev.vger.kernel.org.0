Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975AC3C7C1
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 11:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404403AbfFKJ4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 05:56:55 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48594 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391392AbfFKJ4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 05:56:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0CF95200B0;
        Tue, 11 Jun 2019 11:56:54 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cbal-H2_vzyd; Tue, 11 Jun 2019 11:56:53 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 97E9F201AE;
        Tue, 11 Jun 2019 11:56:53 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Jun 2019
 11:56:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2B94D31804B1;
 Tue, 11 Jun 2019 11:56:53 +0200 (CEST)
Date:   Tue, 11 Jun 2019 11:56:53 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/6] xfrm: reduce xfrm_state_afinfo size
Message-ID: <20190611095653.GG17989@gauss3.secunet.de>
References: <20190503154619.32352-1-fw@strlen.de>
 <20190509110748.GU17989@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190509110748.GU17989@gauss3.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 01:07:48PM +0200, Steffen Klassert wrote:
> On Fri, May 03, 2019 at 05:46:13PM +0200, Florian Westphal wrote:
> > xfrm_state_afinfo is a very large struct; its over 4kbyte on 64bit systems.
> > 
> > The size comes from two arrays to store the l4 protocol type pointers
> > (esp, ah, ipcomp and so on).
> > 
> > There are only a handful of those, so just use pointers for protocols
> > that we implement instead of mostly-empty arrays.
> > 
> > This also removes the template init/sort related indirections.
> > Structure size goes down to 120 bytes on x86_64.
> > 
> >  include/net/xfrm.h      |   49 ++---
> >  net/ipv4/ah4.c          |    3 
> >  net/ipv4/esp4.c         |    3 
> >  net/ipv4/esp4_offload.c |    4 
> >  net/ipv4/ipcomp.c       |    3 
> >  net/ipv4/xfrm4_state.c  |   45 -----
> >  net/ipv4/xfrm4_tunnel.c |    3 
> >  net/ipv6/ah6.c          |    4 
> >  net/ipv6/esp6.c         |    3 
> >  net/ipv6/esp6_offload.c |    4 
> >  net/ipv6/ipcomp6.c      |    3 
> >  net/ipv6/mip6.c         |    6 
> >  net/ipv6/xfrm6_state.c  |  137 ----------------
> >  net/xfrm/xfrm_input.c   |   24 +-
> >  net/xfrm/xfrm_policy.c  |    2 
> >  net/xfrm/xfrm_state.c   |  400 +++++++++++++++++++++++++++++++++++-------------
> >  16 files changed, 343 insertions(+), 350 deletions(-)
> > 
> > Florian Westphal (6):
> >       xfrm: remove init_tempsel indirection from xfrm_state_afinfo
> >       xfrm: remove init_temprop indirection from xfrm_state_afinfo
> >       xfrm: remove init_flags indirection from xfrm_state_afinfo
> >       xfrm: remove state and template sort indirections from xfrm_state_afinfo
> >       xfrm: remove eth_proto value from xfrm_state_afinfo
> >       xfrm: remove type and offload_type map from xfrm_state_afinfo
> 
> I have deferred this until after the merge window. I'll
> consider applying them then.

This is now applied to ipsec-next, thanks Florian!
