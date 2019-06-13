Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04B440F3
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfFMQKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:10:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33589 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732845AbfFMQKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 12:10:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so2075625plo.0
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6DW7ReEmFUuBGFp6WLPwUD/d9R/t22ShIFaBwJLcskQ=;
        b=tGxAqZRuolOpTZprdtnwamTpw1Y0g2Kgpb65RKyoQmGoVGxmXv/pgxmOWFBJb7iMwu
         tG77WiWTWlRsLb91xjSYcUL22FGfc6TGMCIrIVm+kAq+UEEeC1qVKWutQdhZgk9WFigy
         mKp7frusW3UkSqwBPew0Ag6629MjG3x4ggSlsaQObIUvzSqgwqCJmRkf8bc4yEm/fhqv
         r7IB7yeclIYUZrD7tvpf0jhfrOaemZS6r1AmciR0ao4+ybVEztQ15zMXGDEgz7zmUpKw
         z4PiDhpSpL13I9cRilS4Hrt8q6z/WjZkiSfl1ZxhH0n1RY2wAmiO41+ViSE7d2N+530J
         oTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6DW7ReEmFUuBGFp6WLPwUD/d9R/t22ShIFaBwJLcskQ=;
        b=oV3oUib+Ko6y/PnfkQP2vXaMpn674+YpPaRLbOi0Tw4tYWw/oHTNW1D8Lj1eeZdeQE
         QynD98IuyPjMu1Y3C4rsr9RcLjFNi0dwAp59j5ilJq7wcdKtTEV5VUfB6N/0CYtW5NDN
         uPTAVxZvNmTFD5c4/f/rSmMhz+uN1RjePZjDz9AiNu8sTW5A1j3Wc1+fonszZQHPi/Td
         p1YxGTR/YbYQFn3+8HFQsr6RNgvWK1YbP2GaHAAY3ifnnKM+klf21LwtNKD/oQku0QHo
         nvcAjglFj69K/Fdy5cjnj+eV3x5l4NKyyX69BhYEM3Oy0vHhzxRVr+2Snw1ykrDXdzy2
         gEFw==
X-Gm-Message-State: APjAAAUdb8a+I/Hw9zSz/zI2np8haG/j3b43cTrgzooifcQZlJYaUaOh
        KaCYe/3IzqlZoFt0rr+3RtoYZQ+f1Jk=
X-Google-Smtp-Source: APXvYqzhcnbFUke66h9Lgd8K7/XYGRz+hmBH+k6fWFY2zj8SerFBugDBPGe8wo/Y7u9d6SIzxu7GeQ==
X-Received: by 2002:a17:902:4222:: with SMTP id g31mr10109575pld.41.1560442243441;
        Thu, 13 Jun 2019 09:10:43 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id l2sm254350pgs.33.2019.06.13.09.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 09:10:42 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [RFC PATCH net-next 1/1] Allow 0.0.0.0/8 as a valid address range
Date:   Thu, 13 Jun 2019 09:10:37 -0700
Message-Id: <1560442237-6336-2-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560442237-6336-1-git-send-email-dave.taht@gmail.com>
References: <1560442237-6336-1-git-send-email-dave.taht@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The longstanding prohibition against using 0.0.0.0/8 dates back
to two issues with the early internet.

There was an interoperability problem with BSD 4.2 in 1984, fixed in
BSD 4.3 in 1986. BSD 4.2 has long since been retired. 

Secondly, addresses of the form 0.x.y.z were initially defined only as
a source address in an ICMP datagram, indicating "node number x.y.z on
this IPv4 network", by nodes that know their address on their local
network, but do not yet know their network prefix, in RFC0792 (page
19).  This usage of 0.x.y.z was later repealed in RFC1122 (section
3.2.2.7), because the original ICMP-based mechanism for learning the
network prefix was unworkable on many networks such as Ethernet (which
have longer addresses that would not fit into the 24 "node number"
bits).  Modern networks use reverse ARP (RFC0903) or BOOTP (RFC0951)
or DHCP (RFC2131) to find their full 32-bit address and CIDR netmask
(and other parameters such as default gateways). 0.x.y.z has had
16,777,215 addresses in 0.0.0.0/8 space left unused and reserved for
future use, since 1989.

This patch allows for these 16m new IPv4 addresses to appear within
a box or on the wire. Layer 2 switches don't care.

0.0.0.0/32 is still prohibited, of course.

Signed-off-by: Dave Taht <dave.taht@gmail.com>

---
 include/linux/in.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/in.h b/include/linux/in.h
index 4d2fedfb753a..1873ef642605 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -63,7 +63,7 @@ static inline bool ipv4_is_all_snoopers(__be32 addr)
 
 static inline bool ipv4_is_zeronet(__be32 addr)
 {
-	return (addr & htonl(0xff000000)) == htonl(0x00000000);
+	return (addr == 0);
 }
 
 /* Special-Use IPv4 Addresses (RFC3330) */
-- 
2.17.1

