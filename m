Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5E3FD448
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKOF3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:29:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44782 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfKOF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:29:43 -0500
Received: by mail-pg1-f195.google.com with SMTP id f19so5250527pgk.11
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 21:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3eyfb2OrYp8TsjvCHWGOdjzVViIx7fXj54769KBwJJs=;
        b=WLeVC+bb8Vrvf4vKteqU9C4j8gcyE3iSyPw9jK9cLJYGDNB48w+YDoKaKJ/GyKEt5S
         l3MxXC62rmd5XIK70+R5/HdgKeeuY9MwDSV7DmHCrdO0mOXPGCnP8jDMr/kY6zS3diXm
         in0pIWoDHXA0+Ip7P2KU71+CSG6aTxgDKuzH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3eyfb2OrYp8TsjvCHWGOdjzVViIx7fXj54769KBwJJs=;
        b=d9aJeSBjKaIx8atgmFLo8gH56COvNJdNhMyqfnuK6LBCWefT6d+Ssk7Q5HtALr00Ur
         f1C26Rd0NwH8lvYWxOURi+GirImjMr2YpVKJldf9kMBOYu8EMnqxsqIaPKcvgUWPND4U
         iic6Fka/yLvbOWx6STVAKuxQ5jMKj6DIGwg+xhuVx3CEvd6qPDwCZKQ4YRXzXf7bX+IB
         0yZbXlyEeydARnWk4cvShTPCAvrrAuF3y/qFVb6l81+NrN/+P7NP0CtyMatnY+DiwQ1h
         vGS4SLyqZwYv3HSUOG/TnI5JDY3fyb5zGDSqK6zIsNuoTfr79wCwAUeaJ/ARW+Bsozut
         tBVQ==
X-Gm-Message-State: APjAAAVH9H3l48bmXPBxCdU5lsFT5qMJYhrscXyJuFrLBVecjSmvUWQK
        DBhFVRkiG5aD+BGMYtohcbAyTw==
X-Google-Smtp-Source: APXvYqxg3RbCCP64BlhX6E+DM8vGwVDnsAvQCshvC9SlNLNCZXX7IVJO1WQAF7/MaqE4yCjC5KCYBQ==
X-Received: by 2002:a17:90a:62c4:: with SMTP id k4mr2703427pjs.0.1573795782880;
        Thu, 14 Nov 2019 21:29:42 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x192sm10581104pfd.96.2019.11.14.21.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 21:29:38 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Sami Tolvanen <samitolvanen@google.com>,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] bnx2x: Drop redundant callback function casts
Date:   Thu, 14 Nov 2019 21:07:11 -0800
Message-Id: <20191115050715.6247-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NULL is already "void *" so it will auto-cast in assignments and
initializers. Additionally, all the callbacks for .link_reset,
.config_loopback, .set_link_led, and .phy_specific_func are already
correct. No casting is needed for these, so remove them.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 160 +++++++++---------
 1 file changed, 80 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index d581d0ae6584..decde193c5b3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -11636,14 +11636,14 @@ static const struct bnx2x_phy phy_null = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)NULL,
-	.read_status	= (read_status_t)NULL,
-	.link_reset	= (link_reset_t)NULL,
-	.config_loopback = (config_loopback_t)NULL,
-	.format_fw_ver	= (format_fw_ver_t)NULL,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.config_init	= NULL,
+	.read_status	= NULL,
+	.link_reset	= NULL,
+	.config_loopback = NULL,
+	.format_fw_ver	= NULL,
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = NULL
 };
 
 static const struct bnx2x_phy phy_serdes = {
@@ -11673,12 +11673,12 @@ static const struct bnx2x_phy phy_serdes = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_xgxs_config_init,
 	.read_status	= (read_status_t)bnx2x_link_settings_status,
-	.link_reset	= (link_reset_t)bnx2x_int_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
-	.format_fw_ver	= (format_fw_ver_t)NULL,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.link_reset	= bnx2x_int_link_reset,
+	.config_loopback = NULL,
+	.format_fw_ver	= NULL,
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = NULL
 };
 
 static const struct bnx2x_phy phy_xgxs = {
@@ -11709,12 +11709,12 @@ static const struct bnx2x_phy phy_xgxs = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_xgxs_config_init,
 	.read_status	= (read_status_t)bnx2x_link_settings_status,
-	.link_reset	= (link_reset_t)bnx2x_int_link_reset,
-	.config_loopback = (config_loopback_t)bnx2x_set_xgxs_loopback,
-	.format_fw_ver	= (format_fw_ver_t)NULL,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_xgxs_specific_func
+	.link_reset	= bnx2x_int_link_reset,
+	.config_loopback = bnx2x_set_xgxs_loopback,
+	.format_fw_ver	= NULL,
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = bnx2x_xgxs_specific_func
 };
 static const struct bnx2x_phy phy_warpcore = {
 	.type		= PORT_HW_CFG_XGXS_EXT_PHY_TYPE_DIRECT,
@@ -11747,12 +11747,12 @@ static const struct bnx2x_phy phy_warpcore = {
 	/* rsrv = */0,
 	.config_init	= (config_init_t)bnx2x_warpcore_config_init,
 	.read_status	= (read_status_t)bnx2x_warpcore_read_status,
-	.link_reset	= (link_reset_t)bnx2x_warpcore_link_reset,
-	.config_loopback = (config_loopback_t)bnx2x_set_warpcore_loopback,
-	.format_fw_ver	= (format_fw_ver_t)NULL,
+	.link_reset	= bnx2x_warpcore_link_reset,
+	.config_loopback = bnx2x_set_warpcore_loopback,
+	.format_fw_ver	= NULL,
 	.hw_reset	= (hw_reset_t)bnx2x_warpcore_hw_reset,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.set_link_led	= NULL,
+	.phy_specific_func = NULL
 };
 
 
@@ -11778,12 +11778,12 @@ static const struct bnx2x_phy phy_7101 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_7101_config_init,
 	.read_status	= (read_status_t)bnx2x_7101_read_status,
-	.link_reset	= (link_reset_t)bnx2x_common_ext_link_reset,
-	.config_loopback = (config_loopback_t)bnx2x_7101_config_loopback,
+	.link_reset	= bnx2x_common_ext_link_reset,
+	.config_loopback = bnx2x_7101_config_loopback,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_7101_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_7101_hw_reset,
-	.set_link_led	= (set_link_led_t)bnx2x_7101_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.set_link_led	= bnx2x_7101_set_link_led,
+	.phy_specific_func = NULL
 };
 static const struct bnx2x_phy phy_8073 = {
 	.type		= PORT_HW_CFG_XGXS_EXT_PHY_TYPE_BCM8073,
@@ -11809,12 +11809,12 @@ static const struct bnx2x_phy phy_8073 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8073_config_init,
 	.read_status	= (read_status_t)bnx2x_8073_read_status,
-	.link_reset	= (link_reset_t)bnx2x_8073_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_8073_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_8073_specific_func
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = bnx2x_8073_specific_func
 };
 static const struct bnx2x_phy phy_8705 = {
 	.type		= PORT_HW_CFG_XGXS_EXT_PHY_TYPE_BCM8705,
@@ -11837,12 +11837,12 @@ static const struct bnx2x_phy phy_8705 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8705_config_init,
 	.read_status	= (read_status_t)bnx2x_8705_read_status,
-	.link_reset	= (link_reset_t)bnx2x_common_ext_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_common_ext_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_null_format_ver,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = NULL
 };
 static const struct bnx2x_phy phy_8706 = {
 	.type		= PORT_HW_CFG_XGXS_EXT_PHY_TYPE_BCM8706,
@@ -11866,12 +11866,12 @@ static const struct bnx2x_phy phy_8706 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8706_config_init,
 	.read_status	= (read_status_t)bnx2x_8706_read_status,
-	.link_reset	= (link_reset_t)bnx2x_common_ext_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_common_ext_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = NULL
 };
 
 static const struct bnx2x_phy phy_8726 = {
@@ -11898,12 +11898,12 @@ static const struct bnx2x_phy phy_8726 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8726_config_init,
 	.read_status	= (read_status_t)bnx2x_8726_read_status,
-	.link_reset	= (link_reset_t)bnx2x_8726_link_reset,
-	.config_loopback = (config_loopback_t)bnx2x_8726_config_loopback,
+	.link_reset	= bnx2x_8726_link_reset,
+	.config_loopback = bnx2x_8726_config_loopback,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)NULL,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.hw_reset	= NULL,
+	.set_link_led	= NULL,
+	.phy_specific_func = NULL
 };
 
 static const struct bnx2x_phy phy_8727 = {
@@ -11929,12 +11929,12 @@ static const struct bnx2x_phy phy_8727 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8727_config_init,
 	.read_status	= (read_status_t)bnx2x_8727_read_status,
-	.link_reset	= (link_reset_t)bnx2x_8727_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_8727_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_8727_hw_reset,
-	.set_link_led	= (set_link_led_t)bnx2x_8727_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_8727_specific_func
+	.set_link_led	= bnx2x_8727_set_link_led,
+	.phy_specific_func = bnx2x_8727_specific_func
 };
 static const struct bnx2x_phy phy_8481 = {
 	.type		= PORT_HW_CFG_XGXS_EXT_PHY_TYPE_BCM8481,
@@ -11964,12 +11964,12 @@ static const struct bnx2x_phy phy_8481 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8481_config_init,
 	.read_status	= (read_status_t)bnx2x_848xx_read_status,
-	.link_reset	= (link_reset_t)bnx2x_8481_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_8481_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_8481_hw_reset,
-	.set_link_led	= (set_link_led_t)bnx2x_848xx_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)NULL
+	.set_link_led	= bnx2x_848xx_set_link_led,
+	.phy_specific_func = NULL
 };
 
 static const struct bnx2x_phy phy_84823 = {
@@ -12001,12 +12001,12 @@ static const struct bnx2x_phy phy_84823 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
 	.read_status	= (read_status_t)bnx2x_848xx_read_status,
-	.link_reset	= (link_reset_t)bnx2x_848x3_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_848x3_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)bnx2x_848xx_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_848xx_specific_func
+	.hw_reset	= NULL,
+	.set_link_led	= bnx2x_848xx_set_link_led,
+	.phy_specific_func = bnx2x_848xx_specific_func
 };
 
 static const struct bnx2x_phy phy_84833 = {
@@ -12036,12 +12036,12 @@ static const struct bnx2x_phy phy_84833 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
 	.read_status	= (read_status_t)bnx2x_848xx_read_status,
-	.link_reset	= (link_reset_t)bnx2x_848x3_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_848x3_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
-	.set_link_led	= (set_link_led_t)bnx2x_848xx_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_848xx_specific_func
+	.set_link_led	= bnx2x_848xx_set_link_led,
+	.phy_specific_func = bnx2x_848xx_specific_func
 };
 
 static const struct bnx2x_phy phy_84834 = {
@@ -12070,12 +12070,12 @@ static const struct bnx2x_phy phy_84834 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
 	.read_status	= (read_status_t)bnx2x_848xx_read_status,
-	.link_reset	= (link_reset_t)bnx2x_848x3_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_848x3_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
-	.set_link_led	= (set_link_led_t)bnx2x_848xx_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_848xx_specific_func
+	.set_link_led	= bnx2x_848xx_set_link_led,
+	.phy_specific_func = bnx2x_848xx_specific_func
 };
 
 static const struct bnx2x_phy phy_84858 = {
@@ -12104,12 +12104,12 @@ static const struct bnx2x_phy phy_84858 = {
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
 	.read_status	= (read_status_t)bnx2x_848xx_read_status,
-	.link_reset	= (link_reset_t)bnx2x_848x3_link_reset,
-	.config_loopback = (config_loopback_t)NULL,
+	.link_reset	= bnx2x_848x3_link_reset,
+	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_8485x_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
-	.set_link_led	= (set_link_led_t)bnx2x_848xx_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_848xx_specific_func
+	.set_link_led	= bnx2x_848xx_set_link_led,
+	.phy_specific_func = bnx2x_848xx_specific_func
 };
 
 static const struct bnx2x_phy phy_54618se = {
@@ -12138,12 +12138,12 @@ static const struct bnx2x_phy phy_54618se = {
 	/* rsrv = */0,
 	.config_init	= (config_init_t)bnx2x_54618se_config_init,
 	.read_status	= (read_status_t)bnx2x_54618se_read_status,
-	.link_reset	= (link_reset_t)bnx2x_54618se_link_reset,
-	.config_loopback = (config_loopback_t)bnx2x_54618se_config_loopback,
-	.format_fw_ver	= (format_fw_ver_t)NULL,
-	.hw_reset	= (hw_reset_t)NULL,
-	.set_link_led	= (set_link_led_t)bnx2x_5461x_set_link_led,
-	.phy_specific_func = (phy_specific_func_t)bnx2x_54618se_specific_func
+	.link_reset	= bnx2x_54618se_link_reset,
+	.config_loopback = bnx2x_54618se_config_loopback,
+	.format_fw_ver	= NULL,
+	.hw_reset	= NULL,
+	.set_link_led	= bnx2x_5461x_set_link_led,
+	.phy_specific_func = bnx2x_54618se_specific_func
 };
 /*****************************************************************/
 /*                                                               */
-- 
2.17.1

