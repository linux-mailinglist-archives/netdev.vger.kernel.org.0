Return-Path: <netdev+bounces-2426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D5F701DAF
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 16:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70AF41C20965
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 14:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316C75CBE;
	Sun, 14 May 2023 14:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDA1117
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 14:00:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFD91FD3
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 07:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684072820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5XPWFCwn0ec1Bk7N8aYQ4DY3w3ZSXgJSesqW7FrFphE=;
	b=AxBlYgdtYiyRpm5s+M6zPxXXIDETxpw++AauWnQPBz+s+8D9O/0SDHx4m8nfId4tLsN6m/
	3TEkOeuwi05NfAMp1vluhln14A7uzXobCClJYj9HUL356EhFhHBZOo/dfyHfbp/I+Qv6Nj
	Gg+PS3vZ8gD0YXzzmPqluz5n7EcdK5Q=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-POgeTwsTP9Wv6ZU5ty0CTg-1; Sun, 14 May 2023 10:00:18 -0400
X-MC-Unique: POgeTwsTP9Wv6ZU5ty0CTg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7577727a00eso2845395985a.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 07:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684072818; x=1686664818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5XPWFCwn0ec1Bk7N8aYQ4DY3w3ZSXgJSesqW7FrFphE=;
        b=eJzdPy+896q47VT55LchyWpxXNpLgVuCw0A660Ho1D9sNspsSFC0j+ESElBsmXJK89
         Td/u8w7s4JVVZiQ2NldpM8C3yLNOHiNIS9v3EUT1CVWqUFyBbud6HBU5BXpMa/XfGfda
         YbNhbthCLBW/KOlvqFv2Xs/sE4LidBPLLWPVwfcVlHourrwFSEzfJakoACrqbR7kO9Kl
         tFhOU+jmfwNpcUtY6IAlvge9gJU7tmnk/E24+BWsubn2QSkTWxXWH3CL4KAlQlze7/ve
         ZvkJSITBISqHjjjQflbydM82ziWiM+txZyqSxRY5Myn7JbOXWkPMbC8Ur7nihr4avhCs
         30kQ==
X-Gm-Message-State: AC+VfDxPnuhNQB+OPtlIo/jWnBNZlvl2e0LbUEvbH1tJMazfe79Sdyjb
	HAb84Be5+2WRlbYmG81PmTgBQ1Y9bMGcsRGl0LwXtSftFUSvfrxs4nApzxJClrP7YR6uKeI4tBH
	EXsDxitvAMzOxBHYe
X-Received: by 2002:a05:6214:1d26:b0:5ef:d5b0:c33f with SMTP id f6-20020a0562141d2600b005efd5b0c33fmr68583110qvd.2.1684072818260;
        Sun, 14 May 2023 07:00:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ZxEJVXSJj22FdfeUHUFCbHqGYuIFy6aJ+7s6HEds/c8wbbuyT8d6HxTccrfjHe12gZcWZvw==
X-Received: by 2002:a05:6214:1d26:b0:5ef:d5b0:c33f with SMTP id f6-20020a0562141d2600b005efd5b0c33fmr68583067qvd.2.1684072817948;
        Sun, 14 May 2023 07:00:17 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id ev11-20020a0562140a8b00b0061668c4b426sm4304678qvb.59.2023.05.14.07.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 07:00:17 -0700 (PDT)
From: Tom Rix <trix@redhat.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Rix <trix@redhat.com>
Subject: [PATCH] netfilter: conntrack: define variables exp_nat_nla_policy and any_addr with CONFIG_NF_NAT
Date: Sun, 14 May 2023 10:00:10 -0400
Message-Id: <20230514140010.3399219-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

gcc with W=1 and ! CONFIG_NF_NAT
net/netfilter/nf_conntrack_netlink.c:3463:32: error:
  ‘exp_nat_nla_policy’ defined but not used [-Werror=unused-const-variable=]
 3463 | static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
      |                                ^~~~~~~~~~~~~~~~~~
net/netfilter/nf_conntrack_netlink.c:2979:33: error:
  ‘any_addr’ defined but not used [-Werror=unused-const-variable=]
 2979 | static const union nf_inet_addr any_addr;
      |                                 ^~~~~~~~

These variables use is controlled by CONFIG_NF_NAT, so should their definitions.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d40544cd61a6..69c8c8c7e9b8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2976,7 +2976,9 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 static const union nf_inet_addr any_addr;
+#endif
 
 static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
 {
@@ -3460,10 +3462,12 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
 	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
+#endif
 
 static int
 ctnetlink_parse_expect_nat(const struct nlattr *attr,
-- 
2.27.0


