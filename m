Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43C9519B40
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbiEDJR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346990AbiEDJRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:17:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809011F632;
        Wed,  4 May 2022 02:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651655654; x=1683191654;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S3giD1hTFEiEIjC/qRjbZxRKhMfT4rpRxJepzxGqmEw=;
  b=JP9R+Dw/qO5yHDEj7VH2WeZzc+ldh5A0FtG2ZNMvDviD8Qah0KkJ17tK
   cjEaa9pXtM5mjRE0SqFF8MmYl+GZ8vAxCztoUC+rFQo2LXKrNihNl+wQD
   sIiRX4YE3ITf7ZqbmODa2F7Tg2znU3+MgOCbmSyhJX6n9SJPRg3l5qNUQ
   IUHsGbrjmhZ8grLTJGoeIYQ/dMIlvxFEMR6BVbb8JPKwV5ScgU5d4n9bZ
   Hw5S22hj7q3X53vft+yhsyPYTGGm79FBV74j9jcYHh3p/Q08WPqkP2dx1
   Xlyw/jTaqHCCT3bOcccaUpSv/hE3I9eEw7mawGrXoeqN+o5GdGpMA2tJB
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267864357"
X-IronPort-AV: E=Sophos;i="5.91,197,1647327600"; 
   d="scan'208";a="267864357"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 02:14:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,197,1647327600"; 
   d="scan'208";a="631878595"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 04 May 2022 02:14:12 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3D7F41A5; Wed,  4 May 2022 12:14:12 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Allen Pais <apais@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 1/1] firmware: tee_bnxt: Use UUID API for exporting the UUID
Date:   Wed,  4 May 2022 12:14:07 +0300
Message-Id: <20220504091407.70661-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is export_uuid() function which exports uuid_t to the u8 array.
Use it instead of open coding variant.

This allows to hide the uuid_t internals.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v4: added tag (Christoph), resent with 126858db81a5 (in next) in mind (Florian)

 drivers/firmware/broadcom/tee_bnxt_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index a5bf4c3f6dc7..40e3183a3d11 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -197,7 +197,7 @@ static int tee_bnxt_fw_probe(struct device *dev)
 		return -ENODEV;
 
 	/* Open session with Bnxt load Trusted App */
-	memcpy(sess_arg.uuid, bnxt_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
+	export_uuid(sess_arg.uuid, &bnxt_device->id.uuid);
 	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
 	sess_arg.num_params = 0;
 
-- 
2.35.1

