Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A667EA31
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbjA0QAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjA0QAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:08 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EEE84FB8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:05 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id o5so4332539qtr.11
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afll7bLWeOuZyip2GcygUZAanANAFhqpn9H/tM0HPJw=;
        b=AdxHxAREE2gWG+0qLgobJuWXZHf3oqb+0jSTD9SmCNEExf6jR0tRORXDal218fXDGk
         TBHDVGttXMCAtJxK+q+pJv54GdZEbdaDSEQ+RjSyCzIJLUqzEIveZq8hQPbUYHQnHYSX
         z2LVgqVJC10tTa2l5FiQW4Ck8s65PLldSu2qAx6mPEPlpdW042ZSGYjhrVrv/4o7a5uw
         AI3lvL1UoMbeJgVAJ9IFSQqHscG5Tb51sL5E4PnLtI3GKAsQ4UQYDVroapqqDsdBJGbu
         segONwPLOoWHk1Eeib315Y0EPXScfaUAwl8TifKoHolrL9DPN5UlkbPmGBJz/Ng5Z2nw
         ECcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afll7bLWeOuZyip2GcygUZAanANAFhqpn9H/tM0HPJw=;
        b=EXfSgWH7WDZI7uhUAFrUageaxsrfBKeILW4JNtXa0R2+pBXhj1K2Yg18HgRMvtj9i+
         E5qHCQylfiFNeUDeMbOuV9Bsdm4kSg8j9w1EgicKPAWHht8aWypxDNMuaJxuJHUgKJTO
         bxNv9AXK619+qfmdKsXnc87uOQ3hZzwAQrQ/gSPb5Gyk3WLjPfnXKsDMBMVeS/J4w7uv
         1Sfpp7dn+WqGq0+yRb/DX6+hxMdHvtDh4oSpbyWfkmUmuIaR9DPapwX+8d8Rxx4witMg
         U+sxNnhr5NX4NRuyVaK2s2IwzqNpN+mWPDjOjXLMSjUqLMNLOmLpfkcXlvIkgc7a2bHv
         Uzcg==
X-Gm-Message-State: AFqh2kp9p54oyHixU7cRWLtCTXjGLzh6JP0MIDcV4b0mBpjH5nrgmKOy
        BbpBdIHUYvQ1xJ2M9t5fPbc7QIML95WkEw==
X-Google-Smtp-Source: AMrXdXtbtfLmpG1UL9ECV7M8vR4TbZooJIrl2VQnS0VVtOtUmj/OaNnpDeMYjC+dAjsD+1i1TaK0Zg==
X-Received: by 2002:ac8:6a0f:0:b0:3b1:691f:3d7a with SMTP id t15-20020ac86a0f000000b003b1691f3d7amr54695739qtr.68.1674835204436;
        Fri, 27 Jan 2023 08:00:04 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:04 -0800 (PST)
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
Subject: [PATCHv3 net-next 05/10] netfilter: use skb_ip_totlen and iph_totlen
Date:   Fri, 27 Jan 2023 10:59:51 -0500
Message-Id: <01124636f6f251be439cb4e048a66e8f5f11d31d.1674835106.git.lucien.xin@gmail.com>
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

There are also quite some places in netfilter that may process IPv4 TCP
GSO packets, we need to replace them too.

In length_mt(), we have to use u_int32_t/int to accept skb_ip_totlen()
return value, otherwise it may overflow and mismatch. This change will
also help us add selftest for IPv4 BIG TCP in the following patch.

Note that we don't need to replace the one in tcpmss_tg4(), as it will
return if there is data after tcphdr in tcpmss_mangle_packet(). The
same in mangle_contents() in nf_nat_helper.c, it returns false when
skb->len + extra > 65535 in enlarge_skb().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_tables_ipv4.h | 4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c        | 2 +-
 net/netfilter/nf_log_syslog.c          | 2 +-
 net/netfilter/xt_length.c              | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 112708f7a6b4..947973623dc7 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -29,7 +29,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	if (iph->ihl < 5 || iph->version != 4)
 		return -1;
 
-	len = ntohs(iph->tot_len);
+	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
 	if (pkt->skb->len < len)
 		return -1;
@@ -64,7 +64,7 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 	if (iph->ihl < 5 || iph->version != 4)
 		goto inhdr_error;
 
-	len = ntohs(iph->tot_len);
+	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
 	if (pkt->skb->len < len) {
 		__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INTRUNCATEDPKTS);
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 029171379884..80448885c3d7 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -994,7 +994,7 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
 		old_dsfield = ipv4_get_dsfield(old_iph);
 		*ttl = old_iph->ttl;
 		if (payload_len)
-			*payload_len = ntohs(old_iph->tot_len);
+			*payload_len = skb_ip_totlen(skb);
 	}
 
 	/* Implement full-functionality option for ECN encapsulation */
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index cb894f0d63e9..c66689ad2b49 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -322,7 +322,7 @@ dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 
 	/* Max length: 46 "LEN=65535 TOS=0xFF PREC=0xFF TTL=255 ID=65535 " */
 	nf_log_buf_add(m, "LEN=%u TOS=0x%02X PREC=0x%02X TTL=%u ID=%u ",
-		       ntohs(ih->tot_len), ih->tos & IPTOS_TOS_MASK,
+		       iph_totlen(skb, ih), ih->tos & IPTOS_TOS_MASK,
 		       ih->tos & IPTOS_PREC_MASK, ih->ttl, ntohs(ih->id));
 
 	/* Max length: 6 "CE DF MF " */
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 1873da3a945a..b3d623a52885 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -21,7 +21,7 @@ static bool
 length_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
-	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
+	u32 pktlen = skb_ip_totlen(skb);
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
-- 
2.31.1

