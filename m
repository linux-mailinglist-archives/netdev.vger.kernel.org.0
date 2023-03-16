Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185056BCEE5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCPMEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCPMEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:04:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FD5C2DBE;
        Thu, 16 Mar 2023 05:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968241; x=1710504241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MLAfqvFhddqkH69T9q585Y5bPPYw4tpph5fqJvMuU1g=;
  b=EHGc+MdY/5EBMs3MyegGDURUK4RtnHw+2mRaCF5JR0iJeNQHgw3OljEr
   JHXuXA95Z6Gj3lDMmQqyLDoJZwBeztXOilDnk+yICveNKmk0PwqO97hUv
   FlOMnqNo8aYiHDgsdLGTOE5pBYVzgJ7wY1bQni+BqL576ORsbr4inlfzl
   5Xxp+aStX6kTTZexHT6Vpk9tAj5paeIfG+LL016STD0E96BC7brFDzMdc
   n60V8tcmuID3QiHhmIaMT03YtxubHs/4FvZ94UdlnCUfq6HosxI+jYfh3
   hT0q3J+oEV6LHoGFfh+TPpS0kb2orjd/LwCi3+YoZl964uQSsMwlowyVN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="365656124"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="365656124"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:03:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="768909617"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="768909617"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2023 05:03:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id CC3273DD; Thu, 16 Mar 2023 14:04:22 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Nicolas Pitre <nico@fluxnic.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v1 1/1] net: smc91x: Replace of_gpio.h with what indeed is used
Date:   Thu, 16 Mar 2023 14:04:19 +0200
Message-Id: <20230316120419.37835-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_gpio.h in this driver is solely used as a proxy to other headers.
This is incorrect usage of the of_gpio.h. Replace it .h with what
indeed is used in the code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 35e99bf0c401..032eccf8eb42 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -57,6 +57,7 @@ static const char version[] =
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/errno.h>
@@ -69,7 +70,6 @@ static const char version[] =
 #include <linux/workqueue.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-- 
2.39.2

