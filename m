Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4811581FA
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBJSC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:59 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45863 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbgBJSCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:55 -0500
Received: by mail-oi1-f194.google.com with SMTP id v19so10030150oic.12
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 10:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0KShUUCdWMdc6fnb1YrsfTdb60AmTRCc7YmXkdpn5U=;
        b=k3TjCHJhU6nkTcCUxn7zXH7719HcZgCiVBa31yj4u2fpmhiYmawQmwxcXu3TaDkogO
         +EAEeTJuF5h4zGadBINUKxyzEIayXTkdq0QwJ1CItinKuI0BXQ/ygY+GMlnZin/b9D3Z
         fyhNPbWaql9+xLCLjwH7bQL9tCdpOu1XM21wJFPNKsWWrIuPsymoPdZdeeb47/virS0M
         UaNhe3Zo9QWWIxvJUvn5Me863ZW6M5vTtziQtFXukncVsPgLFANVNucS/Ed44JoIjmj2
         Uf/Wf6xvdIQvAfMnSuiT10IHfl31tyh/wLGk/erkZ79VFTOjxDjtin2ProH43Xxk26GA
         7XnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=B0KShUUCdWMdc6fnb1YrsfTdb60AmTRCc7YmXkdpn5U=;
        b=pdVzYQMKw1MUWjBbfkvkNJeL7ejtSp9Q/PFpkI3kCrlVLD2KDjOjRdC/GzP+pGLv7z
         qWpZTIiDxWgQ1EKlIub++XMuAq5Pyv3H2Lwk1+0F4r7XjmSvg9qXOP748h3ups79WUYc
         lEzWOCoSRD8jW0cHU7fiHIEuowYIC7RRZkGJoHzn39in1GLjy2nrn1yjgp6r4+HydDgl
         EH22TSHJBVALHOOME0qC3l1uvax9tRYRt2tfX/QTaX4RVx3e1UakhV1zOK4QdLyNXcBg
         QbJxNLwl98LFZgttVTqYTp8ijKPE3qA9amBPggbYl9er6tNQ9H22itWNgvmydu9c5S3b
         F3Yw==
X-Gm-Message-State: APjAAAUJWrzwhRTRrDD+2iqg5p3IYuZeugwGizeMdPpSBGRYJmsnorP3
        KuDEQmuKzVxD4kYhDkFlAVVZ1eBu
X-Google-Smtp-Source: APXvYqxMRFW/Iym6ZleUbDwWpCYlbfoI9xJ5HXNeac3/qVk1ykPCLHPe8fQfSxJsL7wFhLJ2S8O+aQ==
X-Received: by 2002:a54:4106:: with SMTP id l6mr189137oic.76.1581357774943;
        Mon, 10 Feb 2020 10:02:54 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:54 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pietro Oliva <pietroliva@gmail.com>
Subject: [PATCH 5/6] staging: rtl8188eu: Remove some unneeded goto statements
Date:   Mon, 10 Feb 2020 12:02:34 -0600
Message-Id: <20200210180235.21691-6-Larry.Finger@lwfinger.net>
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
 .../staging/rtl8188eu/os_dep/ioctl_linux.c    | 40 ++++++-------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index acca3ae8b254..ba53959e1303 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2009,21 +2009,16 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 	struct ieee_param *param;
 	uint ret = 0;
 
-	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!p->pointer || p->length != sizeof(struct ieee_param))
+		return -EINVAL;
 
 	param = (struct ieee_param *)rtw_malloc(p->length);
-	if (!param) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!param)
+		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
 		kfree(param);
-		ret = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
 	switch (param->cmd) {
@@ -2054,9 +2049,6 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 		ret = -EFAULT;
 
 	kfree(param);
-
-out:
-
 	return ret;
 }
 
@@ -2791,26 +2783,19 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 	* so, we just check hw_init_completed
 	*/
 
-	if (!padapter->hw_init_completed) {
-		ret = -EPERM;
-		goto out;
-	}
+	if (!padapter->hw_init_completed)
+		return -EPERM;
 
-	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!p->pointer || p->length != sizeof(struct ieee_param))
+		return -EINVAL;
 
 	param = (struct ieee_param *)rtw_malloc(p->length);
-	if (!param) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!param)
+		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
 		kfree(param);
-		ret = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
 	switch (param->cmd) {
@@ -2865,7 +2850,6 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
 		ret = -EFAULT;
 	kfree(param);
-out:
 	return ret;
 }
 #endif
-- 
2.25.0

