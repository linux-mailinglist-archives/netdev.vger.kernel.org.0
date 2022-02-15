Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755FE4B6AF3
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbiBOLcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:32:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbiBOLcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:32:05 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550281B7B9;
        Tue, 15 Feb 2022 03:31:54 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c10so8781379pfv.8;
        Tue, 15 Feb 2022 03:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jfI9lhFX9fm5bOhvpIeKtOFzl85DBlhHHLJFTwcXk7E=;
        b=dYOQpCY3N4DCxoqKc+iyHy72EN9Wh/RQkGNvCd2BkDkhgL58jNwxErlMgskwEUp5MN
         p92R1RzA3bfqTqV5Phx1cvLaivDOK6cCGGqetF5dyL903OFRSTViQKPFYGUbdm2q51x9
         gATTXmkhe/L2hLK+ipt5i17psRZWU67UqL5OuDcuZleJtFgJ9TpjWTcVQumfMJTEvPS5
         84HFmR9Iyc5wPFh9L/vYg3Ote2cclijfE9fhe+gB65XJx9O2AKWE8Mh6oUfx9grcWn8H
         Hy6PoRafFhsl8LR1Sl2lSVFE4b/7b3uaGxM3273zASaXuYA4XxOKfAFdO4tCtMI2vYcp
         Gbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jfI9lhFX9fm5bOhvpIeKtOFzl85DBlhHHLJFTwcXk7E=;
        b=hdAUghU8hj0Yn7x0ohXitWvqLFPgEWX1Q07xmLnExc2/6A1eq57L7MjxLwNUSipBVS
         ORuvOex+Q7mrs6SHlkvv0e9u7qfRnxeGf8TC0hMhJBhPx2vaJNNVs8tLLqy+hKUTrd1d
         BxHcXgBdAVNsjk6Fn79Czol0w8+s7u/hZr5N5YbuIpzRI5nGmKZgdgndk10wazdOLUvB
         Ro8VWGUC6mmea0LfN7ENzf8euTf2yU/lruCGwitWBFL7FWHdXWAeZuQIZtPe6Vt91qVC
         Yx920TX1mqDIpJzeYJo8kf4UPEWT8R69CHFYmnbhnVMB118E1VKbgzYPhSHLAjRTWxKv
         g2tw==
X-Gm-Message-State: AOAM5313Tu9ShNpynMQRInh4QZDA0OCd81eFyb/5CaJsSSyuBi9DWQrz
        H0SmVgmdetCWQ3cjzz7OhQ8=
X-Google-Smtp-Source: ABdhPJxoizMI5FWyfJ4R5ufkPNEyGqS8EcnNCcCWUB2b8DIhLRXPfM8MEqLQSSrbs/YrZesIRZkP7w==
X-Received: by 2002:a05:6a00:1a89:: with SMTP id e9mr475846pfv.84.1644924713536;
        Tue, 15 Feb 2022 03:31:53 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:53 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 10/19] net: ip: add skb drop reasons during ip outputting
Date:   Tue, 15 Feb 2022 19:28:03 +0800
Message-Id: <20220215112812.2093852-11-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

As kfree_skb() is not used frequently during packet outputting in ip
layer, we do this job (add reasons for skb drops) at once.

kfree_skb() is replaced by kfree_skb_reason() in following functions:

__ip_queue_xmit(), ip_finish_output(), ip_mc_finish_output(),
ip6_output(), ip6_finish_output(), ip6_finish_output2()

and following drop reasons are added:

SKB_DROP_REASON_IP_OUTNOROUTES
SKB_DROP_REASON_BPF_CGROUP_EGRESS
SKB_DROP_REASON_IPV6DSIABLED

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/ip_output.c       |  6 +++---
 net/ipv6/ip6_output.c      |  6 +++---
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 73ed01d87e43..c7394b4790a0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -374,6 +374,19 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_OFOMERGE,	/* the data of skb is already in
 					 * the ofo queue.
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
2.34.1

