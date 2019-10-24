Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5385CE2EB2
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409014AbfJXKVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:21:02 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:39902 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409006AbfJXKVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:21:01 -0400
Received: by mail-wr1-f47.google.com with SMTP id a11so9336525wra.6
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 03:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b53vszW+hcOog0BWAPQ7z6wQ0lNcheA4ajo1Hii0ddM=;
        b=p0ZUsJSE36MZzmr5UyXHFQxWn5G4i6ijYmC5ApStbPtR7CTzVB5ijT+Hjdf6n8eVy4
         aLa9YUQIHkmH9dlx4ZxZYdVISgV+tzpYNDWPsUjGaDIrPDSJ4LHBTsoMTLjKtPxDKdHd
         nTYNqJTR1gPMG1VzdYxl8CrZB4KAee2jTOZp4l0DlmYJquzIjJpbSSmL9w7epGHdsJrS
         2w9sbXOnbpLl1AGtS7Qeo1s8fEbLHJgB7ZvY4kjddO6DA95NvQh3bwq+QJzajNpR/d7/
         d2YZnz66bFwSs+tfAfjNRr7USoFuwxcpOO9xj+idWIPJreQNwyI6/C0oTdah/IuR+Cuq
         o5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b53vszW+hcOog0BWAPQ7z6wQ0lNcheA4ajo1Hii0ddM=;
        b=sVONDU+Ah+MiRGzzrrnq+fF6lc+TsFyEHi8MWrbacrwEbg5rk98H18QfjqwNu2m/Xe
         ScT4KKFt6vbmzfn77VFVt/cVhMkKV6u/Vb9GA1O91wg0xFhyNb9udlEPQ57o9amR0UPB
         +9YHyIfv3NUWiAAq+sV6ovENOmmLLFKinhiBvlMeEoEbSJXX7nCTiritXsniqkEIZ07t
         McVw99I8J7DbfbvEVeiutKP5gpijhvu5KLm8xZwgvnlEv37HZFyMEHUJBHY+g/COShoY
         TTPBUPsbQa+iI2U4Myea+jbHuwVneesieI+5P/F3Am497uZ4KLacA/bx9wlAuCanflDO
         k+4Q==
X-Gm-Message-State: APjAAAWSQM86cU8fqdiRvUEJOWoxpRZ4/4w5rx7Q72I4kxGpvb9duJ1w
        w67GRVap96JOn4nrF8KWiZh0wrki4EA=
X-Google-Smtp-Source: APXvYqwkFruz5bYz3e9I5FFFC/NVx9la18Di47bqk2AEsN5GlQHGUR3Jv4ssrKwt7kwr94pJz6R47w==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr3189531wru.184.1571912457331;
        Thu, 24 Oct 2019 03:20:57 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f17sm13209769wrs.66.2019.10.24.03.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 03:20:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v5 3/3] ip: allow to use alternative names as handle
Date:   Thu, 24 Oct 2019 12:20:52 +0200
Message-Id: <20191024102052.4118-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024102052.4118-1-jiri@resnulli.us>
References: <20191024102052.4118-1-jiri@resnulli.us>
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
index 9ec73d166790..70ea3d499c8f 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -72,7 +72,7 @@ static struct ll_cache *ll_get_by_name(const char *name)
 		struct ll_cache *im
 			= container_of(n, struct ll_cache, name_hash);
 
-		if (strncmp(im->name, name, IFNAMSIZ) == 0)
+		if (strcmp(im->name, name) == 0)
 			return im;
 	}
 
@@ -288,8 +288,9 @@ static int ll_link_get(const char *name, int index)
 
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

