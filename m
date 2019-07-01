Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DCA5BB09
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfGALz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:55:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44630 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfGALz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 07:55:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so7239463plr.11;
        Mon, 01 Jul 2019 04:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UaeHZEzlrR9kAMRXI78vFSQh8YT14mqYT2wzHuKrFzw=;
        b=Od037p+ADw3o0cfxwcMuZ9ltWKx3H17JLKGYj5S+Ax7EM1BASJ/Rjg1Xe8164BExKQ
         BR9xpOllLNQs1XlJewAZRcoIt/4PlUkUqO0TyUumSKk8VRPQaCIw5ubUE6igRuwHIQk9
         Whz5xaxTTC6ebW1pm5xIhjFcFMFTO/kF9thdfZhMCo7BudsNrKNIcOlO8SUVdWthlVFL
         ATTNebVrJcG53Vnji8pq+0AKzmYTMqSh5y2tNMhiXmmwKx6C4ovfFwInmsLgZ+vI47uc
         NtCCNmkhiLUlpibLKuB+HAfcDXzSi09f+ssb2OP+68CE94RBpiyKrs2Cqwk6SDSqZY7E
         mxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UaeHZEzlrR9kAMRXI78vFSQh8YT14mqYT2wzHuKrFzw=;
        b=PdqK38VvHP4PfoINnpJJBPh1xPDNkOJpPn/RmHZokD+6HPJIaYtf1LRgL27SMp88U9
         gIZfi3raf5vfb8pi8n/YSIWD/Cz62NzBPfKwcOkwwNUHa08KdTIuqyjD+V/rqxEYf+3B
         E/vJmX9GxE4CV3cygTOHYETe9XLxH2GQUUCRHpENY2dohGHzfRK/2SYdylPFfk8mCsLV
         JrBWldlzOGYfR33AwfA4VJFtr4OoHncP4HYu6IyzjHOcqPJMDfrKgYKVJbDiiB1PZOJ+
         tAbxBh3VY0zU6Tt4fh7CQ2YGBmW2A2xqbvYO0ZzEdhJPOtw2bf79xCchJTT7i7TDzHqh
         1EAg==
X-Gm-Message-State: APjAAAWEEr6emx4V78NF3rKGlzvU7iwxd4fTpeFihdjCIlErO99korG4
        VoMnfWf07Wwzn6wrmgdwkJi7Dl+TjhtgWw==
X-Google-Smtp-Source: APXvYqx0RyyVK/QP2SE2IyWjE6GYVCmtJmWvH97NmM5MoRqqACenrNvpBcuGFQYf5n7tmfQPhrKaPg==
X-Received: by 2002:a17:902:8b82:: with SMTP id ay2mr26774235plb.164.1561982156439;
        Mon, 01 Jul 2019 04:55:56 -0700 (PDT)
Received: from bnva-HP-Pavilion-g6-Notebook-PC.domain.name ([117.248.64.59])
        by smtp.gmail.com with ESMTPSA id a64sm8601886pgc.53.2019.07.01.04.55.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 04:55:55 -0700 (PDT)
From:   Vandana BN <bnvandana@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Vandana BN <bnvandana@gmail.com>
Subject: [PATCH] net: dst.h: Fix shifting signed 32-bit value by 31 bits problem
Date:   Mon,  1 Jul 2019 17:25:39 +0530
Message-Id: <20190701115539.6738-1-bnvandana@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix DST_FEATURE_ECN_CA to use "U" cast to avoid shifting signed
32-bit value by 31 bits problem.

Signed-off-by: Vandana BN <bnvandana@gmail.com>
---
 include/net/dst.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 12b31c602cb0..095c5daf9403 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -183,7 +183,7 @@ static inline void dst_metric_set(struct dst_entry *dst, int metric, u32 val)
 }

 /* Kernel-internal feature bits that are unallocated in user space. */
-#define DST_FEATURE_ECN_CA	(1 << 31)
+#define DST_FEATURE_ECN_CA	(1U << 31)

 #define DST_FEATURE_MASK	(DST_FEATURE_ECN_CA)
 #define DST_FEATURE_ECN_MASK	(DST_FEATURE_ECN_CA | RTAX_FEATURE_ECN)
--
2.17.1

