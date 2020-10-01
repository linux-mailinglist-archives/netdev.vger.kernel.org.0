Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCCD27FA15
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgJAHVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:21:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FCDC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:21:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s12so4377411wrw.11
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 00:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8HVibruU0dcUMR5RZeUD1cZ/NXBGV9rTxBVK6DiY0Fc=;
        b=kR3TpPwBkDKIsM9GuhaVoF7JOHpwGF2O0pIpFpd/+JhnPoYfkRdPnqHd5RkeUNc/Dz
         r75jGN45RNbpTxYuU8b+B8qGsh970E/yiVPquDfd0d1/1LDSngtFgaRUvKYPWq21SNJW
         e8z1DCtPLhDm/zy2pNIWQX5p7v2pCdLwc1/mxZAHbbkwvUdrFrliqZkwjs4HkMVZ+vlQ
         ttEYGKZMgewG1vqeg2M/l0fGhD/WKjWkYN9D4QMgFgehP0t54XzUp7frKMsJyvkqJhW1
         B4yf390axYw1aXDRUYOzz2MpQStxsP2iokMmyx3t5T/ptbA6Vhw1OJtkYPMsoFiFMGk+
         plKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8HVibruU0dcUMR5RZeUD1cZ/NXBGV9rTxBVK6DiY0Fc=;
        b=X5SX2a9E+GJcNQLk+jQHHD7NiyEsxId0CNBU9ZsJNhNLRcjsFKcPnJ6uH9ZUNDOFlZ
         mI8l4vcavQFpvh1UaMWrOugFKYpMrDg1/E0OsI0tbIblqNRQInx2gi+JvxdSKkMafJyP
         ICLPqFF+MIpjxTadzRjSUBSMF4cF+I7SSrnYMjYT1tvalBxODg3p79tt0W2tC5CsYqhx
         44gj+5hMLHLSnRavUVOQCh+yddjtGpkS2/Zh9Vc0UCJ+emFs2PAayuZIG/jP/390vpDC
         sqxgW88pFjkCNtagTiQdcAeJpCbFqdBVJQwgt66kLVydI7WOcSPCwz6F2iNQo0670yCa
         OsFg==
X-Gm-Message-State: AOAM533VgL39d4PFJ6GZvR03b4feY4gaa4lUrbgMauev6Iinbjc+C18B
        JMv5u3by0a8S7UsNmzOqSO4GqvaveeVqNniB
X-Google-Smtp-Source: ABdhPJyADsm+FmvGSJ3wHlfwNqFB59gTdiiz2Q9EVZPhSshKnPIj1BiboE5rcGx1L4JEcI/oeO58Ug==
X-Received: by 2002:a5d:4603:: with SMTP id t3mr6953341wrq.424.1601536875109;
        Thu, 01 Oct 2020 00:21:15 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k8sm6995429wrl.42.2020.10.01.00.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 00:21:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, mlxsw@nvidia.com
Subject: [patch iproute2-next] devlink: Add health reporter test command support
Date:   Thu,  1 Oct 2020 09:21:13 +0200
Message-Id: <20201001072113.493092-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add health reporter test command and allow user to trigger a test event.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 bash-completion/devlink   |  2 +-
 devlink/devlink.c         | 11 +++++++++++
 man/man8/devlink-health.8 | 16 ++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index f710c888652e..7395b5040232 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -635,7 +635,7 @@ _devlink_health_reporter()
 _devlink_health()
 {
     case $command in
-        show|recover|diagnose|set)
+        show|recover|diagnose|set|test)
             _devlink_health_reporter 0
             if [[ $command == "set" ]]; then
                 case $cword in
diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0374175eda3d..126156a200c9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -7055,6 +7055,13 @@ static int cmd_health_diagnose(struct dl *dl)
 					0);
 }
 
+static int cmd_health_test(struct dl *dl)
+{
+	return cmd_health_object_common(dl,
+					DEVLINK_CMD_HEALTH_REPORTER_TEST,
+					0);
+}
+
 static int cmd_health_recover(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
@@ -7259,6 +7266,7 @@ static void cmd_health_help(void)
 	pr_err("Usage: devlink health show [ { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME ]\n");
 	pr_err("       devlink health recover { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
 	pr_err("       devlink health diagnose { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
+	pr_err("       devlink health test { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
 	pr_err("       devlink health dump show { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
 	pr_err("       devlink health dump clear { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
 	pr_err("       devlink health set { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
@@ -7282,6 +7290,9 @@ static int cmd_health(struct dl *dl)
 	} else if (dl_argv_match(dl, "diagnose")) {
 		dl_arg_inc(dl);
 		return cmd_health_diagnose(dl);
+	} else if (dl_argv_match(dl, "test")) {
+		dl_arg_inc(dl);
+		return cmd_health_test(dl);
 	} else if (dl_argv_match(dl, "dump")) {
 		dl_arg_inc(dl);
 		if (dl_argv_match(dl, "show")) {
diff --git a/man/man8/devlink-health.8 b/man/man8/devlink-health.8
index 47b96135ef01..975b8c75d798 100644
--- a/man/man8/devlink-health.8
+++ b/man/man8/devlink-health.8
@@ -41,6 +41,12 @@ devlink-health \- devlink health reporting and recovery
 .B  reporter
 .RI "" REPORTER ""
 
+.ti -8
+.BR "devlink health test"
+.RI "{ " DEV " | " DEV/PORT_INDEX " }"
+.B reporter
+.RI "" REPORTER ""
+
 .ti -8
 .B devlink health dump clear
 .RI "{ " DEV " | " DEV/PORT_INDEX " }"
@@ -105,6 +111,16 @@ This action performs a recovery and increases the recoveries counter on success.
 .I "REPORTER"
 - specifies the reporter's name registered on specified devlink device or port.
 
+.SS devlink health test - Trigger a test event on a reporter.
+
+.PP
+.I "DEV"
+- specifies the devlink device.
+
+.PP
+.I "REPORTER"
+- specifies the reporter's name registered on the devlink device.
+
 .SS devlink health dump show - Display the last saved dump.
 
 .PD 0
-- 
2.26.2

