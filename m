Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBDC1E7AA1
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgE2Kao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:44 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37582 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgE2KaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 81F3F205B4;
        Fri, 29 May 2020 12:30:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jwqzr1_51a9n; Fri, 29 May 2020 12:30:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 41F2A2054D;
        Fri, 29 May 2020 12:30:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id DE9A0318012D;
 Fri, 29 May 2020 12:30:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2020-05-29
Date:   Fri, 29 May 2020 12:30:00 +0200
Message-ID: <20200529103011.30127-1-steffen.klassert@secunet.com>
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

1) Add IPv6 encapsulation support for ESP over UDP and TCP.
   From Sabrina Dubroca.

2) Remove unneeded reference when initializing xfrm interfaces.
   From Nicolas Dichtel.

3) Remove some indirect calls from the state_afinfo.
   From Florian Westphal.

Please note that this pull request has two merge conflicts

between commit:

  0c922a4850eb ("xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish")

  from Linus' tree and commit:

    2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")

    from the ipsec-next tree.

and between commit:

  3986912f6a9a ("ipv6: move SIOCADDRT and SIOCDELRT handling into ->compat_ioctl")

  from the net-next tree and commit:

    0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")

    from the ipsec-next tree.

Both conflicts can be resolved as done in linux-next.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit b6246f4d8d0778fd045b84dbd7fc5aadd8f3136e:

  net: ipv4: remove redundant assignment to variable rc (2020-04-20 16:26:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 7d4343d501f9b5ddbc92f278adba339d16d010e1:

  xfrm: fix unused variable warning if CONFIG_NETFILTER=n (2020-05-11 15:12:27 +0200)

----------------------------------------------------------------
Florian Westphal (8):
      xfrm: avoid extract_output indirection for ipv4
      xfrm: state: remove extract_input indirection from xfrm_state_afinfo
      xfrm: move xfrm4_extract_header to common helper
      xfrm: expose local_rxpmtu via ipv6_stubs
      xfrm: place xfrm6_local_dontfrag in xfrm.h
      xfrm: remove extract_output indirection from xfrm_state_afinfo
      xfrm: remove output_finish indirection from xfrm_state_afinfo
      xfrm: fix unused variable warning if CONFIG_NETFILTER=n

Nicolas Dichtel (1):
      xfrm interface: don't take extra reference to netdev

Sabrina Dubroca (2):
      xfrm: add support for UDPv6 encapsulation of ESP
      xfrm: add IPv6 support for espintcp

 include/net/ipv6_stubs.h  |   6 +
 include/net/xfrm.h        |  31 +++-
 net/ipv4/Kconfig          |   1 +
 net/ipv4/udp.c            |  10 +-
 net/ipv4/xfrm4_input.c    |   5 -
 net/ipv4/xfrm4_output.c   |  65 +-------
 net/ipv4/xfrm4_state.c    |  24 ---
 net/ipv6/Kconfig          |  12 ++
 net/ipv6/af_inet6.c       |   6 +
 net/ipv6/ah6.c            |   1 +
 net/ipv6/esp6.c           | 414 +++++++++++++++++++++++++++++++++++++++++++---
 net/ipv6/esp6_offload.c   |   7 +-
 net/ipv6/ip6_vti.c        |  18 +-
 net/ipv6/ipcomp6.c        |   1 +
 net/ipv6/xfrm6_input.c    | 111 +++++++++++--
 net/ipv6/xfrm6_output.c   |  98 +----------
 net/ipv6/xfrm6_protocol.c |  48 ++++++
 net/ipv6/xfrm6_state.c    |  26 ---
 net/xfrm/Kconfig          |   3 +
 net/xfrm/Makefile         |   2 +-
 net/xfrm/espintcp.c       |  56 +++++--
 net/xfrm/xfrm_inout.h     |  32 ++++
 net/xfrm/xfrm_input.c     |  21 +--
 net/xfrm/xfrm_interface.c |   5 +-
 net/xfrm/xfrm_output.c    | 129 ++++++++++++++-
 25 files changed, 836 insertions(+), 296 deletions(-)
