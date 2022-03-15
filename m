Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D814D9900
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347189AbiCOKoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiCOKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:44:14 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780E12AFA
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647340981; x=1678876981;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gr5T7PKLRxwVWHKL9KE7vvmgqJz6sogX8nBx6KfQpZw=;
  b=nnkLPuDfifZzd8Py77FGNEQBuOvRQKyv277P2p3Qe8578oUu9nYzSZM9
   t7Iq99y/2g6dwSykDPzdbb99ix128ndDYQdRlTInIymlDsZoEdcbJ+PCN
   NxTBpl2Vlz6I0ABRU8sO50v17BCI9NEsTTQ6WzTuAovaYiOdRfsR4ck0l
   qXTlEDM+BIWApPKWZvMALyZxyeCNjqfEV2WGM8qIn1p7/lUdxg1E5XSps
   m3qdOwBU2yo69DiAorFSSTczZW6f27qDr43LvDL2LOfMXUerwR57SL+6x
   AUVRFYbxhuKE5DKxgO4ma1W785RhyB5eWCZdCl8jNZ9LCOKbXOIUksSa/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="316988489"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="316988489"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 03:43:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="690151149"
Received: from unknown (HELO giewont.igk.intel.com) ([10.211.8.15])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 03:43:00 -0700
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next v4 0/2] GTP support for ip link and tc flowers
Date:   Tue, 15 Mar 2022 11:42:57 +0100
Message-Id: <20220315104259.578133-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces GTP support to iproute2. Since this patch
series it is possible to create net devices of GTP type. Then, those
devices can be used in tc in order to offload GTP packets. New field
in tc flower (gtp_opts) can be used to match on QFI and PDU type.

Kernel changes (merged):
https://lore.kernel.org/netdev/164708701228.11169.15700740251869229843.git-patchwork-notify@kernel.org/

---
v4: updated link to merged kernel changes

Wojciech Drewek (2):
  ip: GTP support in ip link
  f_flower: Implement gtp options support

 include/uapi/linux/if_link.h |   2 +
 include/uapi/linux/pkt_cls.h |  16 +++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 128 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 +++++++-
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 122 ++++++++++++++++++++++++++++++++-
 8 files changed, 306 insertions(+), 5 deletions(-)
 create mode 100644 ip/iplink_gtp.c

-- 
2.35.1

