Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C8F5F03F6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiI3Ez5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiI3Ezb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:55:31 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9951176E0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:06 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id s9so2183403qkg.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6CT5sAkmztiOhQ7AJtMRLp79aMPquFfDN7VlnvRx+zY=;
        b=UASnhgJSYfBF7HqeFSxp/19B1AvZLvz5BU3fc3HGt3TeNr5dV0x+PrGPAUjCOx4Xvn
         IhN0bOs9J2cQTVJ/3d5EgG5XofcMh4MDSkvLiOuaH+t9i8r32pprnM9l3AT/2kKSdBOC
         8Wiw8Uud+1jxpez79VTYW4towzmqCO4gTOvyN4P8juzp5xfvfsOGuo9z/8NBQeykaldW
         RG78yOFoIyLJnr5dI1Hh8b3CDlg9ArevUpE99F3ilq2i5JpcjHDep2qzO1wMvzdde+Jh
         orLWsJwPj7qN8ieI6P5Lax43+E4VF7lBVIHw9yV2zgQbS6lnCJbmebKXskroLjsS8ZVV
         NwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6CT5sAkmztiOhQ7AJtMRLp79aMPquFfDN7VlnvRx+zY=;
        b=JLWA2QGnDvs3YfdTiY87aCZLTaoo1lckMdRtcP8+pRqcGd5FDYLCn+Iflg/nNo7ShZ
         GBZv6RpbRkPI8rfJXG7jmDZaDjPfZD5a/REdvnq216PVRReHHUNxqYnVR1zvZOv2K3IH
         naZ+BI5tRaQe0RVuoXR7JRXOR+T2C5eBeJgASKfgDRbIYssHEb0YbpkAbI+R52sMjeAL
         tAwQQf6S1WImKVIvVh9zeh9lWE6j7x0B+Yh4xBkYr+B+vMed965D/AzkB9T7UHxwGr/u
         i5L6JGRle9itTEESLLnccD7tiwARsRnI5o8MQxjtBpGqohNbFqUsc2hFXtk+pdl35lIn
         DiHw==
X-Gm-Message-State: ACrzQf1GfhL2HZldo8N1OtABYM8FQBH0vu+mwGU9H4cu07cfOfD78CJe
        Cna0iv3KGxFOVMHY/OSawrQ=
X-Google-Smtp-Source: AMsMyM54tvN3nPyioNt4Kro1FRh8V1LI3HWChmE/+Z7ZGUVCXR/rmtH5VvLAbz5BWDk3Og/ozvYEsg==
X-Received: by 2002:ae9:f810:0:b0:6ce:3cf5:42cc with SMTP id x16-20020ae9f810000000b006ce3cf542ccmr4626866qkh.216.1664513634639;
        Thu, 29 Sep 2022 21:53:54 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id de9-20020a05620a370900b006bb82221013sm1550059qkb.0.2022.09.29.21.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:53:54 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 3/5] tcp: add support for PLB in DCTCP
Date:   Fri, 30 Sep 2022 04:53:18 +0000
Message-Id: <20220930045320.5252-4-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930045320.5252-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
 <20220930045320.5252-1-mubashirmaq@gmail.com>
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
2.38.0.rc1.362.ged0d419d3c-goog

