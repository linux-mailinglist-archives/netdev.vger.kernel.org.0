Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8927527A974
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgI1IY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:24:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48602 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgI1IY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 04:24:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8C7AC20519;
        Mon, 28 Sep 2020 10:24:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MyDg0GSqdV6c; Mon, 28 Sep 2020 10:24:55 +0200 (CEST)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1EC34204EF;
        Mon, 28 Sep 2020 10:24:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 28 Sep 2020 10:24:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 28 Sep
 2020 10:24:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6C3BA318470F;
 Mon, 28 Sep 2020 10:24:54 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-09-28
Date:   Mon, 28 Sep 2020 10:24:42 +0200
Message-ID: <20200928082450.29414-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix a build warning in ip_vti if CONFIG_IPV6 is not set.
   From YueHaibing.

2) Restore IPCB on espintcp before handing the packet to xfrm
   as the information there is still needed.
   From Sabrina Dubroca.

3) Fix pmtu updating for xfrm interfaces.
   From Sabrina Dubroca.

4) Some xfrm state information was not cloned with xfrm_do_migrate.
   Fixes to clone the full xfrm state, from Antony Antony.

5) Use the correct address family in xfrm_state_find. The struct
   flowi must always be interpreted along with the original
   address family. This got lost over the years.
   Fix from Herbert Xu.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 1c3b63f155f637594268cd1add8335461691b314:

  net/tls: allow MSG_CMSG_COMPAT in sendmsg (2020-08-07 17:40:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to e94ee171349db84c7cfdc5fefbebe414054d0924:

  xfrm: Use correct address family in xfrm_state_find (2020-09-25 09:59:51 +0200)

----------------------------------------------------------------
Antony Antony (4):
      xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
      xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
      xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
      xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Herbert Xu (1):
      xfrm: Use correct address family in xfrm_state_find

Sabrina Dubroca (2):
      espintcp: restore IP CB before handing the packet to xfrm
      xfrmi: drop ignore_df check before updating pmtu

YueHaibing (1):
      ip_vti: Fix unused variable warning

 include/net/xfrm.h        | 16 ++++++----------
 net/ipv4/ip_vti.c         |  2 ++
 net/xfrm/espintcp.c       |  6 +++++-
 net/xfrm/xfrm_interface.c |  2 +-
 net/xfrm/xfrm_state.c     | 42 +++++++++++++++++++++++++++++++++++++-----
 5 files changed, 51 insertions(+), 17 deletions(-)
