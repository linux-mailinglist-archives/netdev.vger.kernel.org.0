Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE65BB6B0
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 08:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIQGhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 02:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIQGhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 02:37:32 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BFED4D804;
        Fri, 16 Sep 2022 23:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Sk8f4
        Kor53nWiBGSEmFzBqgX0mraGX2YhwieIB+TDYs=; b=NxzlnFNpobHkDsGao33WU
        LxW+U3LWG00FRtuIgiqlzlH4sUD6nWwbDUL5l2GDjyEkJafxyPjsTjmPxIFF31cO
        tpecLU288sIBeCf5u3fFRtTjYpbfCeQ21GS+c3qyZWLJFjQS+EsSQupL6HFxSRUK
        dDaQg4tvmmA7sjIZ1Hpev4=
Received: from DESKTOP-CE2KKHI.localdomain (unknown [124.160.210.227])
        by smtp1 (Coremail) with SMTP id GdxpCgDHzp7OaiVj3yvhdQ--.64650S2;
        Sat, 17 Sep 2022 14:35:59 +0800 (CST)
From:   williamsukatube@163.com
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     William Dean <williamsukatube@163.com>
Subject: [PATCH -next] net: sched: simplify code in mall_reoffload
Date:   Sat, 17 Sep 2022 14:35:56 +0800
Message-Id: <20220917063556.2673-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDHzp7OaiVj3yvhdQ--.64650S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF17KFy5Gr4UuF4fJr17trb_yoW3Arg_Ca
        48Xr4xWFn7JF1UG3yIqr4vy34SqFZFvFWYqrs2grW7Ga18KF4kZan8K3Z5ArZ3WryxtF1U
        CrZY9Fy5Cr47ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_byZUUUUUU==
X-Originating-IP: [124.160.210.227]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/xtbBiA9-g1aECq0sqgAAsI
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dean <williamsukatube@163.com>

such expression:
	if (err)
		return err;
	return 0;
can simplify to:
	return err;

Signed-off-by: William Dean <williamsukatube@163.com>
---
 net/sched/cls_matchall.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 06cf22adbab7..63b99ffb7dbc 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -313,10 +313,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	tc_cleanup_offload_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);

-	if (err)
-		return err;
-
-	return 0;
+	return err;
 }

 static void mall_stats_hw_filter(struct tcf_proto *tp,
--
2.25.1

