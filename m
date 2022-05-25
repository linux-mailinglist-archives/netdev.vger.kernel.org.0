Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA625338D9
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 10:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiEYIy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 04:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiEYIy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 04:54:56 -0400
Received: from corp-front10-corp.i.nease.net (corp-front11-corp.i.nease.net [42.186.62.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328489FCC;
        Wed, 25 May 2022 01:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=QMdg5
        WKCqTooQfblhmchfJKA7vl3F5cI8zeOAbsLxwo=; b=i7vYabMvkZspa7Hlmnl97
        MDoOYTncpRQGINjBEpCbTBT5bjrUbFlqy4pUyuuozY/bC1TekUAo4Q0uNSSwo/g+
        I8fmBIAE6ywkgdoBlb4re/7SYtjUX3eBH1NJvuQ6XMaX91ui5dJ9nyrx4CgEC2GW
        1DXJP+VrGxHxUaZkTy1kkY=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front11-corp.i.nease.net (Coremail) with SMTP id aYG_CgCXrV_P7o1imDAiAA--.8981S2;
        Wed, 25 May 2022 16:54:39 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com,
        liuyacan <liuyacan@corp.netease.com>
Subject: [PATCH net] net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is unavailable
Date:   Wed, 25 May 2022 16:54:08 +0800
Message-Id: <20220525085408.812273-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aYG_CgCXrV_P7o1imDAiAA--.8981S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr48WFWkKr1kKw4UXr1xAFb_yoW3KrbEkr
        yxGryxu3yFyF42k3yxA3y3urZayw1kWr4xX3WDCrW0q3WDXr1UWa98Crnxu347CrWavFy3
        Gr45KFy3ta47tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbGkYjxAI6xCIbckI1I0E57IF64kEYxAxM7AC8VAFwI0_Gr0_Xr1l
        1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0I
        I2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0
        Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7
        xvwVC2z280aVCY1x0267AKxVW0oVCq3wAawVAFpfBj4fn0lVCYm3Zqqf926ryUJw1UKr1v
        6r18M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
        IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAK
        I48JMxAIw28IcxkI7VAKI48JMxCjnVAK0II2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMx
        CIbVAxMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
        73UjIFyTuYvjfUn_M-DUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQARCVt762GPdAAHsL
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

In the process of checking whether RDMAv2 is available, the current
implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
smc buf desc and register rmb, but the latter may fail. In this case,
the pointer should be reset.

Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
---
 net/smc/af_smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 45a24d242..540b32d86 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2136,6 +2136,7 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 
 not_found:
 	ini->smcr_version &= ~SMC_V2;
+	ini->smcrv2.ib_dev_v2 = NULL;
 	ini->check_smcrv2 = false;
 }
 
-- 
2.20.1

