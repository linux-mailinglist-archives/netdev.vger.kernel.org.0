Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BA74157
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfGXWXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:23:47 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:39245 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfGXWXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:23:46 -0400
Received: by mail-wr1-f47.google.com with SMTP id x4so48534863wrt.6
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 15:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nSFzxl5a0gAsvwK9ZdGSfdw1YCPx8TONxoQNDuNuVhg=;
        b=tEQTORV4ungCKgyRD/kp5GRy4UqLdRB+z+wWbPO4FldBSPd/7DBv4QJWeaBrVMAPkX
         HH1/ueyCcg1Lw1Bk4SXhI9rv6YF1H42sCkWcCrO/aj4gd3YkTecamh/S4Hjst/FLOQVk
         TjzYBbEpsmwOe8jkfJ4HL3KhP/TUxVJ71j36riTAK1W0ddBEZZoc+T83uqBCAsKLK3dP
         jgCem52oKl7vmHMaIMBZhOAvFd5iAxT2qvB6qlNYfSGU6ynsYjI8Ai1KmpMSLSMgr+hF
         /4k8Ls2mJCiQ30mQguYlzDRH6es4yjX3qySWvkKyCEU0GaLQVl3uc6//ot1aaMNRKqSW
         fNxQ==
X-Gm-Message-State: APjAAAVEY4doVYP0QIDhy9bk6QqIrWArmV3eK9wTBr/EcnanRo84ONNP
        lROQPBiLoA6weFl9yKxRYSSXYYUtDV4=
X-Google-Smtp-Source: APXvYqxhnI6f9cRxIHyiuHsk0KyvkiicNC0i9cFZLEDmmc9xOjN3B4TljiASuGYcv2DCcjjhqyxYxg==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr83412460wrq.319.1564007024355;
        Wed, 24 Jul 2019 15:23:44 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host21-50-dynamic.21-87-r.retail.telecomitalia.it. [87.21.50.21])
        by smtp.gmail.com with ESMTPSA id f7sm46444550wrv.38.2019.07.24.15.23.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 15:23:43 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2] iplink: document the 'link change' subcommand
Date:   Wed, 24 Jul 2019 21:12:18 +0200
Message-Id: <20190724191218.11757-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip link can set parameters both via the 'set' and 'change' keyword.
In fact, 'change' is an alias for 'set'.
Document this in the help and manpage.

Fixes: 1d93483985f0 ("iplink: use netlink for link configuration")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 ip/iplink.c           | 4 ++--
 man/man8/ip-link.8.in | 7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 212a0885..be237c93 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -64,12 +64,12 @@ void iplink_usage(void)
 			"\n"
 			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
 			"\n"
-			"	ip link set { DEVICE | dev DEVICE | group DEVGROUP }\n"
+			"	ip link { set | change } { DEVICE | dev DEVICE | group DEVGROUP }\n"
 			"			[ { up | down } ]\n"
 			"			[ type TYPE ARGS ]\n");
 	} else
 		fprintf(stderr,
-			"Usage: ip link set DEVICE [ { up | down } ]\n");
+			"Usage: ip link { set | change } DEVICE [ { up | down } ]\n");
 
 	fprintf(stderr,
 		"		[ arp { on | off } ]\n"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 883d8807..d4be1a0e 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1802,7 +1802,8 @@ deleted since it is the default group.
 .BI type " TYPE "
 specifies the type of the device.
 
-.SS ip link set - change device attributes
+.SS ip link set
+.SS ip link change - change device attributes
 
 .PP
 .B Warning:
@@ -1815,6 +1816,10 @@ can move the system to an unpredictable state. The solution
 is to avoid changing several parameters with one
 .B ip link set
 call.
+.B set
+and
+.B change
+are synonyms and have identical syntax and behavior.
 
 .TP
 .BI dev " DEVICE "
-- 
2.21.0

