Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E67CDD43
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 10:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfJGI1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 04:27:17 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45526 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfJGI1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 04:27:15 -0400
Received: by mail-wr1-f48.google.com with SMTP id r5so14043675wrm.12
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 01:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J4CsrjtlU0SWDUjEQj9Vv0VfFqOqYEFCIhHKnhR6AGg=;
        b=Hy6DTkSUW9FGNrUoRVzGwXKrRAKhyyX9cJlQiaM/HbX2g3BE2b8Ja1XfGk90DrX1xg
         bIGXwlIBMRVS7wH7JyvZ1vZjKA+EAN/SV2cdqf71kOxKSWpLp5m+WiY85Vib+32wKVuZ
         7987fCuqVTlBlmczMhsnUuJSYAMnBsUr2MpdS3Vxyu6SYsN2F+Z+JniD1WjnKgxiKYiQ
         E/h2NQoHrQMMSrOoU28bIWQimQEX+ja5pIA1bzig06mtxHSnYRHaNYRiCl+u0XkKLExw
         H4oFfcr88EbzZGE956ReIW1llF+SVN26FWx/zz3FxlcyPnZrE9nTRHRX94AvZLPsJ+Y/
         3yTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J4CsrjtlU0SWDUjEQj9Vv0VfFqOqYEFCIhHKnhR6AGg=;
        b=qygCgtH6wnGAfiUncuBloKYvTXcBmrH3tJrTlTn7w9iC8j/IK/LggbSvTwt0zUHiRb
         Tza5pDEAmFif3OCwqqSNB5umjQM0WfpkQHQNPvwpRO7ir73wMXe1Y4SE6G11/FSZBBX7
         EDf8dGYt2eK5rizfG+0Id4Xz8tmrfakKs9cYrLg7FrtAnRoio6/2MDM8WeqMZUCE61Jt
         g2u+MaTtEGhrQ3ojnmt4PRHmnobFmxj+OOZN7cvUAQUwqVk8ekZEOvgrC6aBCwaM+Ke2
         jkGHPcAFT24kq+Yzerxq15XRyVpjObIgIGbmezz5xwRloOPyL3T9rZvUvIhH+CJlRU1b
         3j0A==
X-Gm-Message-State: APjAAAVpojaWZ7zP7z7MhiNBb+J3veYAjphnVk2MTADZzhHdPkKsL0In
        TmJyecn5vECisvs9h6uwsLNVcMuXVeU=
X-Google-Smtp-Source: APXvYqw2wqP9PO5ygn6TDy2MtiLOF1fy7fwkugOWRpy+x+fc8cvLp+Pxk+HaO3TKbDk3/8NpseLSjg==
X-Received: by 2002:adf:efcb:: with SMTP id i11mr21837226wrp.69.1570436833293;
        Mon, 07 Oct 2019 01:27:13 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id q22sm13245025wmj.5.2019.10.07.01.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 01:27:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 2/2] selftests: add netdevsim devlink dev info test
Date:   Mon,  7 Oct 2019 10:27:09 +0200
Message-Id: <20191007082709.13158-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007082709.13158-1-jiri@resnulli.us>
References: <20191007082709.13158-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add test to verify netdevsim driver name returned by devlink dev info.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index de3174431b8e..cb0f17e17abc 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -4,7 +4,7 @@
 lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
-	   netns_reload_test resource_test"
+	   netns_reload_test resource_test dev_info_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -284,6 +284,25 @@ resource_test()
 	log_test "resource test"
 }
 
+info_get()
+{
+	local name=$1
+
+	cmd_jq "devlink dev info $DL_HANDLE -j" ".[][][\"$name\"]" "-e"
+}
+
+dev_info_test()
+{
+	RET=0
+
+	driver=$(info_get "driver")
+	check_err $? "Failed to get driver name"
+	[ "$driver" == "netdevsim" ]
+	check_err $? "Unexpected driver name $driver"
+
+	log_test "dev_info test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

