Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B0C2A31CB
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgKBRkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgKBRkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:40:04 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49B4C0617A6;
        Mon,  2 Nov 2020 09:40:04 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id b12so7186584plr.4;
        Mon, 02 Nov 2020 09:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4FUjseBvSlN4iyKlxPmISM29dOoxCX8GBWbbpYhudEI=;
        b=YIDrIs4hnsMP/+ygcESF72A7xjSFMnE+4x7aP5jyclyeFMB4U2fQxf7SNMdKRo1DDq
         lToQq5m+es1IdL8lZwGUlLcRoeOFtMZzmlSncRGgKXK3eLOSLPGHlbUIwYox2YI4XYLj
         wHw7xxgxy0SWGtu4iaNQ0wE31hj4mFT1vDShKd8h0ZYgCuqtmqqm1DulC5hinbhZqUoN
         YerBaA5W9OHIu1IOOW40wkOdHiHkgmRU5nW6qq841uVGIx1i0smbqKbth84QxdvXZwcm
         5w/fWByBBWjW8pGJXTBCj75r2EmTZ2uA5r7mw/hzmELaDQAWzB0gxlWgvOEOjW42v4LE
         05cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4FUjseBvSlN4iyKlxPmISM29dOoxCX8GBWbbpYhudEI=;
        b=Db5+DYcmeu6p8SKFZgfK/0GqnhxbPNf93HLcEk04+xEO9THyCLs+FdnXoRBHBBdS9a
         S6Gm4uW3ewNZUGp+tBoi/5dboa3cqTKp/Nihku03grevKNS9/o3IcEsCs40crA87IlJz
         t9Lv3wkatohYpC8Hw5OeexT1fwReeWJs23sz/2N44DQ6eFi8VJ0/IpSkB5FLfS0vfp/W
         RBFKP4PHiWFO4jrOYdb2Fc2rqgA+9nZCX7bBw6nl5IfuCFVmIjwasfOAWqGD4SOtDftQ
         aHYuaSO6935xUOTCjSTQkOdflOXnQBudIDWknLW4wW+sjsUIIc9ofp+kUxx/zhlEpFOh
         C1dQ==
X-Gm-Message-State: AOAM533cQOC/5VBPREzvWw6zLc+6EAWT2Uf6OPzLnnz/GHk0oRFC6+dK
        b1JHbGiJIdp6U2qpSGZxXnpvepaM/VsU+2U8cIA=
X-Google-Smtp-Source: ABdhPJzOlLg5cWU8Xm1c1s/AkcdP3EMOQfXigJqCCdawvffGOGPdYMWeNktnGnG99fV6j0SFx9dNJA==
X-Received: by 2002:a17:902:8693:b029:d5:d861:6f03 with SMTP id g19-20020a1709028693b02900d5d8616f03mr21578621plo.19.1604338804184;
        Mon, 02 Nov 2020 09:40:04 -0800 (PST)
Received: from localhost.localdomain ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id v23sm75234pjh.46.2020.11.02.09.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:40:02 -0800 (PST)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [RESEND PATCH v3] net: usb: usbnet: update __usbnet_{read|write}_cmd() to use new API
Date:   Mon,  2 Nov 2020 23:09:46 +0530
Message-Id: <20201102173946.13800-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
However, this could lead to potential partial reads/writes being
considered valid, and since most of the callers of
usbnet_{read|write}_cmd() don't take partial reads/writes into account
(only checking for negative error number is done), and this can lead to
issues.

However, the new usb_control_msg_{send|recv}() APIs don't allow partial
reads and writes.
Using the new APIs also relaxes the return value checking that must
be done after usbnet_{read|write}_cmd() is called.

Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes in v3:
	* Aligned continuation lines after the opening brackets
Changes in v2:
	* Fix build error


 drivers/net/usb/usbnet.c | 52 ++++++++--------------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index bf6c58240bd4..b2df3417a41c 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1982,64 +1982,32 @@ EXPORT_SYMBOL(usbnet_link_change);
 static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 			     u16 value, u16 index, void *data, u16 size)
 {
-	void *buf = NULL;
-	int err = -ENOMEM;
 
 	netdev_dbg(dev->net, "usbnet_read_cmd cmd=0x%02x reqtype=%02x"
 		   " value=0x%04x index=0x%04x size=%d\n",
 		   cmd, reqtype, value, index, size);
 
-	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
-		if (!buf)
-			goto out;
-	}
-
-	err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-			      cmd, reqtype, value, index, buf, size,
-			      USB_CTRL_GET_TIMEOUT);
-	if (err > 0 && err <= size) {
-        if (data)
-            memcpy(data, buf, err);
-        else
-            netdev_dbg(dev->net,
-                "Huh? Data requested but thrown away.\n");
-    }
-	kfree(buf);
-out:
-	return err;
+	return usb_control_msg_recv(dev->udev, 0,
+				    cmd, reqtype, value, index, data, size,
+				    USB_CTRL_GET_TIMEOUT, GFP_KERNEL);
 }
 
 static int __usbnet_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 			      u16 value, u16 index, const void *data,
 			      u16 size)
 {
-	void *buf = NULL;
-	int err = -ENOMEM;
-
 	netdev_dbg(dev->net, "usbnet_write_cmd cmd=0x%02x reqtype=%02x"
 		   " value=0x%04x index=0x%04x size=%d\n",
 		   cmd, reqtype, value, index, size);
 
-	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
-		if (!buf)
-			goto out;
-	} else {
-        if (size) {
-            WARN_ON_ONCE(1);
-            err = -EINVAL;
-            goto out;
-        }
-    }
-
-	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
-			      cmd, reqtype, value, index, buf, size,
-			      USB_CTRL_SET_TIMEOUT);
-	kfree(buf);
+	if (size && !data) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 
-out:
-	return err;
+	return usb_control_msg_send(dev->udev, 0,
+				    cmd, reqtype, value, index, data, size,
+				    USB_CTRL_SET_TIMEOUT, GFP_KERNEL);
 }
 
 /*
-- 
2.25.1

