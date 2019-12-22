Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181F0128D13
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 06:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfLVFrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 00:47:32 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44996 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfLVFrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 00:47:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id x7so7099393pgl.11;
        Sat, 21 Dec 2019 21:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XjcArXgAKvyfXDBzvMFPB+lHDAxL1AfHT3DO6M8M8pE=;
        b=QbGggnc4rIBvP1w2ApBWds25yNBz7SrOcuLl9VlQJCYjcADux3y+UglVZooSW4SdPa
         aASLnMYWp9ViF6BO87ILXkqQ31ecI/dJ95aVsHGvEf4an7NFGG9VRRWXv0GlSWwXiOhe
         SEeX6HvJncwtqsBCqvOYraM0XN9E025eXKDhV8/HP/yceXDtqY/XfKq96TJsCB7wbQ9d
         3bzPdDFtPFSX5gh70p2FbaXB1nYNmUvODQkfOB6Z5yltAub3uX+1v4SlAssElHprNXV+
         JSJ6elEQfi+pGIitKDnzijKqhSpQRTpGbLIcWcwB+FnKXRmNQHosDOEAxyQ6CR3uP7/A
         7aXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XjcArXgAKvyfXDBzvMFPB+lHDAxL1AfHT3DO6M8M8pE=;
        b=IyxwoT9i00bVRfWcdNIlSZbr7HwA9l8iV74/6bxObFOkfZegRZ+TB8VyMWAQFNSrEt
         gmwCnfWmYTnC5iA6+OSgmlQm9+F5ZR8c7/k4MHjOxx4MV+60tRaXskfC1wYSf50zH7mI
         Dg4Ua3ARt9VIzqr3Ry1j5SSUzrF3jBDAyN+3m9kdsw5xIO2zwpzk6SrYxbqK4i1aOecm
         FCoJDMkruyUapWbLj6ZVsvpm32aSdnJTbF783ZdNyKk7rqpMAOTT9pbb4EhGdsdHFCgA
         8Rh24sV7a7eK3Sep/TxgqQC3MZiF4nmDti4TmrclaIkZ9A5TOMbK5mfibjChowl8HJ87
         vKCQ==
X-Gm-Message-State: APjAAAVhI2B88yfDOTg9UwP9P/2VwZjBmEzWbnHiDz315b77Z1hQ9x0K
        3hKZIae3W7x385CfbQxBVHM=
X-Google-Smtp-Source: APXvYqx/CXunbtTsMsCA0OTUahlAsoQ/vNvrN9YML3yeUrMBpoBnwEnYlPtdizk64BmU3JLJ3C6eAQ==
X-Received: by 2002:a63:d017:: with SMTP id z23mr24720347pgf.110.1576993651284;
        Sat, 21 Dec 2019 21:47:31 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:229b:e8c2:8912:129c:d0d])
        by smtp.gmail.com with ESMTPSA id o2sm10880285pjo.26.2019.12.21.21.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 21:47:30 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     syzbot+514595412b80dc817633@syzkaller.appspotmail.com,
        davem@davemloft.net, gregkh@linuxfoundation.org, oneukum@suse.com
Cc:     allison@lohutok.net, andreyknvl@google.com,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        swinslow@gmail.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tranmanphong@gmail.com, zhang.run@zte.com.cn
Subject: [PATCH] ax88172a: fix wrong reading MAC malicious device
Date:   Sun, 22 Dec 2019 12:47:13 +0700
Message-Id: <20191222054713.14887-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <000000000000ab9d07059a410fae@google.com>
References: <000000000000ab9d07059a410fae@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Crash log KASAN: use-after-free Read in asix_suspend

https://syzkaller.appspot.com/text?tag=CrashLog&x=1330a2c6e00000
(unnamed net_device) (uninitialized): Failed to read MAC address: 0

asix_read_cmd() with ret = 0 but this is a error. Fix the checking
return value condition.

Reported-by: syzbot+514595412b80dc817633@syzkaller.appspotmail.com

Tested by:
https://groups.google.com/d/msg/syzkaller-bugs/0hHExZ030LI/yge-2Q_9BAAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/ax88172a.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index af3994e0853b..525900896ce0 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -197,6 +197,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* Get the MAC address */
 	ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, buf, 0);
 	if (ret < ETH_ALEN) {
+		if (ret >= 0)
+			ret = -ENXIO;
 		netdev_err(dev->net, "Failed to read MAC address: %d\n", ret);
 		goto free;
 	}
-- 
2.20.1

