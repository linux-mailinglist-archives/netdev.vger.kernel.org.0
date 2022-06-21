Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A62553EB4
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354197AbiFUWu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiFUWu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:50:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25771EED5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 15:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655851857; x=1687387857;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MvvQOgHlO+rNXY4kpO8077ud4jLa/GFdSCKJdYH2zxY=;
  b=iHhTHR/BogruEkhb+M1HwoSa6k48GMJFlWgrfKpigbWkKIMe+0gmCQC+
   xuvpGnj9hsC28PxiTrAluxksZea2poJjMV/dYd6ca0DfqaWpZTcF45vFM
   VX0eKOEsc2f6Jx32xAWQxh0jmpysKErmFqArY7zjbmLQuB81RqLrks1LB
   oV0H5hBjC4FWlzGYXlcVT37ybEeqUeUQZgrC4XloYCjawBdMqBYkaaBk/
   DkGy1feHLU8Vwd45m5p63rdLYuoYdY9KWColQQKUJerooKVMP5FwvUztB
   dCleex7MzcDNXhAiSH17TX0iSLc0kBR3d3IDouCg0/J8HJQ1aMh6cfivK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="277806454"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="277806454"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:50:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="655359198"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jun 2022 15:50:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-06-21
Date:   Tue, 21 Jun 2022 15:47:52 -0700
Message-Id: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Marcin fixes GTP filters by allowing ignoring of the inner ethertype field.

Wojciech adds VSI handle tracking in order to properly distinguish similar
filters for removal.

Anatolii removes ability to set 1000baseT and 1000baseX fields
concurrently which caused link issues. He also disallows setting
channels to less than the number of Traffic Classes which would cause
NULL pointer dereference.

The following are changes since commit 69135c572d1f84261a6de2a1268513a7e71753e2:
  net/tls: fix tls_sk_proto_close executed repeatedly
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anatolii Gerasymenko (2):
  ice: ethtool: advertise 1000M speeds properly
  ice: ethtool: Prohibit improper channel config for DCB

Marcin Szycik (1):
  ice: ignore protocol field in GTP offload

Wojciech Drewek (1):
  ice: Fix switchdev rules book keeping

 drivers/net/ethernet/intel/ice/ice_ethtool.c | 49 +++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c     | 42 +++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.c  |  5 +-
 3 files changed, 89 insertions(+), 7 deletions(-)

-- 
2.35.1

