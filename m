Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B172858207
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfF0MDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:03:36 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47454 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbfF0MDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:03:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hgT7m-0002l1-DI; Thu, 27 Jun 2019 14:03:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     ranro@mellanox.com, tariqt@mellanox.com
Subject: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Date:   Thu, 27 Jun 2019 14:03:31 +0200
Message-Id: <20190627120333.12469-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq and Ran reported a regression caused by net-next commit
2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list").

This happens when net.ipv4.conf.$dev.promote_secondaries sysctl is
enabled -- we can arrange for ifa->next to point at ifa, so next
process that tries to walk the list loops forever.

Fix this and extend rtnetlink.sh with a small test case for this.

Florian Westphal (2):
      net: ipv4: fix infinite loop on secondary addr promotion
      selftests: rtnetlink: add small test case with 'promote_secondaries' enabled

 net/ipv4/devinet.c                       |    3 ++-
 tools/testing/selftests/net/rtnetlink.sh |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)


