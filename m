Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B115A2A8F9A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgKFGoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgKFGoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 01:44:10 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A110C0613CF;
        Thu,  5 Nov 2020 22:44:10 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 13so423939pfy.4;
        Thu, 05 Nov 2020 22:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sNLPRuw21PItPm6NtDbw6hLmvWCYd5keSz8WF1N4O2Y=;
        b=Psj4Fnl8VYM3Y6Yef8Rt8q25SQXJ4r5fplJN4OMvpBKgMsw8g/qRTknM5UdgYlfXr7
         /BkvuzTzZKHpl1tJCsqYarD44CUjKblN5Rkf+NQsxg9mJjQFRMo43cCShytvuCnaJPj5
         v8N8yNnUlCtgChMxJjyU532/4cQ4nDoS1mvwLuxmeYlg/mFrNsqOWm1XDys/R3V1GnMo
         NuSNajoEZQIsJngvDyV3mQqk0ysx6pbWTuroi9nSiK6DdIPDtJISU0kfy6R8l8+pfu7K
         rS9cByI2KcUGjiPKZrHS+ciGnwRhQYPJvj3q4Xfo51kvuSWCyAkvPTERp60nxLOj2LG3
         oSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sNLPRuw21PItPm6NtDbw6hLmvWCYd5keSz8WF1N4O2Y=;
        b=SWyGcee19mcahGpMmSUNnC7YkoHxX0eyQEnxRJTwYWTJC3kow/aieJZY0ijR9BH9VL
         UU53j97RnN0yViyoLQsl0zTN9g0n8xYctGctczde/4B6BqtFnfQKLU7VtFEXWaDJGiGl
         6B38LEpezfDqfSVJh0s81xaA7/QDtm861COZj4YRX48w924qCN7ZkToVdofevm2YPFE5
         xvVTUk9l6rIRNDNQizHZ52/9qKKOcC2NbnA4lr5hWit2+1GJp3TdY3dV0sul7W4WH7vx
         f0GpM09ROSyGxZozrOCl35U/ALUu+cGgGYL3IOocaLh5JJH7xPg3juwt6OoNKGBOxvN/
         dQhQ==
X-Gm-Message-State: AOAM533GUp0WvrnRLhk2KQiT8l5sV5VzzSnbhiXDW3vNMQ6110xWT64S
        SB+CTyqteuFLVIqPNLUvIeY=
X-Google-Smtp-Source: ABdhPJyzZ9gn5dQawPxpwGKVEE19XcEnAF92CKNV5/O2WMgqGK1diGGivyD7ply0qyX3YpRJl1pLGg==
X-Received: by 2002:a17:90a:d182:: with SMTP id fu2mr899635pjb.145.1604645050149;
        Thu, 05 Nov 2020 22:44:10 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id g1sm837820pjt.40.2020.11.05.22.44.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 22:44:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: udp: remove redundant initialization in udp_send_skb
Date:   Fri,  6 Nov 2020 01:42:40 -0500
Message-Id: <1604644960-48378-4-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for 'err' with 0 is redundant and can be removed,
as it is updated by ip_send_skb and not used before that.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ca04a8a..6953688 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -874,7 +874,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 	struct sock *sk = skb->sk;
 	struct inet_sock *inet = inet_sk(sk);
 	struct udphdr *uh;
-	int err = 0;
+	int err;
 	int is_udplite = IS_UDPLITE(sk);
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
-- 
2.7.4

