Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5252AD74
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiEQVWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiEQVWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:22:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611353EB93
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652822556; x=1684358556;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C8z2h7k7Vg8YpHk05GyzRFFDno0PhQMBS9KiRMnp3hw=;
  b=Bkqi454h1QE7cPfYsJ0S5JScONCFAwVto9162Ev/ZeYbew8h/i63pjFw
   BiNMunvN1XcoJTpLuyIxK7r7X9IT/MXvbj800IMok4aogSdBH21NikJu+
   3yNQnVeykmyGbNKjKNpEaQJUpTUZc24dUkTNI9ICBqQvdHX+qXs9Af+Yw
   rU8OakkW2StQLcT+0yeeFDKw1bmZIOCtAJ/MKblyx6GAjRZrlB+2WZi8Q
   9qmePU9Y51ZNp6Vawlj9dMBd0L8423y/+1ViI/GkZ9HQZcDwXcqM48OiY
   FYTDI/z0zhmzIWSYhApVANXDzK5xd7Jyx63OtyWs3uQIVj5Z5XERCI/SD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357749575"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357749575"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 14:22:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="605546001"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 17 May 2022 14:22:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver Updates 2022-05-17
Date:   Tue, 17 May 2022 14:19:32 -0700
Message-Id: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Karol changes calculation of u16 to unsigned int for GNSS related
calculations. He also adds implementation for GNSS write; data is
written to the GNSS module through TTY device using u-blox UBX protocol.

The following are changes since commit 65a9dedc11d615d8f104a48d38b4fa226967b4ed:
  net: phy: marvell: Add errata section 5.1 for Alaska PHY
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Karol Kolacinski (3):
  ice: remove u16 arithmetic in ice_gnss
  ice: add i2c write command
  ice: add write functionality for GNSS TTY

 drivers/net/ethernet/intel/ice/ice.h          |   4 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   7 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  51 +++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 252 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  26 +-
 6 files changed, 304 insertions(+), 40 deletions(-)

-- 
2.35.1

