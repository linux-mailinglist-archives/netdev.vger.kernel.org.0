Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3141D9935
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgESOPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgESOPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:15:30 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3803DC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:15:30 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so16144720wrt.1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yy/dui8GI6ROX+tvArCSJo2jhKNrpxJz13y2Wdn/fzA=;
        b=mzRZ/rxju34rpecP3SysU9bTn/luElOfc0xMWwUT1+MdSm1zBm0rygpmUhomdRBkaO
         d8yUHzJ1tzB56hyxR97SyKU/QRHfvloOih691F78hFEfD/QZj9VqKVCMYi4O1IkK3mau
         NgCW6qrfruzBGYt/jpA74zJq70TK9Sn8DoryaVpF8WH0F82LUb2L6OOJTCSGJ1whk0Sa
         7bUSlnCwd7sPazJ1R3RVAsuyC9kzsCLtGQ2oCXzNTryImOOj+++dNJF3e5evCaqBFT+K
         tI0OaXiMv3ESeXKv6oI40gDS6bHCDJXK65poxYEtFnJX/EEV0L0RlB6FMuceM+Tm5Wp9
         gRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yy/dui8GI6ROX+tvArCSJo2jhKNrpxJz13y2Wdn/fzA=;
        b=ibv4TBZFa7KF5vCVhwrCiZ2HfvRr5QzjElJ5ydTnF8XQY7tZZVlpLj3FBHGYIf4mJy
         GlZSn3TtXmM1R9OBCjnL8b8h9d9PO7rJJXS9rJ8RwzZhDp3zmdtcq1MRLBSkVH+35X3u
         48cLLkxlsBn2Do/LVJSSJu9UbooQJ2TVZZlNFLH1tDzXd+ZrS4T7rFnRunETyefI66l9
         8NELP2XynmZDf07ABvKq99RGjuqn67mOVepzX+6B2rP3qiwcniW3li+Uw+kyq/ODo86v
         pE5M92qNkpJaEC+975XeSpfxmngfXmCQeO++pTqjSb/mqugbGpE5zOFnqr0EIsjVoYoM
         tNng==
X-Gm-Message-State: AOAM530LrywJ3qbiVl/GFxiNPR0gaLfyd1AVG92jcamBZGMmxMIhRFAE
        RVkznCReyUa6oL6I1WXI242IJw==
X-Google-Smtp-Source: ABdhPJyDDPuCPP/gfuDW40IwuX65eBmCeKCWa50nWkob1SVHqIiuzS5NzFL6sm7vj9o+xQCB1Oel5A==
X-Received: by 2002:adf:e5c8:: with SMTP id a8mr25139009wrn.335.1589897728907;
        Tue, 19 May 2020 07:15:28 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id c140sm4242222wmd.18.2020.05.19.07.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 07:15:27 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 2/2] nfp: flower: inform firmware of flower features
Date:   Tue, 19 May 2020 16:15:02 +0200
Message-Id: <20200519141502.18676-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519141502.18676-1-simon.horman@netronome.com>
References: <20200519141502.18676-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

For backwards compatibility it may be required for the firmware to
disable certain features depending on the features supported by
the host. Combine the host feature bits and firmware feature bits
and write this back to the firmware.

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/main.c  | 106 +++++++++++++-----
 .../net/ethernet/netronome/nfp/flower/main.h  |  11 ++
 2 files changed, 87 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index 62c202307940..d054553c75e0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -665,6 +665,77 @@ static int nfp_flower_vnic_init(struct nfp_app *app, struct nfp_net *nn)
 	return err;
 }
 
+static void nfp_flower_wait_host_bit(struct nfp_app *app)
+{
+	unsigned long err_at;
+	u64 feat;
+	int err;
+
+	/* Wait for HOST_ACK flag bit to propagate */
+	err_at = jiffies + msecs_to_jiffies(100);
+	do {
+		feat = nfp_rtsym_read_le(app->pf->rtbl,
+					 "_abi_flower_combined_features_global",
+					 &err);
+		if (time_is_before_eq_jiffies(err_at)) {
+			nfp_warn(app->cpp,
+				 "HOST_ACK bit not propagated in FW.\n");
+			break;
+		}
+		usleep_range(1000, 2000);
+	} while (!err && !(feat & NFP_FL_FEATS_HOST_ACK));
+
+	if (err)
+		nfp_warn(app->cpp,
+			 "Could not read global features entry from FW\n");
+}
+
+static int nfp_flower_sync_feature_bits(struct nfp_app *app)
+{
+	struct nfp_flower_priv *app_priv = app->priv;
+	int err;
+
+	/* Tell the firmware of the host supported features. */
+	err = nfp_rtsym_write_le(app->pf->rtbl, "_abi_flower_host_mask",
+				 app_priv->flower_ext_feats |
+				 NFP_FL_FEATS_HOST_ACK);
+	if (!err)
+		nfp_flower_wait_host_bit(app);
+	else if (err != -ENOENT)
+		return err;
+
+	/* Tell the firmware that the driver supports lag. */
+	err = nfp_rtsym_write_le(app->pf->rtbl,
+				 "_abi_flower_balance_sync_enable", 1);
+	if (!err) {
+		app_priv->flower_ext_feats |= NFP_FL_ENABLE_LAG;
+		nfp_flower_lag_init(&app_priv->nfp_lag);
+	} else if (err == -ENOENT) {
+		nfp_warn(app->cpp, "LAG not supported by FW.\n");
+	} else {
+		return err;
+	}
+
+	if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MOD) {
+		/* Tell the firmware that the driver supports flow merging. */
+		err = nfp_rtsym_write_le(app->pf->rtbl,
+					 "_abi_flower_merge_hint_enable", 1);
+		if (!err) {
+			app_priv->flower_ext_feats |= NFP_FL_ENABLE_FLOW_MERGE;
+			nfp_flower_internal_port_init(app_priv);
+		} else if (err == -ENOENT) {
+			nfp_warn(app->cpp,
+				 "Flow merge not supported by FW.\n");
+		} else {
+			return err;
+		}
+	} else {
+		nfp_warn(app->cpp, "Flow mod/merge not supported by FW.\n");
+	}
+
+	return 0;
+}
+
 static int nfp_flower_init(struct nfp_app *app)
 {
 	u64 version, features, ctx_count, num_mems;
@@ -753,35 +824,11 @@ static int nfp_flower_init(struct nfp_app *app)
 	if (err)
 		app_priv->flower_ext_feats = 0;
 	else
-		app_priv->flower_ext_feats = features;
+		app_priv->flower_ext_feats = features & NFP_FL_FEATS_HOST;
 
-	/* Tell the firmware that the driver supports lag. */
-	err = nfp_rtsym_write_le(app->pf->rtbl,
-				 "_abi_flower_balance_sync_enable", 1);
-	if (!err) {
-		app_priv->flower_ext_feats |= NFP_FL_ENABLE_LAG;
-		nfp_flower_lag_init(&app_priv->nfp_lag);
-	} else if (err == -ENOENT) {
-		nfp_warn(app->cpp, "LAG not supported by FW.\n");
-	} else {
-		goto err_cleanup_metadata;
-	}
-
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MOD) {
-		/* Tell the firmware that the driver supports flow merging. */
-		err = nfp_rtsym_write_le(app->pf->rtbl,
-					 "_abi_flower_merge_hint_enable", 1);
-		if (!err) {
-			app_priv->flower_ext_feats |= NFP_FL_ENABLE_FLOW_MERGE;
-			nfp_flower_internal_port_init(app_priv);
-		} else if (err == -ENOENT) {
-			nfp_warn(app->cpp, "Flow merge not supported by FW.\n");
-		} else {
-			goto err_lag_clean;
-		}
-	} else {
-		nfp_warn(app->cpp, "Flow mod/merge not supported by FW.\n");
-	}
+	err = nfp_flower_sync_feature_bits(app);
+	if (err)
+		goto err_cleanup;
 
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_init(app);
@@ -792,10 +839,9 @@ static int nfp_flower_init(struct nfp_app *app)
 
 	return 0;
 
-err_lag_clean:
+err_cleanup:
 	if (app_priv->flower_ext_feats & NFP_FL_ENABLE_LAG)
 		nfp_flower_lag_cleanup(&app_priv->nfp_lag);
-err_cleanup_metadata:
 	nfp_flower_metadata_cleanup(app);
 err_free_app_priv:
 	vfree(app->priv);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7db3be0b17e9..59abea2a39ad 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -44,10 +44,21 @@ struct nfp_app;
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
 #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
+#define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
 #define NFP_FL_ENABLE_LAG		BIT(1)
 
+#define NFP_FL_FEATS_HOST \
+	(NFP_FL_FEATS_GENEVE | \
+	NFP_FL_NBI_MTU_SETTING | \
+	NFP_FL_FEATS_GENEVE_OPT | \
+	NFP_FL_FEATS_VLAN_PCP | \
+	NFP_FL_FEATS_VF_RLIM | \
+	NFP_FL_FEATS_FLOW_MOD | \
+	NFP_FL_FEATS_PRE_TUN_RULES | \
+	NFP_FL_FEATS_IPV6_TUN)
+
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
 	ktime_t *last_used;
-- 
2.20.1

