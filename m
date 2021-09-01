Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B507B3FD7C8
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbhIAKjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235258AbhIAKjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:39:18 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0534EC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 03:38:22 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id me10so5529686ejb.11
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5lE8m62tSp6aNk3T+0edy9NLkv9Nbj+TwR8sRB68q/U=;
        b=r38fXqtj0XWEpOrqaPxCMZnGb7K3jLQY1GH8Ac98CaLoHBpX0aeO1ydAU3aonDEbVP
         8F2vaMwuvwaWcgn1Dt2h7NGibxFJyTg1UAnvrcnfdPqAJp7yS8Xs0is2N1VKkS3a9UIk
         36eLdEGepTtUs7a7c0+9VRW8ipfEhkiPuW91La5i46Aj6aveMxElvlvQOKH2VxL+9K65
         cv3IZaYtjICmw688pJWtyAYq3TOWKR0PwWpfihwXN8NAL898A62nT3KP51AYNgRoKYtA
         fRadfZ4kYFbyV0IEgj/+J8pQOr98684l5/SNtP83CQ9jjcX2l+oCNuT7lQ3lm6EtN7LB
         mCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5lE8m62tSp6aNk3T+0edy9NLkv9Nbj+TwR8sRB68q/U=;
        b=Z4PI02x6/Oyq9vPvfQJNaRvgPxb6eAT/5RjQ9UpZh5F2gzYNo7LmWphTR7m1m/3fk0
         TzsannBBnG87smL5O+7X1vn+giVhGGWgLM4E9ZX9hrJgV6XMes2RSColLM0fDgxvopgA
         /7U+6//R+aH9TDEZ+t5k+oGR90gkt68Pub1iOUsPKSDBxGuaKzvINMljd4qjgA3T0rMR
         qrQmXCNhba5owqc1ntkjFzA9h1djbJPQple2OSm7lrSO+oU6Ruy3E08LiJKMq7FldrBk
         2glHAD2OqxsHNEnNuR/XFLqHwMAS4dJnU9G/z+2rxAZDl61Fp4tJ06+XlerrWJ8SiiFI
         5mbw==
X-Gm-Message-State: AOAM532f1Kj1jZOdff0OnCX81QgkuHSt9Hr4ckj/O0INl5Zt31xA7p1L
        ++imy+PzIXLmEPwVUmc5DMBCkJ059ZiCvaSt
X-Google-Smtp-Source: ABdhPJyGOIKOHb9VRmGn+h/Gi97NXxR9MkB/59DyfCLWgS7h5zO/GadQ6hYeiRC6zdH47dUgKYksSQ==
X-Received: by 2002:a17:907:766e:: with SMTP id kk14mr35704971ejc.339.1630492700368;
        Wed, 01 Sep 2021 03:38:20 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y23sm9580527ejp.115.2021.09.01.03.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:38:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 1/2] bridge: vlan: set vlan option attributes while parsing
Date:   Wed,  1 Sep 2021 13:38:15 +0300
Message-Id: <20210901103816.1163765-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901103816.1163765-1-razor@blackwall.org>
References: <20210901103816.1163765-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Set vlan option attributes immediately while parsing to simplify the
checks, avoid having reserved values (e.g. -1 for unset var) and have
more limited scope for the variables. This is also similar to how global
vlan options are set. The attribute setting and checks are moved with
option parsing, no functional changes intended.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c | 53 ++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 4ead57b783a8..48365bca4c4a 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -272,16 +272,24 @@ static int vlan_option_set(int argc, char **argv)
 	};
 	struct bridge_vlan_info vinfo = {};
 	struct rtattr *afspec;
-	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
-	int state = -1;
 
+	afspec = addattr_nest(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY);
+	afspec->rta_type |= NLA_F_NESTED;
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
 			NEXT_ARG();
 			d = *argv;
+			req.bvm.ifindex = ll_name_to_index(d);
+			if (req.bvm.ifindex == 0) {
+				fprintf(stderr,
+					"Cannot find network device \"%s\"\n",
+					d);
+				return -1;
+			}
 		} else if (strcmp(*argv, "vid") == 0) {
+			short vid_end = -1;
 			char *p;
 
 			NEXT_ARG();
@@ -299,8 +307,22 @@ static int vlan_option_set(int argc, char **argv)
 			} else {
 				vid = atoi(*argv);
 			}
+			if (vid >= 4096) {
+				fprintf(stderr, "Invalid VLAN ID \"%hu\"\n",
+					vid);
+				return -1;
+			}
+
+			vinfo.flags = BRIDGE_VLAN_INFO_ONLY_OPTS;
+			vinfo.vid = vid;
+			addattr_l(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_INFO,
+				  &vinfo, sizeof(vinfo));
+			if (vid_end != -1)
+				addattr16(&req.n, sizeof(req),
+					  BRIDGE_VLANDB_ENTRY_RANGE, vid_end);
 		} else if (strcmp(*argv, "state") == 0) {
 			char *endptr;
+			int state;
 
 			NEXT_ARG();
 			state = strtol(*argv, &endptr, 10);
@@ -310,42 +332,21 @@ static int vlan_option_set(int argc, char **argv)
 				fprintf(stderr, "Error: invalid STP state\n");
 				return -1;
 			}
+			addattr8(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_STATE,
+				 state);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
 		}
 		argc--; argv++;
 	}
+	addattr_nest_end(&req.n, afspec);
 
 	if (d == NULL || vid == -1) {
 		fprintf(stderr, "Device and VLAN ID are required arguments.\n");
 		return -1;
 	}
 
-	req.bvm.ifindex = ll_name_to_index(d);
-	if (req.bvm.ifindex == 0) {
-		fprintf(stderr, "Cannot find network device \"%s\"\n", d);
-		return -1;
-	}
-
-	if (vid >= 4096) {
-		fprintf(stderr, "Invalid VLAN ID \"%hu\"\n", vid);
-		return -1;
-	}
-	afspec = addattr_nest(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY);
-	afspec->rta_type |= NLA_F_NESTED;
-
-	vinfo.flags = BRIDGE_VLAN_INFO_ONLY_OPTS;
-	vinfo.vid = vid;
-	addattr_l(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_INFO, &vinfo,
-		  sizeof(vinfo));
-	if (vid_end != -1)
-		addattr16(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_RANGE,
-			  vid_end);
-	if (state >= 0)
-		addattr8(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_STATE, state);
-	addattr_nest_end(&req.n, afspec);
-
 	if (rtnl_talk(&rth, &req.n, NULL) < 0)
 		return -1;
 
-- 
2.31.1

