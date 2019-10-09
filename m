Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03984D1C6A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbfJIXIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:08:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:40462 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731959AbfJIXIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:08:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 16:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,277,1566889200"; 
   d="scan'208";a="205902509"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.70.56])
  by orsmga002.jf.intel.com with ESMTP; 09 Oct 2019 16:08:41 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v3 00/10] Multipath TCP prerequisites
Date:   Wed,  9 Oct 2019 16:07:59 -0700
Message-Id: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The MPTCP upstreaming community has prepared a net-next RFCv3 patch
set for review. The scope of this patch set is limited to prerequisite
TCP core changes so we can get focused feedback in these areas.

In this patch set we introduce some MPTCP definitions, additional ULP
and skb extension features, TCP option space checking, and a few
exported symbols.


Our intent is to send this as a non-RFC series when the next phase of
changes are ready to post. That second patch set will add CONFIG_MPTCP
in Kconfig, introduce the MPTCP socket type, implement the basic
features of the protocol, and add self tests.


Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-rfcv3)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-rfcv3


Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Mat Martineau (9):
  net: Make sock protocol value checks more specific
  sock: Make sk_protocol a 16-bit value
  tcp: Define IPPROTO_MPTCP
  tcp: Add MPTCP option number
  tcp, ulp: Add clone operation to tcp_ulp_ops
  mptcp: Add MPTCP to skb extensions
  tcp: Prevent coalesce/collapse when skb has MPTCP extensions
  tcp: Export TCP functions and ops struct
  tcp: Check for filled TCP option space before SACK

Paolo Abeni (1):
  tcp: clean ext on tx recycle

 include/linux/skbuff.h          |  3 +++
 include/net/mptcp.h             | 43 +++++++++++++++++++++++++++++++++
 include/net/sock.h              |  6 ++---
 include/net/tcp.h               | 19 +++++++++++++++
 include/trace/events/sock.h     |  5 ++--
 include/uapi/linux/in.h         |  2 ++
 net/ax25/af_ax25.c              |  2 +-
 net/core/skbuff.c               |  7 ++++++
 net/decnet/af_decnet.c          |  2 +-
 net/ipv4/inet_connection_sock.c |  2 ++
 net/ipv4/tcp.c                  |  6 ++---
 net/ipv4/tcp_input.c            | 10 ++++++--
 net/ipv4/tcp_ipv4.c             |  2 +-
 net/ipv4/tcp_output.c           |  5 +++-
 net/ipv4/tcp_ulp.c              | 12 +++++++++
 tools/include/uapi/linux/in.h   |  2 ++
 16 files changed, 114 insertions(+), 14 deletions(-)
 create mode 100644 include/net/mptcp.h

-- 
2.23.0

