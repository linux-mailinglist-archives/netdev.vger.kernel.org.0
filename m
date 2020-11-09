Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05992AB5E5
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgKILHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729510AbgKILHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:07:02 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AA1C0613D4
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 03:07:02 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id p8so7416318wrx.5
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2uLK4LNo7fJGEwA0NXfYaAQzvkTW8/WkGHuVu61FcZ4=;
        b=SLmwWdYmA2Su0OyL+219YDZzeVXOkzpy5gortE6aVnwng+6cHrJzhAQJzNByqcPbPZ
         isbE6V3Lb9JgstbUlm/PZvCpNxelIDnwHLTINtWIzMAUAJP+6YLk/AWf+cW33RVJOvLq
         4EQlOOLu8zd+gVrxvr0w9485FxLsZ4uiV1jlwgDMS4E7kDkszYjvid4w0z806pFvA1dO
         U+nHioEgRrLmfLyR8tH/H/Ge3+qH76H09ubPywZEg/u4KcGzZ6YzgnyKXZKxxyWIo1cW
         FT3Tuwvxb43JhyG0QmKnG/8uRrjp2S/bO4jEisldpzuA8EOA5eJuEswwYg/l6KV0K70j
         EAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2uLK4LNo7fJGEwA0NXfYaAQzvkTW8/WkGHuVu61FcZ4=;
        b=F7nG4lYE2tRgCMo78hRYYY+2+hbl8FECEXSW0wgjPRd1zcRzJscVGGBqSr01XEona6
         pnamBeHiBhYDCljQC8Dn79H3sY3PQQON/fvelyFy5afAi8YVzm17t4dMnNbqsEt/YhOC
         7sg5v1UTniGLt/I2pLeIXmFkLjL85whvo7M0lwakM3+A7XwBKeQw3ejt3Vnll+vcDsD4
         QQji1J90bQyPY7c7iC//Agn1eWosp/KB27fHySw16NXNNXQHmSewD9InPgpQPFyfVCWE
         AP7iziVZVE7jX66nO5cOoz1PbU8Hyhr5xjFPKWOtNF6ZMu/2Tck3GP3i5f6FJzWqaPQK
         V5dg==
X-Gm-Message-State: AOAM530LdMSihpxnjB0+uA1KU1Z7L+iECCfjzvmQYtGldxV+OGNFY3/Q
        ABv6mp6Szc1GmsPYtudFNxcrkg==
X-Google-Smtp-Source: ABdhPJwC1VmwvlzIaWje0LLMyGfNJlg7DPW07nQhl2YWyOW+KS6oIpzkSUqvI/A14QOWWdg2F+P+tA==
X-Received: by 2002:adf:9b98:: with SMTP id d24mr16961027wrc.17.1604920021208;
        Mon, 09 Nov 2020 03:07:01 -0800 (PST)
Received: from localhost.localdomain (lfbn-nic-1-190-206.w2-15.abo.wanadoo.fr. [2.15.39.206])
        by smtp.gmail.com with ESMTPSA id d3sm12815582wre.91.2020.11.09.03.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 03:07:00 -0800 (PST)
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
Subject: [PATCH v3 1/9] mm: slab: clarify krealloc()'s behavior with __GFP_ZERO
Date:   Mon,  9 Nov 2020 12:06:46 +0100
Message-Id: <20201109110654.12547-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201109110654.12547-1-brgl@bgdev.pl>
References: <20201109110654.12547-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

__GFP_ZERO is ignored by krealloc() (unless we fall-back to kmalloc()
path, in which case it's honored). Point that out in the kerneldoc.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 mm/slab_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index f9ccd5dc13f3..d6df73f79204 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1091,9 +1091,9 @@ static __always_inline void *__do_krealloc(const void *p, size_t new_size,
  * @flags: the type of memory to allocate.
  *
  * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
+ * lesser of the new and old sizes (__GFP_ZERO flag is effectively ignored).
+ * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
+ * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
  *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
-- 
2.29.1

