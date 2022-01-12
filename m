Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268AD48CB17
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356317AbiALSgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:36:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37246 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356351AbiALSfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:35:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 303C9CE1DF2;
        Wed, 12 Jan 2022 18:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44133C36AE5;
        Wed, 12 Jan 2022 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642012540;
        bh=zP4n5siVZnpIyHLJdzM1lw+loF13BYSmPiQZisa6tuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AHNf8poxGDbn8OXvXbyU/lgYy4gLXmPWkzVfGXNfqOB2rXeXy/W1Var/4aL2lIAvB
         OhuzmRV/vQbjXdyFojxfOEPhVrR9nkVSbjivDRo+1CtuXg/pmXXu84/qkp1bL/K8nR
         0KRfwxpeQLAAqjIL5feVPmbMOQ5F6ThYGoVMz9+L2n1+nOy4eIxtdgwxD9ii5ucviE
         GJFvN2dVy5lhY8b7rcUtXYfjQW+x51XYSVsJ/LOzt/VsioJZLT4nARhyAhMADVRtKW
         sbGW18ON579dWzPLEKzGOOONxjB0AxJkMXYZKNrn1qsNZHeuPvWeuMU1TdFM4g0/uy
         Ic9DHW18rj0xA==
Date:   Wed, 12 Jan 2022 10:35:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, geert@linux-m68k.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto 2/2] lib/crypto: blake2s: move hmac construction
 into wireguard
Message-ID: <Yd8fevK3n5aACJMF@gmail.com>
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com>
 <20220111134934.324663-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111134934.324663-3-Jason@zx2c4.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 02:49:34PM +0100, Jason A. Donenfeld wrote:
> Basically nobody should use blake2s in an HMAC construction; it already
> has a keyed variant. But for unfortunately historical reasons, Noise,
> used by WireGuard, uses HKDF quite strictly, which means we have to use
> this. Because this really shouldn't be used by others, this commit moves
> it into wireguard's noise.c locally, so that kernels that aren't using
> WireGuard don't get this superfluous code baked in. On m68k systems,
> this shaves off ~314 bytes.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: wireguard@lists.zx2c4.com
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
