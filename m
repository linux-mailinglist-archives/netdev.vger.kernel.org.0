Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03DD6A406A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 12:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjB0LPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 06:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0LPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 06:15:53 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8721A97B
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 03:15:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 02FAE201CF;
        Mon, 27 Feb 2023 12:15:50 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K5ayoYr1z8la; Mon, 27 Feb 2023 12:15:49 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7AC7A200A7;
        Mon, 27 Feb 2023 12:15:49 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 6BD7580004A;
        Mon, 27 Feb 2023 12:15:49 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 27 Feb 2023 12:15:49 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Mon, 27 Feb
 2023 12:15:49 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A15913182E03; Mon, 27 Feb 2023 12:15:48 +0100 (CET)
Date:   Mon, 27 Feb 2023 12:15:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     David George <David.George@sophos.com>,
        Sri Sakthi <srisakthi.s@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Srisakthi Subramaniam <Srisakthi.Subramaniam@sophos.com>,
        Vimal Agrawal <Vimal.Agrawal@sophos.com>
Subject: Re: [PATCH] xfrm: Allow transport-mode states with AF_UNSPEC selector
Message-ID: <Y/yQ5O7wXgOSzt3Z@gauss3.secunet.de>
References: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
 <Y+8Pg5JzOBntLcWA@gondor.apana.org.au>
 <CA+t5pP=NRQUax5ogB32dZN74Mk2qq_ZY7OgNro8JmckVkQsQyw@mail.gmail.com>
 <Y+861os+ZbBWVvvi@gondor.apana.org.au>
 <LO0P265MB604061D3617058B2B07D534CE0A49@LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM>
 <Y/RDBnFoROo5+xcm@gondor.apana.org.au>
 <Y/RceGnV2JLvRmXC@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y/RceGnV2JLvRmXC@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 01:54:00PM +0800, Herbert Xu wrote:
> On Tue, Feb 21, 2023 at 12:05:26PM +0800, Herbert Xu wrote:
> > 
> > OK I wasn't aware of this.  This definitely looks buggy.  We need
> > to fix this bogus check.
> 
> It looks like I actually added this bogus check :)
> 
> Does this patch work for you?
> 
> ---8<---
> xfrm state selectors are matched against the inner-most flow
> which can be of any address family.  Therefore middle states
> in nested configurations need to carry a wildcard selector in
> order to work at all.
> 
> However, this is currently forbidden for transport-mode states.
> 
> Fix this by removing the unnecessary check.
> 
> Fixes: 13996378e658 ("[IPSEC]: Rename mode to outer_mode and add inner_mode")
> Reported-by: David George <David.George@sophos.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Patch applied, thanks a lot Herbert!
