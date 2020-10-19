Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60E292C7B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgJSRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729916AbgJSRRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 13:17:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B03C0613CE;
        Mon, 19 Oct 2020 10:17:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so299324pfp.13;
        Mon, 19 Oct 2020 10:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVXu+0Ku8pFxkjaLJbcVBjbu1+5Ssr4Lq2DXPPsKrG0=;
        b=GoJpQwp+MzHtT2MHfa5uAVuEkXzu7EfwhJbD9UXGqw4Q8jnCvU1oFKfAsMgJG9rOyo
         N4vLWDPbXBPXZNhRbDrmf7dxYdrryTSkpgEnIvtRyhAuqNErangPXCfmYjRe6L0QuGLw
         A+RqHtJMlAGlzUejS7fTzj0stZ8ZFd4Pc6qR3FVEIeOp1JYn7i01IhtwWYaABcBFYMGw
         Mx2jn5XiSHsQe4vlroNlamTF/gSpO2MhTzr3kI6OFQf373OKFqbGQGQy6NE2GkBG2LOP
         oFGhbEpVNGL0XlRl7T2Z5sn/IWERccsgjFODk5OlgsYlGTB5Bj5nKPVKINW4h9TUgV0O
         r92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVXu+0Ku8pFxkjaLJbcVBjbu1+5Ssr4Lq2DXPPsKrG0=;
        b=hjE5f12tV0oC43On3Bxai95xIcnIQx9qT2RXy6RAQzKGYSx/vwtPZ+13JiuDFsUWgx
         Mt/jMj2dqSGTeGkRwfEtHkY7bsqMQCOP3oVex+/pQgzerThYKGDigoGoVoRh/0Rwz+v2
         WBFIi3+b8QJXt/sU2XzRFGic6Dcmi2Z8lLnONAX0it66pExsCrpKxJs34QRtOXFVYHe9
         D/S5LuPhQ4+HrUozU5wDNzKdOl21Fu96u3Z1al6p37W7HwH6czYwFN028kBFtAwaEAOT
         202TMIo40HM1dCF3VcZyJwFHexdGTBRnv5TDLr/4/RYRTov0N7jHikdE+1bJ9UI3BImJ
         oNkw==
X-Gm-Message-State: AOAM530nPGmf0pfYWXljyr0u5lZqCjgKPDUx9LQYNQzDEKf1GCeJAsCt
        RkD8Ubz4BoyCA7nok1Wce6Hg0wGpLAU=
X-Google-Smtp-Source: ABdhPJz+VHySnwFA/jCNjbdhhJ36otWFUapb2xj2oqhToviJ8N50CoCLVyjyfiRx+iPljgzG+RkLUA==
X-Received: by 2002:a05:6a00:8c5:b029:142:2501:39e6 with SMTP id s5-20020a056a0008c5b0290142250139e6mr567237pfu.53.1603127871930;
        Mon, 19 Oct 2020 10:17:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c12sm118536pjq.50.2020.10.19.10.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 10:17:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: Have netpoll bring-up DSA management interface
Date:   Mon, 19 Oct 2020 10:17:44 -0700
Message-Id: <20201019171746.991720-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA network devices rely on having their DSA management interface up and
running otherwise their ndo_open() will return -ENETDOWN. Without doing
this it would not be possible to use DSA devices as netconsole when
configured on the command line. These devices also do not utilize the
upper/lower linking so the check about the netpoll device having upper
is not going to be a problem.

The solution adopted here is identical to the one done for
net/ipv4/ipconfig.c with 728c02089a0e ("net: ipv4: handle DSA enabled
master network devices"), with the network namespace scope being
restricted to that of the process configuring netpoll.

Fixes: 04ff53f96a93 ("net: dsa: Add netconsole support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/core/netpoll.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index c310c7c1cef7..960948290001 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/if_vlan.h>
+#include <net/dsa.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/addrconf.h>
@@ -657,15 +658,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 
 int netpoll_setup(struct netpoll *np)
 {
-	struct net_device *ndev = NULL;
+	struct net_device *ndev = NULL, *dev = NULL;
+	struct net *net = current->nsproxy->net_ns;
 	struct in_device *in_dev;
 	int err;
 
 	rtnl_lock();
-	if (np->dev_name[0]) {
-		struct net *net = current->nsproxy->net_ns;
+	if (np->dev_name[0])
 		ndev = __dev_get_by_name(net, np->dev_name);
-	}
+
 	if (!ndev) {
 		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
 		err = -ENODEV;
@@ -673,6 +674,19 @@ int netpoll_setup(struct netpoll *np)
 	}
 	dev_hold(ndev);
 
+	/* bring up DSA management network devices up first */
+	for_each_netdev(net, dev) {
+		if (!netdev_uses_dsa(dev))
+			continue;
+
+		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
+		if (err < 0) {
+			np_err(np, "%s failed to open %s\n",
+			       np->dev_name, dev->name);
+			goto put;
+		}
+	}
+
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
-- 
2.25.1

