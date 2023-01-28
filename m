Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7E667F956
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbjA1P7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjA1P6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:55 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C174E2943B
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:44 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id jf11so2256627qvb.4
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=GoCzo2xvQ5wjPwW1SIpoPIv7J0LYWPvzomvgTUVTHqCeUwYvD/0QGeyBEWzDl2O+Ru
         Qj/0txIRCGfK31jDrfrBj5JTkmykZXBLQ3dNyT5W3x88lLeLG9cIDkMsyaitAj0zt/E0
         LDOIR5TVUAlWXfc+x4w4N6NzckkyJfSPuLIsKxo8JsMf/iDEqkDuMILlwjftFlzWfvHK
         8LVaMF8qttSfbFOfpp44qHsXBtLs5D7iWAtMvhm0f4OCoFiSdnhbnSM7tQabYhcueWMH
         2RpkiAE9rRAp7KydQI6qg3h9F2kNtkkhnYje20PzhOwPwxHXhvXfLC/ky5UlQjbpQ2dm
         6piQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=gmMilo+HRYBuDKrkM8iGzzK3b+RFZgDFFVaMhhO7238HdbOe0yVZUj0Y+87awi3aNV
         ntQkUQwpwQ31TE6Lg9rJKoX69dpJI+W6LsOwaqEpltyiX7RLe7zwu36ubyqYf3Hc1sYz
         A6H8GoPekQ6U6ntxOHs8FkdyPJqdvqTps1HTMFbmVkg7MnyAAzYEhUC+iUdtkIKmGCdB
         lI7iuxZVfulHCsEu2OdlZuFS8AiMGsI98hLKdPZMGpV+93yCpaux5G3HfgJ4CDrjaOfo
         0vFedN0WtO0BIEPHvA4gzFK7JNpMuXgJqMp6YyjWiwj+2CeyDYBcITsruxz4eEJ6m48n
         UKDg==
X-Gm-Message-State: AO0yUKUD4LxWaXlx5FT0YZ6UTgBCHeCbMnHHXZaDGXQU4v3im+UK9xnb
        V/D66d9Az01E+6KhWvEBK/BwGem40q36FQ==
X-Google-Smtp-Source: AK7set+sTvZa/K5s+5/+d7n8APwh8duYvXDQQi+Uq5/GdptoSFGX4u4/cpqlAZ6ny14DgH83HHR86Q==
X-Received: by 2002:a05:6214:d4f:b0:53a:1a88:f740 with SMTP id 15-20020a0562140d4f00b0053a1a88f740mr5609249qvr.27.1674921523421;
        Sat, 28 Jan 2023 07:58:43 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:43 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv4 net-next 02/10] bridge: use skb_ip_totlen in br netfilter
Date:   Sat, 28 Jan 2023 10:58:31 -0500
Message-Id: <4542573738ca3499bd15b2e9980c0176db442dc7.1674921359.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
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

These 3 places in bridge netfilter are called on RX path after GRO
and IPv4 TCP GSO packets may come through, so replace iph tot_len
accessing with skb_ip_totlen() in there.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_hooks.c            | 2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..b67c9c98effa 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -214,7 +214,7 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
 		goto csum_error;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < len) {
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 5c5dd437f1c2..71056ee84773 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -212,7 +212,7 @@ static int nf_ct_br_ip_check(const struct sk_buff *skb)
 	    iph->version != 4)
 		return -1;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < nhoff + len ||
 	    len < (iph->ihl * 4))
                 return -1;
@@ -256,7 +256,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 			return NF_ACCEPT;
 
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		if (pskb_trim_rcsum(skb, len))
 			return NF_ACCEPT;
 
-- 
2.31.1

