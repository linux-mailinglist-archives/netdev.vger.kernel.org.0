Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42297C86C8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 12:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfJBK4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 06:56:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41866 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfJBK4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 06:56:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id q9so327389wrm.8
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 03:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yaPNGdmtqURbhhCbze6HwYDLgUjVlHOsmkR9Dnj/4f0=;
        b=ZjNGK5KbxOsBCmh+MZC2Ti7BSqAH0Uo53GomCvhf99UXQeLVpyp2MgERuEORgqe7Ve
         p1TGlt9V4JdEK/EFL8MBEOJIPoTxSt9D8PGuXaUKb42tsb/3dHy0jjUs9Fyod+tviYim
         P9VNVq6B3paibBrv4b9pfe8wx3pNVoXdbvn48v99DeHuHDOZvf0dlRthxDVfpIp7porx
         9Oh6JPN2NaNu/OEODyhPLI4LKqRSZJFYdjw/IZguFSZWp9cS0nw47shAyRMxWuK+AVYg
         cZi8u2Ph7j+5TirJeugM+ptaDEP/+/2C7Bfx25435JbmdffMMpteEY+4C1wWeiGoAqxP
         Tqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaPNGdmtqURbhhCbze6HwYDLgUjVlHOsmkR9Dnj/4f0=;
        b=FRkt7MNZ/P5vcjGNSFCiZT41XeRi/QpYI4RljVNriqvEi4rJhliBR0yRl8y9Lonyxw
         iwjqrGJV5/p/tOM4YAry9RKXOsWY3MksVfp/oISHmM7e/6UbTZ9z22XLi7+p5Pg+ML6D
         qjduoXJYvS2BZzTKK389My4AKyNpnSw435VOQtnwBnjZjmr6zc3IWctxVg46O/R11TyJ
         mtwaM5KqVYnNVtp14cqymQQeWu5isRAhHAfUYA7DVBGGSptU+M9ZiSSNa6F6icTmaxLx
         46lparLrbQPV8XV3r8sdLtNkLJsVrlvEzVdFNm17orWN3eQ9k/xNKRYI6+TgQPF8Uxlj
         7zHQ==
X-Gm-Message-State: APjAAAVmdhEfIFX5uy95+jXV9afqY1LZxmF1pE+NlPgq7xUGRPcXzUHM
        zwwdvma4fZ/RxAWYHvRIgPPi1IhuAdI=
X-Google-Smtp-Source: APXvYqyPhF5iSgnjUzNMg5Hv9hLtjWIgaUIiRwBguCzgllTPVHJbJT4CBFGBw+jm8mjnTDZhprFjng==
X-Received: by 2002:a5d:614c:: with SMTP id y12mr2287255wrt.392.1570013811287;
        Wed, 02 Oct 2019 03:56:51 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id a192sm7291374wma.1.2019.10.02.03.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 03:56:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch iproute2-next v2 2/2] ip: allow to use alternative names as handle
Date:   Wed,  2 Oct 2019 12:56:45 +0200
Message-Id: <20191002105645.30756-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002105645.30756-1-jiri@resnulli.us>
References: <20191002105645.30756-1-jiri@resnulli.us>
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

