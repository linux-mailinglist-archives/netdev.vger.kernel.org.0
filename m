Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826FF531232
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbiEWPbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiEWPbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:31:45 -0400
Received: from corp-front10-corp.i.nease.net (corp-front11-corp.i.nease.net [42.186.62.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CA27B34;
        Mon, 23 May 2022 08:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=iAKnlov5oGYA0AbpIPgfJSBgZZq4Ax0UhG
        qj4V4nCIQ=; b=i7QWLHUc8WgkBB71ZkQm8ciazZtcjMHdzgr6WQuJeKFCpg3h9X
        V848sfEkhRobH/d7sRF/w3h5rbQuJ8mUL3KngUbDKbgp4dOnpdrke4KC+/fXhtRd
        WbakJYSNFtrFPuOb7b20vovElyV9Hirkzu3PT7S28lmu85yW90JrgwvMU=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front11-corp.i.nease.net (Coremail) with SMTP id aYG_CgC3zV_MqItiOosgAA--.4948S2;
        Mon, 23 May 2022 23:31:24 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ubraun@linux.ibm.com
Subject: [PATCH v2 net] Revert "net/smc: fix listen processing for SMC-Rv2"
Date:   Mon, 23 May 2022 23:31:10 +0800
Message-Id: <20220523153110.474996-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220523150709.306731-1-liuyacan@corp.netease.com>
References: <20220523150709.306731-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aYG_CgC3zV_MqItiOosgAA--.4948S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4fXw4DuFy8Cry3tw13Arb_yoW5uF47pa
        1Ykr9xuF4fGF4fGrs5tF13ZF1Yvw18Kry8C3srGr1FkwnFyryrtryIqr4Y9FZxGrW3t3WI
        vFW8Cr1fWw15taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUGvb7IF0VACp39vda4lb7IF0VCFI7km07C26c804VAKzcIF0wAF
        F20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r
        1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAF
        wI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2js
        IE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAawVAFpfBj4fn0lVCY
        m3Zqqf926ryUJw1UKr1v6r18M2kK6xCIbVAIwIAEc20F6c8GOVW8Jr15Jr4ln4vEIxkG6c
        02xx0F6c8GOVWUtr18Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCE34x0Y48IcwAq
        x4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14
        v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E
        6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMx02cVAKzw
        CY1x0262kKe7AKxVWUtVW8ZwCY0x0Ix7I2Y4AK64vIr41l42xK82IYc2Ij64vIr41l4x8a
        64kIII0Yj41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY624lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUUID7DUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760qFUgAgs1
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

This reverts commit 5ec8b414b4381e8714731415fc221ef50a4e7b14.

Some rollback issue will be fixed in other patches in the future.

Link: https://lore.kernel.org/all/20220523055056.2078994-1-liuyacan@corp.netease.com/
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
---
 net/smc/af_smc.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d3de54b70..45a24d242 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2093,13 +2093,13 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	return 0;
 }
 
-static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
-					struct smc_clc_msg_proposal *pclc,
-					struct smc_init_info *ini)
+static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
+					 struct smc_clc_msg_proposal *pclc,
+					 struct smc_init_info *ini)
 {
 	struct smc_clc_v2_extension *smc_v2_ext;
 	u8 smcr_version;
-	int rc = 0;
+	int rc;
 
 	if (!(ini->smcr_version & SMC_V2) || !smcr_indicated(ini->smc_type_v2))
 		goto not_found;
@@ -2117,31 +2117,26 @@ static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 	ini->smcrv2.saddr = new_smc->clcsock->sk->sk_rcv_saddr;
 	ini->smcrv2.daddr = smc_ib_gid_to_ipv4(smc_v2_ext->roce);
 	rc = smc_find_rdma_device(new_smc, ini);
-	if (rc)
+	if (rc) {
+		smc_find_ism_store_rc(rc, ini);
 		goto not_found;
-
+	}
 	if (!ini->smcrv2.uses_gateway)
 		memcpy(ini->smcrv2.nexthop_mac, pclc->lcl.mac, ETH_ALEN);
 
 	smcr_version = ini->smcr_version;
 	ini->smcr_version = SMC_V2;
 	rc = smc_listen_rdma_init(new_smc, ini);
-	if (rc) {
-		ini->smcr_version = smcr_version;
-		goto not_found;
-	}
-	rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
-	if (rc) {
-		ini->smcr_version = smcr_version;
-		goto not_found;
-	}
-	return 0;
+	if (!rc)
+		rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
+	if (!rc)
+		return;
+	ini->smcr_version = smcr_version;
+	smc_find_ism_store_rc(rc, ini);
 
 not_found:
-	rc = rc ?: SMC_CLC_DECL_NOSMCDEV;
 	ini->smcr_version &= ~SMC_V2;
 	ini->check_smcrv2 = false;
-	return rc;
 }
 
 static int smc_find_rdma_v1_device_serv(struct smc_sock *new_smc,
@@ -2174,7 +2169,6 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 				  struct smc_init_info *ini)
 {
 	int prfx_rc;
-	int rc;
 
 	/* check for ISM device matching V2 proposed device */
 	smc_find_ism_v2_device_serv(new_smc, pclc, ini);
@@ -2202,18 +2196,14 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
 
 	/* check if RDMA V2 is available */
-	rc = smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
-	if (!rc)
+	smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
+	if (ini->smcrv2.ib_dev_v2)
 		return 0;
 
-	/* skip V1 check if V2 is unavailable for non-Device reason */
-	if (rc != SMC_CLC_DECL_NOSMCDEV &&
-	    rc != SMC_CLC_DECL_NOSMCRDEV &&
-	    rc != SMC_CLC_DECL_NOSMCDDEV)
-		return rc;
-
 	/* check if RDMA V1 is available */
 	if (!prfx_rc) {
+		int rc;
+
 		rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
 		smc_find_ism_store_rc(rc, ini);
 		return (!rc) ? 0 : ini->rc;
-- 
2.20.1

