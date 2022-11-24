Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A7F637EA6
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiKXRzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiKXRyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:54:54 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A806347;
        Thu, 24 Nov 2022 09:54:14 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id p12so1337963qvu.5;
        Thu, 24 Nov 2022 09:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dhuOlBvKzwd3/0ePZXd2zuYBi6GrQ2Jo7WM3sl4Ywlo=;
        b=DjsrjOhIGzB5EstXnNxA0roNHcZ59qW0qafaJ++ZF1B313EsAzpBdhsVsudq3nHlvV
         UDVyMXUMhb8HTJvWKMngjitvqEGguX6ufGVXACuPpcfhrnKqItotOwtW6C10FLTQhvQT
         iBnX4b3GG5Aah9WJNPjF40+cIk2xAUK6tovEwnHlCY4Ovo5KM7StfWG2nOgAFUZgDw4M
         GFYwqvEzBKBIVgdUHwa9CXMavrC0vr0BbENSk6QOzQ/ohiwmIG2h5YFdLXFvJFfBFMC7
         EfKAuMAJvl46RU5PGE0oZ94b/KVS72ujuTlM4WI1rMjtOotg2pwDphI3hP4nwD0fO6pP
         j2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dhuOlBvKzwd3/0ePZXd2zuYBi6GrQ2Jo7WM3sl4Ywlo=;
        b=zBTUZmgihG9cDVVjO+5czACO3j462hemplvtgFv3R5LqRC0GDcEIbocY+MjQ5+7Tp4
         rpAx7JrxJSbYChRTXQeOYzex2blycb81Mytb+/7ekxfoWM4ESYgjG/uWd5c0nKt47iFz
         bk5ym7QvFSDoMk8CkRRtyu0RrXfY9G7QPUgKfQTvwbOzLRiMUxxTbUnHJm/hmtT2o4d/
         OQE8Z9BQiuMAop+0dWzLuW6Dg0TBuyCiNbx0zj4ggRgy3dJmfks/ITZWfGIXi8lVWb2K
         amzeJJy6XXsMu9JJU4s+kD7hlgNf93pqaeZPJFu8uhG8ZTxegh7Hyc/l9zrv5VSswprg
         S5Fw==
X-Gm-Message-State: ANoB5pmogIBw5GYTWmv78vzA+Eo/2w4Al2Cw+DWBiG9sp4Lid9fyK3uY
        B7WYgkmsSY8v4/HEkxa9JCKaGUYyfVCqmQ==
X-Google-Smtp-Source: AA0mqf5lvQVT9TRcv3GZQuOes0SvukE8kKD2ydqjiPKLmTgXoms2EnegQy+wykBQO91hBDdpf1KLGA==
X-Received: by 2002:a05:6214:5a0a:b0:4bb:806b:8e5e with SMTP id lu10-20020a0562145a0a00b004bb806b8e5emr31525497qvb.123.1669312452695;
        Thu, 24 Nov 2022 09:54:12 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bz13-20020a05622a1e8d00b0039cc0fbdb61sm893776qtb.53.2022.11.24.09.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 09:54:12 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH nf] netfilter: fix using __this_cpu_add in preemptible in nf_flow_table_offload
Date:   Thu, 24 Nov 2022 12:54:10 -0500
Message-Id: <9fc554880eeb0bc9d1749d9577e3aa058eb9f61c.1669312450.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

flow_offload_queue_work() can be called in workqueue without
bh disabled, like the call trace showed in my act_ct testing,
calling NF_FLOW_TABLE_STAT_INC() there would cause a call
trace:

  BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u4:0/138560
  caller is flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
  Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work [act_ct]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   check_preemption_disabled+0xc3/0xf0
   flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
   nf_flow_table_iterate+0x138/0x170 [nf_flow_table]
   nf_flow_table_free+0x140/0x1a0 [nf_flow_table]
   tcf_ct_flow_table_cleanup_work+0x2f/0x2b0 [act_ct]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by using NF_FLOW_TABLE_STAT_INC_ATOMIC()
instead in flow_offload_queue_work().

Note that for FLOW_CLS_REPLACE branch in flow_offload_queue_work(),
it may not be called in preemptible path, but it's good to use
NF_FLOW_TABLE_STAT_INC_ATOMIC() for all cases in
flow_offload_queue_work().

Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 00b522890d77..0fdcdb2c9ae4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -997,13 +997,13 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	struct net *net = read_pnet(&offload->flowtable->net);
 
 	if (offload->cmd == FLOW_CLS_REPLACE) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
 	} else if (offload->cmd == FLOW_CLS_DESTROY) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
 	} else {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
 	}
 }
-- 
2.31.1

