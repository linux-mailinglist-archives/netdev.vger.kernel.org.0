Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302F0D2B15
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbfJJNTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:19:03 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:53371 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388217AbfJJNTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:19:01 -0400
Received: by mail-wm1-f41.google.com with SMTP id i16so6913726wmd.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vibWHhQLnNEBvbjooAcoAHOAIgHhzEUeyNPeAW/pEYE=;
        b=FmiJe2jUfuD4A5oLlKJbqKGQe16/vXVCGK9hxM6NZP0qqMXhHd7Z/lKbz13LMz3sK7
         fOajlVDf9BI7TYlRgmGi9tfp4qIgbtTwfz59zZmcW8yhCvyvZCIobb/Ds/eklVllGvCc
         olgTPkrLde+HblwWt+q1nP/og0svsmFvGIY06DfDLZ8csh97cgRWMz/PYg6Ig379sTix
         P2DWv1Lo1E9696jLALzmVLriCbzzvXx557hzhsJc5/fl4u+UnxvNk8jizLgAFUs1WXqQ
         PLHomx+K6zGUR1vA6xEVpKIcBov6R0b4pbWWu6KJyzQ9CmkRBsXBLVTipgjhUS6g/+Jq
         yBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vibWHhQLnNEBvbjooAcoAHOAIgHhzEUeyNPeAW/pEYE=;
        b=CIpSrab+z30C0HcOvtmxMYjFGbT3Z6RL+81y9m/3NSAvwudltcSHuF1Wf8VGh1Kh6D
         YnUet6XlGv+Nqk0mipMYjBHykXKi1bVX9iJBjWsst8sOUTeDj/mhHXrPNpNEhiQ18VBD
         xxMN1v4pYic8XybD1QdLS6RLvF6JTS0abp17wP7nPOUfuS2SEb7xA8E8O68f2qZRGEiS
         /vpwuCRbNfc5SVg8e7pyOjkM1F1g31WTR8u26OH8qg/NmRuVLLFeav0Pp73rdy9IOVW/
         cI2bRYAzYuTflWkHqzG+1M5HmK30z5KvZoquUVJqQ4UzaRFGZG7fWTfx6+lpvyIp7yXe
         QFBw==
X-Gm-Message-State: APjAAAUbJ5/twFlvE5B/JppIJyYa12JGbtHdwHeO01dQn9TZBU7slMXO
        hLY6UAd6p2SLxNnTE8aM+wfFJAW6HBA=
X-Google-Smtp-Source: APXvYqzrbApWyNEWWRDID7WDl46QJZLFbQ5twU2n8hQ5lfBIi8HyXhUrDwFbCDF4+odUPQjgkwdHEg==
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr8073025wmk.28.1570713538041;
        Thu, 10 Oct 2019 06:18:58 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id d15sm5983299wru.50.2019.10.10.06.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:18:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 4/4] selftests: add netdevsim devlink health tests
Date:   Thu, 10 Oct 2019 15:18:51 +0200
Message-Id: <20191010131851.21438-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010131851.21438-1-jiri@resnulli.us>
References: <20191010131851.21438-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add basic tests to verify functionality of netdevsim reporters.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- added test of manual recovery fail

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 127 +++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index cb0f17e17abc..5e4ab193559a 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -4,7 +4,8 @@
 lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
-	   netns_reload_test resource_test dev_info_test"
+	   netns_reload_test resource_test dev_info_test \
+	   empty_reporter_test dummy_reporter_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -303,6 +304,130 @@ dev_info_test()
 	log_test "dev_info test"
 }
 
+empty_reporter_test()
+{
+	RET=0
+
+	devlink health show $DL_HANDLE reporter empty >/dev/null
+	check_err $? "Failed show empty reporter"
+
+	devlink health dump show $DL_HANDLE reporter empty >/dev/null
+	check_err $? "Failed show dump of empty reporter"
+
+	devlink health diagnose $DL_HANDLE reporter empty >/dev/null
+	check_err $? "Failed diagnose empty reporter"
+
+	devlink health recover $DL_HANDLE reporter empty
+	check_err $? "Failed recover empty reporter"
+
+	log_test "empty reporter test"
+}
+
+check_reporter_info()
+{
+	local name=$1
+	local expected_state=$2
+	local expected_error=$3
+	local expected_recover=$4
+	local expected_grace_period=$5
+	local expected_auto_recover=$6
+
+	local show=$(devlink health show $DL_HANDLE reporter $name -j | jq -e -r ".[][][]")
+	check_err $? "Failed show $name reporter"
+
+	local state=$(echo $show | jq -r ".state")
+	[ "$state" == "$expected_state" ]
+	check_err $? "Unexpected \"state\" value (got $state, expected $expected_state)"
+
+	local error=$(echo $show | jq -r ".error")
+	[ "$error" == "$expected_error" ]
+	check_err $? "Unexpected \"error\" value (got $error, expected $expected_error)"
+
+	local recover=`echo $show | jq -r ".recover"`
+	[ "$recover" == "$expected_recover" ]
+	check_err $? "Unexpected \"recover\" value (got $recover, expected $expected_recover)"
+
+	local grace_period=$(echo $show | jq -r ".grace_period")
+	check_err $? "Failed get $name reporter grace_period"
+	[ "$grace_period" == "$expected_grace_period" ]
+	check_err $? "Unexpected \"grace_period\" value (got $grace_period, expected $expected_grace_period)"
+
+	local auto_recover=$(echo $show | jq -r ".auto_recover")
+	[ "$auto_recover" == "$expected_auto_recover" ]
+	check_err $? "Unexpected \"auto_recover\" value (got $auto_recover, expected $expected_auto_recover)"
+}
+
+dummy_reporter_test()
+{
+	RET=0
+
+	check_reporter_info dummy healthy 0 0 0 false
+
+	local BREAK_MSG="foo bar"
+	echo "$BREAK_MSG"> $DEBUGFS_DIR/health/break_health
+	check_err $? "Failed to break dummy reporter"
+
+	check_reporter_info dummy error 1 0 0 false
+
+	local dump=$(devlink health dump show $DL_HANDLE reporter dummy -j)
+	check_err $? "Failed show dump of dummy reporter"
+
+	local dump_break_msg=$(echo $dump | jq -r ".break_message")
+	[ "$dump_break_msg" == "$BREAK_MSG" ]
+	check_err $? "Unexpected dump break message value (got $dump_break_msg, expected $BREAK_MSG)"
+
+	devlink health dump clear $DL_HANDLE reporter dummy
+	check_err $? "Failed clear dump of dummy reporter"
+
+	devlink health recover $DL_HANDLE reporter dummy
+	check_err $? "Failed recover dummy reporter"
+
+	check_reporter_info dummy healthy 1 1 0 false
+
+	devlink health set $DL_HANDLE reporter dummy auto_recover true
+	check_err $? "Failed to dummy reporter auto_recover option"
+
+	check_reporter_info dummy healthy 1 1 0 true
+
+	echo "$BREAK_MSG"> $DEBUGFS_DIR/health/break_health
+	check_err $? "Failed to break dummy reporter"
+
+	check_reporter_info dummy healthy 2 2 0 true
+
+	local diagnose=$(devlink health diagnose $DL_HANDLE reporter dummy -j -p)
+	check_err $? "Failed show diagnose of dummy reporter"
+
+	local rcvrd_break_msg=$(echo $diagnose | jq -r ".recovered_break_message")
+	[ "$rcvrd_break_msg" == "$BREAK_MSG" ]
+	check_err $? "Unexpected recovered break message value (got $rcvrd_break_msg, expected $BREAK_MSG)"
+
+	devlink health set $DL_HANDLE reporter dummy grace_period 10
+	check_err $? "Failed to dummy reporter grace_period option"
+
+	check_reporter_info dummy healthy 2 2 10 true
+	
+	echo "Y"> $DEBUGFS_DIR/health/fail_recover
+	check_err $? "Failed set dummy reporter recovery to fail"
+
+	echo "$BREAK_MSG"> $DEBUGFS_DIR/health/break_health
+	check_fail $? "Unexpected success of dummy reporter break"
+	
+	check_reporter_info dummy error 3 2 10 true
+
+	devlink health recover $DL_HANDLE reporter dummy
+	check_fail $? "Unexpected success of dummy reporter recover"
+
+	echo "N"> $DEBUGFS_DIR/health/fail_recover
+	check_err $? "Failed set dummy reporter recovery to be successful"
+	
+	devlink health recover $DL_HANDLE reporter dummy
+	check_err $? "Failed recover dummy reporter"
+	
+	check_reporter_info dummy healthy 3 3 10 true
+
+	log_test "dummy reporter test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

