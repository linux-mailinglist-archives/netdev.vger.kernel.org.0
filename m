Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA7E6356B2
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbiKWJdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiKWJcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:32:20 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1781618B28
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:31:21 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 40E322052E;
        Wed, 23 Nov 2022 10:31:20 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZQyoaSSWzvkc; Wed, 23 Nov 2022 10:31:19 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B4F352019C;
        Wed, 23 Nov 2022 10:31:19 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id AFACD80004A;
        Wed, 23 Nov 2022 10:31:19 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 10:31:19 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 10:31:19 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2B5383182F8F; Wed, 23 Nov 2022 10:31:19 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/6] pull request (net): ipsec 2022-11-23
Date:   Wed, 23 Nov 2022 10:31:10 +0100
Message-ID: <20221123093117.434274-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
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

1) Fix "disable_policy" on ipv4 early demuxP Packets after
   the initial packet in a flow might be incorectly dropped
   on early demux if there are no matching policies.
   From Eyal Birger.

2) Fix a kernel warning in case XFRM encap type is not
   available. From Eyal Birger.

3) Fix ESN wrap around for GSO to avoid a double usage of a
    sequence number. From Christian Langrock.

4) Fix a send_acquire race with pfkey_register.
   From Herbert Xu.

5) Fix a list corruption panic in __xfrm_state_delete().
   Thomas Jarosch.

6) Fix an unchecked return value in xfrm6_init().
   Chen Zhongjin.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 1d22f78d05737ce21bff7b88b6e58873f35e65ba:

  Merge tag 'ieee802154-for-net-2022-10-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2022-10-05 20:38:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 40781bfb836eda57d19c0baa37c7e72590e05fdc:

  xfrm: Fix ignored return value in xfrm6_init() (2022-11-22 07:16:34 +0100)

----------------------------------------------------------------
Chen Zhongjin (1):
      xfrm: Fix ignored return value in xfrm6_init()

Christian Langrock (1):
      xfrm: replay: Fix ESN wrap around for GSO

Eyal Birger (2):
      xfrm: fix "disable_policy" on ipv4 early demux
      xfrm: lwtunnel: squelch kernel warning in case XFRM encap type is not available

Herbert Xu (1):
      af_key: Fix send_acquire race with pfkey_register

Thomas Jarosch (1):
      xfrm: Fix oops in __xfrm_state_delete()

 net/core/lwtunnel.c     |  4 +++-
 net/ipv4/esp4_offload.c |  3 +++
 net/ipv4/ip_input.c     |  5 +++++
 net/ipv6/esp6_offload.c |  3 +++
 net/ipv6/xfrm6_policy.c |  6 +++++-
 net/key/af_key.c        | 34 +++++++++++++++++++++++-----------
 net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
 net/xfrm/xfrm_replay.c  |  2 +-
 8 files changed, 57 insertions(+), 15 deletions(-)
