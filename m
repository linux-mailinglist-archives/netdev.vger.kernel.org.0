Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284B065ABDA
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 22:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjAAV7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 16:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjAAV7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 16:59:04 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEB110E0
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 13:59:03 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id j9so12237752qvt.0
        for <netdev@vger.kernel.org>; Sun, 01 Jan 2023 13:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pd91SZ8ZY7SZMOzUe+Mhtx+sOoHRZXx4CyoNoudccHM=;
        b=T0whX5/V5TmQwFY42hiF4ezDAWfesxk4LbxOjyDNoTLR76/5487b3+DyKZcSQq06nd
         9qcg8wwC7qdqKq4j6uu3MTyyNK0CZqIaYa/c/aOMILShgWyyBySR1Omsj5U84LmOmeva
         y8VYNIYwUFGFz+bFQdrO6CxJYmP7aInzqi84uPZJQt3PsfeYYtlv8DMyzLv7UZ3P/pY9
         nhLS7d0XjstXEZTYbXOjg0MxiC/lzPPnILz3AyJR43OM9XWc+702F7eMdWCamjYmCuty
         1jT9Z1F8BNVcfQG09AzNjksqLwplHfGSjqPq2mqkEO80ImhXZV4Lh4Gk3WZSWuNo1nF9
         Zycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pd91SZ8ZY7SZMOzUe+Mhtx+sOoHRZXx4CyoNoudccHM=;
        b=h9cq+Uq8Y3shuut4zK5AyAtL+76jwqzYUYLGpfst5T4q8vDavdXBSRuGfbKV785xJh
         MpC/IHEIGnqjNLaDUPcFRZPCNPKwoOxqip8GUHWhbG+9V+slU8Akbu6sgESFnB9zIKuX
         TCZVqQM/JPStHMobEmwCof+yse+AdjyGlAZwMrxdXApPmmx9h9FCHi+UkZN3oSnhrtzD
         BZJ/+Rh0XCCTCWDwC89yRLgS1Atjhh2idjsuFCl1ua2/KgQNFMY0gL3aB1hoV8OvsUt1
         wSeLazSIdJ/+0MMRnp98lPg7kaWDdS0wIkjRqVYx4+cOxey2K8UvcIrFQ9mFrk0JwicG
         QYDA==
X-Gm-Message-State: AFqh2kpBziN8ot3YyYyRVi1U2h3Us/pcu/jkA6dBUcsEVB+vxfn5Y+CS
        W8uQownjgbATolpUTEiiU/VmTw==
X-Google-Smtp-Source: AMrXdXuvc3HE+HzQtZPNyCCwzKoR9GNijnZsunXSuh39GYBtlInK7cwC9i6ql/U6E6jOoe6te1RGEA==
X-Received: by 2002:ad4:5c44:0:b0:4c6:5a5f:306b with SMTP id a4-20020ad45c44000000b004c65a5f306bmr85370210qva.29.1672610342206;
        Sun, 01 Jan 2023 13:59:02 -0800 (PST)
Received: from mbili.. (bras-base-kntaon1618w-grc-10-184-145-9-33.dsl.bell.ca. [184.145.9.33])
        by smtp.gmail.com with ESMTPSA id m14-20020ae9e70e000000b006e42a8e9f9bsm19233073qka.121.2023.01.01.13.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 13:59:01 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        zengyhkyle@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 1/2] net: sched: atm: dont intepret cls results when asked to drop
Date:   Sun,  1 Jan 2023 16:57:43 -0500
Message-Id: <20230101215744.709178-2-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230101215744.709178-1-jhs@mojatatu.com>
References: <20230101215744.709178-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If asked to drop a packet via TC_ACT_SHOT it is unsafe to assume
res.class contains a valid pointer
Fixes: b0188d4dbe5f ("[NET_SCHED]: sch_atm: Lindent")

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/sch_atm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index f52255fea652..4a981ca90b0b 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -393,10 +393,13 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				result = tcf_classify(skb, NULL, fl, &res, true);
 				if (result < 0)
 					continue;
+				if (result == TC_ACT_SHOT)
+					goto done;
+
 				flow = (struct atm_flow_data *)res.class;
 				if (!flow)
 					flow = lookup_flow(sch, res.classid);
-				goto done;
+				goto drop;
 			}
 		}
 		flow = NULL;
-- 
2.34.1

