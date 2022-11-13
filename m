Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864CC6270E7
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbiKMQot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiKMQos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:44:48 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13538DEE1;
        Sun, 13 Nov 2022 08:44:48 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id cg5so5592951qtb.12;
        Sun, 13 Nov 2022 08:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3grqxCjJ0FJboCJuXL1kuIKZVHmc0HhkHBhsbXQ5EeA=;
        b=o4bZmTT6/hGofQiZrbW3vopSA/Jc+5IR3iANWtKyHnJinMu0zsY6LJAGsTpEDS+4uF
         dkUEYYvCYANDswZ6wG7QJtcPdA9Yfqp/d4bDH39GDEiwQiEMq5FYQ/UcoiMMraSb2aeM
         /I1d664SAjE6bPMxoKzFfwVNG2Vu4jjqpipNKIntiCUghntyBFYLYIi2RNNjSokTcDRR
         MBjs+9plQZXPLgmnqToJrxNCbiUN2l9e6F08ncsDefA3nvH941216mmPD8UVA8/AF5IY
         eDyVa5U6Zfoi8Jkc/FhHHXFvKRqtqOkozUfILdDo3e5PmUbHu1Kx4mda8yMAA7M5ALaW
         IddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3grqxCjJ0FJboCJuXL1kuIKZVHmc0HhkHBhsbXQ5EeA=;
        b=rqOrX830ZaMKFOhzYmlRGvWdVRMMojrTDgMJdLM9H/Z3VJ6FmCwR/srloe9zm1zTH5
         5LLrZMlGTqowTIGlADWyrNmby92U7Ox8ftQ0hwvqeWkYE1rwwHAyOE+Ylxxd7qH3cL9g
         4mwWT/bUw3c7geYlaIWgxtFml3YfmxiuwGTuRxU3zpMUio0btuUssAoW47FKmVVd0Zup
         soaV2LN09U1C0klKwrEFAVJFoTIIO/tVSMy6X7SrQErX+o2RY6o/2r1C+KLyDaJvAXnV
         MsP1oML6DrMTCv+/f+ZPb/BHRPwmM2jqm6Y64cmO0MoB0dClJCLZaP1QKg2xFTxFJspr
         Esbw==
X-Gm-Message-State: ANoB5pn4Co5q3/t7/679q5FwCORbCw2TXTO9bVtJbo7f85tRQSeo935W
        pVcMWiz+97vBeAJyO9N0dnvDp8T+9Fm6gA==
X-Google-Smtp-Source: AA0mqf52kQ7hsIG8B4Td9Z97rjJiBMrPF7R7EOZ2sNJPpOsTi9qt+0Me+O0uAhjOlj8VRCpboP7Ycg==
X-Received: by 2002:ac8:124b:0:b0:3a5:6f39:4bd9 with SMTP id g11-20020ac8124b000000b003a56f394bd9mr9416392qtj.234.1668357886931;
        Sun, 13 Nov 2022 08:44:46 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf8-20020a05622a400800b0035d08c1da35sm4429191qtb.45.2022.11.13.08.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:44:46 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCH net-next 1/7] sctp: verify the bind address with the tb_id from l3mdev
Date:   Sun, 13 Nov 2022 11:44:37 -0500
Message-Id: <d069da3c0763f88181ed65aa91d93dca75916d2d.1668357542.git.lucien.xin@gmail.com>
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

After binding to a l3mdev, it should use the route table from the
corresponding VRF to verify the addr when binding to an address.

Note ipv6 doesn't need it, as binding to ipv6 address does not
verify the addr with route lookup.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index bcd3384ab07a..dbfe7d1000c2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -351,10 +351,13 @@ static int sctp_v4_addr_valid(union sctp_addr *addr,
 /* Should this be available for binding?   */
 static int sctp_v4_available(union sctp_addr *addr, struct sctp_sock *sp)
 {
-	struct net *net = sock_net(&sp->inet.sk);
-	int ret = inet_addr_type(net, addr->v4.sin_addr.s_addr);
-
+	struct sock *sk = &sp->inet.sk;
+	struct net *net = sock_net(sk);
+	int tb_id = RT_TABLE_LOCAL;
+	int ret;
 
+	tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ?: tb_id;
+	ret = inet_addr_type_table(net, addr->v4.sin_addr.s_addr, tb_id);
 	if (addr->v4.sin_addr.s_addr != htonl(INADDR_ANY) &&
 	   ret != RTN_LOCAL &&
 	   !sp->inet.freebind &&
-- 
2.31.1

