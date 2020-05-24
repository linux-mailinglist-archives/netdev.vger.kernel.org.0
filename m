Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D2D1DFC50
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 03:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgEXBvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 21:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387589AbgEXBvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 21:51:51 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32789C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 18:51:50 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m2so7844488qtd.7
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 18:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ib20qnKqlHueZ/Aw31ocWOwrL7mHImR2PdAvhPHYZbE=;
        b=P9iIai6pAa/BPzDQHgmLuth0xp5RDGGhgCOwsa+cJGPtSiDKovLbTE7GUDbuRX0aSw
         XCYlncD7nflJYAnbxa523S16qMolmlFpeiy68+5xFKEv3runjvhWN033ULBpJD1RF7eo
         OBvHl+Az6RXYPM0KKyFMfwJSTbCaOXk/KsIk0EhFHxnpTboKFjSNEcSKS208OuN/Rlq2
         6zFK0U7eQ96wJJ9Hwvd8T5+dfnbyv98Iwm4RnQga9wwfulrTN9W9qXrDEZ21nCA+qttN
         jeit/Xy8WRGpwN2+kgBSp2HcZ0v6J6mZX1p2MZY/IX4lPhPlqPqCru5mMkSgrnNmONw1
         cojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ib20qnKqlHueZ/Aw31ocWOwrL7mHImR2PdAvhPHYZbE=;
        b=gRmHFFzxllTEmcMYN6NPmjp1lpN1Hy2AmZiaSFy97LQ/SOQNSG83ReHTe0l6RgJ0mI
         /F2Hl/JoQFwmXkcKCpHwOW/VM4zzM0DdvIt/ZFFbZ+er9Ci/ymNrcHNhAZCNlpH4CmB8
         TxasuRt1rLt/rCAnHhrVke32wtGvpi4Ev+U9SThu4fwuHhmB1zJ4ubeev5aiIKWbne+S
         XRn1T04PmXvZmR6Q18llOsvS7z2bwsnIuz9nSTFF+R404/8cooMvBQ0f2RPSMNxLMEqL
         IJIj/ZooxqBryS6SQLdX1gcQK+PoTyJuejm3YE2KzAvIf1q92n/V2cXCR7y1+1U7RVpG
         07cg==
X-Gm-Message-State: AOAM533vbchkUh+B2bJqtfSnNHr2K4Y5oubcwuwQEG2UJA9WMHM1taOS
        MinZuxbCW9HfzezxvXAh1ZZfAakwiHR2dU/w6BcdtkQcryPpM6wZ5PylvyuOcwqGpGBy4Wf+c8U
        6n23GHeD7Z7L8lyJwnP2UL8v3I71zazDOq7dssszxm+MYUOQsGDKPfM5CDCzjec/x7zqzUA==
X-Google-Smtp-Source: ABdhPJxXh5A0DrdSB3vPCq3mWt+JOFxd9pUrGCyuCpY6RYycTYw7GH/udOVoyLX1iHlgh4CiicImhvay/CB2y7k=
X-Received: by 2002:a0c:b44c:: with SMTP id e12mr10032901qvf.30.1590285109218;
 Sat, 23 May 2020 18:51:49 -0700 (PDT)
Date:   Sat, 23 May 2020 18:51:44 -0700
Message-Id: <20200524015144.44017-1-icoolidge@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH] iproute2: ip addr: Accept 'optimistic' flag
From:   "Ian K. Coolidge" <icoolidge@google.com>
To:     netdev@vger.kernel.org
Cc:     "Ian K. Coolidge" <icoolidge@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows addresses added to use IPv6 optimistic DAD.
---
 ip/ipaddress.c           | 7 ++++++-
 man/man8/ip-address.8.in | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 80d27ce2..48cf5e41 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -72,7 +72,7 @@ static void usage(void)
 		"           [-]tentative | [-]deprecated | [-]dadfailed | temporary |\n"
 		"           CONFFLAG-LIST ]\n"
 		"CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG\n"
-		"CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute | autojoin ]\n"
+		"CONFFLAG  := [ home | nodad | optimistic | mngtmpaddr | noprefixroute | autojoin ]\n"
 		"LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]\n"
 		"LFT := forever | SECONDS\n"
 		"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
@@ -2335,6 +2335,11 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 				ifa_flags |= IFA_F_HOMEADDRESS;
 			else
 				fprintf(stderr, "Warning: home option can be set only for IPv6 addresses\n");
+		} else if (strcmp(*argv, "optimistic") == 0) {
+			if (req.ifa.ifa_family == AF_INET6)
+				ifa_flags |= IFA_F_OPTIMISTIC;
+			else
+				fprintf(stderr, "Warning: optimistic option can be set only for IPv6 addresses\n");
 		} else if (strcmp(*argv, "nodad") == 0) {
 			if (req.ifa.ifa_family == AF_INET6)
 				ifa_flags |= IFA_F_NODAD;
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index 2a553190..fe773c91 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -92,7 +92,7 @@ ip-address \- protocol address management
 
 .ti -8
 .IR CONFFLAG " := "
-.RB "[ " home " | " mngtmpaddr " | " nodad " | " noprefixroute " | " autojoin " ]"
+.RB "[ " home " | " mngtmpaddr " | " nodad " | " optimstic " | " noprefixroute " | " autojoin " ]"
 
 .ti -8
 .IR LIFETIME " := [ "
@@ -258,6 +258,11 @@ stateless auto-configuration was active.
 (IPv6 only) do not perform Duplicate Address Detection (RFC 4862) when
 adding this address.
 
+.TP
+.B optimistic
+(IPv6 only) When performing Duplicate Address Detection, use the RFC 4429
+optimistic variant.
+
 .TP
 .B noprefixroute
 Do not automatically create a route for the network prefix of the added
-- 
2.27.0.rc0.183.gde8f92d652-goog

