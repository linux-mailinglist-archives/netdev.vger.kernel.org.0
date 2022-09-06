Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FBA5AF6AA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiIFVNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiIFVNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:13:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45CAB8A4E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662498786; x=1694034786;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KdBmLyNtcsuPLYJ1LZ0M8KF6tV7h9mrfqebqUWc2tb8=;
  b=cbK89ZhBnKbNHATcidgOyYLywLJm5soiLr6Z9Tzxd0QhytMgsldTbtFf
   iJ4in3CzEUWFOrI6Px86DpeEAjUiPJyv8a9HeRSw1NybcmrWJDZLkd6pE
   ggzgnrAx5i7AglzhEFlmwyTSS1yM9Qv14cUVnhbxl3ieZ7M9+NtR647fC
   CEniYUnMfdNOu8HK+WWM1yYnJTKPCBXCmNrGdgj4+2Q3MWe28oGjj9mQV
   O48sXxq72TNs0X8ZbqRvxzFUqAtV6vDU6ga1gL+pNDoNktf4jjIWxe64n
   hlWHCKA3sM5o7Nz3VrX9oDLtQ+DeCG3S5eC1LfUAb/7DZo6Szg60oahdu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295441845"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295441845"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:13:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="591421355"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 14:13:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates 2022-09-06 (ice)
Date:   Tue,  6 Sep 2022 14:12:57 -0700
Message-Id: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Tony reduces device MSI-X request/usage when entire request can't be fulfilled.

Michal adds check for reset when waiting for PTP offsets.

Paul refactors firmware version checks to use a common helper.

Christophe Jaillet changes a couple of local memory allocation to not
use the devm variant.

The following are changes since commit 03fdb11da92fde0bdc0b6e9c1c642b7414d49e8d:
  net: moxa: fix endianness-related issues from 'sparse'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Christophe JAILLET (2):
  ice: switch: Simplify memory allocation
  ice: Simplify memory allocation in ice_sched_init_port()

Michal Michalik (1):
  ice: Check if reset in progress while waiting for offsets

Paul Greenwalt (1):
  ice: add helper function to check FW API version

Tony Nguyen (1):
  ice: Allow operation with reduced device MSI-X

 drivers/net/ethernet/intel/ice/ice_common.c |  57 +++---
 drivers/net/ethernet/intel/ice/ice_main.c   | 185 +++++++++++---------
 drivers/net/ethernet/intel/ice/ice_ptp.c    |   3 +
 drivers/net/ethernet/intel/ice/ice_sched.c  |   4 +-
 drivers/net/ethernet/intel/ice/ice_switch.c |   6 +-
 5 files changed, 136 insertions(+), 119 deletions(-)

-- 
2.35.1

