Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90776487CF6
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiAGTZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:25:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:42367 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbiAGTZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 14:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641583553; x=1673119553;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C0th8gsROJI3GvC5mmzJikWkPE41uBmnF18Hw9VeCXc=;
  b=XyHsFfR/oQul2dkbIA828KCxFrRgPswrEvVt3Xjkk2N6p2GYxB6ARpBX
   j+trnea/n35IMeM353Pq3biXKKX4CT9MTg8PmB8o+jzNw0UEeouQ5H6Bl
   4S/ggwV4lIvbpHwqX/tAW0O7hnUfkf+j6qZe3d2eOH9H0yu/pMyWOGcK1
   +5UBIMNmX8Px9p193pEIRbQDr/abUxIKQOqx7A36Q5E7Sq9yjc4tUePMd
   XXOlWCGY33xJlH463kJdZkFkpKrDKz7lLPrCAGz94ZOJRmB2Pr7O12A5p
   fB1JCDZmbhWoBi4+ICgt8dNKn8UgKJvPYitge2h+bj7ldbyG6TcxO+mdR
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="241742145"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="241742145"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:25:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="527478584"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:25:53 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/3] mptcp: Refactoring for one selftest and csum validation
Date:   Fri,  7 Jan 2022 11:25:21 -0800
Message-Id: <20220107192524.445137-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few more patches from the MPTCP tree for 5.17, with some refactoring
changes.

Patch 1 changes the MPTCP join self tests to depend more on events
rather than delays, so the script runs faster and has more consistent
results.

Patches 2 and 3 get rid of some duplicate code in MPTCP's checksum
validation by modifying and leveraging an existing helper function.


Geliang Tang (2):
  mptcp: change the parameter of __mptcp_make_csum
  mptcp: reuse __mptcp_make_csum in validate_data_csum

Paolo Abeni (1):
  selftests: mptcp: more stable join tests-cases

 net/mptcp/options.c                           |   8 +-
 net/mptcp/protocol.h                          |   1 +
 net/mptcp/subflow.c                           |  15 +--
 .../testing/selftests/net/mptcp/mptcp_join.sh | 120 ++++++++++--------
 4 files changed, 79 insertions(+), 65 deletions(-)


base-commit: c25af830ab2608ef1dd5e4dada702ce1437ea8e7
-- 
2.34.1

