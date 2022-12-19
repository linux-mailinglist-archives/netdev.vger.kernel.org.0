Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D66650EED
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiLSPnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiLSPmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:42:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DDC120BC;
        Mon, 19 Dec 2022 07:42:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9560EB80EA3;
        Mon, 19 Dec 2022 15:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59EDC43398;
        Mon, 19 Dec 2022 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671464563;
        bh=uzUgGEhWKxfTXIAicGnMskAOI5jXVPYSOrd9yyXt3LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW7jKiqJrZsTqb50XmGmAj4/Q7hZKNtmhdVMeHek65EccBzLp6s019XAF3Bc8XbB8
         3yTPd0SrsrvaNbdctyz633/Iw926tvZXITTl1+Zzh4/STfasaUDgWkPOkLO/zsls7c
         hXv4A2xUOlKzSIJ4VgJFDQCNeAoU7endWt2mjKbZ9uISXFBLOkIM8n1ITklLW1wPTs
         G2py07m81MonY9VVVRbRjyvz+hTaDUxNIlB1DzZL+CKxS4owra3XCvdJWbmGfXujaK
         iBQrliNzJ0TnK0a589D1mt5XP+fl+1kuZy+Mfahov5fSW06WmM5Y+g+MoX71iGB7Qs
         n+eZbRgVhjYww==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: [RFC bpf-next 6/8] libbpf: add API to get XDP/XSK supported features
Date:   Mon, 19 Dec 2022 16:41:35 +0100
Message-Id: <6cce9b15a57345402bb94366434a5ac5609583b8.1671462951.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1671462950.git.lorenzo@kernel.org>
References: <cover.1671462950.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Add functions to get XDP/XSK supported function of netdev over route
netlink interface. These functions provide functionalities that are
going to be used in upcoming change.

The newly added bpf_xdp_query_features takes a fflags_cnt parameter,
which denotes the number of elements in the output fflags array. This
must be at least 1 and maybe greater than XDP_FEATURES_WORDS. The
function only writes to words which is min of fflags_cnt and
XDP_FEATURES_WORDS.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.h   |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 tools/lib/bpf/netlink.c  | 62 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index eee883f007f9..9d102eb5007e 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -967,6 +967,7 @@ LIBBPF_API int bpf_xdp_detach(int ifindex, __u32 flags,
 			      const struct bpf_xdp_attach_opts *opts);
 LIBBPF_API int bpf_xdp_query(int ifindex, int flags, struct bpf_xdp_query_opts *opts);
 LIBBPF_API int bpf_xdp_query_id(int ifindex, int flags, __u32 *prog_id);
+LIBBPF_API int bpf_xdp_query_features(int ifindex, __u32 *fflags, __u32 *fflags_cnt);
 
 /* TC related API */
 enum bpf_tc_attach_point {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 71bf5691a689..9c2abb58fa4b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -362,6 +362,7 @@ LIBBPF_1.0.0 {
 		bpf_program__set_autoattach;
 		btf__add_enum64;
 		btf__add_enum64_value;
+		bpf_xdp_query_features;
 		libbpf_bpf_attach_type_str;
 		libbpf_bpf_link_type_str;
 		libbpf_bpf_map_type_str;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 35104580870c..6fd424cde58b 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -9,6 +9,7 @@
 #include <linux/if_ether.h>
 #include <linux/pkt_cls.h>
 #include <linux/rtnetlink.h>
+#include <linux/xdp_features.h>
 #include <sys/socket.h>
 #include <errno.h>
 #include <time.h>
@@ -41,6 +42,12 @@ struct xdp_id_md {
 	struct xdp_link_info info;
 };
 
+struct xdp_features_md {
+	int ifindex;
+	__u32 *flags;
+	__u32 *flags_cnt;
+};
+
 static int libbpf_netlink_open(__u32 *nl_pid)
 {
 	struct sockaddr_nl sa;
@@ -357,6 +364,39 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	return 0;
 }
 
+static int bpf_get_xdp_features(void *cookie, void *msg, struct nlattr **tb)
+{
+	struct nlattr *xdp_tb[IFLA_XDP_FEATURES_BITS_WORD + 1];
+	struct xdp_features_md *md = cookie;
+	struct ifinfomsg *ifinfo = msg;
+	int ret, i, words;
+
+	if (md->ifindex && md->ifindex != ifinfo->ifi_index)
+		return 0;
+
+	if (!tb[IFLA_XDP_FEATURES])
+		return 0;
+
+	words = min(XDP_FEATURES_WORDS, *md->flags_cnt);
+	for (i = 0; i < words; ++i)
+		md->flags[i] = 0;
+
+	ret = libbpf_nla_parse_nested(xdp_tb, XDP_FEATURES_WORDS,
+				      tb[IFLA_XDP_FEATURES], NULL);
+	if (ret)
+		return ret;
+
+	*md->flags_cnt = words;
+	for (i = 0; i < words; ++i) {
+		if (!xdp_tb[IFLA_XDP_FEATURES_BITS_WORD])
+			continue;
+
+		md->flags[i] = libbpf_nla_getattr_u32(xdp_tb[IFLA_XDP_FEATURES_BITS_WORD]);
+	}
+
+	return 0;
+}
+
 int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
 {
 	struct libbpf_nla_req req = {
@@ -421,6 +461,28 @@ int bpf_xdp_query_id(int ifindex, int flags, __u32 *prog_id)
 	return 0;
 }
 
+int bpf_xdp_query_features(int ifindex, __u32 *xdp_fflags, __u32 *fflags_cnt)
+{
+	struct libbpf_nla_req req = {
+		.nh.nlmsg_len		= NLMSG_LENGTH(sizeof(struct ifinfomsg)),
+		.nh.nlmsg_type		= RTM_GETLINK,
+		.nh.nlmsg_flags		= NLM_F_DUMP | NLM_F_REQUEST,
+		.ifinfo.ifi_family	= AF_PACKET,
+	};
+	struct xdp_features_md md = {};
+	int ret;
+
+	if (!xdp_fflags || !fflags_cnt)
+		return -EINVAL;
+
+	md.ifindex = ifindex;
+	md.flags = xdp_fflags;
+	md.flags_cnt = fflags_cnt;
+
+	ret = libbpf_netlink_send_recv(&req, __dump_link_nlmsg,
+				       bpf_get_xdp_features, &md);
+	return libbpf_err(ret);
+}
 
 typedef int (*qdisc_config_t)(struct libbpf_nla_req *req);
 
-- 
2.38.1

