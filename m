Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3D65314A8
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbiEWPHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbiEWPHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:07:45 -0400
Received: from corp-front09-corp.i.nease.net (corp-front09-corp.i.nease.net [59.111.134.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE04EDED;
        Mon, 23 May 2022 08:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=gASKp
        OtgMj1BfL6/AQe7tCq6BG4t75k/9AW8Xenxz00=; b=c1QSzGY3SqO9iBPXUvARZ
        DkalgaRs4AUN/V46FxOpWz15GOc2aS41M0at2ZVVPFnFtiDpvBakMpgpFdEr2B+z
        t+xRsPSBi/DccGjktecbx7thMFIjLOoU22jWfZbM6tKuwxrsRMu/AW+v6zMnI/y8
        lt3Nm6SstH/cDeJ6Q458og=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front09-corp.i.nease.net (Coremail) with SMTP id nxDICgAXGV4to4tiArlgAA--.20394S2;
        Mon, 23 May 2022 23:07:26 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com,
        liuyacan <liuyacan@corp.netease.com>
Subject: [PATCH net] Revert "net/smc: fix listen processing for SMC-Rv2"
Date:   Mon, 23 May 2022 23:07:09 +0800
Message-Id: <20220523150709.306731-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nxDICgAXGV4to4tiArlgAA--.20394S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4fXw4DuFy8Cry3tw13Arb_yoW5tr4rpa
        1Ykr9xZF4fGF4fGrs5tF13ZF1Yvw18Kry8C3srGr1SkwnFyryrtryIqr4Y9FZxGrW3t3WI
        vFW8Cr1fWw45taUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUJab7IF0VACp39vda4lb7IF0VCFI7km07C26c804VAKzcIF0wAF
        F20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r
        1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAF
        wI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aV
        AFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9v
        y-n0Xa0_Xr1Utr1kJwI_Jr4ln4vE4IxY62xKV4CY8xCE548m6r4UJryUGwAawVCIc40E5I
        027xCE548m6r1DJr4UtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCqF7xvr2I5Mc02
        F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI
        0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CE
        Vc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24l7I0Y64k_Mx
        kI7II2jI8vz4vEwIxGrwCF04k20xvY0x0EwIxGrwCF72vEw2IIxxk0rwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwCFI7vE0wC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
        106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
        xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
        xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
        Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRp6wAUUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760qFUgAcsJ
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
Fixes: 5ec8b414b438 ("net/smc: fix listen processing for SMC-Rv2")
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

