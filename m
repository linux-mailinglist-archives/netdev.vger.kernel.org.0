Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188A15325E8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiEXJDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 05:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiEXJDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 05:03:20 -0400
Received: from corp-front09-corp.i.nease.net (corp-front09-corp.i.nease.net [59.111.134.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20C710563;
        Tue, 24 May 2022 02:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=RwR4zVzEfE8Rgkx26xGb5eh8WRRaiUn8OW
        4af/6yY9w=; b=J88F/M+b91mWnSNzO6wKeWZtuIPRtzLhNoDLJxOcN1U6TM/WBi
        +4oErJ+pKPgyl6gsw8vFrcXdXg57oAvCk7j93rzmykEA86CVUNvn0qAweg1O3xex
        wzftQu+xlgFKBI8iNMLE9kydZ70cMNZZheF1EQ1VpyZx9146JAN8b3ZSE=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front09-corp.i.nease.net (Coremail) with SMTP id nxDICgBnrmI_n4xizAJhAA--.16112S2;
        Tue, 24 May 2022 17:02:55 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     pabeni@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, ubraun@linux.ibm.com
Subject: [PATCH v3 net] Revert "net/smc: fix listen processing for SMC-Rv2"
Date:   Tue, 24 May 2022 17:02:30 +0800
Message-Id: <20220524090230.2140302-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <3090d3059e3493af2b0d69961eaa8584834f7a1a.camel@redhat.com>
References: <3090d3059e3493af2b0d69961eaa8584834f7a1a.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nxDICgBnrmI_n4xizAJhAA--.16112S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGr43GFWUKr18uF4UJw1fZwb_yoW5tr4rpa
        15Cr9xuF4rGF4fGrs5tF13uF1Yqw18Kry8C3srGr1FkwnFyryrtryIqr4Y9FZxKrW3t3WI
        vFW8Cr1fWw45taUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUpqb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxujqTIEc-sFP3VYkVW5Jr1DJw4U
        KVWUGwAawVCFI7vE04vSzxk24VAqrcv_Gr1UXr18M2kK6IIYrVAqxI0j4VAqrcv_Jw1UGr
        1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02
        F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
        kC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
        rI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAKI4
        8JMxAIw28IcxkI7VAKI48JMxCjnVAK0II2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMxCI
        bVAxMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
        AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
        2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
        C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73
        UjIFyTuYvjTRMuWlUUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAQCVt761WpXwAFsx
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

This reverts commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d.

Some rollback issue will be fixed in other patches in the future.

Link: https://lore.kernel.org/all/20220523055056.2078994-1-liuyacan@corp.netease.com/

Fixes: 8c3b8dc5cc9b ("net/smc: fix listen processing for SMC-Rv2")
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

