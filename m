Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E4E2C7B8E
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 23:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgK2WBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 17:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK2WBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 17:01:05 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1953C0613D3;
        Sun, 29 Nov 2020 14:00:24 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 23so12872975wrc.8;
        Sun, 29 Nov 2020 14:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9m45deAlqqrpV+EGvz5gA1CvOVmGlfrfttO8AgnDF8M=;
        b=UaJjRVpPbjqyG3EJL4oCEFQHv5RgI3bRPzUIjq6YtsL+l17Eg+kOyoIDhP7raRw0Cf
         WAz/uQdFRPF+kCkA/5Bg7TmlG52ZzIqJQ0qFP1SIG2Hzy3daV/u1X+H3L7V3R9CG0CIi
         QP+23WUzGYQdepncfXxWoc3G4XU/gjWrn/jGubz1IgHHxZuhY5FqVFG48JrP2GPyZO+m
         v7vckwHXRcyZBOnE9F1h4eDi67ZVrsfdgNwb4SJrm+rBsgs3hvHkZdwkcfiND7tYelU/
         MiXmu4jjmcmFVyBcxskNZumtZrLTyctHhwwsd4y5fEYiI0ZZvVw9Iu4tWIoT3uIbKyuY
         /ruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9m45deAlqqrpV+EGvz5gA1CvOVmGlfrfttO8AgnDF8M=;
        b=TCKCBKJ5e9D6fSoHt9WVq54TApdfHrvCPwrKzJsk4NZYhxojuL8SH/paCvFwWwswWb
         fuGrAX5bND5P/V0miFZIctL5FSivY7nKT9YeiVSCEq1vAVd7UICbtKbVzdim9NAqaIne
         c36/1dh984UKoL8RkSBiYDAY7LAuS8yMDpqSbcbnMRCbVLKSTjOj7JD6R9hm4jBRbbAA
         DwDlq7xyxrrZawL6HONEqdcrNcgwBqh0JvNjCvn/LMrDVOentnXHeR756Q6QiWur5JHX
         7BE/b4SaalqwYOQSgJlRCSuVAnDMEgQROYUCCXykM6jnkC2YMc46Woy23Zf4zLUnqzZU
         Zo6Q==
X-Gm-Message-State: AOAM533t6rEwxDeGVwNz13K0rA3vhThgbW7cnHHuv0uPu+z9jQDP0OVL
        YT/iEtFOotU4WZqzlJUEFRw=
X-Google-Smtp-Source: ABdhPJyMKt84005QvoggyFlAukrVlo4LUTwEvBiFT5mI8PqttNb1gwPi5BFEKF9zQOE0dMphRSwQBg==
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr24597824wrw.123.1606687223652;
        Sun, 29 Nov 2020 14:00:23 -0800 (PST)
Received: from adgra-XPS-15-9570.home (lfbn-idf1-1-1007-144.w86-238.abo.wanadoo.fr. [86.238.83.144])
        by smtp.gmail.com with ESMTPSA id b4sm4938080wrr.30.2020.11.29.14.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 14:00:23 -0800 (PST)
From:   Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrien Grassein <adrien.grassein@gmail.com>
Subject: [PATCH v2 3/3] net: fsl: fec: add imx8mq support.
Date:   Sun, 29 Nov 2020 23:00:00 +0100
Message-Id: <20201129220000.16550-3-adrien.grassein@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201129220000.16550-1-adrien.grassein@gmail.com>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
 <20201129220000.16550-1-adrien.grassein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the imx8mq support to the
fsl fec driver.
Quirks are extracted from the NXP driver (5.4).

Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4f22c8e3fe7e..a4bb1adbf9ed 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -131,6 +131,14 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
+static const struct fec_devinfo fec_imx8mq_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -158,6 +166,11 @@ static struct platform_device_id fec_devtype[] = {
 		.name = "imx6ul-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
 	}, {
+		.name = "imx8mq-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8mq_info,
+	},
+
+	{
 		/* sentinel */
 	}
 };
@@ -171,6 +184,7 @@ enum imx_fec_type {
 	MVF600_FEC,
 	IMX6SX_FEC,
 	IMX6UL_FEC,
+	IMX8MQ_FEC,
 };
 
 static const struct of_device_id fec_dt_ids[] = {
@@ -181,6 +195,8 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
 	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
+	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
+
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fec_dt_ids);
-- 
2.20.1

