Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95E0289EC9
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 08:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgJJG7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 02:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728459AbgJJG5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 02:57:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9327C0613CF;
        Fri,  9 Oct 2020 23:57:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g10so8768196pfc.8;
        Fri, 09 Oct 2020 23:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TbBIbqC8DAFbPFSiL7x/czfUd8Ri1dHtd4Wy4OMwCtE=;
        b=DnDBEoueu5yY2GmrVTAMYaxr2x810ufN9NJ9yfrpmWCC/2rAaJNFp9t47zAxovadkw
         tYWnpiCZxa+9VG4OPh6xpLy56bOn1FCgeQSYbsqVlCLLAuzt2Nk/dDEo0y6Fmdh6oMe9
         i4t2NgCZ+bWQJymdN4Nrq4ShgC66aO78ei2cvLjsYFXYOe7E+AGypQnRYXrfE4cpkBcF
         NLleiKF6RDP6NiSF2Tdn4Q7qya16I88bgKQUwDYDEXConVNEBlyFlCcacJTtlV3V6ZBA
         PCTN2SfEQD35Sdo8Gv93x1+qu6LrmgvRfZRg5qxldp9EHrWjBijPrHPsVzH2LfQjEr9+
         Ll2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TbBIbqC8DAFbPFSiL7x/czfUd8Ri1dHtd4Wy4OMwCtE=;
        b=PXWxl3ahDcF5rAf4ukD2N7T2MJw+890P7Oc6/ySXEadwYfI9eDrORiJnHBsAvBJLZR
         fkfj+Mddi6SYA+RHQ24cTywUP9FJgzeOBEfVcPNc4tW2um+7AEn+RPy9gCRJnudyl2Hg
         yLOfGD3YboPZHi8QOPqC1Z0tuNv2OpQyLXepH8RW/JhZnusRT6qe1XeKMkX7AHhfdWR2
         CS+N3RtXYyzmlL2xCATkk0dX/jcc+Sv2mm9S/FB3t/XJquzj5bKIBRjUpPzyb7I0tdNv
         eElmaKeg6X+PCB33sw/nFa9QKeu6l8u3hiuJz2VuxKhnc27/Kl2oWpZjsLRH5BcFjrde
         MVtw==
X-Gm-Message-State: AOAM533qIKp/hkM7r6Q4XL4Ltmhgs6gNL/zputgxKBIkxtkoBkkxas2K
        wynSGsElVkWV0o45X/LmgfA=
X-Google-Smtp-Source: ABdhPJxK3n4NYTLiNOVehda6ZI4fd68di0A5O3p4cFTtXkGxfTq+DvTtTbUQOEd4JfHQ+QH+VuoqcA==
X-Received: by 2002:a17:90a:c285:: with SMTP id f5mr9026834pjt.87.1602313023069;
        Fri, 09 Oct 2020 23:57:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id g3sm13947340pjl.6.2020.10.09.23.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 23:57:02 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: usbnet: update  __usbnet_{read|write}_cmd() to use new API
Date:   Sat, 10 Oct 2020 12:26:23 +0530
Message-Id: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
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
Since not all callers of usbnet_{read|write}_cmd() check if a complete 
read/write happened, partial reads can go unnoticed.

This issue was briefly mentioned here.
	https://lore.kernel.org/linux-usb/1565777764.25764.4.camel@suse.com/

Using the new API in place of the old one doesn't break anything.
This is mainly because usb_control_msg_{send|recv}() returns 0 on success
and a negative error number on failure (which includes partial reads/writes).

Thus, the error checking condition provided by the present callers of 
usbnet_{read|write}_cmd() for failure (return value < 0 is considered as an 
error) will hold. 
And similarly, the condition checked by some callers for 'success' 
(return value >= 0 && return value < length/size) will also hold.

However, if I have missed out on any caller that this might cause problems with,
please let me know, and I will fix that up as well.

 drivers/net/usb/usbnet.c | 52 ++++++++--------------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index bf6c58240bd4..dd9fe530a374 100644
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
+			      cmd, reqtype, value, index, data, size,
+			      USB_CTRL_GET_TIMEOUT, GFP_KERNEL);
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
+			cmd, reqtype, value, index, data, size,
+			USB_CTRL_SET_TIMEOUT, GPF_KERNEL);
 }
 
 /*
-- 
2.25.1

