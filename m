Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6284DC307
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiCQJkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiCQJkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:40:39 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAD9186F9F;
        Thu, 17 Mar 2022 02:39:23 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w12so7998496lfr.9;
        Thu, 17 Mar 2022 02:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=uwQnx6pwvh3u1NvgP1tcS0s4NRQpVnBsyx6kEU6UEk4=;
        b=k2kH5SHw44LX+U1I8vgVRDFxYoHVjCkRGfxHD/XVhACKFuDfdlyhwS79VhJqBVe1Sv
         ZyLiPp7rGfQu5J9UThvg5umZaEIxmlRYvRHzJHdY4bKA64MnmTClSRh+/5l37fXS+hiE
         +aoPn89ubtg6jgj9L59kxamoAPiT3Qk812c68GxOzV1AP+EDdGcv/MAAxE1bJHDfA9/b
         Q3cFIeanOs7HQklTpyEjGuaq0K54NE9OphWdpuCWgxIHDHxHOxbFPJ40VkzCUCvluPJI
         lYU+T38iERECXUx/1dFg0vEu7Qkjali7PfdqYHFdu8lVGVRwHSSfP9hKMtShBwaEwiMf
         d+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=uwQnx6pwvh3u1NvgP1tcS0s4NRQpVnBsyx6kEU6UEk4=;
        b=7a9NqKHifCJzmQuYW3QcnQocbV+2/h/FH7kb7suMNjvC1aCnQ7ndkPqcqaFoVdWRFK
         IpZW3/Npdvuqdk1rc+agb+nKGCJdkfOWmXf/E12AU2+OhyUfR7ikm9BfaEPR98M7ICS9
         N8pEc+R8CTYZDGFyQVwmDdZbuRJyXVzWC6zbn3J91mJE6zvSvJv8z+q5iICyE3/D7cMT
         qnPMKbDWLea4uEL8c5UdWg/yC3bdqhK3Bycr7TkAL0LrXrRAmsKdVQ1XKvryhIVlHZBh
         LUJKuTxoIPdO5n5/pGcCPXynZo79ubSnGTGM6u+JITbB4sPcMxEzoBtXqYi2Q8gGuIFK
         twMA==
X-Gm-Message-State: AOAM533yN0NtIbUb7ZsjHG3N1EiTdlR+H6DKWOdQO+dyhvKFvADvtgDN
        KO8ybOzCVjLAkq4k1CplY6c=
X-Google-Smtp-Source: ABdhPJz2ESit2pwtBK0+dp42fWwk772KaV2IroyT2+W3Q+GDPLm+wy9O37fS8qnrLVrRU105KSbOYA==
X-Received: by 2002:a05:6512:32c2:b0:448:942a:3362 with SMTP id f2-20020a05651232c200b00448942a3362mr2368898lfg.356.1647509961939;
        Thu, 17 Mar 2022 02:39:21 -0700 (PDT)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id w13-20020a2e998d000000b002496199495csm113479lji.55.2022.03.17.02.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:39:21 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2 net-next 2/4] net: switchdev: add support for offloading of fdb locked flag
Date:   Thu, 17 Mar 2022 10:39:00 +0100
Message-Id: <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used for Mac-auth/MAB feature in the offloaded case.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 include/net/switchdev.h | 3 ++-
 net/bridge/br.c         | 3 ++-
 net/bridge/br_fdb.c     | 7 +++++--
 net/bridge/br_private.h | 2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 3e424d40fae3..d5d923411f5e 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -229,7 +229,8 @@ struct switchdev_notifier_fdb_info {
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
-	   offloaded:1;
+	   offloaded:1,
+	   locked:1;
 };
 
 struct switchdev_notifier_port_obj_info {
diff --git a/net/bridge/br.c b/net/bridge/br.c
index b1dea3febeea..adcdbecbc218 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid, false,
+						fdb_info->locked);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 57ec559a85a7..57aa1955d34d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -987,7 +987,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, true, false);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1216,7 +1216,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify)
+			      bool swdev_notify, bool locked)
 {
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
@@ -1236,6 +1236,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
+		if (locked)
+			flags |= BIT(BR_FDB_ENTRY_LOCKED);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f5a0b68c4857..3275e33b112f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -790,7 +790,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify);
+			      bool swdev_notify, bool locked);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
-- 
2.30.2

