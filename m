Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2214188A7
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfEILHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:07:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36606 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfEILHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 07:07:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8CB7A201E4;
        Thu,  9 May 2019 13:07:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UXdNXFRImLDD; Thu,  9 May 2019 13:07:49 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 20017201C6;
        Thu,  9 May 2019 13:07:49 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 May 2019
 13:07:48 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7F5453180601;
 Thu,  9 May 2019 13:07:48 +0200 (CEST)
Date:   Thu, 9 May 2019 13:07:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/6] xfrm: reduce xfrm_state_afinfo size
Message-ID: <20190509110748.GU17989@gauss3.secunet.de>
References: <20190503154619.32352-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190503154619.32352-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: DD15CE65-5D34-498B-B39C-5DA9B239BA78
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 05:46:13PM +0200, Florian Westphal wrote:
> xfrm_state_afinfo is a very large struct; its over 4kbyte on 64bit systems.
> 
> The size comes from two arrays to store the l4 protocol type pointers
> (esp, ah, ipcomp and so on).
> 
> There are only a handful of those, so just use pointers for protocols
> that we implement instead of mostly-empty arrays.
> 
> This also removes the template init/sort related indirections.
> Structure size goes down to 120 bytes on x86_64.
> 
>  include/net/xfrm.h      |   49 ++---
>  net/ipv4/ah4.c          |    3 
>  net/ipv4/esp4.c         |    3 
>  net/ipv4/esp4_offload.c |    4 
>  net/ipv4/ipcomp.c       |    3 
>  net/ipv4/xfrm4_state.c  |   45 -----
>  net/ipv4/xfrm4_tunnel.c |    3 
>  net/ipv6/ah6.c          |    4 
>  net/ipv6/esp6.c         |    3 
>  net/ipv6/esp6_offload.c |    4 
>  net/ipv6/ipcomp6.c      |    3 
>  net/ipv6/mip6.c         |    6 
>  net/ipv6/xfrm6_state.c  |  137 ----------------
>  net/xfrm/xfrm_input.c   |   24 +-
>  net/xfrm/xfrm_policy.c  |    2 
>  net/xfrm/xfrm_state.c   |  400 +++++++++++++++++++++++++++++++++++-------------
>  16 files changed, 343 insertions(+), 350 deletions(-)
> 
> Florian Westphal (6):
>       xfrm: remove init_tempsel indirection from xfrm_state_afinfo
>       xfrm: remove init_temprop indirection from xfrm_state_afinfo
>       xfrm: remove init_flags indirection from xfrm_state_afinfo
>       xfrm: remove state and template sort indirections from xfrm_state_afinfo
>       xfrm: remove eth_proto value from xfrm_state_afinfo
>       xfrm: remove type and offload_type map from xfrm_state_afinfo

I have deferred this until after the merge window. I'll
consider applying them then.

Thanks!
