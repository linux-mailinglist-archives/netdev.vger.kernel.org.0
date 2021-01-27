Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7019A305FCC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhA0PiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbhA0Pff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:35:35 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB309C0613ED;
        Wed, 27 Jan 2021 07:34:54 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id s24so3533487wmj.0;
        Wed, 27 Jan 2021 07:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O0+FsHVqi4ap1j75IGE/n9TgljAosRz8g3ZX1HMj7o0=;
        b=Z1aOqet4hZJ7dMjXqka0XO32eTNUpfLUIBDyzIBIEZtJ2bXtwb50xhfFEujkXpTTy4
         u4I5M89r/eX+5htdvP+2pv0j0B0OWlJeOS+ddYnp64WAwQUytkWtFNLHfwiWQ/zNaRQD
         kKtk6Dii0dGezYRs/AD6ieC1ZbmzkpSVpKwixClhnTz1nggub2byUAdGq/DPP8ENrIKm
         e1xTPSWLL0mh7bl/a9HACdN2H4YCeNgXVGYd1gMogevlnnHkbKanHJ4BEkgfgDhjw60W
         C5EC3hes0ZYgRD50vJ7WLbLo2xvWMSk4e1uNbrFweTgobW2NHMuPcYQ3MTNxc72KR+UI
         O5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O0+FsHVqi4ap1j75IGE/n9TgljAosRz8g3ZX1HMj7o0=;
        b=UFMYg6+6Dm991QrDI2SxMzUAJEa5su/94x3KINvfwONSd5QRHUmGjQYFE7o/d8Ah4K
         FPbocnsIfP37bl8zV+dX00VqqLS86EwAuLC96irRxWhu3Ob1guIeoczSqOXmGlkiYjgN
         bivvXR6XEUKf0eCErrP/44T2hYkOuWu99cSuJX0iZL5aMBne+NaqeS2faZDe3uCnD2oa
         tqXdAHIoE0+TXSr1zi95RCvFZF458qUP81VcwvImXfQDf69tYYe2xRN2uAxHu6aQShmT
         ZK//R2mtBoZHdWpU6G6qKK1Du3uRv1Ui27FUSKB09A6z/WagDAjDr02R+HnZwRjd7oMx
         tYlg==
X-Gm-Message-State: AOAM532OnoOW/jgoFtkFccdM9dJmKKP0ljh6/7b4sXdBjEX7W/SC7hVR
        Nr6kFQ7mAsPwMR1ANJTyhfA=
X-Google-Smtp-Source: ABdhPJyRtXK+jyd1VmvD9IDzq2c97wPZq4xvkjCvrNxi7iNTgLJUL0jHM6IP3WDa04aPuuBrUQ9WMg==
X-Received: by 2002:a7b:cde1:: with SMTP id p1mr4577118wmj.111.1611761693426;
        Wed, 27 Jan 2021 07:34:53 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id m8sm3386132wrv.37.2021.01.27.07.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 07:34:52 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v2 1/2] net: usb: qmi_wwan: add qmap id sysfs file for qmimux interfaces
Date:   Wed, 27 Jan 2021 16:34:32 +0100
Message-Id: <20210127153433.12237-2-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210127153433.12237-1-dnlplm@gmail.com>
References: <20210127153433.12237-1-dnlplm@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qmimux interface sysfs file qmap/mux_id to show qmap id set
during the interface creation, in order to provide a method for
userspace to associate QMI control channels to network interfaces.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 7ea113f51074..bcfb1e2788fd 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -218,6 +218,28 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	return 1;
 }
 
+static ssize_t mux_id_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct qmimux_priv *priv;
+
+	priv = netdev_priv(dev);
+
+	return sysfs_emit(buf, "0x%02x\n", priv->mux_id);
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
@@ -240,6 +262,8 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 		goto out_free_newdev;
 	}
 
+	new_dev->sysfs_groups[0] = &qmi_wwan_sysfs_qmimux_attr_group;
+
 	err = register_netdevice(new_dev);
 	if (err < 0)
 		goto out_free_newdev;
-- 
2.17.1

