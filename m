Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C615AEBCB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241847AbiIFOWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241189AbiIFOUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:20:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95658B9B7;
        Tue,  6 Sep 2022 06:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472303; x=1694008303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NEeFuL7s2HGlJGPjMrfp/6jwPjBk7uYpbdHP2kx39AA=;
  b=l0O/GBBPWExKVhfi92Ne8zSZC+S1XAYQWKMrqTgXGJ4XPPpBkTjxkerE
   KCnB1oZJW+cfeKcukOty1f/uOo1TqXlMQZ5mLQnNaXhGSu3OTK/4YzRAn
   ufkFX52iqzZvEGMBFjg182MUtHz6HvkWz9/DuFT8L/KiyDHeIYIZqvsTH
   AXLlW+2VpxOB18VMz3+1G0gg2a9uwqD1dc9ngbd7fP3SQ6DmzmLsQPOBN
   WTkLeYPgLqE1plDhcjeil7QPS/qiYaOYP/tOXPmrapv6Ck2+zlWYRKI6m
   KZlVxovoLxrjtVtPDiCQxXbQ3pnWpg6KVnHsHTwWzyjEF6Bed9iHgcU0s
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="283591162"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="283591162"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:49:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="616712869"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 06 Sep 2022 06:49:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6404F363; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
Subject: [PATCH v3 02/11] leds: Move led_init_default_state_get() to the global header
Date:   Tue,  6 Sep 2022 16:49:55 +0300
Message-Id: <20220906135004.14885-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are users inside and outside LED framework that have implemented
a local copy of led_init_default_state_get(). In order to deduplicate
that, as the first step move the declaration from LED header to the
global one.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/leds/leds.h  | 1 -
 include/linux/leds.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index aa64757a4d89..345062ccabda 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -27,7 +27,6 @@ ssize_t led_trigger_read(struct file *filp, struct kobject *kobj,
 ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr, char *buf,
 			loff_t pos, size_t count);
-enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
 
 extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 499aea1e59b9..b96feacc73f8 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -67,6 +67,8 @@ struct led_init_data {
 	bool devname_mandatory;
 };
 
+enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
+
 struct led_hw_trigger_type {
 	int dummy;
 };
-- 
2.35.1

