Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C63F6AF7B0
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCGVbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjCGVbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:40 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E4AA4B1B;
        Tue,  7 Mar 2023 13:31:39 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h19so16050178qtk.7;
        Tue, 07 Mar 2023 13:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fj36irOffjBtbTZwkLkJGzRSUR+RtRBnfCPwNNGVcEE=;
        b=VgdfoIuD7BwThrOSqXcd+KSPirMxbTCYNmZrdkSvLrQwpoAxSWGJuUcJ9yxnUZiQNm
         RbmHt5cpabTylMm4yzzI+KmRqL7HCiBhY1HNauXcsY7cWuQqEb9U5ndzQsbHOepLeY6m
         XWJZKy9Dj7gviReOQIYIE55+qXZOSE3blXznTxwvYg4JiABsmsChfFlU9so+6Gx+Xr4Y
         0AX4zzM2AuCqt1fmdm4tG4uA2MtM2GGdxNG3WpwkZ/aTwFpD8ipXB+qnPZYfVzNi4MEq
         sw8ic0X81z+GuvdBFxXLkaVWMpOgWBwTxVlVXFjhpFbingObtUzfWvvK3afLnZOJUzIS
         JRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fj36irOffjBtbTZwkLkJGzRSUR+RtRBnfCPwNNGVcEE=;
        b=76e/Iopz8jPcqX0oyxn30NeK9+V/X2QQhoqv11LbZpTcKy4h2JZWMzUokupE398J4F
         GUJZ/3DhG7mxDfmJhC7ifKNO+xsMyQ7RUe23AoClQlObRR39tyV7rmelIPHxfs5taU+i
         NI0YLfu9SRYjATe38fW+dhCnU0YSdiAO/zKEMpOb95xYCrz5eBCCmm+OwcJskCr0WESe
         B+Bnwlf09jih+dwqa3iZ0T46+mK7x38i87Bp8zTs43yyoKGkpyypHV3ipPlSH9kby6ns
         PJvjrKkZU69ej8FsisO+0QAQ74GYxby3eCcZ8tCw2ewUfalegKfPqD08ncp/7le588EU
         Su0w==
X-Gm-Message-State: AO0yUKVTt+KkyxI5xVwIbU/t8TNMx2hGuQPK5a+sliKUR5oqz+8GEQdB
        HJVzijnOQUNeHY4l9Z0q2juSLhKQhxTDCg==
X-Google-Smtp-Source: AK7set+5LA0jjO71Q8C9O/tT0jz8NCc4D/FSc/rfOVb3lKD6dYxgAbn1+Ru7++sQSWbjU3DXm4tcJg==
X-Received: by 2002:a05:622a:489:b0:3b8:340b:1aab with SMTP id p9-20020a05622a048900b003b8340b1aabmr25172765qtx.25.1678224699195;
        Tue, 07 Mar 2023 13:31:39 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r125-20020a374483000000b006fcb77f3bd6sm10269329qka.98.2023.03.07.13.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:31:38 -0800 (PST)
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
Subject: [PATCHv2 nf-next 5/6] netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
Date:   Tue,  7 Mar 2023 16:31:31 -0500
Message-Id: <f3071ca25fd9f99d3c9b3d50267cb6ea47c25faf.1678224658.git.lucien.xin@gmail.com>
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

For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
length for the jumbo packets, all data and exthdr will be trimmed
in nf_ct_skb_network_trim().

This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
of the IPv6 packet, similar to br_validate_ipv6().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
---
 net/netfilter/nf_conntrack_ovs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index 52b776bdf526..068e9489e1c2 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -6,6 +6,7 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/ipv6_frag.h>
 #include <net/ip.h>
+#include <linux/netfilter_ipv6.h>
 
 /* 'skb' should already be pulled to nh_ofs. */
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
@@ -120,8 +121,14 @@ int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
 		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
-		len = sizeof(struct ipv6hdr)
-			+ ntohs(ipv6_hdr(skb)->payload_len);
+		len = ntohs(ipv6_hdr(skb)->payload_len);
+		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP) {
+			int err = nf_ip6_check_hbh_len(skb, &len);
+
+			if (err)
+				return err;
+		}
+		len += sizeof(struct ipv6hdr);
 		break;
 	default:
 		len = skb->len;
-- 
2.39.1

