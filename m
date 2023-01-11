Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E373966548C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjAKG0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbjAKG0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:26:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6E910A3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673418365; x=1704954365;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HCPL1xFUUapl3UIEgBjSPx32Mc365rZge0zCFYFHsWY=;
  b=M7JxHTi2h1Ag6TsbgMKob/3/ivYobM3WnfaerD1lOPplRjPi8fTMIRft
   Vyp4jGAa19PboyRG8tYVqU2G6CIb69YuIgM2j7uzqoPydpVxCNzydRWw/
   soO0NQo4cmgyIKLkQXU6Ols7yRzrdnQ79Ycf4R+BNQF4YN31Mf7TI5enU
   mPadFlfxXAJyEh+reJh7XK/aJyLRcnkb8LqfY8mlkyUg4xg3g6xdiofmI
   g234Lac8Y9yJfK+uw72TWuXGBAKej1c+Z4Cv50cQB6tkyAz3CDT85ZyG1
   Z8XfnYKJhR1CHTla+XUtt21i+CtASqqEVK32nv5MyKy2LN+881JmZZZkK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="306856849"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="306856849"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 22:26:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="607256941"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="607256941"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2023 22:25:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 69875E1; Wed, 11 Jan 2023 08:26:33 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 0/3] net: thunderbolt: Add tracepoints
Date:   Wed, 11 Jan 2023 08:26:30 +0200
Message-Id: <20230111062633.1385-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes from v1:

  * Fix sparse warnings added by this series (there are still some existing
    ones as well that should be dealt with at some point too).
  * Added ack from Yehezkel.
  * Update copyright to reflect 2023.

The previous version can be found:

  v1: https://lore.kernel.org/netdev/20230104081731.45928-1-mika.westerberg@linux.intel.com/

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
2.39.0

