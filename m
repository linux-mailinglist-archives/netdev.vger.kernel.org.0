Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4732A533430
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 02:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbiEYAQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 20:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiEYAQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 20:16:11 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08E9A1AB;
        Tue, 24 May 2022 17:16:09 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ntegs-00HGsA-Fp; Wed, 25 May 2022 10:15:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 May 2022 08:15:54 +0800
Date:   Wed, 25 May 2022 08:15:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] xfrm: convert alg_key to flexible array member
Message-ID: <Yo11OitanGR5F6ke@gondor.apana.org.au>
References: <20220524204741.980721-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220524204741.980721-1-stephen@networkplumber.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 01:47:40PM -0700, Stephen Hemminger wrote:
> Iproute2 build generates a warning when built with gcc-12.
> This is because the alg_key in xfrm.h API has zero size
> array element instead of flexible array.
> 
>     CC       xfrm_state.o
> In function ‘xfrm_algo_parse’,
>     inlined from ‘xfrm_state_modify.constprop’ at xfrm_state.c:573:5:
> xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
>   162 |                         buf[j] = val;
>       |                         ~~~~~~~^~~~~
> 
> This patch convert the alg_key into flexible array member.
> There are other zero size arrays here that should be converted as
> well.
> 
> This patch is RFC only since it is only compile tested and
> passes trivial iproute2 tests.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  include/uapi/linux/xfrm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
