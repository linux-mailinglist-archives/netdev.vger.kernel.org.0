Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5976D52583D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359451AbiELX04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359450AbiELX0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:26:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C122FFDF
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652398009; x=1683934009;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GNV+LO1ybpOWHmQ4r6igGS0ARXXbp9yywJBUY7nXGHI=;
  b=VLo+MBZxOXyrehUJlV7XZO+7m2C1iGqGlptuV+DXoMoYgC5IuN1V2QcI
   5dJOqCN2mTx6/hqP0j4rU2Of3dmQcc85QfgmcMAQJtKJKv4Kxn28sDPzE
   h39WzHa0Uz+sdMlBMbqoBw02hgLEcT0mJhC/Hg0uD48ZYw8hevTHdMaGC
   3TrnpDxSAB41rFJruDIb+r22/yDfEPWCE0IiPRRYmvqkdhxV5TvAA/7m0
   n0xozz3c8dSfFN5XJJfSRdyM84j4VJFoUFKEHztg35WVLoyLfCpz8kNa+
   prbQBY6bphjeVLdjUj+7BjdK+4snF6H19hcTo9uSfWYREe1V78KcdaZJi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270097022"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270097022"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 16:26:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="739919553"
Received: from cmokhtar-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.250])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 16:26:47 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/2] mptcp: Subflow accounting fix
Date:   Thu, 12 May 2022 16:26:40 -0700
Message-Id: <20220512232642.541301-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a bug fix affecting the in-kernel path manager
(patch 1), where closing subflows would sometimes not adjust the PM's
count of active subflows. Patch 2 updates the selftests to exercise the
new code.

Paolo Abeni (2):
  mptcp: fix subflow accounting on close
  selftests: mptcp: add subflow limits test-cases

 net/mptcp/pm.c                                |  5 +-
 net/mptcp/protocol.h                          | 14 ++++++
 net/mptcp/subflow.c                           | 12 +++--
 .../testing/selftests/net/mptcp/mptcp_join.sh | 48 ++++++++++++++++++-
 4 files changed, 71 insertions(+), 8 deletions(-)


base-commit: f3f19f939c11925dadd3f4776f99f8c278a7017b
-- 
2.36.1

