Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6ECD6270E9
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbiKMQox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbiKMQou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:44:50 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35389DEF0;
        Sun, 13 Nov 2022 08:44:49 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id e15so5624240qts.1;
        Sun, 13 Nov 2022 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QWD/jUXR3p/XF022zWpAWrCQHECTDO1W29LEJMQqdc=;
        b=MJ9OfO41w/ZJQ0AHEqLuC58HYWppcOiqalK1qjlgWK2DW60p/Z3AMLyscAS/7ESft9
         P276fEfNv1GVIdeRXvKjlQICQM69+neZgEAdqDUkaodHvpWy7hEmnlH5EIg+aXjiCRi4
         1ljbwUhTSqi9GBJb0U+CBC7/TH/s4mHYP6BE5nKsTOrgEvI5b+dLsmcsY/EPQDRzczbp
         vMT2kkX1o4Mk/kx2jLegXI31CE7pjTmfn31zEvbIQUYHwxqr/NofoslFzJdC/RUnzaYo
         TWkxHZBEXk0l1gMeaSoZsYnWFzE51m2sJ4AEXM9ICwiVNh54r2daxgPRIKMRzprfoUUD
         zPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1QWD/jUXR3p/XF022zWpAWrCQHECTDO1W29LEJMQqdc=;
        b=jAexhBQb7VBiE6TodQyE/8/CeyzZ17Es/xrKAjJu3RPOG/zvfmDqP8Ez3DPddbnkLG
         MmepORMSUAX3zVNRHZPRM0tRDVN6zGwl09OufbarGg8JkIjzYofidvTj5lVPpsA/ul8e
         uNbVhHunxtal1Kz5ifLxr9JE1QLtDv0pV5CkGtoPQdg711N+/xHxp7VLlwErreIa7kmM
         TuiN823wdzXwbRd5CYhs9iAM+SQ3aGsI2YlS5lT7MM/EDZ78CdoYMKbsKRHvIX82PqPS
         fzx3h+lAExUR3pKZpwHxW0p6syddbeJTqE7me7dEKZgJ4qY/RLqqOEHXnjg84wtsSjAe
         QZAg==
X-Gm-Message-State: ANoB5pnUOWIL3kPH83Qepnb691Z24BhSEjSKnvqyNip7rJ0lSWM/x4MR
        pUxDmIcwTNrsZAlgyyFXP0gm7NNwrZZgOg==
X-Google-Smtp-Source: AA0mqf4lY6viBeHpddQ7BjGnzr6FiGMXWSkyOCzDkF9k8FOi5T7n9He07T3lVKmdyM9olK0ESVzriw==
X-Received: by 2002:ac8:48d6:0:b0:35b:b0a4:a6f9 with SMTP id l22-20020ac848d6000000b0035bb0a4a6f9mr9237050qtr.559.1668357888045;
        Sun, 13 Nov 2022 08:44:48 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf8-20020a05622a400800b0035d08c1da35sm4429191qtb.45.2022.11.13.08.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:44:47 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCH net-next 2/7] sctp: check ipv6 addr with sk_bound_dev if set
Date:   Sun, 13 Nov 2022 11:44:38 -0500
Message-Id: <1a234438372853dae6de0483c09c87399af33c93.1668357542.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668357542.git.lucien.xin@gmail.com>
References: <cover.1668357542.git.lucien.xin@gmail.com>
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

When binding to an ipv6 address, it calls ipv6_chk_addr() to check if
this address is on any dev. If a socket binds to a l3mdev but no dev
is passed to do this check, all l3mdev and slaves will be skipped and
the check will fail.

This patch is to pass the bound_dev to make sure the devices under the
same l3mdev can be returned in ipv6_chk_addr(). When the bound_dev is
not a l3mdev or l3slave, l3mdev_master_dev_rcu() will return NULL in
__ipv6_chk_addr_and_flags(), it will keep compitable with before when
NULL dev was passed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index d081858c2d07..e6274cdbdf6c 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -680,9 +680,11 @@ static int sctp_v6_is_any(const union sctp_addr *addr)
 /* Should this be available for binding?   */
 static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 {
-	int type;
-	struct net *net = sock_net(&sp->inet.sk);
 	const struct in6_addr *in6 = (const struct in6_addr *)&addr->v6.sin6_addr;
+	struct sock *sk = &sp->inet.sk;
+	struct net *net = sock_net(sk);
+	struct net_device *dev = NULL;
+	int type;
 
 	type = ipv6_addr_type(in6);
 	if (IPV6_ADDR_ANY == type)
@@ -696,8 +698,14 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (!(type & IPV6_ADDR_UNICAST))
 		return 0;
 
+	if (sk->sk_bound_dev_if) {
+		dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+		if (!dev)
+			return 0;
+	}
+
 	return ipv6_can_nonlocal_bind(net, &sp->inet) ||
-	       ipv6_chk_addr(net, in6, NULL, 0);
+	       ipv6_chk_addr(net, in6, dev, 0);
 }
 
 /* This function checks if the address is a valid address to be used for
-- 
2.31.1

