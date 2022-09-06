Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251155AF669
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiIFU4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiIFU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:56:38 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CDA92F69
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:56:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id az27so17248311wrb.6
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 13:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Bzx+cD7xk0ffAd/x0upRKnsqyh6CtsmmDF1m6ENUxaM=;
        b=IpNFDVABVsbGTVL4O05HzyVsipCk56tBqMmYN3RVWBY3xdRsLjzWYVOwhOfY9EnSZT
         2u6617ukv5IOnBEqJWzwq3qWtdkSd/UefYW5LT7pf8Pb9FnttIfbc7hN+l2hJTFbTxsi
         MzeVctChyR3S7W4U8ap5yYKknGIlYYCBVwPpXmEU6Dxg76CZYZCe3rzUiimvmpVdRAt5
         F0OOfxq11cQbdnydVLNpF/LHbdKu0RFzlfyNoZgxyJEnGen843AmYW70oKP3raLZQuWX
         x4Tuog8sPIgh2DtJpdk/YIwCNRnD32OGNUierc4TXMqmmnTAJ8xT4/Zmrwlh80pH71j8
         46nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Bzx+cD7xk0ffAd/x0upRKnsqyh6CtsmmDF1m6ENUxaM=;
        b=a3TXwRqts2b3YeE86c5vjO4BkK21CpZTnfqc92d+bZ/EjNHcG06ymCePqowSIfwi0Z
         ObSeBrO9nY6nNPSjgTu9Am0MrBMMWNo55GbOylfvmvAJ/SbUrqMuqNBnt+nKjTAFqBH+
         106d7b1vCN8eIpEq0JAsLnxftJAIdQht6TBg2yqwklhAZcIJbCi2EV9sn+jWajG3ocqd
         LtS9CnLXOpsNNwNXsAY2yubOOJ77QFaMsE7dQiU0AVDSfIQ9NCiKG/oGrpNtO4hKI5zO
         +snCJuoRs+ZmqIo7FiGCE2sK01UjvvinouZG37T4g1MBx188wNeeUp+HS2bgt6+l10Jv
         Te0w==
X-Gm-Message-State: ACgBeo3z/4F/aEX/MdpQlbuDhrtL38gklNlTLqQAIrpymlydd4P/tpir
        6hreM9zZgBy07eQvwLsdXoRSiw==
X-Google-Smtp-Source: AA6agR4csVvGLH1IsqcOSvdAYqNYq9G3fSXUikGRnM1gpJqqiCWMN5qC13x9mChWks06jED8eDrCYA==
X-Received: by 2002:adf:f4cc:0:b0:228:ab76:fa13 with SMTP id h12-20020adff4cc000000b00228ab76fa13mr176515wrp.110.1662497794138;
        Tue, 06 Sep 2022 13:56:34 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n24-20020a1c7218000000b003a317ee3036sm15735887wmc.2.2022.09.06.13.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:56:32 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] mptcp: add mptcp_for_each_subflow_safe helper
Date:   Tue,  6 Sep 2022 22:55:39 +0200
Message-Id: <20220906205545.1623193-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
References: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2778; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=FzIWMWFonpoxcP1L4R9vUfT0ariFVPfRrgBWzxMq3A4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjF7O5M9GDs9tE3T0u9pD8nPu9iCoCtaH4vovheHBF
 6ifLOcqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYxezuQAKCRD2t4JPQmmgc0PGEA
 Cuipi8+Slnngy8VjGZnlG7dgxNZ+n1VE6WdfroG8gP/pqr5CVioCmHKwKK2n3nJPcAnE9QYxjRYPoT
 0a9K/XAJCqFm59av5uXcrYab0mgVvl6SgSXB+tDXGoQb9mRYhAdHrzdd/n+O/jqfMZgHYANCtKr2Mp
 UMf751iAQvZAFC1cpsNrb1i9ZsQKatBdAaV6plI+lY+j71zsCURB+T9gk6rRK8znxndk27+49n9tfR
 9j8cbZmDXH0StxbDzyH63j3drLOD0+g3z9gCUJyicE4bXLI24QzpRsvOZ+yGThXVodkVLkyqCd+fTT
 WADc8jbnAr/C9MlGDB1u951ZsZK7A9PkU2br47vXIAif5DJYMHlug+EpVFubBJGwQqOQNbxyD4kdvF
 EZhE5ehr5flBZztz0+w2tGI/oDoQ+PAd5XZo3Gi04GkZprbrxEPNj/mLRsa0/M2qRBEG+6ZO72bLra
 FrK6KLtLgoHKR2KqJWlw2j8M8xOIFNtRca4XNYjtYtTLt8LSj4AM0+gdsljC3fQAiNOMi2HB2MIOAS
 OukMMjwwYjO9YUW6hZxnP03n/sRsrTSUTQa41PCh5TztOxh+7wZ2ArR+XKUubBc3gsOUR2IIHXN8be
 nAqEEWQALEwYLirGj7hvv9q/PKSVGnC/Rk9D6uGmRhNJrZQUl58e+RpeKU+w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to mptcp_for_each_subflow(): this is clearer now that the _safe
version is used in multiple places.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/protocol.c   | 6 +++---
 net/mptcp/protocol.h   | 2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a3e4ee7af0ee..5e142c0c597a 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -796,7 +796,7 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 		u8 rm_id = rm_list->ids[i];
 		bool removed = false;
 
-		list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		mptcp_for_each_subflow_safe(msk, subflow, tmp) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow->local_id;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d398f3810662..fc782d693eaf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2357,7 +2357,7 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 
 	might_sleep();
 
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+	mptcp_for_each_subflow_safe(msk, subflow, tmp) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 		if (inet_sk_state_load(ssk) != TCP_CLOSE)
@@ -2400,7 +2400,7 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 
 	mptcp_token_destroy(msk);
 
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+	mptcp_for_each_subflow_safe(msk, subflow, tmp) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 		bool slow;
 
@@ -3047,7 +3047,7 @@ void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
 	__mptcp_clear_xmit(sk);
 
 	/* join list will be eventually flushed (with rst) at sock lock release time */
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node)
+	mptcp_for_each_subflow_safe(msk, subflow, tmp)
 		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, flags);
 
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 132d50833df1..c1b12318535d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -314,6 +314,8 @@ struct mptcp_sock {
 
 #define mptcp_for_each_subflow(__msk, __subflow)			\
 	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
+#define mptcp_for_each_subflow_safe(__msk, __subflow, __tmp)			\
+	list_for_each_entry_safe(__subflow, __tmp, &((__msk)->conn_list), node)
 
 static inline void msk_owned_by_me(const struct mptcp_sock *msk)
 {
-- 
2.37.2

