Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB88C12A5C1
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 04:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfLYDH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 22:07:28 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:42868 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfLYDH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 22:07:28 -0500
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-05 (Coremail) with SMTP id zQCowACXn89b0gJeJlojBg--.766S3;
        Wed, 25 Dec 2019 11:07:08 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     paulus@samba.org
Cc:     davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ppp: Remove redundant BUG_ON() check in ppp_pernet
Date:   Wed, 25 Dec 2019 03:07:04 +0000
Message-Id: <1577243224-1923-1-git-send-email-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: zQCowACXn89b0gJeJlojBg--.766S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtFW5XFW8XryDuF4xKr4kWFg_yoWxKwc_Cw
        4fCFW3Aw1UAr1q9r4UCws8ZrZIy3WkWr1kJrs2grZxX34ktFyrXr95ursrAr4kWrZ5CF9r
        Ca47ZryrJrWYgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbwxYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF
        x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
        v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
        67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2
        IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
        xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcVWlDUUUU
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAMPA1z4ipKwYQAAsu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to ppp_pernet causes a crash via BUG_ON.
Dereferencing net in net_generic() also has the same effect.
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

