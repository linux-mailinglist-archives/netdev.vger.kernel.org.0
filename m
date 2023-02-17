Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFB969A6E7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBQI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBQI3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:29:25 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917701C596
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 00:29:22 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSw7C-00CLVl-Rk; Fri, 17 Feb 2023 16:29:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Feb 2023 16:29:10 +0800
Date:   Fri, 17 Feb 2023 16:29:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sri Sakthi <srisakthi.s@gmail.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org, srisakthi.subramaniam@sophos.com,
        david.george@sophos.com, Vimal.Agrawal@sophos.com
Subject: Re: xfrm: Pass on correct AF value to xfrm_state_find
Message-ID: <Y+861os+ZbBWVvvi@gondor.apana.org.au>
References: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
 <Y+8Pg5JzOBntLcWA@gondor.apana.org.au>
 <CA+t5pP=NRQUax5ogB32dZN74Mk2qq_ZY7OgNro8JmckVkQsQyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+t5pP=NRQUax5ogB32dZN74Mk2qq_ZY7OgNro8JmckVkQsQyw@mail.gmail.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:53:55PM +0530, Sri Sakthi wrote:
>
> configuration error and you can see similar configuration by strongswan in
> https://www.strongswan.org/testing/testresults/ikev2/compress/

Just because strongswan is doing it doesn't mean that it isn't
buggy.

Either have no policy selector on the ESP SA, or have one that
actually matches the inner flow.

The configuration you presented was only working by accident
previously as it used the wrong family to interpret the inner
flow addresses.  In your case, it would have interpreted the
inner addresses src 10.171.96.0/20 dst 10.171.80.0/20 as IPv6
addresses.

This is what triggered the original out-of-bound report and
my patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
