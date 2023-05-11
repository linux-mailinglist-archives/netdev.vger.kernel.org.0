Return-Path: <netdev+bounces-1837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08BB46FF42E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B96E628163A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA93F1D2BD;
	Thu, 11 May 2023 14:26:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD37B1F922;
	Thu, 11 May 2023 14:26:52 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0768D100D9;
	Thu, 11 May 2023 07:26:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bdd7b229cso15780021a12.0;
        Thu, 11 May 2023 07:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1683815197; x=1686407197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuRohinkfnfKmQ5A0D+/nPSG9lRUGHQe+yhHKcHJQxc=;
        b=LtK1dCAhlTv//hzdt2MS3tcXcqmmZZ8Uq+ljdJNnuuCglgmhmm9NuHsu73nfpcQlSJ
         Oe1i6sin4+SziCfaxmajG9Mop1DS3VAV89W3M9GwqfL2NqFBqcZRlnBK7rAoWVLECKju
         QGLD6uMlpZNvfWHqc4hYTnnbHRI14zXMNpVgR3YjZSl8eED7DDP48pupvBdwHhlEzDjG
         dGIUFk34vfcb+AN0naBTlDjc46KrhjdmBFRxdbe2hO6F0EgKmzkvTETHjHMcwwMCMk2q
         R7pJ+d5SeSJeDn75IkxGfZ4fKQP589sMALN7ukmg6zahdU4e3DmKP7/1Or8+YvChH745
         uW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815197; x=1686407197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NuRohinkfnfKmQ5A0D+/nPSG9lRUGHQe+yhHKcHJQxc=;
        b=ZyupoRAqPzCmJQjElv2ieiEOaTbdrRzbMk+F/TtU2muO3o84z9INJj6megvVlltFZD
         QKtuwNjDrCSn80fRTmvBdwwPsQX8BG5bJhlGjbiemBdy9S9Moj0VW/qDbxzXBOVHdmjV
         c1z5sgBXqDUDsnscosMDHT1dOCn7jeMQTZgkYQ51oDCtnzzxLFzAfRGnnomwIbXP1cum
         +zeQ1YeXY7bctEU93s2Qkjwo1BKwZi2MDVSmWjridNHqeKxgjU4vP2sRMKUnMqlT0Udg
         lAx1iCzUXGFCpDOAeNPqle/Dk1dje98fHycA/Xw802tIUkV1vv85A+MEC2shbPTioX5g
         NyRQ==
X-Gm-Message-State: AC+VfDx6IK6xrg5gjRgM1PApJ+70ZCFwIyy8biQPZxtE2p26RfBFzFCi
	9nkktWXHdaPxZRyYQIF+iaSejuxFv5nYag==
X-Google-Smtp-Source: ACHHUZ5GOLDQBV2a4yxrRPw74HHNTnjeXEf7+OrzQ2aRfK6fL6kLzU37PHBUAbvQ3LzW53EJgy3gcg==
X-Received: by 2002:a17:907:720e:b0:966:5a6c:752d with SMTP id dr14-20020a170907720e00b009665a6c752dmr13444473ejc.20.1683815197050;
        Thu, 11 May 2023 07:26:37 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-008-180-228.77.8.pool.telefonica.de. [77.8.180.228])
        by smtp.gmail.com with ESMTPSA id hf15-20020a1709072c4f00b0094f58a85bc5sm4056647ejc.180.2023.05.11.07.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:26:35 -0700 (PDT)
From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To: selinux@vger.kernel.org
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
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
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH v4 5/9] drivers: use new capable_any functionality
Date: Thu, 11 May 2023 16:25:28 +0200
Message-Id: <20230511142535.732324-5-cgzones@googlemail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511142535.732324-1-cgzones@googlemail.com>
References: <20230511142535.732324-1-cgzones@googlemail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the new added capable_any function in appropriate cases, where a
task is required to have any of two capabilities.

Reorder CAP_SYS_ADMIN last.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v4:
   Additional usage in kfd_ioctl()
v3:
   rename to capable_any()
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 3 +--
 drivers/net/caif/caif_serial.c           | 2 +-
 drivers/s390/block/dasd_eckd.c           | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 1b54a9aaae70..d21fb9d1556b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2896,8 +2896,7 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	 * more priviledged access.
 	 */
 	if (unlikely(ioctl->flags & KFD_IOC_FLAG_CHECKPOINT_RESTORE)) {
-		if (!capable(CAP_CHECKPOINT_RESTORE) &&
-						!capable(CAP_SYS_ADMIN)) {
+		if (!capable_any(CAP_CHECKPOINT_RESTORE, CAP_SYS_ADMIN)) {
 			retcode = -EACCES;
 			goto err_i1;
 		}
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
index ade1369fe5ed..67d1058bce1b 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -5370,7 +5370,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
 	char psf0, psf1;
 	int rc;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EACCES;
 	psf0 = psf1 = 0;
 
-- 
2.40.1


