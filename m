Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C24D0F2A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbfJIMty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:49:54 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36088 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbfJIMtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:49:53 -0400
Received: by mail-wr1-f50.google.com with SMTP id y19so2838203wrd.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 05:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6f/ADsT4NiPuk4LYiN3omyCi+X+BMo4XSPaq8QEdsxw=;
        b=XyqvvkEiYyDiEPC5fhg72aKDWcQxIAnFlJCwDHdBnTQ0SWeTQ1312vEhxHZWKdoS8Q
         Ef2Kxb4lUxhbZDEPcx1lTaSfA74pz51EuN2k1kt+9QMxQPZSOstKnrbwQY9+cGCuAP/R
         TyeQibFDJarrDIGZ8L/UN/kCL7ZFfEpp3MGZdz0b7ZFLz+fNNPaSj0Dt3nMbSjCx1AEZ
         e3H2DiO/sz1pmFRb6m+bpILu61rEuue3MP5MKiEVpJNvee2j/dg51QA+gZ1cG7WE1ljd
         nP84wNAi8JT3cmAhSNBaR5mtJLsRNcsGDvAMzcZfOYtnIgyEb9EqaJ3xQZ70G96NlOSE
         fRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6f/ADsT4NiPuk4LYiN3omyCi+X+BMo4XSPaq8QEdsxw=;
        b=qkVs4rkT3r+TfsKF0dp9oRSTY0EyOoSCx0K5HrnxzJI6EZ9GognUL74kuPWoLK+txt
         bVk5oURCVadVbRGNaoEETrUFHLAJeV0JV84GqfrLQm7jNl6zI58ecCErllAp9SzcdvKl
         UlO76jAFbtfnx6zmqm4AV1BORyEqw6E8q9CcXT2c8eFcop75mEMe9e+WyJxHQvRYYu7Z
         6ILyY8TyJi4hEjm1GhLUOztp1XvDcm9b1/cFOyMp16Nk0kw4ImugmdZNYtxIOZgkHUrQ
         P7XBhT8ZNokyFY5UP6yON6enZFIj8zppcKdOky4EsLFRcb0mimmhLfyvwe/Su4QFlgcq
         78+A==
X-Gm-Message-State: APjAAAVen5MnE07jMYw6lMvWWsOdkERPfsmPH3n15xycaFT6heOEVd4O
        hs2RuQRwJrwOoYH39ZTVJrQ0JFZwoQ8=
X-Google-Smtp-Source: APXvYqy3pNmuBMU2FdxwflkwVWjY+oyWySIgRr1ehWDcdDPCaJm07klzISvZtNhNI/5oBc8YFYk01w==
X-Received: by 2002:a5d:6992:: with SMTP id g18mr2951027wru.237.1570625390482;
        Wed, 09 Oct 2019 05:49:50 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id y3sm8649003wmg.2.2019.10.09.05.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:49:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v3 2/2] ip: allow to use alternative names as handle
Date:   Wed,  9 Oct 2019 14:49:47 +0200
Message-Id: <20191009124947.27175-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191009124947.27175-1-jiri@resnulli.us>
References: <20191009124947.27175-1-jiri@resnulli.us>
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
v2->v3:
- removed altnametoindex and doing IFLA_IFNAME/IFLA_ALT_IFNAME in
  ll_link_get() instead.
rfc->v1:
- added patch description
---
 ip/iplink.c  | 5 +++--
 lib/ll_map.c | 8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

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
index e0ed54bf77c9..5c612f952be4 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -22,6 +22,7 @@
 #include "libnetlink.h"
 #include "ll_map.h"
 #include "list.h"
+#include "utils.h"
 
 struct ll_cache {
 	struct hlist_node idx_hash;
@@ -70,7 +71,7 @@ static struct ll_cache *ll_get_by_name(const char *name)
 		struct ll_cache *im
 			= container_of(n, struct ll_cache, name_hash);
 
-		if (strncmp(im->name, name, IFNAMSIZ) == 0)
+		if (strcmp(im->name, name) == 0)
 			return im;
 	}
 
@@ -174,8 +175,9 @@ static int ll_link_get(const char *name, int index)
 
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

