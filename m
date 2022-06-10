Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15279546B6A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349417AbiFJREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349740AbiFJREA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:04:00 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A13C36309;
        Fri, 10 Jun 2022 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654880639; x=1686416639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2DHPKG6LELctv9GPHh5MdlgXeZF+xfpjUKtxgbPNOI=;
  b=LKtZEpJ64QCoZdbWCorC8DNOkxW+txUFjSqj4BtIeNw1iQK2Z0ni5iMV
   iJRSGHpI0qz6JdL3BiVItmBqRhFMVACUywALzvCnAPXhxOCbUHGkXpspi
   tKgQtC/STMryWigsvqHuYUWgZXpDsnqml4tg7TaRGsJXf/bkCO6sQAhRV
   uNx0cCGUC1KDn9gyARA72fvuTWOOr5xqVKrCltVcCmkE/xlpKhXd3l/+N
   Fi8273be3OguiE3tlaTCQBwTTLH9hXKfmmTD/qUEH87nd9IuG8+5QwtQ7
   QkSHCDt+O7vFbvdmfyYXS6U0Jv1sSTEvxwA0fgetC/Ot/cxsHruosMNkW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="266452769"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="266452769"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:03:58 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638218765"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:03:57 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH v2 2/6] net/ncsi: Rename NCSI_CAP_VLAN_NO to NCSI_CAP_VLAN_FILTERED
Date:   Sat, 11 Jun 2022 00:59:36 +0800
Message-Id: <20220610165940.2326777-3-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NCSI_CAP_VLAN_NO actually stands for the "VLAN + non-VLAN" mode
defined in NCSI spec, which accepts both VLAN-tagged packets that match
the enabled VLAN filter settings and non-VLAN-tagged packets. It would
be more clear to rename it to NCSI_CAP_VLAN_FILTERED.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 net/ncsi/internal.h    | 2 +-
 net/ncsi/ncsi-manage.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index bc4a00e41695..7f384f841019 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -46,7 +46,7 @@ enum {
 	NCSI_CAP_AEN_HDS                 = 0x04, /* HNC driver status        */
 	NCSI_CAP_AEN_MASK                = 0x07,
 	NCSI_CAP_VLAN_ONLY               = 0x01, /* Filter VLAN packet only  */
-	NCSI_CAP_VLAN_NO                 = 0x02, /* Filter VLAN and non-VLAN */
+	NCSI_CAP_VLAN_FILTERED           = 0x02, /* Filter VLAN and non-VLAN */
 	NCSI_CAP_VLAN_ANY                = 0x03, /* Filter Any-and-non-VLAN  */
 	NCSI_CAP_VLAN_MASK               = 0x07
 };
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 78814417d753..a8f7a2ff52a0 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1098,7 +1098,7 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 				nca.type = NCSI_PKT_CMD_DV;
 			} else {
 				nca.type = NCSI_PKT_CMD_EV;
-				nca.bytes[3] = NCSI_CAP_VLAN_NO;
+				nca.bytes[3] = NCSI_CAP_VLAN_FILTERED;
 			}
 			nd->state = ncsi_dev_state_config_sma;
 		} else if (nd->state == ncsi_dev_state_config_sma) {
-- 
2.34.1

