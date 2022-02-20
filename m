Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BDA4BCFAE
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 17:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244269AbiBTP7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:59:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbiBTP7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:59:18 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146FC43AFE;
        Sun, 20 Feb 2022 07:58:57 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so603154pjb.0;
        Sun, 20 Feb 2022 07:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n6gvWaFKwJ4c00qvrbIyVU2QHYUO7UdYkobNiYVL6FU=;
        b=Wd+miKXq1iMzYA2L5WBFCJ9m3Z1paX2px5Te9c3iCwlYXcKiK2eGa6eRNkYpQI5oiP
         IKQkpxLbxzJglW5/6JJPcXsGA3MPRN2+HtJdZTF/7KtV44KXgpOCw+VvuMXn/q/xPLSc
         MRy3aVpFXTVQ0c9dPg/jxt8BiXZ0v/4gb13GGFB4rifD95U7LbNP6fQTp0VaHXqAqJhQ
         Za1JOGYS0IaF4NBeYqRr1hQImfnsvgdCTfDAesrADVHgVOWPxyjLB3sQVzcpHCL+PwhX
         nyJuWh7YtywpLVKVWU1Lek0Bss2hwTYn6Z3GRMEl/YeyVi6GemgKRd6gSo5XgtiorTw/
         7LEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n6gvWaFKwJ4c00qvrbIyVU2QHYUO7UdYkobNiYVL6FU=;
        b=m94Hlpc6uF/SC49bcH8fRoCFW7XJbOou8bOiT4YgER8700WooY2zugG/9ZcfdfzhQb
         NJT/6eCp4wpaurflMkcE3EW2E0xp9necKzb0mSvFMk3CvSbPJDFfZQp8yOoqJTx+hU0f
         TzZPG6cUPJjVXxsf8MrEtuqb5v6Qd6x1ds2NMFxCoKxa8Vo61bwjrCLXDCUeDeufcUCM
         X0hRY2mJcdBFTKAyuoct2iYqoYWPXypY0FI9V4rOVekgxucSeNj/f2jrAh38B2wf8Dcb
         msnOmhwm+fX3pwUWyirSVZ0XLQNJHOX1MTndysvy80tEGE7IVzv/rJhjf31N//l8Khiw
         FBwg==
X-Gm-Message-State: AOAM5322SVqr+PKzQ2HqmpJglwol7laCLOFb9Uu/UMmj32hLcCzDP6Uz
        F6IOgO/vFH7TSYKWvnxHWrc=
X-Google-Smtp-Source: ABdhPJyX7EBuEdIMsMoR+wifYixriLOjrTR4BxgU3fYxTBgCSiGDP0jQKGdTRaZ4BqPX27uDw2lIMQ==
X-Received: by 2002:a17:90a:d243:b0:1b9:cbac:a775 with SMTP id o3-20020a17090ad24300b001b9cbaca775mr17638579pjw.196.1645372736596;
        Sun, 20 Feb 2022 07:58:56 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id o14sm5001927pfw.121.2022.02.20.07.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:58:56 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ip: add skb drop reasons for ip egress path
Date:   Sun, 20 Feb 2022 23:57:03 +0800
Message-Id: <20220220155705.194266-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220155705.194266-1-imagedong@tencent.com>
References: <20220220155705.194266-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in the packet egress path of
IP layer (both IPv4 and IPv6 are considered).

Following functions are involved:

__ip_queue_xmit()
ip_finish_output()
ip_mc_finish_output()
ip6_output()
ip6_finish_output()
ip6_finish_output2()

Following new drop reasons are introduced:

SKB_DROP_REASON_IP_OUTNOROUTES
SKB_DROP_REASON_BPF_CGROUP_EGRESS
SKB_DROP_REASON_IPV6DSIABLED

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/ip_output.c       |  6 +++---
 net/ipv6/ip6_output.c      |  6 +++---
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3e90efe6586..c310a4a8fc86 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -380,6 +380,19 @@ enum skb_drop_reason {
 					 * the ofo queue, corresponding to
 					 * LINUX_MIB_TCPOFOMERGE
 					 */
+	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed during
+					 * packet outputting
+					 */
+	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by eBPF program
+						 * with type of BPF_PROG_TYPE_CGROUP_SKB
+						 * and attach type of
+						 * BPF_CGROUP_INET_EGRESS
+						 * during packet sending
+						 */
+	SKB_DROP_REASON_IPV6DSIABLED,	/* IPv6 is disabled on the device,
+					 * see the doc for disable_ipv6
+					 * in ip-sysctl.rst for detail
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 2ab7193313aa..47dedef7b6b8 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -37,6 +37,10 @@
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
+	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
+	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
+	   BPF_CGROUP_EGRESS)					\
+	EM(SKB_DROP_REASON_IPV6DSIABLED, IPV6DSIABLED)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0c0574eb5f5b..df549b7415fb 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -317,7 +317,7 @@ static int ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *sk
 	case NET_XMIT_CN:
 		return __ip_finish_output(net, sk, skb) ? : ret;
 	default:
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_BPF_CGROUP_EGRESS);
 		return ret;
 	}
 }
@@ -337,7 +337,7 @@ static int ip_mc_finish_output(struct net *net, struct sock *sk,
 	case NET_XMIT_SUCCESS:
 		break;
 	default:
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_BPF_CGROUP_EGRESS);
 		return ret;
 	}
 
@@ -536,7 +536,7 @@ int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 no_route:
 	rcu_read_unlock();
 	IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_OUTNOROUTES);
 	return -EHOSTUNREACH;
 }
 EXPORT_SYMBOL(__ip_queue_xmit);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0c6c971ce0a5..4cd9e5fd25e4 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -130,7 +130,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	rcu_read_unlock_bh();
 
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_OUTNOROUTES);
 	return -EINVAL;
 }
 
@@ -202,7 +202,7 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	case NET_XMIT_CN:
 		return __ip6_finish_output(net, sk, skb) ? : ret;
 	default:
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_BPF_CGROUP_EGRESS);
 		return ret;
 	}
 }
@@ -217,7 +217,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(idev->cnf.disable_ipv6)) {
 		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_IPV6DSIABLED);
 		return 0;
 	}
 
-- 
2.35.1

