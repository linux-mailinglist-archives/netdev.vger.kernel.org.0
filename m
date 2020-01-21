Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A0C143774
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAUHQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:16:41 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:35750 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgAUHQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:16:41 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0E3542052E;
        Tue, 21 Jan 2020 08:16:39 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LsNFq5c8HxBf; Tue, 21 Jan 2020 08:16:38 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A06F420491;
        Tue, 21 Jan 2020 08:16:38 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:16:38 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 49B7231802BC;
 Tue, 21 Jan 2020 08:16:38 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-01-21
Date:   Tue, 21 Jan 2020 08:16:27 +0100
Message-ID: <20200121071631.25188-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix packet tx through bpf_redirect() for xfrm and vti
   interfaces. From Nicolas Dichtel.

2) Do not confirm neighbor when do pmtu update on a virtual
   xfrm interface. From Xu Wang.

3) Support output_mark for offload ESP packets, this was
   forgotten when the output_mark was added initially.
   From Ulrich Weber.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit a112adafcb47760feff959ee1ecd10b74d2c5467:

  NFC: pn533: fix bulk-message timeout (2020-01-13 18:50:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 4e4362d2bf2a49ff44dbbc9585207977ca3d71d0:

  xfrm: support output_mark for offload ESP packets (2020-01-15 12:18:35 +0100)

----------------------------------------------------------------
Nicolas Dichtel (2):
      vti[6]: fix packet tx through bpf_redirect()
      xfrm interface: fix packet tx through bpf_redirect()

Ulrich Weber (1):
      xfrm: support output_mark for offload ESP packets

Xu Wang (1):
      xfrm: interface: do not confirm neighbor when do pmtu update

 net/ipv4/esp4_offload.c   |  2 ++
 net/ipv4/ip_vti.c         | 13 +++++++++++--
 net/ipv6/esp6_offload.c   |  2 ++
 net/ipv6/ip6_vti.c        | 13 +++++++++++--
 net/xfrm/xfrm_interface.c | 34 ++++++++++++++++++++++++++--------
 5 files changed, 52 insertions(+), 12 deletions(-)
