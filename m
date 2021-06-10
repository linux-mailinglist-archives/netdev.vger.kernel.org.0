Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E483A317B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhFJQ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:57:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34618 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhFJQ5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:57:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A14096423A;
        Thu, 10 Jun 2021 18:53:48 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Thu, 10 Jun 2021 18:54:55 +0200
Message-Id: <20210610165458.23071-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix a crash when stateful expression with its own gc callback
   is used in a set definition.

2) Skip IPv6 packets from any link-local address in IPv6 fib expression.
   Add a selftest for this scenario, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you!

----------------------------------------------------------------

The following changes since commit f2386cf7c5f4ff5d7b584f5d92014edd7df6c676:

  net: lantiq: disable interrupt before sheduling NAPI (2021-06-08 19:16:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 12f36e9bf678a81d030ca1b693dcda62b55af7c5:

  netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local (2021-06-09 21:11:03 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      selftests: netfilter: add fib test case
      netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local

Pablo Neira Ayuso (1):
      netfilter: nf_tables: initialize set before expression setup

 net/ipv6/netfilter/nft_fib_ipv6.c            |  22 ++-
 net/netfilter/nf_tables_api.c                |  85 ++++++-----
 tools/testing/selftests/netfilter/Makefile   |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh | 221 +++++++++++++++++++++++++++
 4 files changed, 283 insertions(+), 47 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_fib.sh
