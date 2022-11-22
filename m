Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E7563408D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiKVPuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKVPuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:50:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411BF63B84;
        Tue, 22 Nov 2022 07:50:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id ci10so7391955pjb.1;
        Tue, 22 Nov 2022 07:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=XzoAp9Plv3egb3kfLGSXnYMVJkluSY/7fd0B6sswIds=;
        b=INdoxMR4pymr7XaCszMHSiwlodvYNMw0hTQ1XFdS3pyv1vqEJBHN3y8nUlf0UqgYCr
         rx8nNbdWgidBnRcU0ojvgzjVKCnY5F6IvNu2XgqfdXCTM7EQvPkSk9McnvmGCN0NJfLB
         pHMrYxvw+Q+U/FtheOSfmdsRwZ1aEdU+laEgbByMp5v/fkONQ4vzH1IzkJ1O/stgISAx
         AzoU2eVklfrsW9psoTB83i0NzGmPIZ45gr2yJ5y9Qm4vNIyafOowwXgr7Blo7M0KcINV
         Tux9ssO02KUiZJFaIf8YpNarnpL1c9BM8WmAFZW4t9P0h2nBJTcfy9w1vovvk8zdt85J
         tDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzoAp9Plv3egb3kfLGSXnYMVJkluSY/7fd0B6sswIds=;
        b=t19eMS1XRXCU5L834r2dzlLkc2ecPOIGVEfJePS7laiOTLo/MYTynqPM2qKAP9GZ+6
         L8C7YWGF3YdBXObKLZRs8kayFjGx2lbga45KB9IlBIM5i8N8pCljJBWwYsVJ6CxRiWUK
         s8oY2QFU1zDS9+uusLHUOqsgaB+gpQCvCcm8Q9IuWacoz9PeN0bGVCLOvXj45VAcnICj
         26fZVJ78TTfus7fZpe6zMwS3kTNau7rRTE+FzgjjYZlUo80z3yZ+AlT0WhtK/RrsrI97
         9TK8x4j4hw/00tFUcpSXEgHyPdeLNBq4X35EDWbWvlwSnYBSSAKADJkqAv8B2V3/WD+c
         3k5A==
X-Gm-Message-State: ANoB5plksHtzGd+Dgc8uXbnQj4vFxHmM3H7dBQDLz6fvrSoo0LPVib8v
        WvLyUUcR7EXFhhM7OF5CbmA=
X-Google-Smtp-Source: AA0mqf6C6yUIcGfIEM3SRjP8poGnNnss3uo6pxcf+6Njnbggm+vHaUZTQr5HIm/i0Lub8iGrBqGkLg==
X-Received: by 2002:a17:902:c286:b0:176:a880:6d72 with SMTP id i6-20020a170902c28600b00176a8806d72mr6034538pld.127.1669132202607;
        Tue, 22 Nov 2022 07:50:02 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090301cc00b001868981a18esm12251637plh.6.2022.11.22.07.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 07:50:02 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default information
Date:   Wed, 23 Nov 2022 00:49:34 +0900
Message-Id: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
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

Some piece of information are common to the vast majority of the
devices. Examples are:

  * the driver name.
  * the serial number of a USB device.

Modify devlink_nl_info_fill() to retrieve those information so that
the drivers do not have to. Rationale: factorize code.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
I am sending this as an RFC because I just started to study devlink.

I can see a parallel with ethtool for which the core will fill
whatever it can. c.f.:
commit f20a0a0519f3 ("ethtool: doc: clarify what drivers can implement in their get_drvinfo()")
Link: https://git.kernel.org/netdev/net-next/c/f20a0a0519f3

I think that devlink should do the same.

Right now, I identified two fields. If this RFC receive positive
feedback, I will iron it up and try to see if there is more that can
be filled by default.

Thank you for your comments.
---
 net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7f789bbcbbd7..1908b360caf7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -18,6 +18,7 @@
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
 #include <linux/refcount.h>
+#include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/timekeeping.h>
@@ -6685,12 +6686,37 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
 
+static int devlink_nl_driver_info_get(struct device_driver *drv,
+				      struct devlink_info_req *req)
+{
+	if (!drv)
+		return 0;
+
+	if (drv->name[0])
+		return devlink_info_driver_name_put(req, drv->name);
+
+	return 0;
+}
+
+static int devlink_nl_usb_info_get(struct usb_device *udev,
+				   struct devlink_info_req *req)
+{
+	if (!udev)
+		return 0;
+
+	if (udev->serial[0])
+		return devlink_info_serial_number_put(req, udev->serial);
+
+	return 0;
+}
+
 static int
 devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
 		     u32 seq, int flags, struct netlink_ext_ack *extack)
 {
 	struct devlink_info_req req = {};
+	struct device *dev = devlink_to_dev(devlink);
 	void *hdr;
 	int err;
 
@@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto err_cancel_msg;
 
+	err = devlink_nl_driver_info_get(dev->driver, &req);
+	if (err)
+		goto err_cancel_msg;
+
+	if (!strcmp(dev->parent->type->name, "usb_device")) {
+		err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);
+		if (err)
+			goto err_cancel_msg;
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
-- 
2.37.4

