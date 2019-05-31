Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB7230748
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfEaDx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:53:58 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:54399 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfEaDx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:53:57 -0400
Received: by mail-it1-f195.google.com with SMTP id h20so13557063itk.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r4mnV8n9h367f6/VUTN5uF0kUnyjJ6IcwlGv5KmdBDM=;
        b=uQ5CqKcdh/yUYawzZpJbRZ12LMQNtmodArP5AWBWD9vjKgkFac6xjrmwQsM1TNxDlB
         /afVEpVlc6yUnyDL44O6VpMUSZbGnJz5vY8t2TzIRYBTxXyfrA/opbRkuMh/s0FMDa10
         Yaj82guuMR8LL9IGBSM7Ugvz2Mbl6If5nbkrkAzZQCD2ne7/fQngLuOUEnSSt3p2AKCj
         T+Fle7a7mKUJ7KN0nHLDILNV5TdkKzxqJsbbO43z/DfarwmzWVJXOuJ4Nt4wxRBxM6/R
         /OIbcj6WOO07tz9PONxo9f6wd/jt6IerZF/L3gWS9w39N8TbRAm7kbZpma7Age9p10+Y
         yCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r4mnV8n9h367f6/VUTN5uF0kUnyjJ6IcwlGv5KmdBDM=;
        b=pqOJWlo+KbFwp++MJXKjc3w0SKSIAakq3f5ZnEiz/r7FlmVqm8kmSTLHFE6jM8lHYs
         3ebx0LR5jo18nXY7xEY1AAfL2n+3sONPOIxGD08111sXzgRh67zLjkZkj03zi17PdilM
         FbaP3Ag5nIBnOMnFjxp5mNyOnNyPrYtm4Ew9ksmE17m31kNlDsKk0UDwwIYHKXhPR69t
         Nk/5/rkylaeGzvP1S+DTlNpSHFkqVsQGZzJsVNIP+U4wH9MbeRDG6s0TWtoOy/WDtnST
         CC6tqzfI1FclKyAKT3GDTRmL/sZNxTlHd2VDhLQy2nbzMA+12oNCFhPRGxDkiic6wZKG
         M3EQ==
X-Gm-Message-State: APjAAAWTysLi3pgYryXARQHtuvkcLlWy60mSCYUT5sewX2hyR0t9MR+p
        UdBkR3yifmgUFPGV1yRbYNpmKA==
X-Google-Smtp-Source: APXvYqwO6awYQhmpOv3yi4OxH66vN6iPJ0929GOj5GH4pyJJakg8VatINo8iNHYSqyTX8R1QdVMheQ==
X-Received: by 2002:a24:b07:: with SMTP id 7mr2381324itd.59.1559274836720;
        Thu, 30 May 2019 20:53:56 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.53.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:53:56 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 01/17] bitfield.h: add FIELD_MAX() and field_max()
Date:   Thu, 30 May 2019 22:53:32 -0500
Message-Id: <20190531035348.7194-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
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
---
 include/linux/bitfield.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 3f1ef4450a7c..cf4f06774520 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -63,6 +63,19 @@
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
@@ -118,6 +131,7 @@ static __always_inline u64 field_mask(u64 field)
 {
 	return field / field_multiplier(field);
 }
+#define field_max(field)	((typeof(field))field_mask(field))
 #define ____MAKE_OP(type,base,to,from)					\
 static __always_inline __##type type##_encode_bits(base v, base field)	\
 {									\
-- 
2.20.1

