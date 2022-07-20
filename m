Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAB557BDE5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiGTSfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiGTSe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:34:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F30671BD6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658342098; x=1689878098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bz91TNeeBfGTVdIdZvjlrnngeTyrZBksJ2a1iP5sz44=;
  b=b89Nyw4pXmxeGgagfdcYI0WOE3R6Kv+i46Jy6bOnHooVlFa94odmtFFo
   DbIFzqvHCV7pRT85mWusQIAvCtP3OpBkW8qNBuJRNCBHZAYePo+sjrGMU
   8VH9DTX8P0IIjLmjSTPhZKac15NXVQjPXUyqhm3JmGGCrLl4+bJM0T6yX
   vT69EjXaDP91vdu3/VowvALXhKbVcFbxv/q7B54cu9IyNdjNs+dFchU3Q
   waKG5luHYNk+s2qglk+RqaFo2is11KFxMr3LPlkQS4Re0cV0sILkrJdBW
   QVgsRuFGlHox1TAwVZ8uqt8PM2W+tFmfXB6uNhiWBua4fgdT0qIAOoMD/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="285620853"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="285620853"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="925337487"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:57 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next PATCH 1/3] update <linux/devlink.h> UAPI header
Date:   Wed, 20 Jul 2022 11:34:47 -0700
Message-Id: <20220720183449.2070222-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220720183449.2070222-1-jacob.e.keller@intel.com>
References: <20220720183449.2070222-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/uapi/linux/devlink.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index da0f1ba8f7a0..90f6cf97d308 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -576,6 +576,14 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	/* Before adding this attribute to a command, user space should check
+	 * the policy dump and verify the kernel recognizes the attribute.
+	 * Otherwise older kernels which do not recognize the attribute may
+	 * silently accept the unknown attribute while not actually performing
+	 * a dry run.
+	 */
+	DEVLINK_ATTR_DRY_RUN,			/* flag */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.36.1

