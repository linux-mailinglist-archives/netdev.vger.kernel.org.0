Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A21636B58
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbiKWUjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbiKWUip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:38:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEC9767F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669235924; x=1700771924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8dEXTLUkqZgGzLwqYW+vRYIDPD/cXXINDhgjTaC78NA=;
  b=WVPiqtLPHIhgdpJquLtwT985iQroow+U9sdl4xn02rW9LMMc9NX9jHZo
   UFfj4APpvmIlCLKva75oQrf0GhazM3zFVNM7b332g4jRx7qil1dzADQmD
   5v25F7AMQD6TAH3uyeNmma7PwiUGJ9QwQTVHla0EqMXD5xysk5L7pn/2r
   dPlUHGYQiYYiIM2qC5DNYCXdlK2VYWAMaArC1A1s5nSRviqRX3cOOOvXJ
   OZyrWeRg+nk5YxnfPChma5Oqls2e1fx+jDIBmuhBUQBIPDzrqc+cq6r/Q
   vZhAkHLkXYPRtFtD7Y3gt+XXw7b8q7obUNKrG/rfIM0YDRcczqsugIZbD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315307137"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315307137"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619756065"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619756065"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 8/9] ice: document 'shadow-ram' devlink region
Date:   Wed, 23 Nov 2022 12:38:33 -0800
Message-Id: <20221123203834.738606-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221123203834.738606-1-jacob.e.keller@intel.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

78ad87da9978 ("ice: devlink: add shadow-ram region to snapshot Shadow RAM")
added support for the 'shadow-ram' devlink region, but did not document it
in the ice devlink documentation. Fix this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
New patch, not in v1.

 Documentation/networking/devlink/ice.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 890062da7820..bcd4839fbf79 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -189,6 +189,11 @@ device data.
     * - ``nvm-flash``
       - The contents of the entire flash chip, sometimes referred to as
         the device's Non Volatile Memory.
+    * - ``shadow-ram``
+      - The contents of the Shadow RAM, which is loaded from the beginning
+        of the flash. Although the contents are primarily from the flash,
+        this area also contains data generated during device boot which is
+        not stored in flash.
     * - ``device-caps``
       - The contents of the device firmware's capabilities buffer. Useful to
         determine the current state and configuration of the device.
-- 
2.38.1.420.g319605f8f00e

