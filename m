Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BEA2D6B0F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394169AbgLJWbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:31:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405145AbgLJW2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 17:28:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607639223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0i8bXJYeqHWVQ3kqT+YAvemEqycrW60WPjZl2fOfz/o=;
        b=XYoFVMwh3kGTBYP6ezt2pCyQKVBYxGLAYeUwnyDPWzWXVrEdpEuyt0/sJipuaqaSi94RJR
        F0hPI1MSipO6vqQlov1bFbc9Jkp/BGpvOcbmXdIeJYHn6qWlCENRbzJ/jrRCp1mfxVvP6d
        dvdup9l6SVlpsPEJpen7bbTZeUsgP10=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-QDoUKpJVM5uRUmKEAH0JPA-1; Thu, 10 Dec 2020 16:53:41 -0500
X-MC-Unique: QDoUKpJVM5uRUmKEAH0JPA-1
Received: by mail-wr1-f70.google.com with SMTP id o12so2422538wrq.13
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 13:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0i8bXJYeqHWVQ3kqT+YAvemEqycrW60WPjZl2fOfz/o=;
        b=LwkuMhVX2pxIRASNWYG0JZ5kxyGM60P0oF0O9wuBYgNq5PS41FqzdsHEaVCuE7ttXK
         jVZBPFMTx43stDYoUWgNjh8w2vNp/GIRzCgH5lYCb40u/Vu3EiYiH1DTQdN011KuEezB
         rpDcxDtqCJDCqymcsoCVGAqKbNlIX/1RpKn+3ijlESIQM5XUyeMS5dlodb4LA4fT1CEz
         5P/A8+x8CeUtA2hDszj7f1uZCV1pKDGa9oGTj/hFI3Y2Vx7d5z2U1CQLHsco4u+mNHpO
         +xQYBwH6VxNVQ257+zZu2xHg9Yjm/ov0KhYwnQJJMeEN0qXfkozs75CtnzPUGuOKrS3W
         yRkg==
X-Gm-Message-State: AOAM531gjD1tWFAJceUDDhvfATo+YtQAXYxNZG22IWJ6DvNlGa+RjjPX
        Dz08vqMOryisZirAO7WOUmmNjVCB9gZXc0+TAG+U9r0TWTw6BgPq6UnNyStoa67HeXC5AF4SAD+
        CI/HETE9AQyjqmJ7Y
X-Received: by 2002:a5d:40ce:: with SMTP id b14mr10292856wrq.350.1607637220061;
        Thu, 10 Dec 2020 13:53:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1f3NIbAKDDoulfDKrPujtjmk6g5/Bkjd068CwxcRzGW07As4/PzNGkqbQC2y53LJkuG4eMg==
X-Received: by 2002:a5d:40ce:: with SMTP id b14mr10292842wrq.350.1607637219899;
        Thu, 10 Dec 2020 13:53:39 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s13sm10859535wrt.80.2020.12.10.13.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 13:53:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1426180070; Thu, 10 Dec 2020 22:53:38 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>
Subject: [PATCH net-next v2] inet_ecn: Use csum16_add() helper for IP_ECN_set_* helpers
Date:   Thu, 10 Dec 2020 22:53:31 +0100
Message-Id: <20201210215331.141767-1-toke@redhat.com>
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

Reported-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Jonathan Morton <chromatix99@gmail.com>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/inet_ecn.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index 563457fec557..d916a458aceb 100644
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
@@ -93,23 +94,19 @@ static inline int IP_ECN_set_ce(struct iphdr *iph)
 	 * INET_ECN_ECT_1 => check += htons(0xFFFD)
 	 * INET_ECN_ECT_0 => check += htons(0xFFFE)
 	 */
-	check += (__force u16)htons(0xFFFB) + (__force u16)htons(ecn);
+	check_add = htons(0xFFFB) + htons(ecn);
 
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

