Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA02F083
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfD3Ghd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:33 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48760 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfD3Ghd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 34B9820279;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M9q3zaZh6tcm; Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6C08620268;
        Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 056CC3180584;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2019-04-30
Date:   Tue, 30 Apr 2019 08:37:09 +0200
Message-ID: <20190430063727.10908-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: D86496CF-3C21-4171-94FB-D4F42EC69496
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) A lot of work to remove indirections from the xfrm code.
   From Florian Westphal.

2) Support ESP offload in combination with gso partial.
   From Boris Pismenny.

3) Remove some duplicated code from vti4.
   From Jeremy Sowden.

Please note that there is merge conflict

between commit:

8742dc86d0c7 ("xfrm4: Fix uninitialized memory read in _decode_session4")

from the ipsec tree and commit:

c53ac41e3720 ("xfrm: remove decode_session indirection from afinfo_policy")

from the ipsec-next tree. The merge conflict will appear
when those trees get merged during the merge window.
The conflict can be solved as it is done in linux-next:

https://lkml.org/lkml/2019/4/25/1207

Please pull or let me know if there are problems.

Thanks!

The following changes since commit e6d1407013a91722ffc89e980d715eb9ce7b57f6:

  tcp: remove conditional branches from tcp_mstamp_refresh() (2019-03-23 21:43:21 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to bb9cd077e216b886438c5698e1cd75f762ecd3c9:

  xfrm: remove unneeded export_symbols (2019-04-23 07:42:20 +0200)

----------------------------------------------------------------
Boris Pismenny (1):
      xfrm: gso partial offload support

Florian Westphal (16):
      xfrm: place af number into xfrm_mode struct
      xfrm: prefer family stored in xfrm_mode struct
      xfrm: remove input indirection from xfrm_mode
      xfrm: remove output indirection from xfrm_mode
      xfrm: remove xmit indirection from xfrm_mode
      xfrm: remove gso_segment indirection from xfrm_mode
      xfrm: remove input2 indirection from xfrm_mode
      xfrm: remove output2 indirection from xfrm_mode
      xfrm: remove afinfo pointer from xfrm_mode
      xfrm: make xfrm modes builtin
      xfrm: store xfrm_mode directly, not its address
      xfrm: kconfig: make xfrm depend on inet
      xfrm: remove tos indirection from afinfo_policy
      xfrm: remove init_path indirection from afinfo_policy
      xfrm: remove decode_session indirection from afinfo_policy
      xfrm: remove unneeded export_symbols

Jeremy Sowden (1):
      vti4: eliminated some duplicate code.

 include/net/xfrm.h                 | 116 +++--------
 net/core/pktgen.c                  |   2 +-
 net/ipv4/Kconfig                   |  29 +--
 net/ipv4/Makefile                  |   3 -
 net/ipv4/esp4_offload.c            |  50 ++++-
 net/ipv4/ip_vti.c                  |  66 +++----
 net/ipv4/xfrm4_mode_beet.c         | 155 ---------------
 net/ipv4/xfrm4_mode_transport.c    | 114 -----------
 net/ipv4/xfrm4_mode_tunnel.c       | 152 ---------------
 net/ipv4/xfrm4_output.c            |  27 ++-
 net/ipv4/xfrm4_policy.c            | 127 -------------
 net/ipv4/xfrm4_protocol.c          |   3 +-
 net/ipv6/Kconfig                   |  35 +---
 net/ipv6/Makefile                  |   4 -
 net/ipv6/esp6_offload.c            |  40 +++-
 net/ipv6/ip6_vti.c                 |   6 +-
 net/ipv6/xfrm6_mode_beet.c         | 131 -------------
 net/ipv6/xfrm6_mode_ro.c           |  85 ---------
 net/ipv6/xfrm6_mode_transport.c    | 121 ------------
 net/ipv6/xfrm6_mode_tunnel.c       | 151 ---------------
 net/ipv6/xfrm6_output.c            |  36 ++--
 net/ipv6/xfrm6_policy.c            | 126 ------------
 net/ipv6/xfrm6_protocol.c          |   3 +-
 net/xfrm/Kconfig                   |   8 +-
 net/xfrm/xfrm_device.c             |  61 +++++-
 net/xfrm/xfrm_inout.h              |  38 ++++
 net/xfrm/xfrm_input.c              | 299 +++++++++++++++++++++++++++--
 net/xfrm/xfrm_interface.c          |   6 +-
 net/xfrm/xfrm_output.c             | 381 ++++++++++++++++++++++++++++++++++++-
 net/xfrm/xfrm_policy.c             | 280 +++++++++++++++++++++++----
 net/xfrm/xfrm_state.c              | 186 +++++++-----------
 tools/testing/selftests/net/config |   2 -
 32 files changed, 1249 insertions(+), 1594 deletions(-)
 delete mode 100644 net/ipv4/xfrm4_mode_beet.c
 delete mode 100644 net/ipv4/xfrm4_mode_transport.c
 delete mode 100644 net/ipv4/xfrm4_mode_tunnel.c
 delete mode 100644 net/ipv6/xfrm6_mode_beet.c
 delete mode 100644 net/ipv6/xfrm6_mode_ro.c
 delete mode 100644 net/ipv6/xfrm6_mode_transport.c
 delete mode 100644 net/ipv6/xfrm6_mode_tunnel.c
 create mode 100644 net/xfrm/xfrm_inout.h
