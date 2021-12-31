Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3224A4823BA
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 12:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhLaLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 06:35:02 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58792 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhLaLfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Dec 2021 06:35:00 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n3GBV-0004tz-E7; Fri, 31 Dec 2021 22:34:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Dec 2021 22:34:57 +1100
Date:   Fri, 31 Dec 2021 22:34:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org, x86@kernel.org,
        ardb@kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto] x86/aesni: don't require alignment of data
Message-ID: <Yc7q4T839yqpCpfE@gondor.apana.org.au>
References: <20211221150611.3692437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221150611.3692437-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 07:06:11AM -0800, Jakub Kicinski wrote:
> x86 AES-NI routines can deal with unaligned data. Crypto context
> (key, iv etc.) have to be aligned but we take care of that separately
> by copying it onto the stack. We were feeding unaligned data into
> crypto routines up until commit 83c83e658863 ("crypto: aesni -
> refactor scatterlist processing") switched to use the full
> skcipher API which uses cra_alignmask to decide data alignment.
> 
> This fixes 21% performance regression in kTLS.
> 
> Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> (and running thru various kTLS packets).
> 
> CC: stable@vger.kernel.org # 5.15+
> Fixes: 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: herbert@gondor.apana.org.au
> CC: x86@kernel.org
> CC: ardb@kernel.org
> CC: linux-crypto@vger.kernel.org
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
