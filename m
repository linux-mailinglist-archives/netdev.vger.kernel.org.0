Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F96A3654
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfH3MHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:07:14 -0400
Received: from correo.us.es ([193.147.175.20]:36266 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727635AbfH3MHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:07:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 012DDD2CAF
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCE9DDA801
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 845D4FF6FA; Fri, 30 Aug 2019 14:07:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FF90B8019;
        Fri, 30 Aug 2019 14:07:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 14:07:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4625E4251481;
        Fri, 30 Aug 2019 14:07:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Fri, 30 Aug 2019 14:06:59 +0200
Message-Id: <20190830120704.6147-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Spurious warning when loading rules using the physdev match,
   from Todd Seidelmann.

2) Fix FTP conntrack helper debugging output, from Thomas Jarosch.

3) Restore per-netns nf_conntrack_{acct,helper,timeout} sysctl knobs,
   from Florian Westphal.

4) Clear skbuff timestamp from the flowtable datapath, also from Florian.

5) Fix incorrect byteorder of NFT_META_BRI_IIFVPROTO, from wenxu.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f53a7ad189594a112167efaf17ea8d0242b5ac00:

  r8152: Set memory to all 0xFFs on failed reg reads (2019-08-25 19:52:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to daf1de9078792a4d60e36aa7ecf3aadca65277c2:

  netfilter: nft_meta_bridge: Fix get NFT_META_BRI_IIFVPROTO in network byteorder (2019-08-30 02:49:04 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: conntrack: make sysctls per-namespace again
      netfilter: nf_flow_table: clear skb tstamp before xmit

Thomas Jarosch (1):
      netfilter: nf_conntrack_ftp: Fix debug output

Todd Seidelmann (1):
      netfilter: xt_physdev: Fix spurious error message in physdev_mt_check

wenxu (1):
      netfilter: nft_meta_bridge: Fix get NFT_META_BRI_IIFVPROTO in network byteorder

 net/bridge/netfilter/nft_meta_bridge.c  | 2 +-
 net/netfilter/nf_conntrack_ftp.c        | 2 +-
 net/netfilter/nf_conntrack_standalone.c | 5 +++++
 net/netfilter/nf_flow_table_ip.c        | 3 ++-
 net/netfilter/xt_physdev.c              | 6 ++----
 5 files changed, 11 insertions(+), 7 deletions(-)
