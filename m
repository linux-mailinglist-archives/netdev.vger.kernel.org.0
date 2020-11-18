Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE482B8836
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgKRXJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKRXJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:09:38 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80508C0613D4;
        Wed, 18 Nov 2020 15:09:55 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id r18so2411539pgu.6;
        Wed, 18 Nov 2020 15:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S4SV7UWqaAO4+KNigQEQ+xlXa5i4hvXUtpTZN2jrHlA=;
        b=uMnzVzhmPlLPZ0/M2t6pQ+/a395zQleD37ySHopmwQHi4ghvFtsIYAuEEUi6scn2oE
         WjTuRb77VxCgNSlatY0O5bWDL2EiY+PXnJbPwJaluV4vC2qtJKuzyyJMxCW/ucs4NyKe
         D6UQC1mlWQe/JZJGxrieQSi4pgLDj+AeWS5cTJzd96Usyo+5jw+yzp2wMIDEU2Q9ZqsZ
         ICJCcPd5L9Du5QfGItxLs1Jhao0h5CbGZLyD+J5V3qIdveZ3hSKzNiEmBUhjBP8agbM6
         YzZytOLol+oTy2zCVuyaCvIhJkmTPA3GMplkkuDpFGzSVcWrWuWLHLy2h6EiPXUMw4ib
         rC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S4SV7UWqaAO4+KNigQEQ+xlXa5i4hvXUtpTZN2jrHlA=;
        b=OxUuXGgP3oKdli648U7oXIwkzQ+WirCZUT9SBwEhqZTR40uII0QSTJsadsVP+kI8Gm
         u/dskVQjGSFebyeQOZTFDoW6qff20mWZuhkc9ys+R0tb1K2L84g+zyIiWuL+IzWIi9Am
         DMEaDpCzvzxBEolr4JnUTF2E+0dSdnmlPMxtl16L605ai4lRecubK41vInvf1aN1OlZl
         NVY1z76rXzTYfI13OAdNPZ+h942QTrjXhz4Tj1hn6dAEjaOWRfN82fPlsRby4eT365lS
         FqGoQ1wU81FdBd9539PnLHgYQ+DjGAZoeQmdmpPvGxHydaU/CKrNshZMu92b8rBzHFaa
         PMKg==
X-Gm-Message-State: AOAM533X7DpfEF59+ntSPHg5CD/RKi/UZj6ZUA/DtO0Ub5lSZ2de7Fzu
        2RFepkL8MEk9xi8KKNirwoY=
X-Google-Smtp-Source: ABdhPJzu9wrEysVlRm1/cjj7lif5xoT+FkSGrGUKs2fsSy8kVxEFM/1XL01MQtqHSGgEVT7zhSxWRg==
X-Received: by 2002:a63:154e:: with SMTP id 14mr10380799pgv.49.1605740995078;
        Wed, 18 Nov 2020 15:09:55 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id b21sm2565304pji.24.2020.11.18.15.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:09:54 -0800 (PST)
From:   rentao.bupt@gmail.com
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH v2 2/2] docs: hwmon: Document max127 driver
Date:   Wed, 18 Nov 2020 15:09:29 -0800
Message-Id: <20201118230929.18147-3-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201118230929.18147-1-rentao.bupt@gmail.com>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Add documentation for the max127 hardware monitoring driver.

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 Changes in v2:
   - add more description for min/max sysfs nodes.
   - convert values from volt to millivolt in the document.

 Documentation/hwmon/index.rst  |  1 +
 Documentation/hwmon/max127.rst | 45 ++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 Documentation/hwmon/max127.rst

diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
index 408760d13813..0a07b6000c20 100644
--- a/Documentation/hwmon/index.rst
+++ b/Documentation/hwmon/index.rst
@@ -111,6 +111,7 @@ Hardware Monitoring Kernel Drivers
    ltc4245
    ltc4260
    ltc4261
+   max127
    max16064
    max16065
    max1619
diff --git a/Documentation/hwmon/max127.rst b/Documentation/hwmon/max127.rst
new file mode 100644
index 000000000000..dc192dd9c37c
--- /dev/null
+++ b/Documentation/hwmon/max127.rst
@@ -0,0 +1,45 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Kernel driver max127
+====================
+
+Author:
+
+  * Tao Ren <rentao.bupt@gmail.com>
+
+Supported chips:
+
+  * Maxim MAX127
+
+    Prefix: 'max127'
+
+    Datasheet: https://datasheets.maximintegrated.com/en/ds/MAX127-MAX128.pdf
+
+Description
+-----------
+
+The MAX127 is a multirange, 12-bit data acquisition system (DAS) providing
+8 analog input channels that are independently software programmable for
+a variety of ranges. The available ranges are {0,5V}, {0,10V}, {-5,5V}
+and {-10,10V}.
+
+The MAX127 features a 2-wire, I2C-compatible serial interface that allows
+communication among multiple devices using SDA and SCL lines.
+
+Sysfs interface
+---------------
+
+  ============== ==============================================================
+  in[0-7]_input  The input voltage (in mV) of the corresponding channel.
+		 RO
+
+  in[0-7]_min    The lower input limit (in mV) for the corresponding channel.
+		 ADC range and LSB will be updated when the limit is changed.
+		 For the MAX127, it will be adjusted to -10000, -5000, or 0.
+		 RW
+
+  in[0-7]_max    The higher input limit (in mV) for the corresponding channel.
+		 ADC range and LSB will be updated when the limit is changed.
+		 For the MAX127, it will be adjusted to 0, 5000, or 10000.
+		 RW
+  ============== ==============================================================
-- 
2.17.1

