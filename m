Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74736202598
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 19:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgFTRTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 13:19:50 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:41027 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgFTRTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 13:19:47 -0400
Received: by mail-ej1-f67.google.com with SMTP id dp18so13658985ejc.8
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 10:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0CESgfsYXJyXtYBDBdCeCR4Yk3XC58tRCswLA8nsOPw=;
        b=Z1Z8I+eEnOWnW/GkKkXqNKDULqGdD/KgFlzhLkmBxqlVHJNl9qxNUhJTCbb3maZupe
         4gadLKoo/6HA5Oy386w0nmndBFcwlWViFYjeEPjyqjf6D2ClvZc/XoNi3ukNPqQMs+Gx
         6yiIVccJxBtR1PHLXL4sc5xwGOCyLTTmAIa2IgLOjT3mOalrnH7suHK3vcbff7NqhBWT
         OPu6QTo/kIFdbohhpb5uqeLA6g3wziTF7V9LUq8NWm3nnfs6oZaJgc+M/5UmK+Fc+S3R
         DOdIxPKOLqgyojMZXW5I6644CCLkiDTD2b/0U7Tkg1sdDjpLTBm1gPCXddPuyMbgRfWj
         vHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0CESgfsYXJyXtYBDBdCeCR4Yk3XC58tRCswLA8nsOPw=;
        b=O5uZzMENTsKAgHfMNdtiUs5FihMsnWluJxS31Rhmcg+ty2OhhtLg/qYLfw3odCJV92
         Wv/4GZSsroBpOS/2DdknKv2wJGc7hv+iNLQfCbuWqR/J8cgB7CDK84/cQ4zWPGeZSIm5
         OrBo1XlqVxu8q5LJqPNm5l3aKfo+io2886SdEgA6h/C2xb1/tHqcmtUsq9chmpVTgrx5
         C46P8JC3Nk7bPp//maFBqDtEC9wgortQN0DoXi+JxucW5zDlsmIlPtUmV3tB926HNHs0
         /0PuBtflxxlh2x+TiaytEN1huHUx1ZPrmP+6gUtsREPt6t4n6ajidWkkDQrWyJOqmHrd
         PXJw==
X-Gm-Message-State: AOAM533C83WM+Ma2rhVik8mDFEfj88f0mvltza5wIoycQ8GEMJ/BXr5A
        s/cwu4L25F+hFR+lqMUsyBg=
X-Google-Smtp-Source: ABdhPJyMt5e1lA0Cp44LUIDK98Fq1NR0PFFu/96hdqlpLROndtpzFvAI9UjnL/tRC2DuNP+0Y0yICQ==
X-Received: by 2002:a17:906:4155:: with SMTP id l21mr1623075ejk.438.1592673523618;
        Sat, 20 Jun 2020 10:18:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id a9sm7863476edr.23.2020.06.20.10.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 10:18:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net-next 2/3] net: dsa: sja1105: make config table operation structures constant
Date:   Sat, 20 Jun 2020 20:18:31 +0300
Message-Id: <20200620171832.3679837-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620171832.3679837-1-olteanv@gmail.com>
References: <20200620171832.3679837-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The per-chip instantiations of struct sja1105_table_ops and struct
sja1105_dynamic_table_ops can be made constant, so do that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c |  4 ++--
 drivers/net/dsa/sja1105/sja1105_dynamic_config.h |  4 ++--
 drivers/net/dsa/sja1105/sja1105_static_config.c  | 12 ++++++------
 drivers/net/dsa/sja1105/sja1105_static_config.h  | 12 ++++++------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 331593ace215..75247f342124 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -638,7 +638,7 @@ static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
 #define OP_SEARCH	BIT(3)
 
 /* SJA1105E/T: First generation */
-struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
+const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105et_vl_lookup_entry_packing,
 		.cmd_packing = sja1105_vl_lookup_cmd_packing,
@@ -722,7 +722,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 };
 
 /* SJA1105P/Q/R/S: Second generation */
-struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
+const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105_vl_lookup_entry_packing,
 		.cmd_packing = sja1105_vl_lookup_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
index 1fc0d13dc623..28d4eb5efb8b 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
@@ -34,7 +34,7 @@ struct sja1105_mgmt_entry {
 	u64 index;
 };
 
-extern struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN];
-extern struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN];
+extern const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN];
+extern const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN];
 
 #endif
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index fb44c0a72285..139b7b4fbd0d 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -838,7 +838,7 @@ sja1105_static_config_get_length(const struct sja1105_static_config *config)
 /* Compatibility matrices */
 
 /* SJA1105E: First generation, no TTEthernet */
-struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
+const struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105et_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -908,7 +908,7 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 };
 
 /* SJA1105T: First generation, TTEthernet */
-struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
+const struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = {
 		.packing = sja1105_schedule_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
@@ -1026,7 +1026,7 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 };
 
 /* SJA1105P: Second generation, no TTEthernet, no SGMII */
-struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
+const struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -1096,7 +1096,7 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 };
 
 /* SJA1105Q: Second generation, TTEthernet, no SGMII */
-struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
+const struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = {
 		.packing = sja1105_schedule_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
@@ -1214,7 +1214,7 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 };
 
 /* SJA1105R: Second generation, no TTEthernet, SGMII */
-struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
+const struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -1284,7 +1284,7 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 };
 
 /* SJA1105S: Second generation, TTEthernet, SGMII */
-struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
+const struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = {
 		.packing = sja1105_schedule_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index ee0f10062763..bc7606899289 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -381,12 +381,12 @@ struct sja1105_static_config {
 	struct sja1105_table tables[BLK_IDX_MAX];
 };
 
-extern struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX];
-extern struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX];
-extern struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX];
-extern struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX];
-extern struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX];
-extern struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX];
+extern const struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX];
 
 size_t sja1105_table_header_packing(void *buf, void *hdr, enum packing_op op);
 void
-- 
2.25.1

