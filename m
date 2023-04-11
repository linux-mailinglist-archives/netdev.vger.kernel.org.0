Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC906DD651
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjDKJLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDKJK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:10:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D7126A1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681204249; x=1712740249;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7aH48hhTcqsbru85jjXdrPODWNjlZPhKDzyLdvEyfFU=;
  b=d5hEoY1HYS1R663jfoohFuLLqBl3kPvzGiNdWTqhb7Kl+AsmyGpYEC7M
   RO9jZpnz4ihQ6JwzbKKHgA42EdyJVUpQnoOUFgV3dOjRVUFEFyxO05t9+
   5g9A+f/0p6GOOQpV+2UBeYbAGJ9uVK//XyuL1W1uE+WT1rDG9t2GtNRXk
   Uq8j6g2D0au3aBOGoX4k5Hib9i3tkK8QT9MjaIHu9IqUvvg+v1pCzByT4
   OVtuJCZar0frc9/BV+8BxwRXL6fdfNncloiMECBCKI6nWKz+LHdo+b16v
   6rZLXkPXin1+OY4kLOOVuCdXWI/JCxKSTR5Y3RGccPeibFXSBzbVAa5dH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="343568207"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="343568207"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 02:10:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="753066930"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753066930"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 02:10:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 3BB56438; Tue, 11 Apr 2023 12:10:49 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 0/3] net: thunderbolt: Fix for sparse warnings and typos
Date:   Tue, 11 Apr 2023 12:10:46 +0300
Message-Id: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This series tries to fix the rest of the sparse warnings generated
against the driver. While there fix the two typos in comments as well.

The previous version of the series can be found here:

  https://lore.kernel.org/netdev/20230404053636.51597-1-mika.westerberg@linux.intel.com/

Changes from the previous version:

  * Split the sparse fix into two patches
  * Fixed the other typo
  * Added tags from Simon and Andy.

Mika Westerberg (3):
  net: thunderbolt: Fix sparse warnings in tbnet_check_frame() and tbnet_poll()
  net: thunderbolt: Fix sparse warnings in tbnet_xmit_csum_and_map()
  net: thunderbolt: Fix typos in comments

 drivers/net/thunderbolt/main.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

-- 
2.39.2

