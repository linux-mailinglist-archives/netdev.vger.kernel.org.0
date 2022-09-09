Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8D5B3D2D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiIIQj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiIIQjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:39:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80EB23BC9
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 09:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662741581; x=1694277581;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rFuvhz281biWdRa+kAAUKegAr+N+qSS+yz0/+RrsNKQ=;
  b=XpvgvbTegeFIFBKq9zbIC4QUC0M+xUhwaB7lsxD7+w6MdxeFsi5moCtw
   j25xAJNFcwrWw6pjopURrS8s7x9Iw+ba1wx5CYfzPb+RiAJVlOdAZzGYj
   kqfz+cKoAXdkZ+Vy6kcrLKfqModP/ah+wWeZqCkV9EQsAawGrn11pd7JD
   9J1L2Gn+niqojwFI4AQveVo9DFFbeiLgjl8GJYhv4RWPAZchIXFJe6oNt
   WykTC5p+l5dijs26/lraypnda70qB95Tvm0CCB/UEwldZKIokpfzMoWSv
   FxAOMfLPSGP4ewcLO6qeCYEo50FavXyf4ZV6FPFrxkRZlLfd6Y4TMpZyC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10465"; a="323731547"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="323731547"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 09:39:41 -0700
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="677233661"
Received: from sreehari-nuc.iind.intel.com ([10.223.163.48])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 09:39:36 -0700
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
Subject: [PATCH net-next 1/2] net: wwan: t7xx: Use needed_headroom instead of hard_header_len
Date:   Fri,  9 Sep 2022 22:04:59 +0530
Message-Id: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index c6b6547f2c6f..f5dbcce97e8f 100644
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

