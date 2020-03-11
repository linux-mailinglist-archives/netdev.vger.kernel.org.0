Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840CC180E1D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 03:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgCKCmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 22:42:46 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41925 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbgCKCmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 22:42:46 -0400
Received: by mail-yw1-f68.google.com with SMTP id p124so643237ywc.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 19:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z34hT5bULDEZ91B4ZRD0I3GVUqGPOkD4dMmDdKPzM1w=;
        b=M0ZoqeGgG+H1m7mfw/LTqZ+immbVB/GDQ11/vgSYcolxH+Bclr5pw31gNg1OfvPjhl
         Lcg2AmQA9PWp7+Ilgnvbi9Xnr/b/kSvym5zDEKyqNjdLcqtaPeSK8Nv43jaVoIhjRQTM
         xBqlSyC8FUImBaNsGoHSklolbii9rpGHRXDSF9LYLX/k9u5Zjd4saXv5EhluzJIYsxvA
         PwhH9biQ+OmTw3CPxCfBAt9HI2eCugdQb8KerivL+FD4kkjm99VXnJtYggu0LnAATs3T
         PE6PXMino1OW0mK1qDUlm3w3fqky5KSppx+ugvCuJbhAQI7ap2hXZ+0qx9qe/nbjw8el
         SDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z34hT5bULDEZ91B4ZRD0I3GVUqGPOkD4dMmDdKPzM1w=;
        b=E1rtgCYgOIq/m9A+YfdOSw7qbZKPJhe3Q6tnLjMRkN6BWPr8+yWAXlQiaJnUJ0umbx
         KGE74lDen2lG8fzksBVrX8NxVd+h2LsmPJe41Fek6m/UJSi7A4t+SD+v9TAW5Qijxux5
         Nu+JBved7TJ/Kz4SuhCAZlC8UGZTq6fokXPqX3Jl/09L2M+k5Kt3cTiV5Ofk6S5t0pcR
         6gOz5qv3Vp07k+I15AcedzdS522Qy3FtwQ8PZLwyW0lDZ8tvQxnt7Jy44GiO+4gDgvp+
         S1/KyK70Yxby2xGP/VVZeu7BUHT7FiTpaoPpP3HOm32A98xQKt+LOUl5YpEzBn3Bnoig
         KWaw==
X-Gm-Message-State: ANhLgQ3bHapMptRlRfkB59L/D+adkdmPXe3nk9jRYzRP9Yp5GuD80uz2
        J2YCgTJI75JbaUh8674NhiMyxw==
X-Google-Smtp-Source: ADFU+vspO2XL5NOw50R2gE7tEMV4xyqoRv+aMelSY/MVWHtUuEhnkA77KqE8WWjPSnvmSc1JOwp7wg==
X-Received: by 2002:a25:9ac5:: with SMTP id t5mr809418ybo.305.1583894564945;
        Tue, 10 Mar 2020 19:42:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x81sm19262510ywa.96.2020.03.10.19.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 19:42:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
Date:   Tue, 10 Mar 2020 21:42:40 -0500
Message-Id: <20200311024240.26834-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define FIELD_MAX(), which supplies the maximum value that can be
represented by a field value.  Define field_max() as well, to go
along with the lower-case forms of the field mask functions.

Signed-off-by: Alex Elder <elder@linaro.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v3: Rebased on latest netdev-next/master.

David, please take this into net-next as soon as possible.  When the
IPA code was merged the other day this prerequisite patch was not
included, and as a result the IPA driver fails to build.  Thank you.

  See: https://lkml.org/lkml/2020/3/10/1839

					-Alex

 include/linux/bitfield.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 4bbb5f1c8b5b..48ea093ff04c 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -55,6 +55,19 @@
 					      (1ULL << __bf_shf(_mask))); \
 	})
 
+/**
+ * FIELD_MAX() - produce the maximum value representable by a field
+ * @_mask: shifted mask defining the field's length and position
+ *
+ * FIELD_MAX() returns the maximum value that can be held in the field
+ * specified by @_mask.
+ */
+#define FIELD_MAX(_mask)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_MAX: ");	\
+		(typeof(_mask))((_mask) >> __bf_shf(_mask));		\
+	})
+
 /**
  * FIELD_FIT() - check if value fits in the field
  * @_mask: shifted mask defining the field's length and position
@@ -110,6 +123,7 @@ static __always_inline u64 field_mask(u64 field)
 {
 	return field / field_multiplier(field);
 }
+#define field_max(field)	((typeof(field))field_mask(field))
 #define ____MAKE_OP(type,base,to,from)					\
 static __always_inline __##type type##_encode_bits(base v, base field)	\
 {									\
-- 
2.20.1

