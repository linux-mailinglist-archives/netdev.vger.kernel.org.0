Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282238BBF8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfHMOst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:48:49 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50529 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfHMOss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:48:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so1794891wml.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 07:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qxrTzlHF4iwE40HMkbzdeG0tmiBjic5rWp5kswtBtA=;
        b=c4C8l+AIjIibfmXNLBONPd8Jz1kYm0GUGmRFWJRuBkCh/5SbVStHFjtBurDvrlx69i
         0sOobyepbVD8LQ3GHShj9rlDjjEzjFXuQKJtwNdAUgnYuoFXJasQKT5whe1GhQRAAuyW
         WRhcpoE9oiOn7VXv77oXO9PjFt/qDDQYb7iYQ4XoFJEcTC1GMrLkHHlHBVJQD4zvamsm
         GFm4LDm49RW3TBmT8qDhlDjPb4tHfUY+Gkz08pMzEIIx1Q5WTZ2yW+mIRyhsDVNy3AXd
         iJEUZDw83D6dhN7atOVkTQlA+pm0ezz1mDJBToTPPVzIOiLXYx0Qrw8sD6DqOkxTk2HD
         /GCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qxrTzlHF4iwE40HMkbzdeG0tmiBjic5rWp5kswtBtA=;
        b=t2c+qnquDxGqXqPqZUJQmwTYr+qz4KqQ/LGTPJBmIO+YQOn11Vs3xhyEfHwE9JjykV
         3gQGiIFwf4O5X4uoyVI5ewVcQzUqt9IB5i+ebi+mGfbnjXmW5Nxd29Iz5HRgfDvVVCTu
         KBy34p63nr1tbscxc1udn+b+1irn76yf/t9t6bHcJY0AJmBFFV1D+6Ll3qybNvgQtW2+
         C2sMgAIaL4nKvdzfW8dhTCYmeYE2E9I0Rc5iNSlq9j6uUZln1JXq5xGdngBmRII1/2gb
         lG9B1vel/wMOnHDKK905FDwm0j6wSS/dAoTFMGjfw3MpXnjXlPLqnkuOwxCyh1EJAbne
         W/cg==
X-Gm-Message-State: APjAAAVtfv2UG4WUbwmRatKzDS6DMnhCLmZL4LgFT498KFOTMIEwJsw6
        ie6SiWokCKcrspFuVy1snKwViDN6kdE=
X-Google-Smtp-Source: APXvYqxGNYdDjed1Z9IRb1uzRRYgb28bh+pvc9vLPDOhi+dyqfGPXdH7E9+X9S7UaPGJKL1aw7XqLg==
X-Received: by 2002:a1c:2582:: with SMTP id l124mr3731752wml.153.1565707726184;
        Tue, 13 Aug 2019 07:48:46 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id l9sm1329039wmh.36.2019.08.13.07.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 07:48:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 2/2] selftests: netdevsim: add devlink regions tests
Date:   Tue, 13 Aug 2019 16:48:43 +0200
Message-Id: <20190813144843.28466-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813144843.28466-1-jiri@resnulli.us>
References: <20190813144843.28466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Test netdevsim devlink region implementation.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 .../drivers/net/netdevsim/devlink.sh          | 54 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 858ebdc8d8a3..b77fdd046bea 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -3,7 +3,7 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="fw_flash_test params_test"
+ALL_TESTS="fw_flash_test params_test regions_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -90,6 +90,58 @@ params_test()
 	log_test "params test"
 }
 
+check_region_size()
+{
+	local name=$1
+	local size
+
+	size=$(devlink region show $DL_HANDLE/$name -j | jq -e -r '.[][].size')
+	check_err $? "Failed to get $name region size"
+	[ $size -eq 32768 ]
+	check_err $? "Invalid $name region size"
+}
+
+check_region_snapshot_count()
+{
+	local name=$1
+	local phase_name=$2
+	local expected_count=$3
+	local count
+
+	count=$(devlink region show $DL_HANDLE/$name -j | jq -e -r '.[][].snapshot | length')
+	[ $count -eq $expected_count ]
+	check_err $? "Unexpected $phase_name snapshot count"
+}
+
+regions_test()
+{
+	RET=0
+
+	local count
+
+	check_region_size dummy
+	check_region_snapshot_count dummy initial 0
+
+	echo ""> $DEBUGFS_DIR/take_snapshot
+	check_err $? "Failed to take first dummy region snapshot"
+	check_region_snapshot_count dummy post-first-snapshot 1
+
+	echo ""> $DEBUGFS_DIR/take_snapshot
+	check_err $? "Failed to take second dummy region snapshot"
+	check_region_snapshot_count dummy post-second-snapshot 2
+
+	echo ""> $DEBUGFS_DIR/take_snapshot
+	check_err $? "Failed to take third dummy region snapshot"
+	check_region_snapshot_count dummy post-third-snapshot 3
+
+	devlink region del $DL_HANDLE/dummy snapshot 1
+	check_err $? "Failed to delete first dummy region snapshot"
+
+	check_region_snapshot_count dummy post-first-delete 2
+
+	log_test "regions test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

