Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660221E6687
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404614AbgE1Pp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404522AbgE1PpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 11:45:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A29C08C5C8
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 08:45:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l10so5691800wrr.10
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bqViQ9O7yTT1lgzVQrGPraM7Z4Hz1E/DmaF8sGIg+iU=;
        b=Lz/Ir6YYZ1FaaBpnkUI+cMYlywvXzGXow6KMrv4fZdA7/bgI4AbB23N78iA7MFyp2p
         LvnyLynD7rqEMo0nz3JXHbUIf4JazglS82LMO7DvDpJz/fVU1TcVgS09Dup9yOmn5wVS
         KL5+ITKGh5QNC2uugt7BU6Efi/LHQXySdc7wLKdh+Pr3d4FAZLegm0DE9oBVR77mo1y0
         FAk0imstc1fNze/qzrVYEYKGVF7+SzYP2hXp+8GYMvhtNAK8FdjCA+ocmiHyukxsKLmR
         fdPTO09bYF9gqF+Vi7AomscvgvmjVD+/Glq0pkKK4n4azHfefXrjzrah3Ije8A9aOINv
         h4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bqViQ9O7yTT1lgzVQrGPraM7Z4Hz1E/DmaF8sGIg+iU=;
        b=Oel4lxMsuJArPPkeBRSxoI7OhCXessQFFsBQdbZo8yLxh8vd49PjKpg0fzQr4WvNFi
         /ZULbgGVlhS/bHvkmieD+agTnZqfw2SjA/mu2U/ddq/uDCgZlH8iT6CYyNhIlK1j6Hhj
         9hjZtkO41JEDz0ayUhj0U8+0rewPu2jddubJF5sv4UM3b3i6m38Kurg93WBH+CBfo90B
         grZvQ4c338DFoBmJ6YpZSJjEaLXGNU2rmP6cLsoUKgU4CzQjjApSC45Qy8BJVogmE6os
         A3BokVDBhVt67opogLQyCEms53+4F1z1tLHHjz4x+Rqnkg/GnsUa8vfv/6AL8iwMAx2X
         chVQ==
X-Gm-Message-State: AOAM531H0uRsR/8m7BufRMsWZLmBJZK1uLAyX/QA3sgxrhJXIMaD1yHA
        3JKjRHuZEZqMV9GqNazLFDohPw==
X-Google-Smtp-Source: ABdhPJxZ3c9apdw8jBteGu0AEMQp/RpPJsqo4qBOi5jFydJGbre3onqrr8gehfrvNztP9kivt1/xOA==
X-Received: by 2002:adf:e3c4:: with SMTP id k4mr4076613wrm.262.1590680708560;
        Thu, 28 May 2020 08:45:08 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id n1sm6285650wrp.10.2020.05.28.08.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 08:45:08 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 1/2] regmap: provide helpers for simple bit operations
Date:   Thu, 28 May 2020 17:45:02 +0200
Message-Id: <20200528154503.26304-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200528154503.26304-1-brgl@bgdev.pl>
References: <20200528154503.26304-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

In many instances regmap_update_bits() is used for simple bit setting
and clearing. In these cases the last argument is redundant and we can
hide it with a static inline function.

This adds three new helpers for simple bit operations: set_bits,
clear_bits and test_bits (the last one defined as a regular function).

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/base/regmap/regmap.c | 22 ++++++++++++++++++++++
 include/linux/regmap.h       | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 59f911e57719..4ad5c5adc0a3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2936,6 +2936,28 @@ int regmap_update_bits_base(struct regmap *map, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_base);
 
+/**
+ * regmap_test_bits() - Check if all specified bits are set in a register.
+ *
+ * @map: Register map to operate on
+ * @reg: Register to read from
+ * @bits: Bits to test
+ *
+ * Returns -1 if the underlying regmap_read() fails, 0 if at least one of the
+ * tested bits is not set and 1 if all tested bits are set.
+ */
+int regmap_test_bits(struct regmap *map, unsigned int reg, unsigned int bits)
+{
+	unsigned int val, ret;
+
+	ret = regmap_read(map, reg, &val);
+	if (ret)
+		return ret;
+
+	return (val & bits) == bits;
+}
+EXPORT_SYMBOL_GPL(regmap_test_bits);
+
 void regmap_async_complete_cb(struct regmap_async *async, int ret)
 {
 	struct regmap *map = async->map;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 40b07168fd8e..ddf0baff195d 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -1111,6 +1111,21 @@ bool regmap_reg_in_ranges(unsigned int reg,
 			  const struct regmap_range *ranges,
 			  unsigned int nranges);
 
+static inline int regmap_set_bits(struct regmap *map,
+				  unsigned int reg, unsigned int bits)
+{
+	return regmap_update_bits_base(map, reg, bits, bits,
+				       NULL, false, false);
+}
+
+static inline int regmap_clear_bits(struct regmap *map,
+				    unsigned int reg, unsigned int bits)
+{
+	return regmap_update_bits_base(map, reg, bits, 0, NULL, false, false);
+}
+
+int regmap_test_bits(struct regmap *map, unsigned int reg, unsigned int bits);
+
 /**
  * struct reg_field - Description of an register field
  *
@@ -1410,6 +1425,27 @@ static inline int regmap_update_bits_base(struct regmap *map, unsigned int reg,
 	return -EINVAL;
 }
 
+static inline int regmap_set_bits(struct regmap *map,
+				  unsigned int reg, unsigned int bits)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_clear_bits(struct regmap *map,
+				    unsigned int reg, unsigned int bits)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
+static inline int regmap_test_bits(struct regmap *map,
+				   unsigned int reg, unsigned int bits)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regmap_field_update_bits_base(struct regmap_field *field,
 					unsigned int mask, unsigned int val,
 					bool *change, bool async, bool force)
-- 
2.26.1

