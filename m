Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE99634283
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiKVRct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiKVRcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:32:32 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F822BE8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:29 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id p18so10756407qkg.2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3rcuH36mN84wESRx05bYVQTdbTqnB9PFnSiB03P/qI=;
        b=hJmA2rbIoGD5Rj5tdFIeVyLsgnfUiX5OrRkOSyJM4dG2HMWYdcTH4w+0P2jIWDtdv1
         nHYsTiXuTcK1Ehc6r5iOnjAicidIBizK5Rf4KN61pQgSzlb07+J7BMu9ksZ02lrR69LZ
         sQCUp1ngXZr3xe6N23H5d1IEMX5otc5zF74IKsyjNL8fh1wJeBzfxn2kTpSyWMqg5LbH
         VWfomyLQxYXjm1lBaQb7HUugr4gD6uqb7QAbTb/HbgBiGpiY+llPes0m/BUSzi7Rdd06
         kKCtMXgPcD0nBSEyaYl+kuRU6wqo+4+vR7PEoCb+fGHJV3c/aQCXnYzXncpGY37HwuQ+
         bdow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3rcuH36mN84wESRx05bYVQTdbTqnB9PFnSiB03P/qI=;
        b=sfE4WtQYX/dgMeNeqlQNkEWvIDOnQOC1GZPuUKp4FLGNYJZ/GlytxoPE2BQnPoL5fV
         SaqcKH0/eoU4m8XL/MckU80OrisfEbAk8XO9Kjvv9+fpDvzrW/F+Er8rSkbUMpNsp4Dl
         m654b8TmvThZHeV0sOKWis5+y0iuCsFn+cXCA8uXy+Qt8Co//sa95mUancz8Hh3ihWMh
         +EgOBoYSQnkGE9DfBb1CoAxm35x6kMDG6sPr7UxRZ7j29gsNa6CeZFI8q9rZ45VUNSaq
         oDKqBCrJMycSWKaX4yHAtDBMT4mzTtHY8fvbhYCYnKimFeEFoLhnZm7vcZa8xU5wuHQ5
         7mTw==
X-Gm-Message-State: ANoB5pkgH6wq/dd7PM3OHxEkDkQw2NJX9ZnB+MCsaxHm4+uqYi7VJrmj
        KJIPhgbWF+fmJ77QDZKLjYBz3D+h2i9xvw==
X-Google-Smtp-Source: AA0mqf5rZwHfdNwvh8iAxXlCk9OLPe1rQqOkJ2fkAFA42FxXVmpBhvVZqL9FUPJUQc7Qsa4sqa4CaA==
X-Received: by 2002:a37:b2c6:0:b0:6ee:a33b:a583 with SMTP id b189-20020a37b2c6000000b006eea33ba583mr4288028qkf.352.1669138348412;
        Tue, 22 Nov 2022 09:32:28 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10865040qko.94.2022.11.22.09.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:32:27 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 3/5] net: sched: return NF_ACCEPT when fails to add nat ext in tcf_ct_act_nat
Date:   Tue, 22 Nov 2022 12:32:19 -0500
Message-Id: <439676c5242282638057f92dc51314df7bcd0a73.1669138256.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1669138256.git.lucien.xin@gmail.com>
References: <cover.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes to return NF_ACCEPT when fails to add nat
ext before doing NAT in tcf_ct_act_nat(), to keep consistent
with OVS' processing in ovs_ct_nat().

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index da0b7f665277..8869b3ef6642 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -994,7 +994,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 
 	/* Add NAT extension if not confirmed yet. */
 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_DROP;   /* Can't NAT. */
+		return NF_ACCEPT;   /* Can't NAT. */
 
 	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
 	    (ctinfo != IP_CT_RELATED || commit)) {
-- 
2.31.1

