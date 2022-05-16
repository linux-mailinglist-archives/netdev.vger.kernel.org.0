Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04233527C58
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239641AbiEPD3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiEPD3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:29:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4562C1098;
        Sun, 15 May 2022 20:29:08 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L1l7S14Phz1JCM2;
        Mon, 16 May 2022 11:27:48 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 16 May
 2022 11:29:05 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <luwei32@huawei.com>
Subject: [PATCH net-next] ice: use eth_broadcast_addr() to set broadcast address
Date:   Mon, 16 May 2022 11:29:48 +0800
Message-ID: <20220516032948.327471-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use eth_broadcast_addr() to set broadcast address instead of memset().

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 0a0c55fb8699..aa1c61e156cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1191,7 +1191,7 @@ ice_handle_tclass_action(struct ice_vsi *vsi,
 			   ICE_TC_FLWR_FIELD_ENC_DST_MAC)) {
 		ether_addr_copy(fltr->outer_headers.l2_key.dst_mac,
 				vsi->netdev->dev_addr);
-		memset(fltr->outer_headers.l2_mask.dst_mac, 0xff, ETH_ALEN);
+		eth_broadcast_addr(fltr->outer_headers.l2_mask.dst_mac);
 	}
 
 	/* validate specified dest MAC address, make sure either it belongs to
-- 
2.17.1

