Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7AE678E29
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjAXCUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjAXCUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:10 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21A3135
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:09 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id e8so12065899qts.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=B1Sd3Sn+kd/B8aLE8AkmHdcDmfuVLL1F2WTozE9Gjy4Z0HeGY2SDVcyYkNdUQbdpnl
         Txpz1dbICFgHSvDX68xboKcSehfNS4IhKF26AtrGRUIcacZ3G7OfP5FQ7/ax6+zj4ZRi
         dWMw4OcEByhiG1GkAxIGEJSE86sQNID565zS2wqkjYUocWJOdXRvU7WScIQTZhF48Ycs
         2P6XvLOoRcF/wDxmBC5aQaRgioALb28y/nfJ/Ew4JseU63Fnr2QrpyKIngljzomhCbo5
         kt9bg9iXKKIdNj+SAZ7F1CpOZo5g9X8z0DbBtSfDL8pIXcoIC4IUwvgWw3Bl1vEgIst7
         WvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tl5Hvsf/bhbzo4TjITsPEwXtRmHZPlZaj/ryQGs8Zww=;
        b=1on3pBeNhxCCiQSZ/WXY94qFEkU89a/rZQnKUtaAC6STAyH0/+rwBu1YeuZ+5bNgjy
         YecHipBVeXmpNyaETRCpZKzPddyjqbghfprk/Xuu9X16oD0Q1aSfi3zKAOeyQN5LnYrS
         l0BCjWMubFIwK5qc8PRhq4Y9nNpw1bK5CT8c1s39PTf8w9AeNXZD7DjGlk1qpM8Q4www
         MUyNOJ9lb/iFIFx5PbG22DaSmv67zkFiZxRRj5LhBVIwY2/lz1seni2Xl3v0DOlTpwUG
         QSDYv1gTLNoHxm+9oDyohU27ZokPEIyBJcO/PFH9J3TF5WqZ01WyC5d4gYmTAWwrk+A+
         5ETg==
X-Gm-Message-State: AFqh2krGqmWkxyugwVOkBpFsF+90oz2yUQQe0/9GlXUxwc3bHeueax45
        AC4GrycpP9efgm2pp6kqpdDtcthg4sFDDQ==
X-Google-Smtp-Source: AMrXdXsZeqwpc78Kw7vz1mpC/d+qHO/ARsINRBeS5hghn0NVy8V0y9n+/D1iJktmao9v4rJVybxEsw==
X-Received: by 2002:ac8:6bc5:0:b0:3a9:6b48:a130 with SMTP id b5-20020ac86bc5000000b003a96b48a130mr36116146qtt.34.1674526808765;
        Mon, 23 Jan 2023 18:20:08 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:08 -0800 (PST)
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
Subject: [PATCHv2 net-next 02/10] bridge: use skb_ip_totlen in br netfilter
Date:   Mon, 23 Jan 2023 21:19:56 -0500
Message-Id: <728384880c6748d53512acd37eacc82794e71477.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
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

