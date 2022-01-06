Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446404861E6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbiAFJOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:14:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37782 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237223AbiAFJOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:14:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EBD0F20656;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QdJ3NZVAt1pv; Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DEB972065A;
        Thu,  6 Jan 2022 10:13:57 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D041480004A;
        Thu,  6 Jan 2022 10:13:57 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:13:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:13:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5D4333182F75; Thu,  6 Jan 2022 10:13:54 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2022-01-06
Date:   Thu, 6 Jan 2022 10:13:43 +0100
Message-ID: <20220106091350.3038869-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix some clang_analyzer warnings about never read variables.
   From luo penghao.

2) Check for pols[0] only once in xfrm_expand_policies().
   From Jean Sacren.

3) The SA curlft.use_time was updated only on SA cration time.
   Update whenever the SA is used. From Antony Antony

4) Add support for SM3 secure hash.
   From Xu Jia.

5) Add support for SM4 symmetric cipher algorithm.
   From Xu Jia.

6) Add a rate limit for SA mapping change messages.
   From Antony Antony.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit bb8cecf8ba127abca8ccd102207a59c55fdae515:

  Merge branch 'lan78xx-napi' (2021-11-18 12:11:51 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 4e484b3e969b52effd95c17f7a86f39208b2ccf4:

  xfrm: rate limit SA mapping change message to user space (2021-12-23 09:32:51 +0100)

----------------------------------------------------------------
Antony Antony (2):
      xfrm: update SA curlft.use_time
      xfrm: rate limit SA mapping change message to user space

Jean Sacren (1):
      net: xfrm: drop check of pols[0] for the second time

Xu Jia (2):
      xfrm: Add support for SM3 secure hash
      xfrm: Add support for SM4 symmetric cipher algorithm

luo penghao (2):
      ipv6/esp6: Remove structure variables and alignment statements
      xfrm: Remove duplicate assignment

 include/net/xfrm.h           |  5 +++++
 include/uapi/linux/pfkeyv2.h |  2 ++
 include/uapi/linux/xfrm.h    |  1 +
 net/ipv6/esp6.c              |  3 +--
 net/xfrm/xfrm_algo.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_compat.c       |  6 ++++--
 net/xfrm/xfrm_input.c        |  1 +
 net/xfrm/xfrm_output.c       |  1 +
 net/xfrm/xfrm_policy.c       |  3 +--
 net/xfrm/xfrm_state.c        | 23 ++++++++++++++++++++++-
 net/xfrm/xfrm_user.c         | 18 +++++++++++++++++-
 11 files changed, 96 insertions(+), 8 deletions(-)
