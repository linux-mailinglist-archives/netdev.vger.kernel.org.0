Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868564C3F42
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiBYHsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbiBYHsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:48:13 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CBD18CC38
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 23:47:41 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D6B682056D;
        Fri, 25 Feb 2022 08:47:37 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UXjs6Do9npPQ; Fri, 25 Feb 2022 08:47:37 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5EA2A2049A;
        Fri, 25 Feb 2022 08:47:37 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 504A680004A;
        Fri, 25 Feb 2022 08:47:37 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Fri, 25 Feb 2022 08:47:37 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 25 Feb
 2022 08:47:36 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9E4553182ECA; Fri, 25 Feb 2022 08:47:36 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2022-02-25
Date:   Fri, 25 Feb 2022 08:47:27 +0100
Message-ID: <20220225074733.118664-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix PMTU for IPv6 if the reported MTU minus the ESP overhead is
   smaller than 1280. From Jiri Bohac.

2) Fix xfrm interface ID and inter address family tunneling when
   migrating xfrm states. From Yan Yan.

3) Add missing xfrm intrerface ID initialization on xfrmi_changelink.
   From Antony Antony.

4) Enforce validity of xfrm offload input flags so that userspace can't
   send undefined flags to the offload driver.
   From Leon Romanovsky.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit de8a820df2acd02eac1d98a99dd447634226d653:

  net: stmmac: remove unused members in struct stmmac_priv (2022-01-24 13:31:45 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 7c76ecd9c99b6e9a771d813ab1aa7fa428b3ade1:

  xfrm: enforce validity of offload input flags (2022-02-09 09:00:40 +0100)

----------------------------------------------------------------
Antony Antony (1):
      xfrm: fix the if_id check in changelink

Jiri Bohac (2):
      xfrm: fix MTU regression
      Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Yan Yan (2):
      xfrm: Check if_id in xfrm_migrate
      xfrm: Fix xfrm migrate issues when address family changes

 include/net/xfrm.h        |  6 +++---
 include/uapi/linux/xfrm.h |  6 ++++++
 net/ipv4/esp4.c           |  2 +-
 net/ipv6/esp6.c           |  2 +-
 net/ipv6/ip6_output.c     | 11 +++++++----
 net/key/af_key.c          |  2 +-
 net/xfrm/xfrm_device.c    |  6 +++++-
 net/xfrm/xfrm_interface.c |  2 +-
 net/xfrm/xfrm_policy.c    | 14 ++++++++------
 net/xfrm/xfrm_state.c     | 29 +++++++++++++----------------
 net/xfrm/xfrm_user.c      |  6 +++++-
 11 files changed, 51 insertions(+), 35 deletions(-)
