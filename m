Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6344262C26
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIIJmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:42:38 -0400
Received: from correo.us.es ([193.147.175.20]:34792 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgIIJm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B48382EFEA2
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A32ABDA78D
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A217CDA789; Wed,  9 Sep 2020 11:42:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6538DDA844;
        Wed,  9 Sep 2020 11:42:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 37C7B4301DE1;
        Wed,  9 Sep 2020 11:42:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/13] Netfilter updates for net-next
Date:   Wed,  9 Sep 2020 11:42:06 +0200
Message-Id: <20200909094219.17732-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Rewrite inner header IPv6 in ICMPv6 messages in ip6t_NPT,
   from Michael Zhou.

2) do_ip_vs_set_ctl() dereferences uninitialized value,
   from Peilin Ye.

3) Support for userdata in tables, from Jose M. Guisado.

4) Do not increment ct error and invalid stats at the same time,
   from Florian Westphal.

5) Remove ct ignore stats, also from Florian.

6) Add ct stats for clash resolution, from Florian Westphal.

7) Bump reference counter bump on ct clash resolution only,
   this is safe because bucket lock is held, again from Florian.

8) Use ip_is_fragment() in xt_HMARK, from YueHaibing.

9) Add wildcard support for nft_socket, from Balazs Scheidler.

10) Remove superfluous IPVS dependency on iptables, from
    Yaroslav Bolyukin.

11) Remove unused definition in ebt_stp, from Wang Hai.

12) Replace CONFIG_NFT_CHAIN_NAT_{IPV4,IPV6} by CONFIG_NFT_NAT
    in selftests/net, from Fabian Frederick.

13) Add userdata support for nft_object, from Jose M. Guisado.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 0f091e43310f5c292b7094f9f115e651358e8053:

  netlabel: remove unused param from audit_log_format() (2020-08-28 09:08:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to b131c96496b369c7b14125e7c50e89ac7cec8051:

  netfilter: nf_tables: add userdata support for nft_object (2020-09-08 16:35:38 +0200)

----------------------------------------------------------------
Balazs Scheidler (1):
      netfilter: nft_socket: add wildcard support

Fabian Frederick (1):
      selftests/net: replace obsolete NFT_CHAIN configuration

Florian Westphal (4):
      netfilter: conntrack: do not increment two error counters at same time
      netfilter: conntrack: remove ignore stats
      netfilter: conntrack: add clash resolution stat counter
      netfilter: conntrack: remove unneeded nf_ct_put

Jose M. Guisado Gomez (2):
      netfilter: nf_tables: add userdata attributes to nft_table
      netfilter: nf_tables: add userdata support for nft_object

Michael Zhou (1):
      netfilter: ip6t_NPT: rewrite addresses in ICMPv6 original packet

Peilin Ye (1):
      ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Wang Hai (1):
      netfilter: ebt_stp: Remove unused macro BPDU_TYPE_TCN

Yaroslav Bolyukin (1):
      ipvs: remove dependency on ip6_tables

YueHaibing (1):
      netfilter: xt_HMARK: Use ip_is_fragment() helper

 include/linux/netfilter/nf_conntrack_common.h      |  2 +-
 include/net/ip_vs.h                                |  3 --
 include/net/netfilter/nf_tables.h                  |  4 ++
 include/uapi/linux/netfilter/nf_tables.h           |  6 +++
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |  3 +-
 net/bridge/netfilter/ebt_stp.c                     |  1 -
 net/ipv6/netfilter/ip6t_NPT.c                      | 39 +++++++++++++++
 net/netfilter/ipvs/Kconfig                         |  1 -
 net/netfilter/ipvs/ip_vs_ctl.c                     |  7 +--
 net/netfilter/nf_conntrack_core.c                  | 25 ++++------
 net/netfilter/nf_conntrack_netlink.c               |  5 +-
 net/netfilter/nf_conntrack_standalone.c            |  4 +-
 net/netfilter/nf_tables_api.c                      | 57 ++++++++++++++++++----
 net/netfilter/nft_socket.c                         | 27 ++++++++++
 net/netfilter/xt_HMARK.c                           |  2 +-
 tools/testing/selftests/net/config                 |  3 +-
 16 files changed, 148 insertions(+), 41 deletions(-)
