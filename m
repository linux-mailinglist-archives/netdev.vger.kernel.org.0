Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11A0107A68
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKVWMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:12:13 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36976 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVWMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 17:12:13 -0500
Received: by mail-pf1-f195.google.com with SMTP id p24so4153329pfn.4
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 14:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PH3oskZajODHo7MO2kKiKAjHTkTyKD0FVvQ5pX14AH0=;
        b=B64z0l6CHxdNQX1uRb/ezQsRHwDa8kYOfHZgAQmRUK8Sw7MPPoASL2SOyOKTuOz/Uv
         H6PQCgfCrffTxMlse/Ff5Izb+HhHK1cofRcdYmF7MTEA7ITBNyP8d4DmqvaC528/uH/b
         Dze1OpE7nQQAaRyYPL2aB8WcO9jN2ObiPfP11nARl+L27b92uJG7Dxmh/w0tdJdvXunh
         BC9jTVovkzwRRkAZ3Qyr+uF2Nqovusq/FOi6HATp6cSe8lrAd+o+ggqQijb1TxEnWYgu
         R+97Yw1Yb/ookT3HSbMip0ZBewcQi68HypksX7svUWsETpVjyKtK0Ab4UdDjx/DjgdpU
         8viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PH3oskZajODHo7MO2kKiKAjHTkTyKD0FVvQ5pX14AH0=;
        b=aFGjPj5Vkms+lbI0K73Xj0nEMuWAy33HLGFrI9ZsnOklSINgbFf8Re4jnJmw/l4aSO
         KgiuYGnVd4/Rlf0ma0CH4rconZ6BkM7bWxUOx9VV5EpPNW3oRoNFXbf28phhDwc/Do15
         lKoUoBfDniXPRct/EBT/xdNkzSrDoyI6NzYl5UVv5Jjn9aI+x5DFGo80GsQecBsIwl6x
         pWWPbiltKjmOahS+Jqa6H5m/HdKcHImZYO1WZIJJWVaHRh0E/DGggHtIn9pbbIgQ1VAh
         4ciKRudHjELEisHuwugRJUDRCGqCXlrlrQuRQhiAjmTpGsM5DnCD+/+gDA9jlF0ftZIb
         6uZw==
X-Gm-Message-State: APjAAAVpDriiV1YNnNXbhZ5hR4L6DBCDFCo5QMpf0V5MydheTmJ3nY0X
        0vYAppLUFC4OgmmyELI5T5Q=
X-Google-Smtp-Source: APXvYqw1qSKGBa/5+3ZQjUXKJATTPYBOsfZroaMcuZiE1cw81ifgYM7d//3A7bhUKKFue2/ECfbVfg==
X-Received: by 2002:a63:ea17:: with SMTP id c23mr4418819pgi.85.1574460732661;
        Fri, 22 Nov 2019 14:12:12 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id f13sm8619816pfa.57.2019.11.22.14.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 14:12:11 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net: Fix a documentation bug wrt. ip_unprivileged_port_start
Date:   Fri, 22 Nov 2019 14:12:04 -0800
Message-Id: <20191122221204.160964-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

It cannot overlap with the local port range - ie. with autobind selectable
ports - and not with reserved ports.

Indeed 'ip_local_reserved_ports' isn't even a range, it's a (by default
empty) set.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 Documentation/networking/ip-sysctl.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 099a55bd1432..dcf05fd1143a 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -904,8 +904,9 @@ ip_local_port_range - 2 INTEGERS
 	Defines the local port range that is used by TCP and UDP to
 	choose the local port. The first number is the first, the
 	second the last local port number.
-	If possible, it is better these numbers have different parity.
-	(one even and one odd values)
+	If possible, it is better these numbers have different parity
+	(one even and one odd value).
+	Must be greater than or equal to ip_unprivileged_port_start.
 	The default values are 32768 and 60999 respectively.
 
 ip_local_reserved_ports - list of comma separated ranges
@@ -944,7 +945,7 @@ ip_unprivileged_port_start - INTEGER
 	unprivileged port in the network namespace.  Privileged ports
 	require root or CAP_NET_BIND_SERVICE in order to bind to them.
 	To disable all privileged ports, set this to 0.  It may not
-	overlap with the ip_local_reserved_ports range.
+	overlap with the ip_local_port_range.
 
 	Default: 1024
 
-- 
2.24.0.432.g9d3f5f5b63-goog

