Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5280E47714D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhLPMFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbhLPMFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:05:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68316C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:05:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxpVc-0007nr-1c; Thu, 16 Dec 2021 13:05:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 0/2] fib: merge nl policies
Date:   Thu, 16 Dec 2021 13:05:05 +0100
Message-Id: <20211216120507.3299-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4: resend with fixed subject line.  I preserved review tags
    from David Ahern.
v3: drop first two patches, otherwise unchanged.

This series merges the different (largely identical) nla policies.

v2 also squashed the ->suppress() implementation, I've dropped this.
Problem is that it needs ugly ifdef'ry to avoid build breakage
with CONFIG_INET=n || IPV6=n.

Given that even microbenchmark doesn't show any noticeable improvement
when ->suppress is inlined (it uses INDIRECT_CALLABLE) i decided to toss
the patch instead of adding more ifdefs.

Florian Westphal (2):
  fib: rules: remove duplicated nla policies
  fib: expand fib_rule_policy

 include/net/fib_rules.h | 21 ---------------------
 net/core/fib_rules.c    | 25 +++++++++++++++++++++++--
 net/decnet/dn_rules.c   |  5 -----
 net/ipv4/fib_rules.c    |  6 ------
 net/ipv4/ipmr.c         |  5 -----
 net/ipv6/fib6_rules.c   |  5 -----
 net/ipv6/ip6mr.c        |  5 -----
 7 files changed, 23 insertions(+), 49 deletions(-)

-- 
2.32.0

