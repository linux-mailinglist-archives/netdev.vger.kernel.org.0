Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E866BED6E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjCQP4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjCQPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE07C9C85
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544b71b3114so39367717b3.13
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bnlpOJ7Mh6uk22VZsxZHret+fbAMKXlOYWSTyVc9q+U=;
        b=UfgwxaI7PjjhN2FMOKR4Gn1fdXBuNJvugZk59EkzGMdUzBQiE8WxkOWvUlBQ2y9kJB
         lqm9pRkDWLteBoTHmis8WusK0vowOI5tRCG1l+962b3cO8omlKD1sK/s7cE6+clE9Snu
         r9zmf9Kh/vrxMChcEEyvSM7HV0VTKcXiBphfh5kXBCAB6XyD/iVH5SSUqz4m2aXYiNPg
         6XWH10glcChxjjUVHtrr9pdC/C7tlyg5uVENnc26O6C+Pzc+3d0SuX7V2dW4vXtBGUwA
         5lOWQek99DSzldX9aVcYjueJliTN/dxoInevUoYTWeIJNPjym3P2rB+uwhy21ZE22aiq
         GyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnlpOJ7Mh6uk22VZsxZHret+fbAMKXlOYWSTyVc9q+U=;
        b=CoJfVH0zxftWp/MHT8UGbfHQBA2qiMxF8PS4yBecyBw22E43SdQGCGVLi7ils11bhp
         aRD5wawGvH5wJadgRJKPwez0JKPXSnDG42ACWK4a3LTw3+f+OPr+QGMxyXBwTNCxgEm3
         weT//x0fX2xoZE/Q1EIuiGGxym1ieXmTZEzai83zK5cKhm9lA+eq9gzI0H67R07GP5fa
         0AbTHp6jSyEns19OBEJ5mIH4dVZgleiurML64buU3iCqY+J8vic/POpl30JUbKnnRP5U
         0NB4rsPmukTdAS8FKeul1SgG2dYkyIn8sQiSgT3Wkh4cZHzbB0ztG8+kbl2TVOOpXEf0
         OZ4w==
X-Gm-Message-State: AO0yUKWbv66SoVa3QhUEUqrrwy9f/CRDQkqw31xiPkdX9E7RLNYO/dmm
        E2BLkL8UZlX/M17zZk7TxN/GCuD9AokBqw==
X-Google-Smtp-Source: AK7set9EMlEkn48blxKvjoQf3n20MUoZhfaBwZYO9379BadS/0a8zXEtOjo9NWDCFqLjOgfv15Rx1I+ZxSgPTg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4cc:b0:a67:c976:c910 with SMTP
 id v12-20020a05690204cc00b00a67c976c910mr47033ybs.7.1679068550593; Fri, 17
 Mar 2023 08:55:50 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:35 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-7-edumazet@google.com>
Subject: [PATCH net-next 06/10] af_unix: preserve const qualifier in unix_sk()
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

We can change unix_sk() to propagate its argument const qualifier,
thanks to container_of_const().

We need to change dump_common_audit_data() 'struct unix_sock *u'
local var to get a const attribute.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/af_unix.h | 5 +----
 security/lsm_audit.c  | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 45ebde587138e59f8331d358420d3fca79d9ee66..824c258143a3ab360b870fda38ba684b70068eee 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -74,10 +74,7 @@ struct unix_sock {
 #endif
 };
 
-static inline struct unix_sock *unix_sk(const struct sock *sk)
-{
-	return (struct unix_sock *)sk;
-}
+#define unix_sk(ptr) container_of_const(ptr, struct unix_sock, sk)
 
 #define peer_wait peer_wq.wait
 
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 00d3bdd386e294ecd562bfa8ce502bf179ad32d9..368e77ca43c4a5d5f71a7e9a0a1e58a006796aa6 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -310,7 +310,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	case LSM_AUDIT_DATA_NET:
 		if (a->u.net->sk) {
 			const struct sock *sk = a->u.net->sk;
-			struct unix_sock *u;
+			const struct unix_sock *u;
 			struct unix_address *addr;
 			int len = 0;
 			char *p = NULL;
-- 
2.40.0.rc2.332.ga46443480c-goog

