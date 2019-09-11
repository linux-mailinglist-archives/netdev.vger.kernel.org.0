Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BECBAFD60
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfIKNFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:05:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40614 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfIKNFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:05:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id t9so3460186wmi.5
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 06:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=RkGpt+lw5qAgiRN4W6/7DO0DC0Wvv5DIa0rZOmT33xI=;
        b=izmM87Q76rqDCm6vpu399jLpYRsYQql/Rx0xUKR2lpGJBgo+LFTWSKgMzldy/PKpiC
         mR9nAYrMij80k8YUMEqKBC0jKJr4ZNZ+XVatL/LSAWrDOLM1tpCDoffbUq7ok6QOed02
         h6ULOZEy30aUU4uhaFVbdX4sX2iS9IlFDOCcMYdRAcTPgBdX8VcoTbdUObT2ysg+uDiU
         z0db0LUVUJN9vHaA4Q2WPkC0mrFJsYgst/SUL1KUpeQZr7U33ZJhXhYAKls9HFU7+PKQ
         tV1qPRanAUkDEiCUqHsgriGLLBZrHJIASt8mRzYDOmHKDLJA3hgEtglh8IeIZtizgcEY
         hM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RkGpt+lw5qAgiRN4W6/7DO0DC0Wvv5DIa0rZOmT33xI=;
        b=KDsPnYou4hO6FeI/cOhcPu0nYcwVetagwYkuPk9eXAB1JhkzT1pGIoAjjBxZIUBow2
         2+KnxsrlRCv68O66MMY8QYvn9ivF0sqJrKPpNEoqRbo12MO+o7X4iYvxWZr4bt5C15UV
         o013if0IvheoWrMH67fj69D9Ke7gl9Yg9nZ+GfBWeH1Rt4iavuw2rbOUKnHL6rgSwH/u
         SzgsUrc2Ph5Nk/5R18cHDr6S8XCJLrvppbTZmusavwxrpJc3NHrNtO3HCP6BmHmXtH/q
         djUZq9l3XBDLp7wU2/FS19zthS3cyHpoapBBPthFysufBF/GWey8+LseyUG//R1m7nUY
         R6FQ==
X-Gm-Message-State: APjAAAXQLPkDcjPZT7eVjpJ4YRW0R4rzFBJ0Nt7y3EZKmdeXz6/s7c3K
        rQmXqgKnurOozExC6ZwH13CWjWv3rkxlug==
X-Google-Smtp-Source: APXvYqzijpPz5MUuv+uI7Ko0/3ABojpOrbZGwjXCXj+eQGwYmaYxL3Xq7BnMIewnXScg7VPndCn8Rw==
X-Received: by 2002:a1c:f30b:: with SMTP id q11mr3926074wmq.156.1568207136225;
        Wed, 11 Sep 2019 06:05:36 -0700 (PDT)
Received: from penelope.horms.nl ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id y3sm19860638wrl.78.2019.09.11.06.05.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:05:35 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH iproute2-next] devlink: add 'reset_dev_on_drv_probe' devlink param
Date:   Wed, 11 Sep 2019 14:05:17 +0100
Message-Id: <20190911130517.21986-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the new devlink parameter along with string to uint
conversion.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
Depends on devlink.h changes present in net-next commit
5bbd21df5a07 ("devlink: add 'reset_dev_on_drv_probe' param")
---
 devlink/devlink.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2f084c020765..15877a04f5d6 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2253,6 +2253,26 @@ static const struct param_val_conv param_val_conv[] = {
 		.vstr = "flash",
 		.vuint = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
 	},
+	{
+		.name = "reset_dev_on_drv_probe",
+		.vstr = "unknown",
+		.vuint = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN,
+	},
+	{
+		.name = "reset_dev_on_drv_probe",
+		.vstr = "always",
+		.vuint = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS,
+	},
+	{
+		.name = "reset_dev_on_drv_probe",
+		.vstr = "never",
+		.vuint = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER,
+	},
+	{
+		.name = "reset_dev_on_drv_probe",
+		.vstr = "disk",
+		.vuint = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK,
+	},
 };
 
 #define PARAM_VAL_CONV_LEN ARRAY_SIZE(param_val_conv)
-- 
2.11.0

