Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9840284A
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343785AbhIGMOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:14:23 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:50922
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229604AbhIGMOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=TLEyCuSpukvBNMXFVsAL9Tq91xopYKQTUpACUgvQjYo=; b=z
        7JfvexHztv4j28MGJCy+lLiC3z6mR4Vj8oL0byOG8/l4IWNxzeDZlvz4dTMtmIhz
        GubnVNVv56ExFOj5hsX/tgE7fU2PKAWjCHWoNTQTImA7MVB18XkIkSdaE2726pOG
        SaaK53zN9qi36RvU6z8cV+VGGOK1e86qU21rt/tIXY=
Received: from t640 (unknown [10.176.36.8])
        by app1 (Coremail) with SMTP id XAUFCgDHcaRYVzdhXjAvAA--.42797S3;
        Tue, 07 Sep 2021 20:13:12 +0800 (CST)
From:   Chenyuan Mi <cymi20@fudan.edu.cn>
Cc:     yuanxzhang@fudan.edu.cn, Chenyuan Mi <cymi20@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] test_objagg: Fix objagg and hints refcount leak when create objagg2 failed
Date:   Tue,  7 Sep 2021 20:12:48 +0800
Message-Id: <20210907121248.28236-1-cymi20@fudan.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: XAUFCgDHcaRYVzdhXjAvAA--.42797S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKw4fJw18AF1rXrykur4rKrg_yoWDtFb_G3
        48XF1kXr4YyFs5Z3W8Kws5Jr4Uua4jqFyFgrn7tFW3GFn0gFZ8Xr93Gr1DAFn09r4rtrWa
        krn7AFs7Cr12yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r126r1DMI8E62xC7I0kMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyU
        JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjTRAl1kUUUUU
X-CM-SenderInfo: isqsiiisuqikmt6i3vldqovvfxof0/
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference couting issue happens in one exception handling path of
test_hints_case(). When failing to create objagg2, the function forgets
to decrease the refcount of both objagg and hints, causing a refcount leak.

Fix this issue by jumping to the label "err_check_expect_hints_stats".

Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

---
 lib/test_objagg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index da137939a410..a7ee118c58aa 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -954,7 +954,8 @@ static int test_hints_case(const struct hints_case *hints_case)
 
 	objagg2 = objagg_create(&delta_ops, hints, &world2);
 	if (IS_ERR(objagg2))
-		return PTR_ERR(objagg2);
+		err = PTR_ERR(objagg2);
+		goto err_check_expect_hints_stats
 
 	for (i = 0; i < hints_case->key_ids_count; i++) {
 		objagg_obj = world_obj_get(&world2, objagg2,
-- 
2.17.1

