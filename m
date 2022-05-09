Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345AF5203BD
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbiEIRmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239745AbiEIRmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:42:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0A62171BE
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652117928; x=1683653928;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ov5l4/imIA/6edRk6qsYpiWvaK9inycSUw2vtyDpXU8=;
  b=IlN/Dhfodjljc4sQw6p7dUI1FOShjYDE54zqBzZ/ImgA4z6chZ4GNTSH
   Na0/iPmG37QoDo/4lbiI3dJ8pPCYLe17vDMZanSse6KfULmxGm3/Y/aZL
   ClMNf83euY54pB4wcJder4uMrZ/p7YjW76KDmcZj82S8RrldpQQd08TSG
   UkW1FVtuteLk1NCc+MQy3gZ8eYbfwjOvxrgA4HHt6dJv1TPDgNkPFYJzO
   7tljNjKnpdEGrPxjbuz84eMOH1d89qrB/e/Zt84kZENF/8beCqR7BMejL
   YjFfjN7ESeOsd89KSDHUktaWU9tP3z5mOrR5xx5JDy3OScUW7FLRTCuk3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249656239"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="249656239"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 10:38:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="519336721"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 09 May 2022 10:38:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver Updates 2022-05-09
Date:   Mon,  9 May 2022 10:35:45 -0700
Message-Id: <20220509173547.562461-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Mateusz adds implementation for setting VF VLAN pruning to allow user to
specify visibility of VLAN tagged traffic to VFs for i40e. He also adds
waiting for result from PF for setting MAC address in iavf.

The following are changes since commit 9c095bd0d4c451d31d0fd1131cc09d3b60de815d:
  Merge branch 'hns3-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Mateusz Palczewski (2):
  i40e: Add VF VLAN pruning
  iavf: Add waiting for response from PF in set mac

 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   9 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 135 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   8 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 123 +++++++++++++---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  61 +++++++-
 7 files changed, 317 insertions(+), 27 deletions(-)

-- 
2.35.1

