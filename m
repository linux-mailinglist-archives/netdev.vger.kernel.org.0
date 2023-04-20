Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA916E9A52
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjDTRHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjDTRHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:07:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E27A811C;
        Thu, 20 Apr 2023 10:07:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Thu, 20 Apr 2023 19:06:55 +0200
Message-Id: <20230420170657.45373-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The following patchset contains late Netfilter fixes for net:

1) Set on IPS_CONFIRMED before change_status() otherwise EBUSY is
   bogusly hit. This bug was introduced in the 6.3 release cycle.

2) Fix nfnetlink_queue conntrack support: Set/dump timeout
   accordingly for unconfirmed conntrack entries. Make sure this
   is done after IPS_CONFIRMED is set on. This is an old bug, it
   happens since the introduction of this feature.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 92e8c732d8518588ac34b4cb3feaf37d2cb87555:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2023-04-18 20:46:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 73db1b8f2bb6725b7391e85aab41fdf592b3c0c1:

  netfilter: conntrack: fix wrong ct->timeout value (2023-04-19 12:08:38 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: conntrack: restore IPS_CONFIRMED out of nf_conntrack_hash_check_insert()

Tzung-Bi Shih (1):
      netfilter: conntrack: fix wrong ct->timeout value

 include/net/netfilter/nf_conntrack_core.h |  6 +++++-
 net/netfilter/nf_conntrack_bpf.c          |  1 +
 net/netfilter/nf_conntrack_core.c         |  1 -
 net/netfilter/nf_conntrack_netlink.c      | 16 ++++++++++++----
 4 files changed, 18 insertions(+), 6 deletions(-)
