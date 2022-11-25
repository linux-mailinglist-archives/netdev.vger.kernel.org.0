Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB200639161
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKYWaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiKYWaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:23 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146862EF24
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:22 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ho10so13078376ejc.1
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBCA9x7cMHFPqIe5fGwepfqiKMVw0+m7IHknfbCdlF0=;
        b=c4GJegnFhscWlswG9LjL8CSsHpMrKyPlAnk/rkgzodpxvraVmNjjszAdKN3CsoeQP5
         cuaWCe1O1vAcNBFyy19bPjx3pU5U7w+es/uQ2+o5o3UY1Fqo3+hMjcG40nS6Zv39REoj
         g7LLy7n4V5IwL6+fv4UhFuvMlxcyVo7zfFrFQeyGYueuURdJnVG7hOextaFaZUm06L4i
         hKUkezauVV7SdAy89wIun4w3MnhHqYu8hp23UiAicyvkaYthXTN5feji+m8IBF5VJuUW
         jNyFdHIQ+gTI6eG8GKPqT4AfdrQTqiipuBvQlTLcvHYoJYc4IIbjiJFWJ7h+qIO8EYGV
         ALVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gBCA9x7cMHFPqIe5fGwepfqiKMVw0+m7IHknfbCdlF0=;
        b=AKyq7kZeqYKgzYh+/xa8SZQYOPmo2rBbk/GVANSPsT7v0yPm+oOubS+f4lNYxXFphh
         VqSldVR1za7suCm1Msdit2O4M4Lxn1VjsIT4Jaq7a3jZebdMWhUhccEN3d/FCnuecabb
         RWwfPiXPyCnK4dF+zdJSUHq+TQUAf9HfVCEvLJBx5qKQ0BojDUnxfYgEau2hQMviuPp2
         Jp0MGhow80ZP+riv54hl+QDnCoc7ESmZHhBXLAqGU7oy0GU765O0v+W3JakgS6RtpNIm
         LpZLb0uqJgEpsmTsonpHv9ribFITIxDHDwMcMpOErATpE/Col/gvVWROE0ec5uHYRE0c
         BfqQ==
X-Gm-Message-State: ANoB5pnKIVtcDhizxGoXB8C6dhcW8mzS3nOdl8GiQ2Rtjj85o4d4izQ8
        iUS0jOZ5/MNVeP42z57YyUkewQ==
X-Google-Smtp-Source: AA0mqf7tcCCuYWQCzoa8E+2Wqa+6jAb3SM+sieUX9y+zBWeZmACPBwf/2wNNh0wf8PHwl9iKRd4KpQ==
X-Received: by 2002:a17:906:5293:b0:7b9:631c:451a with SMTP id c19-20020a170906529300b007b9631c451amr14565134ejm.283.1669415420533;
        Fri, 25 Nov 2022 14:30:20 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:20 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] mptcp: add MSG_FASTOPEN sendmsg flag support
Date:   Fri, 25 Nov 2022 23:29:47 +0100
Message-Id: <20221125222958.958636-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1505; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=A6FMBCW63WCmAXAOc+ddPtBLco+9STQpRswEd8AeUr0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHPa4vNEORZStSCr2EV2UfU8z3wnaTzRh2RWb3b
 PqdgihGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FBzwAKCRD2t4JPQmmgc8BrD/
 wM8u7SAV3orCOwAotH2p43JebnN3OvywrxZXGzPSe3U7xONwt+YTQTVeZrg/gsPdcGGFPGLkgCUljz
 adJbw8b35ljOseooC0t9ep5Z4UdfnXi27QUde7uu+0BlfdfrIVEavcr/cCk1kiI4MaE8GIXTjV+Q7J
 SgaE0nnHuLMhHe20uZfcTQLSKOR83V9DAgkmYBPefWfeADEoKJWhdcjgLDAyWcz0+YN00sA72G6OmG
 m0/59Cvy+0U9lRKlMRefLQweAqKnsyLfmfl8g/+RIHtWn96rijUlIPcK53w8taPmjj7/6TIXYlQFHM
 jlrD16pqbrDdwqVanTAf85KGSZTAEmHuI7ifJ7755jiMF1HjfHclVxP7AoRuVP1S4oodO9wGW2aOPh
 +VHUGVKA4Pn/UGnqVzRi0OvqV9bN/uPAwJ5Bn7XaHRvXN8/GURbDZ+Mw9jda+JN5m34dLkf3KEbFdV
 /vvmKmQKKM2IW819kcfVxcA1LVUlPpf+dXM4MK1KNmFBBCUKgyxHKNSVOIol+uRifFSSWH4k4i+aln
 KEjV8d8UDY/nz1K94TJdh1E2XRlCIUyqs7i6SSvCdU4WaXixerANvP2+PPB4SAdGcWTL5MTNqXpICa
 wC8ASt63uAC2Rl8FYcwgEQqqxUbU96dBEjOhz3dX6IO8bTT0X1322A7Ft2Mw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>

Since commit 54f1944ed6d2 ("mptcp: factor out mptcp_connect()"), all the
infrastructure is now in place to support the MSG_FASTOPEN flag, we
just need to call into the fastopen path in mptcp_sendmsg().

Co-developed-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3796d1bfef6b..37876e06d4c4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1711,17 +1711,14 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int ret = 0;
 	long timeo;
 
-	/* we don't support FASTOPEN yet */
-	if (msg->msg_flags & MSG_FASTOPEN)
-		return -EOPNOTSUPP;
-
 	/* silently ignore everything else */
-	msg->msg_flags &= MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL;
+	msg->msg_flags &= MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_FASTOPEN;
 
 	lock_sock(sk);
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (unlikely(ssock && inet_sk(ssock->sk)->defer_connect)) {
+	if (unlikely(ssock && (inet_sk(ssock->sk)->defer_connect ||
+			       msg->msg_flags & MSG_FASTOPEN))) {
 		int copied_syn = 0;
 
 		ret = mptcp_sendmsg_fastopen(sk, ssock->sk, msg, len, &copied_syn);
-- 
2.37.2

