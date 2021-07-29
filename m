Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D673D9C73
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhG2EDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:03:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51554 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhG2EDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 00:03:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m8xGD-0003hT-9R; Thu, 29 Jul 2021 12:03:05 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m8xGB-0001pU-SN; Thu, 29 Jul 2021 12:03:03 +0800
Date:   Thu, 29 Jul 2021 12:03:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     yajun.deng@linux.dev
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Revert "net: Get rid of consume_skb when tracing is off"
Message-ID: <20210729040303.GA7009@gondor.apana.org.au>
References: <20210728125248.GC2598@gondor.apana.org.au>
 <20210728035605.24510-1-yajun.deng@linux.dev>
 <177cd530dcb2c9f4d09a2b23fdbbc71a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177cd530dcb2c9f4d09a2b23fdbbc71a@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 04:01:28AM +0000, yajun.deng@linux.dev wrote:
>
> if we don't define CONFIG_TRACEPOINTS, consume_skb() wolud called kfree_skb(), there have
> trace_kfree_skb() in kfree_skb(), the trace_kfree_skb() is also a trace function. So we
> can trace consume_skb() even if we don't define CONFIG_TRACEPOINTS.
> This patch "net: Get rid of consume_skb when tracing is off" does not seem to be effective.

The point of my patch was to get rid of consume_skb because its
only purpose is to provide extra information for tracing.  If you're
not tracing then you don't need that extra information (and overhead).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
