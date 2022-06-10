Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F00546ACE
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349768AbiFJQrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349710AbiFJQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:47:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1508EAEE31;
        Fri, 10 Jun 2022 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879668; x=1686415668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2DHPKG6LELctv9GPHh5MdlgXeZF+xfpjUKtxgbPNOI=;
  b=kU2AOKfUv/2XiZ7EOY5GA5cGSO3mtQ/tbKrl1EsdZ2guwZzyP2H3PMxO
   kowQ3/z4C9ddhTi94cYOUi/t4yHyZtLuTW1/T6vMe6I5hH3cJCL+7p4gN
   hVc8KS97m/CCBtb63zTek2M39iEsvsoMCFjZ7/dpkFTCywtIMixYYNcTx
   443+CeeUTI/UJ9mSYRUZrtsJJR8sBGBXdxnfBm85ndLvTy81PiRKEVzce
   7AHQwqxK1/Qsu+8JKVArfRoUX5dyQ38pxdoum2Xlf5eE+GO5FAKqmzJiI
   e3GquxJ/1MTfcqp2WAuTwj7KN1rhBmADl5F0BNQb3kVtO9WckxL/ezhUC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275209613"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275209613"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638211031"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:46 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 2/6] net/ncsi: Rename NCSI_CAP_VLAN_NO to NCSI_CAP_VLAN_FILTERED
Date:   Sat, 11 Jun 2022 00:45:51 +0800
Message-Id: <20220610164555.2322930-3-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
References: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

