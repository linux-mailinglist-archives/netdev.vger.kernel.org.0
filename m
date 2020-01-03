Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA212F613
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 10:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgACJ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 04:28:27 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:35676 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgACJ21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 04:28:27 -0500
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-03 (Coremail) with SMTP id rQCowACHJnAyCQ9eyDDEAQ--.52S3;
        Fri, 03 Jan 2020 17:28:18 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] l2tp: Remove redundant BUG_ON() check in l2tp_pernet
Date:   Fri,  3 Jan 2020 09:28:16 +0000
Message-Id: <1578043696-35911-1-git-send-email-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowACHJnAyCQ9eyDDEAQ--.52S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr45Ww43XF18Kr4fAFyDGFg_yoWxZFX_t3
        yxGa1I9r1kJ3W8Cr47Aw4YvF9Yva95Zr1rC34kKrsrta4Dtrn5Z3yrAa4DCr1UursY9F9F
        krnxZw4UJw45WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb7AYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
        80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx
        8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8uwCF04k20xvY
        0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
        CF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8LjjDUUUUU==
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgMEA10Tegr+WAAAsa
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to l2tp_pernet causes a crash via BUG_ON.
Dereferencing net in net_generic() also has the same effect.
This patch removes the redundant BUG_ON check on the same parameter.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/l2tp/l2tp_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f82ea12..c99223c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -122,8 +122,6 @@ static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
 
 static inline struct l2tp_net *l2tp_pernet(const struct net *net)
 {
-	BUG_ON(!net);
-
 	return net_generic(net, l2tp_net_id);
 }
 
-- 
2.7.4

