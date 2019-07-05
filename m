Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C2B6028B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfGEIqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37462 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfGEIqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A1B01201F9;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TzWcqChICf7C; Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 86FAF20250;
        Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 38CBC318061E;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2019-07-05
Date:   Fri, 5 Jul 2019 10:46:01 +0200
Message-ID: <20190705084610.3646-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) A lot of work to remove indirections from the xfrm code.
   From Florian Westphal.

2) Fix a WARN_ON with ipv6 that triggered because of a
   forgotten break statement. From Florian Westphal.

3)  Remove xfrmi_init_net, it is not needed.
    From Li RongQing.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 2a99283cb7c1ef1bc61770a2a20ef88693687443:

  Merge branch 'net-dsa-mv88e6xxx-support-for-mv88e6250' (2019-06-04 20:07:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to c7b37c769d2a5e711106a3c793140a4f46768e04:

  xfrm: remove get_mtu indirection from xfrm_type (2019-07-01 06:16:40 +0200)

----------------------------------------------------------------
Florian Westphal (8):
      xfrm: remove init_tempsel indirection from xfrm_state_afinfo
      xfrm: remove init_temprop indirection from xfrm_state_afinfo
      xfrm: remove init_flags indirection from xfrm_state_afinfo
      xfrm: remove state and template sort indirections from xfrm_state_afinfo
      xfrm: remove eth_proto value from xfrm_state_afinfo
      xfrm: remove type and offload_type map from xfrm_state_afinfo
      xfrm: fix bogus WARN_ON with ipv6
      xfrm: remove get_mtu indirection from xfrm_type

Li RongQing (1):
      xfrm: remove empty xfrmi_init_net

 include/net/xfrm.h        |  53 +++---
 net/ipv4/ah4.c            |   3 +-
 net/ipv4/esp4.c           |  30 +---
 net/ipv4/esp4_offload.c   |   4 +-
 net/ipv4/ipcomp.c         |   3 +-
 net/ipv4/xfrm4_state.c    |  45 -----
 net/ipv4/xfrm4_tunnel.c   |   3 +-
 net/ipv6/ah6.c            |   4 +-
 net/ipv6/esp6.c           |  23 +--
 net/ipv6/esp6_offload.c   |   4 +-
 net/ipv6/ipcomp6.c        |   3 +-
 net/ipv6/mip6.c           |   6 +-
 net/ipv6/xfrm6_state.c    | 137 ---------------
 net/xfrm/xfrm_device.c    |   5 +-
 net/xfrm/xfrm_input.c     |  25 +--
 net/xfrm/xfrm_interface.c |   6 -
 net/xfrm/xfrm_policy.c    |   2 +-
 net/xfrm/xfrm_state.c     | 437 ++++++++++++++++++++++++++++++++++------------
 18 files changed, 381 insertions(+), 412 deletions(-)
