Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCCD0D61
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbfJILE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:04:56 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:34587 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730741AbfJILEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:04:53 -0400
Received: by mail-wr1-f46.google.com with SMTP id j11so2371344wrp.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+BKt9qSWSNWQpa4AgVq2InG7JAhSeNAvhd7CRZjKhiQ=;
        b=qM3UWOOJjkkNec65dT2j+kRd+w0mL924l2yCrbIp1b2KizIOD4jyGAciV3RzRwgSiS
         VnXQXSMd+sSkzcvOR6TLZUe0t584DdcKLRpkXjn68ijchZJlvCm2CkCHL92mkwK2Dbqd
         NpuDTkK/WUi3HB6d4LAUkkSffIUq6Z1HNlT9846GkZxip8E9lVdvLKZ06QTkDwgJaaS+
         a8H9RXf9lkEks6VOOKf7Lb1Hozat/GYOWk/vqi15huUnEK7i6pHC/+wIw9HXuh3G/nJ8
         3DA2he/NCknXfSDfNvjx2RGDDGhLNsvEAaXvw5Gh59it62nSSYSVNz5HYVvkUPMUbxlk
         LjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+BKt9qSWSNWQpa4AgVq2InG7JAhSeNAvhd7CRZjKhiQ=;
        b=b0LHq7rR3Wb7Sz/sAlm1GC6Or5iyL7KbeFv5EXxNOw6/SG/PyRtcDbJc3zbBoEyL/P
         PjRLw2VQWrdgC9rPNCYKIWw4AefDlrgWWnajf7aCS2TkHYuAcPgfuXxuEdiDaY9OVLw9
         T41xfYICKJSkjX9VvQ6nJ1CKnlExjmRg/6ChcqHHdis/V80P9nBH6CNOsYmPhAaZXaRc
         n0L4Hw0IpFwNwSpylHV8idkNNlaDMVWge389m1f/qZhRNGCleU5T6QlRT5BfgUVxgV8b
         OTOPMNyBVlgK+4nRvQssw2niVAf0xSFqQGXSARn6oXLziqYLiRkpirRKGR0ityhx9xyl
         wV2g==
X-Gm-Message-State: APjAAAXWGfbsQfnB8/EKsEPEzQ9CCua7SoH0hKLWe2ZegarSJ8v77QRR
        Tkj9ku8vNgSFYuRGHaw/28sfDMfttp0=
X-Google-Smtp-Source: APXvYqzY8LLAFbCvUEm7tejDhcjLtsvCvSc6gl9jDnXt3XNtCGo87QK5nuX+1PMCl5Foxm+yhBoAYQ==
X-Received: by 2002:adf:fe4c:: with SMTP id m12mr2239892wrs.137.1570619090280;
        Wed, 09 Oct 2019 04:04:50 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id a13sm4644789wrf.73.2019.10.09.04.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:04:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 4/4] selftests: add netdevsim devlink health tests
Date:   Wed,  9 Oct 2019 13:04:45 +0200
Message-Id: <20191009110445.23237-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191009110445.23237-1-jiri@resnulli.us>
References: <20191009110445.23237-1-jiri@resnulli.us>
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
 .../drivers/net/netdevsim/devlink.sh          | 124 +++++++++++++++++-
 1 file changed, 123 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index cb0f17e17abc..ff84aede8c73 100755
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
 
@@ -303,6 +304,127 @@ dev_info_test()
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

