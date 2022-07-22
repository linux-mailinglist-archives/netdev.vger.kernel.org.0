Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF4C57D8EF
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 05:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiGVDRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 23:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGVDRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 23:17:30 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D551B21AF;
        Thu, 21 Jul 2022 20:17:27 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oEj9r-003DMe-S0; Fri, 22 Jul 2022 13:16:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Jul 2022 11:16:56 +0800
Date:   Fri, 22 Jul 2022 11:16:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Abhishek Shah <abhishek.shah@columbia.edu>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, linux-kernel@vger.kernel.org,
        Gabriel Ryan <gabe@cs.columbia.edu>
Subject: Re: Race 1 in net/xfrm/xfrm_algo.c
Message-ID: <YtoWqEkKzvimzWS5@gondor.apana.org.au>
References: <CAEHB24-9hXY+TgQKxJB4bE9a9dFD9C+Lan+ShBwpvwaHVAGMFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEHB24-9hXY+TgQKxJB4bE9a9dFD9C+Lan+ShBwpvwaHVAGMFg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:03:04PM -0400, Abhishek Shah wrote:
> Dear Kernel Maintainers,
> 
> We found a race in net/xfrm/xfrm_algo.c. The function *xfrm_probe_algs* updates
> the availability field of items in a authentication algorithms list (
> *aalg_list* variable), but this update can occur simultaneously with
> another invocation of *xfrm_probe_algs*, leading to double writes and
> read/write consistency issues in scenarios where the *status* variable may
> vary across the concurrent invocations of the function. This behavior also
> occurs with another list with encryption algorithms (*ealg_list* variable)
> as well as with the *xfrm_find_algo* function. We thought this is
> undesirable given cryptographic logic errors often have security
> implications.
> 
> We provide more details below including the trace and reproducing
> test cases.

What inconsistency are you talking about? An algorithm can always
disappear even if it was available earlier.  Please state clearly
why this is actually a problem rather than relying on some automated
test whose results are useless without human interpretation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
