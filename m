Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EE958E61
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfF0XNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:13:15 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36882 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfF0XNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:13:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so3266163qkl.4
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aI01O8MJBKiqAfWZ/Hp8e27yt/dgHkLaDXUn1mwX3fQ=;
        b=BnSu64OJ0Y3F8wRP1MdQcRmXDfqvrnvzjJkE5Df5rQ9PRtQHtIsCrz6wUWR/OmPHAH
         /B9dbXlVrJNLEP5Qtzj9ShXnca4XBnlL+6kNzvz+L7Hvxlpk2ogcMnKwnbAhA+cTF9T5
         pKp8saOFG81ntSUSfMZsjBTayfQpeb/GuIQqRFWi6/ccuG8+J9lZNb7KgS58/2Ciw7Zh
         Ht0v3klE6x3AVt4jhh2Xv69qpibZn9DYzlPC8ZgZ7elD7Mr1fwOUP5ZY6A1guVzk3c9H
         6ATgSMg2fqGC0LDEbYCVzMJxCvh5Yp2H5/xww/E1W8lW33pU0XJNomaP5JKJo0/M+5wT
         6Jfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aI01O8MJBKiqAfWZ/Hp8e27yt/dgHkLaDXUn1mwX3fQ=;
        b=jiUj0/oWaJCaJQY6O6SsQL+hEvAeGAMh5b6Nx+hpQxS3dT8dEyHXT7DqEAzCCXp4Z/
         OJGD1pzLXfkMBLNGCC/TRXVb5OFQCjWbfnZNSzN6bi9NBRVFtQbPyrQRKWpng44UaUO3
         9Nxs6fFV1uKF0+FZw6pXWa7TZfo62UGMBGvkmO/5wSoBYBwj03FQ3o+tL/A6LBRwP6G8
         jkthZNhit1/PlHwPqlsTTEY505cI4NPtPdf5lHoqaK170xIfNfYYZnj5dPqw21unzXu8
         CvkrnoFeRMYN2rZyr6qkO/oEdBG+6DguC17nKrgHkSBuDE3jiJ1Q6qjGfz3d7GCbyBNC
         fVhg==
X-Gm-Message-State: APjAAAWZV07D88lSn+zRPZL49kdhBCenE5xEvIb2pJr52WHEF2NUfM77
        SiVSxLpV7cJlYB16Hi95frkiuw==
X-Google-Smtp-Source: APXvYqxMs2lbtSTpZb5/Y6WKhcNQxo+QBchSrtSw370D/wC47Ke8balLAIo+05VyNJHv5a0kGBp7yw==
X-Received: by 2002:a37:a10b:: with SMTP id k11mr5528693qke.76.1561677192138;
        Thu, 27 Jun 2019 16:13:12 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm253518qtk.67.2019.06.27.16.13.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 16:13:11 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 5/5] nfp: flower: add GRE encap action support
Date:   Thu, 27 Jun 2019 16:12:43 -0700
Message-Id: <20190627231243.8323-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627231243.8323-1-jakub.kicinski@netronome.com>
References: <20190627231243.8323-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Add new GRE encapsulation support, which allows offload of filters
using tunnel_key set action in combination with actions that egress
to GRE type ports.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 .../ethernet/netronome/nfp/flower/action.c    | 33 ++++++++++++++++---
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 88fedb5ada97..b6bd31fe44b2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -170,13 +170,36 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 	return 0;
 }
 
+static bool
+nfp_flower_tun_is_gre(struct tc_cls_flower_offload *flow, int start_idx)
+{
+	struct flow_action_entry *act = flow->rule->action.entries;
+	int num_act = flow->rule->action.num_entries;
+	int act_idx;
+
+	/* Preparse action list for next mirred or redirect action */
+	for (act_idx = start_idx + 1; act_idx < num_act; act_idx++)
+		if (act[act_idx].id == FLOW_ACTION_REDIRECT ||
+		    act[act_idx].id == FLOW_ACTION_MIRRED)
+			return netif_is_gretap(act[act_idx].dev);
+
+	return false;
+}
+
 static enum nfp_flower_tun_type
 nfp_fl_get_tun_from_act(struct nfp_app *app,
-			const struct flow_action_entry *act)
+			struct tc_cls_flower_offload *flow,
+			const struct flow_action_entry *act, int act_idx)
 {
 	const struct ip_tunnel_info *tun = act->tunnel;
 	struct nfp_flower_priv *priv = app->priv;
 
+	/* Determine the tunnel type based on the egress netdev
+	 * in the mirred action for tunnels without l4.
+	 */
+	if (nfp_flower_tun_is_gre(flow, act_idx))
+		return NFP_FL_TUNNEL_GRE;
+
 	switch (tun->key.tp_dst) {
 	case htons(IANA_VXLAN_UDP_PORT):
 		return NFP_FL_TUNNEL_VXLAN;
@@ -841,7 +864,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
 		       int *out_cnt, u32 *csum_updated,
 		       struct nfp_flower_pedit_acts *set_act,
-		       struct netlink_ext_ack *extack)
+		       struct netlink_ext_ack *extack, int act_idx)
 {
 	struct nfp_fl_set_ipv4_tun *set_tun;
 	struct nfp_fl_pre_tunnel *pre_tun;
@@ -896,7 +919,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	case FLOW_ACTION_TUNNEL_ENCAP: {
 		const struct ip_tunnel_info *ip_tun = act->tunnel;
 
-		*tun_type = nfp_fl_get_tun_from_act(app, act);
+		*tun_type = nfp_fl_get_tun_from_act(app, flow, act, act_idx);
 		if (*tun_type == NFP_FL_TUNNEL_NONE) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported tunnel type in action list");
 			return -EOPNOTSUPP;
@@ -1022,8 +1045,8 @@ int nfp_flower_compile_action(struct nfp_app *app,
 			memset(&set_act, 0, sizeof(set_act));
 		err = nfp_flower_loop_action(app, act, flow, nfp_flow, &act_len,
 					     netdev, &tun_type, &tun_out_cnt,
-					     &out_cnt, &csum_updated, &set_act,
-					     extack);
+					     &out_cnt, &csum_updated,
+					     &set_act, extack, i);
 		if (err)
 			return err;
 		act_cnt++;
-- 
2.21.0

