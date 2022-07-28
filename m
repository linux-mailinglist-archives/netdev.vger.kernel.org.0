Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92862583B34
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiG1J0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbiG1J0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:26:36 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2682F65825;
        Thu, 28 Jul 2022 02:26:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oGzmX-005Ou3-Pj; Thu, 28 Jul 2022 19:26:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 Jul 2022 17:26:14 +0800
Date:   Thu, 28 Jul 2022 17:26:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] net/crypto: Introduce crypto_pool
Message-ID: <YuJWNgIupkBPvsCD@gondor.apana.org.au>
References: <20220726201600.1715505-1-dima@arista.com>
 <YuCEN7LKcVLL0zBn@gondor.apana.org.au>
 <5b88eea6-1d84-8c16-36f4-358053e247f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b88eea6-1d84-8c16-36f4-358053e247f2@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 06:52:27PM +0300, Leonard Crestez wrote:
>
> The fact that setkey is implemented at the crypto_ahash instead of the
> ahash_request level is baked into all algorithm implementations (including
> many hardware-specific ones). Changing this seems extremely difficult.

What I had in mind is simply making the tfm setkey optional.  That
way you could then have an additional setkey at the request level.

If the key is provided in either place you're allowed to perform
the hash.

This should have minimal impact on existing code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
