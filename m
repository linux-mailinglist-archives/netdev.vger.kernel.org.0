Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061B660223
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfGEI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:27:07 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36378 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbfGEI1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:27:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 577E920255;
        Fri,  5 Jul 2019 10:27:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2tQiCUOhC-rI; Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6F576201E6;
        Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:27:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 17A61318061E;
 Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2019-07-05
Date:   Fri, 5 Jul 2019 10:26:53 +0200
Message-ID: <20190705082700.31107-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1)  Fix xfrm selector prefix length validation for
    inter address family tunneling.
    From Anirudh Gupta.

2) Fix a memleak in pfkey.
   From Jeremy Sowden.

3) Fix SA selector validation to allow empty selectors again.
   From Nicolas Dichtel.

4) Select crypto ciphers for xfrm_algo, this fixes some
   randconfig builds. From Arnd Bergmann.

5) Remove a duplicated assignment in xfrm_bydst_resize.
   From Cong Wang.

6) Fix a hlist corruption on hash rebuild.
   From Florian Westphal.

7) Fix a memory leak when creating xfrm interfaces.
   From Nicolas Dichtel.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit af8f3fb7fb077c9df9fed97113a031e792163def:

  net: stmmac: dma channel control register need to be init first (2019-05-20 20:55:39 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 56c5ee1a5823e9cf5288b84ae6364cb4112f8225:

  xfrm interface: fix memory leak on creation (2019-07-03 10:53:06 +0200)

----------------------------------------------------------------
Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation

Arnd Bergmann (1):
      ipsec: select crypto ciphers for xfrm_algo

Cong Wang (1):
      xfrm: remove a duplicated assignment

Florian Westphal (1):
      xfrm: policy: fix bydst hlist corruption on hash rebuild

Jeremy Sowden (1):
      af_key: fix leaks in key_pol_get_resp and dump_sp.

Nicolas Dichtel (2):
      xfrm: fix sa selector validation
      xfrm interface: fix memory leak on creation

 net/key/af_key.c                           |  8 ++-
 net/xfrm/Kconfig                           |  2 +
 net/xfrm/xfrm_interface.c                  | 98 +++++++++---------------------
 net/xfrm/xfrm_policy.c                     | 15 +++--
 net/xfrm/xfrm_user.c                       | 19 ++++++
 tools/testing/selftests/net/xfrm_policy.sh | 27 +++++++-
 6 files changed, 88 insertions(+), 81 deletions(-)
