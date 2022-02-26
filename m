Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5E34C53AD
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiBZEUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 23:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiBZEUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 23:20:09 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4078621F9F5;
        Fri, 25 Feb 2022 20:19:36 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id e6so5003322pgn.2;
        Fri, 25 Feb 2022 20:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tkgz19jZXWoKaZZFHf0Mr4htYcNeEwU33DzQTnxSRwY=;
        b=jq2MudbZGpMn2sWFfzQOA0olYtl3yWKXMjHMJPg3jYhkRD9y9+Jyt+CP6VH84xbI2G
         qhrDq2FiGQC67XGtlenU1z/eoCcHxMIWqiymxppAvzJ4SOUf9lPRWHF50UhTlhLdgbkl
         Ey3umOeWWhaoQdCsAzaSesfxp4JgJluSaThqi6TNVGZbWKxBID3OLzIx3sW/ki7OtmPY
         husUYJDAhUrNkQLou2bao75+KzNw8Wi2rpH8EHKNaq8BAgSqBqVn+2uAT28VYpT00Pvk
         O4SufctTRarpVf9yEKZyprPn9paT52xZru941Y1ai48qu3+ukSit/O3N8UkO5K0zh097
         IExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tkgz19jZXWoKaZZFHf0Mr4htYcNeEwU33DzQTnxSRwY=;
        b=arAAgBADskZRhN9jwZaGdrwARNUYpVvOOersTQVxQMGYywQI+g7luByvGvyfbVFdFQ
         3k+3hOL9KekBdjwA05RX2LPW3n4VUVeNBs80SUcXggVIUOVA8k0Jb0jspwZYx6vujUfL
         c5pGtPoy4jBZ7MkuvWu/JVHYBcxC3PvQ19iHQ82ySCtEHHF8IjqvKrLP0S8A7qObUIbh
         yQjcp6OGEQzJgDwUa3OzkXPNoMtGFxEzTLe7eXuHwVPXE3heC7Bl3JtJ6p7ZiX/QWuAP
         VM+RRXq3VMcO7EruKm+MOfrm0vz9YFn25m8I4y131OQKravNYX3Id7zkCLDGcc9jPN7c
         tCag==
X-Gm-Message-State: AOAM5312JeoDnRPlBLN52m3ld1ug73XYWY8Lz2u/XtlJ1rV/3l5SMVEi
        JPLObxX689fubez/1X1RADk=
X-Google-Smtp-Source: ABdhPJzdhni2kJLhCFDyjScud98tKYjLk+2wpFCOStKS+NRINkJg5NqwgTj5bpJXd0OFT7rfDRslOA==
X-Received: by 2002:a65:6751:0:b0:363:43a5:c7e3 with SMTP id c17-20020a656751000000b0036343a5c7e3mr8662675pgu.46.1645849175745;
        Fri, 25 Feb 2022 20:19:35 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f1335c8889sm4896193pff.7.2022.02.25.20.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 20:19:35 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/3] net: ip: add skb drop reasons for ip egress path
Date:   Sat, 26 Feb 2022 12:18:29 +0800
Message-Id: <20220226041831.2058437-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220226041831.2058437-1-imagedong@tencent.com>
References: <20220226041831.2058437-1-imagedong@tencent.com>
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

Replace kfree_skb() which is used in the packet egress path of IP layer
with kfree_skb_reason(). Functions that are involved include:

__ip_queue_xmit()
ip_finish_output()
ip_mc_finish_output()
ip6_output()
ip6_finish_output()
ip6_finish_output2()

Following new drop reasons are introduced:

SKB_DROP_REASON_IP_OUTNOROUTES
SKB_DROP_REASON_BPF_CGROUP_EGRESS
SKB_DROP_REASON_IPV6DISABLED
SKB_DROP_REASON_NEIGH_CREATEFAIL

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v3:
- fix typo in 'SKB_DROP_REASON_IPV6DSIABLED' noticed by Roman

v2:
- introduce SKB_DROP_REASON_NEIGH_CREATEFAIL for neigh entry create
  failure
- replace SKB_DROP_REASON_IP_OUTNOROUTES with
  SKB_DROP_REASON_NEIGH_CREATEFAIL in ip6_finish_output2(), as I think
  it's more suitable
---
 include/linux/skbuff.h     | 9 +++++++++
 include/trace/events/skb.h | 5 +++++
 net/ipv4/ip_output.c       | 8 ++++----
 net/ipv6/ip6_output.c      | 6 +++---
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3e90efe6586..bd6ed54f2460 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -380,6 +380,15 @@ enum skb_drop_reason {
 					 * the ofo queue, corresponding to
 					 * LINUX_MIB_TCPOFOMERGE
 					 */
+	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
+	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
+						 * BPF_PROG_TYPE_CGROUP_SKB
+						 * eBPF program
+						 */
+	SKB_DROP_REASON_IPV6DISABLED,	/* IPv6 is disabled on the device */
+	SKB_DROP_REASON_NEIGH_CREATEFAIL,	/* failed to create neigh
+						 * entry
+						 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 2ab7193313aa..97f8097651da 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -37,6 +37,11 @@
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
+	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
+	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
+	   BPF_CGROUP_EGRESS)					\
+	EM(SKB_DROP_REASON_IPV6DISABLED, IPV6DISABLED)		\
+	EM(SKB_DROP_REASON_NEIGH_CREATEFAIL, NEIGH_CREATEFAIL)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0c0574eb5f5b..7f618f72fb42 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -233,7 +233,7 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 
 	net_dbg_ratelimited("%s: No header cache and no neighbour!\n",
 			    __func__);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
 	return -EINVAL;
 }
 
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
index 3286b64ec03d..15244fa6649d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -130,7 +130,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	rcu_read_unlock_bh();
 
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
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
+		kfree_skb_reason(skb, SKB_DROP_REASON_IPV6DISABLED);
 		return 0;
 	}
 
-- 
2.35.1

