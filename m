Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4362C4A9BC5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359596AbiBDPTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:08 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50326 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242172AbiBDPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:08 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A364360187;
        Fri,  4 Feb 2022 16:19:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/6] Netfilter fixes for net
Date:   Fri,  4 Feb 2022 16:18:56 +0100
Message-Id: <20220204151903.320786-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Don't refresh timeout for SCTP flows in CLOSED state.

2) Don't allow access to transport header if fragment offset is set on.

3) Reinitialize internal conntrack state for retransmitted TCP
   syn-ack packet.

4) Update MAINTAINER file to add the Netfilter group tree. Moving
   forward, Florian Westphal has access to this tree so he can also
   send pull requests.

5) Set on IPS_HELPER for entries created via ctnetlink, otherwise NAT
   might zap it.

All patches from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit ed14fc7a79ab43e9f2cb1fa9c1733fdc133bba30:

  net: sparx5: Fix get_stat64 crash in tcpdump (2022-02-03 19:01:15 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to d1ca60efc53d665cf89ed847a14a510a81770b81:

  netfilter: ctnetlink: disable helper autoassign (2022-02-04 05:39:57 +0100)

----------------------------------------------------------------
Florian Westphal (6):
      netfilter: conntrack: don't refresh sctp entries in closed state
      netfilter: nft_payload: don't allow th access for fragments
      netfilter: conntrack: move synack init code to helper
      netfilter: conntrack: re-init state for retransmitted syn-ack
      MAINTAINERS: netfilter: update git links
      netfilter: ctnetlink: disable helper autoassign

 MAINTAINERS                                        |  4 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |  2 +-
 net/netfilter/nf_conntrack_netlink.c               |  3 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  9 ++++
 net/netfilter/nf_conntrack_proto_tcp.c             | 59 +++++++++++++++-------
 net/netfilter/nft_exthdr.c                         |  2 +-
 net/netfilter/nft_payload.c                        |  9 ++--
 7 files changed, 61 insertions(+), 27 deletions(-)
