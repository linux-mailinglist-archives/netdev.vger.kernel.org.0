Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E87637E2B
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKXRV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKXRVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:21:50 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E57109590;
        Thu, 24 Nov 2022 09:21:49 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id i9so1325109qkl.5;
        Thu, 24 Nov 2022 09:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=swXPCJ3Vt8NybwpinVftzKi5NXB2BzwYuWxMwJ0OHjA=;
        b=jTHy8g/xCy2WRdZpdom/1rJxLc6HT0ER5phslSKLIgLba2RPPAJlL+KXnjL6QuwamD
         5IR+rv78yjKdTBggAXdCOw6WZAWoRyIEzfOHFYwXC2gBACVT30NN83ZtJiLikLiYX9MP
         t4et5mAvYkgubaX6qI+bVo1yHG5hdOPjx/wyKBtol8mK9tn4eUN3USyB88Tf6klIcOLE
         35nouecPsxlfUCiLufS6W2u7V2paZXG5tKVw2tBmKS4Auy8tRhi0C+8QnhWJ2m3C6I+t
         9YFEc+n3tJeKbB15gZ9xiI2fxXtaD0aVc4Mtktn6vu88l5eUUEoZ31fTnRll5+C0dmqA
         gtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swXPCJ3Vt8NybwpinVftzKi5NXB2BzwYuWxMwJ0OHjA=;
        b=VKswQam6bg+c958oPOnTiAFQxrtZ4fv0vqrGH3izE9Xf4LdEZiKNCkX8jINkr8ZjZZ
         OsRH0N0QS34opNeETPrjiRhMDXnpO+xMk0qsc90uXTQSxSpRjGi28IyLUFvaCGuo7p8W
         v9R1OwwLjOZTSfjH05m40AvdQmL6uiy32X5uGP6WEb61rk9nJL/X8Rm04DDPFtzYb8i1
         1YdDUKDvZRAf9PDde9urcJii7Q3vxYs0baRfMdbYkg/Uhd55jKfLPT6ZqyaracJnwVdo
         QbnUhlVsLXOVmXfjc4WYG+EoR+fNaI9ah+3+uGthV6IIKzywOlWOGNGnzWcn41M5icYg
         hIKA==
X-Gm-Message-State: ANoB5pkOH0cCUuqslmrUK5uRQS1Y89VVbhc1j0bwUQsZ3ye6d3J8pbJ1
        4y6YAZR1jd8TeIXt2Jvd8SHjQP8bavc=
X-Google-Smtp-Source: AA0mqf4TgWQQW9FXb1/4ItHSKTeVqZJ4yhCHU2xXjh45t0lYtHoR7pofAEayS0VM1IJQHL0xyyW8wQ==
X-Received: by 2002:a05:620a:2205:b0:6fa:3d52:ca with SMTP id m5-20020a05620a220500b006fa3d5200camr29438508qkh.362.1669310508502;
        Thu, 24 Nov 2022 09:21:48 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bq10-20020a05622a1c0a00b003a582090530sm829101qtb.83.2022.11.24.09.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 09:21:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH nf] netfilter: fix using __this_cpu_add in preemptible in nf_conntrack_core
Date:   Thu, 24 Nov 2022 12:21:46 -0500
Message-Id: <24fafc682ed793651f7306023b1972323abcd97c.1669310506.git.lucien.xin@gmail.com>
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

Currently in nf_conntrack_hash_check_insert(), when it fails in
nf_ct_ext_valid_pre/post(), NF_CT_STAT_INC() will be called in the
preemptible context, a call trace can be triggered:

   BUG: using __this_cpu_add() in preemptible [00000000] code: conntrack/1636
   caller is nf_conntrack_hash_check_insert+0x45/0x430 [nf_conntrack]
   Call Trace:
    <TASK>
    dump_stack_lvl+0x33/0x46
    check_preemption_disabled+0xc3/0xf0
    nf_conntrack_hash_check_insert+0x45/0x430 [nf_conntrack]
    ctnetlink_create_conntrack+0x3cd/0x4e0 [nf_conntrack_netlink]
    ctnetlink_new_conntrack+0x1c0/0x450 [nf_conntrack_netlink]
    nfnetlink_rcv_msg+0x277/0x2f0 [nfnetlink]
    netlink_rcv_skb+0x50/0x100
    nfnetlink_rcv+0x65/0x144 [nfnetlink]
    netlink_unicast+0x1ae/0x290
    netlink_sendmsg+0x257/0x4f0
    sock_sendmsg+0x5f/0x70

This patch is to fix it by changing to use NF_CT_STAT_INC_ATOMIC() for
nf_ct_ext_valid_pre/post() check in nf_conntrack_hash_check_insert(),
as well as nf_ct_ext_valid_post() in __nf_conntrack_confirm().

Note that nf_ct_ext_valid_pre() check in __nf_conntrack_confirm() is
safe to use NF_CT_STAT_INC(), as it's under local_bh_disable().

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2692139ce417..23b3fedd619a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -891,7 +891,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	zone = nf_ct_zone(ct);
 
 	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC(net, insert_failed);
+		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
 		return -ETIMEDOUT;
 	}
 
@@ -938,7 +938,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return -ETIMEDOUT;
 	}
 
@@ -1275,7 +1275,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 */
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return NF_DROP;
 	}
 
-- 
2.31.1

