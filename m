Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E943CEFFF
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfD3FbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:31:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46814 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfD3Fau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6BB8620268;
        Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ku_tkkrA_kWL; Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 670E02026B;
        Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id DF6143180584;
 Tue, 30 Apr 2019 07:30:46 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2019-04-30
Date:   Tue, 30 Apr 2019 07:30:18 +0200
Message-ID: <20190430053030.27009-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 5827F9EF-B50D-4062-B12F-184131A88B8A
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix an out-of-bound array accesses in __xfrm_policy_unlink.
   From YueHaibing.

2) Reset the secpath on failure in the ESP GRO handlers
   to avoid dereferencing an invalid pointer on error.
   From Myungho Jung.

3) Add and revert a patch that tried to add rcu annotations
   to netns_xfrm. From Su Yanjun.

4) Wait for rcu callbacks before freeing xfrm6_tunnel_spi_kmem.
   From Su Yanjun.

5) Fix forgotten vti4 ipip tunnel deregistration.
   From Jeremy Sowden:

6) Remove some duplicated log messages in vti4.
   From Jeremy Sowden.

7) Don't use IPSEC_PROTO_ANY when flushing states because
   this will flush only IPsec portocol speciffic states.
   IPPROTO_ROUTING states may remain in the lists when
   doing net exit. Fix this by replacing IPSEC_PROTO_ANY
   with zero. From Cong Wang.

8) Add length check for UDP encapsulation to fix "Oversized IP packet"
   warnings on receive side. From Sabrina Dubroca.

9) Fix xfrm interface lookup when the interface is associated to
   a vrf layer 3 master device. From Martin Willi.

10) Reload header pointers after pskb_may_pull() in _decode_session4(),
    otherwise we may read from uninitialized memory.

11) Update the documentation about xfrm[46]_gc_thresh, it
    is not used anymore after the flowcache removal.
    From Nicolas Dichtel.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit d235c48b40d399328585a68f3f9bf7cc3062d586:

  net: dsa: mv88e6xxx: power serdes on/off for 10G interfaces on 6390X (2019-02-28 15:16:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 837f74116585dcd235fae1696e1e1471b6bb9e01:

  xfrm: update doc about xfrm[46]_gc_thresh (2019-04-12 09:38:23 +0200)

----------------------------------------------------------------
Cong Wang (1):
      xfrm: clean up xfrm protocol checks

Jeremy Sowden (2):
      vti4: ipip tunnel deregistration fixes.
      vti4: removed duplicate log message.

Martin Willi (1):
      xfrm: Honor original L3 slave device in xfrmi policy lookup

Myungho Jung (1):
      xfrm: Reset secpath in xfrm failure

Nicolas Dichtel (1):
      xfrm: update doc about xfrm[46]_gc_thresh

Sabrina Dubroca (1):
      esp4: add length check for UDP encapsulation

Steffen Klassert (2):
      Revert "net: xfrm: Add '_rcu' tag for rcu protected pointer in netns_xfrm"
      xfrm4: Fix uninitialized memory read in _decode_session4

Su Yanjun (2):
      net: xfrm: Add '_rcu' tag for rcu protected pointer in netns_xfrm
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

YueHaibing (1):
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

 Documentation/networking/ip-sysctl.txt |  2 ++
 include/net/xfrm.h                     | 20 +++++++++++++++++++-
 net/ipv4/esp4.c                        | 20 +++++++++++++++-----
 net/ipv4/esp4_offload.c                |  8 +++++---
 net/ipv4/ip_vti.c                      |  9 ++++-----
 net/ipv4/xfrm4_policy.c                | 24 +++++++++++++-----------
 net/ipv6/esp6_offload.c                |  8 +++++---
 net/ipv6/xfrm6_tunnel.c                |  6 +++++-
 net/key/af_key.c                       |  4 +++-
 net/xfrm/xfrm_interface.c              | 17 ++++++++++++++---
 net/xfrm/xfrm_policy.c                 |  2 +-
 net/xfrm/xfrm_state.c                  |  2 +-
 net/xfrm/xfrm_user.c                   | 16 ++--------------
 13 files changed, 89 insertions(+), 49 deletions(-)
