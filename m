Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC771554BEA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 15:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357590AbiFVN44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 09:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiFVN4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 09:56:55 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44FE3525C;
        Wed, 22 Jun 2022 06:56:54 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LSlHm32cYz1KC3T;
        Wed, 22 Jun 2022 21:54:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 21:56:29 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <daniel@iogearbox.net>, <shmulik@metanetworks.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH net] test_bpf: fix incorrect netdev features
Date:   Wed, 22 Jun 2022 21:50:02 +0800
Message-ID: <20220622135002.8263-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The prototype of .features is netdev_features_t, it should use
NETIF_F_LLTX and NETIF_F_HW_VLAN_STAG_TX, not NETIF_F_LLTX_BIT
and NETIF_F_HW_VLAN_STAG_TX_BIT.

Fixes: cf204a718357 ("test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test")

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 lib/test_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 2a7836e115b4..5820704165a6 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -14733,9 +14733,9 @@ static struct skb_segment_test skb_segment_tests[] __initconst = {
 		.build_skb = build_test_skb_linear_no_head_frag,
 		.features = NETIF_F_SG | NETIF_F_FRAGLIST |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_GSO |
-			    NETIF_F_LLTX_BIT | NETIF_F_GRO |
+			    NETIF_F_LLTX | NETIF_F_GRO |
 			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_STAG_TX_BIT
+			    NETIF_F_HW_VLAN_STAG_TX
 	}
 };
 
-- 
2.33.0

