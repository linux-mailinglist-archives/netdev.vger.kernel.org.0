Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FAFA5E19
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 01:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfIBX3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 19:29:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46131 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBX3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 19:29:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so1753769pfg.13
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 16:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1vDWjmM70LfW6cc+QxrhskQlwC96kB2Yd7xei6b4mr4=;
        b=OmMPaBjhVxcC+sm0hXVDwSCT6osf8G/CJFEqr4csefabTsFggDBppR6pQ5TFb+EKdN
         hvYqEvlbaYzhNe3zNmma5a4LtJKmBZXe804z0nFXqZtLuvreFZ/LQtZCtqz2p1baUOH1
         Ux+LS8veHDGnjdo8tEkkOzKzTQxMmlqlcwsEg51BwVrppt9jGjWOMYSn7IZGn/YiP6Tq
         44pvWvZW6ibojpYZBjYF6Z+LZQ1/huL9ma/64YGGQB77ENHwYJDQeT4VSCHnB3eBGxds
         +99aDAl9lV+p9KUNPVOPo6QjahLhbl0rD1/5dshi5yjVvWNIfjgTlbIAisYbWlprmIf8
         PrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1vDWjmM70LfW6cc+QxrhskQlwC96kB2Yd7xei6b4mr4=;
        b=GVJfwB2/jHZHu4k3vU4Uwyk3WCTbpccSgZN6Tb6WUBbNyI1phLpyP2C4OMlGindmqp
         GiD0IeTlHyU8BDdHMFTw5bty2wNmbK9mXHtp9NiVEUsGI4X/Uy3CQ+/f69i/JYzHH2hm
         eq1DPGjK4WMxZPnuksCFcUG3rI4QaRPTO1b0HmdOH56mz4M4jeYb/Pvq1Nwp6IkNq1/O
         rq9cPPZN3E2Y/f68XMC0HqLPrCgBsJcN7mnCRTz9ttnzjWUrMuA8vDuO0lAB06MlbVtU
         +Z6f0LzPRSC73JxWwDtV9Mf/qhKNcZ1QxpbJnyUcZZWvoyBORI+Bs6ajjh1DHoY5nEXV
         jCkA==
X-Gm-Message-State: APjAAAWg3r3NWuc4URKpXlUUNHNxpbRrXPrrAiw/lp+JAV5w736++g7M
        XVkYwQrrDT3vCZockHmfPLFFv/BEVZw=
X-Google-Smtp-Source: APXvYqzibmJGG5KI/7tJo/gaMievXZ7b5wSnFhd4tphE+NEVI+MW28U/WwtsrJ/z43DyFh6gDpImHw==
X-Received: by 2002:a17:90b:8ce:: with SMTP id ds14mr15250952pjb.105.1567466979554;
        Mon, 02 Sep 2019 16:29:39 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id v184sm16404703pgd.34.2019.09.02.16.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Sep 2019 16:29:39 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next] Convert usage of IN_MULTICAST to ipv4_is_multicast
Date:   Mon,  2 Sep 2019 16:29:36 -0700
Message-Id: <1567466976-1351-1-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IN_MULTICAST's primary intent is as a uapi macro.

Elsewhere in the kernel we use ipv4_is_multicast consistently.

This patch unifies linux's multicast checks to use that function
rather than this macro.

Signed-off-by: Dave Taht <dave.taht@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>

---
 drivers/net/geneve.c | 2 +-
 include/net/vxlan.h  | 4 ++--
 net/rds/af_rds.c     | 4 ++--
 net/rds/bind.c       | 4 ++--
 net/rds/send.c       | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index cb2ea8facd8d..3ab24fdccd3b 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1345,7 +1345,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 		info->key.u.ipv4.dst =
 			nla_get_in_addr(data[IFLA_GENEVE_REMOTE]);
 
-		if (IN_MULTICAST(ntohl(info->key.u.ipv4.dst))) {
+		if (ipv4_is_multicast(info->key.u.ipv4.dst)) {
 			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_REMOTE],
 					    "Remote IPv4 address cannot be Multicast");
 			return -EINVAL;
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index dc1583a1fb8a..335283dbe9b3 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -391,7 +391,7 @@ static inline bool vxlan_addr_multicast(const union vxlan_addr *ipa)
 	if (ipa->sa.sa_family == AF_INET6)
 		return ipv6_addr_is_multicast(&ipa->sin6.sin6_addr);
 	else
-		return IN_MULTICAST(ntohl(ipa->sin.sin_addr.s_addr));
+		return ipv4_is_multicast(ipa->sin.sin_addr.s_addr);
 }
 
 #else /* !IS_ENABLED(CONFIG_IPV6) */
@@ -403,7 +403,7 @@ static inline bool vxlan_addr_any(const union vxlan_addr *ipa)
 
 static inline bool vxlan_addr_multicast(const union vxlan_addr *ipa)
 {
-	return IN_MULTICAST(ntohl(ipa->sin.sin_addr.s_addr));
+	return ipv4_is_multicast(ipa->sin.sin_addr.s_addr);
 }
 
 #endif /* IS_ENABLED(CONFIG_IPV6) */
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 2977137c28eb..1a5bf3fa4578 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -559,7 +559,7 @@ static int rds_connect(struct socket *sock, struct sockaddr *uaddr,
 			ret = -EDESTADDRREQ;
 			break;
 		}
-		if (IN_MULTICAST(ntohl(sin->sin_addr.s_addr)) ||
+		if (ipv4_is_multicast(sin->sin_addr.s_addr) ||
 		    sin->sin_addr.s_addr == htonl(INADDR_BROADCAST)) {
 			ret = -EINVAL;
 			break;
@@ -593,7 +593,7 @@ static int rds_connect(struct socket *sock, struct sockaddr *uaddr,
 			addr4 = sin6->sin6_addr.s6_addr32[3];
 			if (addr4 == htonl(INADDR_ANY) ||
 			    addr4 == htonl(INADDR_BROADCAST) ||
-			    IN_MULTICAST(ntohl(addr4))) {
+			    ipv4_is_multicast(addr4)) {
 				ret = -EPROTOTYPE;
 				break;
 			}
diff --git a/net/rds/bind.c b/net/rds/bind.c
index 0f4398e7f2a7..6dbb763bc1fd 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -181,7 +181,7 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		if (addr_len < sizeof(struct sockaddr_in) ||
 		    sin->sin_addr.s_addr == htonl(INADDR_ANY) ||
 		    sin->sin_addr.s_addr == htonl(INADDR_BROADCAST) ||
-		    IN_MULTICAST(ntohl(sin->sin_addr.s_addr)))
+		    ipv4_is_multicast(sin->sin_addr.s_addr))
 			return -EINVAL;
 		ipv6_addr_set_v4mapped(sin->sin_addr.s_addr, &v6addr);
 		binding_addr = &v6addr;
@@ -206,7 +206,7 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 			addr4 = sin6->sin6_addr.s6_addr32[3];
 			if (addr4 == htonl(INADDR_ANY) ||
 			    addr4 == htonl(INADDR_BROADCAST) ||
-			    IN_MULTICAST(ntohl(addr4)))
+			    ipv4_is_multicast(addr4))
 				return -EINVAL;
 		}
 		/* The scope ID must be specified for link local address. */
diff --git a/net/rds/send.c b/net/rds/send.c
index 9ce552abf9e9..82dcd8b84fe7 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1144,7 +1144,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		case AF_INET:
 			if (usin->sin_addr.s_addr == htonl(INADDR_ANY) ||
 			    usin->sin_addr.s_addr == htonl(INADDR_BROADCAST) ||
-			    IN_MULTICAST(ntohl(usin->sin_addr.s_addr))) {
+			    ipv4_is_multicast(usin->sin_addr.s_addr)) {
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1175,7 +1175,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 				addr4 = sin6->sin6_addr.s6_addr32[3];
 				if (addr4 == htonl(INADDR_ANY) ||
 				    addr4 == htonl(INADDR_BROADCAST) ||
-				    IN_MULTICAST(ntohl(addr4))) {
+				    ipv4_is_multicast(addr4)) {
 					ret = -EINVAL;
 					goto out;
 				}
-- 
2.17.1

