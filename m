Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9775AB7D3
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiIBR5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIBR5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:57:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7E1AB07E
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 10:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662141433; x=1693677433;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dJHIHFHZdDsSr+Q+FFq1pGW+vpvHFp22xdbZbVE3cK8=;
  b=VjpTy22DX28nbQBIL2qkVKZoL38wt7TKrIyOLDRtb5cV5Rv/0m6ElLzO
   vN22N5YCcDlDSUZ2G/PF8RWEXURhUEcueOnS72H0GtscmA8OGIgOTdVfb
   uS8oNqPv9OP8oJESAA0WDtxuXiWDLdtnsfO2yL6hYGgXufa6M56jvV34H
   bEiZLGew5Ln6j2Kruvg+7vS4VX6V+nOjrHTASu9aGgd4Agf8e3Zw0DZZm
   wtW2SNtNnMbI5JoTQeWRQt5c+mb397MN3eAPyn5I/EHXKeTdS1dsyr9wD
   NLYE7dw+UnJBAVg+kKvW9VrZkn7JM0FMkIuoZaJHq2c15E1iP4JZQeDks
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="296046885"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="296046885"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 10:57:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="590156237"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 10:57:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates 2022-09-02 (ice)
Date:   Fri,  2 Sep 2022 10:57:01 -0700
Message-Id: <20220902175703.1171660-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Przemyslaw fixes memory leak of DMA memory due to incorrect freeing of
rx_buf.

Michal S corrects incorrect call to free memory.
---
v2: Removed patch 3

The following are changes since commit e7506d344bf180096a86ec393515861fb5245915:
  Merge tag 'rxrpc-fixes-20220901' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Michal Swiatkowski (1):
  ice: use bitmap_free instead of devm_kfree

Przemyslaw Patynowski (1):
  ice: Fix DMA mappings leak

 drivers/net/ethernet/intel/ice/ice_base.c | 17 ------
 drivers/net/ethernet/intel/ice/ice_main.c | 10 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 63 +++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.h  |  8 +++
 4 files changed, 80 insertions(+), 18 deletions(-)

-- 
2.35.1

