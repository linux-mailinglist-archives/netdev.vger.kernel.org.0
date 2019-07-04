Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B275F17D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfGDCgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:36:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44057 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfGDCgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 22:36:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so2233624plr.11;
        Wed, 03 Jul 2019 19:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5FkHUosH5w373G3pNIUA3FyKoB3S/lYidTryVrPmEgc=;
        b=qWfWKdsp05s1p8mQnu7JTdC09pDKKOodfUjS5DevKPkWCy2CNOc/kbWvYH8vUVol7Z
         HBcNmQO03/WWZ+t94WpU9L3l8PlKl2ac3rzjVWsvDFCnNKJOIJDo8K7Fup6XW3nJ0Yq4
         2umWAL97EekxkQqbT1XgqH2Xp742kZw85/P2Jp5lsM7Y58fPdKME3EesBHlrDM2gZ7Bs
         J9aCK2rizKOniI9ahYnJ11zbU8+4AxQv44mToF/7LwQb7cJk2RHHCRBbV6y4jOAX+O/d
         qaKHM10i8zfgytxaYY7I5DQ0FaFFiISUI69K7odTEP/ppfODLQtmoU5BstGTjM4cUt8R
         Padw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5FkHUosH5w373G3pNIUA3FyKoB3S/lYidTryVrPmEgc=;
        b=p2G9o68lyJSvPotFAWBgK8d+sS8WegZ1PJh6LlcWbk2eTt7+UMGb8qM1OuMz41Go/g
         vBWLtjpISVv5lGV1H9h46NeNhqdjahOSnplE4N68gWlBM1eoBHptakOEAD7EbWTjnrhv
         RFZgocJsade0vUDGgEmMiyGseJmLzJHniwojWyXdGTvf4uDlzRFY48Si64DByKwwE1cY
         ei2roBVLjHmUp3w7X2Hl1DBJ5OtAMUj3zUs8B6+m4qNlWoAL5sCJcGroWACbSTt+fpFV
         b1pt3J8hGUY79Wp+x6P3anCmCNZbtVwqS7tgnIc48VtzEH0Q2tYNyD0WJlgdV6/+uIm2
         PNKA==
X-Gm-Message-State: APjAAAXpDN4GtSWxLD+AYVxIuFiEzxLCgU1PUmFDM8bGMdkxwl9utDA9
        BDBreo9YAnN0WuvxM8d31zw=
X-Google-Smtp-Source: APXvYqzDlUZDM4vUsC3E9iouAf1cobQwpQM88uIvX5y9yEartDVtlW/cY39D9lsi9dbkKrEX7iGRMg==
X-Received: by 2002:a17:902:722:: with SMTP id 31mr45436828pli.163.1562207799416;
        Wed, 03 Jul 2019 19:36:39 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id q1sm5748143pfn.178.2019.07.03.19.36.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 19:36:39 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [Patch v2 08/10] net/can: using dev_get_drvdata directly
Date:   Thu,  4 Jul 2019 10:36:33 +0800
Message-Id: <20190704023633.4781-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers cast a struct device pointer to a struct
platform_device pointer only to then call platform_get_drvdata().
To improve readability, these constructs can be simplified
by using dev_get_drvdata() directly.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Make the commit message more clearly.

 drivers/net/can/softing/softing_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 68bb58a57f3b..8242fb287cbb 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -683,7 +683,7 @@ static void softing_netdev_cleanup(struct net_device *netdev)
 static ssize_t show_##name(struct device *dev, \
 		struct device_attribute *attr, char *buf) \
 { \
-	struct softing *card = platform_get_drvdata(to_platform_device(dev)); \
+	struct softing *card = dev_get_drvdata(dev); \
 	return sprintf(buf, "%u\n", card->member); \
 } \
 static DEVICE_ATTR(name, 0444, show_##name, NULL)
@@ -692,7 +692,7 @@ static DEVICE_ATTR(name, 0444, show_##name, NULL)
 static ssize_t show_##name(struct device *dev, \
 		struct device_attribute *attr, char *buf) \
 { \
-	struct softing *card = platform_get_drvdata(to_platform_device(dev)); \
+	struct softing *card = dev_get_drvdata(dev); \
 	return sprintf(buf, "%s\n", card->member); \
 } \
 static DEVICE_ATTR(name, 0444, show_##name, NULL)
-- 
2.11.0

