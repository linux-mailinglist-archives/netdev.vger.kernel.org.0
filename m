Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C92517379
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386098AbiEBQEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386076AbiEBQEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:04:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F0CBC2B;
        Mon,  2 May 2022 09:00:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d6so17121294ede.8;
        Mon, 02 May 2022 09:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aLDcUxz3GuWsYBElhW2059fIPwppem/EwWmuSm4Ac4s=;
        b=p2mMHYdm4s0Fe8eLp8ERpUnJyX4PhGrwmqIwslSk6X+INW0IxkvEzoXFPk5VwYyO1a
         xgug13nZSLsUz2buOHh61+6dEuIB0yNvD1GJRLUTd4rXVHTtZ2bQm7uI52hbmW9lz92I
         G3g70LDEbT3ChfGiaqyV0ueg72L/6JiMzGNWSua1CDj2q46MAD5Vo3Qj0FjZacUxjx+L
         irnzdPDPT3QjIzAMCxMVVPmNAZqGsF8AJh9T3H21jyPG8BZSlEorhoD078aLr8QEPsxY
         ehrVFar8Jdye0i/es4zJWKuaEZK/vAsj/r9ha9j8p+B4ewbP19nc3pcIs2Fu0m3lZW9I
         tlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aLDcUxz3GuWsYBElhW2059fIPwppem/EwWmuSm4Ac4s=;
        b=CVFopP47hjifR1DTvxq6Et+N0UUQPiC4lVRWArAB6uYFE5ioriDSnI5WqSLuo6Ub4G
         IGc+ENkNDzXqVgKQfpJfxjw2qZ53TYLZiyocarVTmq0UGbIUtxz6CcLPl9o/FY8sxaKk
         cM2qVxAp9VszFT3UpTukwf1ARMVQfiWh6st3dT3hNKYEdMM8IRweOoEFdZRUSwKXkQAn
         essgGfp6WPJgESYzUbgzZ5ajCp9gJN5HrTUeS9UJP6IX4574gidbbrIjvIjiN+Xxwqp8
         AoS9ysJRVEhou112JuzbCKJ4INnDT/m9ExsaT+d1u/Dpy6fYD3J22oVMKK57hsxrEnF0
         H8jg==
X-Gm-Message-State: AOAM531W3o8lzkt1YtnB3eAlxzJy0lhx/vQvP3y01z6CS0JuvSMVCgyp
        3GVsdF/u4HfHEkKIoyQ1l/e9p1SZlfZsUQ==
X-Google-Smtp-Source: ABdhPJxEIZ3VG0JCxGGF6OC6lyuVM4utpAI+bDEKxf+HczJGz8fO+DWFU6VtPAlp6gvFM43q022t0A==
X-Received: by 2002:a05:6402:5107:b0:427:ded9:9234 with SMTP id m7-20020a056402510700b00427ded99234mr410981edd.275.1651507249567;
        Mon, 02 May 2022 09:00:49 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-001-135-067.77.1.pool.telefonica.de. [77.1.135.67])
        by smtp.gmail.com with ESMTPSA id h18-20020a1709070b1200b006f3ef214dd3sm3689996ejl.57.2022.05.02.09.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 09:00:49 -0700 (PDT)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Ondrej Zary <linux@zary.sk>,
        David Yang <davidcomponentone@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Colin Ian King <colin.king@intel.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Du Cheng <ducheng2@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 4/8] drivers: use new capable_or functionality
Date:   Mon,  2 May 2022 18:00:25 +0200
Message-Id: <20220502160030.131168-3-cgzones@googlemail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502160030.131168-1-cgzones@googlemail.com>
References: <20220217145003.78982-2-cgzones@googlemail.com>
 <20220502160030.131168-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new added capable_or function in appropriate cases, where a task
is required to have any of two capabilities.

Reorder CAP_SYS_ADMIN last.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 drivers/media/common/saa7146/saa7146_video.c     | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c            | 3 +--
 drivers/media/pci/saa7134/saa7134-video.c        | 3 +--
 drivers/media/platform/nxp/fsl-viu.c             | 2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c | 2 +-
 drivers/net/caif/caif_serial.c                   | 2 +-
 drivers/s390/block/dasd_eckd.c                   | 2 +-
 7 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 66215d9106a4..5eabc2e77cc2 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -470,7 +470,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
 
 	DEB_EE("VIDIOC_S_FBUF\n");
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 5ca3d0cc653a..4143f380d44d 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2569,8 +2569,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
 	const struct bttv_format *fmt;
 	int retval;
 
-	if (!capable(CAP_SYS_ADMIN) &&
-		!capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 48543ad3d595..684208ebfdbd 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1798,8 +1798,7 @@ static int saa7134_s_fbuf(struct file *file, void *f,
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_format *fmt;
 
-	if (!capable(CAP_SYS_ADMIN) &&
-	   !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/platform/nxp/fsl-viu.c b/drivers/media/platform/nxp/fsl-viu.c
index afc96f6db2a1..c5ed4c4a1587 100644
--- a/drivers/media/platform/nxp/fsl-viu.c
+++ b/drivers/media/platform/nxp/fsl-viu.c
@@ -803,7 +803,7 @@ static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_frameb
 	const struct v4l2_framebuffer *fb = arg;
 	struct viu_fmt *fmt;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index b9caa4b26209..a0cfcf6c22c4 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1253,7 +1253,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 	if (dev->multiplanar)
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (dev->overlay_cap_owner)
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 688075859ae4..f17b618d8858 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -326,7 +326,7 @@ static int ldisc_open(struct tty_struct *tty)
 	/* No write no play */
 	if (tty->ops->write == NULL)
 		return -EOPNOTSUPP;
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_TTY_CONFIG))
+	if (!capable_or(CAP_SYS_TTY_CONFIG, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* release devices to avoid name collision */
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 8410a25a65c1..9b5d22dd3e7b 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -5319,7 +5319,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
 	char psf0, psf1;
 	int rc;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EACCES;
 	psf0 = psf1 = 0;
 
-- 
2.36.0

