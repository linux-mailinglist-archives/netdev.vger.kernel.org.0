Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919E5107A3B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKVVvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:51:05 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35696 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVVvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:51:04 -0500
Received: by mail-pj1-f67.google.com with SMTP id s8so3600509pji.2
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 13:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2j+Nl5eydyadowIGl0ZeHhCaPa3c/yGy4IMLcjDXYfY=;
        b=mXBBALVPpU5VRqmLWk944bkJN2tXnIuXxH0UA08HnZHBTR9hH8nGcw9OeBqw8PT5e4
         47chXnpo1vzwFSL0ga3YxQw33PnjdY0DRcjpMuX8YF7MLPKmc6XJJ9icKeCfL2WylVFK
         Damt5JYnikikhMEpomtrXfzHbzw6WKclKTI23wDBtMQbZt8nT+hBZFcbjK+vmUgwIJVd
         hz2B5g4uqwV+SBk649sNRWXx67JrkabNg9ASF/55NKI1ShxeSKEGDInGqwvWxIedL9MO
         fRhppx4xziZeWRN/ewKfpriZP3aWQaBnffZgI3J/AkcUZdq8l+Ade7dpGIB1iTXfzQaq
         uUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2j+Nl5eydyadowIGl0ZeHhCaPa3c/yGy4IMLcjDXYfY=;
        b=mfl39cz4/T5dwev82ObB/2AO0Y9PmQeWF3rsaOYLhOXYdpkCBJ17FbUFMSEUaZXVW8
         kqQOX8LCUFmc82Vs3cfhtp5RnTTCo2KBKPXMLlNxw2Krbi1tIHRDNik+fCmnTuzZXTRM
         Pdhmo/HsNF5x5xySjsxb5zrkzh+THhP4LNhAQvGPlBLQJw2U9I/mrJEsh4+DE36G9bN0
         53NivpHpDhq5DY2xFkKxpC0XgFm+9bPU1z2rmVyeSj5zLenTybV2rI4XvDEioFtXo0Vt
         ltvl/1pbMrGakIUeQWXYSn/WxHMqINaBZKYGCXMqfv7RygaiPpxDrDsJ67Yq9xV90gl5
         FgYw==
X-Gm-Message-State: APjAAAWKniRrvvU62svNTeETsaR7XKHKdmpycp23w9Kf9Gu6uAaljOif
        fDXsqPkpzfcHb04LHlCV2PU=
X-Google-Smtp-Source: APXvYqx7n5dGUsIJMCnlhtunyWt1e1Xrz2Jo5Rh1oMHM4zUM+Z/9yF9MIBbnIXRVbtPIHnNqBslGZA==
X-Received: by 2002:a17:902:261:: with SMTP id 88mr16789762plc.322.1574459463963;
        Fri, 22 Nov 2019 13:51:03 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id u7sm8537151pfh.84.2019.11.22.13.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 13:51:03 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net: inet_is_local_reserved_port() should return bool not int
Date:   Fri, 22 Nov 2019 13:50:52 -0800
Message-Id: <20191122215052.155595-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
References: <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
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

