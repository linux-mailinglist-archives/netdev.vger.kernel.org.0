Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666076270EB
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbiKMQoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiKMQov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:44:51 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E2A11814;
        Sun, 13 Nov 2022 08:44:50 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id l15so5611414qtv.4;
        Sun, 13 Nov 2022 08:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tAh+Of9caxaRUw4XnH2iGsda0b31xsN0rQHDbAXeik=;
        b=gxxTCtY0IWNwUHf31mVtlDa2G2+cjiwawgVHmzHiYCtIC3btuGn5a0tLrdPCdv27Qt
         nN44j4je1EcVXmKVKK1Chxa9ldTm7d59RdYbhLINrz+9AgW/8eZaDmUENfzFNfJXl97h
         ghKZCfVGZOaKgOjq6DWeiA0B1tNsi2iAIc3hIb9oe+Kvf6E3/XCSqjEhQemywSlzlgv5
         rnyjK9GXSqfEEjtczhSAvKwptByDFDsJ/G7HDyypvQfJgMCqojRi04C/1e8vHSihuSJp
         hpotmelYx5y+arNcexG28Gu3mFqL7SsIxnuNFzmpp2dtj0SWiO8/vNb6xDb9aKVd9Llz
         hMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+tAh+Of9caxaRUw4XnH2iGsda0b31xsN0rQHDbAXeik=;
        b=rNoU7+fN0GtfpHGP+8h6gvhZ/bzyTZi2PnPfIlB9sZWbi8nNx+Ta6OU+MoEXfhxOo1
         NLLuMoDV1ezreFwanlbqOlM2BYg1HXm7cRI7vfdJ33F/5ZMhZCbdohFuZoFJTQ2yvUnA
         0rjm9ci6qEL2BlGzCSuzwBmyVj01NiBhn6UMMeAVuZq2RU+2YWKyjwRMvPRu6GPM0sLV
         JfBjl7ILlOxsk/3hAKur45T371/WvKS7T3LtXc4E+TGTWOJG3LjZ4/RU6RwXNWozaxol
         yQJdgbj96LFnquY4Dg40AjDByeWbdvHY27OPRvdR7VcbRP/d/ezWcZgN8KDBT9zzT0B1
         AZBA==
X-Gm-Message-State: ANoB5pkFjHDWZDJHm1yzCTRpFEpwMM8AFb0R/7D91d3awJAxEXjOz6++
        EkWBveXJ6V718azh0h+xfByHyniM3bNf0A==
X-Google-Smtp-Source: AA0mqf67/qpID2Rull5karNhfNvmyDDwpPJqkf+XH138/6hWpStI9RN9Zu5APgVTytwcFDejtOQ9EA==
X-Received: by 2002:a05:622a:59cf:b0:3a5:60db:4d6f with SMTP id gc15-20020a05622a59cf00b003a560db4d6fmr9231873qtb.477.1668357889103;
        Sun, 13 Nov 2022 08:44:49 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf8-20020a05622a400800b0035d08c1da35sm4429191qtb.45.2022.11.13.08.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:44:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCH net-next 3/7] sctp: check sk_bound_dev_if when matching ep in get_port
Date:   Sun, 13 Nov 2022 11:44:39 -0500
Message-Id: <87135839695e35749206f2af03a53a9e03f184a3.1668357542.git.lucien.xin@gmail.com>
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

In sctp_get_port_local(), when binding to IP and PORT, it should
also check sk_bound_dev_if to match listening sk if it's set by
SO_BINDTOIFINDEX, so that multiple sockets with the same IP and
PORT, but different sk_bound_dev_if can be listened at the same
time.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3e83963d1b8a..4306164238ef 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8398,6 +8398,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * in an endpoint.
 		 */
 		sk_for_each_bound(sk2, &pp->owner) {
+			int bound_dev_if2 = READ_ONCE(sk2->sk_bound_dev_if);
 			struct sctp_sock *sp2 = sctp_sk(sk2);
 			struct sctp_endpoint *ep2 = sp2->ep;
 
@@ -8408,7 +8409,9 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 			     uid_eq(uid, sock_i_uid(sk2))))
 				continue;
 
-			if (sctp_bind_addr_conflict(&ep2->base.bind_addr,
+			if ((!sk->sk_bound_dev_if || !bound_dev_if2 ||
+			     sk->sk_bound_dev_if == bound_dev_if2) &&
+			    sctp_bind_addr_conflict(&ep2->base.bind_addr,
 						    addr, sp2, sp)) {
 				ret = 1;
 				goto fail_unlock;
-- 
2.31.1

