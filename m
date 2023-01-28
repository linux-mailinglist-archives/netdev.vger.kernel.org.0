Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8567F959
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjA1P7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbjA1P64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:56 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849FC34004
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:48 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id h10so6026542qvq.7
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afll7bLWeOuZyip2GcygUZAanANAFhqpn9H/tM0HPJw=;
        b=BqdJ/5mEF8oUUpZogDzr1K5mgTgs48Yo0Rj3mHMzT/zAua9RX9pJ+RC+C4ZLz4wBwq
         QYDRx58aaTJFedlx42a+v7yMUGy8F6QjZOuLfloB4G+cxZsCpnJEzrO3imbcKLiFxo1b
         KkIdoRoeL734nlnsBRxAn6g5YCqLuHckpU5r99x7eMWbAPg0/8NemBkhpvC2ZH1B9nUW
         hRBcn2s8scIyQ+QfdgJ8x47GT1g1iGR7WX58yFJA5mrWldwqPqz+C2CiwYFeTJM8EgPa
         Er5abkY/UmMDxr3/sp9mwQL1SbFvDBQMQcQgTuYjMCjGWQUAmmEjJcyI0FYdKEyR0RyG
         uSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afll7bLWeOuZyip2GcygUZAanANAFhqpn9H/tM0HPJw=;
        b=zim+L3ShjeyKvb8TnDLZET+CbNRtw/7ZmzQgyieoyojJ1FcVPEItgxc31bo5h+wu8y
         gT4qGPcTG5uKhJdqXQtkcdTr+/px/S0IW0K0Gh5Y1dVGnzudu/28G565RLQlBojDAgzY
         rl01G5MLQqsrz2NijWNfNylyTr7GIB00H6LwLFJYbMmwv15b89MScfzXmDa2dmnVn5OT
         E0AOmYyLsCe6xcTEfNYs34ydVWOqu283M/ZWRMD3H9t5YwPM7fLpb8MfHLSBJRC8ITzP
         2x7fnalAQpnMvMS8Jg1gN+GvB228Q4I2PcWPx6wjl0R+d1K4US/aVVZEOhcYWqkoAj3d
         cxYw==
X-Gm-Message-State: AO0yUKWJzdmlnm9sTRCKLAPIln4gT0XLFUA0evQ6T6zqzzz8/n4EVN0n
        J5ijxXAndJJChfEOMBR30qD9V/RW+YuZ7w==
X-Google-Smtp-Source: AK7set/4446tGgKk1iqaIgcO0sfcOe/L+gLaqKr0izoKaFC7YQRSfeKEvluA6+j1fu7lluTKm8VWMQ==
X-Received: by 2002:a05:6214:1d09:b0:534:bcba:13f2 with SMTP id e9-20020a0562141d0900b00534bcba13f2mr4211629qvd.51.1674921526902;
        Sat, 28 Jan 2023 07:58:46 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:46 -0800 (PST)
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
Subject: [PATCHv4 net-next 05/10] netfilter: use skb_ip_totlen and iph_totlen
Date:   Sat, 28 Jan 2023 10:58:34 -0500
Message-Id: <4a0907aff980537af36aafb49291049ecde89f27.1674921359.git.lucien.xin@gmail.com>
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

