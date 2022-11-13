Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E0626DA8
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 05:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiKMEDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 23:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiKMEDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 23:03:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F8213F71;
        Sat, 12 Nov 2022 20:02:51 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so11002768pji.1;
        Sat, 12 Nov 2022 20:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDuvicETB47o1CIVZJhl8/Y9cPAH0K8QGejUp0fFrIg=;
        b=PfhhcE1ybwFdUQ/LcvjTBXSkXd4uA29ayC9av6hO0Izwf1LYMSx0c6JarAgAdaVbRY
         r1OvZzyqnH7pprM173+rOSWqpWqpAI00Xj/EwbBOc117ctFCrgFmoUW1xM8YaJTJ9iAs
         A1flunV8MOILrgB0bI9WNUlHKWrKI4QpjSX0s3lBUdId2OL8DjIwrZxIYgW6e80JSoF2
         zWIlAxaryArW4dU7fVBb07u2DICW7640/Tb8hoAXJ7iHELqNMxQz1h7Zb9allRp7jS8e
         an85URhYygnHVxCzuW3fWQ8ufC8/rIjoaL3ob7DbUJWdscd3vRcH/a/ogvfKvXHZRkiU
         ewxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hDuvicETB47o1CIVZJhl8/Y9cPAH0K8QGejUp0fFrIg=;
        b=hsmp2XosM7cMGuH9/DelIVv23bYs2r0Jp1RvmDpgYvxtjSh6Fbt5HHKMVrgDNMpBek
         M0gU7CRfYd/xe8JGfDVGVf3MktMlgg1ilWG6ysnON0ZngrxdhwTz5eIOPVl87hbpbGxH
         tkXehden/u5k+ZHau1mRKhQfpP0Tl8UvuBldaVac9vg5mGMqYN79nw+zrAh18ju3fVhT
         FbzfavDuOHWy8zLWCLF5KJzYw2mRKXQJoxFAvfiOgH0oHd86JNJRadg8R7Jx60xnsE5S
         qDVDlicCCyw0gWRSK1lKeIpuJ8TruIC/M3QbjlM1GzQ8Yn+MpmJjblKgEEYWHlX3bJca
         JJMA==
X-Gm-Message-State: ANoB5pkviWhPYsR243fjzrv0kWnm+rz38yZ6ZrfdC/u+G5bZTrbVE1pk
        YMl17ozJOZfcpir0PE+7k/k=
X-Google-Smtp-Source: AA0mqf4eRIpKEXGVlu+vzC91odIvs50k4JA6h0gtI90ohrVjuqCvCCGAnQe+iGqWWCeZvX9HS/aoew==
X-Received: by 2002:a17:90a:c702:b0:213:16b5:f45e with SMTP id o2-20020a17090ac70200b0021316b5f45emr8505607pjt.170.1668312170547;
        Sat, 12 Nov 2022 20:02:50 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a5ac500b00200461cfa99sm7122686pji.11.2022.11.12.20.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 20:02:50 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 3/3] can: etas_es58x: report firmware-version through ethtool
Date:   Sun, 13 Nov 2022 13:01:08 +0900
Message-Id: <20221113040108.68249-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement ethtool_ops::get_drvinfo() in order to report the firmware
version.

Firmware version 0.0.0 has a special meaning and just means that we
could not parse the product information string. In such case, do
nothing (i.e. leave the .fw_version string empty).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

*N.B.* Drivers had to also fill ethtool_drvinfo::driver and
ethtool_drvinfo::bus_info. Starting this week, this is not needed
anymore because of commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo:
populate drvinfo fields even if callback exits").

  https://git.kernel.org/netdev/net-next/c/edaf5df22cb8
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index c5109117f8e6..a048e0d40c97 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1978,7 +1978,28 @@ static const struct net_device_ops es58x_netdev_ops = {
 	.ndo_eth_ioctl = can_eth_ioctl_hwts,
 };
 
+/**
+ * es58x_get_drvinfo() - Get the firmware version.
+ * @netdev: CAN network device.
+ * @drvinfo: Driver information.
+ *
+ * Populate @drvinfo with the firmware version. The core will populate
+ * the rest.
+ */
+static void es58x_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *drvinfo)
+{
+	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
+	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
+
+	if (fw_ver->major || fw_ver->minor || fw_ver->revision)
+		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+			 "%02u.%02u.%02u",
+			 fw_ver->major, fw_ver->minor, fw_ver->revision);
+}
+
 static const struct ethtool_ops es58x_ethtool_ops = {
+	.get_drvinfo = es58x_get_drvinfo,
 	.get_ts_info = can_ethtool_op_get_ts_info_hwts,
 };
 
-- 
2.37.4

