Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C5A50CDFA
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 00:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbiDWW5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 18:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiDWW5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 18:57:15 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFDA25C46
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:54:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u3so15865906wrg.3
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qmAftXD5qiPCz2kwkoPCIF9k7WA+lUT3ZHfv9wYs3R0=;
        b=MWPeOq98JiAX88EYrT+oVDxljDZe8xB+EYBrElDFhr7P96BaHasb78wEpQkXIK7pxa
         JguM0Y7qxl9x80srklsr0mJZ5mc658YK3EDVVoFx9kDbJWxWlSg+qMEV+f3NZzAW7wyJ
         byIwmfShQzt3wjsSIyYv46unwG1FupDX6OE8JDLZaWwFnBF7buuNklwYZwnY3bH+bCTs
         jaN2JI5yuUmnt6DbOwu4TGUuzpcdTdziIq+GuZYJRFcAmP75LgDrcQdGOEJr5Ymkkc/v
         3VBK+CKtHPn9wKXqZacZ1pSqNHCMwHhKJhtsPar5iblx2iF01AVWKEMtNpfdBKpuYYcD
         51Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmAftXD5qiPCz2kwkoPCIF9k7WA+lUT3ZHfv9wYs3R0=;
        b=0Ux161aPTGMnH261L1G3jjaVe+3TYbQZi9Ru0dHAnVgngSNMgV4ijfpIh40p/G/9NY
         60LDnocwxiGWzwovd9gQEgZGSPzMPy57YCDETvoUP3TIA/46BdBi4iVSZ4SG2JEzTiN2
         h3HdSmKKzDWHvBBIVZky/fIVJrIYCB7wso4h9L/E9denYI3aITuyUwdLzAyrl2B9ZD7z
         j3qll78R7p8v+0vRPwnNvNDWQAjRHt4akMecw+ZBwtEmYfQ++ISqJR0f7AIAf23d0sBT
         /pVx6RX4F6VYZBK07Tl3XdWqdLZ1hNI0q9PGchbBs/DdingZDPpwiBa2dVqCuB2K+WOZ
         3zgw==
X-Gm-Message-State: AOAM533yU0qouXkN5BRRf612S7reMUxAsJRhRPySJovAeB/J70a7xcWU
        vTQ25N5q5WJ69f/czcA8IpI=
X-Google-Smtp-Source: ABdhPJxaIFDZAlMUw0q+v45kl7F0Oxy91VZKEdf6PaaE9vQG6kFZpltXrXj7XodpBubi5uQqxmDYSw==
X-Received: by 2002:a5d:64e4:0:b0:20a:91e4:c0f9 with SMTP id g4-20020a5d64e4000000b0020a91e4c0f9mr8276558wri.55.1650754455099;
        Sat, 23 Apr 2022 15:54:15 -0700 (PDT)
Received: from alaa-emad ([197.57.78.84])
        by smtp.gmail.com with ESMTPSA id c9-20020a5d4149000000b00207adbc4982sm4983877wrq.94.2022.04.23.15.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 15:54:14 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2 2/2] net: vxlan: vxlan_core.c: Add extack support to vxlan_fdb_delete
Date:   Sun, 24 Apr 2022 00:54:08 +0200
Message-Id: <22f5fb1d5e592c0deefb246225f66908947a613b.1650754231.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extack to vxlan_fdb_delete and vxlan_fdb_parse

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in V2:
	- fix spelling vxlan_fdb_delete
	- add missing braces
	- edit error message
---
 drivers/net/vxlan/vxlan_core.c | 36 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index cf2f60037340..4e1886655101 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1129,19 +1129,23 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 
 static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
-			   __be32 *vni, u32 *ifindex, u32 *nhid)
+			   __be32 *vni, u32 *ifindex, u32 *nhid, struct netlink_ext_ack *extack)
 {
 	struct net *net = dev_net(vxlan->dev);
 	int err;
 
 	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
-	    tb[NDA_PORT]))
-		return -EINVAL;
+	    tb[NDA_PORT])){
+			NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
+			return -EINVAL;
+		}
 
 	if (tb[NDA_DST]) {
 		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
-		if (err)
+		if (err){
+			NL_SET_ERR_MSG(extack, "Unsupported address family");
 			return err;
+		}
 	} else {
 		union vxlan_addr *remote = &vxlan->default_dst.remote_ip;
 
@@ -1157,24 +1161,30 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	}
 
 	if (tb[NDA_PORT]) {
-		if (nla_len(tb[NDA_PORT]) != sizeof(__be16))
+		if (nla_len(tb[NDA_PORT]) != sizeof(__be16)){
+			NL_SET_ERR_MSG(extack, "Invalid vxlan port");
 			return -EINVAL;
+		}
 		*port = nla_get_be16(tb[NDA_PORT]);
 	} else {
 		*port = vxlan->cfg.dst_port;
 	}
 
 	if (tb[NDA_VNI]) {
-		if (nla_len(tb[NDA_VNI]) != sizeof(u32))
+		if (nla_len(tb[NDA_VNI]) != sizeof(u32)){
+			NL_SET_ERR_MSG(extack, "Invalid vni");
 			return -EINVAL;
+		}	
 		*vni = cpu_to_be32(nla_get_u32(tb[NDA_VNI]));
 	} else {
 		*vni = vxlan->default_dst.remote_vni;
 	}
 
 	if (tb[NDA_SRC_VNI]) {
-		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32))
+		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32)){
+			NL_SET_ERR_MSG(extack, "Invalid src vni");
 			return -EINVAL;
+		}
 		*src_vni = cpu_to_be32(nla_get_u32(tb[NDA_SRC_VNI]));
 	} else {
 		*src_vni = vxlan->default_dst.remote_vni;
@@ -1183,12 +1193,16 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	if (tb[NDA_IFINDEX]) {
 		struct net_device *tdev;
 
-		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32))
+		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32)){
+			NL_SET_ERR_MSG(extack, "Invalid ifindex");
 			return -EINVAL;
+		}
 		*ifindex = nla_get_u32(tb[NDA_IFINDEX]);
 		tdev = __dev_get_by_index(net, *ifindex);
-		if (!tdev)
+		if (!tdev){
+			NL_SET_ERR_MSG(extack,"Device not found");
 			return -EADDRNOTAVAIL;
+		}
 	} else {
 		*ifindex = 0;
 	}
@@ -1226,7 +1240,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		return -EINVAL;
 
 	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
-			      &nhid);
+			      &nhid, extack);
 	if (err)
 		return err;
 
@@ -1291,7 +1305,7 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	int err;
 
 	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
-			      &nhid);
+			      &nhid, extack);
 	if (err)
 		return err;
 
-- 
2.36.0

