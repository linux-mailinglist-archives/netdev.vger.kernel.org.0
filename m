Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC11965C6
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 12:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgC1L3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 07:29:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33410 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgC1L3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 07:29:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CC6242052E;
        Sat, 28 Mar 2020 12:29:31 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4Hm3vpDhsdx5; Sat, 28 Mar 2020 12:29:31 +0100 (CET)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E2E062054D;
        Sat, 28 Mar 2020 12:29:29 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 28 Mar
 2020 12:29:29 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5562C31801E6; Sat, 28 Mar 2020 12:29:29 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2020-03-28
Date:   Sat, 28 Mar 2020 12:29:19 +0100
Message-ID: <20200328112924.676-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-02.secunet.de (10.53.40.202)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Use kmem_cache_zalloc() instead of kmem_cache_alloc()
   in xfrm_state_alloc(). From Huang Zijiang.

2) esp_output_fill_trailer() is the same in IPv4 and IPv6,
   so share this function to avoide code duplcation.
   From Raed Salem.

3) Add offload support for esp beet mode.
   From Xin Long.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 92df9f8a745ee9b8cc250514272345cb2e74e7ef:

  Merge branch 'mvneta-xdp-ethtool-stats' (2020-02-16 20:04:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 308491755f36c461ee67290af159fdba6be0169d:

  xfrm: add prep for esp beet mode offload (2020-03-26 14:51:07 +0100)

----------------------------------------------------------------
Huang Zijiang (1):
      xfrm: Use kmem_cache_zalloc() instead of kmem_cache_alloc() with flag GFP_ZERO.

Raed Salem (1):
      ESP: Export esp_output_fill_trailer function

Xin Long (3):
      esp4: add gso_segment for esp4 beet mode
      esp6: add gso_segment for esp6 beet mode
      xfrm: add prep for esp beet mode offload

 include/net/esp.h       | 16 ++++++++++++++++
 net/ipv4/esp4.c         | 16 ----------------
 net/ipv4/esp4_offload.c | 32 ++++++++++++++++++++++++++++++++
 net/ipv6/esp6.c         | 16 ----------------
 net/ipv6/esp6_offload.c | 36 ++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_device.c  | 28 +++++++++++++++++++++++++++-
 net/xfrm/xfrm_state.c   |  2 +-
 7 files changed, 112 insertions(+), 34 deletions(-)
