Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB182A2E35
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgKBPV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgKBPUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:20:47 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A651FC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:20:46 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id b8so15092645wrn.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 07:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsoLpTPvbfDjEd3BTKWBJg3n1+l4gj6JVB0+8bMwSMU=;
        b=HmtPp910xThA01pL3B9QJDzM6myxOQbI+Gxv1vc6oac7iOA0ZXJQlHuq/+mHtde0X+
         OfcMSK5kznkjMW2e37tU9WeWtUF/ehvgMx77Hvy2j/YhuAWr2JWWTq+2rF5jNonVIGbD
         cCSqCJ03TKw0ntRupzKEmRuIb7vqNrbM7ZjMJ1dyUUTFAq7QYOcoPlQY6BSvbU5ivx1u
         2ja7v3leUJx7kGjq4+D8hYbHBwnlqSZkHzw7OQggIsENJu2wboHE39wVaYvHlfopqTaz
         gmSuc/NRG00fKNAAatDeqOG57nb8eBHuWtuyK6Mk/YJvrj1Yz6MBIwM8xHmW9fbnRR1V
         p5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsoLpTPvbfDjEd3BTKWBJg3n1+l4gj6JVB0+8bMwSMU=;
        b=iaC+Ll67ztDhEQWxTrjtyY7dX9z4ECCaROimVgVNyLM2mt7/6MEPs7Xb5xtajvZTSS
         EzmZzh+YBAcV4E5+0O35gK3zRFEizid1SdnfXT5FsPnYg6RqMf0tH+bTgQch7MJFj/WB
         2ZvBEtsHbeO9Hy2HKgM9eWAEfm/6fwx3qBLJNkKLhiw0lPklc37UhogD2d5WOTJBBA0Z
         axExlL+a6XLMb9dGZlJm3vXWwHf5LDIQMuXDDjlHDMLGSu61WBwdb5R8W8TeVNmASFXD
         LtzJ3QR7iJ+PHEG8g7YfMyHi2t6NTuFI2PQsViqwZbBcZ49o2DKD7AUw7xrAK39a3z/m
         sXGA==
X-Gm-Message-State: AOAM531kK3kPHdtAeCYHl51+y2VLEET2KCXeAb2C4x31KzXvlfk9XHkb
        2BHwBWJgpx4razWHw5KN11BlTA==
X-Google-Smtp-Source: ABdhPJwlFwfWfCpdDsl2PScT66d3xFr7tIJPKogPvk6kP2iU+Xbqm7qx9Peryv+18kqHISpx03BO0g==
X-Received: by 2002:adf:f3c4:: with SMTP id g4mr22117429wrp.207.1604330445459;
        Mon, 02 Nov 2020 07:20:45 -0800 (PST)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id b18sm15138014wmj.41.2020.11.02.07.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 07:20:44 -0800 (PST)
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
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v2 2/8] ALSA: pcm: use krealloc_array()
Date:   Mon,  2 Nov 2020 16:20:31 +0100
Message-Id: <20201102152037.963-3-brgl@bgdev.pl>
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
Reviewed-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/pcm_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index d531e1bc2b81..c6f8f9e252e0 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1129,8 +1129,8 @@ int snd_pcm_hw_rule_add(struct snd_pcm_runtime *runtime, unsigned int cond,
 	if (constrs->rules_num >= constrs->rules_all) {
 		struct snd_pcm_hw_rule *new;
 		unsigned int new_rules = constrs->rules_all + 16;
-		new = krealloc(constrs->rules, new_rules * sizeof(*c),
-			       GFP_KERNEL);
+		new = krealloc_array(constrs->rules, new_rules,
+				     sizeof(*c), GFP_KERNEL);
 		if (!new) {
 			va_end(args);
 			return -ENOMEM;
-- 
2.29.1

