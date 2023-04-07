Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325F76DA6D0
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjDGBOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjDGBOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:14:47 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26A283C0
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:14:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pkagU-00DO6L-Ks; Fri, 07 Apr 2023 09:14:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Apr 2023 09:14:34 +0800
Date:   Fri, 7 Apr 2023 09:14:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <ZC9ueqlByZyf0HUO@gondor.apana.org.au>
References: <20230403085601.44f04cd2@kernel.org>
 <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
 <20230403120345.0c02232c@kernel.org>
 <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
 <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
 <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
 <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
 <20230406074648.4c26a795@kernel.org>
 <ZC9qns9e33LUuO8q@gondor.apana.org.au>
 <20230406180337.599b6362@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406180337.599b6362@kernel.org>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 06:03:37PM -0700, Jakub Kicinski wrote:
>
> I couldn't find a check in netpoll/netconsole which would defer
> when in hardirq. Does it defer?

Right, netconsole is the one exception that can occur in any
context.  However, as I said in the previous email I don't see
how this can break the wake logic and leave the queue stopped
forever.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
