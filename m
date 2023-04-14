Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744476E2849
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDNQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDNQ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:27:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C219426A6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681489615; x=1713025615;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=caFSAfS+M+T/D93W6sVmtsts5WF3L0vQ1+3PJS/BNZc=;
  b=hiBOnyEjk6LsG08Aa95TvYMroEI3SWcWje/lyJRGFQ43zlyooEJUck7H
   j8NkRoYmRBMVTXYiAZErjNGnPhQzgVWtTzAtVYw6Nk+0y6bye2QnQANB9
   b2ziKhizoAAEKEgsGQrJhgZrqD98LETv/wuTFj5zAzENfuh+gf5ZDkSJU
   d9E+S2b6TFBheNkzvyHuTVxAQH4xUInOBU/s6VKD4M+Swf+6sxUWFSd08
   p4qRtjx0GXSPgH9AeeILfWoueaTnTkt9xY7193LqUUKXYnTT7x5lSfI8M
   cYVv/CvHosstjD1yvVREUeJ2UVjGr27dN6HsIG6jP+69o1MNX5yjmDM33
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="409705419"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="409705419"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 09:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="864258645"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="864258645"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.1])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 09:26:20 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH] ice: document RDMA devlink parameters
Date:   Fri, 14 Apr 2023 09:26:14 -0700
Message-Id: <20230414162614.571861-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.40.0.131.gc918699d9952
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce
devlink param") added support for the enable_roce and enable_iwarp
parameters in the ice driver. It didn't document these parameters in the
ice devlink documentation file. Add this documentation, including a note
about the mutual exclusion between the two modes.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 10f282c2117c..0e39a0caba55 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -7,6 +7,21 @@ ice devlink support
 This document describes the devlink features implemented by the ``ice``
 device driver.
 
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+     - Notes
+   * - ``enable_roce``
+     - runtime
+     - mutually exclusive with ``enable_iwarp``
+   * - ``enable_iwarp``
+     - runtime
+     - mutually exclusive with ``enable_roce``
+
 Info versions
 =============
 
-- 
2.40.0.131.gc918699d9952

