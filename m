Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567706AF7B6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCGVbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCGVbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:40 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D27A5692;
        Tue,  7 Mar 2023 13:31:39 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id c18so16071992qte.5;
        Tue, 07 Mar 2023 13:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxcuzOHps6XE85Z991hXn4nkBNrmr2smZxk/EhnEOzA=;
        b=bRqT8Ak0aHQDDQRqTzfWwKxrvM2oTRzRqiboHYbj020VmMl9ySibzoCe/6fwqe7dm7
         iP5W8BvJSKfJznIH0y8Yks7O+9KlssR96gS49S77yed8c5z9ARh56MPKSLFAt4qYTj0e
         RHU/ejG1dhMAIWksMa2pujIy9taCHjuiqtwrNER9Ktx13Dnt7dKf49bEyx0wcTI2nYC+
         V/yGhFRvyd5SvQQYyGIZD9tFDwBWZ/bQIfvymKVG0C5rr3gy9k9p4NKdosepUb1Fg019
         Tq+VgfjnAm6P1fW5OxhVRGGBOHMmq9P0F4HeS3d7/llXO4RXehk2hYyBwThixflDDrQR
         Jc+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxcuzOHps6XE85Z991hXn4nkBNrmr2smZxk/EhnEOzA=;
        b=Wbn6SEKEY/BH2oaggpTwoqEeXi/fv1auq4mzraPd/UVTzvSIvldFboaQniSu+DkHyA
         TktjPJfMhhbj+5a1s2V2XF/gQzT0JFeSoQ7lhrw6oaucHnAnntnpbFCc2nGha/AsdPbF
         oVNM1tZrTKnmMzKD9F6LyZ+J1ek1D1JEytGRgsozEceyKeySB4Wmcb+t8aniNHoscYJC
         UMYQD2wW+ZwoDaXKyF4vNj/Lz1kC0RuzIAMiQYbVMWdo6H/L+STbSUXWOdacIl7dHE2c
         5VwuLmYOPGAlvHfQLXvNQ/717XpHPNf+vOv+wAfic6K/5hbcn/dBfbekUPmeR3jAcXS9
         MreA==
X-Gm-Message-State: AO0yUKWdZFuntaa+eRPkAxmZFmkUgXIbSYobtD724WdkYHPcVmpRHlvy
        SrxbN5k0breHMd8TMRPI/nCfIuPuz9LE2g==
X-Google-Smtp-Source: AK7set+fkHHjLeN99hOMYpB784xMMehvRosINp6/u31qVerQO95y8xzrhKbE7Rw6noc9whfGwSXHCw==
X-Received: by 2002:a05:622a:409:b0:3bf:d35d:98c0 with SMTP id n9-20020a05622a040900b003bfd35d98c0mr27896674qtx.29.1678224698080;
        Tue, 07 Mar 2023 13:31:38 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r125-20020a374483000000b006fcb77f3bd6sm10269329qka.98.2023.03.07.13.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:31:37 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 nf-next 4/6] netfilter: move br_nf_check_hbh_len to utils
Date:   Tue,  7 Mar 2023 16:31:30 -0500
Message-Id: <bbd0a919e878b402935720d73e1ad25469b57d3b.1678224658.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678224658.git.lucien.xin@gmail.com>
References: <cover.1678224658.git.lucien.xin@gmail.com>
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

Rename br_nf_check_hbh_len() to nf_ip6_check_hbh_len() and move it
to netfilter utils, so that it can be used by other modules, like
ovs and tc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
---
 include/linux/netfilter_ipv6.h |  2 ++
 net/bridge/br_netfilter_ipv6.c | 55 +---------------------------------
 net/netfilter/utils.c          | 52 ++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 48314ade1506..7834c0be2831 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -197,6 +197,8 @@ static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
+int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen);
+
 int ipv6_netfilter_init(void);
 void ipv6_netfilter_fini(void);
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index a0d6dfb3e255..550039dfc31a 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -40,59 +40,6 @@
 #include <linux/sysctl.h>
 #endif
 
-/* We only check the length. A bridge shouldn't do any hop-by-hop stuff
- * anyway
- */
-static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
-{
-	int len, off = sizeof(struct ipv6hdr);
-	unsigned char *nh;
-
-	if (!pskb_may_pull(skb, off + 8))
-		return -1;
-	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
-	len = (nh[1] + 1) << 3;
-
-	if (!pskb_may_pull(skb, off + len))
-		return -1;
-	nh = skb_network_header(skb);
-
-	off += 2;
-	len -= 2;
-	while (len > 0) {
-		int optlen;
-
-		if (nh[off] == IPV6_TLV_PAD1) {
-			off++;
-			len--;
-			continue;
-		}
-		if (len < 2)
-			return -1;
-		optlen = nh[off + 1] + 2;
-		if (optlen > len)
-			return -1;
-
-		if (nh[off] == IPV6_TLV_JUMBO) {
-			u32 pkt_len;
-
-			if (nh[off + 1] != 4 || (off & 3) != 2)
-				return -1;
-			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
-			if (pkt_len <= IPV6_MAXPLEN ||
-			    ipv6_hdr(skb)->payload_len)
-				return -1;
-			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
-				return -1;
-			*plen = pkt_len;
-		}
-		off += optlen;
-		len -= optlen;
-	}
-
-	return len ? -1 : 0;
-}
-
 int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
@@ -112,7 +59,7 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 		goto inhdr_error;
 
 	pkt_len = ntohs(hdr->payload_len);
-	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
+	if (hdr->nexthdr == NEXTHDR_HOP && nf_ip6_check_hbh_len(skb, &pkt_len))
 		goto drop;
 
 	if (pkt_len + ip6h_len > skb->len) {
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 2182d361e273..acef4155f0da 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -215,3 +215,55 @@ int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 	}
 	return ret;
 }
+
+/* Only get and check the lengths, not do any hop-by-hop stuff. */
+int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen)
+{
+	int len, off = sizeof(struct ipv6hdr);
+	unsigned char *nh;
+
+	if (!pskb_may_pull(skb, off + 8))
+		return -ENOMEM;
+	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
+	len = (nh[1] + 1) << 3;
+
+	if (!pskb_may_pull(skb, off + len))
+		return -ENOMEM;
+	nh = skb_network_header(skb);
+
+	off += 2;
+	len -= 2;
+	while (len > 0) {
+		int optlen;
+
+		if (nh[off] == IPV6_TLV_PAD1) {
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			return -EBADMSG;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			return -EBADMSG;
+
+		if (nh[off] == IPV6_TLV_JUMBO) {
+			u32 pkt_len;
+
+			if (nh[off + 1] != 4 || (off & 3) != 2)
+				return -EBADMSG;
+			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
+			if (pkt_len <= IPV6_MAXPLEN ||
+			    ipv6_hdr(skb)->payload_len)
+				return -EBADMSG;
+			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
+				return -EBADMSG;
+			*plen = pkt_len;
+		}
+		off += optlen;
+		len -= optlen;
+	}
+
+	return len ? -EBADMSG : 0;
+}
+EXPORT_SYMBOL_GPL(nf_ip6_check_hbh_len);
-- 
2.39.1

