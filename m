Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715FB1E63CF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391150AbgE1OXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391111AbgE1OW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:22:56 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847CEC08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:22:55 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j198so4620917wmj.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bUTqIyJQ96SSMI0A1T4YUDc+Z+dd4WsNKtNtEYEWK4U=;
        b=upvfkJpE+j2X8Py5StpA9JlDlz2G9d49LnZEOgNJpWo/0I87+o9/l2XXA6HKaXcNac
         bXBCxrNiF435IihMwKsSZiyIuVjmiev2lr80Ts7YvZxkr2y+Ny3q+KKL2LEWFCP4f2Mn
         jDCBpYaiitFDb9cI/2Qsa+yvmMxX7nEjTCkgmHspXj8M19pq6FYicVh5ufEf3GsndFsC
         3sImHWzerLDxh1w42NoP5PX14EUb5k9D/VNKWVIobkFk8O77pL77IyOg7lrb757twjpi
         QsnvGsOfA4hIJLkF9gCVphVrXvKu4hwwk8x1d2eQE56DXo5ckQKHQI6aiKdnddEUBnxD
         tqoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bUTqIyJQ96SSMI0A1T4YUDc+Z+dd4WsNKtNtEYEWK4U=;
        b=a0Z4vsEasFol1ib4NJOUzBPKEdAQX/wY4XCUxgnzqxwVv1M+WCwwf4dB705xH3jJMU
         EuM1XiRSH+GBWd5L//hrsco2UlWI7KahgSRfdNGxdy2NU9f9R1zINrWUrpDnBoMST6oj
         b8bB/8V8K9WvaU5ZvcP5c5ttrr6R2HxvRJtvXkNWHrt2+991T8FP8G7AwrJrqhkSm69S
         KTwtEAvPrk6TtfGvBG58WV8+1b3KtSw0fGNMpFbIPqHLRM04yAFNDjLYnYxVJ4vZjUZq
         Dmts777YQjn9844aU/Qi4tLbD/mmSBPP33lBRrH7N916cb1YN8Tzq4UVKBzSPk0M+XC0
         hHLg==
X-Gm-Message-State: AOAM533IO0TmQXCSE0vmZkOQLW5Uvy6YSHSjaYtHsf3K3495L1MJOxYz
        DpNr9GIPMPZG+/SBKGsDkKz5zw==
X-Google-Smtp-Source: ABdhPJyl+FBJZedD5liWJOKutUX+saEOEFndp/bsIsFCtM6wE+3IrguyrR+0NAJOMR+t886hi1rjXQ==
X-Received: by 2002:a7b:c086:: with SMTP id r6mr3540234wmh.29.1590675773653;
        Thu, 28 May 2020 07:22:53 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h74sm6258162wrh.76.2020.05.28.07.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:22:53 -0700 (PDT)
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
Subject: [PATCH v2 1/2] regmap: provide helpers for simple bit operations
Date:   Thu, 28 May 2020 16:22:40 +0200
Message-Id: <20200528142241.20466-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200528142241.20466-1-brgl@bgdev.pl>
References: <20200528142241.20466-1-brgl@bgdev.pl>
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
clear_bits and test_bits.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/base/regmap/regmap.c | 22 ++++++++++++++++++++++
 include/linux/regmap.h       | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 59f911e57719..30f659e0b4e4 100644
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
+	return (val & bits) == bits ? 1 : 0;
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

