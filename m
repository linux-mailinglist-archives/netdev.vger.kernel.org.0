Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082B914CCCE
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgA2OzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:55:03 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42552 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgA2OzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:55:03 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iwok8-00077s-PJ; Wed, 29 Jan 2020 15:55:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com
Subject: [PATCH net 0/4] mptcp: fix sockopt crash and lockdep splats
Date:   Wed, 29 Jan 2020 15:54:42 +0100
Message-Id: <20200129145446.26425-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Paasch reported a few bugs and lockdep splats triggered by
syzkaller.

One patch fixes a crash in set/getsockopt.
Two patches fix lockdep splats related to the order in which RTNL
and socket lock are taken.

Last patch fixes out-of-bounds access when TCP syncookies are used.

Change since last iteration on mptcp-list:
 - add needed refcount in patch 2
 - call tcp_get/setsockopt directly in patch 2

 Other patches unchanged except minor amends to commit messages.

 include/linux/tcp.h   |  2 --
 net/ipv4/syncookies.c |  4 ++++
 net/ipv4/tcp_input.c  |  3 +++
 net/ipv6/syncookies.c |  3 +++
 net/mptcp/protocol.c  | 54 ++++++++++++++++++++++++++++++++----------------------
 net/mptcp/subflow.c   |  5 ++++-
 6 files changed, 46 insertions(+), 25 deletions(-)



