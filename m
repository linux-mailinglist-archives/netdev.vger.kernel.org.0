Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77AA5EED1A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiI2FOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI2FOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:14:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0FF11BCD2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:14:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E1DD3204D9;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id F_bLmSwMykwW; Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6B56B201CA;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 5BE5980004A;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 07:14:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 07:14:00 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AAEE33182AD8; Thu, 29 Sep 2022 07:14:00 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/3] pull request (net): ipsec 2022-09-29
Date:   Thu, 29 Sep 2022 07:13:54 +0200
Message-ID: <20220929051357.3497325-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
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

1) Use the inner instead of the outer protocol for GSO on inter
   address family tunnels. This fixes the GSO case for address
   family tunnels. From Sabrina Dubroca.

2) Reset ipcomp_scratches with NULL when freed, otherwise
   it holds obsolete address. From Khalid Masum.

3) Reinject transport-mode packets through workqueue
   instead of a tasklet. The tasklet might take too
   long to finish. From Liu Jian.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit ebe5555c2f34505cdb1ae5c3de8b24e33740b3e0:

  nfp: flower: fix ingress police using matchall filter (2022-08-26 19:41:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 4f4920669d21e1060b7243e5118dc3b71ced1276:

  xfrm: Reinject transport-mode packets through workqueue (2022-09-28 09:04:12 +0200)

----------------------------------------------------------------
Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Liu Jian (1):
      xfrm: Reinject transport-mode packets through workqueue

Sabrina Dubroca (1):
      esp: choose the correct inner protocol for GSO on inter address family tunnels

 net/ipv4/esp4_offload.c |  5 ++++-
 net/ipv6/esp6_offload.c |  5 ++++-
 net/xfrm/xfrm_input.c   | 18 +++++++++++++-----
 net/xfrm/xfrm_ipcomp.c  |  1 +
 4 files changed, 22 insertions(+), 7 deletions(-)
