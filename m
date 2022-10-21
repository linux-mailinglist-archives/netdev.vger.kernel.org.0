Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653F66073A4
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiJUJNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiJUJM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:12:57 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD1D2570B3;
        Fri, 21 Oct 2022 02:12:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 48AD42019D;
        Fri, 21 Oct 2022 11:11:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9l94Wvjqj3yJ; Fri, 21 Oct 2022 11:11:28 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CD98720189;
        Fri, 21 Oct 2022 11:11:28 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id BE90980004A;
        Fri, 21 Oct 2022 11:11:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 11:11:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 11:11:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id ADD1B3182AD5; Fri, 21 Oct 2022 11:11:27 +0200 (CEST)
Date:   Fri, 21 Oct 2022 11:11:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Christian Langrock <christian.langrock@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [IPSEC]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ipsec v7] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <20221021091127.GQ3294086@gauss3.secunet.de>
References: <20221017063447.1816366-1-christian.langrock@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221017063447.1816366-1-christian.langrock@secunet.com>
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

On Mon, Oct 17, 2022 at 08:34:47AM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.
> 
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
> Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>

Applied, thanks a lot Christian!
