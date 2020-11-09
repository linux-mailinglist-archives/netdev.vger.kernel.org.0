Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308DB2AB5E8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgKILHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729515AbgKILHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:07:04 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A36C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 03:07:04 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id p8so7416408wrx.5
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X2Rt2FzEDhfwvo5anIXOq/hUQeEl4/lxGNeKa+o6J0w=;
        b=aox5vh8ytYutbWVc26/liVn7Z8hEPu2nlIMQId7oA48asO+6m3jeTPz78Xi5tKvZ5M
         bwqHNNDNK70TD0NuDOZApqzQQQIxd7lpVAV+s12r5UTEgNsP0LLtTP/8WwzPWY/N5W3F
         Npda/QnMuuCjfODUnOM6c1KUKnZ4sERDBgsxwJiNxobq6BnhL/yQBZO223GeqTICPw9m
         vPcqcg/xsiMtQw2qzDEvFh+x8itNf6+A8g+1ljb0/aVhzJkxBCaUC9gPqB0T/1iCSeAD
         Up5ueADAnhN5fgjIVO2va7mHiOxvK3gevDqJSukErF5i8yrzIC+ShGo5F2g2sSe+Tv4s
         iVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X2Rt2FzEDhfwvo5anIXOq/hUQeEl4/lxGNeKa+o6J0w=;
        b=aOH89vWuIxfDPgGYuFMkDpvgXEqmJXY6K5/HzXWyWTJQRYFKpMvUXR08WF3qlatDT9
         kzkkTOVTK2F8su3HbO7QoZ2BMfeC1Hi2U7ps/OquVxhCjkxeZTeER1TUDDOhiZz999qV
         NF5cRQwNG/kMq5Vv1/JWn0vdbyDdYeTPteyQREHal4pEwHL7+DDxu2n+LPD3aVeMw+yq
         x0syozfcpaCoWWqsKpH9hg1NDWLT2AYum7U2louWz9InQdzGlDXyfLQL8TqsPtgUwTT/
         c9WHnHs1yVgbPOrE9lYKRQ/UwvBEJZXycGMRXPlMysLalCbFg0qRLqU/fDYy4NOSM13z
         VvJw==
X-Gm-Message-State: AOAM530By0wFA70ttLD0UYx65zfLuckIWBVZsDc8ToOc57ruPDaNXF2I
        IXi1PERo/22u24ygW/p45oC6eA==
X-Google-Smtp-Source: ABdhPJz9QUvKGU969idAKC9U5b3ocmwgTjZ8J0vtC/TaPYMbRMpLHkJeyp4aCBCLAgcQ+m/LRxWMMA==
X-Received: by 2002:adf:9066:: with SMTP id h93mr18252530wrh.166.1604920022928;
        Mon, 09 Nov 2020 03:07:02 -0800 (PST)
Received: from localhost.localdomain (lfbn-nic-1-190-206.w2-15.abo.wanadoo.fr. [2.15.39.206])
        by smtp.gmail.com with ESMTPSA id d3sm12815582wre.91.2020.11.09.03.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 03:07:02 -0800 (PST)
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
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 2/9] mm: slab: provide krealloc_array()
Date:   Mon,  9 Nov 2020 12:06:47 +0100
Message-Id: <20201109110654.12547-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201109110654.12547-1-brgl@bgdev.pl>
References: <20201109110654.12547-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

When allocating an array of elements, users should check for
multiplication overflow or preferably use one of the provided helpers
like: kmalloc_array().

There's no krealloc_array() counterpart but there are many users who use
regular krealloc() to reallocate arrays. Let's provide an actual
krealloc_array() implementation.

While at it: add some documentation regarding krealloc.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 Documentation/core-api/memory-allocation.rst |  4 ++++
 include/linux/slab.h                         | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 4446a1ac36cc..5954ddf6ee13 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -147,6 +147,10 @@ The address of a chunk allocated with `kmalloc` is aligned to at least
 ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
 alignment is also guaranteed to be at least the respective size.
 
+Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
+to kmalloc_array(): a helper for resizing arrays is provided in the form of
+krealloc_array().
+
 For large allocations you can use vmalloc() and vzalloc(), or directly
 request pages from the page allocator. The memory allocated by `vmalloc`
 and related functions is not physically contiguous.
diff --git a/include/linux/slab.h b/include/linux/slab.h
index dd6897f62010..be4ba5867ac5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -592,6 +592,24 @@ static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 	return __kmalloc(bytes, flags);
 }
 
+/**
+ * krealloc_array - reallocate memory for an array.
+ * @p: pointer to the memory chunk to reallocate
+ * @new_n: new number of elements to alloc
+ * @new_size: new size of a single member of the array
+ * @flags: the type of memory to allocate (see kmalloc)
+ */
+static __must_check inline void *
+krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
+		return NULL;
+
+	return krealloc(p, bytes, flags);
+}
+
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
  * @n: number of elements.
-- 
2.29.1

