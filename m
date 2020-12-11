Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753662D77D0
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406071AbgLKO2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:28:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgLKO2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607696809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6PUvQxUTo6XSalZrcrFnAw4kOJvTyVzYyCrrIhslngc=;
        b=Pc+pOfee/uDepmRbrgy2+9wHewpFnPUuGV2uYJ6MsMf1UuyQQVfZAFScDf9V0fATtzFXd5
        OWMZgXOe2mPnHc2P8MlxP7pztNVzZPcc0848KuPTtWK0oDOfBuseo1+fnoONTpzVE6Dsf4
        ORup04ERiZx8IMMfoAqVMRyGFKUuKmc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-9sVUxkOTPzyVh6POb7KD-Q-1; Fri, 11 Dec 2020 09:26:48 -0500
X-MC-Unique: 9sVUxkOTPzyVh6POb7KD-Q-1
Received: by mail-wm1-f72.google.com with SMTP id g198so1685236wme.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 06:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6PUvQxUTo6XSalZrcrFnAw4kOJvTyVzYyCrrIhslngc=;
        b=SELzc4xxCQSbBhb6l6czFT05+RQzrUUW5ZbyaWmE+AChUx+rJgvQLJ3tZxXcMeaZNI
         v+HvwgoTC4PAFyq23zhJ2dh/CHED/3bHtxduF8ChfKYHNPX1g4dkwr82+7EA6jnbP3Cy
         456DzUPQeb3QS5rEJfjc4dJVpEDrkFFaRcoNJuBWfq7y658WSbKthFqE5HAUIpZ+7WXw
         unuTJkJP5PahB1JsZRtXM8Xe9UOd6EJAPpcga1TccAZptmfazCPbGCHU9h3/2AHdmbUA
         bMpoy10RhqUdxMmZygkRPVx6qUusQ5F+cp6oZZouu34owKDnje7ovnCm9dsZXjTwETJE
         tE+A==
X-Gm-Message-State: AOAM530XHHZDbf3TsG5sWJJ7wr4+/2Biy5ZKhNsy7iD8fMoNf7JXHe5x
        /ygMelQXhL4MplfOMV+Oh+Utfcbp/lX9ELcKXCn83t0//u9wQkh/gGxc7nVhJBOD4vgDtKtbK0X
        ZZQKIcqV89bCKVDR6
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr14045044wma.9.1607696806792;
        Fri, 11 Dec 2020 06:26:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPYGPB5MVKht7xgWM2CXMhmRzxisot4i6pymq+Eg9PYuQbT5q02aeIh0fbsUZ4bK4NK/a4nA==
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr14045034wma.9.1607696806652;
        Fri, 11 Dec 2020 06:26:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h83sm16285169wmf.9.2020.12.11.06.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:26:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 48286180092; Fri, 11 Dec 2020 15:26:44 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>
Subject: [PATCH net-next v3] inet_ecn: Use csum16_add() helper for IP_ECN_set_* helpers
Date:   Fri, 11 Dec 2020 15:26:38 +0100
Message-Id: <20201211142638.154780-1-toke@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub pointed out that the IP_ECN_set* helpers basically open-code
csum16_add(), so let's switch them over to using the helper instead.

v2:
- Use __be16 for check_add stack variable in IP_ECN_set_ce() (kbot)
v3:
- Turns out we need __force casts to do arithmetic on __be16 types

Reported-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Jonathan Morton <chromatix99@gmail.com>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/inet_ecn.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index 563457fec557..ba77f47ef61e 100644
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -8,6 +8,7 @@
 
 #include <net/inet_sock.h>
 #include <net/dsfield.h>
+#include <net/checksum.h>
 
 enum {
 	INET_ECN_NOT_ECT = 0,
@@ -75,8 +76,8 @@ static inline void INET_ECN_dontxmit(struct sock *sk)
 
 static inline int IP_ECN_set_ce(struct iphdr *iph)
 {
-	u32 check = (__force u32)iph->check;
 	u32 ecn = (iph->tos + 1) & INET_ECN_MASK;
+	__be16 check_add;
 
 	/*
 	 * After the last operation we have (in binary):
@@ -93,23 +94,20 @@ static inline int IP_ECN_set_ce(struct iphdr *iph)
 	 * INET_ECN_ECT_1 => check += htons(0xFFFD)
 	 * INET_ECN_ECT_0 => check += htons(0xFFFE)
 	 */
-	check += (__force u16)htons(0xFFFB) + (__force u16)htons(ecn);
+	check_add = (__force __be16)((__force u16)htons(0xFFFB) +
+				     (__force u16)htons(ecn));
 
-	iph->check = (__force __sum16)(check + (check>=0xFFFF));
+	iph->check = csum16_add(iph->check, check_add);
 	iph->tos |= INET_ECN_CE;
 	return 1;
 }
 
 static inline int IP_ECN_set_ect1(struct iphdr *iph)
 {
-	u32 check = (__force u32)iph->check;
-
 	if ((iph->tos & INET_ECN_MASK) != INET_ECN_ECT_0)
 		return 0;
 
-	check += (__force u16)htons(0x1);
-
-	iph->check = (__force __sum16)(check + (check>=0xFFFF));
+	iph->check = csum16_add(iph->check, htons(0x1));
 	iph->tos ^= INET_ECN_MASK;
 	return 1;
 }
-- 
2.29.2

