Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DC66EDDF6
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbjDYI2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbjDYI2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:28:16 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E0C4C2B
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:28:13 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1prE1p-0022eX-VP; Tue, 25 Apr 2023 16:28:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Apr 2023 16:28:03 +0800
Date:   Tue, 25 Apr 2023 16:28:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: Ensure consistent address families when
 resolving templates
Message-ID: <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:00:32AM +0200, Tobias Brunner wrote:
> 
> At least in theory, there could be applications for optional outbound
> templates, e.g. an optional ESP transform that's only applied to some of the
> traffic matching the policy (based on the selector on the state, which is
> matched against the original flow) followed by a mandatory AH transform
> (there could even be multiple optional transforms, e.g. using different
> algorithms, that are selectively applied to traffic).  No idea if anybody
> actually uses this, but the API allows configuring it.  And syzbot showed
> that some combinations are problematic.

OK, if nobody actually is using this we should restrict its usage.

How about limiting optional transforms on outbound policies to
transport mode only?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
