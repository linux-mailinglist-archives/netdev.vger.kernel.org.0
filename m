Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9516054B778
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244756AbiFNRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245239AbiFNRRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:17:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD582A43C
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:17:41 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so8289113plg.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PX4xpZVSDZWWYzf0Mgpk64vZeG3iQ4tbiusifSgBIMg=;
        b=NNOSUsZOXzsJ78Ul0a43M4kgxpNn9bZ7hY7dLpe9lFiWYg31ROa0EsgDNvO646xv83
         qGOrUX6xljcSLCvvlBPvpCDDcIHjuzfpqwSS85K8ORYDdq40HCcw48P/SrkY7GI3gJZK
         lbgnKgeJcZMXRVHmYZclOBhest7/44n0eNiwwAcwjC4PRFL1NvofOnz20UJUWY82hwWk
         KYYa4k6PBy4TUXVxcXBH1S4yJEYmpqxiPsggxrhybMOkVAHejLafK1FOgvb9ZFUz7D1P
         Ib+vTa/B3ffnQSZEawZfVFt7cwDAByoUM5EEAirkcPLtyzPWtSonaoLY3+oIeKO4zEWB
         BMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PX4xpZVSDZWWYzf0Mgpk64vZeG3iQ4tbiusifSgBIMg=;
        b=CdltVWq5Y4HZUJgruHlUMQ8Kd00Do+5PdcZiFCrXJnN5/UHOsKR4v/SioDbl0/2S4v
         bl1mAN+/c2/FMhEUoetzGaIkT3LyOAvekXb366ujJ9YS7E3WFkRTRy2twipvtl+tSksM
         qFcUlocUA1KmnYWkuWx/xSPGhsLIs9AtVa15WAIKz+7GTB+S0GaE7xemwQHKQwRDgLIq
         kDUnhjOUybI4bSNwtZIS5TfGK2OS0TCCiqcLr57hCMhfZz0NfKQCBPnGtH4z/brlsRqj
         kB5/IXJ1ggpg186dDFc01QECN1oecEfHUrKTahTMH/1blxz7HRyichqjmLdSLXQz/x/W
         Q6yQ==
X-Gm-Message-State: AJIora+XTATghPffgW7WZ5/GwaJpklISTnlubTFUZrCSkvU1m1vdsHjb
        iUQXJq7eRAXTmLio5WRs0xdPLeenTJY=
X-Google-Smtp-Source: AGRyM1t29oZfGJi5u+mz1Et2hPVNO+q5ai+RFNDq4HPzUILjKbjLO2kMcHLjtYSUAJBgDgthNMd+QQ==
X-Received: by 2002:a17:902:ca0b:b0:167:4c4d:7320 with SMTP id w11-20020a170902ca0b00b001674c4d7320mr5235569pld.113.1655227060666;
        Tue, 14 Jun 2022 10:17:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2dbb:8c54:2434:5ada])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902e15400b00168c523032fsm7435883pla.269.2022.06.14.10.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 10:17:40 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 1/2] tcp: fix over estimation in sk_forced_mem_schedule()
Date:   Tue, 14 Jun 2022 10:17:33 -0700
Message-Id: <20220614171734.1103875-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220614171734.1103875-1-eric.dumazet@gmail.com>
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
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

sk_forced_mem_schedule() has a bug similar to ones fixed
in commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
sk_rmem_schedule() errors")

While this bug has little chance to trigger in old kernels,
we need to fix it before the following patch.

Fixes: d83769a580f1 ("tcp: fix possible deadlock in tcp_send_fin()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 8ab98e1aca6797a51eaaf8886680d2001a616948..18c913a2347a984ae8cf2793bb8991e59e5e94ab 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3362,11 +3362,12 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
  */
 void sk_forced_mem_schedule(struct sock *sk, int size)
 {
-	int amt;
+	int delta, amt;
 
-	if (size <= sk->sk_forward_alloc)
+	delta = size - sk->sk_forward_alloc;
+	if (delta <= 0)
 		return;
-	amt = sk_mem_pages(size);
+	amt = sk_mem_pages(delta);
 	sk->sk_forward_alloc += amt << PAGE_SHIFT;
 	sk_memory_allocated_add(sk, amt);
 
-- 
2.36.1.476.g0c4daa206d-goog

