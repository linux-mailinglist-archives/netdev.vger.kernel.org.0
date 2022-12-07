Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF76464ED
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLGXRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLGXRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:17:46 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B6F2720
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670455065; x=1701991065;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wks1MctEb+jqMbd5wfzAYbC+D1RpAd5A/dfT8NrKv80=;
  b=JzdAeDGyau3iY7Kaqhvo46xXN5NGsDEL2390P4xPobhyLKAKT7/56zLP
   6743hiCQ19gq/InUwXlhW4fiDcehKIR4b6qDCxd65PxrRRH/w+uFOk/5Y
   aOfz6m9oqadFaIB09f0NlyAOFdEZ9SCyWOGqJ89stx3hauzVIol0DD5Mg
   EKET5ITgshFlvYrdJCp+3f+hyLSD0RTKgY7ji1cUfnydJDA400ylfMvgY
   wmcpaLxC+d4shWZN7wJNr4CCGyECYPF24CaNB7B3XOCVaQyTmhJ7ezGbY
   /j8zU4PfajuaLsbffA2R/jw+7yZGwC4eIQLuHmNGmxP06D5FF6FNXsVQF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="403293965"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="403293965"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:17:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677539546"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677539546"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:17:41 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v1 0/2] ethtool: use bits.h defines
Date:   Wed,  7 Dec 2022 15:17:26 -0800
Message-Id: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
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

Change the ethtool files in the kernel, including uapi header files, to
use the kernel style BIT() and BIT_ULL() functions instead of
open-coding bit shift operations.

Making this change results in a more consistent presentation of bit-
shift operations as well as reduces the further likelihood of mistaken
(1 << 31) usage which omits the 1UL that is necessary to get an unsigned
result of the shift.

Jesse Brandeburg (2):
  ethtool/uapi: use BIT for bit-shifts
  ethtool: refactor bit-shifts

 include/linux/ethtool.h              |   2 +-
 include/uapi/linux/ethtool.h         | 112 ++++++++++++++++-----------
 include/uapi/linux/ethtool_netlink.h |   6 +-
 net/ethtool/bitset.c                 |  14 ++--
 net/ethtool/ioctl.c                  |   4 +-
 net/ethtool/strset.c                 |   6 +-
 6 files changed, 84 insertions(+), 60 deletions(-)


base-commit: 01d0e110f2365151d8e69ca4978128112637642d
-- 
2.31.1

