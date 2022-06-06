Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A81C53E885
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiFFLfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235528AbiFFLfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:35:04 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC601B78E
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 04:35:03 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id a10so11865628ioe.9
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 04:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mtu.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u4X5HayGDbM23oAI4XP/Qad7ruRB7AB+eU6LfBS0aOU=;
        b=cmoj9jSeQ5vesHQdLYTkV0lvtEhV6VzmgpXpcjEtfK5DCCrVELrwAircy8tpXsyGnJ
         2fd3NpQUDAgu67IdBx1UVdr5SKXM+QAp71T2X2CftK5GjgEcZjoGwC9jBZgDK+X8r5cH
         URlx80KOA30l2hBl3HcJ4qa2O7ihGKlDjO3qSBdfPad9utsps2n5IQIIgyKZ1s38BKVf
         n+k010KuSspEdyNSN/llVtcpMlk0RrRG42LgeL7SSFf0ddfONabC/i6lLPS8bUA6fxr8
         fqjER3WjaAWjskWwShVL+lAAHXNKmU2336eaGk8+ys6Xhdh6GQ0aGpi0/4wR2iXc5AB2
         CKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u4X5HayGDbM23oAI4XP/Qad7ruRB7AB+eU6LfBS0aOU=;
        b=yL0fF/f6s3/gz8/030JYpLJeBOoipX8Wb8N+YRlSONdu5uM+feazngpdqJsI6jfsH2
         USGyq96RmphPJDMkON76g/d2x0ocuBwjY9XSLmxWg227lmnwI09k4u3j1smgKoFk7JFk
         EcCM9nhzp3veGpV8mVQswl8DhOoiyU4fVocmiJwRwqvGTjT9qzwOFAFh7ghyWX44gdWs
         L7ZTC5iFY6DbN1YuDGiz/pEAVmNAbVoVovTeu/m+1UV80Ssm9sgsCIy6wGe5XrvOf/hr
         utKNvk+u+l3ey8j7hFIcd9dPfnlBK475Ik2FB47wDrAfzIVrrkCdcN3G80h0e+GELHeK
         fqow==
X-Gm-Message-State: AOAM531/wlP3CNf6WPzsPxOxlVIxb8vZ0O/Kgt2lAptUPzmfQhEJ/Qdv
        OtntAkmxm/7bth1cNrTP0g5L4oRD6d5NTg==
X-Google-Smtp-Source: ABdhPJxm2xVglq69UaoIt+CW4VCvkkBSrl8uy5LhCFN4E6ZVOdSc2aLwwje6cAnaOUgcDanvoIPzqQ==
X-Received: by 2002:a05:6638:1909:b0:32e:d7f1:9072 with SMTP id p9-20020a056638190900b0032ed7f19072mr12454535jal.261.1654515302361;
        Mon, 06 Jun 2022 04:35:02 -0700 (PDT)
Received: from Peter-Reagan-Desktop-VI.. (z205.pasty.net. [71.13.100.205])
        by smtp.googlemail.com with ESMTPSA id g12-20020a6b760c000000b0066952cfe3e2sm1216960iom.39.2022.06.06.04.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 04:35:01 -0700 (PDT)
From:   Peter Lafreniere <pjlafren@mtu.edu>
To:     netdev@vger.kernel.org
Cc:     Peter Lafreniere <pjlafren@mtu.edu>
Subject: [PATCH] net: constify some inline functions in sock.h
Date:   Mon,  6 Jun 2022 07:34:58 -0400
Message-Id: <20220606113458.35953-1-pjlafren@mtu.edu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Despite these inline functions having full visibility to the compiler
at compile time, they still strip const from passed pointers.
This change allows for functions in various network drivers to be marked as
const that could not be marked const before.

Signed-off-by: Peter Lafreniere <pjlafren@mtu.edu>
---
 include/net/sock.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c585ef6565d9..657873e2d90f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -611,7 +611,7 @@ void sock_net_set(struct sock *sk, struct net *net)
 
 int sk_set_peek_off(struct sock *sk, int val);
 
-static inline int sk_peek_offset(struct sock *sk, int flags)
+static inline int sk_peek_offset(const struct sock *sk, int flags)
 {
 	if (unlikely(flags & MSG_PEEK)) {
 		return READ_ONCE(sk->sk_peek_off);
@@ -863,7 +863,7 @@ static inline void sk_add_bind2_node(struct sock *sk, struct hlist_head *list)
 		({ tpos = (typeof(*tpos) *)((void *)pos - offset); 1;});       \
 	     pos = rcu_dereference(hlist_next_rcu(pos)))
 
-static inline struct user_namespace *sk_user_ns(struct sock *sk)
+static inline struct user_namespace *sk_user_ns(const struct sock *sk)
 {
 	/* Careful only use this in a context where these parameters
 	 * can not change and must all be valid, such as recvmsg from
@@ -909,7 +909,7 @@ enum sock_flags {
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
 
-static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)
+static inline void sock_copy_flags(struct sock *nsk, const struct sock *osk)
 {
 	nsk->sk_flags = osk->sk_flags;
 }
-- 
2.36.1

