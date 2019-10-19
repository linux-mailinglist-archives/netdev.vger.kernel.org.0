Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2913DD9D0
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfJSRh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 13:37:56 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:38394 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfJSRh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 13:37:56 -0400
Received: by mail-wm1-f52.google.com with SMTP id 3so8919427wmi.3
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 10:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9599ZeIhe5QMmJM9oH9aNpMDWiL+Pk1Pi9VQ7Im2WgE=;
        b=dVfWfvKygQH4D44z6WLYfhvBWLADmQuzWMxfpVefbJbbbNdbb1K1UlT6W9Ic4YCA/4
         mus6Y1CeBhx7OZZXqs5nfgfmAoUEqxZG4yL941IA9mN0Wya909/3wlq4Gyto2jJYdmYK
         F/nnd4jAV9VwIpxgm1jynlSj7fgMYqfqI8WYgoLIDDR7rgV0Xp4FoQDT67VQoM330NgG
         3HCTkGMdB38sf+tyT5he5vaTG9j9rAKKM8vPN4bd0Oei3DtBU4jybb7yCvQOkM6rvE5k
         WHvkFSIGHtLxeCqpU6+RL99m7XmEC+h6eM/uTxowa9GQNGfP0MSh+ivO1NlkgA1zMIuh
         ESew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9599ZeIhe5QMmJM9oH9aNpMDWiL+Pk1Pi9VQ7Im2WgE=;
        b=kcTqtNAkjQqgMX91iOWQLQqoqz5VSv1sKH5GpiPS0+9jEApKbfX8orAAQtEIlwqWTC
         ysZp35MJ6J3Gpsgz3CtSf2Yj1AZOULIMV6sG0p9PCgQw/gJ90V/EaS53arioG+9ZsHiA
         tvQl0lgrHr3xQQI88+Nw9JIbtOr/pgmFdN7r6dzIGguPjAIvUQSas0/C8kWZhxVNvAKe
         X39Zg5euYcs5+qDy/ImZ5K9OOnxLFC41+tYuJWNbu65Bsk+1bbJgaj58d6WBiJwDmj5O
         pnUewTNV9FMKRbqutnuSOgRQ48R3I0SPWzZjnLelFubZzzbX08vL3fERV1iqx6BPz/az
         1ejw==
X-Gm-Message-State: APjAAAWUwjhsPocF0lupsyjjUifVOc00Njow37YKbuQNl6w7rAy0SkxO
        auXtiJE0Yb87KmhIHSGPD/Dd09LqSVI=
X-Google-Smtp-Source: APXvYqx3rdo+UAnoThAuiGc1F8UTWmLmse61+clVhdkCsEIDtaTiR100MuEk8S50JFLxHC/ORceo4Q==
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr8750331wml.27.1571506673779;
        Sat, 19 Oct 2019 10:37:53 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z189sm11472569wmc.25.2019.10.19.10.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 10:37:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v4 3/3] ip: allow to use alternative names as handle
Date:   Sat, 19 Oct 2019 19:37:49 +0200
Message-Id: <20191019173749.19068-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191019173749.19068-1-jiri@resnulli.us>
References: <20191019173749.19068-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend ll_name_to_index() to get the index of a netdevice using
alternative interface name. Allow alternative long names to pass checks
in couple of ip link/addr commands.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v3->v4:
- moved utils.h include into the first patch
v2->v3:
- removed altnametoindex and doing IFLA_IFNAME/IFLA_ALT_IFNAME in
  ll_link_get() instead.
rfc->v1:
- added patch description
---
 ip/iplink.c  | 5 +++--
 lib/ll_map.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index bf90fad1b3ea..47f73988c2d5 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -931,7 +931,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				NEXT_ARG();
 			if (dev != name)
 				duparg2("dev", *argv);
-			if (check_ifname(*argv))
+			if (check_altifname(*argv))
 				invarg("\"dev\" not a valid ifname", *argv);
 			dev = *argv;
 		}
@@ -1106,7 +1106,8 @@ int iplink_get(char *name, __u32 filt_mask)
 
 	if (name) {
 		addattr_l(&req.n, sizeof(req),
-			  IFLA_IFNAME, name, strlen(name) + 1);
+			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
+			  name, strlen(name) + 1);
 	}
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
 
diff --git a/lib/ll_map.c b/lib/ll_map.c
index 1b382b5cec94..52d149dcd91b 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -72,7 +72,7 @@ static struct ll_cache *ll_get_by_name(const char *name)
 		struct ll_cache *im
 			= container_of(n, struct ll_cache, name_hash);
 
-		if (strncmp(im->name, name, IFNAMSIZ) == 0)
+		if (strcmp(im->name, name) == 0)
 			return im;
 	}
 
@@ -287,8 +287,9 @@ static int ll_link_get(const char *name, int index)
 
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
 	if (name)
-		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, name,
-			  strlen(name) + 1);
+		addattr_l(&req.n, sizeof(req),
+			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
+			  name, strlen(name) + 1);
 
 	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
 		goto out;
-- 
2.21.0

