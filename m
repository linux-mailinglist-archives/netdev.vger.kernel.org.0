Return-Path: <netdev+bounces-5482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1C1711987
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 580D9281542
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B81C24EB4;
	Thu, 25 May 2023 21:49:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DC820982
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:49:43 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C1910FC
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:23 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75b0b5c9eb8so19291085a.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685051361; x=1687643361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ualsJr250Jlatwvq3JxdtUEX7Vc86H8V8s6taY1rrr4=;
        b=MctaKa07SA6PnzzgGFo27OJbtiRiZ6Wcc7MVlo1DpMe91RU2F4WWHfIio+aPjNZx6M
         1jZ2N4J18c8/1CS6OVxmwDu2dMjTe8ciiG6mV8MIcpzSwoblUEEWgSjUUlsS6jgd7NKN
         44zrX676nbCo6k84RudSx78Cd08SbJABFQihVvpdsSMvFZWXcsBMHD+nKmU/8dtVVGQm
         6CugwM9gjWZELHIBTOMJ2jaQF3/Fl9RfQ1FOIna3MAfmPomhRIMb2BEg16eeUU8fjh0F
         2B009E9pab38hZnNg66uECcsQG0D7CgjNQXYVp0LybtqLB3bJIVHk8Ux4r6pnJcOBqPr
         oplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685051361; x=1687643361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ualsJr250Jlatwvq3JxdtUEX7Vc86H8V8s6taY1rrr4=;
        b=YsKQs9KfZ8CPKwwUgkKnpZDxpEd2Gz0R1yOyJQbRUVZq65smCNQoZLWq0dSwvve2DO
         sn2/ZEQymM9q9wwROtRrKUbwP0IAYzgILSG6+3k06hmioU2V8jQpQqHtg2yleWkyjbbN
         Ok28htuHPF/AJaosXI76C/Eb8x2IppkNtRzUyhpjpkLjJKdlmJqbwTfBAhJKJU+6xsRf
         5W6RUPCVi2nvCjQUadmbleorTC00hXOH93Unxl/dTAuUUqiEn/OQDiE27C3xF/ZexbTH
         CrBr5qevvS5kG5zefIxRD40dJIGyY2xv86xx79D2itIca/i1iF6IRadJ7/O5bJasjSgI
         NPtQ==
X-Gm-Message-State: AC+VfDyrB1sEI6AEvlpxXMDLAcs+GHOx5koY7TndFZt5Wu4j/nTQfwxE
	TmZMJ+Utfz05IhsK+y0fgmECImFKK+pmtg==
X-Google-Smtp-Source: ACHHUZ6vbRhZz+8+ICsflj752zj/uFbqYO22G0cT3VtrXzX6SE6IfAqBjp6lJMcLiV35NDM/mPGsxw==
X-Received: by 2002:ac8:7e95:0:b0:3f6:b0dc:1084 with SMTP id w21-20020ac87e95000000b003f6b0dc1084mr1241206qtj.54.1685051360840;
        Thu, 25 May 2023 14:49:20 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x7-20020ac81207000000b003f7f66d5a0esm735742qti.44.2023.05.25.14.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 14:49:20 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net 1/3] rtnetlink: move validate_linkmsg into rtnl_create_link
Date: Thu, 25 May 2023 17:49:15 -0400
Message-Id: <7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1685051273.git.lucien.xin@gmail.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In commit 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()"),
it moved validate_linkmsg() from rtnl_setlink() to do_setlink(). However,
as validate_linkmsg() is also called in __rtnl_newlink(), it caused
validate_linkmsg() being called twice when running 'ip link set'.

The validate_linkmsg() was introduced by commit 1840bb13c22f5b ("[RTNL]:
Validate hardware and broadcast address attribute for RTM_NEWLINK") for
existing links. After adding it in do_setlink(), there's no need to call
it in __rtnl_newlink().

Instead of deleting it from __rtnl_newlink(), this patch moves it to
rtnl_create_link() to fix the missing validation for the new created
links.

Fixes: 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/rtnetlink.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 653901a1bf75..d1f88ba7e391 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2377,15 +2377,13 @@ static	int rtnl_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate,
 static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 			    struct netlink_ext_ack *extack)
 {
-	if (dev) {
-		if (tb[IFLA_ADDRESS] &&
-		    nla_len(tb[IFLA_ADDRESS]) < dev->addr_len)
-			return -EINVAL;
+	if (tb[IFLA_ADDRESS] &&
+	    nla_len(tb[IFLA_ADDRESS]) < dev->addr_len)
+		return -EINVAL;
 
-		if (tb[IFLA_BROADCAST] &&
-		    nla_len(tb[IFLA_BROADCAST]) < dev->addr_len)
-			return -EINVAL;
-	}
+	if (tb[IFLA_BROADCAST] &&
+	    nla_len(tb[IFLA_BROADCAST]) < dev->addr_len)
+		return -EINVAL;
 
 	if (tb[IFLA_AF_SPEC]) {
 		struct nlattr *af;
@@ -3285,6 +3283,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	struct net_device *dev;
 	unsigned int num_tx_queues = 1;
 	unsigned int num_rx_queues = 1;
+	int err;
 
 	if (tb[IFLA_NUM_TX_QUEUES])
 		num_tx_queues = nla_get_u32(tb[IFLA_NUM_TX_QUEUES]);
@@ -3320,13 +3319,18 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	err = validate_linkmsg(dev, tb, extack);
+	if (err < 0) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
+
 	dev_net_set(dev, net);
 	dev->rtnl_link_ops = ops;
 	dev->rtnl_link_state = RTNL_LINK_INITIALIZING;
 
 	if (tb[IFLA_MTU]) {
 		u32 mtu = nla_get_u32(tb[IFLA_MTU]);
-		int err;
 
 		err = dev_validate_mtu(dev, mtu, extack);
 		if (err) {
@@ -3534,10 +3538,6 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			m_ops = master_dev->rtnl_link_ops;
 	}
 
-	err = validate_linkmsg(dev, tb, extack);
-	if (err < 0)
-		return err;
-
 	if (tb[IFLA_LINKINFO]) {
 		err = nla_parse_nested_deprecated(linkinfo, IFLA_INFO_MAX,
 						  tb[IFLA_LINKINFO],
-- 
2.39.1


