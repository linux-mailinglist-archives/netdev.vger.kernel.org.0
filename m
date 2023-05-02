Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCFF6F47B1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjEBPwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbjEBPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA129358A;
        Tue,  2 May 2023 08:52:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ab0c697c84so6979105ad.3;
        Tue, 02 May 2023 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042728; x=1685634728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jq2+Ws2GP3JQE0Jr7dOoHGPq41eYDcAa1s36M+qTeU=;
        b=cEu6gKcoRMQN6HzLanHGAMmOlN7BkH8DOQbRyD/xZpEN1Dht96TRsDSmIGPs4VlEW2
         kMUSeIBw0dmOj4sQP8zdLiHz7J4wteldPHekr8HUYOV4eI5YsPNzb6kERQ4orZeQ/J8c
         e7BeXs4jVrYAmEOzgCHRdzMVVB4wVtt+w33xYm8lxXYDAzcU6bAYC4FVcNbVv1ZJsmYt
         0myWxiElbuKVS+FkEfH6kmgkd6vfIanbFTDTFlX0s8P+qhKuDGA3DORv/yzimPzX/fFw
         LORyN+EV9Arf0n4FFUmEPvJIzfSv7w2wZDlCZf+npuEEZPYchpemj9brerx7yOZtrIXX
         3/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042728; x=1685634728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jq2+Ws2GP3JQE0Jr7dOoHGPq41eYDcAa1s36M+qTeU=;
        b=E2hyG7TZOSLRrpQLeYX7E/yHdm1ZALP7gaMsZTeMy3CGvTsKtzmslApDOJChiUaNK1
         J6tc0zGGWH5h0DwBjSeR9Td2tEsRJjDULikc0dLaACyqZ9UeJzFj1L6gUrcU4SN/6XVA
         NiQ5C4TskisaXrp7Zli1bp9UFzh6C7WJIWJZf4GFL0zPH9CfUT+sg6en2WhR/Aw6LyTw
         Kwudw7P/p6t4f0WCORr0ih1q+Ry3ayN8NIVWEVtsXfcul6BWlzFQ+oalTQC2yT2k9xiJ
         agLyW9NP4s8xHB7/mQiorO2IuKqB1oiJ/90tWnNbGsGwZbj3ic1HzAR442PRF+LJKCa3
         7GJA==
X-Gm-Message-State: AC+VfDwBlvuCXlheXgaDLFYkRSmSSmcgLO+6BJMRSRfSG6el4rJoPIQc
        DDlBwfhux6LCiLitHmbys5M=
X-Google-Smtp-Source: ACHHUZ4kWv7Y+iMtScvxeFczDhOVhuSqJzLktbb/2tyL8SZBqnCN4ugtHVQMSOgNfylGuOz1LphD5w==
X-Received: by 2002:a17:902:f649:b0:1a6:67e1:4d2c with SMTP id m9-20020a170902f64900b001a667e14d2cmr17742373plg.6.1683042728277;
        Tue, 02 May 2023 08:52:08 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:07 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 03/13] bpf: sockmap, reschedule is now done through backlog
Date:   Tue,  2 May 2023 08:51:49 -0700
Message-Id: <20230502155159.305437-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
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

Now that the backlog manages the reschedule() logic correctly we can drop
the partial fix to reschedule from recvmsg hook.

Rescheduling on recvmsg hook was added to address a corner case where we
still had data in the backlog state but had nothing to kick it and
reschedule the backlog worker to run and finish copying data out of the
state. This had a couple limitations, first it required user space to
kick it introducing an unnecessary EBUSY and retry. Second it only
handled the ingress case and egress redirects would still be hung.

With the correct fix, pushing the reschedule logic down to where the
enomem error occurs we can drop this fix.

Fixes: bec217197b412 ("skmsg: Schedule psock work if the cached skb exists on the psock")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 198bed303c51..3f95c460c261 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -481,8 +481,6 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		msg_rx = sk_psock_peek_msg(psock);
 	}
 out:
-	if (psock->work_state.skb && copied > 0)
-		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
-- 
2.33.0

