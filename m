Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27D65ED561
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiI1GvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiI1Guu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:50:50 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED6C1F65FE;
        Tue, 27 Sep 2022 23:49:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0BC64201CC;
        Wed, 28 Sep 2022 08:49:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9YqpzX5v-ApX; Wed, 28 Sep 2022 08:49:09 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5D72B2052D;
        Wed, 28 Sep 2022 08:49:08 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 4DE2380004A;
        Wed, 28 Sep 2022 08:49:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 08:49:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 28 Sep
 2022 08:49:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8E90531825E5; Wed, 28 Sep 2022 08:49:07 +0200 (CEST)
Date:   Wed, 28 Sep 2022 08:49:07 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Christian Langrock <christian.langrock@secunet.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-ipsec v2] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <20220928064907.GU566407@gauss3.secunet.de>
References: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
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

On Tue, Sep 27, 2022 at 02:59:50PM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.
> 
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for...")
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>

Some minor nits:

This is already v3, not v2 as stated in the subject line.
Also, please explain the changes between the versions
(see 'git log' for examples).

The target tree is 'ipsec', not 'net-ipsec'.

Otherwise this is a fix for a real bug. So fix the build,
incorporate the review from Leon and send a v4.

Thanks!
