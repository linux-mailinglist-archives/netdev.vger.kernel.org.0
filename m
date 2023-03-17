Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027E26BE16F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 07:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCQGoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 02:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCQGoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 02:44:06 -0400
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0942A5C137;
        Thu, 16 Mar 2023 23:43:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowABHTQkaDBRk5fQMEQ--.40302S2;
        Fri, 17 Mar 2023 14:43:38 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     kuba@kernel.org
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH v2] octeontx2-vf: Add missing free for alloc_percpu
Date:   Fri, 17 Mar 2023 14:43:37 +0800
Message-Id: <20230317064337.18198-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowABHTQkaDBRk5fQMEQ--.40302S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4rZF4fCr17uw15XFWfGrg_yoW8WF13pa
        18AFy7ur45XF43WwsrAa4rGFWfGayDt3ySg34Fkw4Fvw43tFn5ZFyqkrW0kr18GrWkWFnx
        ta4Yv393W3Z5JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r47MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUb2Nt3UUUUU==
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the free_percpu for the allocated "vf->hw.lmt_info" in order to avoid
memory leak, same as the "pf->hw.lmt_info" in
`drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.

Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated LMTLINE region")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Geethasowjanya Akula <gakula@marvell.com>
---
Changelog:

v1 -> v2:

1. Remove the if () checks.
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 7f8ffbf79cf7..ab126f8706c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -709,6 +709,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_ptp_destroy:
 	otx2_ptp_destroy(vf);
 err_detach_rsrc:
+	free_percpu(vf->hw.lmt_info);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2_detach_resources(&vf->mbox);
@@ -762,6 +763,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	otx2_shutdown_tc(vf);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
+	free_percpu(vf->hw.lmt_info);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2vf_vfaf_mbox_destroy(vf);
-- 
2.25.1

