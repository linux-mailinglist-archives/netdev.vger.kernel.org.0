Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9E67E114
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjA0KKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjA0KKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:10:31 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529F54B1A0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:10:29 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pLLgI-004fpi-F9; Fri, 27 Jan 2023 18:10:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Jan 2023 18:10:02 +0800
Date:   Fri, 27 Jan 2023 18:10:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Hopps <chopps@labn.net>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@chopps.org
Subject: Re: [PATCH] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Message-ID: <Y9Oi+np1iaRJhEY/@gondor.apana.org.au>
References: <20230126102933.1245451-1-chopps@labn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126102933.1245451-1-chopps@labn.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 05:29:34AM -0500, Christian Hopps wrote:
> When copying the DSCP bits for decap-dscp into IPv6 don't assume the
> outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
> the DSCP bits from the correctly saved "tos" value in the control block.
> 
> fixes: 227620e29509 ("[IPSEC]: Separate inner/outer mode processing on input")

The broken code apparently came from

commit b3284df1c86f7ac078dcb8fb250fe3d6437e740c
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Mar 29 21:16:28 2019 +0100

    xfrm: remove input2 indirection from xfrm_mode

Please fix the Fixes header.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
