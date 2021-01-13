Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBCC2F4B18
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbhAMMNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbhAMMNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:48 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387CFC0617A7
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:37 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c5so1871950wrp.6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATylw7O0JvPXuZo0K63DCjbbvEh4iMcDM+Z+skEBAj8=;
        b=OfeynaacaTCjabxQsY34bA30qnjJxvMrfnJf81GhgAYpVZqB3041sP3ORO+ebJK5Ku
         ySeexoFT1iDIndFTHW4qDaro0TkA7PGHROfYeczPXm4jOh+GO/SAXWGF0uy4bmyfAdjV
         vKljxURPnDXlT+L0rF0sXXNJeXzexGmzsnV4xJSlvCjSn3Lp3I4tA7GBkHuXsLMgDZgV
         8484k2oICS8O3N7KQCrNZRSdrrQOrH5f9Pz1/gCJd7sbmlpjOAZ3p9H7rsZONMkcvJbY
         kvFlkcMiRRywSdVfyPX+4CXZSOBFHgjoRsQHg/IBDVEzf0sQOJ7BRxqvB+rnfoNAWL4M
         EW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATylw7O0JvPXuZo0K63DCjbbvEh4iMcDM+Z+skEBAj8=;
        b=HV4hlZI/lxJvdpy5y480E82kq2PBmj+8YvClQDFeTXK6adgqPdoC0bYTEn7zubg7vv
         HYCA7wMIWl/wPf0i9NvRKj37s7czGX6Ioui86uoECnp64EOZFjjoA9MSMbbBZjPrZk08
         J5EXpdiT37D01IGdNxia2tJbe521o+Iyq6uc292lreDVpfyaV8a/egpifIxC5lUVxRHV
         +u8hnVMaOZxxWJUSmJkSxDEWNqpLefReBjUv47IgzkbeY+6Y1DSCfi/V23cWPRTqykiq
         FwRr6m0BUCB2kJppkxm1G/fn605AIabFAOZec2fA4MI5wEcTkOLyhiZUEXDV+X+d7J5u
         bqwg==
X-Gm-Message-State: AOAM530rO5waxELEqQF0GCmihp2N22RI6ntrrXuinxFUQnb/w8GFEK7D
        mMtVzHeppBXjOxODc0DViypYjo86/AcDr/XP
X-Google-Smtp-Source: ABdhPJyyzZc9KDK7We44APjrHcsZd8VgkUsKLlSvgJ322I0+0p8DUL7WAuIyG3S4xAIf/DM6KrVLCQ==
X-Received: by 2002:adf:a441:: with SMTP id e1mr2265084wra.385.1610539955512;
        Wed, 13 Jan 2021 04:12:35 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id h83sm2806067wmf.9.2021.01.13.04.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:35 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 10/10] selftests: add netdevsim devlink lc test
Date:   Wed, 13 Jan 2021 13:12:22 +0100
Message-Id: <20210113121222.733517-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add test to verify netdevsim driver line card functionality.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 62 ++++++++++++++++++-
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c254365..c33cf13d3bf3 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test linecard_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
 BUS_ADDR=10
 PORT_COUNT=4
+LINECARD_COUNT=2
 DEV_NAME=netdevsim$BUS_ADDR
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
@@ -507,10 +508,67 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+check_linecards_state()
+{
+	local expected_state_0=$1
+	local expected_state_1=$2
+
+	local state=$(devlink lc show $DL_HANDLE lc 0 -j | jq -e -r ".[][][].state")
+	check_err $? "Failed to get linecard 0 state"
+
+	[ "$state" == "$expected_state_0" ]
+	check_err $? "Unexpected linecard 0 state (got $state, expected $expected_state_0)"
+
+	local state=$(devlink lc show $DL_HANDLE lc 1 -j | jq -e -r ".[][][].state")
+	check_err $? "Failed to get linecard 1 state"
+
+	[ "$state" == "$expected_state_1" ]
+	check_err $? "Unexpected linecard 1 state (got $state, expected $expected_state_1)"
+}
+
+linecard_test()
+{
+	RET=0
+
+	check_linecards_state "unprovisioned" "unprovisioned"
+
+	devlink lc provision $DL_HANDLE lc 0 type card2ports
+	check_err $? "Failed to provision linecard 0 with card2ports"
+
+	check_linecards_state "provisioned" "unprovisioned"
+
+	devlink lc provision $DL_HANDLE lc 1 type card4ports
+	check_err $? "Failed to provision linecard 0 with card4ports"
+
+	check_linecards_state "provisioned" "provisioned"
+
+	echo "Y"> $DEBUGFS_DIR/linecards/0/active
+	check_err $? "Failed to set lincard 0 active"
+
+	check_linecards_state "active" "provisioned"
+
+	echo "Y"> $DEBUGFS_DIR/linecards/1/active
+	check_err $? "Failed to set lincard 1 active"
+
+	check_linecards_state "active" "active"
+
+	devlink lc unprovision $DL_HANDLE lc 0
+	check_err $? "Failed to unprovision linecard 0"
+
+	check_linecards_state "unprovisioned" "active"
+
+	devlink lc unprovision $DL_HANDLE lc 1
+	check_err $? "Failed to unprovision linecard 1"
+
+	check_linecards_state "unprovisioned" "unprovisioned"
+
+	log_test "linecard test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-	echo "$BUS_ADDR $PORT_COUNT" > /sys/bus/netdevsim/new_device
+	echo "$BUS_ADDR $PORT_COUNT $LINECARD_COUNT" > /sys/bus/netdevsim/new_device
 	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
 }
 
-- 
2.26.2

