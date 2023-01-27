Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0967EA29
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbjA0QAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjA0QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:02 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4BA7F6A9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:00 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id x5so4358283qti.3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPo2A8/WyRg0uZtMgMrJXTBrF2bqp+xJsCXZ+utu8AQ=;
        b=n0eBLaQ0piq5nQS2gFn1vaSPymqbYNahrFzNETi2aRVELLQ8l+AJqYn8Za9kCuixqZ
         0nVSlnrHZ5hVO+O3kkr8Zb/ysV9uhyLTbjdVvLZSyanV6Jpz0yH76iYFTBMB40WnMWpe
         CkhG7XdIztW7dLeaSciQ+eVjELBcf6nEGhXiCEZMvWArBo8YWOltt5qOIVlDN6Ct2bUd
         A0YFTMLZuDe+1pEqjg3URq7sjeJ5vTxJC3TwctIguxyP3gQytbk6EgAdz7VuZPet5kZE
         3ibUchqzXqbvS3Aflx09T8XvqiK1mRW/I/Ld8M0k27bpJrrcIe1GKBR8egQWh7onAHye
         ReLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPo2A8/WyRg0uZtMgMrJXTBrF2bqp+xJsCXZ+utu8AQ=;
        b=o5ZjFMHwSgh5FvN+AEKiwLzJz+aIHmBTTQQY8UB8nTcJ1PusnwkjpbS8+SmFHoPAnq
         w2qhmoqdt2hs2PF5kqAMDtmI8OGi9T+brAF3zoJDs1+K8QQWuCGCu9aZzF70Mw0KO0k+
         Kcx1RJ2U5HdwzjjAo7tu5OIgi8PuzdI8CWtyTK79XSLPNxQrqk0lncZ2pbW/B3qHSLcM
         aAqBrpDOkyNxQhPF0Qcwn8UFzHsCT8wPxQFxLHZHpQBGfWDDPJKT25jUV07WPnRcrIKK
         nao2krdOfb1C64EMCPATSuRXYrlJp/BovU/mrWbljyQ7LM0GIbU4COfma/Pt5XOc6iW4
         hoTw==
X-Gm-Message-State: AFqh2kqS6qtC90Xds6+sj7Rl9jZoyehdAnpDTQz0lWFDOrUjRb0ZHzhf
        3wUt9J7T/v5k6RfPmFLNciERKzyt0cJmWQ==
X-Google-Smtp-Source: AMrXdXvrC8d6CyKufeUaRQQGyPTcu28uAVcfbmnBXC/w7zvZKDp6tghu2kUn9tld0Kvg+J0iTApTqw==
X-Received: by 2002:ac8:7312:0:b0:3ab:7bb3:4707 with SMTP id x18-20020ac87312000000b003ab7bb34707mr50654709qto.64.1674835199731;
        Fri, 27 Jan 2023 07:59:59 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.07.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:59:59 -0800 (PST)
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
Subject: [PATCHv3 net-next 01/10] net: add a couple of helpers for iph tot_len
Date:   Fri, 27 Jan 2023 10:59:47 -0500
Message-Id: <520630e418a95e6085b7c7399f9741570af82079.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
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

This patch adds three APIs to replace the iph->tot_len setting
and getting in all places where IPv4 BIG TCP packets may reach,
they will be used in the following patches.

Note that iph_totlen() will be used when iph is not in linear
data of the skb.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/ip.h  | 21 +++++++++++++++++++++
 include/net/route.h |  3 ---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/ip.h b/include/linux/ip.h
index 3d9c6750af62..d11c25f5030a 100644
--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -35,4 +35,25 @@ static inline unsigned int ip_transport_len(const struct sk_buff *skb)
 {
 	return ntohs(ip_hdr(skb)->tot_len) - skb_network_header_len(skb);
 }
+
+static inline unsigned int iph_totlen(const struct sk_buff *skb, const struct iphdr *iph)
+{
+	u32 len = ntohs(iph->tot_len);
+
+	return (len || !skb_is_gso(skb) || !skb_is_gso_tcp(skb)) ?
+	       len : skb->len - skb_network_offset(skb);
+}
+
+static inline unsigned int skb_ip_totlen(const struct sk_buff *skb)
+{
+	return iph_totlen(skb, ip_hdr(skb));
+}
+
+/* IPv4 datagram length is stored into 16bit field (tot_len) */
+#define IP_MAX_MTU	0xFFFFU
+
+static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
+{
+	iph->tot_len = len <= IP_MAX_MTU ? htons(len) : 0;
+}
 #endif	/* _LINUX_IP_H */
diff --git a/include/net/route.h b/include/net/route.h
index 6e92dd5bcd61..fe00b0a2e475 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -35,9 +35,6 @@
 #include <linux/cache.h>
 #include <linux/security.h>
 
-/* IPv4 datagram length is stored into 16bit field (tot_len) */
-#define IP_MAX_MTU	0xFFFFU
-
 #define RTO_ONLINK	0x01
 
 #define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
-- 
2.31.1

