Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CFA60F745
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiJ0Mav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbiJ0Mal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:30:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA64DB65
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666873838; x=1698409838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aCj1syVk/jD+A4kLd9xm90pyuP5zqiQwqwtuX20+9OE=;
  b=RbT4jWidi/YrxZ2gnnQh0nJZ/lQRahM7OsThVKQ2Zu1tXYgWFXTmOD1W
   WQYqWgJ6fgDyK/KZIF7bDQ5ehFkvIl0cZT7JEFdWtWg1GJ/BdrT3zKyJ5
   CyepJWtDhNrxYFD+aPAYKeVVUzqjlJuFqYV6AZmRQ/QtUzPr9LZaztjAl
   lfxbgH3XcLnjcRSxtg1IffdLHtp88d+c+lQRzXE4eWm3D7N1iMPP0RVpH
   LWrtOvzvkX5KuVhjjuzmArtQyVsfbMUM3/99F97SYLpvg8C1bX04e8Tf9
   QBQSsWyFhIFxOgVdwgOTzR5GV/OdjMeqTlhL2QdmM45yB6xYRHoZLy5El
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="291511618"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="291511618"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:30:18 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="774974772"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="774974772"
Received: from sreehari-nuc.iind.intel.com ([10.223.163.48])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:30:13 -0700
From:   Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@linux.intel.com, sreehari.kancharla@intel.com
Subject: [PATCH net-next v2 1/2] net: wwan: t7xx: Use needed_headroom instead of hard_header_len
Date:   Thu, 27 Oct 2022 17:55:09 +0530
Message-Id: <20221027122510.24982-1-sreehari.kancharla@linux.intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

hard_header_len is used by gro_list_prepare() but on Rx, there
is no header so use needed_headroom instead.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index f71d3bc3b237..7639846fa3df 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -161,7 +161,7 @@ static void t7xx_ccmni_post_stop(struct t7xx_ccmni_ctrl *ctlb)
 
 static void t7xx_ccmni_wwan_setup(struct net_device *dev)
 {
-	dev->hard_header_len += sizeof(struct ccci_header);
+	dev->needed_headroom += sizeof(struct ccci_header);
 
 	dev->mtu = ETH_DATA_LEN;
 	dev->max_mtu = CCMNI_MTU_MAX;
-- 
2.17.1

