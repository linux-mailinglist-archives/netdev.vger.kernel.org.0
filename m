Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D421831AFB3
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 09:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBNIKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 03:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNIKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 03:10:05 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B52C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 00:09:24 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e9so2047160plh.3
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 00:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZH5AthoYP0ATroCQXQOvsjYTNNTRpVgT1SFkwL5oOg=;
        b=POO5jLZt8HZztOn8zSIgbb4iDPecai0YEliOp+113Mg0cQHd4gzJViMwsxolXzBcTV
         fVfzNGcXP3xug+al2aFmZbi0GQ8JKcc7oJ5ajp3iaYr8IGadt4Gf+NYgYozKS1UfWn+x
         UJ09mNzjjWufcCihj23M0I5QxJai5Sl+3dhaYcwDc+2/LeNrNs5kkI7GhcreIKOQ9ytz
         8VEVlRvrTS0rKkjZ04x7ueg5d4Sl7meVQK0Nfea7I8gKLrL1ZJpffve7h4GFkxpwNWra
         cg4FSoSds+khZ/0wCD2OPWvP40gwZkjD9mbS7jXaay17bGq1DDFUKFzIJ48G7dcU1okE
         mwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZH5AthoYP0ATroCQXQOvsjYTNNTRpVgT1SFkwL5oOg=;
        b=ShpdRs0ptTj+X1+k10bUQYIGrScVd8TJ51vo1CpeVvnnp8zwY27qTyiIRhuzAWAY3d
         fE0fXXKZ91aF66wjwfWhHHeAyUXMfaOyblGWM+Y3aXU/TO9niuoYAjo7Y+VbXrCkWQ7d
         sKQWasLHDBvYpReSr5d1PGpSMmaZ8UyRC6jT/kf9z/53f5RrJf5FraKb38+L3sYQt9cl
         7a30LHqtJxB73K8+GaQL52AujktUSuGRPLyZkgCNjsK2cFGgUgHmcn6uJS8WgbtN6oaW
         qZyQI5I4YeajJdqRToNPY2RQ8lUXeNLCgK0wY/or5kbwrGz1LIjZdqszDrKb4FzKUuoM
         BjBA==
X-Gm-Message-State: AOAM531jWG7YvMcr7wcgqOb7j2WHIBuv8+jYSA7NK9H4TrNpopU5dVdV
        23cQrinh5oFtNuA0YWxmsWM=
X-Google-Smtp-Source: ABdhPJwEC/Q0X1yhvcIFFnEYtxqkaWllZOLLc3lEIIBbXbzDj7dMd/AZ6I7ZiIPrGUP9nYDOb0byZw==
X-Received: by 2002:a17:90b:4d06:: with SMTP id mw6mr10140735pjb.24.1613290164156;
        Sun, 14 Feb 2021 00:09:24 -0800 (PST)
Received: from tardis.. (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id w7sm12999231pjv.24.2021.02.14.00.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 00:09:23 -0800 (PST)
From:   Thayne McCombs <astrothayne@gmail.com>
To:     dsahern@gmail.com, netdev@vger.kernel.org
Cc:     Thayne McCombs <astrothayne@gmail.com>
Subject: [PATCH] ss: Make leading ":" always optional for sport and dport
Date:   Sun, 14 Feb 2021 01:09:13 -0700
Message-Id: <20210214080913.8651-1-astrothayne@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <0e45b850-6c2a-4089-1369-151987983552@gmail.com>
References: <0e45b850-6c2a-4089-1369-151987983552@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doh! Sorry about that, here it is with the sign-off.

-- >8 --

The sport and dport conditions in expressions were inconsistent on
whether there should be a ":" at the beginning of the port when only a
port was provided depending on the family. The link and netlink
families required a ":" to work. The vsock family required the ":"
to be absent. The inet and inet6 families work with or without a leading
":".

This makes the leading ":" optional in all cases, so if sport or dport
are used, then it works with a leading ":" or without one, as inet and
inet6 did.

Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
---
 misc/ss.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index aefa1c2f..5c934fa0 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2111,6 +2111,18 @@ static void vsock_set_inet_prefix(inet_prefix *a, __u32 cid)
 	memcpy(a->data, &cid, sizeof(cid));
 }
 
+static char* find_port(char *addr, bool is_port)
+{
+	char *port = NULL;
+	if (is_port)
+		port = addr;
+	else
+		port = strchr(addr, ':');
+	if (port && *port == ':')
+		*port++ = '\0';
+	return port;
+}
+
 void *parse_hostcond(char *addr, bool is_port)
 {
 	char *port = NULL;
@@ -2152,17 +2164,16 @@ void *parse_hostcond(char *addr, bool is_port)
 	if (fam == AF_PACKET) {
 		a.addr.family = AF_PACKET;
 		a.addr.bitlen = 0;
-		port = strchr(addr, ':');
+		port = find_port(addr, is_port);
 		if (port) {
-			*port = 0;
-			if (port[1] && strcmp(port+1, "*")) {
-				if (get_integer(&a.port, port+1, 0)) {
-					if ((a.port = xll_name_to_index(port+1)) <= 0)
+			if (*port && strcmp(port, "*")) {
+				if (get_integer(&a.port, port, 0)) {
+					if ((a.port = xll_name_to_index(port)) <= 0)
 						return NULL;
 				}
 			}
 		}
-		if (addr[0] && strcmp(addr, "*")) {
+		if (!is_port && addr[0] && strcmp(addr, "*")) {
 			unsigned short tmp;
 
 			a.addr.bitlen = 32;
@@ -2176,19 +2187,18 @@ void *parse_hostcond(char *addr, bool is_port)
 	if (fam == AF_NETLINK) {
 		a.addr.family = AF_NETLINK;
 		a.addr.bitlen = 0;
-		port = strchr(addr, ':');
+		port = find_port(addr, is_port);
 		if (port) {
-			*port = 0;
-			if (port[1] && strcmp(port+1, "*")) {
-				if (get_integer(&a.port, port+1, 0)) {
-					if (strcmp(port+1, "kernel") == 0)
+			if (*port && strcmp(port, "*")) {
+				if (get_integer(&a.port, port, 0)) {
+					if (strcmp(port, "kernel") == 0)
 						a.port = 0;
 					else
 						return NULL;
 				}
 			}
 		}
-		if (addr[0] && strcmp(addr, "*")) {
+		if (!is_port && addr[0] && strcmp(addr, "*")) {
 			a.addr.bitlen = 32;
 			if (nl_proto_a2n(&a.addr.data[0], addr) == -1)
 				return NULL;
@@ -2201,21 +2211,13 @@ void *parse_hostcond(char *addr, bool is_port)
 
 		a.addr.family = AF_VSOCK;
 
-		if (is_port)
-			port = addr;
-		else {
-			port = strchr(addr, ':');
-			if (port) {
-				*port = '\0';
-				port++;
-			}
-		}
+		port = find_port(addr, is_port);
 
 		if (port && strcmp(port, "*") &&
 		    get_u32((__u32 *)&a.port, port, 0))
 			return NULL;
 
-		if (addr[0] && strcmp(addr, "*")) {
+		if (!is_port && addr[0] && strcmp(addr, "*")) {
 			a.addr.bitlen = 32;
 			if (get_u32(&cid, addr, 0))
 				return NULL;
-- 
2.30.1

