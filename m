Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22815A8BC0
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiIADGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiIADGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:06:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA3310DE46
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 20:06:19 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id i5-20020a17090a2a0500b001fd8708ffdfso1142072pjd.2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 20:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7BPZ0w7bR+POM8UWGdSp7cvsHsjrzEmyCxOmSJVn3Sk=;
        b=h0W5hDXZX1p6OY1jFNHelBXMYElhN5kCe43NFXLFeouKwTwZN/BZ7+ToznHm/Pf4+z
         4hJTHHaT2dU9C98IhbUK9gU/h3MSsK5O4UyzkKMpOrZVW4cAmoDodPzMk48Aa5DpRXde
         hn6pR0ZRvBdSiN4lQ/voefmOc0nefZ5azxgsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7BPZ0w7bR+POM8UWGdSp7cvsHsjrzEmyCxOmSJVn3Sk=;
        b=2fzxklU64jf6fbwfaMPQQEEyGXVjcwXx8E4LLYhfY1/BhNHIqJ8Kn9ts6l9SBlc6uj
         N1/sXyFtHXJp1YuYiH1EMsdVGF51CmiDuOiwDXmMHNGY9us/CTHA+huZex235P7OuD5T
         h6nMHaNUBMg/87tuqh4YtOwN1lW0BAxuqjZnrjq7YuguCLseZlgbnnV1lMp3OakrpdyM
         BdIg+Aqrh1+4ZPWxD683J5T6+hwNKbyZfNdXGWAXQeDT5AXS4Zx8MY+CW6UtNNq5i5BH
         icGBFAoEvW3dh+WeZ5stwnMVZlb6SAHJ2z+t+CSnOldRt6Z9kdR9MpA7hioXg4AOxmdW
         QQuQ==
X-Gm-Message-State: ACgBeo0ABvkHrLG8Mat3Iin/0PypMiRd783pD65N1pzVb3dFfFU+RYWe
        y1vuCU2b9lGpAuXUVNX4ZJSMeA==
X-Google-Smtp-Source: AA6agR4qEkOjTxq3lCWI2gk3QzhiahCCSeb9FdqdRP4PLgYME9Xygid90h2LiUfUrUUP3IZG+U8+jw==
X-Received: by 2002:a17:90b:3c48:b0:1fd:b6bd:8d2a with SMTP id pm8-20020a17090b3c4800b001fdb6bd8d2amr6320256pjb.159.1662001578599;
        Wed, 31 Aug 2022 20:06:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i9-20020a170902c94900b00173cfb184c0sm12681822pla.32.2022.08.31.20.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 20:06:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 2/2] netlink: Bounds-check struct nlmsgerr creation
Date:   Wed, 31 Aug 2022 20:06:10 -0700
Message-Id: <20220901030610.1121299-3-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220901030610.1121299-1-keescook@chromium.org>
References: <20220901030610.1121299-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5544; h=from:subject; bh=PTnYSDiLEsJDovKpPxYSpPKcq7Gr9tqmNSUX+zizaOA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjECGia+Ip13JgEGdDSv05K80fyPwzKiQxqsAYFJoZ BNe/+7WJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxAhogAKCRCJcvTf3G3AJsYPD/ 0V5RKSN7bwCg72exKE161D97aLqJRsHhGiZWb0IOJmyL5BJrEmwpfYpQ0B14fq5xU5rV+IoJVNXSll X1yfGa8u9B8v4FEBTZWD01wHvNr2qCRCwmfdTGu0W122+TA7E006P2Z64nl6ztWqbt7MjzXQYys4W3 j30C1GGGCB8p/pCFuhthVqB/STFW2F8gGe1H4+8Dpm+WfwfzZygyXEcXzZ/6PTay88Z1FX4TF4v8lq TtufX5z1jymGdfoZgs6APcwEg6jERKOJKLyqE9JWvdHmjoTei51UWXeZeKYqs0txiCX5l3w3t3zy3/ /tBZXlLhZ5I27XeKS9d+yz0GvXwNBx11jemingI8/6nbDB7Tg05u8X4xEeq8fbedCmKsJ39Pq9I47B AUXr2dXsBTXE93sscUPE+qW+0qPGXOksjsLuPHhTEJqgw8n7cHs6BCreqwPf/9vlNPyvW1Kl5vke1+ raLP03IsNRU/7gjuc1E2zj5nqomffs6xbJMIvvxmOHwkmxcXS8+twXklXnAkobRdsZqwn4WiOufcSY bc83MOA2UsLdbiS2HfEDDbZpdO4hhhTjztngX8cux8CS0iyZr6uNKyyV+R1Y5j2Sr/uhpXs6sSwJXs QiDTHCHxDIxuEcsg4LI9MnLVUNI6IBYAt2lX1AQmWqaVB1QPij1iqgaAhR1A==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 32-bit systems, it might be possible to wrap lnmsgerr content
lengths beyond SIZE_MAX. Explicitly test for all overflows, and mark the
memcpy() as being unable to internally diagnose overflows.

This also excludes netlink from the coming runtime bounds check on
memcpy(), since it's an unusual case of open-coded sizing and
allocation.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/netfilter/ipset/ip_set_core.c | 10 +++++--
 net/netlink/af_netlink.c          | 49 +++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 16ae92054baa..43576f68f53d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1709,13 +1709,14 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
 		struct sk_buff *skb2;
 		struct nlmsgerr *errmsg;
-		size_t payload = min(SIZE_MAX,
-				     sizeof(*errmsg) + nlmsg_len(nlh));
+		size_t payload;
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 		struct nlattr *cmdattr;
 		u32 *errline;
 
+		if (check_add_overflow(sizeof(*errmsg), nlmsg_len(nlh), &payload))
+			return -ENOMEM;
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
 		if (!skb2)
 			return -ENOMEM;
@@ -1723,7 +1724,10 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 				  nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
 		errmsg = nlmsg_data(rep);
 		errmsg->error = ret;
-		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
+		unsafe_memcpy(&errmsg->msg, nlh, nlh->nlmsg_len,
+			      /* "payload" was explicitly bounds-checked, based on
+			       * the size of nlh->nlmsg_len.
+			       */);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
 		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0cd91f813a3b..8779c273f34f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2407,7 +2407,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	struct nlmsghdr *rep;
 	struct nlmsgerr *errmsg;
 	size_t payload = sizeof(*errmsg);
-	size_t tlvlen = 0;
+	size_t alloc_size, tlvlen = 0;
 	struct netlink_sock *nlk = nlk_sk(NETLINK_CB(in_skb).sk);
 	unsigned int flags = 0;
 	bool nlk_has_extack = nlk->flags & NETLINK_F_EXT_ACK;
@@ -2419,32 +2419,44 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	if (nlk_has_extack && extack && extack->_msg)
 		tlvlen += nla_total_size(strlen(extack->_msg) + 1);
 
-	if (err && !(nlk->flags & NETLINK_F_CAP_ACK))
-		payload += nlmsg_len(nlh);
+	if (err && !(nlk->flags & NETLINK_F_CAP_ACK) &&
+	    check_add_overflow(payload, (size_t)nlmsg_len(nlh), &payload))
+		goto failure;
 	else
 		flags |= NLM_F_CAPPED;
-	if (err && nlk_has_extack && extack && extack->bad_attr)
-		tlvlen += nla_total_size(sizeof(u32));
-	if (nlk_has_extack && extack && extack->cookie_len)
-		tlvlen += nla_total_size(extack->cookie_len);
-	if (err && nlk_has_extack && extack && extack->policy)
-		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
+	if (err && nlk_has_extack && extack && extack->bad_attr &&
+	    check_add_overflow(tlvlen, (size_t)nla_total_size(sizeof(u32)),
+			       &tlvlen))
+		goto failure;
+	if (nlk_has_extack && extack && extack->cookie_len &&
+	    check_add_overflow(tlvlen, (size_t)nla_total_size(extack->cookie_len),
+			       &tlvlen))
+		goto failure;
+	if (err && nlk_has_extack && extack && extack->policy &&
+	    check_add_overflow(tlvlen,
+			       (size_t)netlink_policy_dump_attr_size_estimate(extack->policy),
+			       &tlvlen))
+		goto failure;
 
 	if (tlvlen)
 		flags |= NLM_F_ACK_TLVS;
 
-	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
-	if (!skb) {
-		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
-		sk_error_report(NETLINK_CB(in_skb).sk);
-		return;
-	}
+	if (check_add_overflow(payload, tlvlen, &alloc_size))
+		goto failure;
+
+	skb = nlmsg_new(alloc_size, GFP_KERNEL);
+	if (!skb)
+		goto failure;
 
 	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
 			  NLMSG_ERROR, payload, flags);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
+					 ?  nlh->nlmsg_len : sizeof(*nlh),
+		      /* "payload" was bounds checked against nlh->nlmsg_len,
+		       * and overflow-checked as tlvlen was constructed.
+		       */);
 
 	if (nlk_has_extack && extack) {
 		if (extack->_msg) {
@@ -2469,6 +2481,11 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	nlmsg_end(skb, rep);
 
 	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
+	return;
+failure:
+	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
+	sk_error_report(NETLINK_CB(in_skb).sk);
+
 }
 EXPORT_SYMBOL(netlink_ack);
 
-- 
2.34.1

