Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A514581CBE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 02:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbiG0ASY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 20:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiG0ASW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 20:18:22 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B4632D9D;
        Tue, 26 Jul 2022 17:18:18 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oGUkR-004pdo-2Y; Wed, 27 Jul 2022 10:18:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Jul 2022 08:17:59 +0800
Date:   Wed, 27 Jul 2022 08:17:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
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
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] net/crypto: Introduce crypto_pool
Message-ID: <YuCEN7LKcVLL0zBn@gondor.apana.org.au>
References: <20220726201600.1715505-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726201600.1715505-1-dima@arista.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 09:15:54PM +0100, Dmitry Safonov wrote:
> Add crypto_pool - an API for allocating per-CPU array of crypto requests
> on slow-path (in sleep'able context) and to use them on a fast-path,
> which is RX/TX for net/ users (or in any other bh-disabled users).
> The design is based on the current implementations of md5sig_pool.
> 
> Previously, I've suggested to add such API on TCP-AO patch submission [1], 
> where Herbert kindly suggested to help with introducing new crypto API.

What I was suggesting is modifying the actual ahash interface so
that the tfm can be shared between different key users by moving
the key into the request object.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
