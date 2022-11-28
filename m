Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC2763B364
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbiK1UhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiK1UhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACFC2E9C3
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667823; x=1701203823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qvGEbQNEVi2QQZXMSo/YiGLVOkVye7E+5saqT1o9g2w=;
  b=iSn+JbgjafV9t9QSmT5aSIl3a1JTyNPN046izT80HkWMZaUJauUzOApC
   LomVGe1tZFRDJDY6g/QBGM3JcDH03xy/cR1vmQvvoYB74NnnqIjbt6ORz
   fBt2MW34rcWrO4oa+7TZMmWwae9qTJEAxcNm2G1vx2CNk7Fre4TxPNYse
   eBieREMswjQi4iDECW02VjX4b5FQ2QjMxsDXG3vc1OyvjdewnavM1F7ej
   rsc4eLUWWNe555g1A4i8KnYUKUlyT0GI5M3OJaLEhMhJUZpXVW9gEWYTo
   WO293vONJTui2hjhzJumIJ1R708xpP48fOyFM40vdEvqomPJajgs/FV1I
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205400"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205400"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286363"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286363"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 8/9] ice: document 'shadow-ram' devlink region
Date:   Mon, 28 Nov 2022 12:36:46 -0800
Message-Id: <20221128203647.1198669-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
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

78ad87da9978 ("ice: devlink: add shadow-ram region to snapshot Shadow RAM")
added support for the 'shadow-ram' devlink region, but did not document it
in the ice devlink documentation. Fix this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
No changes since v2.

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

