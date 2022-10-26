Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D631D60E29B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbiJZNwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJZNvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:51:45 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DECF2F021
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:42 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q75so3617845iod.7
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HQzBPd6KHPcD+1NDhZDAIEvnyUqJdlqV66ub1WerTw=;
        b=i87YjYTviOLiibnvyZz+NQCt3JFY9jHR6xjCggn5V7bhPxa5m22/8X3CF6AwLsaR1F
         QaGYV/JHzibezBgDsebTF0SbBI3V1QDuYLBKtBKxecb/KIudqdvhme6v4kFeE+FGlkO1
         do9lY5l9MEO2XUMrDvgCaGgKQjFC0i+UAtAeWFA/Z4VXcve/vEtWcUU4OZCwRHpnRQzq
         0UrGhptx9ae3cNsWZR3ABJtuvjr1E1ywPga7XwVtopEJgu1wF0Gu5ruO/DBIN+CBstcr
         t6nv8rUCA3Rntsm7cBlmOD7K99I2rPuhnmeYFNDJ81vHYHSyKaAKVFsJRU4buLbBaF8b
         3Plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HQzBPd6KHPcD+1NDhZDAIEvnyUqJdlqV66ub1WerTw=;
        b=zA3fLEPkHiFsTpewUEinITkjHJTWP0F1jPmpHrZugKm0sKGsYqjqeV7eVRWo6iDtBo
         XBcqDqWsQ9Fuw/7oNJ9j/6rCs+zmrMN4zLbTWK1IhXqWrFOnxavAyw0JlAqIcdIyzljf
         QsqlgTM2Do6fpUc/iZFM817tWtHNipMfB21JeWEe6Y1fNpGnUUSdV0qjIfg9TXE2p4gn
         Zg2e/0GiKwhsYkVJdGr7HAqb9kOY5CeacUJ4+5qXPU9Ysm1nj4ZcSwEkojTVjy4LOcey
         ZHU83ZkAu7MnTnbdoH8RSFHlOjC8LzNVJf6eq+vXIiSy9F42pL7afFHhwIDTrAXdfG8M
         675Q==
X-Gm-Message-State: ACrzQf0VdYZplPpGpMAhdBFEDg6w6YNzvwjVK4HEF8M2fae70uSFMW4K
        oo03GZNK6PCcVJrhyInXj0YkjmkLK5pAJg==
X-Google-Smtp-Source: AMsMyM7SbhdzQqSh6qVpWYeywS67+PeRVqe/PGCDmMV2jBliB6vppqZGz86NJYfWeciGbTGBU+2gow==
X-Received: by 2002:a05:620a:12ec:b0:6ee:9e71:190 with SMTP id f12-20020a05620a12ec00b006ee9e710190mr30068381qkl.527.1666792291636;
        Wed, 26 Oct 2022 06:51:31 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id b24-20020ac84f18000000b00397101ac0f2sm3211836qte.3.2022.10.26.06.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 06:51:31 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/5] tcp: add support for PLB in DCTCP
Date:   Wed, 26 Oct 2022 13:51:13 +0000
Message-Id: <20221026135115.3539398-4-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
In-Reply-To: <20221026135115.3539398-1-mubashirmaq@gmail.com>
References: <20221026135115.3539398-1-mubashirmaq@gmail.com>
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

From: Mubashir Adnan Qureshi <mubashirq@google.com>

PLB support is added to TCP DCTCP code. As DCTCP uses ECN as the
congestion signal, PLB also uses ECN to make decisions whether to change
the path or not upon sustained congestion.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_dctcp.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 2a6c0dd665a4..e0a2ca7456ff 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -54,6 +54,7 @@ struct dctcp {
 	u32 next_seq;
 	u32 ce_state;
 	u32 loss_cwnd;
+	struct tcp_plb_state plb;
 };
 
 static unsigned int dctcp_shift_g __read_mostly = 4; /* g = 1/2^4 */
@@ -91,6 +92,8 @@ static void dctcp_init(struct sock *sk)
 		ca->ce_state = 0;
 
 		dctcp_reset(tp, ca);
+		tcp_plb_init(sk, &ca->plb);
+
 		return;
 	}
 
@@ -117,14 +120,28 @@ static void dctcp_update_alpha(struct sock *sk, u32 flags)
 
 	/* Expired RTT */
 	if (!before(tp->snd_una, ca->next_seq)) {
+		u32 delivered = tp->delivered - ca->old_delivered;
 		u32 delivered_ce = tp->delivered_ce - ca->old_delivered_ce;
 		u32 alpha = ca->dctcp_alpha;
+		u32 ce_ratio = 0;
+
+		if (delivered > 0) {
+			/* dctcp_alpha keeps EWMA of fraction of ECN marked
+			 * packets. Because of EWMA smoothing, PLB reaction can
+			 * be slow so we use ce_ratio which is an instantaneous
+			 * measure of congestion. ce_ratio is the fraction of
+			 * ECN marked packets in the previous RTT.
+			 */
+			if (delivered_ce > 0)
+				ce_ratio = (delivered_ce << TCP_PLB_SCALE) / delivered;
+			tcp_plb_update_state(sk, &ca->plb, (int)ce_ratio);
+			tcp_plb_check_rehash(sk, &ca->plb);
+		}
 
 		/* alpha = (1 - g) * alpha + g * F */
 
 		alpha -= min_not_zero(alpha, alpha >> dctcp_shift_g);
 		if (delivered_ce) {
-			u32 delivered = tp->delivered - ca->old_delivered;
 
 			/* If dctcp_shift_g == 1, a 32bit value would overflow
 			 * after 8 M packets.
@@ -172,8 +189,12 @@ static void dctcp_cwnd_event(struct sock *sk, enum tcp_ca_event ev)
 		dctcp_ece_ack_update(sk, ev, &ca->prior_rcv_nxt, &ca->ce_state);
 		break;
 	case CA_EVENT_LOSS:
+		tcp_plb_update_state_upon_rto(sk, &ca->plb);
 		dctcp_react_to_loss(sk);
 		break;
+	case CA_EVENT_TX_START:
+		tcp_plb_check_rehash(sk, &ca->plb); /* Maybe rehash when inflight is 0 */
+		break;
 	default:
 		/* Don't care for the rest. */
 		break;
-- 
2.38.0.135.g90850a2211-goog

