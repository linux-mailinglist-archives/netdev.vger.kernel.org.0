Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E0236CC7C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhD0Uog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54302 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbhD0Uoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:34 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C0AE864124;
        Tue, 27 Apr 2021 22:43:12 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/7] Netfilter updates for net-next
Date:   Tue, 27 Apr 2021 22:43:38 +0200
Message-Id: <20210427204345.22043-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add support for the catch-all set element. This special element
   can be used to define a default action to be applied in case that
   the set lookup returns no matching element.

2) Fix incorrect #ifdef dependencies in the nftables cgroupsv2
   support, from Arnd Bergmann.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 6d72e7c767acbbdd44ebc7d89c6690b405b32b57:

  net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send (2021-04-26 13:07:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 7acc0bb490c85012bcbda142b6755fd1fdf1fba1:

  netfilter: nft_socket: fix build with CONFIG_SOCK_CGROUP_DATA=n (2021-04-27 22:34:05 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      netfilter: nft_socket: fix an unused variable warning
      netfilter: nft_socket: fix build with CONFIG_SOCK_CGROUP_DATA=n

Pablo Neira Ayuso (5):
      netfilter: nftables: rename set element data activation/deactivation functions
      netfilter: nftables: add loop check helper function
      netfilter: nftables: add helper function to flush set elements
      netfilter: nftables: add helper function to validate set element data
      netfilter: nftables: add catch-all set element support

 include/net/netfilter/nf_tables.h        |   5 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c            | 576 ++++++++++++++++++++++++++-----
 net/netfilter/nft_lookup.c               |  12 +-
 net/netfilter/nft_objref.c               |  11 +-
 net/netfilter/nft_set_hash.c             |   6 +
 net/netfilter/nft_set_pipapo.c           |   6 +-
 net/netfilter/nft_set_rbtree.c           |   6 +
 net/netfilter/nft_socket.c               |  11 +-
 9 files changed, 532 insertions(+), 103 deletions(-)
