Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1079233E74
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgGaEpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgGaEpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:45:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB2C061574;
        Thu, 30 Jul 2020 21:45:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k1so6196654pjt.5;
        Thu, 30 Jul 2020 21:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WD31emG5AAw62cTFIzmY9OBwp6Qx1m67HwbYW6jOzgE=;
        b=Fwn4fVpIuOoiY6zQvbpgMCZzaLl4zm5qe1vcnKdKkipMxP8rnrEnNmarXXW2F4251W
         OuOcoCTWnnG7RJOBGbpCpl7VFICmd6rktak1eV2hL+YKaPj74PK2wemOGPCAIpWTAlsD
         s9pCQcj2W5ErTSrqlp6pkn2Tzj8EbAA5QIxVNYiew5xpGC2iH87AsfRkSRYAkKoz74cz
         JfZOIXzscNbFvLquroOiEG8zS9VfZiMt3bywjxx9RcoHr1rwb1k7fw9KDT7x1iR39X7j
         AFejoRKZvZy90KeIVo/YIjcWN1qGox6/8MUj6yxY+4Lc03xXyALCyh763BLEt+XKYnEO
         IQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WD31emG5AAw62cTFIzmY9OBwp6Qx1m67HwbYW6jOzgE=;
        b=R7/JD3yVo0JFSzvEOOAHVuRTpMHoc9wyhxZmsZSRcQ7v9QxYkU+owaW1H3p9JLIRny
         MewrqOE2y/H9PTWuUweCLT1xE0yGN2qRyIvUIy0N4ETcC4CCsW01t1ECYAAz88lb5pmz
         ZqUpBzPeN3BQu1et+4PVdq/E/fRZ1wXSwowgWgIMPl1i3tyWo5NfNfBW2VuFEDNpEQGb
         0I+XB4DVeUOH5tGwE9kwOWZtCiME8w8kEEHYVRHQlhx46tfT7b9+heNGUPLS8bkA5R86
         k8hwJFTatOHL7dpFYYDZ48j8gypKqR3yxvMidz/pHiCa6N8HtRwQltw13RRhpH27KddL
         cV6w==
X-Gm-Message-State: AOAM530gTWk2dHrRIqyqA4dJjEzqa5GNd4BGk9jKOyHAfnBOvpr8nWQ3
        DXd5GJXOnFKurMJaWeu4fVQ=
X-Google-Smtp-Source: ABdhPJxfqbrlJkN0gPj7CdOreSoE9noW2lX2r4E2qd+4uyCDucE/2gd/JByR4Zr9P6JaNWPSgIdLtQ==
X-Received: by 2002:a63:135b:: with SMTP id 27mr2084276pgt.37.1596170700904;
        Thu, 30 Jul 2020 21:45:00 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id x6sm2329573pfd.53.2020.07.30.21.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 21:45:00 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next 1/3] net/bridge: Add new function to access FDB from XDP programs
Date:   Fri, 31 Jul 2020 13:44:18 +0900
Message-Id: <1596170660-5582-2-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a function to find the destination port from the
FDB in the kernel tables, which mainly helps XDP programs to access
FDB in the kernel via bpf helper. Note that, unlike the existing
br_fdb_find_port(), this function takes an ingress device as an
argument.

The br_fdb_find_port() also enables us to access FDB in the kernel,
and rcu_read_lock()/rcu_read_unlock() must be called in the function.
But, these are unnecessary in that cases because XDP programs have
to call APIs with rcu_read_lock()/rcu_read_unlock(). Thus, proposed
function could be used without these locks in the function.

Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 include/linux/if_bridge.h | 11 +++++++++++
 net/bridge/br_fdb.c       | 25 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 6479a38e52fa..24d72d115d0b 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -127,6 +127,9 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    const unsigned char *addr,
 				    __u16 vid);
+struct net_device *br_fdb_find_port_xdp(const struct net_device *dev,
+				    const unsigned char *addr,
+				    __u16 vid);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 #else
@@ -138,6 +141,14 @@ br_fdb_find_port(const struct net_device *br_dev,
 	return NULL;
 }
 
+static inline struct net_device *
+br_fdb_find_port_xdp(const struct net_device *dev,
+				    const unsigned char *addr,
+				    __u16 vid);
+{
+	return NULL;
+}
+
 static inline void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 {
 }
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9db504baa094..79bc3c2da668 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -141,6 +141,31 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 }
 EXPORT_SYMBOL_GPL(br_fdb_find_port);
 
+struct net_device *br_fdb_find_port_xdp(const struct net_device *dev,
+				    const unsigned char *addr,
+				    __u16 vid)
+{
+	struct net_bridge_fdb_entry *f;
+	struct net_device *dst = NULL;
+	struct net_bridge *br = NULL;
+	struct net_bridge_port *p;
+
+	p = br_port_get_check_rcu(dev);
+	if (!p)
+		return NULL;
+
+	br = p->br;
+	if (!br)
+		return NULL;
+
+	f = br_fdb_find_rcu(br, addr, vid);
+	if (f && f->dst)
+		dst = f->dst->dev;
+
+	return dst;
+}
+EXPORT_SYMBOL_GPL(br_fdb_find_port_xdp);
+
 struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
 					     const unsigned char *addr,
 					     __u16 vid)
-- 
2.20.1 (Apple Git-117)

