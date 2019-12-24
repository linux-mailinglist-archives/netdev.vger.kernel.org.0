Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64C412A026
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 11:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLXKcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 05:32:47 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:50680 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfLXKcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 05:32:47 -0500
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-05 (Coremail) with SMTP id zQCowAAXHc1D3AFeEjTIBQ--.98S3;
        Tue, 24 Dec 2019 17:37:08 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     paulus@samba.org
Cc:     davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ppp: Remove redundant BUG_ON() check in ppp_pernet
Date:   Tue, 24 Dec 2019 09:37:04 +0000
Message-Id: <1577180224-16405-1-git-send-email-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: zQCowAAXHc1D3AFeEjTIBQ--.98S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtFW8Jr4UKFyrurWxAw4DXFb_yoW3Jrb_Cw
        4fCFW3Aw1UAr1q9r4UCws8ZrZay3WkWr1kJrs2grZxX34ktFyrXr95ursrAr4kWrZ5CF9r
        Ca47ZryrJrWYgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbFkYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2Iq
        xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
        106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
        xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
        xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWU
        JVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcVWlDUUUU
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBAgNA102S0V3TwABse
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to ppp_pernet causes a crash via BUG_ON.
Dereferencing net in net_generici() also has the same effect.
This patch removes the redundant BUG_ON check on the same parameter.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ppp/ppp_generic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 3bf8a8b..22cc2cb 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -296,8 +296,6 @@ static struct class *ppp_class;
 /* per net-namespace data */
 static inline struct ppp_net *ppp_pernet(struct net *net)
 {
-	BUG_ON(!net);
-
 	return net_generic(net, ppp_net_id);
 }
 
-- 
2.7.4

