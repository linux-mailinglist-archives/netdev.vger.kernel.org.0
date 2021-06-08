Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DCF39ED53
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFHEFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:48 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:45989 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhFHEFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:47 -0400
Received: by mail-lf1-f51.google.com with SMTP id a1so20133886lfr.12;
        Mon, 07 Jun 2021 21:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1uFD2O0vKXy2Tb2HNN6E4vBvc6S9cY96zFOzzHgNrTM=;
        b=ekFCy4rTrKxhkCHRrv+Kw1A0n6rHg7Q0KKykF1lDJFFGciPhqnC6b3DD8Fgb+Tx05j
         jcSRzqSd1ysrJHvXBeBbXBXDwk+xilym3oUs0/8/BEFaXs4FRFGGIMl6o5bNvGXRCWav
         R7H0EAF/K7lV5kbXx9l8hCNA5zcMdYHvyJS0vnk5JBiN6fMlsEwK3+44hYBKKgmYZ7ta
         iuyLQ0dT6jLD7+86LLH+lrFFPGmVPJEWRlpaevFMX1dS46oWzIDgdXk/C3tmKn7NGKWn
         2YcyyQL4TKH/rcDLbeWGudtNfsZ31ryErzwhagwywKXV2xpXyMfuehanT0n3xi76IAdr
         nXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1uFD2O0vKXy2Tb2HNN6E4vBvc6S9cY96zFOzzHgNrTM=;
        b=Fq5o+oE7CM2X+O+z/UQ/1VMv8YFuRpKy/fSgTkNLJT5OmTEwISC+brC09dwAZC8hXK
         y6BAKBFvnK0eYDUqn9ouKwkPQJQ5kvKjHoPe5gNiE5KCMSwlw6Tb+GImZ70Fy8figPTd
         yc+e9ruOebWtsvEghjW/rmD9UI9e7aEqTQPQ3ivAwqjKsf/U7rkhhxqNmm6go+DjCh+H
         uyPeO/auUMmRyxaDSzp2pcdI2bh7DY8nWKu+ETjqhg2J87PsacqQzGhsDRV33wWhSxxm
         uMSOpalDw8UYumNOZwe7PTVRdMr4PLNTB9IaXfydLuHPeJ7yu79UpakThMyCzOK+Doi+
         DT4g==
X-Gm-Message-State: AOAM532fftXA4DIDEcqOwhOQE6lCYXNh0xrbQPxxjkF+kH16u5twEom5
        j2eDESKDGpU8akv25JZQqhc=
X-Google-Smtp-Source: ABdhPJxocvEw+Mi3KJ9OSKPUilp799hP5e1cKMh5Y/I0m68CnqNuyvtmyHN7V924o7St9JnOz7eTXg==
X-Received: by 2002:a19:4f1a:: with SMTP id d26mr14467136lfb.265.1623124973967;
        Mon, 07 Jun 2021 21:02:53 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:53 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/10] net: wwan: core: spell port device name in lowercase
Date:   Tue,  8 Jun 2021 07:02:36 +0300
Message-Id: <20210608040241.10658-6-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually a device name is spelled in lowercase, let us follow this
practice in the WWAN subsystem as well. The bottom line is that such
name is easier to type.

To keep the device type attribute contents more natural (i.e., spell
abbreviations in uppercase), while making the device name lowercase,
turn the port type strings array to an array of structure that contains
both the port type name and the device name suffix.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 97d77b06d222..ba4392d71b80 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -184,12 +184,30 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 
 /* ------- WWAN port management ------- */
 
-static const char * const wwan_port_type_str[WWAN_PORT_MAX + 1] = {
-	[WWAN_PORT_AT] = "AT",
-	[WWAN_PORT_MBIM] = "MBIM",
-	[WWAN_PORT_QMI] = "QMI",
-	[WWAN_PORT_QCDM] = "QCDM",
-	[WWAN_PORT_FIREHOSE] = "FIREHOSE",
+static const struct {
+	const char * const name;	/* Port type name */
+	const char * const devsuf;	/* Port devce name suffix */
+} wwan_port_types[WWAN_PORT_MAX + 1] = {
+	[WWAN_PORT_AT] = {
+		.name = "AT",
+		.devsuf = "at",
+	},
+	[WWAN_PORT_MBIM] = {
+		.name = "MBIM",
+		.devsuf = "mbim",
+	},
+	[WWAN_PORT_QMI] = {
+		.name = "QMI",
+		.devsuf = "qmi",
+	},
+	[WWAN_PORT_QCDM] = {
+		.name = "QCDM",
+		.devsuf = "qcdm",
+	},
+	[WWAN_PORT_FIREHOSE] = {
+		.name = "FIREHOSE",
+		.devsuf = "firehose",
+	},
 };
 
 static ssize_t type_show(struct device *dev, struct device_attribute *attr,
@@ -197,7 +215,7 @@ static ssize_t type_show(struct device *dev, struct device_attribute *attr,
 {
 	struct wwan_port *port = to_wwan_port(dev);
 
-	return sprintf(buf, "%s\n", wwan_port_type_str[port->type]);
+	return sprintf(buf, "%s\n", wwan_port_types[port->type].name);
 }
 static DEVICE_ATTR_RO(type);
 
@@ -285,7 +303,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	/* create unique name based on wwan device id, port index and type */
 	dev_set_name(&port->dev, "wwan%up%u%s", wwandev->id,
 		     atomic_inc_return(&wwandev->port_id),
-		     wwan_port_type_str[port->type]);
+		     wwan_port_types[port->type].devsuf);
 
 	err = device_register(&port->dev);
 	if (err)
-- 
2.26.3

