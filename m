Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0F84B191D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345457AbiBJXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:10:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiBJXK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:10:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FCD4266C;
        Thu, 10 Feb 2022 15:10:26 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8A7D16019D;
        Fri, 11 Feb 2022 00:10:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/6] Netfilter fixes for net
Date:   Fri, 11 Feb 2022 00:10:15 +0100
Message-Id: <20220210231021.204488-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Add selftest for nft_synproxy, from Florian Westphal.

2) xt_socket destroy path incorrectly disables IPv4 defrag for
   IPv6 traffic (typo), from Eric Dumazet.

3) Fix exit value selftest nft_concat_range.sh, from Hangbin Liu.

4) nft_synproxy disables the IPv4 hooks if the IPv6 hooks fail
   to be registered.

5) disable rp_filter on router in selftest nft_fib.sh, also
   from Hangbin Liu.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 7db788ad627aabff2b74d4f1a3b68516d0fee0d7:

  nfp: flower: fix ida_idx not being released (2022-02-08 21:06:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to bbe4c0896d25009a7c86285d2ab024eed4374eea:

  selftests: netfilter: disable rp_filter on router (2022-02-11 00:01:04 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: xt_socket: fix a typo in socket_mt_destroy()

Florian Westphal (1):
      selftests: netfilter: add synproxy test

Hangbin Liu (2):
      selftests: netfilter: fix exit value for nft_concat_range
      selftests: netfilter: disable rp_filter on router

Pablo Neira Ayuso (2):
      netfilter: nft_synproxy: unregister hooks on init error path
      selftests: netfilter: synproxy test requires nf_conntrack

 net/netfilter/nft_synproxy.c                       |   4 +-
 net/netfilter/xt_socket.c                          |   2 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/nft_concat_range.sh        |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh       |   1 +
 tools/testing/selftests/netfilter/nft_synproxy.sh  | 117 +++++++++++++++++++++
 6 files changed, 124 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_synproxy.sh
