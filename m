Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC2C1E88
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfI3J7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:59:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36527 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfI3J7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:59:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id m18so12011286wmc.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yaPNGdmtqURbhhCbze6HwYDLgUjVlHOsmkR9Dnj/4f0=;
        b=DTPU3ZvzQkOpsYYcQcLBybrdlLV7jERqc827ihIgz6hLAYcFdXS7SXDlEHdRg5/7rC
         WrOnKdGmtZHbPnXNuAwoCkoZNOMYcqsxy+fsHo8S5khHBDLCGMv6gEMWUUFjcX+y3M32
         vDSA+pCpIIx1r2o8w4Ddc+jrzTg/5AOb0RHuxvWxmKSP0ZsInDUk7131J5uakTlxqFGJ
         TE79HpLd+xmRO9rpznRa9FRePQwecmIoVz9n2OHaacjvpWGP9eqeXH4YUnoxsCPqbXTg
         3NdtUmmLM7baXAqkOjs3tjJeq3X7O8ul3tJhTVfSLJxYmMMpR6aYMY0ZnsL9Agzkcmst
         aW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaPNGdmtqURbhhCbze6HwYDLgUjVlHOsmkR9Dnj/4f0=;
        b=uMLXxGm+eZGXGjkgz/EjD4ecQMtSVx+imjVSI8NolZwxE5lK1O5UuptvbO2fKOELSK
         v/M8Du2Yk7Hef2W4l3CFyBzhw9mifCcS7u0em3uo+hpuHWS0DhwjlbeE3INz6wQo1zrq
         6bD527NzHq3FBm/rxBf9kGQUPHq8up2gHnsuvNSlH0AQsxR+QyBGe5InKmvmuuhpgdK1
         C/s3L8ApELgdn1/WO22BWDrItr1VLB79lYYzh6/9oNUNiTZVuZLf5k4SzxeydXe2y7jI
         eDgk+eDbsnFBG+0XVN8msLzA6ayIsUoBhsRLPcLGo20YtFPMVjk3kgPhv8FBgNUN0SbG
         ImFQ==
X-Gm-Message-State: APjAAAV8sFz4A3oxI2E1dgwuD4mrN90vMhu1u3Evf4ED3tVcGM6rRCEW
        ADrZM9zauitJfXGBH2FYb9UkdWAPGX8=
X-Google-Smtp-Source: APXvYqy1v7cDaVp/ZvXnxoud02ylSPA8B90FqhWpiKuEpBFioGw/qKBOTRil1NyW0xGdCyjUQDBarw==
X-Received: by 2002:a1c:4d0e:: with SMTP id o14mr8018043wmh.172.1569837545098;
        Mon, 30 Sep 2019 02:59:05 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id q3sm10888007wrm.86.2019.09.30.02.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:59:04 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 2/2] ip: allow to use alternative names as handle
Date:   Mon, 30 Sep 2019 11:59:03 +0200
Message-Id: <20190930095903.11851-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
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
rfc->v1:
- added patch description
---
 ip/iplink.c  |  5 +++--
 lib/ll_map.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index e3f8a28fe94c..1684e259b538 100644
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
index e0ed54bf77c9..04dfb0f2320b 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -70,7 +70,7 @@ static struct ll_cache *ll_get_by_name(const char *name)
 		struct ll_cache *im
 			= container_of(n, struct ll_cache, name_hash);
 
-		if (strncmp(im->name, name, IFNAMSIZ) == 0)
+		if (strcmp(im->name, name) == 0)
 			return im;
 	}
 
@@ -240,6 +240,43 @@ int ll_index_to_flags(unsigned idx)
 	return im ? im->flags : -1;
 }
 
+static int altnametoindex(const char *name)
+{
+	struct {
+		struct nlmsghdr		n;
+		struct ifinfomsg	ifm;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_GETLINK,
+	};
+	struct rtnl_handle rth = {};
+	struct nlmsghdr *answer;
+	struct ifinfomsg *ifm;
+	int rc = 0;
+
+	if (rtnl_open(&rth, 0) < 0)
+		return 0;
+
+	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK,
+		  RTEXT_FILTER_VF | RTEXT_FILTER_SKIP_STATS);
+	addattr_l(&req.n, sizeof(req), IFLA_ALT_IFNAME, name, strlen(name) + 1);
+
+	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
+		goto out;
+
+	ifm = NLMSG_DATA(answer);
+	rc = ifm->ifi_index;
+
+	free(answer);
+
+	rtnl_close(&rth);
+out:
+	return rc;
+}
+
+
 unsigned ll_name_to_index(const char *name)
 {
 	const struct ll_cache *im;
@@ -257,6 +294,8 @@ unsigned ll_name_to_index(const char *name)
 		idx = if_nametoindex(name);
 	if (idx == 0)
 		idx = ll_idx_a2n(name);
+	if (idx == 0)
+		idx = altnametoindex(name);
 	return idx;
 }
 
-- 
2.21.0

