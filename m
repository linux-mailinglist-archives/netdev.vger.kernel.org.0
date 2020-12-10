Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7054B2D58DC
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732370AbgLJK4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:56:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726033AbgLJK4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607597707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xeB4IZR0qaOlIEB5djhUe5TW2XKVsYT2+1EoMTn433g=;
        b=MHsT+yChMdvcdHqjZBkrSb1G8PymNffMbMaOUN9I8K623vDBLHVfm6E2MhB5MS394FnveD
        QWMmrrXOw3ndjdIRucLGwkt9Ybr149/Ub5gOurhhxVspIFs6x+jOMNHCdI1fEPWI4QBMLU
        alK3XdnaNv75MlBpify1oWcno1ce7y8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-ySAUe5HgPuCz4tdNYh9khg-1; Thu, 10 Dec 2020 05:55:05 -0500
X-MC-Unique: ySAUe5HgPuCz4tdNYh9khg-1
Received: by mail-wr1-f72.google.com with SMTP id p18so1776940wro.9
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xeB4IZR0qaOlIEB5djhUe5TW2XKVsYT2+1EoMTn433g=;
        b=aKslu/oIIg+zE2DBDTVYkr4R7xIFrtoZqIfRZ9WSd0UHOxeJNiJnAPbvNqdGS7QvQx
         A4EOKrE7hgy/xgreCd6H7LEW2w98qQyGkPD0uT3pMYdwu0jkz1Fi9wMpuBHZrGMZWA1i
         goGRWnjR3V+CmTt417jEqQjfOngjvENqGuW/4Yc3zNYCAvPbkRQge8u3d81oonwrhIsQ
         gQECCzZIwPsaQYECLwK679Z2sblB/O8wAgJN3VWI8iI4NEgdaSrUqbz6LjvKhhxZtd4Q
         Bk16ndtHU8fqjURCJaUC7CyAGhyGplVwCA0mvuGJiL5SpNsNzqeT7Jn53kWPm2vs2GZQ
         gN6w==
X-Gm-Message-State: AOAM53319nKgPnZtvCiTiVdwBOdcp59iEzDoicKkxkDJakFII3kI27/e
        62FrHEl8CHmMzSqBSq3is84WqzezOqOuchVnG9BFzerGzPw3/28TYJj0224dH28LLSmTerJjRMM
        euD5O9A3nDqCYCiIF
X-Received: by 2002:adf:e8cd:: with SMTP id k13mr7666303wrn.193.1607597704415;
        Thu, 10 Dec 2020 02:55:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT7x/VMAR/wKKe/R7DyD3phxS2jvpkJfaew/3KFvn63CnnHdd35C+NjMw7BuCiRKPnCQIQxQ==
X-Received: by 2002:adf:e8cd:: with SMTP id k13mr7666282wrn.193.1607597704229;
        Thu, 10 Dec 2020 02:55:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n17sm8262702wmc.33.2020.12.10.02.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 02:55:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 337D3180068; Thu, 10 Dec 2020 11:55:03 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>
Subject: [PATCH net-next] inet_ecn: Use csum16_add() helper for IP_ECN_set_* helpers
Date:   Thu, 10 Dec 2020 11:54:55 +0100
Message-Id: <20201210105455.122471-1-toke@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub pointed out that the IP_ECN_set* helpers basically open-code
csum16_add(), so let's switch them over to using the helper instead.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Jonathan Morton <chromatix99@gmail.com>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/inet_ecn.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index 563457fec557..fad1bc596c29 100644
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
+	u16 check_add;
 
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

