Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4890D4BFFE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfFSRmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:42:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39423 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbfFSRmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:42:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so356164wma.4
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mr6WZ5OSFO4WU2Gm6yevlMWjzMzjrI5TVzLu9UHe+VE=;
        b=l7GLuS59WwVeZIrFDj1tWPmC9vI/dUSVLP0TUytU5hIpEIzva5m+ME4aE6IIycCfRx
         Dqc5xzSXQW4yOha4IBXHqT/yVAdtJ3rRmIlbVsGlYLM5U3+xs8O3sjhfuZzywRrCIjP0
         ENhpPx8w+Crcnv6vw7RvDUzKsPgX5RlvxKzKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Mr6WZ5OSFO4WU2Gm6yevlMWjzMzjrI5TVzLu9UHe+VE=;
        b=AYOQH5kYRwsxfVSKyzO7YHk2p3J16yh8N4jwmNfNdPCDY7/pQy4vRvjFYk7OKF0QoB
         wAF3upc7B5sksIbwceqtErom2FayVTrqiZrwv0arpLT3LYptwERU6V2Dk6A8aVbHzlfJ
         nZd+4F0uV1REcPDvUpAwlf5A3ZmOgWOLKltFNzFfUbYD3aCBSJnk0sc3Qad7KjKXIHh6
         rFpaACxHDZk/PA1HWh3WxSDRZ8TnagEreDOjl7GXmZ5IHZCE+lgzlO2hHhOxcoEivM10
         nlk9fjD4x5Z3vZMs+Nl+u53OG5aQafd9hjHo8YJDARyB1erjC2HjxjnIM/tzZOxU8gO7
         TYKQ==
X-Gm-Message-State: APjAAAVSHJUgZjMWWDx3aQk0H49pVRJcYFlj5dmU2AtfwtOMIoKRNyI6
        054Eww7wTrpjAoxRmiuZljlm1yy96/pqaQ==
X-Google-Smtp-Source: APXvYqxQDeoDcQ4LKJuDV+25VM5Ib5llnwtOLBOQFfgKiZ3ihmyX64HYh/XcKXIPwHdnq3MhHYlaGg==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr9800755wmi.50.1560966139563;
        Wed, 19 Jun 2019 10:42:19 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id a81sm2381958wmh.3.2019.06.19.10.42.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 10:42:18 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netdev@vger.kernel.org
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next] net: sched: act_ctinfo: tidy UAPI definition
Date:   Wed, 19 Jun 2019 18:41:10 +0100
Message-Id: <20190619174109.55695-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some enums from the UAPI definition that were only used
internally and are NOT part of the UAPI.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 include/net/tc_act/tc_ctinfo.h        | 5 +++++
 include/uapi/linux/tc_act/tc_ctinfo.h | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/tc_act/tc_ctinfo.h b/include/net/tc_act/tc_ctinfo.h
index d6a688571672..f071c1d70a25 100644
--- a/include/net/tc_act/tc_ctinfo.h
+++ b/include/net/tc_act/tc_ctinfo.h
@@ -23,6 +23,11 @@ struct tcf_ctinfo {
 	u64 stats_cpmark_set;
 };
 
+enum {
+	CTINFO_MODE_DSCP	= BIT(0),
+	CTINFO_MODE_CPMARK	= BIT(1)
+};
+
 #define to_ctinfo(a) ((struct tcf_ctinfo *)a)
 
 #endif /* __NET_TC_CTINFO_H */
diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_act/tc_ctinfo.h
index 32337304fbe5..f5f26d95d0e7 100644
--- a/include/uapi/linux/tc_act/tc_ctinfo.h
+++ b/include/uapi/linux/tc_act/tc_ctinfo.h
@@ -26,9 +26,4 @@ enum {
 
 #define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
 
-enum {
-	CTINFO_MODE_DSCP	= _BITUL(0),
-	CTINFO_MODE_CPMARK	= _BITUL(1)
-};
-
 #endif
-- 
2.20.1 (Apple Git-117)

