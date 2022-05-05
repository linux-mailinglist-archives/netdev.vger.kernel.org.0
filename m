Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5216951C042
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiEENMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiEENMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:12:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD3D5643F;
        Thu,  5 May 2022 06:08:43 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x52so3592445pfu.11;
        Thu, 05 May 2022 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ygWgolZv0vpFbsXb9qRTpWXxJ3LS36RLc/Ro0DAsCd8=;
        b=YUGiQ+r1PwViVgJIpKNS9sjK5Sl5tGqSNWQ3nBGzVihmoy8DVQnZDQnr/+R1ye3f1t
         nUrdHk7eZnC2r+o+sV1pgnDNZJK1qdT4GBD7L6CJJtpaLz6LfRpSdYvsjTwjIJo51+Oy
         +Cn6Ef3aeVPzbqo8R1sSl3U9LihbWk/z0fNnneGybSMDMU5svtlMTaQG0C40d8Hg4haN
         7oH9y+yZdSVTrcews7k97lQLb4fcDhMxNIII5OjQPxjQ7SW8FDTOB60v5fQCv3AJgrDO
         X6LsJI54hJ0NBLbv2Jl/82ItOtGmurheT3RNv63ldTkrvf7mG85Zh5JL/ubob/e7zUDP
         X+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ygWgolZv0vpFbsXb9qRTpWXxJ3LS36RLc/Ro0DAsCd8=;
        b=Q2Y7rXrFHYfWfgZ2ajZZOLfakNqLewygMwifn3kQ6h1NcPmhuWfWLrGzJhMsxyaZmt
         0lPb/w2o4HMDjle/TzZyTFSm3NAYHl+zEbFl3/GXUFjteHiQ8CJERjC4gXJQT3XV1jui
         qvO6C5Dywsd3Af/xqi8GYk3Xqzkpf8azJzmNZyI11u8vs7fnlcs+9qnOWmKOF5X0S/a7
         cZFS/LBqJCCdQBYeexI6ES4vmdnZLQ79kkXbmSNS0EpGExidEFkrEgBELI4pbmXSkVtd
         1qFwGMZ15ZDvvtN4XDWScVmzOfSrPx99LPJWaxHR2a6L7JDgNYO3VpF9EmsA9R1CuWF4
         Q3lQ==
X-Gm-Message-State: AOAM533AGHaCrhkhXt1jqWp/CKcXyyOCX9bUP6S5LKziiswljfNnkrr+
        /D3YXwNQv9H1jOYstZk279Jy6NpEEBaOPjBW
X-Google-Smtp-Source: ABdhPJyuxZPZsvp6n9JXzaCaRV3rMdMn/XZ06g/dvH49I+5zl53Y9fPDzVmIuBEyTiJb3DA9Y/Qb9w==
X-Received: by 2002:a63:89c3:0:b0:3ab:238f:134d with SMTP id v186-20020a6389c3000000b003ab238f134dmr22473029pgd.387.1651756122725;
        Thu, 05 May 2022 06:08:42 -0700 (PDT)
Received: from localhost.localdomain ([61.16.102.75])
        by smtp.gmail.com with ESMTPSA id p2-20020a1709027ec200b0015e8d4eb2d9sm1431824plb.291.2022.05.05.06.08.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 May 2022 06:08:42 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <xingwanli@kuaishou.com>
Subject: [PATCH net-next] net: use the %px format to display sock
Date:   Thu,  5 May 2022 21:08:26 +0800
Message-Id: <20220505130826.40914-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

From: Jason Xing <xingwanli@kuaishou.com>

I found that the current socket address, say 000000009842d952, cannot be
searched in messages because %p format function hashes and converts it
into an unique identifier which is currently useless for debugging.

Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 net/ipv4/af_inet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 72fde28..b17a4d4 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -139,12 +139,12 @@ void inet_sock_destruct(struct sock *sk)
 	sk_mem_reclaim_final(sk);
 
 	if (sk->sk_type == SOCK_STREAM && sk->sk_state != TCP_CLOSE) {
-		pr_err("Attempt to release TCP socket in state %d %p\n",
+		pr_err("Attempt to release TCP socket in state %d %px\n",
 		       sk->sk_state, sk);
 		return;
 	}
 	if (!sock_flag(sk, SOCK_DEAD)) {
-		pr_err("Attempt to release alive inet socket %p\n", sk);
+		pr_err("Attempt to release alive inet socket %px\n", sk);
 		return;
 	}
 
-- 
1.8.3.1

