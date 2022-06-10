Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D845545AC2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346212AbiFJDpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbiFJDo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:44:57 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F3E380839;
        Thu,  9 Jun 2022 20:44:56 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id i15so5045646plr.1;
        Thu, 09 Jun 2022 20:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLTpWfEYARxnaBZe2tmsRz6wbhK6fZ6IiWkByiKDceA=;
        b=WH6UUBMrnFxq5pWLa7MsNH2J14XF29eCtBTrTaQvSsdnO+srquKuC0LowcntUG7rPF
         mj37pD3J6Hh1PBOI4ltrMtCsqM9ngRCw1Fb6Ry+R6x8AlObIIYqX5zhNZPvfp+fP5Jx2
         50Z74KjShS5bG9A16SWVSghZ7i/sWFYWOPatcxqIiuAIxVRPiAF0bW+7dVot0gwlP3cw
         Zl3CceAZh8hC+qtjtEH8r71LZwauLM8GsJUqd19IXpo2JunP4tNAV2g0rLUmt/xlYPuj
         LBjF/31Z2Qw4M2FaWU8w4VOD2lVfcqSnDNriebh3lfWP7qd14qkNL7UQAcNF7JCs5UaF
         VULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLTpWfEYARxnaBZe2tmsRz6wbhK6fZ6IiWkByiKDceA=;
        b=7cA5BCdf3i+GUgWKHmzr9SBpJqzJ857ErkAOJ/kOEZ3EUbuTjgUKVdtscxlGrU5wfU
         X6L/HVW1iWZC5XyW/Na+A49dHrRcMX2OPdMeWT+ruHeUR+GKqPG0x/mo8APRKQkn73HX
         m9/6m2i4RonyVzmL9iJSIlBboSyB2fjhRzQZf9oF+QMxvZDUta5PauW3ql206gzPj809
         d9sG/UyFPoShTW9jZNVAmQKGT8bq2xCSS8/G0LyJwJ6ZK0/bAE8cv2Ezz3Dl59QE+pdl
         t0QsIrNZGIlg8SfYAyrF/5qC6hh4fAljm6tWPIB5r64bcc97suUD9kTGo9Tn59oKhoP3
         Uxtw==
X-Gm-Message-State: AOAM531Ep7/fwMS7CH6zn7mzNR9qCiksxWeRUSZCo0w1OR7qlgHYchne
        pXynLAkl0TUiQ6dJHgxTFYg=
X-Google-Smtp-Source: ABdhPJxFOjQUQMQvh+McDuc5ckf06fMo+WdtXUr+NnJhN1UV7fUMPe903WR/5MNopMhzlEg6cK4dJg==
X-Received: by 2002:a17:902:e0d1:b0:168:bedf:7146 with SMTP id e17-20020a170902e0d100b00168bedf7146mr200378pla.107.1654832696233;
        Thu, 09 Jun 2022 20:44:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:44:55 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v3 3/9] net: inet: add skb drop reason to inet_csk_destroy_sock()
Date:   Fri, 10 Jun 2022 11:41:58 +0800
Message-Id: <20220610034204.67901-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610034204.67901-1-imagedong@tencent.com>
References: <20220610034204.67901-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

skb dropping in inet_csk_destroy_sock() seems to be a common case. Add
the new drop reason 'SKB_DROP_REASON_SOCKET_DESTROIED' and apply it to
inet_csk_destroy_sock() to stop confusing users with 'NOT_SPECIFIED'.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h        | 5 +++++
 net/ipv4/inet_connection_sock.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index fae9b40e54fa..3c6f1e299c35 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -231,6 +231,11 @@ enum skb_drop_reason {
 	 * MTU)
 	 */
 	SKB_DROP_REASON_PKT_TOO_BIG,
+	/**
+	 * @SKB_DROP_REASON_SOCKET_DESTROYED: socket is destroyed and the
+	 * skb in its receive or send queue are all dropped
+	 */
+	SKB_DROP_REASON_SOCKET_DESTROYED,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index c0b7e6c21360..1812060f24cb 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1129,7 +1129,7 @@ void inet_csk_destroy_sock(struct sock *sk)
 
 	sk->sk_prot->destroy(sk);
 
-	sk_stream_kill_queues(sk);
+	sk_stream_kill_queues_reason(sk, SKB_DROP_REASON_SOCKET_DESTROYED);
 
 	xfrm_sk_free_policy(sk);
 
-- 
2.36.1

