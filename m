Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DAC4C3A8A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 01:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiBYAxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 19:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiBYAxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 19:53:36 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817706211C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 16:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645750385; x=1677286385;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Omi3XQHIC7kCcULuYJcgiYxsXqqdpxDfRMdsvBKd/jM=;
  b=N1NFRMddUyfiwW2Ulv1EVYv6MEKDatQ06yMoLG3QuLOvnCviY9ZFqK40
   444Q83xiuEsajpAZKEZEJwmctLF6zUyXp2TtbUFXDWZmD2sFrCZK4enXq
   RK5wpDQswA0bSZdE2InU0xYrj+2SEhDdtR2zih6Cx1xRHK0a4vKjlDPgO
   kgBzzn/mufDiNT+f3RvrqEuDwNvvOjrrUJKu84rlHJ/vOprZtuK4GtSbP
   LxfAhit0gJWo+H34zcgaTmnOUd3FaeazpIgZI20CEEi0ynDAre+jp0cBb
   sOWpOqZSCi2vrnZMo+ESEhiXqUDiHg3dlj99DkbsWK8U/reSuNZA8n2DU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="313105741"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="313105741"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 16:53:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="638050197"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.28.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 16:53:04 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/3] mptcp: Fixes for 5.17
Date:   Thu, 24 Feb 2022 16:52:56 -0800
Message-Id: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes an issue with the SIOCOUTQ ioctl in MPTCP sockets that
have performed a fallback to TCP.

Patch 2 is a selftest fix to correctly remove temp files.

Patch 3 fixes a shift-out-of-bounds issue found by syzkaller.

Mat Martineau (1):
  mptcp: Correctly set DATA_FIN timeout when number of retransmits is
    large

Paolo Abeni (2):
  mptcp: accurate SIOCOUTQ for fallback socket
  selftests: mptcp: do complete cleanup at exit

 net/mptcp/protocol.c                           | 18 ++++++++++++++++--
 .../selftests/net/mptcp/mptcp_connect.sh       |  4 ++--
 2 files changed, 18 insertions(+), 4 deletions(-)


base-commit: d8152cfe2f21d6930c680311b03b169899c8d2a0
-- 
2.35.1

