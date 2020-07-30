Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA4232B79
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgG3Flt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56002 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgG3Flr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 433A1205B4;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zzaaA22LW5kk; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C136820270;
        Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1D20731801D4; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2020-07-30
Date:   Thu, 30 Jul 2020 07:41:11 +0200
Message-ID: <20200730054130.16923-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please note that I did the first time now --no-ff merges
of my testing branch into the master branch to include
the [PATCH 0/n] message of a patchset. Please let me
know if this is desirable, or if I should do it any
different.

1) Introduce a oseq-may-wrap flag to disable anti-replay
   protection for manually distributed ICVs as suggested
   in RFC 4303. From Petr Vaněk.

2) Patchset to fully support IPCOMP for vti4, vti6 and
   xfrm interfaces. From Xin Long.

3) Switch from a linear list to a hash list for xfrm interface
   lookups. From Eyal Birger.

4) Fixes to not register one xfrm(6)_tunnel object twice.
   From Xin Long.

5) Fix two compile errors that were introduced with the
   IPCOMP support for vti and xfrm interfaces.
   Also from Xin Long.

6) Make the policy hold queue work with VTI. This was
   forgotten when VTI was implemented.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 8af7b4525acf5012b2f111a8b168b8647f2c8d60:

  Merge branch 'net-atlantic-additional-A2-features' (2020-06-22 21:10:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to b328ecc468f8f92433c9ad82675c0ce9f99b10cf:

  xfrm: Make the policy hold queue work with VTI. (2020-07-21 08:34:44 +0200)

----------------------------------------------------------------
Eyal Birger (2):
      xfrm interface: avoid xi lookup in xfrmi_decode_session()
      xfrm interface: store xfrmi contexts in a hash by if_id

Petr Vaněk (1):
      xfrm: introduce oseq-may-wrap flag

Steffen Klassert (4):
      Merge remote-tracking branch 'origin/testing'
      Merge remote-tracking branch 'origin/testing'
      Merge remote-tracking branch 'origin/testing'
      xfrm: Make the policy hold queue work with VTI.

Xin Long (15):
      xfrm: add is_ipip to struct xfrm_input_afinfo
      tunnel4: add cb_handler to struct xfrm_tunnel
      tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
      ip_vti: support IPIP tunnel processing with .cb_handler
      ip_vti: support IPIP6 tunnel processing
      ip6_vti: support IP6IP6 tunnel processing with .cb_handler
      ip6_vti: support IP6IP tunnel processing
      ipcomp: assign if_id to child tunnel from parent tunnel
      xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler
      xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler
      ip_vti: not register vti_ipip_handler twice
      ip6_vti: not register vti_ipv6_handler twice
      xfrm: interface: not xfrmi_ipv6/ipip_handler twice
      xfrm: interface: use IS_REACHABLE to avoid some compile errors
      ip6_vti: use IS_REACHABLE to avoid some compile errors

 include/net/xfrm.h        |   5 +-
 include/uapi/linux/xfrm.h |   1 +
 net/ipv4/ip_vti.c         |  80 ++++++++++++++++-----------
 net/ipv4/ipcomp.c         |   1 +
 net/ipv4/tunnel4.c        |  43 +++++++++++++++
 net/ipv6/ip6_vti.c        |  52 +++++++++++++++++-
 net/ipv6/ipcomp6.c        |   1 +
 net/ipv6/tunnel6.c        |  41 ++++++++++++++
 net/xfrm/xfrm_input.c     |  24 ++++----
 net/xfrm/xfrm_interface.c | 136 +++++++++++++++++++++++++++++++++++++++-------
 net/xfrm/xfrm_policy.c    |  11 ++++
 net/xfrm/xfrm_replay.c    |  12 ++--
 12 files changed, 338 insertions(+), 69 deletions(-)
