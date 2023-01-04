Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A017365CE24
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjADIRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjADIRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:17:12 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B721A050
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 00:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672820228; x=1704356228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=haS6nAo+i7DzugcQFK9XkTZxgJ8bi4NCd7dI5MjN7DA=;
  b=RfycicUgPc8H1qcmLRBG+An/0iK61sT7oh+XQO+GbR/hN+wpw6NVtr+U
   z38PW46rodV3INnprOvEmXO9o8JZNB9FFy9SevD4k0Vkv0zwxFlJcMqdD
   o3GB43Qnii+rW3ExdU/rDxEw814XQE9TPr13QzOLNB4SNaWVAaNMUnvtZ
   lTLaI4B056uETzEo81UmraBTvsk4Y2Z2LaiZ2A2kHPJuqdD4S8Uz5aG2L
   2+VYLdTvDUsXRnwZ0E6s8YZR3oB107X1aK5VhJCb265M1rqZw7tQlZd2a
   rnXlGhBTSf4bK2dSUPkn03nqvRCX2zd7VU+vl2P7CfcgV/6KRTC9EJ/iu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="301561382"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="301561382"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 00:17:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="632726104"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="632726104"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 04 Jan 2023 00:16:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id AF32D162; Wed,  4 Jan 2023 10:17:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 0/3] net: thunderbolt: Add tracepoints
Date:   Wed,  4 Jan 2023 10:17:28 +0200
Message-Id: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This series adds tracepoints and additional logging to the
Thunderbolt/USB4 networking driver. These are useful when debugging
possible issues.

Before that we move the driver into its own directory under drivers/net
so that we can add additional files without trashing the network drivers
main directory, and update the MAINTAINERS accordingly.

Mika Westerberg (3):
  net: thunderbolt: Move into own directory
  net: thunderbolt: Add debugging when sending/receiving control packets
  net: thunderbolt: Add tracepoints

 MAINTAINERS                                   |   2 +-
 drivers/net/Kconfig                           |  13 +-
 drivers/net/Makefile                          |   4 +-
 drivers/net/thunderbolt/Kconfig               |  12 ++
 drivers/net/thunderbolt/Makefile              |   6 +
 .../net/{thunderbolt.c => thunderbolt/main.c} |  48 +++++-
 drivers/net/thunderbolt/trace.c               |  10 ++
 drivers/net/thunderbolt/trace.h               | 141 ++++++++++++++++++
 8 files changed, 219 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/thunderbolt/Kconfig
 create mode 100644 drivers/net/thunderbolt/Makefile
 rename drivers/net/{thunderbolt.c => thunderbolt/main.c} (96%)
 create mode 100644 drivers/net/thunderbolt/trace.c
 create mode 100644 drivers/net/thunderbolt/trace.h

-- 
2.35.1

