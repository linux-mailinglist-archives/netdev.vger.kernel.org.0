Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777475FD5E2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiJMIFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJMIFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:05:47 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D423104D1D;
        Thu, 13 Oct 2022 01:05:46 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oitCx-00EEsi-LD; Thu, 13 Oct 2022 19:04:48 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Oct 2022 16:04:47 +0800
Date:   Thu, 13 Oct 2022 16:04:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Christian Langrock <christian.langrock@secunet.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH ipsec v6] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <Y0fGn4XRSSQons1K@gondor.apana.org.au>
References: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
 <Y0aI2bGb24M5vA7B@gondor.apana.org.au>
 <20221013061633.GS2950045@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013061633.GS2950045@gauss3.secunet.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 08:16:33AM +0200, Steffen Klassert wrote:
>
> That is because with this patch, the sequence number from the xfrm_state
> is assigned to the skb and advanced by the number of segments while
> holding the state lock, as it was before. The sequence numbers this
> patch operates on are exclusive and private to that skb (and its
> segments). The next skb will checkout the correct number from the
> xfrm_state regardless on which cpu it comes.

Thanks for the explanation Steffen.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
