Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83C26BBED
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 07:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIPFlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 01:41:36 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:38510 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbgIPFlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 01:41:36 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowAAnnRUMpWFfe1tFAg--.2699S2;
        Wed, 16 Sep 2020 13:39:24 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        kuba@kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] sunrpc: cache : Replace seq_printf with seq_puts
Date:   Wed, 16 Sep 2020 05:39:18 +0000
Message-Id: <20200916053918.25741-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowAAnnRUMpWFfe1tFAg--.2699S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur4UGr48WFW7JFWrWryrCrg_yoWxuFcE9a
        4fCF1UWFs3XF1UCFnrJrsxG3ykZa4qvFs5KwnrtrW7tr1Utr1jvwn3uFn3G3W5GFWkKF97
        CrykuFyxXw1akjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCY02Avz4vE14v_GrWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUdDGOUUUUU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCwUBA1z4jcHRVQAAsg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

seq_puts is a lot cheaper than seq_printf, so use that to print
literal strings.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/sunrpc/cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index baef5ee43dbb..9e68e443f497 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1436,10 +1436,10 @@ static int c_show(struct seq_file *m, void *p)
 	cache_get(cp);
 	if (cache_check(cd, cp, NULL))
 		/* cache_check does a cache_put on failure */
-		seq_printf(m, "# ");
+		seq_puts(m, "# ");
 	else {
 		if (cache_is_expired(cd, cp))
-			seq_printf(m, "# ");
+			seq_puts(m, "# ");
 		cache_put(cp, cd);
 	}
 
-- 
2.17.1

