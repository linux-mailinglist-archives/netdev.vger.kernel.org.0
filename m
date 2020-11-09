Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E02AB5EF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgKILH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgKILHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:07:17 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8677DC0617A7
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 03:07:16 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id c17so8204697wrc.11
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uU00Tfvm+17A7iE8x45GJfsjWZ/7CO3W5FPvjO+v7UE=;
        b=RG2F+82oEqldWg6NTKGoC7UPk0O3vTxH9eTGTjyarUGvACcl6LwiyVBskaFEt1Pqm6
         qMxcfA0KMfkW5wNV3g6IT+hgAs2iqXACJ3N3dvfqSrCeZzUAOMwEc5r60U68oM/abbdp
         BVvztISZFGbho3XV9t5SL1u/kBS3vwLpauBxX0yXvm1ttFGAsQfYFHV+KUfWm52I7cCD
         8gCnDBCe0CgXSwSibJtmk6kjahUuLaDNlL9UchomHElEtgRdetA4QUIzhJ3s2kqYQJIy
         hMGwQ19uDlTKAD9Oe+7Y24DOg21aGPiQwGkonVuLgyYUV5H0Om/MAWDetrgEg+DE7LJv
         /kLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uU00Tfvm+17A7iE8x45GJfsjWZ/7CO3W5FPvjO+v7UE=;
        b=rfGj3cR/Qw1N2ApOYf2jWarQ51UHBzJE1ps/QBoCEGAr2f+g4g00Bu/Yb2ndfNKkhH
         Vt9slpbrWu0N7PhxcFlGkcMPxEHONgEVsZhiHFfsw0MMLCHCnri6HTZxaD297OFpu78G
         CQRe/O+VHVAHDLsKVLZ+lDCNfAOAEvSpKu2b3vmEBkk7SONFvNlCgR8y06nv8xHOj9mn
         JqHwbMWWo5dZqS7aboBz+oIc2hdRLFyOE8ZYpTUQR6rZGaCAshK24IKe3T9BgMlGERcz
         axaxSJUOf/tjzDRhQFWgQ52WOTMD8eJAMFv9eBiJu1aHy6TP4wZIerC3TwLAqNSoqhfk
         5eOA==
X-Gm-Message-State: AOAM530fz9L2xEWFBitMQHSN0OFdCSR1bc/KE5p4kcund2H9y6SFoFDM
        jNVMXtTwCtuuwjkFYWydneCPoQ==
X-Google-Smtp-Source: ABdhPJxqEseYvyvPu8S4NoqtIS4iNC5GkWi9kRY0f7fjCzxFROga8iAwMRGM7mBzZtGU9vsmm1Ko/Q==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr9918092wru.397.1604920035266;
        Mon, 09 Nov 2020 03:07:15 -0800 (PST)
Received: from localhost.localdomain (lfbn-nic-1-190-206.w2-15.abo.wanadoo.fr. [2.15.39.206])
        by smtp.gmail.com with ESMTPSA id d3sm12815582wre.91.2020.11.09.03.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 03:07:14 -0800 (PST)
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
Subject: [PATCH v3 9/9] dma-buf: use krealloc_array()
Date:   Mon,  9 Nov 2020 12:06:54 +0100
Message-Id: <20201109110654.12547-10-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201109110654.12547-1-brgl@bgdev.pl>
References: <20201109110654.12547-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/sync_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index 5a5a1da01a00..20d9bddbb985 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -270,8 +270,7 @@ static struct sync_file *sync_file_merge(const char *name, struct sync_file *a,
 		fences[i++] = dma_fence_get(a_fences[0]);
 
 	if (num_fences > i) {
-		nfences = krealloc(fences, i * sizeof(*fences),
-				  GFP_KERNEL);
+		nfences = krealloc_array(fences, i, sizeof(*fences), GFP_KERNEL);
 		if (!nfences)
 			goto err;
 
-- 
2.29.1

