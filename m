Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5484467F3CB
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjA1Blv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjA1Blu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:41:50 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4179E410A3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:41:49 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pLaDk-004ygf-9V; Sat, 28 Jan 2023 09:41:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Jan 2023 09:41:32 +0800
Date:   Sat, 28 Jan 2023 09:41:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Hopps <chopps@labn.net>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@chopps.org
Subject: Re: [PATCH] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Message-ID: <Y9R9TBekaAzQZu6S@gondor.apana.org.au>
References: <20230126102933.1245451-1-chopps@labn.net>
 <Y9Oi+np1iaRJhEY/@gondor.apana.org.au>
 <m2h6wc16tu.fsf@ja.int.chopps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2h6wc16tu.fsf@ja.int.chopps.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 07:31:54AM -0500, Christian Hopps wrote:
>
> Yes that's what the immediate git blame points at; however, that code was copied from net/ipv6/xfrm6_mode_tunnel.c:xfrm6_tunnel_input() and that code arrived in:
> 
>    b59f45d0b2878 ("[IPSEC] xfrm: Abstract out encapsulation modes")
> 
> Originally this code using a different sk_buff layout was from the initial git repo checkin.
> 
>    1da177e4c3f41 ("Linux-2.6.12-rc2")
> 
> Why don't I just remove the fixes line? I didn't want to include it initially anyway.

On closer inspection my patch was definitely buggy in that it would
place some random value in the DSCP field.  Previously the code
simply didn't copy the TOS value across.

Steffen, keeping the Fixes header is fine by me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
