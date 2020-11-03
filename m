Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D0A2A44C2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgKCMFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:05:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49488 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgKCMFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 07:05:22 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kZv3r-0002sm-Mt; Tue, 03 Nov 2020 23:05:16 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Nov 2020 23:05:15 +1100
Date:   Tue, 3 Nov 2020 23:05:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH ipsec] xfrm: Pass template address family to
 xfrm_state_look_at
Message-ID: <20201103120515.GA10759@gondor.apana.org.au>
References: <20201103023217.27685-1-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103023217.27685-1-ajderossi@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 06:32:19PM -0800, Anthony DeRossi wrote:
> This fixes a regression where valid selectors are incorrectly skipped
> when xfrm_state_find is called with a non-matching address family (e.g.
> when using IPv6-in-IPv4 ESP in transport mode).
> 
> The state's address family is matched against the template's family
> (encap_family) in xfrm_state_find before checking the selector in
> xfrm_state_look_at.  The template's family should also be used for
> selector matching, otherwise valid selectors may be skipped.
> 
> Fixes: e94ee171349d ("xfrm: Use correct address family in xfrm_state_find")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  net/xfrm/xfrm_state.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Your patch reintroduces the same bug that my patch was trying to
fix, namely that when you do the comparison on flow you must use
the original family and not some other value.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
