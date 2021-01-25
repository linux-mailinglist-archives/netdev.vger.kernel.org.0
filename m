Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FA0303423
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbhAZFSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730009AbhAYPgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:36:07 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BB9C061225;
        Mon, 25 Jan 2021 07:23:10 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id u14so11435554wmq.4;
        Mon, 25 Jan 2021 07:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bonaNtQOYdal1eJtZWnTWz1u25uAbcWM2s+Tk4ODo6o=;
        b=nDw4+r+GuwRJX5fPNU4BcC6ZlTzTTY4EI2/3gSnuZZpYf8l12Ql+FFL/MOn+Gngf5R
         xz0Skd06kxpS+pwljFitrBrZ+8E11D5GeQl9MbQIO4u23DF/f6XwPK0raexzxwDhi+sw
         GsHLw4PfVRHWMA7RuJzi70Rg4GEefl/2egTZp9XqPqbC4UPZ7Ewo0pCoNZ55TLy7yUuV
         xtb202eOC2FP5z+7UYsf4K41T9fmeOvleuCZrTHRAQZDMldoH2CzU1/o92M5Xo+QULOA
         ynvxmaK4aSfjStoyeyqIsTxJcwAmWTbRc4TUD3FkNA+DzlnZF2od3XMlwtoByDNypQm5
         o/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bonaNtQOYdal1eJtZWnTWz1u25uAbcWM2s+Tk4ODo6o=;
        b=NOmr9aC2pnpIBAic8wvKtuic4NOnrkQ4ceA94F95v/taJJighV3o0HgwL9BuhdAq6M
         EPfgjcc9Zr08qBuBKmTT7cTc+BREmjznfwArSzZOxPDpCi013ZKrBXBnkNNDOkcTvj90
         nE7wZOL5vc3WKQXki9xArBIz2z3NNO/Nhq0ny9zsvhj4hozykFdgvyut7X26kN5Ib4o3
         xhUHieqosCcggw0UHg+EdkiOUBU2XqThK14XOfETmOIEHyh7lW7VS8SLexJBu8wtLfES
         PjaImxJ0B0GhKs9A/7cB73Fc/6PosnsTzb+jjjPDdVPSRFnloyzLek9dcqIySq1pvfwK
         mbAQ==
X-Gm-Message-State: AOAM532bDcmt+u6W9B77BjKTEdywwQxynjDZ7qbXLOPApPcI14CzYVWP
        yE5DDQ67kJVlAm7ndCEcgcQ=
X-Google-Smtp-Source: ABdhPJzDzziMZ3RQVf8GVDCFp9muT3RhPjTIECOGJiaXXW9bFFUnZMnwjH16axbS8S/sVTkrQmacfw==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr623368wmc.102.1611588188781;
        Mon, 25 Jan 2021 07:23:08 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id l84sm13071307wmf.17.2021.01.25.07.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:23:08 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 1/2] net: usb: qmi_wwan: add qmap id sysfs file for qmimux interfaces
Date:   Mon, 25 Jan 2021 16:22:34 +0100
Message-Id: <20210125152235.2942-2-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125152235.2942-1-dnlplm@gmail.com>
References: <20210125152235.2942-1-dnlplm@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qmimux interface sysfs file qmap/mux_id to show qmap id set
during the interface creation, in order to provide a method for
userspace to associate QMI control channels to network interfaces.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 7ea113f51074..9b85e2ed4760 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -218,6 +218,31 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	return 1;
 }
 
+static ssize_t mux_id_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct qmimux_priv *priv;
+	ssize_t count = 0;
+
+	priv = netdev_priv(dev);
+	count += scnprintf(&buf[count], PAGE_SIZE - count,
+			   "0x%02x\n", priv->mux_id);
+
+	return count;
+}
+
+static DEVICE_ATTR_RO(mux_id);
+
+static struct attribute *qmi_wwan_sysfs_qmimux_attrs[] = {
+	&dev_attr_mux_id.attr,
+	NULL,
+};
+
+static struct attribute_group qmi_wwan_sysfs_qmimux_attr_group = {
+	.name = "qmap",
+	.attrs = qmi_wwan_sysfs_qmimux_attrs,
+};
+
 static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 {
 	struct net_device *new_dev;
@@ -240,6 +265,8 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 		goto out_free_newdev;
 	}
 
+	new_dev->sysfs_groups[0] = &qmi_wwan_sysfs_qmimux_attr_group;
+
 	err = register_netdevice(new_dev);
 	if (err < 0)
 		goto out_free_newdev;
-- 
2.17.1

