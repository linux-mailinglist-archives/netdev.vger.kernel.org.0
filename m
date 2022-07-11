Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB1056D7C8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiGKIYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGKIYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:24:09 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D551AD87
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:24:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 001AD204E0;
        Mon, 11 Jul 2022 10:24:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KEq9CoUBx4au; Mon, 11 Jul 2022 10:24:05 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 72418201E5;
        Mon, 11 Jul 2022 10:24:05 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 68E9180004A;
        Mon, 11 Jul 2022 10:24:05 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 10:24:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Jul
 2022 10:24:04 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1F3C93182E41; Mon, 11 Jul 2022 10:24:04 +0200 (CEST)
Date:   Mon, 11 Jul 2022 10:24:04 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>,
        "Tobias Brunner" <tobias@strongswan.org>
Subject: Re: [PATCH ipsec-next 1/4] Revert "xfrm: update SA curlft.use_time"
Message-ID: <20220711082404.GM566407@gauss3.secunet.de>
References: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 08:16:28AM +0200, Antony Antony wrote:
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

This is a fix, so it should go to the ipsec tree. Please
slpit your patchset into fixes that go to the ipsec tree
and new features that go to ipsec-next.

Thanks!

