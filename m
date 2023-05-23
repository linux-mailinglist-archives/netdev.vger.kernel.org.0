Return-Path: <netdev+bounces-4492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA9070D1E3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E37E01C20A5F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AA179E3;
	Tue, 23 May 2023 02:56:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B954479DF;
	Tue, 23 May 2023 02:56:27 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98718E0;
	Mon, 22 May 2023 19:56:26 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-534696e4e0aso3921505a12.0;
        Mon, 22 May 2023 19:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810586; x=1687402586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LDFpEJF2r3u4aoZRDO+MEf7dfGfkdbpGtCFF1Q2dVs=;
        b=sD0KAy/4foe/p2Mr5fyxWy/pMwTNAxI3QLVcHznhxj0koUy/tnW4TDCXloLYCtMtPG
         xqiw/asbzlOSS7RvfjFaSuBnX1aFMEIy932NvAZiEyOiG9kGK/ok05nTDCBCelAU/Wlz
         fBFnI7TTnbr5516/CU1YKiM6JlGTJuiCrJ0DXMGzeTaBf/uOREhcbQvzRQSNPaudV8mS
         2uhu4ZMq1PKGCvTYa18/+xp0KPjn32V8CoA1ofkFTQd5EpOIVxAboiVtMZ+IntYyow7D
         HVjmxeZluV6TGenKJy4KA7lmJursVX0zdX3ie1fY20ZOGV8twM4/kXFeCrKoGnL/pdch
         lvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810586; x=1687402586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8LDFpEJF2r3u4aoZRDO+MEf7dfGfkdbpGtCFF1Q2dVs=;
        b=FMz5ZXLR0QzQC15c9Me+1SiTfiYwe3qz4JRbICBmgBZq2adVrpEt8QQr/q6ysBusRd
         xz1snhgTlJxiRssMEdjIE2cxjD1K4ziYUx3REPAQi0DL6TGkgBGcIZbfESU/d0FA35RT
         um3OXYcxWey7739ST8/Bcp6XhNjF9SqIHzZ1MGQiujDsOh+l2I6XQv53D6jDGkZEIrjJ
         +TzbSUaUXm70uKFkXcvXiGKSCPSBCDX2Dih2I7S68bfpdmjlEUruFryv0nJF7L1UYNaJ
         yuq5RDNWU+UIx7JUFs17NwDQGAq9SFxR93F2zSdM5CuPzNwUZbaYuALrZvSdKMvyyIXn
         fbeQ==
X-Gm-Message-State: AC+VfDwDB2x5KS8MWxzhoyBbp4Sz7tN6DgX9ou80KB2xTqUI3Wv5qdsn
	7x92OIcs1KJJu10CDZOiBKc=
X-Google-Smtp-Source: ACHHUZ4Rq3ZfaOYXiTHNotxGDfeiitiY29OVaLB/ppf1Xvokst1L7UQ/fk/PZZfUCtvyowz9je7Nwg==
X-Received: by 2002:a17:902:d50e:b0:1ae:6720:8e01 with SMTP id b14-20020a170902d50e00b001ae67208e01mr14213921plg.20.1684810586061;
        Mon, 22 May 2023 19:56:26 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:25 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v10 03/14] bpf: sockmap, reschedule is now done through backlog
Date: Mon, 22 May 2023 19:56:07 -0700
Message-Id: <20230523025618.113937-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: bec217197b412 ("skmsg: Schedule psock work if the cached skb exists on the psock")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 0a9ee2acac0b..76ff15f8bb06 100644
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


