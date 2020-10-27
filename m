Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67E629ABE2
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411653AbgJ0MRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:17:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36081 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411635AbgJ0MRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:17:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id e2so1214070wme.1
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJP6zUa9eBmdV8bx1jdaWyKmaK9MsWkK16il5Qo0OrM=;
        b=P+3tCIHOjCZAx0wmilW2GDFvIGyFUKkJ6kMCnuzTaqTK/WVy0FTiGFvqMSEeEaTSDi
         lidtNcACGQa4FsZTJSv/WM+PJAWcMBZ84eqrsFS5cBt5SmJFi36Zt8P8jQqLDmjkvqeW
         khRH3E+peGeaQTCIY3Vt2p8gYCX0QOu5toB/kJmHKtw/28SJ6BKumTSSq2MJytdIAdgp
         oJxR5uAJUIN5EhwIO49GT3ZmC5B5ob3NU85YWSk0gy8yt2me9ot389ODzNeNzE1g7isf
         BjKSBXgUK2OMn2MduiDvTrDfwsn8XX/eMtY9lahl6HLlIYN8j7wdAJNYVoPtfuaoSs+h
         PRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJP6zUa9eBmdV8bx1jdaWyKmaK9MsWkK16il5Qo0OrM=;
        b=hCYmwVYx5zR1px4iYfH84Ljsril4Rjwpkuu5qmL4OTrKJhn6SOnMX7NTbuaQrm8jRP
         tmP+qTs/qJNn6lhoYABzV5dM4suXETIhbsRji25Yt1Yre3kNTxUv5gDlqKHmyy0mWtSM
         xELIKm424pwYKXHk0s40S3shchqz9j8RmeryQ1NFby+Uv9ZIRMeeqrZeMIRWKLykQjnj
         JO5Lzd074SDphY8+QhSdw5kGLhHVrasazwTfGkj7BqkgLdRkEJb5PGns2I4Rizkg9aSa
         rwg0euB9pXhf3TsUQBgq85jNROb9xjgCqMrabZsVMGa64B3RKxWA+W9paSV11y7v9Tgo
         Qj1A==
X-Gm-Message-State: AOAM532Szk1zxGy/66wiuNSKtoFVyJZy/SaIGbxjWF9OBdAGd82mL5rR
        nK1JOWsttqAEGGT6n8GIikYUAA==
X-Google-Smtp-Source: ABdhPJxUDPfM7/G4w39/lM3kfVBbiG37Et7vUzW73qIzYGjUaK5vAjNfvCioGZotPrXrgX+P7fvBjA==
X-Received: by 2002:a1c:8087:: with SMTP id b129mr2477389wmd.10.1603801056147;
        Tue, 27 Oct 2020 05:17:36 -0700 (PDT)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id a2sm1731908wrs.55.2020.10.27.05.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:17:35 -0700 (PDT)
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
Subject: [PATCH 0/8] slab: provide and use krealloc_array()
Date:   Tue, 27 Oct 2020 13:17:17 +0100
Message-Id: <20201027121725.24660-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Andy brought to my attention the fact that users allocating an array of
equally sized elements should check if the size multiplication doesn't
overflow. This is why we have helpers like kmalloc_array().

However we don't have krealloc_array() equivalent and there are many
users who do their own multiplication when calling krealloc() for arrays.

This series provides krealloc_array() and uses it in a couple places.

A separate series will follow adding devm_krealloc_array() which is
needed in the xilinx adc driver.

Bartosz Golaszewski (8):
  mm: slab: provide krealloc_array()
  ALSA: pcm: use krealloc_array()
  vhost: vringh: use krealloc_array()
  pinctrl: use krealloc_array()
  edac: ghes: use krealloc_array()
  drm: atomic: use krealloc_array()
  hwtracing: intel: use krealloc_array()
  dma-buf: use krealloc_array()

 drivers/dma-buf/sync_file.c      |  4 ++--
 drivers/edac/ghes_edac.c         |  4 ++--
 drivers/gpu/drm/drm_atomic.c     |  3 ++-
 drivers/hwtracing/intel_th/msu.c |  2 +-
 drivers/pinctrl/pinctrl-utils.c  |  2 +-
 drivers/vhost/vringh.c           |  3 ++-
 include/linux/slab.h             | 11 +++++++++++
 sound/core/pcm_lib.c             |  4 ++--
 8 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.29.1

