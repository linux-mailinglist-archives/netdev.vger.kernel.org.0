Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284121066F8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKVHVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:21:13 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46602 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVHVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:21:13 -0500
Received: by mail-pl1-f196.google.com with SMTP id l4so2725961plt.13
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 23:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2j+Nl5eydyadowIGl0ZeHhCaPa3c/yGy4IMLcjDXYfY=;
        b=ovRv4ml4kbzpb/vYiIGR57OFG+TsoT5/aOUf66YLXKTDRXRsb3ORx2D2/tRHLDAOV0
         qKjpeAICf0E8VDdgMikt/ZfJmNHvXR3m+bESEENbeCG6qlkvQ3g2A6qjPkT+Zp7luraq
         SY/80ai0aMNsEbvGsBDCfZxMHx+p7/sJdOy00FSn9Qws1KcyuyRTTfx9+0FAvUOWmlzC
         PCSuypfcVFIs30qBQ+MnSqPX7qTxqVMzrCCSc7sFEokGhVixwLlhAlJQVNabd2HCYDzl
         +U59JuHrYioHvFLCQzKkkOwDYMUhYDwER4acs+sKpvEGGutzi89sagp0ap0UQFaobV3y
         tG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2j+Nl5eydyadowIGl0ZeHhCaPa3c/yGy4IMLcjDXYfY=;
        b=AeZ2yPLk7VOXXPSDxjB+dVURqSIr+E8WhOkkILZs/d06mM+t9VHaCpimoPcDvlxcBf
         ukyoZzs6YFsGxtPz4IClZQWTLmOyA/Lm6Bgvlrw5344Kc+PJ4brKT23IQXeBCKmG/F3o
         CjtT4btUSFks8yNs1DVfTIRoQMvpl4zY3bcT3Mq5TAzDGz73Np/7bjmcKDVKphWI7ZHR
         iSZPWUl6xRqlFajpUdpH/E7OPpPtwC+w9VBYBtYodUWOU6pqfwv/Uuk1iNx4eVsr6LK5
         VEa7EkBAuny+hyJ5nb8rhEZ+XrXVlNav7bCNubeY+V8hyJTR3nKZiGWMxw1kweKYyI0O
         Kdng==
X-Gm-Message-State: APjAAAWgtKAQgmwlZGFJIBU13Lfv83hGn86DzHYwqXzpHTS46g56vTL+
        AQOI6FYi0HjTsBRuzh92WDw=
X-Google-Smtp-Source: APXvYqxjJoI5u5pAUGWlvlOxZY07ZOuc4Qu1/qEnB0SpUOGoJ41b4yDNw+j/fFnvUU4Vt0Vb+f1Sjg==
X-Received: by 2002:a17:902:d717:: with SMTP id w23mr12346027ply.142.1574407272588;
        Thu, 21 Nov 2019 23:21:12 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id s2sm5310646pgv.48.2019.11.21.23.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 23:21:11 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH 1/3] net: inet_is_local_reserved_port() should return bool not int
Date:   Thu, 21 Nov 2019 23:21:00 -0800
Message-Id: <20191122072102.248636-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ip.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index a2c61c36dc4a..cebf3e10def1 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -339,10 +339,10 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
 void inet_get_local_port_range(struct net *net, int *low, int *high);
 
 #ifdef CONFIG_SYSCTL
-static inline int inet_is_local_reserved_port(struct net *net, int port)
+static inline bool inet_is_local_reserved_port(struct net *net, int port)
 {
 	if (!net->ipv4.sysctl_local_reserved_ports)
-		return 0;
+		return false;
 	return test_bit(port, net->ipv4.sysctl_local_reserved_ports);
 }
 
@@ -357,9 +357,9 @@ static inline int inet_prot_sock(struct net *net)
 }
 
 #else
-static inline int inet_is_local_reserved_port(struct net *net, int port)
+static inline bool inet_is_local_reserved_port(struct net *net, int port)
 {
-	return 0;
+	return false;
 }
 
 static inline int inet_prot_sock(struct net *net)
-- 
2.24.0.432.g9d3f5f5b63-goog

