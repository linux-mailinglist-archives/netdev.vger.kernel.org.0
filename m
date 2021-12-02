Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CEA465F01
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 08:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbhLBH7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 02:59:42 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:40048 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230274AbhLBH7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 02:59:41 -0500
Received: from localhost.localdomain (unknown [124.16.141.244])
        by APP-03 (Coremail) with SMTP id rQCowAA3PVkLfKhhYmTeAA--.61374S2;
        Thu, 02 Dec 2021 15:55:56 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mctp: Remove redundant if statements
Date:   Thu,  2 Dec 2021 07:55:35 +0000
Message-Id: <20211202075535.34383-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAA3PVkLfKhhYmTeAA--.61374S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY87k0a2IF6w4xM7kC6x804xWl14x267AK
        xVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
        A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j
        6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr
        1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAa
        Y2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4
        A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Av
        z4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8
        dsqJUUUUU==
X-Originating-IP: [124.16.141.244]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQgDA102awiI+gAAs7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'if (dev)' statement already move into dev_{put , hold}, so remove
redundant if statements.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/mctp/route.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 46c44823edb7..b89fda2c230e 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -892,8 +892,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	if (!ext_rt)
 		mctp_route_release(rt);
 
-	if (dev)
-		dev_put(dev);
+	dev_put(dev);
 
 	return rc;
 
-- 
2.25.1

