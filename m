Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD755380BC1
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhENO1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:27:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14674 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229942AbhENO1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:27:48 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14EEMNDg027629;
        Fri, 14 May 2021 14:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=5bl1zmUBree67gp8ksHVfQp53E6olxx+qbucqo8ZA7c=;
 b=gxJi051NTXSXHm8q738zmdTQ8mihP1X1ixC0KXc1vk5xe9oOS22ZiTTpFgLC4MZp06Mj
 pRQHwWI/dFOOCbV2qKantlsRmzlNOAFCo6IsrtoQlFv0kty0ZbHIVO0eJ6l4P+gAtJne
 J/pyXFgp47RHZaDepiXX8bdpoe5fha0OAeE0LMT9NUn2GP4sI0t5ydZWFyjTQ0eHOME3
 ohAaotzy1GkXSbR5w7xGCe3eiftiad5QTioDQcPpDX7cqVa5x6bKaTaBeIS3mWmlx4jm
 f0TwrzjKu0VuSuOTb2uRWjkBQr5cGRcQCmkfSDeAwuG6qBF9wqfbvGSzjVOxOL8GLFfO UQ== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38gpqsrq3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 14:25:04 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14EEO5p2106870;
        Fri, 14 May 2021 14:25:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38gppq53yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 14:25:03 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14EEM3bl103577;
        Fri, 14 May 2021 14:25:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 38gppq53wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 14:25:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14EEOumt008995;
        Fri, 14 May 2021 14:24:57 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 May 2021 07:24:56 -0700
Date:   Fri, 14 May 2021 17:24:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Johan Hovold <johan@kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Rustam Kovhaev <rkovhaev@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net] net: hso: check for allocation failure in
 hso_create_bulk_serial_device()
Message-ID: <YJ6IMH7jI9QFdGIX@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJurlxqQ9L+zzIAS@hovoldconsulting.com>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: iw5OUc9nxGpX4DRnwmKRtU1O-Z93NsTo
X-Proofpoint-ORIG-GUID: iw5OUc9nxGpX4DRnwmKRtU1O-Z93NsTo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In current kernels, small allocations never actually fail so this
patch shouldn't affect runtime.

Originally this error handling code written with the idea that if
the "serial->tiocmget" allocation failed, then we would continue
operating instead of bailing out early.  But in later years we added
an unchecked dereference on the next line.

	serial->tiocmget->serial_state_notification = kzalloc();
        ^^^^^^^^^^^^^^^^^^

Since these allocations are never going fail in real life, this is
mostly a philosophical debate, but I think bailing out early is the
correct behavior that the user would want.  And generally it's safer to
bail as soon an error happens.

Fixes: af0de1303c4e ("usb: hso: obey DMA rules in tiocmget")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Do more extensive clean up.  As Johan pointed out the comments and
later NULL checks can be removed.

 drivers/net/usb/hso.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3ef4b2841402..260f850d69eb 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2618,29 +2618,28 @@ static struct hso_device *hso_create_bulk_serial_device(
 		num_urbs = 2;
 		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
 					   GFP_KERNEL);
+		if (!serial->tiocmget)
+			goto exit;
 		serial->tiocmget->serial_state_notification
 			= kzalloc(sizeof(struct hso_serial_state_notification),
 					   GFP_KERNEL);
-		/* it isn't going to break our heart if serial->tiocmget
-		 *  allocation fails don't bother checking this.
-		 */
-		if (serial->tiocmget && serial->tiocmget->serial_state_notification) {
-			tiocmget = serial->tiocmget;
-			tiocmget->endp = hso_get_ep(interface,
-						    USB_ENDPOINT_XFER_INT,
-						    USB_DIR_IN);
-			if (!tiocmget->endp) {
-				dev_err(&interface->dev, "Failed to find INT IN ep\n");
-				goto exit;
-			}
-
-			tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (tiocmget->urb) {
-				mutex_init(&tiocmget->mutex);
-				init_waitqueue_head(&tiocmget->waitq);
-			} else
-				hso_free_tiomget(serial);
+		if (!serial->tiocmget->serial_state_notification)
+			goto exit;
+		tiocmget = serial->tiocmget;
+		tiocmget->endp = hso_get_ep(interface,
+					    USB_ENDPOINT_XFER_INT,
+					    USB_DIR_IN);
+		if (!tiocmget->endp) {
+			dev_err(&interface->dev, "Failed to find INT IN ep\n");
+			goto exit;
 		}
+
+		tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (tiocmget->urb) {
+			mutex_init(&tiocmget->mutex);
+			init_waitqueue_head(&tiocmget->waitq);
+		} else
+			hso_free_tiomget(serial);
 	}
 	else
 		num_urbs = 1;
-- 
2.30.2

