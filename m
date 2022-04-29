Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164E95149DD
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359503AbiD2Mwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359484AbiD2Mwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:52:33 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A26CC9B7D;
        Fri, 29 Apr 2022 05:49:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i5so10632101wrc.13;
        Fri, 29 Apr 2022 05:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m2VDhVRQPjsV1IPycPT/Y4TlTx8jaZtNzcIfdQQLUOE=;
        b=ecACeX4mEA86JpS0EXqxZYgqpdd/LkB5YAIuA0ZlDvIGigqsSq6u1HE5Fkm2nj/4no
         XTvJc5g4hQCzMLN3bJsYak/3ygV7SkqvcmGozAMysaaQj34gblO9wOzUSGOqLyVMxCgq
         5U8GqBywfsp3IGvSDFHF/01j/6tEwuIdmQR/hx1zigTs9Xk9q8h7f1m8Ziq8Z+TYc0zP
         S0le5HBcSYQI/59t/usSCR632rbPOBsY3eu8+iu2xiVmpUE8dn/ZyGq6gbJIInUCVMG/
         gyhZJu9P1d9wi011YgbJEn3rUvLoIGwLNbdNeGgF1SgvtfrM1Vu6ZsHHnmqlIFstgVBn
         vBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m2VDhVRQPjsV1IPycPT/Y4TlTx8jaZtNzcIfdQQLUOE=;
        b=nsqcxkqFXC5YMKK15B/Ja+dqa7TqzuGiBCvVONuCsgdqV/rEO8kAcrrFyC5VmtjZPh
         wYrvbD81ToA8Ph2+J3dEBbv2Uyepd4DGSUg6ugB9FrVwceUP5M0M9eE64T0rnOBD9N+K
         tpDSsG5Ion5cw0zHfgPjHvGoVQfpTCjivB8E6VKfpIN1gxQ0glTFEyT72Mh2ARCkzXgM
         tEX1JpP1QTP23Ng7mja3PKq792wsVa44SMzwIbg0oOM5MnInn1x0viBZ4TA0UaOgj1f6
         zGmE8yIfZ9kVomzgDM8ZkPnZ/wzYqbBouR3utt90Qq4KNETPjmhOkh8xirhhMYSkb5Ka
         g/sQ==
X-Gm-Message-State: AOAM531683PryuqnFzRRJqE0FG++i7RUjlZd2TamKzmsCug6IEdd6sU9
        UJyZSuFCbEPW+E4yLw62Bm4=
X-Google-Smtp-Source: ABdhPJzV6OVD5id6uhYczjlC98kidiEApQj0yn/ZFy0FzVSsvGmB79Qh41p54L7i5YkxXtjSF9eTgQ==
X-Received: by 2002:a05:6000:1d81:b0:207:b7f8:24ee with SMTP id bk1-20020a0560001d8100b00207b7f824eemr30228367wrb.260.1651236553660;
        Fri, 29 Apr 2022 05:49:13 -0700 (PDT)
Received: from alaa-emad ([197.57.200.226])
        by smtp.gmail.com with ESMTPSA id e25-20020adfa459000000b0020c4ebaf526sm443463wra.78.2022.04.29.05.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:49:13 -0700 (PDT)
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
Subject: [PATCH net-next v5 2/2] net: vxlan: Add extack support to vxlan_fdb_delete
Date:   Fri, 29 Apr 2022 14:49:07 +0200
Message-Id: <7abd2d1abb8abd3080356b8e031b1b100b80f1ed.1651236082.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651236081.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1651236081.git.eng.alaamohamedsoliman.am@gmail.com>
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

This patch adds extack msg support to vxlan_fdb_delete and vxlan_fdb_parse.
extack is used to propagate meaningful error msgs to the user of vxlan
fdb netlink api

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
changes in V4:
        - fix errors reported by checkpatch.pl
        - edit commit message.
---
changes in V5:
	- edit commit message
---
 drivers/net/vxlan/vxlan_core.c | 38 ++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index ad0f2150cfdb..429ce2168971 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1129,19 +1129,25 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,

 static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
-			   __be32 *vni, u32 *ifindex, u32 *nhid)
+			   __be32 *vni, u32 *ifindex, u32 *nhid,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = dev_net(vxlan->dev);
 	int err;

 	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
-	    tb[NDA_PORT]))
-		return -EINVAL;
+	    tb[NDA_PORT])) {
+			NL_SET_ERR_MSG(extack,
+						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
+			return -EINVAL;
+		}

 	if (tb[NDA_DST]) {
 		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Unsupported address family");
 			return err;
+		}
 	} else {
 		union vxlan_addr *remote = &vxlan->default_dst.remote_ip;

@@ -1157,24 +1163,30 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	}

 	if (tb[NDA_PORT]) {
-		if (nla_len(tb[NDA_PORT]) != sizeof(__be16))
+		if (nla_len(tb[NDA_PORT]) != sizeof(__be16)) {
+			NL_SET_ERR_MSG(extack, "Invalid vxlan port");
 			return -EINVAL;
+		}
 		*port = nla_get_be16(tb[NDA_PORT]);
 	} else {
 		*port = vxlan->cfg.dst_port;
 	}

 	if (tb[NDA_VNI]) {
-		if (nla_len(tb[NDA_VNI]) != sizeof(u32))
+		if (nla_len(tb[NDA_VNI]) != sizeof(u32)) {
+			NL_SET_ERR_MSG(extack, "Invalid vni");
 			return -EINVAL;
+		}
 		*vni = cpu_to_be32(nla_get_u32(tb[NDA_VNI]));
 	} else {
 		*vni = vxlan->default_dst.remote_vni;
 	}

 	if (tb[NDA_SRC_VNI]) {
-		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32))
+		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32)) {
+			NL_SET_ERR_MSG(extack, "Invalid src vni");
 			return -EINVAL;
+		}
 		*src_vni = cpu_to_be32(nla_get_u32(tb[NDA_SRC_VNI]));
 	} else {
 		*src_vni = vxlan->default_dst.remote_vni;
@@ -1183,12 +1195,16 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	if (tb[NDA_IFINDEX]) {
 		struct net_device *tdev;

-		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32))
+		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32)) {
+			NL_SET_ERR_MSG(extack, "Invalid ifindex");
 			return -EINVAL;
+		}
 		*ifindex = nla_get_u32(tb[NDA_IFINDEX]);
 		tdev = __dev_get_by_index(net, *ifindex);
-		if (!tdev)
+		if (!tdev) {
+			NL_SET_ERR_MSG(extack, "Device not found");
 			return -EADDRNOTAVAIL;
+		}
 	} else {
 		*ifindex = 0;
 	}
@@ -1226,7 +1242,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		return -EINVAL;

 	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
-			      &nhid);
+			      &nhid, extack);
 	if (err)
 		return err;

@@ -1292,7 +1308,7 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	int err;

 	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
-			      &nhid);
+			      &nhid, extack);
 	if (err)
 		return err;

--
2.36.0

