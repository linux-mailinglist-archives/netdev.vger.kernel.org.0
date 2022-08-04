Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417115899F2
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiHDJbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiHDJbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:31:19 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A453DF39
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:31:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 414EE20536;
        Thu,  4 Aug 2022 11:31:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V1WxMjG9UXad; Thu,  4 Aug 2022 11:31:15 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B8FDF204E5;
        Thu,  4 Aug 2022 11:31:15 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id AC54680004E;
        Thu,  4 Aug 2022 11:31:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 11:31:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 4 Aug
 2022 11:31:15 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E0F1C3182BEF; Thu,  4 Aug 2022 11:31:14 +0200 (CEST)
Date:   Thu, 4 Aug 2022 11:31:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        <0002-xfrm-fix-XFRMA_LASTUSED-comment.patch@moon.secunet.de>,
        <0003-xfrm-clone-missing-x-lastused-in-xfrm_do_migrate.patch@moon.secunet.de>,
        <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH ipsec 1/3] Revert "xfrm: update SA curlft.use_time"
Message-ID: <20220804093114.GS2950045@gauss3.secunet.de>
References: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
 <e66a68873492c0b3e02f8459e88cedabe255e3b6.1658936270.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e66a68873492c0b3e02f8459e88cedabe255e3b6.1658936270.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 05:38:35PM +0200, Antony Antony wrote:
> This reverts commit af734a26a1a95a9fda51f2abb0c22a7efcafd5ca.
> 
> The abvoce commit is a regression according RFC 2367. A better fix would be
> use x->lastused. Which will be propsed later.
> 
> according to RFC 2367 use_time == sadb_lifetime_usetime.
> 
> "sadb_lifetime_usetime
>                    For CURRENT, the time, in seconds, when association
>                    was first used. For HARD and SOFT, the number of
>                    seconds after the first use of the association until
>                    it expires."
> 
> Fixes: af734a26a1a9 ("xfrm: update SA curlft.use_time")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Series applied, thanks Antony!
