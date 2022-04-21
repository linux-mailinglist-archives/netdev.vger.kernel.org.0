Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40499509DBC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350048AbiDUKhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388434AbiDUKhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:37:36 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB7C29830;
        Thu, 21 Apr 2022 03:34:45 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 21 Apr
 2022 18:34:45 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 21 Apr
 2022 18:34:43 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <baihaowen@meizu.com>
CC:     <UNGLinuxDriver@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.manoil@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>
Subject: [PATCH V2] net: mscc: ocelot: Remove useless code
Date:   Thu, 21 Apr 2022 18:34:41 +0800
Message-ID: <1650537281-15069-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1650537117-14450-1-git-send-email-baihaowen@meizu.com>
References: <1650537117-14450-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

payload only memset but no use at all, so we drop them.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: change correct title

 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index c8701ac955a8..1e74bdb215ec 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -672,12 +672,10 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 {
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
-	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
 	int row = ix / 2;
 	u32 type;
 
-	memset(&payload, 0, sizeof(payload));
 	memset(&data, 0, sizeof(data));
 
 	/* Read row */
@@ -813,11 +811,9 @@ static void es0_entry_set(struct ocelot *ocelot, int ix,
 {
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
-	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
 	int row = ix;
 
-	memset(&payload, 0, sizeof(payload));
 	memset(&data, 0, sizeof(data));
 
 	/* Read row */
-- 
2.7.4

