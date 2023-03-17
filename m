Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263B76BED66
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjCQP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCQPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:57 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B542C9CBF
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id dl18-20020ad44e12000000b005a4d5420bc6so3002388qvb.11
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NLKZaiswqvS0yMI41n07zPe+J+J2Kt7/bjcStBMbJy4=;
        b=c2jzm0JuT2Oquz9ZcC4JGex7iHPj4tgfQuWWbrTAVX4N1WxcC+Zrb6C2ycRWvvb/QG
         Y2kjl+nodxCV8etLWbhQ/S9hz1t/WWKZTqp2LiwAnyht3V47PxeGmOIe8Qul9UAqOrE5
         PtoSgL02yM4zeWnDUs2/rqi6IT3SK6GJN57MlDG6xYT9CmF2SRQdnkmxx5MXzhBug5Hq
         OvnozV1k/sljTNHe2UoYImQAsr063LHmtH8UX9EBJ6l6+VGz9f3HxyC1BMc1TMB29l8c
         utCFhkTfQo6fZTGRIwLsFG/kTRwLgZpeWkvY7q9x4Rzo2gAh4zBcjjZ4pmdXwoixT/jV
         tkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NLKZaiswqvS0yMI41n07zPe+J+J2Kt7/bjcStBMbJy4=;
        b=mLkLYDnuIDKME48EqiQpJWfC3o0N4AVmOBniu5VtzR99HJ3M3yDzk0/zeE3OdQGDVx
         oUzNUSgeeyM3erDQi2XHiB0lvlSQik2wz025ALGGdWjyKiOAD/shhdFSNX7v21Xv4r9S
         5LNXn4/Xo52mXrskcxHEBd8/wDy1be6TedqBQbXJqphEF7SjjWiIIyeFgOQu3nIk/NoJ
         KN+hnikLVPjw1vrokxgfXGFP5oecbxkuiMnu9uEtAbg2EcFh4JC1VaboawmY0rkDTKkC
         3XpuDal/8t43qIeOMKXWua12pehGApOoFUohWlofY9mV4ydS58vjj+xXAtyNrK4Bk6y9
         Q8nA==
X-Gm-Message-State: AO0yUKUljchtBnaX77SkNwSPosrEXJaOUkT19Xtlbh5NUxd9psD2/ivw
        H/R+vgAqkDMeNGdVk7+ZCuXxVWc8hkV0cg==
X-Google-Smtp-Source: AK7set/r3sB8bae56hQAcmC2wZm6adUqSCH2EacCBGUEGeWZwKjyVOEgOqYDX9ThTJY3XjKRgS0eqxg+zPnebA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ae9:e20c:0:b0:742:825d:2b07 with SMTP id
 c12-20020ae9e20c000000b00742825d2b07mr7193618qkc.5.1679068549221; Fri, 17 Mar
 2023 08:55:49 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:34 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-6-edumazet@google.com>
Subject: [PATCH net-next 05/10] dccp: preserve const qualifier in dccp_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can change dccp_sk() to propagate its argument const qualifier,
thanks to container_of_const().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/dccp.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/dccp.h b/include/linux/dccp.h
index 07e547c02fd8b23e05f1f45a3915b2987faddbe9..325af611909f99793491b437231eba20b589c032 100644
--- a/include/linux/dccp.h
+++ b/include/linux/dccp.h
@@ -305,10 +305,8 @@ struct dccp_sock {
 	struct timer_list		dccps_xmit_timer;
 };
 
-static inline struct dccp_sock *dccp_sk(const struct sock *sk)
-{
-	return (struct dccp_sock *)sk;
-}
+#define dccp_sk(ptr)	container_of_const(ptr, struct dccp_sock, \
+					   dccps_inet_connection.icsk_inet.sk)
 
 static inline const char *dccp_role(const struct sock *sk)
 {
-- 
2.40.0.rc2.332.ga46443480c-goog

