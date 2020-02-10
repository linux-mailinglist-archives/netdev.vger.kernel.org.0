Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF12B1581F9
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBJSC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:58 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37468 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgBJSC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:57 -0500
Received: by mail-ot1-f65.google.com with SMTP id d3so7274070otp.4
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 10:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7zev+nzf84O19+SsgOdC2PDlzmc84n4XaWfl0N7G4i0=;
        b=Dm5a5NF32KMUXbMVRjY9EA3Lu2y+8Y1u6jlIPibi5pscf9+PxxuHEBLUcxn5GVYiEo
         BFXXlCP+fpqSe1rZiDI1MhiSSlnMGt0AN78XxKV726Fpejy6W9MYAPXFZ8Wn1PRF99hY
         fc0tKxZq7n9gtzN44yaSCSLOo2XhlgtFqWC07O98De42qk1U/xwSQZyXLS5c00WYETGn
         XOlIbniRxuh26KCfgW9tcbVdoLMDSZdH2U5mn6h4oDLnjT7Q3RQvy7mH+KIdce0I14v3
         /pUIvmX+rtwqWNHzwOkNs+4NXpxlRGq5PCZdLk+dDxKtDrcp0nthRc8q43JqINhzv0SO
         FVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=7zev+nzf84O19+SsgOdC2PDlzmc84n4XaWfl0N7G4i0=;
        b=T9l1Q5v7v1ayWHKJ8LpHvDPkUTwM0eUA2XVFoXZlb51qi6j6Pzx2g71i3Htn43icaA
         oJ04/jbZz7cQJ0gaz4D+L7QMkjJx+0mSLpCy3kUevY781UsTy1wjgHlM9yriPz8Jh2ZV
         q8/Zi+98oGEiuPggu7I62rzskvYdGBdzohmpkO7jpCLI1KHIzTFgQSVhLg7NuYfKZwNx
         oNn2XSQ2wWJEuE1WbgDOu4n8Zzy8yk4NHQMXvX2P6lajTy0KRVK1UND26c/s8YSE7Hul
         gx9LH5mwOgM2rTbR7e/XOxzHTy/F3DSsW1uEGKn0+EXj9YtDco6/IcrcjEx0MFnR+6hG
         jAjA==
X-Gm-Message-State: APjAAAVyg1THjQf3blh6dKsJhjBiqLz7xFvBLkcB6XLTeFgzT0ou58ex
        e2ioRYzpVkVQLza59vt3x04=
X-Google-Smtp-Source: APXvYqxunMGeML/UlC7WUnBRDzKk0bdaw79CtqMWEXo2vCD0jzYIOUDupIbDs9S1OkiKbdIUqYkClQ==
X-Received: by 2002:a05:6830:1218:: with SMTP id r24mr2037318otp.144.1581357775682;
        Mon, 10 Feb 2020 10:02:55 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:55 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pietro Oliva <pietroliva@gmail.com>
Subject: [PATCH 6/6] staging: rtl8723bs: Remove unneeded goto statements
Date:   Mon, 10 Feb 2020 12:02:35 -0600
Message-Id: <20200210180235.21691-7-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
References: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In routines rtw_hostapd_ioctl() and wpa_supplicant_ioctl(), several
error conditions involve setting a variable indicating the error,
followed by a goto. The code following the target of that goto merely
returns the value. It is simpler, therefore to return the error value
immediately, and eliminate the got  target.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pietro Oliva <pietroliva@gmail.com>
---
 .../staging/rtl8723bs/os_dep/ioctl_linux.c    | 47 +++++--------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 2ac0d84f090e..9b9038e7deb1 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -3373,21 +3373,16 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 
 	/* down(&ieee->wx_sem); */
 
-	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!p->pointer || p->length != sizeof(struct ieee_param))
+		return -EINVAL;
 
 	param = rtw_malloc(p->length);
-	if (param == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (param == NULL)
+		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
 		kfree(param);
-		ret = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
 	switch (param->cmd) {
@@ -3421,12 +3416,8 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 
 	kfree(param);
 
-out:
-
 	/* up(&ieee->wx_sem); */
-
 	return ret;
-
 }
 
 static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
@@ -4200,28 +4191,19 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 	* so, we just check hw_init_completed
 	*/
 
-	if (!padapter->hw_init_completed) {
-		ret = -EPERM;
-		goto out;
-	}
-
+	if (!padapter->hw_init_completed)
+		return -EPERM;
 
-	/* if (p->length < sizeof(struct ieee_param) || !p->pointer) { */
-	if (!p->pointer || p->length != sizeof(*param)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!p->pointer || p->length != sizeof(*param))
+		return -EINVAL;
 
 	param = rtw_malloc(p->length);
-	if (param == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (param == NULL)
+		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
 		kfree(param);
-		ret = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
 	/* DBG_871X("%s, cmd =%d\n", __func__, param->cmd); */
@@ -4321,13 +4303,8 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
 		ret = -EFAULT;
 
-
 	kfree(param);
-
-out:
-
 	return ret;
-
 }
 
 static int rtw_wx_set_priv(struct net_device *dev,
-- 
2.25.0

