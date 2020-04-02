Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3E319C05A
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbgDBLpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:45:02 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44658 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDBLpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:45:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jJyHM-0002iU-Pr; Thu, 02 Apr 2020 13:45:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Subject: [PATCH net 0/4] mptcp: various bugfixes and improvements
Date:   Thu,  2 Apr 2020 13:44:50 +0200
Message-Id: <20200402114454.8533-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains the following mptcp bug fixes:

1. Fix crash on tcp fallback when userspace doesn't provide a 'struct
   sockaddr' to accept().
2. Close mptcp socket only when all subflows have closed, not just the first.
3. avoid stream data corruption when we'd receive identical mapping at the
    exact same time on multiple subflows.
4. Fix "fn parameter not described" kerneldoc warnings.

Florian Westphal (3):
      mptcp: fix tcp fallback crash
      mptcp: subflow: check parent mptcp socket on subflow state change
      mptcp: re-check dsn before reading from subflow

Matthieu Baerts (1):
      mptcp: fix "fn parameter not described" warnings

 net/mptcp/protocol.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h |   2 +
 net/mptcp/subflow.c  |   3 +-
 net/mptcp/token.c    |   9 +++--
 4 files changed, 113 insertions(+), 10 deletions(-)

