Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F8D50D19F
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 14:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiDXMNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 08:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiDXMNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 08:13:09 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83036221;
        Sun, 24 Apr 2022 05:10:06 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j15so3925234wrb.2;
        Sun, 24 Apr 2022 05:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kMsrPopqXyKvjj6ADtV/e3/sJqjPNnfQay4OisloMYc=;
        b=G1NNAqa9Af1R4e+iYq/k9TLDn34NKa+zwVDQ56afqH335EQ42AUrhuX2rB+ybjDpDq
         /kZYqx7nmUAi0wrUmhwa5TBh5Yqqicn5BVBrolEzH5UsO4R9s/mlbXwvf2YrNebaU6V7
         QrzVt/ZDKDEnYpQ5Mo8HhonNLASsrCKROmZ41PoiVdYtcQojB/K4pdoI98hge2gAGwHd
         nSt77fn9VjDjDmkddV360nPYZxLIzX2Tg84JP3aEclHl73m/8Ei1XWUa9iKGsvVCcTkH
         LXZT25JCGUlbOfPAtHyEgrGyV1zrhhEUVXbqS7iWfrNrvvz/eBeAg6UV/ai7yXj7dwtD
         CbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kMsrPopqXyKvjj6ADtV/e3/sJqjPNnfQay4OisloMYc=;
        b=0Elo5JvIsZitAhgXphj+KU3b0Kv9ojtNwDD82fypOsEZMkDlOFwep9Oly3ho4GvmLi
         OV5O8SBMC+dLhmF8Z623EzYDzIgiyv5CNYNQYOY93HpsJLah73Yr+HOBoOx6rPLqcv4k
         5XHrqJ7XwS7xQ7jMMoNv9pUNtdk6a6cW2UF3wY1k5v34YiFSwd5vbDOVdmKDEwGUN4NO
         DkxXdfCsJHHdjmh6CjZkVJlJaGzD1x7tQxdN95CcN9QvvXwnnwOAXhuAFY2alO+V4ZlU
         FmFtMSEXcDOBqsK4r0U4fYbEI7KQANodYuVQnQkD27iKVOFwi2FD+8rV39deOxrYeIDT
         NEQw==
X-Gm-Message-State: AOAM531JqIA/349r9zSRNVD4Am7wm/5ucHIgbyap7MyfGva8faQjKmJW
        Whv/j+ITVBK3jNeRaRTdTqQ=
X-Google-Smtp-Source: ABdhPJzN0XK82EJGnpmBD6Aw/R5DjFt3ttHuCFQExkPKkZ+QNRqdno2HCbWpBsbHz04CrC6TCgyxAA==
X-Received: by 2002:a05:6000:156c:b0:20a:8397:6d28 with SMTP id 12-20020a056000156c00b0020a83976d28mr10215309wrz.363.1650802205019;
        Sun, 24 Apr 2022 05:10:05 -0700 (PDT)
Received: from alaa-emad ([197.57.78.84])
        by smtp.gmail.com with ESMTPSA id q3-20020adfab03000000b0020ad57b8ddesm3091466wrc.101.2022.04.24.05.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 05:10:04 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, jdenham@redhat.com,
        sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v3 2/2] net: vxlan: vxlan_core.c: Add extack support to vxlan_fdb_delete
Date:   Sun, 24 Apr 2022 14:09:45 +0200
Message-Id: <0d09ad611bb78b9113491007955f2211f3a06e82.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
changes in V3:
	fix errors reported by checkpatch.pl
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

