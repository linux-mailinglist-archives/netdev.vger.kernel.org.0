Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910991437C9
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAUHjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:39:14 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36760 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgAUHjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:39:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B3D7D20536;
        Tue, 21 Jan 2020 08:39:05 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id phduP3lr9rDk; Tue, 21 Jan 2020 08:39:05 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8C6642055E;
        Tue, 21 Jan 2020 08:39:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:39:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3CEAB31802BC;
 Tue, 21 Jan 2020 08:39:03 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2020-01-21
Date:   Tue, 21 Jan 2020 08:38:52 +0100
Message-ID: <20200121073858.31120-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Add support for TCP encapsulation of IKE and ESP messages,
   as defined by RFC 8229. Patchset from Sabrina Dubroca.

Please note that there is a merge conflict in:

net/unix/af_unix.c

between commit:

3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")

from the net-next tree and commit:

b50b0580d27b ("net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram")

from the ipsec-next tree.

The conflict can be solved as done in linux-next.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit e7096c131e5161fa3b8e52a650d7719d2857adfd:

  net: WireGuard secure network tunnel (2019-12-08 17:48:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to e27cca96cd68fa2c6814c90f9a1cfd36bb68c593:

  xfrm: add espintcp (RFC 8229) (2019-12-09 09:59:07 +0100)

----------------------------------------------------------------
Sabrina Dubroca (6):
      net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
      xfrm: introduce xfrm_trans_queue_net
      xfrm: add route lookup to xfrm4_rcv_encap
      esp4: prepare esp_input_done2 for non-UDP encapsulation
      esp4: split esp_output_udp_encap and introduce esp_output_encap
      xfrm: add espintcp (RFC 8229)

 include/linux/skbuff.h    |  11 +-
 include/net/espintcp.h    |  39 ++++
 include/net/xfrm.h        |   4 +
 include/uapi/linux/udp.h  |   1 +
 net/core/datagram.c       |  27 ++-
 net/ipv4/Kconfig          |  11 +
 net/ipv4/esp4.c           | 264 +++++++++++++++++++++---
 net/ipv4/udp.c            |   3 +-
 net/ipv4/xfrm4_protocol.c |   9 +
 net/unix/af_unix.c        |   7 +-
 net/xfrm/Makefile         |   1 +
 net/xfrm/espintcp.c       | 509 ++++++++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_input.c     |  21 +-
 net/xfrm/xfrm_policy.c    |   7 +
 net/xfrm/xfrm_state.c     |   3 +
 15 files changed, 871 insertions(+), 46 deletions(-)
 create mode 100644 include/net/espintcp.h
 create mode 100644 net/xfrm/espintcp.c
