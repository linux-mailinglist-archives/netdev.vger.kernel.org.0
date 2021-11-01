Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AD6441E5D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhKAQiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhKAQiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:15 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFECC061714;
        Mon,  1 Nov 2021 09:35:41 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 5so65287363edw.7;
        Mon, 01 Nov 2021 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C1JDx8MgKU4JCNT344IgLl9Cl3PKPBGqorAF6Avl50Y=;
        b=nSqyXEe9k2xwGuTIFdrOnlKClHxLT4VfcTESz+OeE5J/OZEYzlCLsF/USmyjmHlwFi
         s5gCv9EwwhakIZ/Gz1ey/SIjBoKw3fxgfoPT7gN4dqXuq2NmCf6z5qO7XOkP601E1OXW
         voPaY8e0FGUoSLLXlk5itq01OMhJNPAToUOlGFgUUQH49oq51L0O1huTqkHf9oEzBkuE
         aGLH/YL83KlHAFS/RAqlKjnIJk+UtGok6sd72UJn33ykD7jL2/Y8BDHYbKyu8qpZcyu+
         tHun82uAn55ucX4ZjzuThpfkSQyY6b/yjMaN+tvSYkDG7YhTxhi/Pwnwq22VWJiQ8fC0
         TxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C1JDx8MgKU4JCNT344IgLl9Cl3PKPBGqorAF6Avl50Y=;
        b=m2bTegsG8VDWl1X19QNen4Rr4DogcKBwfJ2DctMmiMz6Xnip8GFmUNjc1FhZ2nARSM
         vMOQ/g8eqU6WCQdINjaMVm2kp0VDG23ZFJJwe/chsh7uHOdTE95ahr5WL14Dm/kGrnh8
         EU+iKex5MKLUyMxLbzNZJiMgig2ZkJJ7Nezq64zcTo3/niny4VRm2blYVC9T8r3BE2Z2
         zCLK8ok/UrRt5BcDOsO2582MTLbfZk+afkYc6iiD3tpzsoiLJD5ONHceYp7XWXK/h69W
         9fSo9gYbhj9qKdSQ5PCUEX1Kyj9mzfimiCTu+P8v+12RCPWWKIgc91kauZe+4bTx96Dd
         QxTg==
X-Gm-Message-State: AOAM530rN7gRxlSFkemQMapwUmP1CSx/4F3jphV4+l+r70sXB/BgNV/z
        jRHNOULhUN27VLnh3OWVUxs=
X-Google-Smtp-Source: ABdhPJzTY3Qnt4GfhLy3uv8Sl9V59utghnl9eccv0GntrHj0PQqlJHt1ELshiDqCDae7/rM14vz64A==
X-Received: by 2002:a17:907:6291:: with SMTP id nd17mr37083612ejc.194.1635784539936;
        Mon, 01 Nov 2021 09:35:39 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:39 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/25] tcp: Use BIT() for OPTION_* constants
Date:   Mon,  1 Nov 2021 18:34:42 +0200
Message-Id: <dc9dca0006fa1b586da44dcd54e29eb4300fe773.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extending these flags using the existing (1 << x) pattern triggers
complaints from checkpatch.

Instead of ignoring checkpatch modify the existing values to use BIT(x)
style in a separate commit.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_output.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6867e5db3e35..96f16386f50e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -406,17 +406,17 @@ static void tcp_init_nondata_skb(struct sk_buff *skb, u32 seq, u8 flags)
 static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 {
 	return tp->snd_una != tp->snd_up;
 }
 
-#define OPTION_SACK_ADVERTISE	(1 << 0)
-#define OPTION_TS		(1 << 1)
-#define OPTION_MD5		(1 << 2)
-#define OPTION_WSCALE		(1 << 3)
-#define OPTION_FAST_OPEN_COOKIE	(1 << 8)
-#define OPTION_SMC		(1 << 9)
-#define OPTION_MPTCP		(1 << 10)
+#define OPTION_SACK_ADVERTISE	BIT(0)
+#define OPTION_TS		BIT(1)
+#define OPTION_MD5		BIT(2)
+#define OPTION_WSCALE		BIT(3)
+#define OPTION_FAST_OPEN_COOKIE	BIT(8)
+#define OPTION_SMC		BIT(9)
+#define OPTION_MPTCP		BIT(10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
 {
 #if IS_ENABLED(CONFIG_SMC)
 	if (static_branch_unlikely(&tcp_have_smc)) {
-- 
2.25.1

