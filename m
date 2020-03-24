Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D6D1912A0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCXORd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:17:33 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55158 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbgCXORd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:17:33 -0400
Received: by mail-pj1-f65.google.com with SMTP id np9so1543413pjb.4;
        Tue, 24 Mar 2020 07:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nqAcdWRnqSA/uVQmjWL4caKhzvHsEqccflrG15Mc1BU=;
        b=i+R3w8tyBBRz7DPLdorBhqwkmJr0che8ngK6INjQt9Dj6plsw9cPLB9/2oL+Ru2Phu
         EJ1NEWAtawVzsfxWiDf6mPWQ2QVA6l74wvA1wYnt8AuOHHJ9XcQEv4KXa9BnlsrTp7xP
         X7Y3+pHhYiIBwCbGIVt25dnRGWiYKM0D244lbl7iwbmLPU5XCzvOtJukJXN8MTRcHN0f
         ypa56lPmgFOS1rviBKXsY3G2+GeKCmst6Wfh2ISNAGqLtX8JEL2BDKa0+BM8onFimw3g
         Lf7ARAbwGniGWHYWllahoFtg/Ds90+rhgRNTrQ2GceBy5sV18StFxyCic0gb6e49Y1Sz
         boBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nqAcdWRnqSA/uVQmjWL4caKhzvHsEqccflrG15Mc1BU=;
        b=BwgWn8j1eN/y6D31AyQ9y5X3rsL1fFbyNgd+YKmjLlxjXQBW1L1E8D43YAIcVweoXN
         eaz8EFYpm7Dl9ui8WuM7jSV+a5igU8SNFEg58/IfvTqz2VDKVF96M28Eb/Cx3wGc/1UN
         aJba6fNk5ldPZ+cBZtZ2p55VDY4mq8g/U4Ae4cSGq62+di5Im8pCp6OOFRo3EHkvAsv6
         2lJmIesdPSQBnFcXU3MT0VxIQG93c8RAhT2sGrSBD2qHIc9hnlVmDdHbA/8+K2jq/po8
         63C2ZGNuUYs6l7oZQcVsVV+cE9ZFw8YvkmndmSRRdwVC53MIuRSXzGiK/EY1NjXUbhxN
         MgbA==
X-Gm-Message-State: ANhLgQ24GKiNGMobF5Wl+GZEg7/dOGsqZ7N7JNp126wDtJIMcK0eZCek
        fQBxMqUsplhltiCTxCmgy/Q=
X-Google-Smtp-Source: ADFU+vvCSoe1U89aWWTI8mNMwOh7QdhrRFV/bChepi0T+tjxcwIiOwaHnOhN/sgcgKEl4/URYv0CGQ==
X-Received: by 2002:a17:902:7248:: with SMTP id c8mr12760121pll.243.1585059451710;
        Tue, 24 Mar 2020 07:17:31 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id y3sm16256642pfy.158.2020.03.24.07.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 07:17:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH RESEND net 1/3] class: add class_find_and_get_file_ns() helper function
Date:   Tue, 24 Mar 2020 14:17:22 +0000
Message-Id: <20200324141722.21308-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new helper function is to find and get a class file.
This function is useful for checking whether the class file is existing
or not. This function will be used by networking stack to
check "/sys/class/net/*" file.

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/base/class.c         | 12 ++++++++++++
 include/linux/device/class.h |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index bcd410e6d70a..dedf41f32f0d 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -105,6 +105,17 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
 		sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
 }
 
+struct kernfs_node *class_find_and_get_file_ns(struct class *cls,
+					       const char *name,
+					       const void *ns)
+{
+	struct kernfs_node *kn = NULL;
+
+	if (cls)
+		kn = kernfs_find_and_get_ns(cls->p->subsys.kobj.sd, name, ns);
+	return kn;
+}
+
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
@@ -580,6 +591,7 @@ int __init classes_init(void)
 
 EXPORT_SYMBOL_GPL(class_create_file_ns);
 EXPORT_SYMBOL_GPL(class_remove_file_ns);
+EXPORT_SYMBOL_GPL(class_find_and_get_file_ns);
 EXPORT_SYMBOL_GPL(class_unregister);
 EXPORT_SYMBOL_GPL(class_destroy);
 
diff --git a/include/linux/device/class.h b/include/linux/device/class.h
index e8d470c457d1..230cf2ce6d3f 100644
--- a/include/linux/device/class.h
+++ b/include/linux/device/class.h
@@ -209,7 +209,9 @@ extern int __must_check class_create_file_ns(struct class *class,
 extern void class_remove_file_ns(struct class *class,
 				 const struct class_attribute *attr,
 				 const void *ns);
-
+struct kernfs_node *class_find_and_get_file_ns(struct class *cls,
+					       const char *name,
+					       const void *ns);
 static inline int __must_check class_create_file(struct class *class,
 					const struct class_attribute *attr)
 {
-- 
2.17.1

