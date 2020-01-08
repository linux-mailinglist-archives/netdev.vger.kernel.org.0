Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5688B134FDA
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgAHXRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:17:20 -0500
Received: from correo.us.es ([193.147.175.20]:43140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgAHXRU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49E85FF9A3
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E52DDA70F
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 33AECDA701; Thu,  9 Jan 2020 00:17:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31F01DA701;
        Thu,  9 Jan 2020 00:17:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0DCCF426CCB9;
        Thu,  9 Jan 2020 00:17:16 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/9] Netfilter fixes for net
Date:   Thu,  9 Jan 2020 00:17:04 +0100
Message-Id: <20200108231713.100458-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Missing netns context in arp_tables, from Florian Westphal.

2) Underflow in flowtable reference counter, from wenxu.

3) Fix incorrect ethernet destination address in flowtable offload,
   from wenxu.

4) Check for status of neighbour entry, from wenxu.

5) Fix NAT port mangling, from wenxu.

6) Unbind callbacks from destroy path to cleanup hardware properly
   on flowtable removal.

7) Fix missing casting statistics timestamp, add nf_flowtable_time_stamp
   and use it.

8) NULL pointer exception when timeout argument is null in conntrack
   dccp and sctp protocol helpers, from Florian Westphal.

9) Possible nul-dereference in ipset with IPSET_ATTR_LINENO, also from
   Florian.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit bd6f48546b9cb7a785344fc78058c420923d7ed8:

  net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs (2019-12-27 16:37:07 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 22dad713b8a5ff488e07b821195270672f486eb2:

  netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present (2020-01-08 23:31:46 +0100)

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
      netfilter: conntrack: dccp, sctp: handle null timeout argument
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Pablo Neira Ayuso (2):
      netfilter: nf_tables: unbind callbacks from flowtable destroy path
      netfilter: flowtable: add nf_flowtable_time_stamp

wenxu (4):
      netfilter: nft_flow_offload: fix underflow in flowtable reference counter
      netfilter: nf_flow_table_offload: fix incorrect ethernet dst address
      netfilter: nf_flow_table_offload: check the status of dst_neigh
      netfilter: nf_flow_table_offload: fix the nat port mangle.

 include/net/netfilter/nf_flow_table.h   |  6 ++++
 net/ipv4/netfilter/arp_tables.c         | 27 ++++++++++--------
 net/netfilter/ipset/ip_set_core.c       |  3 +-
 net/netfilter/nf_conntrack_proto_dccp.c |  3 ++
 net/netfilter/nf_conntrack_proto_sctp.c |  3 ++
 net/netfilter/nf_flow_table_core.c      |  7 +----
 net/netfilter/nf_flow_table_ip.c        |  4 +--
 net/netfilter/nf_flow_table_offload.c   | 50 ++++++++++++++++++++++++---------
 net/netfilter/nf_tables_api.c           |  8 ++++--
 net/netfilter/nft_flow_offload.c        |  3 --
 10 files changed, 75 insertions(+), 39 deletions(-)
