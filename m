Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A7B360085
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 05:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhDODfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 23:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhDODfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 23:35:00 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1F6C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 20:34:38 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id b139so18490010qkc.10
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 20:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0gr9xoLhNOvNDy6SbuGKMIg7J3bMcVhUGfITNxZn5gE=;
        b=lqeM7+mqUZJ4iJbH0AohYBqE3msXNTZY5AuqyXLt3EoyFFkSWLtzCvYuTDr1XIq5PU
         jmtRl1tkJRZE1rfbQitN2Y8fobH612+kO9N74Gp2Oubp35vdE/8yDgtMOckMOdNPhIJs
         cUkWPe/LGIS/FOf2nrI2gHJZK4tO5MBolRpgQIUB2y5t1w7vDxM/VLXr0JsWYVyQ+wTD
         Kd1fSK3g+wGTka5o2A3EEDaVhVn4JnogHsTHgjP5zBdRt2N2UGV0lTZlCj3HPo7WkXnT
         j85WE+qc9xGg43Ao6OjxcSlF5hd40O+rIQZSIW6bmxNaB2Rh0V/emwdicHi3cTIdqCkw
         Y3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0gr9xoLhNOvNDy6SbuGKMIg7J3bMcVhUGfITNxZn5gE=;
        b=BcIbSGC25Y5u0hHsuGazMFZnzLGf7XWnEXI2PMWTHtUn/v137Oag23PyaGUWamBlJP
         8YZdtTCK3A2M62fm0N8/pLmlFCdW4SZhRh3o5VQ27/JFlDyfeNeK6oF7Owoa9VA0FJsj
         j8KMXimP2TlOGXk9h1haDegpPK2EVoOto8xTvT9oWTSiV6NyMXKOAEZJP37aqyTD/OMF
         PNIF2AoVRuZq1ydkocFROw9+FbpEGptSVtzVhIfsIUnqeISeb/efQNdM0cM5zVb2YYt6
         hSh78ilOEZb8ZQDAv7RveochEvI3e+X9Z2JT8/lYZjP4CzgHTFjfkZOJB1O2qwSxhBH9
         Fg1A==
X-Gm-Message-State: AOAM5319/szQ4Hcq5mNRPG42W+LzsU5uEMHocf3V7jbRxoUUp7xrSJ7P
        NFMDzJvnnnZq4f4Brpla7WV4mjdUDf4K4g==
X-Google-Smtp-Source: ABdhPJyn5HCvt1TPpHddafmQ+MD6WIBT1/+ozHFtiUCKc9fUQ6aE7RcIJz5JkVwDImA/Qz2dv+nThw==
X-Received: by 2002:a05:620a:22a2:: with SMTP id p2mr1675109qkh.314.1618457677466;
        Wed, 14 Apr 2021 20:34:37 -0700 (PDT)
Received: from jrr-vaio.internal.cc-sw.com (2603-6010-7221-eda3-0000-0000-0000-1d7d.res6.spectrum.com. [2603:6010:7221:eda3::1d7d])
        by smtp.gmail.com with ESMTPSA id 81sm1080029qkl.121.2021.04.14.20.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 20:34:36 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH RESEND net-next] net: Make tcp_allowed_congestion_control readonly in non-init netns
Date:   Wed, 14 Apr 2021 23:33:41 -0400
Message-Id: <20210415033341.1147-1-jonathon.reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
References: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tcp_allowed_congestion_control is global and writable;
writing to it in any net namespace will leak into all other net
namespaces.

tcp_available_congestion_control and tcp_allowed_congestion_control are
the only sysctls in ipv4_net_table (the per-netns sysctl table) with a
NULL data pointer; their handlers (proc_tcp_available_congestion_control
and proc_allowed_congestion_control) have no other way of referencing a
struct net. Thus, they operate globally.

Because ipv4_net_table does not use designated initializers, there is no
easy way to fix up this one "bad" table entry. However, the data pointer
updating logic shouldn't be applied to NULL pointers anyway, so we
instead force these entries to be read-only.

These sysctls used to exist in ipv4_table (init-net only), but they were
moved to the per-net ipv4_net_table, presumably without realizing that
tcp_allowed_congestion_control was writable and thus introduced a leak.

Because the intent of that commit was only to know (i.e. read) "which
congestion algorithms are available or allowed", this read-only solution
should be sufficient.

The logic added in recent commit
31c4d2f160eb: ("net: Ensure net namespace isolation of sysctls")
does not and cannot check for NULL data pointers, because
other table entries (e.g. /proc/sys/net/netfilter/nf_log/) have
.data=NULL but use other methods (.extra2) to access the struct net.

Fixes: 9cb8e048e5d9 ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")
Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a09e466ce11d..a62934b9f15a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1383,9 +1383,19 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		/* Update the variables to point into the current struct net */
-		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++)
-			table[i].data += (void *)net - (void *)&init_net;
+		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
+			if (table[i].data) {
+				/* Update the variables to point into
+				 * the current struct net
+				 */
+				table[i].data += (void *)net - (void *)&init_net;
+			} else {
+				/* Entries without data pointer are global;
+				 * Make them read-only in non-init_net ns
+				 */
+				table[i].mode &= ~0222;
+			}
+		}
 	}
 
 	net->ipv4.ipv4_hdr = register_net_sysctl(net, "net/ipv4", table);
-- 
2.20.1

