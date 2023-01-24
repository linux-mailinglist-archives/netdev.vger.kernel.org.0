Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8378E678E2D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjAXCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjAXCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:20 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0494A3ABF
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:13 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id e8so12065990qts.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afll7bLWeOuZyip2GcygUZAanANAFhqpn9H/tM0HPJw=;
        b=NCSM/nCddVqSbHVq59s6SZXXC9Kl4BORKs8X/LeQM0rTRcbo1D/h+ka2I4vMVTBg43
         CFeUuvws6zurLEdIeRQnJTFx8x46ia3BCSLM/KhafO+sjd7aE7SZIBjj2pNMPn/xxZ3v
         4mBqz1bqzJFspa5p60fNoa3+oV+xDFIKJdAKO9JzxLytHwT73XPpQd+M/Qk5ZOsO7zJb
         kJaS9TKmnZDk/B7zyOpieOhxvdQECl7eCSMnie9l1fmW/lcgKjsJLUqi13bV5AuKKATj
         SPnIL++4i9Alcm5yf6plrH8PicB4JMfCyH/jiKejQaCdNceqZlCuTiSudAH7eN/hOI0E
         1v1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afll7bLWeOuZyip2GcygUZAanANAFhqpn9H/tM0HPJw=;
        b=hyoJ0ZV2qZ5WqkikfHBvEyZYzYnrMqqmJ89hXwTorX8tmi0A3rp5bjGxicuWcziNU8
         FTBiMqgKTbe38zfgXZhzO8gEdd/lbkr4cWE7569lYvf1m6UFIcbmmTLJ1WwneuA8/I6e
         Afer1ddE3d28RRbVQnF2xk5AMAi5hWw8YOgzytyJHeq/6ZsnZGxxTe8RgUwUWNRxwKRA
         MFw7Og9GNGLCOt/bPMr+XXVEBq3Wf3ojkxSxGk2iW/AMDQyRhoQilvDfVVSzeQ2ObGRz
         JbaMoY9dIXm0ZMZPKtbXtZs/MSuxqePwA0pm4cc4xa72Ewo+QZ6fbzz0C8pc+iXqjCJ/
         8yTA==
X-Gm-Message-State: AFqh2kqayY8aepwrd1YFe+E0LcPa2fJYKhIe6b0v6rtMALyYJFZ0pccv
        cTR9NFwgkPO9bmuiU+NwTASCXEEwESWDhg==
X-Google-Smtp-Source: AMrXdXvhPLcE0SmJkUWJZ9ZCUfqvRwH0Lb23xrHHc+jXSpgmgBZuaBYV18PZgv/Kxu5lCoO/rWurXQ==
X-Received: by 2002:ac8:4d09:0:b0:3b2:ae67:97f8 with SMTP id w9-20020ac84d09000000b003b2ae6797f8mr33904840qtv.44.1674526812529;
        Mon, 23 Jan 2023 18:20:12 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:12 -0800 (PST)
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
Subject: [PATCHv2 net-next 05/10] netfilter: use skb_ip_totlen and iph_totlen
Date:   Mon, 23 Jan 2023 21:19:59 -0500
Message-Id: <763f395823bfe6a655f48a45eec6c565436dd3fc.1674526718.git.lucien.xin@gmail.com>
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

