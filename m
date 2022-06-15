Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34CC54CCAF
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351306AbiFOP0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349631AbiFOP0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:26:47 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435D6403E3;
        Wed, 15 Jun 2022 08:26:45 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g25so23948321ejh.9;
        Wed, 15 Jun 2022 08:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bhsajzc5zv5308M/OSV2tfJqy8kM2QCvJ63coi/piRY=;
        b=kq9iTJsgbu9BZcqKbado2S7HB0FOj/e136ESwlL6aOTciWmNReYg5vTVbJOCqCeII8
         QdQCsEzS/2m7Iq/E81aOjOtOqlwkm5jWUHQb6A3O/rh9spg/Mz4bdudilceLdimXJTwV
         7aO2QjW7F38phYgITfvsJ9ZJDihDKvlbvnnsYYwgj6pWNh1yCUpYOiE+Na8940MuJLuy
         r5gXl6SHmV54z/oTfJWX1fUq1CghYmVkkryK6fevERsYwka+WX1I772NIT7SAgDvTZJX
         4dWNIXsFgeg84j1RYzMTyAaG3Toxl1IM6ePz6gDzUxcOwWhfNWWx+n40x/x8StV6LEtb
         g07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bhsajzc5zv5308M/OSV2tfJqy8kM2QCvJ63coi/piRY=;
        b=CnizZqyGj5yfRBzvXYDAOKLdbIdwx73D3M8WFqtM36dTPdjvuFia+9/cqNe9S0E0Vq
         /8q8iik6rDAVLIfo2/1PA2s4SQvMPOMfw0sR6uOpe3AaV5SCDcbqbzCM8o6SRWBZNC+k
         ykf45HMCepWWYh9Q7vK5yKe+JmMMwCGY/ylnsTtjAdAg+FX0S0Mgz/iGAz7xM7gvtM1Z
         c81mMzxsWdPCng8WykODNQH7JihK9qQgDyWSfOIDYnpLX7gkONNfggZPQ/TDDYBuaVzy
         aDyY+wwQp0XAExX2qpDoJDYiGGjvMEcBFxs3ArHYbIz05cz1cJoTRQBuG/hsxpuzVJWx
         Q9Ig==
X-Gm-Message-State: AJIora8w2vkwFuRdVHLIm8d90AElTwZIJTqwrHqWh2Y1J3M7XebRlVe/
        WO65P8dHYofUyTY/BHqEI4VNkMu27hZeAw==
X-Google-Smtp-Source: AGRyM1uNOuVtL9eHOdEEATX0v+vKKJzkTi9GM/WOh6mqKuM9t6CocTsGxwzN74wwVnYxXfeQ4UcPOg==
X-Received: by 2002:a17:907:7fa5:b0:711:c8e2:2f4c with SMTP id qk37-20020a1709077fa500b00711c8e22f4cmr319681ejc.49.1655306803734;
        Wed, 15 Jun 2022 08:26:43 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-003-151-196.77.3.pool.telefonica.de. [77.3.151.196])
        by smtp.gmail.com with ESMTPSA id v14-20020aa7d9ce000000b0042bc97322desm9501224eds.43.2022.06.15.08.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 08:26:43 -0700 (PDT)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Serge Hallyn <serge@hallyn.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, Ondrej Zary <linux@zary.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        David Yang <davidcomponentone@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v3 4/8] drivers: use new capable_any functionality
Date:   Wed, 15 Jun 2022 17:26:18 +0200
Message-Id: <20220615152623.311223-3-cgzones@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615152623.311223-1-cgzones@googlemail.com>
References: <20220502160030.131168-8-cgzones@googlemail.com>
 <20220615152623.311223-1-cgzones@googlemail.com>
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

Use the new added capable_any function in appropriate cases, where a
task is required to have any of two capabilities.

Reorder CAP_SYS_ADMIN last.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v3:
   rename to capable_any()
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
index 2296765079a4..f0d08935b096 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -469,7 +469,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
 
 	DEB_EE("VIDIOC_S_FBUF\n");
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index d40b537f4e98..7098cff2ea51 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2567,8 +2567,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
 	const struct bttv_format *fmt;
 	int retval;
 
-	if (!capable(CAP_SYS_ADMIN) &&
-		!capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4d8974c9fcc9..23104c04a9aa 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1797,8 +1797,7 @@ static int saa7134_s_fbuf(struct file *file, void *f,
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_format *fmt;
 
-	if (!capable(CAP_SYS_ADMIN) &&
-	   !capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/platform/nxp/fsl-viu.c b/drivers/media/platform/nxp/fsl-viu.c
index afc96f6db2a1..81a90c113dc6 100644
--- a/drivers/media/platform/nxp/fsl-viu.c
+++ b/drivers/media/platform/nxp/fsl-viu.c
@@ -803,7 +803,7 @@ static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_frameb
 	const struct v4l2_framebuffer *fb = arg;
 	struct viu_fmt *fmt;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index b9caa4b26209..918913e47069 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1253,7 +1253,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 	if (dev->multiplanar)
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (dev->overlay_cap_owner)
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 688075859ae4..ca3f82a0e3a6 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -326,7 +326,7 @@ static int ldisc_open(struct tty_struct *tty)
 	/* No write no play */
 	if (tty->ops->write == NULL)
 		return -EOPNOTSUPP;
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_TTY_CONFIG))
+	if (!capable_any(CAP_SYS_TTY_CONFIG, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* release devices to avoid name collision */
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 836838f7d686..66f6db7a11fc 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -5330,7 +5330,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
 	char psf0, psf1;
 	int rc;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EACCES;
 	psf0 = psf1 = 0;
 
-- 
2.36.1

