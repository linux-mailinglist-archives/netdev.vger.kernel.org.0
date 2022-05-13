Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314A25269AC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383439AbiEMS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383441AbiEMSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:55:58 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2B113F0F
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:55:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 31so8289874pgp.8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lajSQFrAmQ6OJRNALq9XvXIlm86H0i8f/Z4pUjJ7cG0=;
        b=jtymue7j/IrNNp/BIMttKlb2mEU17RfRq0a06OLxNhXfA12XEvd2366TfuSsghMvJj
         TOSwt8DIaXFKYLx7S6uIugjCSiiOoHqz2ENHFBABR/MPPSU+At5elKmkCIne7gBoFyyA
         1F+vrEQnWQqg27VNHtXdFTGHA2EntY8SidlrbNoeRTSkeCDVD1KPJhZrcxtIIfv3tRax
         4YoOUpIjR+k9FbHzShqc7NY3fgfHau7OyJ1s5M51wTdgKFy0lY7HexjhVsKKn18xLuw0
         YawUIkxYLV1fkwlY+PBNCuleRMlcyarW944z3ZSBfYdlKkpG8NO/EUWAPLRnS5puI5eB
         gk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lajSQFrAmQ6OJRNALq9XvXIlm86H0i8f/Z4pUjJ7cG0=;
        b=50UNZr2pohsYrOWZxQrkSvB7Ucpcv/OtzFP5rERoN4b9qSy9S80Jvt2tgu1fAd6x62
         KinIXRpg+iBVVi6WMXl7F3HTFk6rlskY6GuT4Tvp7oCRrerMQUXQZW5s2n5QPcEmr4gs
         mgNDQ4reOCijVKPZXRFvqFcmQDcoQpgCIZsKIteVWofs920U2qZSI2aSwrTNRQLkhEF+
         uELFoCSlR2M0DGg+9U9GT+91u+IKKU32B8q5YPvyxxvfazlm9RlpxieNGn790UjzMSb1
         5ZJ2TyuM3y9AZogHVodAqJ/KY1Xy3aqeCF6dNhZz5Ek+3ONeaIZfqWAetRXF7oMHzhqm
         f49g==
X-Gm-Message-State: AOAM5335cRPEoi8S8B07aBBTImmU2nUYQKESGoWZKzsmeZf/r0tqaBTz
        LEiz+LlPpBcv4B61CuiY90w=
X-Google-Smtp-Source: ABdhPJygy36GADMAjIOXu+zCX1EZyb3tLP1q6qwgrVHJ0Z56rJKWZk1CugwYP/QpwBYYzgsAZ6CIMg==
X-Received: by 2002:a62:1d09:0:b0:50d:fa91:a4c5 with SMTP id d9-20020a621d09000000b0050dfa91a4c5mr5950146pfd.25.1652468157054;
        Fri, 13 May 2022 11:55:57 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:55:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH v2 net-next 02/10] sctp: read sk->sk_bound_dev_if once in sctp_rcv()
Date:   Fri, 13 May 2022 11:55:42 -0700
Message-Id: <20220513185550.844558-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sctp_rcv() reads sk->sk_bound_dev_if twice while the socket
is not locked. Another cpu could change this field under us.

Fixes: 0fd9a65a76e8 ("[SCTP] Support SO_BINDTODEVICE socket option on incoming packets.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 90e12bafdd4894624b3a63d625ed21c85b60a4f0..4f43afa8678f9febf2f02c2ce1a840ce3ab6a07d 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -92,6 +92,7 @@ int sctp_rcv(struct sk_buff *skb)
 	struct sctp_chunk *chunk;
 	union sctp_addr src;
 	union sctp_addr dest;
+	int bound_dev_if;
 	int family;
 	struct sctp_af *af;
 	struct net *net = dev_net(skb->dev);
@@ -169,7 +170,8 @@ int sctp_rcv(struct sk_buff *skb)
 	 * If a frame arrives on an interface and the receiving socket is
 	 * bound to another interface, via SO_BINDTODEVICE, treat it as OOTB
 	 */
-	if (sk->sk_bound_dev_if && (sk->sk_bound_dev_if != af->skb_iif(skb))) {
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	if (bound_dev_if && (bound_dev_if != af->skb_iif(skb))) {
 		if (transport) {
 			sctp_transport_put(transport);
 			asoc = NULL;
-- 
2.36.0.550.gb090851708-goog

