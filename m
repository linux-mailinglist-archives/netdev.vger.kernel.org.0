Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31EAD2E20
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfJJPqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:46:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35311 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJJPqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:46:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so7317912wmi.0;
        Thu, 10 Oct 2019 08:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IgNkDcJv0Dsat8rX7/2Xt+TqC2z88O73Ns5IrlBP/xE=;
        b=ICZMR/kXK4ALkcUdh0QSQSOcz8hympO2L0DXdxYG6WiZRQPIzt56IyYT1bbtChGft6
         dAA2Hwc9NWTwEc547la4Bm1t9zBeNY8B6I87cY4IFx+tvm6fHm8ThRn3Kyqux9uH7IaX
         ME04BtFS5DlcH1gRda+qPqDkYpFIEAfm2UT7m6sjMJY2NbXruBXARNNzcEe5Yj7iIiOy
         3kmTk17xeKP6zVeBSK94fFSNq+luFF+1RSApsYCYdufh4gvHsYEljjEpUg0c2TYKPMqS
         fiJzSLNXndJy+EKXTqlhjCP70qiIebkd2XBgyZ9drZ5nDsSjL4Oa8zD6KQ4yx7ezuV0Z
         Adrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IgNkDcJv0Dsat8rX7/2Xt+TqC2z88O73Ns5IrlBP/xE=;
        b=I5lGDkcJSvtsIfxFLGwoZ7XxSXTOXKInUDsrTt1vk/9tz3r9GV5kfCGiubi1lLoqxE
         fFn/IhJJSuxNtAOHuDWeQOGuZlWvMK5qfsjhr057Gb56PHHIwexZWwdYE4KO5gDBfGtE
         KmOy46lovj1W8ZuJuU8oH1oELQpjSKsbROREnu7RB5zzv3/1UPuLGN+227WmeGtfaY2F
         MPNI2uhvxMuvT7wpR7A3fRRBtIf4LfmnVwAv9VhguPUlP/6L/X1MUwY0hgMgQ1mNA06n
         lBO/NC9bXoxww6FWhQ4BR9NDD+E90oSs9sNYJWz8/43OU2YwE5ynI75S7vstiPTesOLh
         4lrg==
X-Gm-Message-State: APjAAAVtUhMjYfZ0CLR06wX/TZ6U3sA1rI5/pvTUsiFMAHajul+pV8zZ
        LI0XYXrajsATnuwGGlm9ux8gkkXO8Zr1ow==
X-Google-Smtp-Source: APXvYqzHJcOBxuNlsbdIdjGkvOSD9xg1agAV0t9veDiKZfz6DjAcyhslXuWWzb/o5il3Bn07r61zdg==
X-Received: by 2002:a05:600c:2185:: with SMTP id e5mr8441624wme.78.1570722386439;
        Thu, 10 Oct 2019 08:46:26 -0700 (PDT)
Received: from andrea.corp.microsoft.com ([2a01:110:8012:1010:e9a3:da77:7120:dee0])
        by smtp.gmail.com with ESMTPSA id u25sm6719807wml.4.2019.10.10.08.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:46:25 -0700 (PDT)
From:   Andrea Parri <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH v2 3/3] Drivers: hv: vmbus: Add module parameter to cap the VMBus version
Date:   Thu, 10 Oct 2019 17:46:00 +0200
Message-Id: <20191010154600.23875-4-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010154600.23875-1-parri.andrea@gmail.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, Linux guests negotiate the VMBus version with Hyper-V
and use the highest available VMBus version they can connect to.
This has some drawbacks: by using the highest available version,
certain code paths are never executed and can not be tested when
the guest runs on the newest host.

Add the module parameter "max_version", to upper-bound the VMBus
versions guests can negotiate.

Suggested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 drivers/hv/connection.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 2f6961ac8c996..f60d7330ff3fd 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -14,6 +14,7 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/hyperv.h>
@@ -55,6 +56,16 @@ static __u32 vmbus_versions[] = {
 	VERSION_WS2008
 };
 
+/*
+ * Maximal VMBus protocol version guests can negotiate.  Useful to cap the
+ * VMBus version for testing and debugging purpose.
+ */
+static uint max_version = VERSION_WIN10_V5_2;
+
+module_param(max_version, uint, S_IRUGO);
+MODULE_PARM_DESC(max_version,
+		 "Maximal VMBus protocol version which can be negotiated");
+
 int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 {
 	int ret = 0;
@@ -237,6 +248,8 @@ int vmbus_connect(void)
 
 	for (i = 0; i < ARRAY_SIZE(vmbus_versions); i++) {
 		version = vmbus_versions[i];
+		if (version > max_version)
+			continue;
 
 		ret = vmbus_negotiate_version(msginfo, version);
 		if (ret == -ETIMEDOUT)
-- 
2.23.0

