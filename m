Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404954CC4E1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiCCSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiCCSRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:19 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FB71A39CD
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:31 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 27so5230656pgk.10
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFD2Eu7ySwZixX0vecWolWD4u1kH+iPN2NO5nEy2DUo=;
        b=XEpC/E4h9OkZwK9gHHf4tAkCk/dS+zYsb0GoUKqomTb/WmtYs9HJfws24/WvYdFGsr
         /1N3iC9K2K0yc6UFG/VEfNY4TwbZeUaI/kBbXfMy3qi7IKXtWOIw0pl8FWni9nX9QPtV
         IsqiP2CZ/97frELkC4Di1VatvYgc/CtXq/H44A+ApznPOaH76lN3ilNzo+dvc7StrKBQ
         9e0xuhKNbkbX4Emyr64FFQBXLYbR+qDRdhxSgMngss7rurdrBwzAI7K9WbvRCjsXCVmw
         rj4950SO8bOuaXP/trgs50u9RfJnLKlj2k2zSfy7mELbkfdaJrtToiZT2+IZSXbShcrF
         6ZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFD2Eu7ySwZixX0vecWolWD4u1kH+iPN2NO5nEy2DUo=;
        b=r8qe4hoWqBpoEFQqR1AMmsK+I8JjeZIuZkrlyWY5TegD7WvJSqiPZaQ0sd70RFlXhl
         XyHSeN71eYtrqYfLadjiDE4FmSrDB9SSIFiwArKEvPgk8PpbLOtXU0DbKKfzXr5fAFDu
         HHEyHxXS5VhoPoAUYzHnujMD6CJHO0MUUiIczNx+c2dF9cNYLEcKv2GIf+LNNM5vO5U8
         NRCjf/rexKCX4U3+2AvFL9t2iZ2XMBqbxTqK5jN2mmrOVoN0sSN90yhOs9aJe93mkX4M
         5OGDJmXmV01/IUFlm0j7VqiFKay/aYkGEtqFmGQf04o3S+hfpw5BWotgIn3KEe0R++qv
         yTIw==
X-Gm-Message-State: AOAM533ZY5oxPLtPomjcUhIkjhGFQj82FzLE1ZGHSxpd5u7t4e02ScUN
        2h3beWopITg4Bbe1heSY1Hu5KQ+h3lY=
X-Google-Smtp-Source: ABdhPJzGnhf9lfwB/A+jBBsDyM1x1jn8QwgviqkVnxmPON2AjIz4nGv9exIGAtVcEWdJrcKYZC6uWA==
X-Received: by 2002:a05:6a00:1da3:b0:4e1:68a4:3f1f with SMTP id z35-20020a056a001da300b004e168a43f1fmr39487327pfw.64.1646331390825;
        Thu, 03 Mar 2022 10:16:30 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:30 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 03/14] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Thu,  3 Mar 2022 10:15:56 -0800
Message-Id: <20220303181607.1094358-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
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

hystart_ack_delay() had the assumption that a TSO packet
would not be bigger than GSO_MAX_SIZE.

This will no longer be true.

We should use sk->sk_gso_max_size instead.

This reduces chances of spurious Hystart ACK train detections.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 24d562dd62254d6e50dd08236f8967400d81e1ea..dfc9dc951b7404776b2246c38273fbadf03c39fd 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -372,7 +372,7 @@ static void cubictcp_state(struct sock *sk, u8 new_state)
  * We apply another 100% factor because @rate is doubled at this point.
  * We cap the cushion to 1ms.
  */
-static u32 hystart_ack_delay(struct sock *sk)
+static u32 hystart_ack_delay(const struct sock *sk)
 {
 	unsigned long rate;
 
@@ -380,7 +380,7 @@ static u32 hystart_ack_delay(struct sock *sk)
 	if (!rate)
 		return 0;
 	return min_t(u64, USEC_PER_MSEC,
-		     div64_ul((u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+		     div64_ul((u64)sk->sk_gso_max_size * 4 * USEC_PER_SEC, rate));
 }
 
 static void hystart_update(struct sock *sk, u32 delay)
-- 
2.35.1.616.g0bdcbb4464-goog

