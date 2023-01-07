Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2A660BBE
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbjAGCGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbjAGCGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:06:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B5687F2C;
        Fri,  6 Jan 2023 18:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3610B81EE6;
        Sat,  7 Jan 2023 02:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD3C433D2;
        Sat,  7 Jan 2023 02:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673057177;
        bh=TjnR4/cNwXYZcaHqUWqPKsdE8NWp+ngNLYzqeN7WR2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UzRilV2g2QXwDJ0pSBDmIV06RzW7VAcxSXdN0j0pt8M2/fKc+9Dsbn36uBRfGz/a7
         4dnpNM1YXth199JN5bZ0AqMFCIxEeiNYNLi/21t8Xt34IAwQr2PXGUJ7uPnPDfa29y
         Wv8kRESxkuY/qeHy+13oNtgmEatB9kWlCTtRZuBMrgyDE7dN7QRwbDhwT2mLTp6r0O
         PnONf9GVKZCA//eggdSoXjdXvOixjUUGYnj3DPTX8HkhO+WWmTdzHuuwG+uGSRs0N/
         Z+/9LvPPAgmfxWjQyAPS+kouV1gjOQox5+Nmt7W44/X7lb2DuehGq5TUqZSp+QdF8F
         l4wK59vbia82A==
Date:   Fri, 6 Jan 2023 18:06:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 5/5] crypto/Documentation: Add crypto_pool kernel API
Message-ID: <20230106180616.4a39dd2a@kernel.org>
In-Reply-To: <20230103184257.118069-6-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
        <20230103184257.118069-6-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some extra nits here since you need to respin for the build warning
(include the document in some index / toc tree and adjust the length 
of the underscores to match the line length).

On Tue,  3 Jan 2023 18:42:57 +0000 Dmitry Safonov wrote:
> diff --git a/Documentation/crypto/crypto_pool.rst b/Documentation/crypto/crypto_pool.rst
> new file mode 100644
> index 000000000000..4b8443171421
> --- /dev/null
> +++ b/Documentation/crypto/crypto_pool.rst
> @@ -0,0 +1,33 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Per-CPU pool of crypto requests
> +=============
> +
> +Overview
> +--------
> +The crypto pool API manages pre-allocated per-CPU pool of crypto requests,
> +providing ability to use async crypto requests on fast paths, potentially

.. you *don't* enable async crypto in this series, right?

> +on atomic contexts. The allocation and initialization of the requests should

s/on/in/ atomic contexts

> +be done before their usage as it's slow-path and may sleep.
> +
> +Order of operations
> +-------------------
> +You are required to allocate a new pool prior using it and manage its lifetime.

The use of second person is quite uncommon for documentation, but if
you prefer so be it..

> +You can allocate a per-CPU pool of ahash requests by ``crypto_pool_alloc_ahash()``.

You don't need to use the backticks around function names and struct
names. Our doc rendering system recognizes them automatically. 

`make htmldocs` to see for yourself.
