Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD34A217DB3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 05:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgGHDnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 23:43:10 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:36990 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728369AbgGHDnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 23:43:10 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-05 (Coremail) with SMTP id zQCowAC3meq9QAVfJfj4Aw--.9521S2;
        Wed, 08 Jul 2020 11:42:53 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] rds: send: Replace sg++ with sg = sg_next(sg)
Date:   Wed,  8 Jul 2020 03:42:52 +0000
Message-Id: <20200708034252.17408-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowAC3meq9QAVfJfj4Aw--.9521S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
        6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
        kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8I
        cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87
        Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUj_Oz3UUUUU==
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwULA102Yl5m1gAAst
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sg++ with sg = sg_next(sg).

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/rds/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 68e2bdb08fd0..57d03a6753de 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -387,7 +387,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
 				ret -= tmp;
 				if (cp->cp_xmit_data_off == sg->length) {
 					cp->cp_xmit_data_off = 0;
-					sg++;
+					sg = sg_next(sg);
 					cp->cp_xmit_sg++;
 					BUG_ON(ret != 0 && cp->cp_xmit_sg ==
 					       rm->data.op_nents);
-- 
2.17.1

