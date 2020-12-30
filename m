Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE562E78A5
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 13:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgL3MrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 07:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgL3MrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 07:47:11 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4035C061799
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 04:46:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kuarr-0005T2-FG; Wed, 30 Dec 2020 13:46:19 +0100
Date:   Wed, 30 Dec 2020 13:46:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Visa Hankala <visa@hankala.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20201230124619.GB30823@breakpoint.cc>
References: <20201229145009.cGOUak0JdKIIgGAv@hankala.org>
 <20201229160127.GA30823@breakpoint.cc>
 <20201230115517.iZlNGikD3bKtySfO@hankala.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230115517.iZlNGikD3bKtySfO@hankala.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Visa Hankala <visa@hankala.org> wrote:
> On Tue, Dec 29, 2020 at 05:01:27PM +0100, Florian Westphal wrote:
> > This is suspicious.  Is prefixlen == 0 impossible?
> > 
> > If not, then after patch
> > mask = ~0U << 32;
> > 
> > ... and function returns 0.
> 
> With prefixlen == 0, there is only one equivalence class, so
> returning 0 seems reasonable to me.

Right, that seems reasonable indeed.

> Is there a reason why the function has treated /0 prefix as /32
> with IPv4? IPv6 does not have this treatment.

Not that I recall, looks like a bug.
