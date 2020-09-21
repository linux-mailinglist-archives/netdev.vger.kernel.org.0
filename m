Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82512727C6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgIUOhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgIUOhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:37:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EEFC0613D2
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so13012032wrn.13
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/qlLBmSLkXX8+VWho1l+4lvAqtyGS8XDHRWiRzbfdT0=;
        b=Q001+qfEfU11Y7UoINCguwe49yZ95OIa3Dtvsd2N+mQGKjbZp+DAbLebQLXtUGBb49
         enuj+gcu0OkBdDGQJ83p0ylqjAoQOtC/YfSYOoQA3hD3KR37inUKZgW8tGJWT8yk+VeX
         q377TB41SenHuTgpNx44CFEnjNNqF3DzJpmwdl/7cr97Q33RBA3029gMF/qVl+LMNghR
         JGLjS0g1/v/YW3C3qHy4zL3LY80S9K/SbwQKNGYq1AIfUMMa/NtA/MiE+TlpDoS+N8/U
         vkeXJegOlczyOceUflvCrMaXksoMhSHVXE+n8PFYRn5FR0bNPWcl2W2vkHGTtS1/yvZV
         LhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/qlLBmSLkXX8+VWho1l+4lvAqtyGS8XDHRWiRzbfdT0=;
        b=DlqWs5QfV9vQAvb14gIPduzeZ52ny9G0ppNmqATnxC7OPvQUFbmLL7xsEMsmZSjUkA
         /Rj0rU1Cahc3GqtSHpRryW1VKPoZCuAQTO2QPIjPVCP2JLFxPaB6Ob36ngqYXUWcHJ3h
         GKBWbY2vTQgyCMWWmnymAKe/FtdVHT6EUYkg6s0m+q8/dMWf35rWh/b6MthIkubxqbYJ
         eI8Q4XSQN+L8h+XVPzd/IXyOtdzQbsaCyJhl6s6nJZr+BmlpqRaZxE5mV3g3417RUAHh
         pxHqGN4levSSOSfMtxAFP6nz/KLUxFdZbxKypEhP4hy6jlZPqkVTKaAwyOdcm85Bmx1z
         jI9w==
X-Gm-Message-State: AOAM533YRhhrZnXpLt7IaRczpVR/n9MJj40OkbNQ3dwDBVe9JLVPI7z2
        KTpO3P/slHZ9hTipdOM2ZLJl+g==
X-Google-Smtp-Source: ABdhPJyeDwt3llJ1iiPKlXmXG5HaT72EzX6BpOjM8GwSM6TDgvyQwVjapGSKAZO2Up1n/3L5Hn4W4w==
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr96505wru.248.1600699031023;
        Mon, 21 Sep 2020 07:37:11 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c14sm20370753wrv.12.2020.09.21.07.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:37:10 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v3 4/7] netlink/compat: Append NLMSG_DONE/extack to frag_list
Date:   Mon, 21 Sep 2020 15:36:54 +0100
Message-Id: <20200921143657.604020-5-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143657.604020-1-dima@arista.com>
References: <20200921143657.604020-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modules those use netlink may supply a 2nd skb, (via frag_list)
that contains an alternative data set meant for applications
using 32bit compatibility mode.

In such a case, netlink_recvmsg will use this 2nd skb instead of the
original one.

Without this patch, such compat applications will retrieve
all netlink dump data, but will then get an unexpected EOF.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/netlink/af_netlink.c | 47 ++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d2d1448274f5..de12dd3136f9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2186,13 +2186,35 @@ EXPORT_SYMBOL(__nlmsg_put);
  * It would be better to create kernel thread.
  */
 
+static int netlink_dump_done(struct netlink_sock *nlk, struct sk_buff *skb,
+			     struct netlink_callback *cb,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put_answer(skb, cb, NLMSG_DONE, sizeof(nlk->dump_done_errno),
+			       NLM_F_MULTI | cb->answer_flags);
+	if (WARN_ON(!nlh))
+		return -ENOBUFS;
+
+	nl_dump_check_consistent(cb, nlh);
+	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno, sizeof(nlk->dump_done_errno));
+
+	if (extack->_msg && nlk->flags & NETLINK_F_EXT_ACK) {
+		nlh->nlmsg_flags |= NLM_F_ACK_TLVS;
+		if (!nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
+			nlmsg_end(skb, nlh);
+	}
+
+	return 0;
+}
+
 static int netlink_dump(struct sock *sk)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 	struct netlink_ext_ack extack = {};
 	struct netlink_callback *cb;
 	struct sk_buff *skb = NULL;
-	struct nlmsghdr *nlh;
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
@@ -2258,22 +2280,19 @@ static int netlink_dump(struct sock *sk)
 		return 0;
 	}
 
-	nlh = nlmsg_put_answer(skb, cb, NLMSG_DONE,
-			       sizeof(nlk->dump_done_errno),
-			       NLM_F_MULTI | cb->answer_flags);
-	if (WARN_ON(!nlh))
+	if (netlink_dump_done(nlk, skb, cb, &extack))
 		goto errout_skb;
 
-	nl_dump_check_consistent(cb, nlh);
-
-	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno,
-	       sizeof(nlk->dump_done_errno));
-
-	if (extack._msg && nlk->flags & NETLINK_F_EXT_ACK) {
-		nlh->nlmsg_flags |= NLM_F_ACK_TLVS;
-		if (!nla_put_string(skb, NLMSGERR_ATTR_MSG, extack._msg))
-			nlmsg_end(skb, nlh);
+#ifdef CONFIG_COMPAT_NETLINK_MESSAGES
+	/* frag_list skb's data is used for compat tasks
+	 * and the regular skb's data for normal (non-compat) tasks.
+	 * See netlink_recvmsg().
+	 */
+	if (unlikely(skb_shinfo(skb)->frag_list)) {
+		if (netlink_dump_done(nlk, skb_shinfo(skb)->frag_list, cb, &extack))
+			goto errout_skb;
 	}
+#endif
 
 	if (sk_filter(sk, skb))
 		kfree_skb(skb);
-- 
2.28.0

