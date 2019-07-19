Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D68F6E4A9
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfGSLDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:03:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44077 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfGSLDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:03:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so31803832wrf.11
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j6GyE+Jcy/rxx/rrCXGOUFntwlZUty/id9jeiuXNxpA=;
        b=AKV8ybxEcFsYNyUe9HXEv51MmuRW4SvEnWQKJHbZv2d1kg8XQgza7lDZ16gxY9eSko
         wQ3+zRNhFMu8Bf2FOOJGLOUBuq6NBdgKg83mw8IANswzUbr7UYlJ+eMat0CvlBS6LeS5
         5SZxgDsGFM7LPSE9wNBhuRVajud6ucVYHwk84UY9iZ5y/52eOojWb2glUamNIw4Xpwmu
         zxieeaAGJ7QkbQlwhKPhykIxidoP/oeK3/I+N0zpvyfjpLjufKq7vmvjZVouUGbqHtRL
         B9uUAGmxQLW5xRnHID2XgFOBwVJZLfy+AabjQNSNdCv6BcDHQQu0QDSaAWK971Ow8fBE
         foZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j6GyE+Jcy/rxx/rrCXGOUFntwlZUty/id9jeiuXNxpA=;
        b=KDGCJMTBBflhlgxdWQ9MgNP+/r3xYHqEF4nGgHH6fIzwas+LZ74Nm6YXqTkYJ5LfmW
         FOwctZh66cECC2Pm+6og/9NrsEaQBio1UGSID+HLKAqi4sXhu4kP/ysbT61uwzhL8vzF
         hMe9R256yO8XLXH0BpiYegsbYCVAgJTQRi6WitypOfAiDQME9g9f6AekitWnwgBdbc16
         7P+WBK5aYoRoSemnRUIh4R9kApZB9ycFK0CIljZ4GMEBVzlKnMVy7xHchi7rW7OrYujV
         la5jjd5mn2j0pcMw2oie2KWLAk5IsynW7Af7hcboZvNhf91TF71cv9KyLgLfHZJWQFhy
         Rcjg==
X-Gm-Message-State: APjAAAXCUiP6PdKD1nwAt3AkddJdwliTe1nYJYIhpjB2MiUFteU1ccYf
        PapKuhE7hclT8NljI9Oc5ZvP3izT
X-Google-Smtp-Source: APXvYqy+Op/uQq7wmvTBVMe1T3Om/VUuDNb7DJsX7ZhJimn4h55ZYiystpcJWeeW7bKi2OQrpKvJsQ==
X-Received: by 2002:a5d:4b91:: with SMTP id b17mr18252602wrt.57.1563534191932;
        Fri, 19 Jul 2019 04:03:11 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id t63sm23962881wmt.6.2019.07.19.04.03.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:03:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch iproute2 rfc 2/2] ip: allow to use alternative names as handle
Date:   Fri, 19 Jul 2019 13:03:09 +0200
Message-Id: <20190719110309.29731-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 ip/iplink.c  |  5 +++--
 lib/ll_map.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 45f975f1dce9..ad1e67761dd8 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -929,7 +929,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				NEXT_ARG();
 			if (dev != name)
 				duparg2("dev", *argv);
-			if (check_ifname(*argv))
+			if (check_altifname(*argv))
 				invarg("\"dev\" not a valid ifname", *argv);
 			dev = *argv;
 		}
@@ -1104,7 +1104,8 @@ int iplink_get(char *name, __u32 filt_mask)
 
 	if (name) {
 		addattr_l(&req.n, sizeof(req),
-			  IFLA_IFNAME, name, strlen(name) + 1);
+			  check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
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

