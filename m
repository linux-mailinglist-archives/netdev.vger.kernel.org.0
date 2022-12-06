Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E500F643BD6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiLFDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiLFDVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:21:11 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6582A222B4
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 19:21:10 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 65so681809pfx.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 19:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IVhIY4UWF/5X7MjyjLwZX17dLT4es9nKPf5MwEUtlEs=;
        b=DPBQ2MFpASK7RiJG8rGdgwyp8Blvpvi6wt3/xHBoJ1C9MxKZ/MiM14tLCZqA+XFfVX
         NOLxWLI6adAVJQo0vh6vwiGZaQ9gO15u1fGTMSNuZ3eIpSiqEkH+gao9gNRUbZelWHEI
         jumEtgjvv63Vxnt+wsDo0NNseyHDh3AXZEYTzphcnrOfymeEKPIMCyBWzFgLrPw6A33i
         1cvHywPUEPsSKGWAWSW8VAeyrSizuw2JEeE/TeoVtwxrb+S00NnkrWkUKAR0cXPBkX+w
         nQshwYoJfwWj9ImdDYNpYc7vJ15LwXSOXviEvrTl/wpAbs0M3bvt4jWFOzHRFPSkNsus
         GoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVhIY4UWF/5X7MjyjLwZX17dLT4es9nKPf5MwEUtlEs=;
        b=hM2LsMSPHWanOm7E8nMCjk3ZbPe2S1lgZvwb/YCjDBnA3evNgR9WCgjP2cvS1HXGlV
         4WhVNjeCFEsw6In8z8KwYgGr0JlPn8SXKFLr2Mr8dv1AUlMe2UHdA24HnTkbJobs7uFQ
         /GiddKFZ+I+RPOqDflPzGbW8yB6x0oKs+AHB2XKRlSiQ28iJnfVHNsygIc1BokOH4/xE
         4XoJZYgn8oEjn5yIZZ0bHUOHL8oR/waGUFwdQGopekKf5Fr+7EOzLY4+Qr78d1Wg4fAm
         zYohwseMflRcM6kKaTmgJoKBecK/YAYtO85iEYOlHqb+D/xPlYAEwP3qZFXI+CDPH1a/
         Gk4g==
X-Gm-Message-State: ANoB5pmOgZ9/H/KzJkXug+VQvFHdDd3GeUwm7fDNqaAHLPaCy5gfTECq
        LL2lezPThmazUUV9R3tUkWO+N3LrxreO2Q==
X-Google-Smtp-Source: AA0mqf7h3F3Q1P7zOXi1bpMDIZJgCjJ4O3wzoK+p6oFgP8iOh3S3Z1BndDnMM5ddIoKYBfJ9vN4ehQ==
X-Received: by 2002:a63:e411:0:b0:45f:b2a7:2659 with SMTP id a17-20020a63e411000000b0045fb2a72659mr60057480pgi.132.1670296869480;
        Mon, 05 Dec 2022 19:21:09 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 137-20020a62198f000000b0056b9ec7e2desm10498294pfz.125.2022.12.05.19.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 19:21:08 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] bonding: get correct NA dest address
Date:   Tue,  6 Dec 2022 11:20:55 +0800
Message-Id: <20221206032055.7517-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

In commit 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving
IPv6 messages"), there is a copy/paste issue for NA daddr. I found that
in my testing and fixed it in my local branch. But I forgot to re-format
the patch and sent the wrong mail.

Fix it by reading the correct dest address.

Fixes: 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving IPv6 messages")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f298b9b3eb77..b9a882f182d2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3247,7 +3247,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		goto out;
 
 	saddr = &combined->ip6.saddr;
-	daddr = &combined->ip6.saddr;
+	daddr = &combined->ip6.daddr;
 
 	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
 		  __func__, slave->dev->name, bond_slave_state(slave),
-- 
2.38.1

