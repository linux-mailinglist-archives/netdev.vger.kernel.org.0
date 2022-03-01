Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A644C88B1
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiCAKBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiCAKBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:01:16 -0500
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0DC78C7FA;
        Tue,  1 Mar 2022 02:00:33 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowAAnCPG27h1i3OLYAQ--.4914S2;
        Tue, 01 Mar 2022 18:00:23 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] wireless/nl80211: Handle errors for nla_memdup
Date:   Tue,  1 Mar 2022 18:00:20 +0800
Message-Id: <20220301100020.3801187-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAAnCPG27h1i3OLYAQ--.4914S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr4DCw1kCF1UXF1ftr4rGrg_yoWDKrb_CF
        WvqF1Ut3W8Aa1Fga4xCrs0ya92kw48Jr4fWwnIgF9rA345JrZa9F1FvF95Ga45Cry09rW5
        Gw1DKr1xtwnxWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbzxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
        AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
        0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
        v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the potential failure of the nla_memdup(),
it should be better to check it, as same as kmemdup().

Fixes: a442b761b24b ("cfg80211: add add_nan_func / del_nan_func")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/wireless/nl80211.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 578bff9c378b..b1909ce2b739 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13411,6 +13411,9 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	i = 0;
 	nla_for_each_nested(attr, attr_filter, rem) {
 		filter[i].filter = nla_memdup(attr, GFP_KERNEL);
+		if (!filter[i].filter)
+			goto err;
+
 		filter[i].len = nla_len(attr);
 		i++;
 	}
@@ -13423,6 +13426,15 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	}
 
 	return 0;
+
+err:
+	i = 0;
+	nla_for_each_nested(attr, attr_filter, rem) {
+		kfree(filter[i].filter);
+		i++;
+	}
+	kfree(filter);
+	return -ENOMEM;
 }
 
 static int nl80211_nan_add_func(struct sk_buff *skb,
-- 
2.25.1

