Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9835568EE26
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjBHLnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjBHLna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:43:30 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6F46168
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:43:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 669D820652;
        Wed,  8 Feb 2023 12:43:28 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3VCYRPoq2jjs; Wed,  8 Feb 2023 12:43:27 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CEA122066D;
        Wed,  8 Feb 2023 12:43:26 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id BF99280004A;
        Wed,  8 Feb 2023 12:43:26 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 8 Feb 2023 12:43:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 8 Feb
 2023 12:43:25 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6547A31802C0; Wed,  8 Feb 2023 12:43:25 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/6] pull request (net): ipsec 2023-02-08
Date:   Wed, 8 Feb 2023 12:43:16 +0100
Message-ID: <20230208114322.266510-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
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

1) Fix policy checks for nested IPsec tunnels when using
   xfrm interfaces. From Benedict Wong.

2) Fix netlink message expression on 32=>64-bit
   messages translators. From Anastasia Belova.

3) Prevent potential spectre v1 gadget in xfrm_xlate32_attr.
   From Eric Dumazet.

4) Always consistently use time64_t in xfrm_timer_handler.
   From Eric Dumazet.

5) Fix KCSAN reported bug: Multiple cpus can update use_time
   at the same time. From Eric Dumazet.

6) Fix SCP copy from IPv4 to IPv6 on interfamily tunnel.
   From Christian Hopps.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 571f3dd0d01b62ec63a4039320dbdbcd54ae8fb0:

  Merge tag 'rxrpc-fixes-20230107' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2023-01-07 23:10:33 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git tags/ipsec-2023-02-08

for you to fetch changes up to 6028da3f125fec34425dbd5fec18e85d372b2af6:

  xfrm: fix bug with DSCP copy to v6 from v4 tunnel (2023-01-30 11:31:58 +0100)

----------------------------------------------------------------
ipsec-2023-02-08

----------------------------------------------------------------
Anastasia Belova (1):
      xfrm: compat: change expression for switch in xfrm_xlate64

Benedict Wong (1):
      Fix XFRM-I support for nested ESP tunnels

Christian Hopps (1):
      xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Eric Dumazet (3):
      xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
      xfrm: consistently use time64_t in xfrm_timer_handler()
      xfrm: annotate data-race around use_time

 net/xfrm/xfrm_compat.c         |  4 +++-
 net/xfrm/xfrm_input.c          |  3 +--
 net/xfrm/xfrm_interface_core.c | 54 ++++++++++++++++++++++++++++++++++++++----
 net/xfrm/xfrm_policy.c         | 14 +++++++----
 net/xfrm/xfrm_state.c          | 18 +++++++-------
 5 files changed, 73 insertions(+), 20 deletions(-)
