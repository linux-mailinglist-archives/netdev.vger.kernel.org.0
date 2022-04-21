Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FB350AB3A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442375AbiDUWMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442357AbiDUWMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:12:06 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457004EDFF;
        Thu, 21 Apr 2022 15:09:15 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id x12so4296808qtp.9;
        Thu, 21 Apr 2022 15:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34XIV2T1kdRh88xIeEi+R8LLjXux+r8JN+NZehS/gPA=;
        b=J+NaAh2+JYKqgwb4AZSjTPz7DGAfj+DbRT67de9zSfaG8MchvY+Fq/v7XhE2fULGYr
         lWwXrh22P2SyMhSmdUvBDLoTzdyDTU+OAXjcowdHhJj+7SOqNcRVMvXHTbs4WR7QpuGk
         aEB68ywEgIJmqPDsaqjD1j8nWKtX0pbiT3SL2SD3/yPeGY6DVFu8/57DN4SpyJN6I3ff
         qhr/RYR8q3vvhQ7CoPt3+2TUS6hN6yu9kz3xLa4m/qtOJu11zJlyKeYEMTcg0TijJoDY
         KXo9GDg3CZCv3NVhV8AwQvN6DSRRt5kpk3YMZHee7oLU7vYeumOofzNWdrRIyGmfce7J
         k5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=34XIV2T1kdRh88xIeEi+R8LLjXux+r8JN+NZehS/gPA=;
        b=OucCvdp46TlWdys9fIzOveKDU9MJacphMYxku64LmJve0sWGQKwHZV1Lb2/I3RHIW5
         MU/Hwh/MRNaNqZj3v/k1083iW2SK30fWM1AKVDhAUJCSU7r5BYqSTipP2oEw/Uq7S4Vn
         S4Qy8uxWXx5pWJpatWq/GomjTYd1t/cjYYQI+qggqwB6fVulhbYXgMWnklGtwAVy4vn1
         oyUuBMIUwgu/Q7Jf1ihBuqwgdCBdv2vblhQwOc4yTIfqkof5DTPv+TDuKFGTPplzwygK
         cl1FU03NQ2sJuFNPl8+pHfRiBdsELBdHP3/OxmNmE993UIXX1FSQc/9xiR09935zqw9F
         RH9A==
X-Gm-Message-State: AOAM531Ug5HhKDSaKIelKg4/qQ0jvc36Oggo+rTCPnwfwSM7YpS2uy3f
        uDq/Dmjdg5RVGhQpB+RamQ==
X-Google-Smtp-Source: ABdhPJw0p6jBowr4Ig1lFO9TCZf4cE72S4F5SvwN7ekhku31YrUtGgjF/dTiNHTDQhSCXwmF+np8BQ==
X-Received: by 2002:ac8:764a:0:b0:2e1:bb5e:5ff3 with SMTP id i10-20020ac8764a000000b002e1bb5e5ff3mr1158932qtr.255.1650578954326;
        Thu, 21 Apr 2022 15:09:14 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id h14-20020a05620a21ce00b0069e8c2d2bd9sm98120qka.42.2022.04.21.15.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:09:13 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, "xeb@mail.ru" <xeb@mail.ru>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 3/3] ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode
Date:   Thu, 21 Apr 2022 15:09:02 -0700
Message-Id: <b606e0355949a3ca8081ee29d9d22f2f30e898bd.1650575919.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1650575919.git.peilin.ye@bytedance.com>
References: <cover.1650575919.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

As pointed out by Jakub Kicinski, currently using TUNNEL_SEQ in
collect_md mode is racy for [IP6]GRE[TAP] devices.  Consider the
following sequence of events:

1. An [IP6]GRE[TAP] device is created in collect_md mode using "ip link
   add ... external".  "ip" ignores "[o]seq" if "external" is specified,
   so TUNNEL_SEQ is off, and the device is marked as NETIF_F_LLTX (i.e.
   it uses lockless TX);
2. Someone sets TUNNEL_SEQ on outgoing skb's, using e.g.
   bpf_skb_set_tunnel_key() in an eBPF program attached to this device;
3. gre_fb_xmit() or __gre6_xmit() processes these skb's:

	gre_build_header(skb, tun_hlen,
			 flags, protocol,
			 tunnel_id_to_key32(tun_info->key.tun_id),
			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
					      : 0);   ^^^^^^^^^^^^^^^^^

Since we are not using the TX lock (&txq->_xmit_lock), multiple CPUs may
try to do this tunnel->o_seqno++ in parallel, which is racy.  Fix it by
making o_seqno atomic_t.

As mentioned by Eric Dumazet in commit b790e01aee74 ("ip_gre: lockless
xmit"), making o_seqno atomic_t increases "chance for packets being out
of order at receiver" when NETIF_F_LLTX is on.

Maybe a better fix would be:

1. Do not ignore "oseq" in external mode.  Users MUST specify "oseq" if
   they want the kernel to allow sequencing of outgoing packets;
2. Reject all outgoing TUNNEL_SEQ packets if the device was not created
   with "oseq".

Unfortunately, that would break userspace.

We could now make [IP6]GRE[TAP] devices always NETIF_F_LLTX, but let us
do it in separate patches to keep this fix minimal.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 77a5196a804e ("gre: add sequence number for collect md mode.")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 include/net/ip6_tunnel.h | 2 +-
 include/net/ip_tunnels.h | 2 +-
 net/ipv4/ip_gre.c        | 6 +++---
 net/ipv6/ip6_gre.c       | 7 ++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index a38c4f1e4e5c..74b369bddf49 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -58,7 +58,7 @@ struct ip6_tnl {
 
 	/* These fields used only by GRE */
 	__u32 i_seqno;	/* The last seen seqno	*/
-	__u32 o_seqno;	/* The last output seqno */
+	atomic_t o_seqno;	/* The last output seqno */
 	int hlen;       /* tun_hlen + encap_hlen */
 	int tun_hlen;	/* Precalculated header length */
 	int encap_hlen; /* Encap header length (FOU,GUE) */
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 0219fe907b26..3ec6146f8734 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -116,7 +116,7 @@ struct ip_tunnel {
 
 	/* These four fields used only by GRE */
 	u32		i_seqno;	/* The last seen seqno	*/
-	u32		o_seqno;	/* The last output seqno */
+	atomic_t	o_seqno;	/* The last output seqno */
 	int		tun_hlen;	/* Precalculated header length */
 
 	/* These four fields used only by ERSPAN */
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index ca70b92e80d9..8cf86e42c1d1 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -464,7 +464,7 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
 			 flags, proto, tunnel->parms.o_key,
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
@@ -502,7 +502,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 		(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
 	gre_build_header(skb, tunnel_hlen, flags, proto,
 			 tunnel_id_to_key32(tun_info->key.tun_id),
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
@@ -579,7 +579,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	gre_build_header(skb, 8, TUNNEL_SEQ,
-			 proto, 0, htonl(tunnel->o_seqno++));
+			 proto, 0, htonl(atomic_fetch_inc(&tunnel->o_seqno)));
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d9e4ac94eab4..5136959b3dc5 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -766,7 +766,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
 						      : 0);
 
 	} else {
@@ -777,7 +777,8 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 
 		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
+						      : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
@@ -1055,7 +1056,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	/* Push GRE header. */
 	proto = (t->parms.erspan_ver == 1) ? htons(ETH_P_ERSPAN)
 					   : htons(ETH_P_ERSPAN2);
-	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(t->o_seqno++));
+	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-- 
2.20.1

