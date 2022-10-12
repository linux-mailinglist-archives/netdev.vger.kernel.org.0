Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86FB5FC52A
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJLMTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJLMTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:19:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB0BBEFA0;
        Wed, 12 Oct 2022 05:19:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oiahi-0002eU-DS; Wed, 12 Oct 2022 14:19:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/3] netfilter fixes for net
Date:   Wed, 12 Oct 2022 14:18:59 +0200
Message-Id: <20221012121902.27738-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series from Phil Sutter for the *net* tree fixes a problem with a change
from the 6.1 development phase: the change to nft_fib should have used
the more recent flowic_l3mdev field.  Pointed out by Guillaume Nault.
This also makes the older iptables module follow the same pattern.

Also add selftest case and avoid test failure in nft_fib.sh when the
host environment has set rp_filter=1.

Please consider pulling this from

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git master

----------------------------------------------------------------
The following changes since commit 739cfa34518ef3a6789f5f77239073972a387359:

  net/mlx5: Make ASO poll CQ usable in atomic context (2022-10-12 09:16:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git master

for you to fetch changes up to 6a91e7270936c5a504af7e0a197d7021e169d281:

  selftests: netfilter: Fix nft_fib.sh for all.rp_filter=1 (2022-10-12 14:08:15 +0200)

----------------------------------------------------------------
Phil Sutter (3):
      selftests: netfilter: Test reverse path filtering
      netfilter: rpfilter/fib: Populate flowic_l3mdev field
      selftests: netfilter: Fix nft_fib.sh for all.rp_filter=1

 net/ipv4/netfilter/ipt_rpfilter.c            |   2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c            |   2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c           |   9 +-
 net/ipv6/netfilter/nft_fib_ipv6.c            |   5 +-
 tools/testing/selftests/netfilter/Makefile   |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh |   1 +
 tools/testing/selftests/netfilter/rpath.sh   | 147 +++++++++++++++++++++++++++
 7 files changed, 156 insertions(+), 12 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/rpath.sh
