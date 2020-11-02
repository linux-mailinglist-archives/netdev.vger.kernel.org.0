Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864962A2E33
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKBPVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgKBPUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:20:50 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A545EC061A4A
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:20:48 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id b8so15092757wrn.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 07:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m2ikj+dhQ1Zeha09QctzFr3Pm7l2AwdyE1EcOPpxBQc=;
        b=oJDk04WZntZBUbAydrL0ALwZvx6qsFnM0UTwP7yjzGp9SneSLAZ43tbdB/bF7oQqW3
         iiuSouFoG62GGcADtc8azAKYtDYI0ZnCIVLXLENOWEvJtP9dEhgy+GyDXB3JKS+l2fGx
         bxF0NSqOMUp/P8+SkU3s5luJjeEhP2lfKWf+pC10hdkDrEXp60OzkmeLn09PzpY01EkY
         MwgDB4TUg62M7QnU/rsSmTQOq5JnBOcV5FU9fgHyN1JZK6xeFZDJ6PchjKtIM6/g/M7c
         AXXVv6RED3VXkyertnMsUGPB/xvLGiikQh4Jzj9aP3M/2EMPl4c4y4bnyySk5m25IxHj
         ZNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m2ikj+dhQ1Zeha09QctzFr3Pm7l2AwdyE1EcOPpxBQc=;
        b=ZbrisRoVOi0LnHsBu+i96wFrBr8cc7B4DhyxJrtlEPDsi+SQrQw2CIBbsHcam4T0LL
         KYRkyT8X3CgzqptOQ5M+RwIy59stmGNuVWiPw6Cp7jwreCdAKRfsfSRHK93arEK4+Fz1
         wBrEE6rMyIsUsviDtnriaQukgxKzOpW1GHqyLjBW+9YTpwC9aniTkpAV9f9zf4vt1gxm
         ylkhIL2507VZP0f9+lwPCnZ207n2Z2odqYR6oC0E9uG4ggrHKg5wa5u3P9wHqATX4vZ4
         iVJ25YP6aXy8s7Nvsft/Uj9rkZWH0uC8OOrNNJ5sElc3twFw8nG58kY2AcJ+txhjoc0G
         L3xQ==
X-Gm-Message-State: AOAM531Vl4FnKZmGQQrQf98nZwvnzTKTRNhkephQa/rxK2aSEIpVbtg1
        2iPwO/yF6g8eRMkkWRocu7AUTA==
X-Google-Smtp-Source: ABdhPJwvKcFeOxhAGZIOl2LHYhbvs+cPksUqs/XQ2W4u8LoRrqAy/FNPpiVpDIX+qAcFGl6qizbLQA==
X-Received: by 2002:adf:ce12:: with SMTP id p18mr20784973wrn.52.1604330447426;
        Mon, 02 Nov 2020 07:20:47 -0800 (PST)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id b18sm15138014wmj.41.2020.11.02.07.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 07:20:46 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 3/8] vhost: vringh: use krealloc_array()
Date:   Mon,  2 Nov 2020 16:20:32 +0100
Message-Id: <20201102152037.963-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201102152037.963-1-brgl@bgdev.pl>
References: <20201102152037.963-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vringh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 8bd8b403f087..08a0e1c842df 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -198,7 +198,8 @@ static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
 
 	flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
 	if (flag)
-		new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
+		new = krealloc_array(iov->iov, new_num,
+				     sizeof(struct iovec), gfp);
 	else {
 		new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
 		if (new) {
-- 
2.29.1

