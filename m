Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC445540DB
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 05:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356493AbiFVDXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 23:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356339AbiFVDXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 23:23:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3597E5FDB
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 20:23:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3177608c4a5so130368417b3.14
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 20:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3KCQGhIBktplV9I6E2fZah/RSzad42fIFYA9iqiHteQ=;
        b=tbA6XIuQjMypK7AuHIPya47a/ywzxOgeGDZk1LX5wVGeWA7svIO+IZ1WPSlyUWxQ1C
         8XRCkLg+a/9xknA8tv4gfEU9NhfDD+L/46ztnGB+55V/Ipc4lHaxkPb5svZmoQovqRwo
         TLPvZ0PIFbzoqTgiC8P6NNEo7NPwibBi0xMsZvGWPFgaBB2bpS4r9R5WTK2C9K/CuDyQ
         x8rAut2tvv6/4AmR6E2Gpm/5sWZ1pFJgRWdtNKrR3TjDJzprFFi+vPaT2tqRw8WtD62d
         n06lJk0psrYC65tJiGOZoxmdOdcLUagXAgTqXDR6KaH/Y9ofxTql4ahia54+ba+BWCor
         QjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3KCQGhIBktplV9I6E2fZah/RSzad42fIFYA9iqiHteQ=;
        b=dF0L6q0k3fbxjh+BSVyjmz72mFVfzV06I1yQWbpgI8Zz4a20ZnyuarzB2ErIDxXB/u
         5jfpn5xrlxijVKBEuvwhQA3OTlbLVuc1CeJk7QohwmyMyjvSmBICFg9UYr9/vLynICSR
         0BZqfV3c5Pv8lgr0vp3351UE2AW+UKgcxA1guD9UrHXhtZPLvobyouBlihy6d9nqovyp
         RhaXotXd4zRayPhmZdMKEq7ZdHrBhV2NULdc4Wsd5ItRE0+h29qBs/KEBOI3H7E/ntyS
         zI8akvRdkImSTZob8CrptFSsQgJK2sxvacFhX5Ak3NCz0F+Iv6LS9PsqoVP6AzbA3qk3
         dpKA==
X-Gm-Message-State: AJIora+0oi/+RKrgMVl98cEiXn+hMkUd0XRVv1XCCvbQ2mVL0/nFVn41
        UrD7pK99RCseClkqgokLCCOKtRsOqPEvng==
X-Google-Smtp-Source: AGRyM1sdjy2odfzNuvvEDzQwXKm3gn5L/q4CuwTj7m/+v8tURpJpYtCL7/oqhyPaU8HJFqZNRQOE8JRubh09Pw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1dcc:0:b0:317:6b70:92f5 with SMTP id
 d195-20020a811dcc000000b003176b7092f5mr1726707ywd.117.1655868185516; Tue, 21
 Jun 2022 20:23:05 -0700 (PDT)
Date:   Wed, 22 Jun 2022 03:23:03 +0000
Message-Id: <20220622032303.159394-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next] raw: remove unused variables from raw6_icmp_error()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

saddr and daddr are set but not used.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/raw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 46b560aacc11352ee9f2043c277709c28f85e610..722de9dd0ff78fbb2535165935c92fe7d7e6a8c2 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -332,7 +332,6 @@ static void rawv6_err(struct sock *sk, struct sk_buff *skb,
 void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		u8 type, u8 code, int inner_offset, __be32 info)
 {
-	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
@@ -345,8 +344,6 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 	sk_nulls_for_each(sk, hnode, hlist) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
-		saddr = &ip6h->saddr;
-		daddr = &ip6h->daddr;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
 				  inet6_iif(skb), inet6_iif(skb)))
-- 
2.37.0.rc0.104.g0611611a94-goog

