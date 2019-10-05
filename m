Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C684CC85A
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 08:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfJEGKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 02:10:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44329 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfJEGKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 02:10:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so9416172wrl.11
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 23:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKpqz2pZ7VCfBi6jUT/giqtkR4LaHmkM1S1UjvFMP4k=;
        b=y2BDrRbF2hPe1HQLlR3DbGRdIQHV2evtqXSNnct89tNKGVjvF14pUvwNKFcuzwdGvu
         vEmBzEm8oe6vEsEeQepzY6a0PYOecEqkkKMs5tcw2Dr8fc+NLKUd38Ika2FwuE+HQ2rR
         z1NEB0ihL8LkTRw21W+vYqlI/EOE26+BLkIXw0rOTQSeZwhVnRpNqP1ndPJOdPf9ejM/
         NN1kZvyfzY2nUctrRBObDM+XYIM+Pu124kw6hjtlvNt2iU0XAUP/Sbu/oXKISS1hu7Hx
         TNZ8cRYmWYYmkVk5FzzMdVEmi1rmIMlrLgwj+V70IcEH0bGTr3D4TaCKTPHHyXMLscQi
         lelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKpqz2pZ7VCfBi6jUT/giqtkR4LaHmkM1S1UjvFMP4k=;
        b=Q6K+YHt5oEBgVg+dZ9VXP+ZEasI7xIIJtbpIoRlPgYTWSyocbaBM9lhJ3eHRzD+DvX
         zQcblU39bYSO1BT53iXIBqdsLG5xpG76cwJtnQ9enKiIiJszLG5+0Pslbsr3/fqeBypi
         qzZXuVoqajIu9DVPw/Qo+igxBKpVmo83aJm2B2RC1as8gUhq49JPKIFLCGCYz1boTXQh
         JMpK12lMIK9oralc/vmCvILx1U7gtvO6T21tcYZiQ/0MNp3RUikjoV3rlYhI6C5Ap5T7
         egS9DBQRTtV/q+b/znl3quVLk4w68VMimu24MzBeXHeZpDNgBrMDnoO+M1vbcKtOxnC1
         KWvw==
X-Gm-Message-State: APjAAAUNYyS07scvzDlbRV3cUi2OpyypCG/g4aAee7KPZJY1YI7XzgFX
        0eXKvdU0km4zlpZCHQYYgnIu3K/hPzE=
X-Google-Smtp-Source: APXvYqwNE3hTzG6bPI3ZVKMIacwbBZ2m1hZGHg3rWxc0m2oHB0PkgQFnlXQ2IZs4E9oEcI9f5nGvog==
X-Received: by 2002:adf:fd4d:: with SMTP id h13mr14287728wrs.66.1570255837369;
        Fri, 04 Oct 2019 23:10:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n8sm10786761wma.7.2019.10.04.23.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 23:10:37 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, petrm@mellanox.com,
        tariqt@mellanox.com, saeedm@mellanox.com, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: [patch net-next 3/3] selftests: test creating netdevsim inside network namespace
Date:   Sat,  5 Oct 2019 08:10:33 +0200
Message-Id: <20191005061033.24235-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005061033.24235-1-jiri@resnulli.us>
References: <20191005061033.24235-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add a test that creates netdevsim instance inside network namespace
and verifies that the related devlink instance and port netdevices
reside in the namespace.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink_in_netns.sh | 72 +++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  7 +-
 2 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/devlink_in_netns.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_in_netns.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_in_netns.sh
new file mode 100755
index 000000000000..7effd35369e1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_in_netns.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="check_devlink_test check_ports_test"
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+BUS_ADDR=10
+PORT_COUNT=4
+DEV_NAME=netdevsim$BUS_ADDR
+SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
+DL_HANDLE=netdevsim/$DEV_NAME
+NETNS_NAME=testns1
+
+port_netdev_get()
+{
+	local port_index=$1
+
+	cmd_jq "devlink -N $NETNS_NAME port show -j" \
+	       ".[][\"$DL_HANDLE/$port_index\"].netdev" "-e"
+}
+
+check_ports_test()
+{
+	RET=0
+
+	for i in $(seq 0 $(expr $PORT_COUNT - 1)); do
+		netdev_name=$(port_netdev_get $i)
+		check_err $? "Failed to get netdev name for port $DL_HANDLE/$i"
+		ip -n $NETNS_NAME link show $netdev_name &> /dev/null
+		check_err $? "Failed to find netdev $netdev_name"
+	done
+
+	log_test "check ports test"
+}
+
+check_devlink_test()
+{
+	RET=0
+
+	devlink -N $NETNS_NAME dev show $DL_HANDLE &> /dev/null
+	check_err $? "Failed to show devlink instance"
+
+	log_test "check devlink test"
+}
+
+setup_prepare()
+{
+	modprobe netdevsim
+	ip netns add $NETNS_NAME
+	ip netns exec $NETNS_NAME \
+		echo "$BUS_ADDR $PORT_COUNT" > /sys/bus/netdevsim/new_device
+	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
+}
+
+cleanup()
+{
+	pre_cleanup
+	echo "$BUS_ADDR" > /sys/bus/netdevsim/del_device
+	ip netns del $NETNS_NAME
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
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 85c587a03c8a..8b48ec54d058 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -254,6 +254,7 @@ cmd_jq()
 {
 	local cmd=$1
 	local jq_exp=$2
+	local jq_opts=$3
 	local ret
 	local output
 
@@ -263,7 +264,11 @@ cmd_jq()
 	if [[ $ret -ne 0 ]]; then
 		return $ret
 	fi
-	output=$(echo $output | jq -r "$jq_exp")
+	output=$(echo $output | jq -r $jq_opts "$jq_exp")
+	ret=$?
+	if [[ $ret -ne 0 ]]; then
+		return $ret
+	fi
 	echo $output
 	# return success only in case of non-empty output
 	[ ! -z "$output" ]
-- 
2.21.0

