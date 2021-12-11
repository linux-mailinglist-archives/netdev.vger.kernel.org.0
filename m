Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE4C47105B
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345766AbhLKCGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbhLKCGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:08 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCEDC061714;
        Fri, 10 Dec 2021 18:02:23 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so36045034edv.1;
        Fri, 10 Dec 2021 18:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MsFfAGLof3Dm9/LrR3eo50ukODDBjEJuAPZhIodAjb8=;
        b=H7Ipv3u+6+S3eEvDoI6LyEtyl9WL3LaAV9Y5t5ns7VvFske1+/sSP8h1Xq0pFxCvJs
         LtnhD4gaUrq+43Cf0WUTiQJbmvq+nfA0pGQtIeejOSNPTwjHMRGwGmQRyyU+9dgMX648
         Hbn0MYrVo++b28V7bi3OFVqs7u6FUFf4pvueWAn8kJSqUKqRMzdqdtceIkCnlXzEWo6F
         +oemCssXGoushIjaMa4++GkQhAxbsLw/RxR/ba/4SdJ5ZHYwk8piYswWzrI18kf1Qyr1
         tENmIqS3uxPdBRg0we9Q7WR2eDyhDxtFzXPHaMiefUNzPLNMLNx2FCPwDn3VOW/ysDy5
         r77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MsFfAGLof3Dm9/LrR3eo50ukODDBjEJuAPZhIodAjb8=;
        b=PSjGXY6rqVzTxrRmry1H6cvUGJrjgWPUqNW3/SA4t8dg7zU9E4uo5yVzgi7NCQBYbX
         zuJ2ZTJrhN1CL+b+g3+OCiWAmJM6FZKsI+RkiBsaqE/Gvaz5EYWHXONe/MkFkPuTQR6o
         bQTwxLTqncrkTTMY4fv0I7JoFdAlUxp/3X5OEN+HNKSn2ToJA2AWONtOOQFKRs9WCBUP
         yEpNAVYgwGV61x0TJRYJNLvEbQ1Kzi5tFXAuiGiB18MM2vw11mcTH+fq3jqJtU8govAL
         2fNBicvDGTWsS/hyrdfmxl6LLgSBNkjUmRw+3paw4MPqFfWUT+9/TVH9FlZKNgtRg5Sh
         rSKg==
X-Gm-Message-State: AOAM5324C19bRjtJK7mlLLiDLHstZxa59CidwIW87x5Wl71KlbcHjB5E
        6q3cem9gB1cA5wa5h6jM+i0f+w2EKZRIRA==
X-Google-Smtp-Source: ABdhPJx/2z0MX3VHpvYqYPXQQ1Igm3zjDVnnLvgGVBK/jENd6zK9sjWHU+U5qbXPEJhweaqgZUtTmA==
X-Received: by 2002:aa7:d4c3:: with SMTP id t3mr44776130edr.268.1639188141321;
        Fri, 10 Dec 2021 18:02:21 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:21 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 04/15] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Sat, 11 Dec 2021 03:01:36 +0100
Message-Id: <20211211020155.10114-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In order for switch driver to be able to make simple and reliable use of
the master tracking operations, they must also be notified of the
initial state of the DSA master, not just of the changes. This is
because they might enable certain features only during the time when
they know that the DSA master is up and running.

Therefore, this change explicitly checks the state of the DSA master
under the same rtnl_mutex as we were holding during the
dsa_master_setup() and dsa_master_teardown() call. The idea being that
if the DSA master became operational in between the moment in which it
became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
when we checked for the master being up, there is a chance that we
would emit a ->master_state_change() call with no actual state change.
We need to avoid that by serializing the concurrent netdevice event with
us. If the netdevice event started before, we force it to finish before
we begin, because we take rtnl_lock before making netdev_uses_dsa()
return true. So we also handle that early event and do nothing on it.
Similarly, if the dev_open() attempt is concurrent with us, it will
attempt to take the rtnl_mutex, but we're holding it. We'll see that
the master flag IFF_UP isn't set, then when we release the rtnl_mutex
we'll process the NETDEV_UP notifier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/dsa2.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 90e29dd42d3d..76cf9ee1153c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1034,9 +1034,18 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
-			err = dsa_master_setup(dp->master, dp);
+			struct net_device *master = dp->master;
+			bool admin_up = (master->flags & IFF_UP) &&
+					!qdisc_tx_is_noop(master);
+
+			err = dsa_master_setup(master, dp);
 			if (err)
 				return err;
+
+			/* Replay master state event */
+			dsa_tree_master_admin_state_change(dst, master, admin_up);
+			dsa_tree_master_oper_state_change(dst, master,
+							  netif_oper_up(master));
 		}
 	}
 
@@ -1051,9 +1060,19 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_cpu(dp))
-			dsa_master_teardown(dp->master);
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_cpu(dp)) {
+			struct net_device *master = dp->master;
+
+			/* Synthesizing an "admin down" state is sufficient for
+			 * the switches to get a notification if the master is
+			 * currently up and running.
+			 */
+			dsa_tree_master_admin_state_change(dst, master, false);
+
+			dsa_master_teardown(master);
+		}
+	}
 
 	rtnl_unlock();
 }
-- 
2.32.0

