Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34C02002E4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgFSHnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:55 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34760 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbgFSHnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 089FD2055E;
        Fri, 19 Jun 2020 09:43:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IVLOKBZpXrcP; Fri, 19 Jun 2020 09:43:48 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 28F0A20573;
        Fri, 19 Jun 2020 09:43:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 19 Jun 2020 09:43:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 19 Jun
 2020 09:43:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id DDF9E3180168;
 Fri, 19 Jun 2020 09:43:45 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-06-19
Date:   Fri, 19 Jun 2020 09:43:37 +0200
Message-ID: <20200619074342.14095-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix double ESP trailer insertion in IPsec crypto offload if
   netif_xmit_frozen_or_stopped is true. From Huy Nguyen.

2) Merge fixup for "remove output_finish indirection from
   xfrm_state_afinfo". From Stephen Rothwell.

3) Select CRYPTO_SEQIV for ESP as this is needed for GCM and several
   other encryption algorithms. Also modernize the crypto algorithm
   selections for ESP and AH, remove those that are maked as "MUST NOT"
   and add those that are marked as "MUST" be implemented in RFC 8221.
   From Eric Biggers.

Please note the merge conflict between commit:

a7f7f6248d97 ("treewide: replace '---help---' in Kconfig files with 'help'")

from Linus' tree and commits:

7d4e39195925 ("esp, ah: consolidate the crypto algorithm selections")
be01369859b8 ("esp, ah: modernize the crypto algorithm selections")

from the ipsec tree.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2020-06-03 16:27:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to be01369859b8aa07346e497381bb46d377da0d8c:

  esp, ah: modernize the crypto algorithm selections (2020-06-15 06:52:16 +0200)

----------------------------------------------------------------
Eric Biggers (3):
      esp, ah: consolidate the crypto algorithm selections
      esp: select CRYPTO_SEQIV
      esp, ah: modernize the crypto algorithm selections

Huy Nguyen (1):
      xfrm: Fix double ESP trailer insertion in IPsec crypto offload.

Stephen Rothwell (1):
      xfrm: merge fixup for "remove output_finish indirection from xfrm_state_afinfo"

 include/net/xfrm.h     |  1 +
 net/ipv4/Kconfig       | 34 ++++++++++++++++++----------------
 net/ipv6/Kconfig       | 34 ++++++++++++++++++----------------
 net/xfrm/Kconfig       | 24 ++++++++++++++++++++++++
 net/xfrm/xfrm_device.c |  4 +++-
 net/xfrm/xfrm_output.c |  4 ----
 6 files changed, 64 insertions(+), 37 deletions(-)
