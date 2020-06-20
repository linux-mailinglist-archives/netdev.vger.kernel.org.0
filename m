Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEEA202596
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 19:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgFTRTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 13:19:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40038 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgFTRTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 13:19:46 -0400
Received: by mail-ed1-f67.google.com with SMTP id p18so10261883eds.7
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 10:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LcEbFIrAAhBYKhdjp7wyHOGr8k5+dVMzs2DskcVbFVE=;
        b=OVhzfBtKWA4UzB1Ys9LGKikDKn7ipCg/7IDzJBD/a96j9vk+8H+PfN5GfM8FDjPSRd
         FVRKS6IQH7MhenHkQYxNfEWnOib7ee1sbehmD6msiJ0atWwNhTDuAayc9GoAT/kvLImS
         JsEf7MhDth4dIO0/aldViN3SFiFxzdOLlxfYe7dFIjNR52MtELFsHK087jDv+oNDhD+w
         8r//ZtiMHC4dRA9KO1z13HdxFf19RJQ7tP2e1cJ6FWjj93KnEr/Ei4WMM4XeKa5gV1pE
         c6LoqziC0HFXBj+Lqu81U87l/mN1eC5FVTfzTln6Y019EAbcqtoURjAYInNefGaXB9+V
         szyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LcEbFIrAAhBYKhdjp7wyHOGr8k5+dVMzs2DskcVbFVE=;
        b=saFqgqinY85PNqKzDEdSDjqvrHvuO2w6Ue+T0mKtokCai8f5NXNNX1XjRB3QXbU3sw
         u0qt734Ooo5EgKG1DT4lDMIEF4Vnqv0Ox1zHXgLwU9bg2B9QK87OL72ntJrE8Is0s1+K
         qu0diCzOIl5m/Qayi6Wj6OZxWcpiDtSiQ7HOa7p8ZyxW7eLdpbOzhjt1js8OtcI8rw9Q
         wZfQfy72X6W1YwvzPR4DbgjZ8xisRs8/3qAWzuns2nCWVhA9DEHs2TcyNyj1Xd82LFiS
         Vs4LjfcIXvm61H9oUrWoD9B2Ha9CusUYAnQ/696tAjzlZIdbWNbbDKWDyBO+QNyc0cq1
         UKWg==
X-Gm-Message-State: AOAM530qTIv8K4AORg6YybAHMijKTuRwC5NG5TljyYwDfNCGYLFgamAt
        NkfRmvJRqxXi2E7nhsGncEk0g5RO
X-Google-Smtp-Source: ABdhPJy0Q1TJqHMhpOOn+cE3d+jdw8qtgCF/H2uqsvofQBfFBB6jPIhTJDYMnimBHTtg+CwAk/0lMQ==
X-Received: by 2002:a50:9b14:: with SMTP id o20mr9044495edi.371.1592673524550;
        Sat, 20 Jun 2020 10:18:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id a9sm7863476edr.23.2020.06.20.10.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 10:18:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net-next 3/3] net: dsa: sja1105: make the instantiations of struct sja1105_info constant
Date:   Sat, 20 Jun 2020 20:18:32 +0300
Message-Id: <20200620171832.3679837-4-olteanv@gmail.com>
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

Since struct sja1105_private only holds a const pointer to one of these
structures based on device tree compatible string, the structures
themselves can be made const.

Also add an empty line between each structure definition, to appease
checkpatch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h     | 12 ++++++------
 drivers/net/dsa/sja1105/sja1105_spi.c | 17 +++++++++++------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 29ed21687295..ba70b40a9a95 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -262,12 +262,12 @@ int sja1105_static_config_upload(struct sja1105_private *priv);
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited);
 
-extern struct sja1105_info sja1105e_info;
-extern struct sja1105_info sja1105t_info;
-extern struct sja1105_info sja1105p_info;
-extern struct sja1105_info sja1105q_info;
-extern struct sja1105_info sja1105r_info;
-extern struct sja1105_info sja1105s_info;
+extern const struct sja1105_info sja1105e_info;
+extern const struct sja1105_info sja1105t_info;
+extern const struct sja1105_info sja1105p_info;
+extern const struct sja1105_info sja1105q_info;
+extern const struct sja1105_info sja1105r_info;
+extern const struct sja1105_info sja1105s_info;
 
 /* From sja1105_clocking.c */
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index bb52b9c841b2..704dcf1d1c01 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -507,7 +507,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.ptpsyncts = 0x1F,
 };
 
-struct sja1105_info sja1105e_info = {
+const struct sja1105_info sja1105e_info = {
 	.device_id		= SJA1105E_DEVICE_ID,
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
@@ -523,7 +523,8 @@ struct sja1105_info sja1105e_info = {
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105E",
 };
-struct sja1105_info sja1105t_info = {
+
+const struct sja1105_info sja1105t_info = {
 	.device_id		= SJA1105T_DEVICE_ID,
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
@@ -539,7 +540,8 @@ struct sja1105_info sja1105t_info = {
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105T",
 };
-struct sja1105_info sja1105p_info = {
+
+const struct sja1105_info sja1105p_info = {
 	.device_id		= SJA1105PR_DEVICE_ID,
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
@@ -556,7 +558,8 @@ struct sja1105_info sja1105p_info = {
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105P",
 };
-struct sja1105_info sja1105q_info = {
+
+const struct sja1105_info sja1105q_info = {
 	.device_id		= SJA1105QS_DEVICE_ID,
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
@@ -573,7 +576,8 @@ struct sja1105_info sja1105q_info = {
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105Q",
 };
-struct sja1105_info sja1105r_info = {
+
+const struct sja1105_info sja1105r_info = {
 	.device_id		= SJA1105PR_DEVICE_ID,
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
@@ -590,7 +594,8 @@ struct sja1105_info sja1105r_info = {
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105R",
 };
-struct sja1105_info sja1105s_info = {
+
+const struct sja1105_info sja1105s_info = {
 	.device_id		= SJA1105QS_DEVICE_ID,
 	.part_no		= SJA1105S_PART_NO,
 	.static_ops		= sja1105s_table_ops,
-- 
2.25.1

