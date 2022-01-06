Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC3486230
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbiAFJgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:36:19 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38788 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237449AbiAFJgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:36:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1F2F1201CC;
        Thu,  6 Jan 2022 10:36:17 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1PDEWFlTNqF4; Thu,  6 Jan 2022 10:36:13 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8DB1820627;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 887EE80004A;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:36:12 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:36:11 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 07B7B3182F75; Thu,  6 Jan 2022 10:36:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2022-01-06
Date:   Thu, 6 Jan 2022 10:36:00 +0100
Message-ID: <20220106093606.3046771-1-steffen.klassert@secunet.com>
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

1) Fix xfrm policy lookups for ipv6 gre packets by initializing
   fl6_gre_key properly. From Ghalem Boudour.

2) Fix the dflt policy check on forwarding when there is no
   policy configured. The check was done for the wrong direction.
   From Nicolas Dichtel.

3) Use the correct 'struct xfrm_user_offload' when calculating
   netlink message lenghts in xfrm_sa_len(). From Eric Dumazet.

4) Tread inserting xfrm interface id 0 as an error.
   From Antony Antony.

5) Fail if xfrm state or policy is inserted with XFRMA_IF_ID 0,
   xfrm interfaces with id 0 are not allowed.
   From Antony Antony.

6) Fix inner_ipproto setting in the sec_path for tunnel mode.
   From  Raed Salem.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 03a000bfd7193cacefb40e309283578c6ae207b5:

  Merge branch 'nh-group-refcnt' (2021-11-22 15:44:49 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 45a98ef4922def8c679ca7c454403d1957fe70e7:

  net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path (2022-01-05 10:59:35 +0100)

----------------------------------------------------------------
Antony Antony (2):
      xfrm: interface with if_id 0 should return error
      xfrm: state and policy should fail if XFRMA_IF_ID 0

Eric Dumazet (1):
      xfrm: fix a small bug in xfrm_sa_len()

Ghalem Boudour (1):
      xfrm: fix policy lookup for ipv6 gre packets

Nicolas Dichtel (1):
      xfrm: fix dflt policy check when there is no policy configured

Raed Salem (1):
      net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path

 include/net/xfrm.h        |  2 +-
 net/ipv6/ip6_gre.c        |  5 ++++-
 net/xfrm/xfrm_interface.c | 14 ++++++++++++--
 net/xfrm/xfrm_output.c    | 30 +++++++++++++++++++++++++-----
 net/xfrm/xfrm_policy.c    | 21 +++++++++++++++++++++
 net/xfrm/xfrm_user.c      | 23 +++++++++++++++++++----
 6 files changed, 82 insertions(+), 13 deletions(-)
