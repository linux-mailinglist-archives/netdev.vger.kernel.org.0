Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D996D678E28
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjAXCUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjAXCUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:10 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868B91E5C2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:08 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id s4so12038549qtx.6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPo2A8/WyRg0uZtMgMrJXTBrF2bqp+xJsCXZ+utu8AQ=;
        b=ZMfL/2Xh2PEOlOGk4IFo6IZn46OkYJjNTB0TANE72KmzmqOkljaYISLsvf3IR05xXa
         qdZiIcml8gBlLPmZMb9obQKFtmW376CdcurqtLuILUu2RG0uKdUfnMHSIbDFATSiazJT
         yzRkkTVAemwR+LFdzfvKFcOgf/siJNjJa37tbZurFbypkikA5RpiHVicwzJYekgby16l
         7CNWqqGQxaeGQVZdStE41bXAkBJV7L1x+SB8UHa8SaIMwaUtTr8bE4iFAxbHfv3+LrUg
         5l1Fl+TF8LN6VSB+p2hJ1YVpaR6pAl5jEyPsjx7l3yCcqo1zSt6/nCjuzvtGF8jdFCzT
         MptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPo2A8/WyRg0uZtMgMrJXTBrF2bqp+xJsCXZ+utu8AQ=;
        b=AbS3upXWjHVQbIgNQIBwfNXYbrclMn0jU6lgoSG83NxllgFMB2KQwA9hB6saQWTDXm
         SkDyJu3xF5vBKKLi80xoP3sT/zSF7tKBiKMiaxBVFJJEa5dwAi31SaWvmuOMbuyiC/qH
         KgvedYSXJaPb75byVwBPJhw2T/uThkkt49bf0ZmpBbuG0IJkHq+EpERPqdAFIT6zlEtq
         ByCdEcCslfI6UuwVLvOBts/QiXBV7EOj432HujlZqyAfLf8t8xKHTZNThp9fH5QSMRf+
         DA/cGFudybC4KIdIfeU6xqWIxJcUa2UcQ+FqgGmBfDg0DSeZmbQaswUKvIB4EgtJV/kY
         pOOw==
X-Gm-Message-State: AFqh2krBduvujncKMT0lsbzPkHt62w1NCDECeSgDOtdlP6Dpqa6Df6vR
        GTDKBOZpXmlHrKBHQrriszvHFRzHrVXMsQ==
X-Google-Smtp-Source: AMrXdXuikjQTkbHsaYK0VBpUyeh6oFDWdf3Rl01C7uWJvKaanev4Lo1NKvlG6vO37GbrU4fYyMcIVQ==
X-Received: by 2002:ac8:5a95:0:b0:3b2:ea9b:76c5 with SMTP id c21-20020ac85a95000000b003b2ea9b76c5mr51636677qtc.41.1674526807555;
        Mon, 23 Jan 2023 18:20:07 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:07 -0800 (PST)
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
Subject: [PATCHv2 net-next 01/10] net: add a couple of helpers for iph tot_len
Date:   Mon, 23 Jan 2023 21:19:55 -0500
Message-Id: <da83e74da75923cd8a1366ab1cb122fd062173cc.1674526718.git.lucien.xin@gmail.com>
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

