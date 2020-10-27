Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CDB29ABB7
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750915AbgJ0MSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:18:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35635 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbgJ0MRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:17:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id h22so1205550wmb.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J57Co4keOJLPpkOAtm30WeNaGboSbDo7KGbxSzSraLw=;
        b=yOHWFHMOzbagC0sIByz6wesCWV3cXS/nI3Cmoh9rPQnQfktOmQ2fHmfj8t5QiyPB1i
         JUphXOi/RvRU2h+y1C0PS56sy6nIPSViAjZH7ZD1nL0kVb70/VdVHhj/AlJj5MwbzGtT
         Fz4SQHpcI/4fYul/80WnINgeUHB50rR1cTYD2+ptya0cZz6H6MnTFFgMAr7/MnsWRrjc
         rDDqtu/ht+rkyImTxS5uHgJepl4JUTv6GjjiiaPzGql9lSo9xdd048jkI/Kvk/PDUJaD
         tXJ1HdRkottcOLQk8yrpkIleD3Wyxw+1fcCHjnYdEOneZJMoeya+bL6uoh2P347Mm79Q
         Or/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J57Co4keOJLPpkOAtm30WeNaGboSbDo7KGbxSzSraLw=;
        b=hrceelV/RKHfNh1fUGd9qSGcRRMZglVRaQKLd4Px88Z/REfJ7pH9o56lYIMw4WbOI1
         scHDOZ6aB1/uBeZkkexwlYuP/b2J6aFNZb98ev7oMCpe2+7qZK9wba+D428/hqKl6o6o
         mb0et6Z44uXJfWu0pXJcGjEExh7+fr3Ypi3vwEJZeeOgEjoX1O/KhB8hR0ialBqLdt4a
         pNQwPewt3umiQKS1oYnLYmTGW1k1x+oXb8OpNwAtzoujgVyW6HW2ht6xbiWZWKpN3p94
         8FMykl50w3X77c/cWrESmLaRSDTWB4C9ieeNhQYS9NwoVUZJBqAiJu3pF5naXfjlOTWm
         liAA==
X-Gm-Message-State: AOAM531U2a4Qt5iAdx4iPZXTHxNXcfsr+UzMBgqywiVQ8Ai5IP/Czx8A
        x2A3zJMXyAf2sgpnIwC3qA88tw==
X-Google-Smtp-Source: ABdhPJzwzTmHdRfbZ3iyfMT0YC13fJkeiYScFTFd2MhD0PJKT6LJ0wGB9w/fQb4FZN9R2w5rbG6dAQ==
X-Received: by 2002:a7b:c92c:: with SMTP id h12mr2566357wml.134.1603801070666;
        Tue, 27 Oct 2020 05:17:50 -0700 (PDT)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id a2sm1731908wrs.55.2020.10.27.05.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:17:49 -0700 (PDT)
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
Subject: [PATCH 7/8] hwtracing: intel: use krealloc_array()
Date:   Tue, 27 Oct 2020 13:17:24 +0100
Message-Id: <20201027121725.24660-8-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027121725.24660-1-brgl@bgdev.pl>
References: <20201027121725.24660-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwtracing/intel_th/msu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 3a77551fb4fc..7d95242db900 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -2002,7 +2002,7 @@ nr_pages_store(struct device *dev, struct device_attribute *attr,
 		}
 
 		nr_wins++;
-		rewin = krealloc(win, sizeof(*win) * nr_wins, GFP_KERNEL);
+		rewin = krealloc_array(win, nr_wins, sizeof(*win), GFP_KERNEL);
 		if (!rewin) {
 			kfree(win);
 			return -ENOMEM;
-- 
2.29.1

