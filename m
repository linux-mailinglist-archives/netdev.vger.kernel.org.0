Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A075B1970
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiIHJ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIHJ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:58:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE36B2742;
        Thu,  8 Sep 2022 02:58:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWEIg-0002vX-Kf; Thu, 08 Sep 2022 11:58:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/4] netfilter: bugfixes for net
Date:   Thu,  8 Sep 2022 11:57:53 +0200
Message-Id: <20220908095757.1755-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The following set contains four netfilter patches for your *net* tree.

When there are multiple Contact headers in a SIP message its possible
the next headers won't be found because the SIP helper confuses relative
and absolute offsets in the message.  From Igor Ryzhov.

Make the nft_concat_range self-test support socat, this makes the
selftest pass on my test VM, from myself.

nf_conntrack_irc helper can be tricked into opening a local port forward
that the client never requested by embedding a DCC message in a PING
request sent to the client.  Fix from David Leadbeater.

Both have been broken since the kernel 2.6.x days.

The 'osf' match might indicate success while it could not find
anything, broken since 5.2 .  Fix from Pablo Neira.

Please consider pulling these changes from
  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

----------------------------------------------------------------
The following changes since commit 0f51fa2a3ca19783e7817a6be76661cd9136d057:

  Merge branch 'dsa-felix-fixes' (2022-09-07 13:44:04 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git 

for you to fetch changes up to 559c36c5a8d730c49ef805a72b213d3bba155cc8:

  netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find() (2022-09-07 15:55:28 +0200)

----------------------------------------------------------------
David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

Florian Westphal (1):
      selftests: nft_concat_range: add socat support

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

 net/netfilter/nf_conntrack_irc.c                   | 34 +++++++++--
 net/netfilter/nf_conntrack_sip.c                   |  4 +-
 net/netfilter/nfnetlink_osf.c                      |  4 +-
 .../selftests/netfilter/nft_concat_range.sh        | 65 ++++++++++++++++++----
 4 files changed, 86 insertions(+), 21 deletions(-)
