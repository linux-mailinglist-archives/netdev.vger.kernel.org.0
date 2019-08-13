Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89BC8B972
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfHMNEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:04:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38489 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfHMNEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:04:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so107675643wrr.5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RKXvVAfVSbRXanbb06lcL1z9vHmtNflI9YquPpASkI=;
        b=DI+PRg+C49X7EbPnkAH1tqQZu/432B0HL1/kwF8yRiBsWgeazLORlhsLot+Hk5atne
         Mdjq4Xoemr8LReJRhZWiCApkOV0kS4sd4A9HazFBOdJWnV0NgYeITyxJ5AMPJctO/NWG
         d6kzfr7dzOfWdlj4lZb0p81v6BQc9JZa4+zwT/cI+xyC6ga4r16Xvc2EZt1lcPSBqfBm
         zhvgozZ/IGBET7KRtmLzFvphrFKYjlQnB6hsFYp3wBk4k143RvCx89pMo1Bo6iFyv9e7
         wiOFxOlrsVz/wmC9fVkU3Mlk/hLc1G8j1QeiKdm/puhUYt5g72YfskArKM0mjGkckkY3
         9LYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RKXvVAfVSbRXanbb06lcL1z9vHmtNflI9YquPpASkI=;
        b=jCb3b+b2FHW3evlfDD9Y4Ar21rweiEeeSbNIUrdZLR2QGlW94BLo/Dv7IDoEJvGNIN
         JoRwWAAkGkBPoGebFTO+SJHUvIefFdms6CMB7FgGrnlwXweP3HCBA0K6lpZSEc1GoTKO
         eqCPdjYeElY4VghxUkzSffM2AqAGpT9inL9+HsWAN+zvAh3j7NH/LQifCqv5qGRsYsBs
         WKNqvSE+r9d8KVR+SrueDEBTdgVb2WDgnVSvcBOASUktT69WWlBG3ge2C2hpwoKdIibF
         uKOo5/DJnzcaaXsaZ8I8UXg1LZG7PQuJfjkd0pVdtEmYhxirFHJwDjZ3aCvP8GOKQds4
         p61g==
X-Gm-Message-State: APjAAAWjErHSaP5S0FYAegrItvtl8/ioLNtFn2Xye4gjQog3Qk72SItZ
        gfOVZ0hJSwPhU6JhNWgywqPFjQ9pfmM=
X-Google-Smtp-Source: APXvYqzC0K71dD94OdjsDHLiM0oBN8/wPX9n/nJVhxQwby4fBiGQsXg07v9tF6tborBPSEZ/PYEhzA==
X-Received: by 2002:adf:fc03:: with SMTP id i3mr21476508wrr.48.1565701488427;
        Tue, 13 Aug 2019 06:04:48 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id t24sm1096596wmj.14.2019.08.13.06.04.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:04:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next] selftests: netdevsim: add devlink params tests
Date:   Tue, 13 Aug 2019 15:04:46 +0200
Message-Id: <20190813130446.25712-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Test recently added netdevsim devlink param implementation.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 62 ++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9d8baf5d14b3..858ebdc8d8a3 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -3,7 +3,7 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="fw_flash_test"
+ALL_TESTS="fw_flash_test params_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -30,6 +30,66 @@ fw_flash_test()
 	log_test "fw flash test"
 }
 
+param_get()
+{
+	local name=$1
+
+	devlink dev param show $DL_HANDLE name $name -j | \
+		jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
+}
+
+param_set()
+{
+	local name=$1
+	local value=$2
+
+	devlink dev param set $DL_HANDLE name $name cmode driverinit value $value
+}
+
+check_value()
+{
+	local name=$1
+	local phase_name=$2
+	local expected_param_value=$3
+	local expected_debugfs_value=$4
+	local value
+
+	value=$(param_get $name)
+	check_err $? "Failed to get $name param value"
+	[ "$value" == "$expected_param_value" ]
+	check_err $? "Unexpected $phase_name $name param value"
+	value=$(<$DEBUGFS_DIR/$name)
+	check_err $? "Failed to get $name debugfs value"
+	[ "$value" == "$expected_debugfs_value" ]
+	check_err $? "Unexpected $phase_name $name debugfs value"
+}
+
+params_test()
+{
+	RET=0
+
+	local max_macs
+	local test1
+
+	check_value max_macs initial 32 32
+	check_value test1 initial true Y
+
+	param_set max_macs 16
+	check_err $? "Failed to set max_macs param value"
+	param_set test1 false
+	check_err $? "Failed to set test1 param value"
+
+	check_value max_macs post-set 16 32
+	check_value test1 post-set false Y
+
+	devlink dev reload $DL_HANDLE
+
+	check_value max_macs post-reload 16 16
+	check_value test1 post-reload false N
+
+	log_test "params test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

