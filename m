Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DCD6EDDEC
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjDYI0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjDYI0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:26:53 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7324C1E
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:26:48 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1prE0P-0022c3-UE; Tue, 25 Apr 2023 16:26:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Apr 2023 16:26:35 +0800
Date:   Tue, 25 Apr 2023 16:26:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Tobias Brunner <tobias@strongswan.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: Ensure consistent address families when
 resolving templates
Message-ID: <ZEeOu6OTobTdTLac@gondor.apana.org.au>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <ZEd3c8j+ceBvObeM@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEd3c8j+ceBvObeM@gauss3.secunet.de>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 08:47:15AM +0200, Steffen Klassert wrote:
>
> The problem is, that you can configure it for outbound too.
> Even though, it does not make much sense. syzbot reported
> a stack-out-of-bounds issue with intermediate optional
> templates that change the address family:

Does anyone actually use this in the real world?

If not we should try to restrict its usage rather than supporting
pointless features.

I think it should be safe to limit the use of optional transforms
on outbound policies to transport mode only.   You can then easily
verify the sanity of the policy in xfrm_user.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
