Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BF162C96E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiKPUBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiKPUBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:31 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89385E9FF;
        Wed, 16 Nov 2022 12:01:30 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id i12so12662961qvs.2;
        Wed, 16 Nov 2022 12:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QWD/jUXR3p/XF022zWpAWrCQHECTDO1W29LEJMQqdc=;
        b=YR3K6mUpbk7T96wNf+IfJvgvYBSl0R0DeiHkVXV+2GZ8HMSpsXaLlR7s9nAF5GOUUB
         ut8tJe2ZWHSlVYzh4LFApQPbZuugMNmnW5wqh8q1J1Mo7F2GyPG9tADUWoDz+m4PCLmn
         qjAa/YaMj/5MGMuYgaEI0p3Qnj+WAmtXAVAlD6bgQuvxwqjKmiqXvcad3qH/SQ/iDlY3
         ytooAhfJow3lGweaJKPY2HBp7SEElebLicHQ3q7+IBFreuOwcRMgztOsLfet6rGJUSNg
         rQZWROzRHJIjuS09rZd3VOiaYSEegefz2sCSofwLTJVIeQcW/qEVYRxBwA1UctnWkfhR
         UQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1QWD/jUXR3p/XF022zWpAWrCQHECTDO1W29LEJMQqdc=;
        b=HtzZT25o0OKPeVNsMfEa+rZNh4wlt0hUcP1K2l2yvlrdDbAd1pi4Ja/l/M+xcOQ87x
         ptBiz25F5LV5JsdULWv7EweCJDCsMKyseq7WXzFfOwzpp5/jFY8TvqoxZkSGe3aSu8CC
         XJh5QTLf2cKXTG442Zl/gVFACFEqFCmqSKQvc7mcJPiD5zd8AZVmfP9ciW4nq9FnDp+A
         P4p5dw2q2BF+yTdZZQYe/BWTSxcKdO0kNoUO3XVJL1AU2jdnQNXBvrQe1ofJQCxd6iGO
         AhMCuh+Ym8jElpW+mMv0k0fUnkCPW/xtGEaPQtatrLy2UPh3knyM+jLBn1POoimay09C
         NE3w==
X-Gm-Message-State: ANoB5pnlbptjOUVb4dao/RpdHSa+ygDj1/53PTzDKWV7HOiznaZHtPUu
        Lr6mm9U5M/Z/iCK/SLUjFUvqvc3GnzAMIQ==
X-Google-Smtp-Source: AA0mqf7/cmTNoluOidHYNQzKs40WE8AjAvns1R3PHnIbePWiIypsAd6prf5fA+PUd+MBsRSX/TgtTg==
X-Received: by 2002:a0c:ff02:0:b0:4bb:85ae:823c with SMTP id w2-20020a0cff02000000b004bb85ae823cmr22446902qvt.68.1668628889511;
        Wed, 16 Nov 2022 12:01:29 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 2/7] sctp: check ipv6 addr with sk_bound_dev if set
Date:   Wed, 16 Nov 2022 15:01:17 -0500
Message-Id: <38513a7b07dc172eaf1611311924571e1d4c689a.1668628394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
References: <cover.1668628394.git.lucien.xin@gmail.com>
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

