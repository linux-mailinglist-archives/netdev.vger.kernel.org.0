Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61843DFBAA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhHDHDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:03:47 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41802 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235227AbhHDHDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:03:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2C3EF205E7;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hl0xWQqfqBwK; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A1EAB20534;
        Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9A1B180004A;
        Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:03:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 4 Aug 2021
 09:03:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 01EE631807A0; Wed,  4 Aug 2021 09:03:30 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2021-08-04
Date:   Wed, 4 Aug 2021 09:03:23 +0200
Message-ID: <20210804070329.1357123-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix a sysbot reported memory leak in xfrm_user_rcv_msg.
   From Pavel Skripkin.

2) Revert "xfrm: policy: Read seqcount outside of rcu-read side
   in xfrm_policy_lookup_bytype". This commit tried to fix a
   lockin bug, but only cured some of the symptoms. A proper
   fix is applied on top of this revert.

3) Fix a locking bug on xfrm state hash resize. A recent change
   on sequence counters accidentally repaced a spinlock by a mutex.
   Fix from Frederic Weisbecker.

4) Fix possible user-memory-access in xfrm_user_rcv_msg_compat().
   From Dmitry Safonov.

5) Add initialiation sefltest fot xfrm_spdattr_type_t.
   From Dmitry Safonov.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit a118ff661889ecee3ca90f8125bad8fb5bbc07d5:

  selftests: net: devlink_port_split: check devlink returned an element before dereferencing it (2021-06-28 16:14:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 480e93e12aa04d857f7cc2e6fcec181c0d690404:

  net: xfrm: Fix end of loop tests for list_for_each_entry (2021-07-26 12:26:28 +0200)

----------------------------------------------------------------
Dmitry Safonov (2):
      net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
      selftests/net/ipsec: Add test for xfrm_spdattr_type_t

Frederic Weisbecker (1):
      xfrm: Fix RCU vs hash_resize_mutex lock inversion

Harshvardhan Jha (1):
      net: xfrm: Fix end of loop tests for list_for_each_entry

Pavel Skripkin (1):
      net: xfrm: fix memory leak in xfrm_user_rcv_msg

Steffen Klassert (2):
      Revert "xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype"
      Merge branch 'xfrm/compat: Fix xfrm_spdattr_type_t copying'

 include/net/netns/xfrm.h            |   1 +
 net/xfrm/xfrm_compat.c              |  49 +++++++++--
 net/xfrm/xfrm_ipcomp.c              |   2 +-
 net/xfrm/xfrm_policy.c              |  32 +++----
 net/xfrm/xfrm_user.c                |  10 +++
 tools/testing/selftests/net/ipsec.c | 165 +++++++++++++++++++++++++++++++++++-
 6 files changed, 231 insertions(+), 28 deletions(-)
