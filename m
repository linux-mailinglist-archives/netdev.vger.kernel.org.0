Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D140C66A8F5
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjANDbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjANDbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:40 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482AF8B772
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:39 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id y7so2197297qtv.5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0xNdytxS8CDoLqiLtfyZpaU170syQa6Cetm8SyHT2g=;
        b=l/ZPdTVsatsN83o81h5awCH+ocGFMzDMwEAql6FSBEfPi0Tdm3b+DDDNEc0ZIYo1Xb
         RSl7ZxtRuGL/fXd9mVrjB/TCcdRdByUUQmfWAGOulvwOf7jyA9gRdrw08cERt3gLU6q7
         4cyroyMUKUWrK5Q3KuIlBWu1psHAfJUok6XKM1lQ0z+t5itWjcyjMo2ORtbkHggYbFX7
         zUN+DueLmZ6Q1GWLb+/byKR1NoVMI3UE0Q6GJlpU/cUfVlKwFQW0tTDClbYqGi6inldk
         //RCO0KweJJb+dOGavrsEYSguHo+qKMCWedjPn+53rMv3qE21hHLIzSRxs2aYDOQSQ4a
         5BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0xNdytxS8CDoLqiLtfyZpaU170syQa6Cetm8SyHT2g=;
        b=1C4NOm3BydnsyOLq+vOy1ibRs5YryY5LH5a4AeqlndHGmcm6AtR8jEnRbXWLbQkXQf
         v6HYmw1d3tLPepV45A4z8wGN9FgAYk5eYUk8OgIBLk+vmidaL0P6xxxBhEy5Z/ZB8Xsr
         fDD8GoV9+ml5MYL42Qb4RuD2w4NiMrGeKvmVQ8YDgHMLeDJmU74cUvmeD7L+UyzxBb7v
         cN+LXxyLZVG3h8LgUoUQCPWCve4iCwsRF29fVI6hLwnLtieloTvleSCYekvOR3vMx3ED
         nqpP/hWkmujVBXnGloZ7wCxE3qCfFrGEN/z0/Vgm/10Mjt0ldRSP2+97f3V3kVQjFazb
         B6sQ==
X-Gm-Message-State: AFqh2kp6MPzXqWMF6w0Mu8bl+ZzQjJmipnPshbtDG/8Owws5K0Vf+M4I
        DKQu+CH5cHyDagxnYbPtwonhZyXNoqZfnA==
X-Google-Smtp-Source: AMrXdXvVSijXq82lbaglMzeLrs6H6dJw4ZLH+qphfWnHSNrovnhEXQpgyYN9CQ2aKBE/MZacifnspw==
X-Received: by 2002:a05:622a:8c8:b0:3ae:2272:e430 with SMTP id i8-20020a05622a08c800b003ae2272e430mr30470465qte.14.1673667098091;
        Fri, 13 Jan 2023 19:31:38 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:37 -0800 (PST)
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
Subject: [PATCH net-next 01/10] net: add a couple of helpers for iph tot_len
Date:   Fri, 13 Jan 2023 22:31:25 -0500
Message-Id: <2cf21684e03a316b453f05c06ce73a262b1897b4.1673666803.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
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
 include/linux/ip.h  | 20 ++++++++++++++++++++
 include/net/route.h |  3 ---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/ip.h b/include/linux/ip.h
index 3d9c6750af62..53a0bf5d3f06 100644
--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -35,4 +35,24 @@ static inline unsigned int ip_transport_len(const struct sk_buff *skb)
 {
 	return ntohs(ip_hdr(skb)->tot_len) - skb_network_header_len(skb);
 }
+
+static inline unsigned int iph_totlen(const struct sk_buff *skb, const struct iphdr *iph)
+{
+	return ntohs(iph->tot_len) ?: (skb_is_gso_tcp(skb) ?
+				       skb->len - skb_network_offset(skb) :
+				       0);
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

