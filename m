Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD352F59D6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhANEPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbhANEPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 23:15:53 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9CAC061575;
        Wed, 13 Jan 2021 20:15:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cq1so2394174pjb.4;
        Wed, 13 Jan 2021 20:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i/xZY8DpdABEtyxGJwRPJ3Gox+RIWU/dLajPoWgwjqs=;
        b=Fv5i6Gtp40PbeMJwpKIdACaEM36r4nswQT66xInERfTRx/Dps1FhpiZpPvE3V6CIMH
         lFRIuuFABGaFGdPLEe6hBwyvqU8hDz2GeAS/mOy7IEd7qoWbBVgNaeQ15tFBeBg87FD+
         Zjx/wdrmdj/0C83Sq0hY1wTp4mkUEdYw0YP2zlH8uam/k1bZOY0R1baDt5wS8/DLtMQO
         cJDJ4iX7TJS0Ly4rLYt6xqovTsBnVfd/3BtmRDT6KqQpR26BjMYrm89l0tzYm6kSadu8
         yuTKQLwQF4cOIWKPozw2hdlr7SnmkMVgdTLfe/m59IWDRJuCyTT62QidyeIbvzH4fMYY
         aWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i/xZY8DpdABEtyxGJwRPJ3Gox+RIWU/dLajPoWgwjqs=;
        b=uHcVjdCDZyBUqNjWNqzM6w9MJbOEJxo2c1+ue3ndaPnUf3a2wPbLTYxLRv8qyZpop4
         hyJVexbgb1TyDyMs4IPjnnDlXSiSYShrDXdlbm/Tg+Aw1mRLSiF07oZ4u5wYLDa3mVnv
         4V7+GjU2ndTT8EUl10AcwLJQsEAedubNDhmw3bgnjoKauy6hbfQzszP7ZHKrzSrhkTwu
         hv9REQw9A4GZvYDQIEjEfIDmd2WS6QA5uPITHOTcLHYpW3brcUb1iTQWuIS2e5ynQzbn
         oON6yhBsrcqyFnFBlR8da/kFTZTGgIjmbi6jbx0JHZVUuMbk0/y1dlzTCRnfpFSs73X2
         kZ0w==
X-Gm-Message-State: AOAM531U7MlwfwL/F0XLOirHMDecobikzSl2j5leCApuh6G16XZMeuKe
        UHGGeL+P4axcTYgNvyw7ztA=
X-Google-Smtp-Source: ABdhPJyz6UUg9D+AVhweeioOxbEoLYSIkELCtNpqwduCHFHytLFcBJU8kPEDp8DtaUKli5OvnnQ+Xw==
X-Received: by 2002:a17:90a:2f22:: with SMTP id s31mr2948608pjd.192.1610597706920;
        Wed, 13 Jan 2021 20:15:06 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id l7sm4033523pjy.29.2021.01.13.20.15.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Jan 2021 20:15:06 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] tcp_cubic: use memset and offsetof init
Date:   Thu, 14 Jan 2021 12:14:56 +0800
Message-Id: <1610597696-128610-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bictcp_reset(), use memset and offsetof instead of = 0.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/tcp_cubic.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index c7bf5b2..ffcbe46 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -104,16 +104,7 @@ struct bictcp {
 
 static inline void bictcp_reset(struct bictcp *ca)
 {
-	ca->cnt = 0;
-	ca->last_max_cwnd = 0;
-	ca->last_cwnd = 0;
-	ca->last_time = 0;
-	ca->bic_origin_point = 0;
-	ca->bic_K = 0;
-	ca->delay_min = 0;
-	ca->epoch_start = 0;
-	ca->ack_cnt = 0;
-	ca->tcp_cwnd = 0;
+	memset(ca, 0, offsetof(struct bictcp, unused));
 	ca->found = 0;
 }
 
-- 
1.9.1

