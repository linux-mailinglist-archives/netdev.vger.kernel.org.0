Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2763D3491F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfFDNk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:59 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:46123 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbfFDNk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:56 -0400
Received: by mail-wr1-f41.google.com with SMTP id n4so10625583wrw.13
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p803wbkUn0hcZuRGndNl30fGv2KxiQSIk6OxWkXUy4s=;
        b=jv6PqBhOcn9Q+drAd4YctO+qldttl4wEoX+ysCcwwgotJ12o+f/6B0ye1RdOvEOLcW
         DUoLIrfbbUr1SwTKgTx47wVSeCyIUfie+34s1X+Trn08AWLNbLXIDUqT7iHAUZ/hVP0W
         Gsn4LmznBKPI3f8aX+QUm6Kau+5vifE984ITNiq8FPPXX3pqADmCWtDHoogF0fon7MPh
         bJbCKtmYxrpr5oLl2qrrw3UADIUJzKfPES0887Y1I71XiCktxe19sHgPbpyblBxqNSFs
         1ZQlbpsn+NQfMtThB4liX8ULwEQNSGqqxUjQQdga+a27FVmBJFvbyhl4QnULF5A1OSNH
         A/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p803wbkUn0hcZuRGndNl30fGv2KxiQSIk6OxWkXUy4s=;
        b=fmb50eiLVdVYMPQBuQg1HC6NLPi4gjQDDxRIrAFoRYEIUnh+n1ICvl4L5kSdrBNUq8
         dxPCQeKq+pDHSoPy12BEQ6FVK29iRVtdbZtt9wtvWA7PE9gN3dYmfATd/85UpKOjMV6Y
         HVqTazMr1PIVcMCujRSLUxsTZ7UTYcYVILt7CjBuQVYvSzDCFffbNPCbj0zPfryzsxES
         AvcH1WDhPJ4NFdENg/VnrUhYMIH59DxK6RN+IFH3woCIUY0QOLy/wA8+MAGlGUSV2x2X
         2AtBYC3+NUOuav3EW4ebCo1bfgEf2Sh2/nniAPfyJh/PICvBsJedaH9B/1+l2nWOiZto
         6Wvg==
X-Gm-Message-State: APjAAAXhcJNL0MQAG7TSQnyBwe2US+0y5NOkD8rCcSyfH8qbdNGmysFc
        zdbMYYb2RkEuWxSjZ+wM9+XtGSz/Tvx7rGcv
X-Google-Smtp-Source: APXvYqz7s3dZrZ/eNqgPXKEMm6UomqHznUFHUCIFBh4ZtMFIjWCF/2e8/tydz2W0uAi17ykzxYt54Q==
X-Received: by 2002:adf:df91:: with SMTP id z17mr13185181wrl.336.1559655654188;
        Tue, 04 Jun 2019 06:40:54 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id s63sm8938235wme.17.2019.06.04.06.40.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 8/8] selftests: add basic netdevsim devlink flash testing
Date:   Tue,  4 Jun 2019 15:40:44 +0200
Message-Id: <20190604134044.2613-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Utilizes the devlink flash code.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- new patch
---
 .../drivers/net/netdevsim/devlink.sh          | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/devlink.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
new file mode 100755
index 000000000000..9d8baf5d14b3
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -0,0 +1,53 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="fw_flash_test"
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+BUS_ADDR=10
+PORT_COUNT=4
+DEV_NAME=netdevsim$BUS_ADDR
+SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
+DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
+DL_HANDLE=netdevsim/$DEV_NAME
+
+fw_flash_test()
+{
+	RET=0
+
+	devlink dev flash $DL_HANDLE file dummy
+	check_err $? "Failed to flash with status updates on"
+
+	echo "n"> $DEBUGFS_DIR/fw_update_status
+	check_err $? "Failed to disable status updates"
+
+	devlink dev flash $DL_HANDLE file dummy
+	check_err $? "Failed to flash with status updates off"
+
+	log_test "fw flash test"
+}
+
+setup_prepare()
+{
+	modprobe netdevsim
+	echo "$BUS_ADDR $PORT_COUNT" > /sys/bus/netdevsim/new_device
+	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
+}
+
+cleanup()
+{
+	pre_cleanup
+	echo "$BUS_ADDR" > /sys/bus/netdevsim/del_device
+	modprobe -r netdevsim
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.17.2

