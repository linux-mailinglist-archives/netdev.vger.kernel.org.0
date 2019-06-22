Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235904F758
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfFVRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 13:07:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39795 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFVRHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 13:07:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so5156506pfe.6
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zO3o9tKYa+QH0pVT+9fR33alGMYM6CVZWsxMQ9ej5DA=;
        b=F7g1UnpSgmsYA67zk2qa+bARB8wBx92w8a6jZDDErCpHCBcc1tWvO6KR+g8C7KgXp0
         ApAW/qROaKpaVsXg3Pz5GEkgs1Quz/Pe+nUHudE2I7r7G5ueMdppb7w91uW4teLmhGXT
         V9oj7eupYxych3pBHXZ6E7NWzSK+Yu8jelEGE8A/V+C/c47rYN4tJcTmVX0mvuH263aA
         hvUwheNHwIotVvWvAs2YxeR3EYxm+W3Dhim1uyRKwumKhiOQN4zefu9IQY6T8eKravQm
         0oJekouM+LKJznmpX5A2i2LGcs7HKqqjjNi9Mbs3ewdoM97yGcDiRODgw7Nge9iosl5r
         +iOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zO3o9tKYa+QH0pVT+9fR33alGMYM6CVZWsxMQ9ej5DA=;
        b=XmVepJpTYsv43cMJPtw4PWoHz92ExASE1jWk6bLiPVaeTr5FpgDHnk4OxZBsn7YvUY
         ANv87eBHa5+Y9hWGzLZGdqpEwqYMQxR6bWrhF7NUn1IkH60mUh5Q+BCj/WW6yYQPjti/
         WEB3mZ63ZHH7qBHVRbBe83ZP7ekVCyl1aOzJGpWdhfmXFSEo6WJy/w1r+HNFESbQpy6b
         Iycu9Mf5hhZtGCJS5hd7PFKx7WwplxM9fhJ7GijMlqmXrgvPXmXizMhOYTuxylTqFKPE
         GDaovyJF/h3Xum0dC9RvozUewRuG4qGg9C07U/sqci07Vkds/2xJSto7mblmo2p2Hyl7
         hQwA==
X-Gm-Message-State: APjAAAXPKysCe9yFycB/c8SFnRbFGoaFnn6Mk4Z2PZ6pZCp9BPBdO9Gb
        wyB8K9DnOtR91IOLvGAcIb/u6NF04hc=
X-Google-Smtp-Source: APXvYqxm/BgPjVo0ydHnmddExfZBGY4qVKNoGUihLbrTEMSVVnijMaj4FhRV4zHMpHBwyb2OpH8Hqg==
X-Received: by 2002:a17:90a:dd45:: with SMTP id u5mr13624999pjv.109.1561223258827;
        Sat, 22 Jun 2019 10:07:38 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id e66sm6121632pfe.50.2019.06.22.10.07.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Jun 2019 10:07:38 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>, John Gilmore <gnu@toad.com>
Subject: [PATCH net-next 1/1] Allow 0.0.0.0/8 as a valid address range
Date:   Sat, 22 Jun 2019 10:07:34 -0700
Message-Id: <1561223254-13589-2-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561223254-13589-1-git-send-email-dave.taht@gmail.com>
References: <1561223254-13589-1-git-send-email-dave.taht@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: John Gilmore <gnu@toad.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

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

