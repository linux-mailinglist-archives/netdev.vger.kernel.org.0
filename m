Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD27624E64
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKJXXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKJXXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:23:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F4F12D18
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668122609; x=1699658609;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DXf5eMO6iRwbWYmQJIa81skpLlE5bGQYMONe31ftIqw=;
  b=WeuI9xmcO6ICsUJOG2r0IWF+C12piONXAepIPUHVcUCJwVEeKjVQC/Ko
   bePgVzm4blLd5b8HJMwhAF2XFAw7NWh7VJpt6wZnkLb1tqoJWmEAEBLNF
   q5xvPByXv1nVMXkfcXPXFVeXCqeIKLIV2eKIrmT11hCIpDJcha7nt1EAx
   ZDiYzqKqXqIZBrDdLoGEwSVNJAuvhOkEjb2UmTd5BRsg0QPVizHOoIZn0
   1K3nnMjdD5IGmtSLuW0fHRI3hwKG7DglUex9UMdlAYzt2rJbTblclcA/7
   awLeYjfKJbV5IzyrVzMYpDZhEPOFC4ZddrD2WakCohD3oJx1xWfEaybee
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309093981"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="309093981"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="637367368"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="637367368"
Received: from jsandova-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.89])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/5] mptcp: Miscellaneous refactoring and small fixes
Date:   Thu, 10 Nov 2022 15:23:17 -0800
Message-Id: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1-3 do some refactoring to more consistently handle sock casts,
and to remove some duplicate code. No functional changes.

Patch 4 corrects a variable name in a self test, but does not change
functionality since the same value gets used due to bash's 
scoping rules.

Patch 5 rewords a comment.

Geliang Tang (4):
  mptcp: use msk instead of mptcp_sk
  mptcp: change 'first' as a parameter
  mptcp: get sk from msk directly
  selftests: mptcp: use max_time instead of time

Mat Martineau (1):
  mptcp: Fix grammar in a comment

 net/mptcp/pm_userspace.c                      |  4 +--
 net/mptcp/protocol.c                          | 34 +++++++------------
 net/mptcp/sockopt.c                           |  4 +--
 net/mptcp/token.c                             |  4 +--
 .../selftests/net/mptcp/simult_flows.sh       |  4 +--
 5 files changed, 21 insertions(+), 29 deletions(-)


base-commit: c1b05105573b2cd5845921eb0d2caa26e2144a34
-- 
2.38.1

