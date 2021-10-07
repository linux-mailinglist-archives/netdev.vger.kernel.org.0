Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC27424CE8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhJGF5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:57:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37642 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhJGF5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:57:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CEFE22057B;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jx6mgpJ-eBig; Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5AC3A200BB;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 52B1780004A;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 07:55:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 7 Oct
 2021 07:55:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9C5983183BED; Thu,  7 Oct 2021 07:55:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2021-10-07
Date:   Thu, 7 Oct 2021 07:55:19 +0200
Message-ID: <20211007055524.319785-1-steffen.klassert@secunet.com>
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

1) Fix a sysbot reported shift-out-of-bounds in xfrm_get_default.
   From Pavel Skripkin.

2) Fix XFRM_MSG_MAPPING ABI breakage. The new XFRM_MSG_MAPPING
   messages were accidentally not paced at the end.
   Fix by Eugene Syromiatnikov.

3) Fix the uapi for the default policy, use explicit field and macros
   and make it accessible to userland.
   From Nicolas Dichtel.

4) Fix a missing rcu lock in xfrm_notify_userpolicy().
   From Nicolas Dichtel.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 626bf91a292e2035af5b9d9cce35c5c138dfe06d:

  Merge tag 'net-5.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-07 14:02:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 93ec1320b0170d7a207eda2d119c669b673401ed:

  xfrm: fix rcu lock in xfrm_notify_userpolicy() (2021-09-23 10:11:12 +0200)

----------------------------------------------------------------
Eugene Syromiatnikov (1):
      include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage

Nicolas Dichtel (3):
      xfrm: make user policy API complete
      xfrm: notify default policy on update
      xfrm: fix rcu lock in xfrm_notify_userpolicy()

Pavel Skripkin (1):
      net: xfrm: fix shift-out-of-bounds in xfrm_get_default

Steffen Klassert (1):
      Merge branch 'xfrm: fix uapi for the default policy'

 include/uapi/linux/xfrm.h   | 15 ++++++----
 net/xfrm/xfrm_user.c        | 67 +++++++++++++++++++++++++++++++++++++--------
 security/selinux/nlmsgtab.c |  4 ++-
 3 files changed, 67 insertions(+), 19 deletions(-)
