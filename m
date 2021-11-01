Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1CA44156F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhKAImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:42:20 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57782 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhKAImU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 04:42:20 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 99AC063F04;
        Mon,  1 Nov 2021 09:37:53 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/5] Netfilter updates for net-next
Date:   Mon,  1 Nov 2021 09:39:35 +0100
Message-Id: <20211101083940.51007-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Use array_size() in ebtables, from Gustavo A. R. Silva.

2) Attach IPS_ASSURED to internal UDP stream state, reported by
   Maciej Zenczykowski.

3) Add NFT_META_IFTYPE to match on the interface type either
   from ingress or egress.

4) Generalize pktinfo->tprot_set to flags field.

5) Allow to match on inner headers / payload data.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit ab98bbee072c7c30c391ae742b209efebb468273:

  Merge branch 'ax88796c-spi-ethernet-adapter' (2021-10-21 16:28:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to c46b38dc8743535e686b911d253a844f0bd50ead:

  netfilter: nft_payload: support for inner header matching / mangling (2021-11-01 09:31:03 +0100)

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      netfilter: ebtables: use array_size() helper in copy_{from,to}_user()

Pablo Neira Ayuso (4):
      netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
      netfilter: nft_meta: add NFT_META_IFTYPE
      netfilter: nf_tables: convert pktinfo->tprot_set to flags field
      netfilter: nft_payload: support for inner header matching / mangling

 include/net/netfilter/nf_tables.h        | 10 ++++--
 include/net/netfilter/nf_tables_ipv4.h   |  7 ++--
 include/net/netfilter/nf_tables_ipv6.h   |  6 ++--
 include/uapi/linux/netfilter/nf_tables.h |  6 +++-
 net/bridge/netfilter/ebtables.c          |  7 ++--
 net/netfilter/nf_conntrack_proto_udp.c   |  7 ++--
 net/netfilter/nf_tables_core.c           |  2 +-
 net/netfilter/nf_tables_trace.c          |  4 +--
 net/netfilter/nft_meta.c                 |  8 +++--
 net/netfilter/nft_payload.c              | 60 +++++++++++++++++++++++++++++---
 10 files changed, 94 insertions(+), 23 deletions(-)
