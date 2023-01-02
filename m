Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48C465ADAE
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 08:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjABHRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 02:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABHRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 02:17:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7617F1D7
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 23:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=fKPzRfi0DSM6WiKOgR1EYKzv+/xISJ8rDQnz71O7KOo=; b=I7X0qdvaL5VnegEK+T58HLYqVg
        PvazixTDuUvJccyGLQHJvI05PJfSIk9OKx5GjQpiFhuSWz26rFtXvcb8mOA6Gtwn3n0aBZwKRIbFh
        Ho5bNaY7G+9Sl88Pw9ZshAYLGw1rBjpIU2V2XCcUvjXLnGA0NXZRcqPfg+IA26Tjj0xexDrr9snaD
        pzgO6yF2RgjtWt8LMPu3cpZLItOzawDjEslOREcL6oZ/RG1JQ6DGT4TLZ6wunBrtXs5/KxOXZ54dM
        wgseBZ/YkORRah+pz+8jCwOpVO2TahJoanuOphFZmsY3Qpb2m4q99z28MAktog07Zkgqf5E1+c882
        Nk9RQylQ==;
Received: from [2601:1c2:d80:3110::a2e7] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pCF4l-009C2O-AE; Mon, 02 Jan 2023 07:17:39 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: sched: htb: fix htb_classify() kernel-doc
Date:   Sun,  1 Jan 2023 23:17:37 -0800
Message-Id: <20230102071737.24378-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix W=1 kernel-doc warning:

net/sched/sch_htb.c:214: warning: expecting prototype for htb_classify(). Prototype was for HTB_DIRECT() instead

by moving the HTB_DIRECT() macro above the function.
Add kernel-doc notation for function parameters as well.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/sched/sch_htb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -- a/net/sched/sch_htb.c b/net/sched/sch_htb.c
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -199,8 +199,14 @@ static unsigned long htb_search(struct Q
 {
 	return (unsigned long)htb_find(handle, sch);
 }
+
+#define HTB_DIRECT ((struct htb_class *)-1L)
+
 /**
  * htb_classify - classify a packet into class
+ * @skb: the socket buffer
+ * @sch: the active queue discipline
+ * @qerr: pointer for returned status code
  *
  * It returns NULL if the packet should be dropped or -1 if the packet
  * should be passed directly thru. In all other cases leaf class is returned.
@@ -211,8 +217,6 @@ static unsigned long htb_search(struct Q
  * have no valid leaf we try to use MAJOR:default leaf. It still unsuccessful
  * then finish and return direct queue.
  */
-#define HTB_DIRECT ((struct htb_class *)-1L)
-
 static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 				      int *qerr)
 {
