Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840D867428B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjASTQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjASTQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:16:27 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E1966D9;
        Thu, 19 Jan 2023 11:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674155719; x=1705691719;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1HuuDaAUhECpauFK3xburRU6vWUT+DOtnKE7jETeHAQ=;
  b=ZV6t7T8MlkwDjgteF7KLqFnNXOAgWnwoWKr0Axhu1OerFC3VSkljc2Q8
   pfYs0DrZdrlTLN+mCu6i4bVNkiVm5QFZ9jqiL6Wd2JaQLyEYowgs1Sp1j
   IZKfKmjiOVDidExiCB18WfN4aRcp1BtAFEKIz9JwfyZANzxmDzCS+4HFc
   jeaUS2BPxsEfoADWUPmZxKY/AUKZ08uUBx+osnzqBcamVrHcuq5j8qC95
   i4/AF0YQreQRl/uY9FipU+Yqqu1M5QpOKV3pSAXJnTQ7qbd7o2seiXrBb
   4XBmNt1YQ2nF/tEWm7fCQUaPSTPmlcc/t6vWdSTVUL1RwURIsMDhK9eId
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="324078044"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="324078044"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 11:10:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="802752086"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="802752086"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jan 2023 11:10:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 49936368; Thu, 19 Jan 2023 21:11:03 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v2 1/2] ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_dsm() stubs
Date:   Thu, 19 Jan 2023 21:11:00 +0200
Message-Id: <20230119191101.80131-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ACPI part of a driver is optional the methods used in it
are expected to be available even if CONFIG_ACPI=n. This is not
the case for _DSM related methods. Add stubs for
acpi_evaluate_dsm_typed() and acpi_check_dsm() methods.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: new patch to prevent compilation failures (LKP)
 include/linux/acpi.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 5e6a876e17ba..4b12dad5a8a4 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -950,6 +950,12 @@ static inline bool acpi_driver_match_device(struct device *dev,
 	return false;
 }
 
+static inline bool acpi_check_dsm(acpi_handle handle, const guid_t *guid,
+				  u64 rev, u64 funcs)
+{
+	return false;
+}
+
 static inline union acpi_object *acpi_evaluate_dsm(acpi_handle handle,
 						   const guid_t *guid,
 						   u64 rev, u64 func,
@@ -958,6 +964,15 @@ static inline union acpi_object *acpi_evaluate_dsm(acpi_handle handle,
 	return NULL;
 }
 
+static inline union acpi_object *acpi_evaluate_dsm_typed(acpi_handle handle,
+							 const guid_t *guid,
+							 u64 rev, u64 func,
+							 union acpi_object *argv4,
+							 acpi_object_type type)
+{
+	return NULL;
+}
+
 static inline int acpi_device_uevent_modalias(struct device *dev,
 				struct kobj_uevent_env *env)
 {
-- 
2.39.0

