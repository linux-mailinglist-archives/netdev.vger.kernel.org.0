Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D31368EA4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbhDWIOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:14:55 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:52888 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhDWIOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:14:54 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id E2A8180005A;
        Fri, 23 Apr 2021 10:14:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:14:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 10:14:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 368E431803A8; Fri, 23 Apr 2021 10:14:16 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2021-04-23
Date:   Fri, 23 Apr 2021 10:14:05 +0200
Message-ID: <20210423081409.729557-1-steffen.klassert@secunet.com>
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

1) The SPI flow key in struct flowi has no consumers,
   so remove it. From Florian Westphal.

2) Remove stray synchronize_rcu from xfrm_init.
   From Florian Westphal.

3) Use the new exit_pre hook to reset the netlink socket
   on net namespace destruction. From Florian Westphal.

4) Remove an unnecessary get_cpu() in ipcomp, that
   code is always called with BHs off.
   From Sabrina Dubroca.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 392c36e5be1dee19ffce8c8ba8f07f90f5aa3f7c:

  Merge branch 'ehtool-fec-stats' (2021-04-15 17:08:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 747b67088f8d34b3ec64d31447a1044be92dd348:

  xfrm: ipcomp: remove unnecessary get_cpu() (2021-04-19 12:49:29 +0200)

----------------------------------------------------------------
Florian Westphal (3):
      flow: remove spi key from flowi struct
      xfrm: remove stray synchronize_rcu from xfrm_init
      xfrm: avoid synchronize_rcu during netns destruction

Sabrina Dubroca (1):
      xfrm: ipcomp: remove unnecessary get_cpu()

 include/net/flow.h     |  3 ---
 net/xfrm/xfrm_ipcomp.c | 25 ++++++++-----------------
 net/xfrm/xfrm_policy.c | 42 ------------------------------------------
 net/xfrm/xfrm_user.c   | 10 +++++++---
 4 files changed, 15 insertions(+), 65 deletions(-)
