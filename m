Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D816AA627
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCDAM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCDAMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:51 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE55227AF;
        Fri,  3 Mar 2023 16:12:50 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id l13so4863998qtv.3;
        Fri, 03 Mar 2023 16:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYWAYiusa6VD7bjKhgAG8p39BgVNjOvNfptsOrDP/rY=;
        b=gEXt2Uya0ndh+iJwuLZaCVgy37CPQ/RrYxtyO3Ie9OWYTEXOo3qHb/7Lc9VgTElzx9
         6QLBE8q4vLfjiFufRajjEq7oIZQ//fsKdWlOwdVheMrhsMVtv9E6e6OkfEk1Fu+UZ0sf
         S8NF/n8ESXMUEkODGRhBIpOVaNVx9fUtzK0qwHNCko5S3fAheKzLCGiq5Tmx0jSl47Uw
         XuuJTJUkyIvJ9noLnH12JyGjJVkce7qbSdK5gq56bhspluHJ+xIfTEPLbbDdPt1L8jbi
         b76hAqIxn7WUA9ZlymPs1Zhn9Lj1VvEpQWmD+v025xx4N4fftrygJ88qVu4S1PAKiB2o
         DfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MYWAYiusa6VD7bjKhgAG8p39BgVNjOvNfptsOrDP/rY=;
        b=QdTnVU3tSf1jbVz1rKhrMNMaBf53Re99Ayp7tzw2X1n1VjKv9B0E5c6LKWQ9SvOXtR
         l2AQp3443gw6+49vzXU6h/B1nBni0ILefJFuXPVJRIEgivhOolDIbxXl/vw+1As6Kg8n
         oNr+jKlADNf3s/Vx7jtYa02S1Vry+d6x96I53iZBjyeDKoTumIk6ymU9CnGqv6eDI6PI
         Qt4KExLKHfFbO1NHDVxQi4UhHhIl5KzAGmiz86NQcgwd8KvvaVmLbojd828TVx+8utdY
         HoyFeFyLWantLPAcgAQLjd6AsGWBR6XuBlYhDIlLgwe7zKFkh02n+yeEdd1Gd0sxCWn3
         j9jg==
X-Gm-Message-State: AO0yUKUeLtr5k2AzZs33PapUDUAaFwQxVpvoqxFXgOqQ5I1diA5wT8or
        znpLcxK4R2njD2URwTFolJxsmNuNpWVFRQ==
X-Google-Smtp-Source: AK7set/fADldKyETJnFbkmCncvyo6n3bpQFZW0XezopmYbweRmZ5sVPCKK3aUmMb8x8OWnfvErKdOg==
X-Received: by 2002:a05:622a:1a86:b0:3bf:c355:9ad4 with SMTP id s6-20020a05622a1a8600b003bfc3559ad4mr6688740qtc.34.1677888769173;
        Fri, 03 Mar 2023 16:12:49 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:48 -0800 (PST)
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
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 5/6] netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
Date:   Fri,  3 Mar 2023 19:12:41 -0500
Message-Id: <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677888566.git.lucien.xin@gmail.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
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

For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
length for the jumbo packets, all data and exthdr will be trimmed
in nf_ct_skb_network_trim().

This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
of the IPv6 packet, similar to br_validate_ipv6().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nf_conntrack_ovs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index 52b776bdf526..2016a3b05f86 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -6,6 +6,7 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/ipv6_frag.h>
 #include <net/ip.h>
+#include <linux/netfilter_ipv6.h>
 
 /* 'skb' should already be pulled to nh_ofs. */
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
@@ -114,14 +115,20 @@ EXPORT_SYMBOL_GPL(nf_ct_add_helper);
 int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
 {
 	unsigned int len;
+	int err;
 
 	switch (family) {
 	case NFPROTO_IPV4:
 		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
-		len = sizeof(struct ipv6hdr)
-			+ ntohs(ipv6_hdr(skb)->payload_len);
+		len = ntohs(ipv6_hdr(skb)->payload_len);
+		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP) {
+			err = nf_ip6_check_hbh_len(skb, &len);
+			if (err)
+				return err;
+		}
+		len += sizeof(struct ipv6hdr);
 		break;
 	default:
 		len = skb->len;
-- 
2.39.1

