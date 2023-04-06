Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972426D905F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbjDFHWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjDFHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:22:35 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00B96E9D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:22:31 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pkJwp-00D0QK-CC; Thu, 06 Apr 2023 15:22:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Apr 2023 15:22:19 +0800
Date:   Thu, 6 Apr 2023 15:22:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com, hkallweit1@gmail.com,
        andrew@lunn.ch, willemb@google.com
Subject: Re: [PATCH net-next v3 4/7] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <ZC5zK2lLSF31VUm9@gondor.apana.org.au>
References: <20230405223134.94665-1-kuba@kernel.org>
 <20230405223134.94665-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405223134.94665-5-kuba@kernel.org>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 03:31:31PM -0700, Jakub Kicinski wrote:
>
> +/**
> + * __netif_txq_maybe_wake() - locklessly wake a Tx queue, if needed
> + * @txq:	struct netdev_queue to stop/start
> + * @get_desc:	get current number of free descriptors (see requirements below!)
> + * @start_thrs:	minimal number of descriptors to re-enable the queue
> + * @down_cond:	down condition, predicate indicating that the queue should
> + *		not be woken up even if descriptors are available
> + *
> + * All arguments may be evaluated multiple times.
> + * @get_desc must be a formula or a function call, it must always
> + * return up-to-date information when evaluated!
> + *
> + * Returns:
> + *	 0 if the queue was woken up
> + *	 1 if the queue was already enabled (or disabled but @down_cond is true)
> + *	-1 if the queue was left stopped

Perhaps we should say left unchanged instead of left stopped.
Just in case someone tries to be pedantic ten years later and
then claims the code to be buggy :)

Otherwise

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
