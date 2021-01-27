Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65633305BC1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhA0MlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbhA0Mdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 07:33:51 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF28C061573;
        Wed, 27 Jan 2021 04:33:11 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t25so1501298pga.2;
        Wed, 27 Jan 2021 04:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kRzDbqZN9OlxFVagsejaEFON9zt2dveik1IQvfbxWeg=;
        b=BjSw9thy+mArYh2NbfoQMLCR8XdISs+TSFKvwKruh3BP8WWp3ZFpB+N0Ik0vhxCbri
         qbp9WGjsLsMLNy4/hdsJc3zkBRqhIeuzu/Q3tRCkTNl1iLBwBxAFR4ROUQYmFUOquKI8
         IfLlwSp2Fpa5cxrKTd9YB7TghA/PeJHwYRiXIuUoQzTLWYdPn1SqTkSD1t+5qlAtuxBD
         rzkF20LGunXJ0lY59oTvdZjJU4kCg49j/KzEwl0m5bLqxHbdQWQTSdNaXYi2ujmL0GlX
         XkhRgOtajnF89tFlb5mLy+ACs3Zh1HDucsoFzE3af0r2X5QaonSOVV+YkFUFk288VtqS
         ftPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kRzDbqZN9OlxFVagsejaEFON9zt2dveik1IQvfbxWeg=;
        b=Tu1E/1jQ3lizxMCZkGMx08voowe8kvO+reIspwJ1Fj0Gk5R+bv8ca1uZStnR6KHKPm
         i+jQVHCKGI0f1OLk2ERChrQak9RaL31LHrID8JycbIDzeCiyebv1SclIYAfKnC/KlpBG
         FqDfXuqgDffsAUijorj9O5EzQMrbxYjvhcnbeoLAsz52v4nLUh0m3gFzvzPlZij8tIAI
         ZIOkQ1dZ2b97vwcrg7ujwNsY2NnZxJvU/X+ashOLGcHfCjNNTVhP0FzqYqtT5q+gMHqb
         WhV8ULQmHMVZnzsGrx9/YsNjnA11dNmwLmEAuL0fPJUaD1yZO9DHe1fSgJmugauz9PpY
         L4lw==
X-Gm-Message-State: AOAM530GcpPZmU3CTFh0kpUdTW3KtvCUBY3v6o+/fV5zbM+tHq2IejK5
        Gb7DFrGc8onY1tVoz016lYk=
X-Google-Smtp-Source: ABdhPJzZjzOr4CgH1ODLt91pBU+Ap5GoVT9mDW4HZxuj375aIn+Ny3qD9RfyOgnQRRjQzPWdtbV7ng==
X-Received: by 2002:a63:fd01:: with SMTP id d1mr10710864pgh.319.1611750790908;
        Wed, 27 Jan 2021 04:33:10 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id j19sm2486784pfn.14.2021.01.27.04.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 04:33:10 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, willemb@google.com, dong.menglong@zte.com.cn,
        tannerlove@google.com, john.ogness@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: packet: make pkt_sk() inline
Date:   Wed, 27 Jan 2021 04:33:02 -0800
Message-Id: <20210127123302.29842-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

It's better make 'pkt_sk()' inline here, as non-inline function
shouldn't occur in headers. Besides, this function is simple
enough to be inline.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/packet/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/internal.h b/net/packet/internal.h
index baafc3f3fa25..5f61e59ebbff 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -139,7 +139,7 @@ struct packet_sock {
 	atomic_t		tp_drops ____cacheline_aligned_in_smp;
 };
 
-static struct packet_sock *pkt_sk(struct sock *sk)
+static inline struct packet_sock *pkt_sk(struct sock *sk)
 {
 	return (struct packet_sock *)sk;
 }
-- 
2.25.1

