Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0714FF53E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiDMKyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiDMKyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:44 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D6759A4E
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t11so3049958eju.13
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=punCyQ5OlXSnY/goe5W8EQLjKTFZYGXPlnRQPpJuU2Q=;
        b=rU+fyBOGNDPr41fXvuDQ0DkGPCf1V24jkzQmDG4PWUkq88+kD3HhGIYVegC/JyoPqU
         XEa1rdx32WiRjGTEixr8QcvgVUojKKc4Wu/e5Kr4KvGoG+ryx12eTlBFSLL58BpcBli0
         bUontmhkN/fG+g5hWkUlF8BZG1rD+vMA26GZF3r2luCDetHYxAwgA/5VY7IFiJZGrbQA
         jyMMz1pSAKz2Im0DEqtUZvCh+C8QATupt8gsqfJVWx62ebvLDxo+zxQ4niXNuGUQrw7B
         yawFY7R9Xs3rB0jEXSX7pbbASlGW30LrJDMxT784poSUYHtJHU9pK3Y76RnG1AKuRKiZ
         xyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=punCyQ5OlXSnY/goe5W8EQLjKTFZYGXPlnRQPpJuU2Q=;
        b=hYaMiwNZ8jhtR+sOZYLt5W11vn7gFWpqbroBJE14R0y/hb2CCVJWg4u2VMoGpjmT7g
         LHelcaAawXkTTX093XgJ3rEIh3cg/BrcnTm4i717wZKJaDIZMMWhKKbHQsUw3nvk83hC
         4LwKLx93bSEpvL58oD6v1r0oBOz2PGzRBDDna0Z31joGsEiXiY1C4+QAo2/ztG88ZrXH
         9xRVYVjQV4cO6vCeCOoi0wIYeBoYymcfAnrKQJzr9U96U9oXnZCT8SFhM/z4Q7OvTTpZ
         uNClSb7JZSp2Ii9Gg42nVYpVyo1Zgn0KFUh7VolCCcinbBAJZT5Bz1oTHTFXXHvq/AzD
         jo2Q==
X-Gm-Message-State: AOAM5330okoYnbeqyozZRtQETCXsfq+RCBF4xGWQJ8C8a3WdZLU0aKuC
        Yzmeiv5N7L8baY9s3uJZgCMR883lwjHR7yvq
X-Google-Smtp-Source: ABdhPJzJtPZE++TuJtHZ/Yg/lYt4Qo1/ToVPqrbAAkZVzw8xogV7ahAeZiktfTk3WFIRP8JnzVVurg==
X-Received: by 2002:a17:906:ae85:b0:6e8:76c2:1f1f with SMTP id md5-20020a170906ae8500b006e876c21f1fmr17664530ejb.333.1649847142018;
        Wed, 13 Apr 2022 03:52:22 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:21 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 01/12] net: rtnetlink: add msg kind names
Date:   Wed, 13 Apr 2022 13:51:51 +0300
Message-Id: <20220413105202.2616106-2-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rtnl kind names instead of using raw values. We'll need to
check for DEL kind later to validate bulk flag support.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v4: new patch

 include/net/rtnetlink.h | 7 +++++++
 net/core/rtnetlink.c    | 6 +++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 9f48733bfd21..78712b51f3da 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -13,6 +13,13 @@ enum rtnl_link_flags {
 	RTNL_FLAG_DOIT_UNLOCKED = 1,
 };
 
+enum rtnl_kinds {
+	RTNL_KIND_NEW,
+	RTNL_KIND_DEL,
+	RTNL_KIND_GET,
+	RTNL_KIND_SET
+};
+
 void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
 int rtnl_register_module(struct module *owner, int protocol, int msgtype,
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4041b3e2e8ec..2c36c9dc9b62 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5928,11 +5928,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct rtnl_link *link;
+	enum rtnl_kinds kind;
 	struct module *owner;
 	int err = -EOPNOTSUPP;
 	rtnl_doit_func doit;
 	unsigned int flags;
-	int kind;
 	int family;
 	int type;
 
@@ -5949,11 +5949,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
 	kind = type&3;
 
-	if (kind != 2 && !netlink_net_capable(skb, CAP_NET_ADMIN))
+	if (kind != RTNL_KIND_GET && !netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
 	rcu_read_lock();
-	if (kind == 2 && nlh->nlmsg_flags&NLM_F_DUMP) {
+	if (kind == RTNL_KIND_GET && (nlh->nlmsg_flags & NLM_F_DUMP)) {
 		struct sock *rtnl;
 		rtnl_dumpit_func dumpit;
 		u32 min_dump_alloc = 0;
-- 
2.35.1

