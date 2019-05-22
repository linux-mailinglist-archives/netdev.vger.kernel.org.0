Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA16E26A72
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbfEVTE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbfEVTE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:04:57 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 168B820862;
        Wed, 22 May 2019 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558551897;
        bh=SiNeIDZKPxr4Qbs0ek4jtgXkPdPts811iHlh2QhaM3Y=;
        h=From:To:Cc:Subject:Date:From;
        b=k2/yFfZj6vLi3DLrCmSmVf3wj+WillJnKBACalEbGDeDIAm7k+flvQuXQ6cgolgYB
         UDWW11zlHrha7HsLTp3QQE/nqyoltKUeORcM5lBgJ9zwI7J3wPySQTqes+9stCwUaX
         P0V9DoX3h8Xmkprkyz6mi/LcQ+TSs4P+FJaAv8Bs=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 0/8] net: Export functions for nexthop code
Date:   Wed, 22 May 2019 12:04:38 -0700
Message-Id: <20190522190446.15486-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This set exports ipv4 and ipv6 fib functions for use by the nexthop
code. It also adds new ones to send route notifications if a nexthop
configuration changes.

v2
- repost of patches dropped at the end of the last dev window
  added patch 8 which exports nh_update_mtu since it is inline with
  the other patches

David Ahern (8):
  ipv6: Add delete route hook to stubs
  ipv6: Add hook to bump sernum for a route to stubs
  ipv6: export function to send route updates
  ipv4: Add function to send route updates
  ipv4: export fib_check_nh
  ipv4: export fib_flush
  ipv4: export fib_info_update_nh_saddr
  ipv4: Rename and export nh_update_mtu

 include/net/ip6_fib.h    |  7 +++++
 include/net/ip_fib.h     |  9 +++++-
 include/net/ipv6_stubs.h |  5 ++++
 net/ipv4/fib_frontend.c  |  2 +-
 net/ipv4/fib_semantics.c | 27 +++++++++---------
 net/ipv4/fib_trie.c      | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/addrconf_core.c |  6 ++++
 net/ipv6/af_inet6.c      |  3 ++
 net/ipv6/ip6_fib.c       | 16 ++++++++---
 net/ipv6/route.c         | 32 +++++++++++++++++++++
 10 files changed, 159 insertions(+), 20 deletions(-)

-- 
2.11.0

