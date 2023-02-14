Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41398696FBC
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjBNVb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjBNVb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:31:56 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3B305DA
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676410298; x=1707946298;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TBbNkjzSwy/nSp2PNP9gNlCrM35Soqxeq1TfOFLNgSk=;
  b=iA1Dbvy06/ftHAOCnQ1a+thC8L7X6UAV+OUvrrL6RPfupLK5BEluz59H
   Ijf+LHKJeiOelELIYUfLqO3xDet53edNmNwSZo76+APnKsOho+HzAdUV6
   SspicsLgcEfrhq+UY7mErFhWWYsgsIMyhPwT2grFn+ziXnf6r97fo9aIh
   go05pvYdDuMNjwUm90Ukgw6mLrBwceVBiDNcgYi3l5kFSgBs1Yh9MJp/c
   TKFR3HuWAWMGxXVoTlGUSaS7mTQ05HRVUGZQ0FmFNt6GTP9eEQQ7IkT51
   WMO+w23TIlEZfqrMuIAWJmwQdbc3b61oB5jpdiGQPzEamksx/9nVZoUbj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331274562"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="331274562"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:30:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733025254"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="733025254"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 13:30:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates 2023-02-14 (ice)
Date:   Tue, 14 Feb 2023 13:29:58 -0800
Message-Id: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Karol extends support for GPIO pins to E823 devices.

Daniel Vacek stops processing of PTP packets when link is down.

Pawel adds support for BIG TCP for IPv6.

Tony changes return type of ice_vsi_realloc_stat_arrays() as it always
returns success.

Zhu Yanjun updates kdoc stating supported TLVs.

The following are changes since commit 2edd92570441dd33246210042dc167319a5cf7e3:
  devlink: don't allow to change net namespace for FW_ACTIVATE reload action
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Daniel Vacek (1):
  ice/ptp: fix the PTP worker retrying indefinitely if the link went
    down

Karol Kolacinski (1):
  ice: Add GPIO pin support for E823 products

Pawel Chmielewski (1):
  ice: add support BIG TCP on IPv6

Tony Nguyen (1):
  ice: Change ice_vsi_realloc_stat_arrays() to void

Zhu Yanjun (1):
  ice: Mention CEE DCBX in code comment

 drivers/net/ethernet/intel/ice/ice.h        |  2 +
 drivers/net/ethernet/intel/ice/ice_common.c | 25 +++++++
 drivers/net/ethernet/intel/ice/ice_common.h |  1 +
 drivers/net/ethernet/intel/ice/ice_dcb.c    |  4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c    | 11 ++--
 drivers/net/ethernet/intel/ice/ice_main.c   |  2 +
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 72 ++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c   |  3 +
 8 files changed, 109 insertions(+), 11 deletions(-)

-- 
2.38.1

